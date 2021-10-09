this.stronghold_intro_event <- this.inherit("scripts/events/event", {
	//calls success when caravan arrives at destination, works as an event
	m = {
	},
	function create()
	{
		this.logInfo("created")
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
		
		local priceMult = this.Const.World.Stronghold.PriceMult;
		local build_cost = this.Const.World.Stronghold.BuyPrices[0] * priceMult;
		local levelOneName = this.Const.World.Stronghold.BaseNames[0]

		local hasMoney = this.World.Assets.getMoney() >= build_cost
		local isTileOccupied = this.World.State.getPlayer().getTile().IsOccupied
		local hasContract = this.World.Contracts.getActiveContract() != null
		local isCoastal = this.Stronghold.checkForCoastal(this.World.State.getPlayer().getTile())

		local moneyText = coloredText("\n10000 crowns", hasMoney)
		local tileText = coloredText("\nThe tile must be empty", !isTileOccupied)
		local contractText = coloredText("\nYou must not have an active contract", !hasContract)
		local coastalText = isCoastal ? coloredText("\n\nYou CAN build a port here.") : coloredText("\n\nYou CANNOT build a port here.", false);

		local requirementsText = "Welcome to Stronghold. Here you can see what you need to build your base. You will start with a small " + levelOneName + ", which can later be upgraded to unlock more features."
		requirementsText += format("\n\nBuilding a %s requires: ", levelOneName)
		requirementsText += moneyText + tileText + contractText
		requirementsText += (hasMoney && !isTileOccupied && !hasContract ) ? coloredText(format("\nYou CAN build a %s!", levelOneName)) : coloredText("\n\nYou CANNOT build a " + levelOneName + "!", false);

		requirementsText += coastalText
		requirementsText += format("\n\n Building a %s will unlock these features: \n%s", levelOneName, this.Const.World.Stronghold.UnlockAdvantages[0])

		requirementsText += format("\n\n Once you've built the %s, click the large fortification in the background to open the management menu. You can rename it by clicking on the name.", levelOneName)
		requirementsText += "\n\n Do you wish to proceed?"

		this.m.Screens.push({
			ID = "A",
			Text = requirementsText,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Build a "+ this.Const.World.Stronghold.BaseNames[0] + " at the current position.",
					function getResult( _event )
					{
						return "Base_Option";
					}

				},
				{
					Text = "Leave",
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
						local priceMult = this.Const.World.Stronghold.PriceMult
						local build_cost = this.Const.World.Stronghold.BuyPrices[0] * priceMult
						if (this.Stronghold.getPlayerBase() && this.Stronghold.getPlayerBase().getSize() != 3){
							build_cost = priceMult * this.Const.World.Stronghold.BuyPrices[this.Stronghold.getPlayerBase().getSize()]
						}
						//called from retinue menu
						this.World.Assets.addMoney(-build_cost);
						local tile = this.World.State.getPlayer().getTile();
						local player_faction = this.Stronghold.getPlayerFaction()
						//create new faction if it doesn't exist already
						if (!player_faction)
						{
							player_faction = this.new("scripts/factions/stronghold_player_faction");
							player_faction.setID(this.World.FactionManager.m.Factions.len());
							player_faction.setName("The " + this.World.Assets.getName());
							player_faction.setMotto("\"" + "Soldiers Live" + "\"");
							player_faction.setDescription("The only way to leave the company is feet first.");
							player_faction.m.Banner = this.World.Assets.getBannerID()
							player_faction.setDiscovered(true);
							player_faction.m.PlayerRelation = 100;		
							player_faction.updatePlayerRelation()
							this.World.FactionManager.m.Factions.push(player_faction);
							player_faction.onUpdateRoster();
							this.World.createRoster(9999)
						}
						
						local player_base = this.World.spawnLocation("scripts/entity/world/settlements/stronghold_player_base", tile.Coords);
						player_base.getFlags().set("isPlayerBase", true);
						player_base.updateProperties()
						player_faction.addSettlement(player_base);
						player_base.setUpgrading(true);
						player_base.m.Flags.set("LevelOne", true)
						player_base.updateTown();
						
						tile.IsOccupied = true;
						tile.TacticalType = this.Const.World.TerrainTacticalType.Urban;
						//spawn assailant quest
						local contract = this.new("scripts/contracts/contracts/stronghold_defeat_assailant_contract");
						contract.setEmployerID(player_faction.getRandomCharacter().getID());
						contract.setFaction(player_faction.getID());
						contract.setHome(player_base);
						contract.setOrigin(player_base);
						contract.m.TargetLevel = 1
						this.World.Contracts.addContract(contract);
						contract.start();
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

