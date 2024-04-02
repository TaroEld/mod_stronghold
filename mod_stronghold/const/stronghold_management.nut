::Stronghold.Main_Management_Options <-
[
	{
		Text = function(){
			return format("Upgrade your %s", this.getHome().getSizeName())
		}
		ID = "Upgrade",
		isValid = function(_contract){
			return _contract.isMainBase() && _contract.getHome().getSize() < this.Stronghold.MAX_BASE_SIZE && !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			if (this.World.Contracts.getActiveContract() != null)
			{
				this.m.Screens.push
				({
					ID = "Upgrade_Contract_Active",
					Title = "Requirements not met",
					Text = "You can't upgrade your base while having an active contract!",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [this.addGenericOption("Alright.")]
				})
				return "Upgrade_Contract_Active";
			}
			if (this.World.Retinue.getInventoryUpgrades() < this.getHome().getSize() + 1)
			{
				local current = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades()]
				local next = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades() + 1]
				this.m.Screens.push
				({
					ID = "Upgrade_Contract_Active",
					Title = "Requirements not met",
					Text = format("You need to level up your %s to a %s before you can upgrade your %s!", current, next, this.getHome().getSizeName()),
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [this.addGenericOption("Alright.")]
				})
				return "Upgrade_Contract_Active";
			}
			local advantages = this.Stronghold.BaseTiers[this.getHome().getSize()].UnlockDescription;
			this.setCost(this.Stronghold.Misc.PriceMult * this.Stronghold.BaseTiers[this.getHome().getSize() + 1].Price)
			local text =  "You can upgrade your " + this.getHome().getSizeName() + " to a " + this.getHome().getSizeName(true) + ". This would add these options: \n" + advantages +"\nThis costs " + this.getCost() + " crowns.\nWhile upgrading, you won't be able to access most of the management options. \n\nCAREFUL: The closest nobles or enemies will attempt to destroy your base. Defend it!"
			this.addOverviewScreen(
				format("Upgrade your %s", this.getHome().getSizeName()),
				text
			)
			this.addEnoughScreen(
				"Upgrading in progress", 
				format("You started upgrading your %s to a %s", this.getHome().getSizeName(), this.getHome().getSizeName(true)),
				this.onUpgradeBought
			)
			return "Overview_Building"
		}
	},
	{
		Text = function(){
			return format("Add a building to your %s", this.getHome().getSizeName())
		},
		ID = "Building",
		isValid = function(_contract){
			local current_buildings = 0;
			local free_building_slots = _contract.getHome().getSize() + 4
			foreach (building in _contract.getHome().m.Buildings){
				if (building != null){
					current_buildings++
				}
			}
			return current_buildings < free_building_slots && !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			//market and management are by default
			local current_buildings = -2;
			local total_building_slots = this.getHome().getSize() + 2
			foreach (building in this.getHome().m.Buildings){
				if (building != null){
					current_buildings++
				}
			}
			local text = format("You can construct a new building for your %s. These are your available options.", this.getHome().getSizeName())
			text += format("\nYour buildings occupy %i out of %i spots in your %s.", current_buildings, total_building_slots, this.getHome().getSizeName())
			if (this.getHome().getSize() < 3) text += format("\nUpgrade your %s to unlock more slots.", this.getHome().getSizeName())
			this.m.Screens.push
			({
				ID = "Building_Choice",
				Title = "Choose a building",
				Text = text,
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getBuildingOptions()
			})
			return "Building_Choice"
		}
	},
	{

		Text = function(){
			return format("Remove a building from your %s", this.getHome().getSizeName())
		}
		ID = "Building_Remove",
		isValid = function(_contract){
			local current_buildings = 0;
			local free_building_slots = _contract.getHome().getSize() + 4
			foreach (building in _contract.getHome().m.Buildings){
				if (building != null){
					current_buildings++
				}	
			}
			return current_buildings >= free_building_slots && !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			this.m.Screens.push
			({
				ID = "Building_Remove_Choice",
				Title = "Choose a building",
				Text = "You can choose to demolish a building. This makes room to construct another in its place.",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getBuildingRemoveOptions()
			})
			return "Building_Remove_Choice"	
		}
	},
	{
		Text = function(){
			return format("Add a location to your %s", this.getHome().getSizeName())
		},
		ID = "Location",
		isValid = function(_contract){
			local current_locations = 0;
			foreach (location in _contract.getHome().m.AttachedLocations){
				if (location != null && location.m.ID != "attached_location.harbor"){
					current_locations++
				}
			}
			return _contract.isMainBase() && current_locations < _contract.getHome().m.AttachedLocationsMax && !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			local current_buildings = 0;
			local total_building_slots = this.getHome().m.AttachedLocationsMax 
			foreach (location in this.getHome().m.AttachedLocations){
				if (location != null && location.m.ID != "attached_location.harbor"){
					current_buildings++
				}
			}
			local text = format("You can construct a new location close to your %s. This can provide various benefits.", this.getHome().getSizeName())
			text += format("\nYour locations occupy %i out of %i spots of your %s.", current_buildings, total_building_slots, this.getHome().getSizeName())
			if (this.getHome().getSize() < 3) text += format("\nUpgrade your %s to unlock more slots.", this.getHome().getSizeName())

			this.m.Screens.push
			({
				ID = "Location_Choice",
				Title = "Choose a location",
				Text = text,
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getLocationOptions()
			})
			return "Location_Choice"
		}
	},
	{
		Text = function(){
			return "Build a road to another settlement."
		},
		ID = "Road",
		isValid = function(_contract){
			return _contract.isMainBase() && _contract.getHome().m.Size > 1 && !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			this.m.Screens.push
			({
				ID = "Road_Choice",
				Title = "Choose a destination",
				Text = "You can build a road to another settlement. This allows wares and patrols to flow hither and thither, should the other factions like you. \nWhere to you want your road to lead to?",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getRoadOptions()
			})
			return "Road_Choice"
		}
	},
	{
		Text = function(){
			return "Buy a Water Skin."
			},
		ID = "Waterskin",
		isValid = function(_contract){
			return _contract.isMainBase() && _contract.getHome().isMaxLevel()
		},
		onChosen = function(){
			if (!this.Stronghold.getPlayerFaction().m.Flags.get("Waterskin"))
			{
				this.m.Screens.push
				({
					ID = "Waterskin",
					Title = "Requirements not met",
					Text = "You ask the learned men if they could craft you a mythical Water of Life. Unfortunately, the recipe has been lost to time. Perhaps you can recover it.",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [this.addGenericOption("Alright.")]
				})
				return "Waterskin";
			}
			else
			{
				this.setCost(20 * this.Stronghold.Misc.PriceMult)
				this.addOverviewScreen(
					"Buy Water Skin",
					format("You choose to buy a Water Skin. This will cost %i crowns.", this.getCost())
				)
				this.addEnoughScreen(
					"Buy Water Skin",
					"You bought a Water Skin.",
					this.onWaterSkinBought
				)
				
				this.m.Screens.push
				({
					ID = "Enough",
					Title = this.m.Title,
					Text = "You bought a Water Skin.",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [
						{
							Text = "Good.",
							function getResult(_option)
							{
								this.World.Assets.getStash().makeEmptySlots(1);
								this.World.Assets.addMoney(-this.Contract.getCost());
								local item = this.new("scripts/items/special/fountain_of_youth_item");
								this.World.Assets.getStash().add(item);
								this.Contract.removeThisContract()
								return 0;
							}

						}
					],
					function start()
					{
						this.List.push({
							id = 10,
							icon = "ui/items/consumables/youth_01.png",
							text = "You lose " +this.Contract.getCost() + " crowns."
						});
					}
				})
				return "Overview_Building"
			}
		}
	},
	{
		Text = function(){
			return "Hire mercenaries."
			},
		ID = "Mercenaries",
		isValid = function(_contract){
			return _contract.isMainBase() && _contract.getHome().isMaxLevel()
		},
		onChosen = function(){
			local has_mercs = false
			foreach ( unit in this.Stronghold.getPlayerFaction().m.Units){
				if (unit.getFlags().get("Stronghold_Mercenaries")){
					has_mercs = true
				}
			}
			if (!this.Stronghold.getPlayerFaction().m.Flags.get("Mercenaries"))
			{
				this.m.Screens.push
				({
					ID = "Mercs_Not_Freed",
					Title = "Requirements not met",
					Text = "There are no mercenary companies available for hire.",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [this.addGenericOption("Alright.")]
				})
				return "Mercs_Not_Freed";
			}
			else if (has_mercs)
			{
				this.m.Screens.push
				({
					ID = "Mercs_Already_Hired",
					Title = "Requirements not met",
					Text = "You cannot employ two mercenary bands at the same time.",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [this.addGenericOption("Alright.")]
				})
				return "Mercs_Already_Hired";
			}
			else
			{
				this.setCost(20 * this.Stronghold.Misc.PriceMult)
				this.addOverviewScreen(
					"Hire mercenaries",
					format("You can hire a group of local mercenaries to follow you on your travels. They demand %i crowns for one week of their time.", this.getCost())
				)
				this.addEnoughScreen(
					"Hire mercenaries",
					"You hired a group of mercenaries.",
					this.onMercenariesHired
				)
				return "Overview_Building"
			}
		}
	},
	{
		Text = function(){
			return "Provide focused training to one of your recruits"
			},
		ID = "Teacher",
		isValid = function(_contract){
			return _contract.isMainBase() && _contract.getHome().isMaxLevel()
		},
		onChosen = function(){
			this.setCost(10 * this.Stronghold.Misc.PriceMult);
			if (!this.Stronghold.getPlayerFaction().m.Flags.get("Teacher"))
			{
				this.m.Screens.push
				({
					ID = "Teacher_Not_Freed",
					Title = "Requirements not met",
					Text = "Nobody here can provide training beyond the services of a Training Hall.",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [this.addGenericOption("Alright.")]
				})
				return "Teacher_Not_Freed";
			}
			else {
				local text = format("The legendary swordmaster spends his days honing his skills. He can give one of your brothers an intensive lesson- for a considerable fee of %i crowns. Choose a brother to receive focused training by the swordmaster.", this.getCost())
				text += "\n\n[b]1.5x combat experience for the next 10 fights.[/b]"
				text += "\n[i]The chosen brother will lose any training hall buffs.[/i]"
			    this.m.Screens.push
				({
					ID = "Teacher_Choice",
					Title = "Train a brother",
					Text = text,
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = this.getTrainerOptions()
				})	
				return "Teacher_Choice"
			}	
		}
	},
	{
		Text = function(){
			return "Send gifts to a faction"
			},
		ID = "Gift",
		isValid = function(_contract){
			return _contract.isMainBase() && _contract.getHome().isMaxLevel()
		},
		onChosen = function(){
			local isValid = this.isGiftValid(true)
			if (isValid[0])
			{
				local text = "You can choose to send gifts to a faction. This will consume the treasures you have in your inventory, and will increase relations with that faction depending on the value of the gifts. The caravan will demand 5000 crowns to transport the goods."
				text += "\n [i]This will spawn a caravan that moves to the destination. If it is destroyed, you lose your investment.[/i]"
				text += "\n\n [i]Gain relation equal to 5% of the value of the treasures with the target faction.[/i]"
				text += "\n [i]Treasures are gained from camps and events, for example a Signet Ring.[/i]"
				
				this.m.Screens.push
				({
					ID = "Send_Gift",
					Title = "Send gifts to a faction",
					Text = text,
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = this.getGiftOptions()
				})
				return "Send_Gift"
			}
			else
			{
				local text = "You can choose to send gifts to a faction. This will consume the treasures you have in your inventory, and will increase relations with that faction depending on the value of the gifts. The caravan will demand 5000 crowns to transport the goods.\n\n"
				if (!isValid[1]) text += "You need at least 5000 crowns to send a gift!\n"
				if (!isValid[2]) text += "You need at least 2 treasures in your inventory or warehouse to send a gift!\n"
				if (!isValid[3]) text += "You can't reach anyone by road or you are already friends with all factions!\n"
				this.m.Screens.push
				({
					ID = "Send_Gift_Failed",
					Title = "Requirements not met",
					Text = text,
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [this.addGenericOption("Alright.")]
				})
				return "Send_Gift_Failed";
			}
		}
	},
	{
		Text = function(){
			return "Leave a brother behind"
			},
		ID = "Store_Brother",
		isValid = function(_contract){
			if (!_contract.isMainBase()) return false
			local playerRoster = this.World.getPlayerRoster().getAll()
			return (playerRoster != null && playerRoster.len() > 1)
		},
		onChosen = function(){
			this.m.Screens.push
			({
				ID = "Store_Brother",
				Title = format("Leave a brother at your %s", this.getHome().getSizeName()),
				Text = "Which brother would you like to leave behind?\nStored brothers draw half their wage while they wait for your return.",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getStoreBrotherOptions()
			})
			return "Store_Brother";
		}
	},			
	{
		Text = function(){
			return "Retrieve a brother"
			},
		ID = "Retrieve_Brother",
		isValid = function(_contract){
			if (!_contract.isMainBase()) return false
			local playerRoster = _contract.getHome().getLocalRoster().getAll()
			return (playerRoster != null && playerRoster.len() > 0)
		},
		onChosen = function(){
			this.m.Screens.push
			({
				ID = "Retrieve_Brother",
				Title = "Retrieve a brother",
				Text = "Which brother would you like to retrieve?",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getRetrieveBrotherOptions()
			})
			return "Retrieve_Brother";
		}
	},			
	{
		Text = function(){
			return "Build a Hamlet"
			},
		ID = "Hamlet",
		isValid = function(_contract){
			return (_contract.isMainBase() && _contract.getHome().isMaxLevel() && !_contract.getHome().getFlags().get("Child"))
		},
		onChosen = function(){
			this.setCost(20 * this.Stronghold.Misc.PriceMult);
			this.addOverviewScreen(
				"Build a Hamlet",
				format("Your Stronghold has grown large enough that many common people flock to it. It would be wise to construct a hamlet for these people to live at. This would cost %i crowns.", this.getCost())
			)
			this.addEnoughScreen(
				"Build a Hamlet",
				"You built a Hamlet.",
				this.onHamletBuild
			)
			return "Overview_Building"
		}
	},
	{
		Text = function(){
			return "Change look"
			},
		ID = "Visual",
		isValid = function(_contract){
			//return _contract.isMainBase()
			return false
		},
		onChosen = function(){
			this.m.Screens.push
			({
				ID = "Change_Style",
				Title = "Change base look",
				Text = "Which look do you want?",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getBaseSyleOptions()
			})
			return "Change_Style";
		}
	},
	{
		Text = function(){
			return format("Remove your %s", this.getHome().getSizeName())
			},
		ID = "Remove_Base",
		isValid = function(_contract){
			return !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			this.addOverviewScreen(
				"Remove your base",
				format("FINAL WARNING! Are you really sure you want to remove your %s?", this.getHome().getSizeName())
			)
			if(this.World.Contracts.getActiveContract() != null)
			{
				this.m.Screens.push
				({
					ID = "Enough",
					Title = this.m.Title,
					Text = format("You can't remove your %s while having an active contract!", this.getHome().getSizeName()),
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [
						this.addGenericOption("Alright.")
					],
					function start()
					{
					}
				})
			}
			else 
			{
				this.addEnoughScreen(
					"Remove your base",
					format("You removed your %s.", this.getHome().getSizeName()),
					this.onRemoveBase
				)
			}
			return "Overview_Building"
		}
	},
]
