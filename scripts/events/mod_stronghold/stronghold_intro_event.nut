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
		
		local priceMult = this.Stronghold.PriceMult;
		local build_cost = this.Stronghold.BuyPrices[0] * priceMult;
		local levelOneName = this.Stronghold.BaseNames[0]

		local hasInventoryUpgrade = this.World.Retinue.getInventoryUpgrades() > 0
		local hasMoney = this.World.Assets.getMoney() >= build_cost
		local isTileOccupied = this.World.State.getPlayer().getTile().IsOccupied
		local hasContract = this.World.Contracts.getActiveContract() != null
		local isCoastal = ::Stronghold.IsCoastal(this.World.State.getPlayer().getTile());
		local hasRenown = this.World.Assets.getBusinessReputation() > 500;

		local isValid = hasRenown && hasInventoryUpgrade && hasMoney && !isTileOccupied && !hasContract

		local inventoryText = coloredText("\n-Upgrading your donkey to a cart.", hasInventoryUpgrade)
		local renownText = coloredText("\n-Having over 500 renown.", hasRenown)
		local moneyText = coloredText("\n-Having 10000 crowns.", hasMoney)
		local tileText = coloredText("\n-Standing on an empty tile.", !isTileOccupied)
		local contractText = coloredText("\n-Not having an active contract.", !hasContract)
		local coastalText = isCoastal ? coloredText("you will be able to build a port here.") : coloredText("you won't be able to build a port here, as you're not close enough to the sea.", false);

		local requirementsText = "Welcome to Stronghold. Here you can see what you need to build your base. You will start with a small " + levelOneName + ", which can later be upgraded to unlock more features."
		requirementsText += format("\n\nBuilding a %s requires: ", levelOneName)
		requirementsText += renownText + inventoryText + moneyText + tileText + contractText


		requirementsText += format("\n\n Building a %s will unlock these features: \n%s", levelOneName, this.Stronghold.UnlockAdvantages[0])
		requirementsText += format("\n\n Also, you %s", coastalText)

		requirementsText += format("\n\n Once you've built the %s, click the large fortification in the background to open the management menu. You can rename it by clicking on the name.", levelOneName)

		local A_options;
		if (isValid){
			requirementsText += coloredText(format("\n\nYou CAN build a %s!", levelOneName)) + " Do you wish to proceed?"
		 	A_options = 
		 	[{
				Text = "Yes, build a "+ this.Stronghold.BaseNames[0] + " here",
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
			requirementsText += coloredText("\n\nYou CANNOT build a " + levelOneName + "!", false) + " Return when you have fulfilled all the requirements."
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

