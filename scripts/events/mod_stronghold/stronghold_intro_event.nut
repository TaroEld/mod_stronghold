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
		local isCoastal = this.Stronghold.isOnTile(this.World.State.getPlayer().getTile(), [this.Const.World.TerrainType.Ocean, this.Const.World.TerrainType.Shore]);
		local hasRenown = this.World.Assets.getBusinessReputation() > renownCost;

		local isValid = hasRenown && hasMoney && !isTileOccupied && !hasContract;

		local renownText = coloredText(format("\n-Having at least %s renown (currently: %s).", renownCost.tostring(), this.World.Assets.getBusinessReputation().tostring()), hasRenown);
		local moneyText = coloredText(format("\n-Price: %s crowns."), buildPrice.tostring(), hasMoney);
		local tileText = coloredText("\n-Standing on an empty tile.", !isTileOccupied);
		local contractText = coloredText("\n-Not having an active contract.", !hasContract);
		local coastalText = isCoastal ? coloredText("you will be able to build a port here.") : coloredText("you won't be able to build a port here, as you're not close enough to the sea.", false);

		local requirementsText = "Welcome to Stronghold. Here you can see what you need to build your base. You will start with a small " + name + ", which can later be upgraded to unlock more features.";
		requirementsText += format("\n\nBuilding a %s requires: ", name);
		requirementsText += renownText + inventoryText + moneyText + tileText + contractText;


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

