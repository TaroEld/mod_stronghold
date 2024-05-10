this.stronghold_intro_event <- this.inherit("scripts/events/event", {
	//calls success when caravan arrives at destination, works as an event
	m = {
	},
	function create()
	{
		this.m.ID = "event.stronghold_intro";
		this.m.Title = "Stronghold";
		this.m.IsSpecial = true;
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		local function coloredText(_text, _condition = true){
			if (_condition){
				return  "[color=" + this.Const.UI.Color.PositiveEventValue + "]" + _text + "[/color]"
			}
			return  "[color=" + this.Const.UI.Color.NegativeEventValue + "]" + _text + "[/color]"
		}
		
		local priceMult = this.Stronghold.Misc.PriceMult;
		local tier = this.Stronghold.BaseTiers[1];
		local buildPrice = tier.Price * priceMult;
		local renownCost = ::Stronghold.getNextRenownCost();
		local name = tier.Name;

		local hasMoney = this.World.Assets.getMoney() >= buildPrice;
		local isTileOccupied = this.World.State.getPlayer().getTile().IsOccupied;
		local hasContract = this.World.Contracts.getActiveContract() != null;
		local isCoastal = this.isCoastal(this.World.State.getPlayer().getTile());
		local hasRenown = this.World.Assets.getBusinessReputation() > renownCost;

		local isValid = hasRenown && hasMoney && !isTileOccupied && !hasContract;

		local renownText = coloredText(format("\n-Having at least %s renown (currently: %s).", renownCost.tostring(), this.World.Assets.getBusinessReputation().tostring()), hasRenown);
		local moneyText = coloredText(format("\n-Price: %s crowns.", buildPrice.tostring()), hasMoney);
		local tileText = coloredText("\n-Standing on an empty tile.", !isTileOccupied);
		local contractText = coloredText("\n-Not having an active contract.", !hasContract);
		local coastalText = isCoastal ? coloredText("you will be able to build a port here.") : coloredText("you won't be able to build a port here, as you're not close enough to the sea.", false);

		local requirementsText = "Welcome to Stronghold. Here you can see what you need to build your base. You will start with a small " + name + ", which can later be upgraded to unlock more features.";
		requirementsText += format("\n\nBuilding a %s requires: ", name);
		requirementsText += renownText + moneyText + tileText + contractText;


		requirementsText += format("\n\n Building a %s will unlock these features: \n%s", name, tier.UnlockDescription);
		requirementsText += format("\n\n Also, you %s", coastalText);

		requirementsText += format("\n\n Once you've built the %s, click the large fortification in the background to open the management menu.", name);

		local A_options;
		if (isValid){
			requirementsText += coloredText(format("\n\nYou can build a %s!", name)) + " Do you wish to proceed?"
		 	A_options = 
		 	[{
				Text = format("Yes, build a %s here", name),
				function getResult( _event )
				{
					return "Base_Option";
				}

			},
			{
				Text = "No",
				function getResult( _event )
				{
					_event.removeEvent()
					return 0;
				}

			}]
		}
		else{
			requirementsText += coloredText("\n\nYou cannot build a " + name + "!", false) + " Return when you have fulfilled all the requirements."
	 	 	A_options = 
	 	 	[{
 				Text = "Alright.",
 				function getResult( _event )
 				{
 					_event.removeEvent()
 					return 0;
 				}
	 		}]
		}
		this.m.Screens.push({
			ID = "A",
			Text = requirementsText,
			Image = "",
			List = [],
			Characters = [],
			Options = A_options,
			function start( _event )
			{
			}
		});

		this.m.Screens.push({
			ID = "Base_Option",
			Text = "Are you sure? You will need a strong company to repel attackers.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yes",
					function getResult( _event )
					{
						this.Stronghold.buildMainBase()
						_event.removeEvent()
						return 0
					}

				},
				{
					Text = "No",
					function getResult( _event )
					{
						_event.removeEvent()
						return 0;
					}

				}
			],
			function start( _event )
			{
			}
 
		});
	}

	function isCoastal (_tile)
	{
		local mapSize = this.World.getMapSize();
		local isCoastal = false;
		local deepOceanTile = null;

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else if (_tile.getNextTile(i).Type == this.Const.World.TerrainType.Ocean || _tile.getNextTile(i).Type == this.Const.World.TerrainType.Shore)
			{
				isCoastal = true;
				break;
			}
		}

		if (isCoastal)
		{
			if (deepOceanTile == null)
			{
				deepOceanTile = this.findAccessibleOceanEdge(_tile, 0, mapSize.X, 0, 1);
			}

			if (deepOceanTile == null)
			{
				deepOceanTile = this.findAccessibleOceanEdge(_tile, 0, 1, 0, mapSize.Y);
			}

			if (deepOceanTile == null)
			{
				deepOceanTile = this.findAccessibleOceanEdge(_tile, mapSize.X - 1, mapSize.X, 0, mapSize.Y);
			}

			if (deepOceanTile == null)
			{
				deepOceanTile = this.findAccessibleOceanEdge(_tile, 0, mapSize.X, mapSize.Y - 1, mapSize.Y);
			}

			if (deepOceanTile == null)
			{
				isCoastal = false;
			}
		}
		return isCoastal;
	}

	function findAccessibleOceanEdge(_tile, _minX, _maxX, _minY, _maxY )
	{
		local myTile = _tile;
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Ship;
		local tiles = [];

		for( local x = _minX; x < _maxX; x = ++x )
		{
			for( local y = _minY; y < _maxY; y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type != this.Const.World.TerrainType.Ocean || tile.IsOccupied)
					{
					}
					else
					{
						local isDeepSea = true;

						for( local i = 0; i != 6; i = ++i )
						{
							if (tile.hasNextTile(i) && tile.getNextTile(i).Type != this.Const.World.TerrainType.Ocean)
							{
								isDeepSea = false;
								break;
							}
						}

						if (!isDeepSea)
						{
						}
						else
						{
							tiles.push(tile);
						}
					}
				}
			}
		}

		while (tiles.len() != 0)
		{
			local idx = this.Math.rand(0, tiles.len() - 1);
			local tile = tiles[idx];
			tiles.remove(idx);
			local path = this.World.getNavigator().findPath(myTile, tile, navSettings, 0);

			if (!path.isEmpty())
			{
				return tile;
			}
		}

		return null;
	}
	
	function onPrepare()
	{
	}
	function onUpdateScore()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function removeEvent()
	{
		local idx = 0
		foreach (event in this.World.Events.m.Events){
			if (event.getID() == this.getID()){
				this.World.Events.m.Events.remove(idx)
				return
			}
			idx++
		}
	}

});

