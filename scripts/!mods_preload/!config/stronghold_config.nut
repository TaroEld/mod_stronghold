local gt = this.getroottable();
gt.Const.World.Stronghold <- {};
gt.Const.World.Stronghold.MaxMenuOptionsLen <- 9; // max length of menu options, limitation of the text window size. got it at 11 so leave 2 spaces for 'back' etc
gt.Const.World.Stronghold.PriceMult <- 1000; //fastest way to change prices, everything gets mult by this
gt.Const.World.Stronghold.BuyPrices <- [10, 20, 20]; //base prices for build/upgrade
gt.Const.World.Stronghold.MaxAttachments <- [3, 6, 9]; //base prices for build/upgrade
gt.Const.World.Stronghold.MaxStrongholdNumber <- 999;

gt.Const.World.Stronghold.UnlockAdvantages <-[
	"You can leave items and brothers behind, to retrieve them later as you need them.\n You can construct up to three settlement buildings.\nYou can construct up to three locations, granting various advantages.\n You will be able to upgrade your base, unlocking more features.",
	"Bands of mercenaries will join your base and guard it against aggressors.\nYou can construct an additional building and three additional locations.\nYou can construct roads to other settlements, connecting your base to the world.",
	"You can construct an additional building, including an arena, and three additional locations.\nA number of unique contracts will be made available.\nYou can now construct the Hamlet, a town which is connected to your Stronghold."
]
gt.Const.World.Stronghold.RoadCost <- 0.5; // per segment
gt.Const.World.Stronghold.BaseNames <- [
"Fort",
"Castle",
"Stronghold"]

gt.Const.World.Stronghold.HamletName <- "Hamlet" 
gt.Const.World.Stronghold.PlayerBaseSprites <- ["world_stronghold_01", "world_stronghold_02", "world_stronghold_03"]
gt.Const.World.Stronghold.PlayerBaseSpritesUpgrading  <- ["world_stronghold_01", "world_stronghold_02", "world_stronghold_03"]
gt.Const.World.Stronghold.PlayerFactionActions <- [
"scripts/factions/actions/stronghold_guard_base_action", 
"scripts/factions/actions/stronghold_send_caravan_action", 
"scripts/factions/actions/stronghold_patrol_roads_action"];


gt.Const.World.Stronghold.BuildingPrices <- 
{
	Tavern = 5,
	Kennel = 5,
	Taxidermist = 5,
	Temple = 5, 
	Training = 5,
	Alchemist = 5,
	Weaponsmith = 10,
	Armorsmith = 10,
	Fletcher = 10,
	Port = 15,
	Arena = 20
};
gt.Const.World.Stronghold.LocationPrices <-
{
	Workshop = 10,
	Ore = 10,
	Blast = 10,
	Stone = 10,
	Militia = 10,
	Wheat = 10,
	Herbalists = 10,
	Gold = 10
};
gt.Const.World.Stronghold.WellSupplied <-
[
	{
		Rarity = 1.04,
		BuyPrice = 1.00,
		SellPrice = 1.00
	},
	{
		Rarity = 1.08,
		BuyPrice = 0.95,
		SellPrice = 1.05
	},
	{
		Rarity = 1.12,
		BuyPrice = 0.9,
		SellPrice = 1.1
	}
]

gt.Const.World.Stronghold.FullDraftList <-
[
	"adventurous_noble_background" ,
	"apprentice_background" ,
	"bastard_background" ,
	"beast_hunter_background" ,
	"beggar_background" ,
	"bowyer_background" ,
	"brawler_background" ,
	"butcher_background" ,
	"caravan_hand_background" ,
	"cultist_background" ,
	"daytaler_background" ,
	"deserter_background" ,
	"disowned_noble_background" ,
	"farmhand_background" ,
	"fisherman_background" ,
	"flagellant_background" ,
	"gambler_background" ,
	"gladiator_background" ,
	"gravedigger_background" ,
	"hedge_knight_background" ,
	"historian_background" ,
	"houndmaster_background" ,
	"hunter_background" ,
	"juggler_background" ,
	"killer_on_the_run_background" ,
	"lumberjack_background" ,
	"manhunter_background" ,
	"mason_background" ,
	"messenger_background" ,
	"militia_background" ,
	"miller_background" ,
	"miner_background" ,
	"minstrel_background" ,
	"monk_background" ,
	"nomad_background" ,
	"peddler_background" ,
	"poacher_background" ,
	"raider_background" ,
	"ratcatcher_background" ,
	"retired_soldier_background" ,
	"sellsword_background" ,
	"servant_background" ,
	"shepherd_background" ,
	"squire_background" ,
	"swordmaster_background" ,
	"tailor_background" ,
	"thief_background" ,
	"vagabond_background" ,
	"wildman_background" ,
	"witchhunter_background"
]
//main options
//to add one, you need a title = Text, as a function, optionally an isValid function, and an onChosen function that pushes a screen and grabs the options
// here, you also add the overview and enough screens in most cases. The latter calls the function that effects the management option
//if single choice, return "Overview_Building", otherwise return the ID of the screen you pushed, such as "Building_Choice"
//generally also setCost here
gt.Const.World.Stronghold.Main_Management_Options <-
[
	{
		Text = function(){
			return format("Upgrade your %s", this.getHome().getSizeName())
		}
		ID = "Upgrade",
		isValid = function(_contract){
			return _contract.isMainBase() && _contract.getHome().getSize() < 3 && !_contract.getHome().isUpgrading()
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
			local advantages = this.Const.World.Stronghold.UnlockAdvantages[this.getHome().getSize()]
			this.setCost(this.Const.World.Stronghold.PriceMult * this.Const.World.Stronghold.BuyPrices[this.getHome().getSize()])
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
			return _contract.isMainBase() && current_locations < _contract.getHome().m.AttachedLocationsMax && !_contract.getHome().m.Flags.get("AllLocationsBuilt") && !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			local current_buildings = 0;
			local total_building_slots = this.getHome().m.AttachedLocationsMax 
			foreach (location in this.getHome().m.AttachedLocations){
				if (location != null && location.m.ID != "attached_location.harbor"){
					current_buildings++
				}
			}
			local text = format("You can construct a new location close to your %s. This can provide various benefits. Each costs 10000 crowns.", this.getHome().getSizeName())
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
			return _contract.isMainBase() && _contract.getHome().m.Size == 3 && !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			if (!this.getHome().m.Flags.get("Waterskin"))
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
				this.setCost(20 * this.Const.World.Stronghold.PriceMult)
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
			return _contract.isMainBase() && _contract.getHome().m.Size == 3
		},
		onChosen = function(){
			local has_mercs = false
			foreach ( unit in this.Stronghold.getPlayerFaction().m.Units){
				if (unit.getFlags().get("Stronghold_Mercenaries")){
					has_mercs = true
				}
			}
			if (!this.getHome().m.Flags.get("Mercenaries"))
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
				this.setCost(20 * this.Const.World.Stronghold.PriceMult)
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
			return _contract.isMainBase() && _contract.getHome().m.Size == 3 && !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			this.setCost(10 * this.Const.World.Stronghold.PriceMult);
			if (!this.getHome().m.Flags.get("Teacher"))
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
			return _contract.isMainBase() && _contract.getHome().m.Size > 1 && !_contract.getHome().isUpgrading()
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
				if (!isValid[2]) text += "You need at least 2 treasures in your inventory or storage to send a gift!\n"
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
			local playerRoster = this.World.getPlayerRoster().getAll()
			return (_contract.isMainBase() && playerRoster != null && playerRoster.len() > 1)
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
			local playerRoster = this.World.getRoster(9999).getAll()
			return (_contract.isMainBase() && playerRoster != null && playerRoster.len() > 0)
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
			return (_contract.isMainBase() && _contract.getHome().m.Size == 3 && !this.Stronghold.getPlayerFaction().getFlags().get("BuildHamlet")) && !_contract.getHome().isUpgrading()
		},
		onChosen = function(){
			this.setCost(20 * this.Const.World.Stronghold.PriceMult);
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
gt.Const.World.Stronghold.Building_options <-
[
	{
		Name = "Tavern",
		ID = "building.tavern",
		Cost = this.Const.World.Stronghold.BuildingPrices["Tavern"],
		Path = "tavern_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Kennel",
		ID = "building.kennel",
		Cost = this.Const.World.Stronghold.BuildingPrices["Kennel"],
		Path = "kennel_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Taxidermist",
		ID = "building.taxidermist",
		SouthID = "building.taxidermist_oriental",
		Cost = this.Const.World.Stronghold.BuildingPrices["Taxidermist"],
		Path = "taxidermist_building",
		SouthPath = "taxidermist_oriental_building",
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && !(_contract.getHome().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Temple",
		ID = "building.temple",
		SouthID = "building.temple",
		Cost = this.Const.World.Stronghold.BuildingPrices["Temple"],
		Path = "temple_building",
		SouthPath = "temple_oriental_building",
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && !(_contract.getHome().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Training Hall",
		ID = "building.training_hall",
		Cost = this.Const.World.Stronghold.BuildingPrices["Training"],
		Path = "training_hall_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Alchemist",
		ID = "building.alchemist",
		Cost = this.Const.World.Stronghold.BuildingPrices["Alchemist"],
		Path = "alchemist_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Weaponsmith",
		ID = "building.weaponsmith",
		SouthID = "building.weaponsmith_oriental",
		Cost = this.Const.World.Stronghold.BuildingPrices["Weaponsmith"],
		Path = "weaponsmith_building",
		SouthPath = "weaponsmith_oriental_building",
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && !(_contract.getHome().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Armorsmith",
		ID = "building.armorsmith",
		SouthID = "building.armorsmith_oriental",
		Cost = this.Const.World.Stronghold.BuildingPrices["Armorsmith"],
		Path = "armorsmith_building",
		SouthPath = "armorsmith_oriental_building",
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && !(_contract.getHome().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Fletcher",
		ID = "building.fletcher",
		Cost = this.Const.World.Stronghold.BuildingPrices["Fletcher"],
		Path = "fletcher_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Port",
		ID = "building.port",
		Cost = this.Const.World.Stronghold.BuildingPrices["Port"],
		Path = "port_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && _contract.getHome().isCoastal())
		}
	},
	{
		Name = "Arena",
		ID = "building.arena",
		Cost = this.Const.World.Stronghold.BuildingPrices["Arena"],
		Path = "arena_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && _contract.getHome().m.Size == 3)
		}
	},
],
gt.Const.World.Stronghold.Location_options <-
[
	{
		Name = "Workshop",
		ID = "attached_location.workshop",
		Cost = this.Const.World.Stronghold.LocationPrices["Workshop"],
		Path = "workshop_location",
		Text= "Build a workshop. Generates tools.",
		isValid = function(_contract){
			return (!_contract.getHome().hasAttachedLocation(this.ID))
		}
	},
	{
		Name = "Ore Smelter",
		ID = "attached_location.ore_smelters",
		Cost = this.Const.World.Stronghold.LocationPrices["Ore"],
		Path = "ore_smelters_location",
		Text= "Build an ore smelter. Weaponsmiths carry more items.",
		isValid = function(_contract){
			return (!_contract.getHome().hasAttachedLocation(this.ID))
		}
	},
	{
		Name = "Blast Furnace",
		ID = "attached_location.blast_furnace",
		Cost = this.Const.World.Stronghold.LocationPrices["Blast"],
		Path = "blast_furnace_location",
		Text= "Build a blast furnace. Armourers carry more items.",
		isValid = function(_contract){
			return (!_contract.getHome().hasAttachedLocation(this.ID))
		}
	},
	{
		Name = "Stone Watchtower",
		ID = "attached_location.stone_watchtower",
		Cost = this.Const.World.Stronghold.LocationPrices["Stone"],
		Path = "stone_watchtower_location",
		Text= "Build a watchtower. Increases movement speed and sight range around the stronghold.",
		isValid = function(_contract){
			return (!_contract.getHome().hasAttachedLocation(this.ID))
		}
	},
	{
		Name = "Militia Trainingcamp",
		ID = "attached_location.militia_trainingcamp",
		Cost = this.Const.World.Stronghold.LocationPrices["Militia"],
		Path = "militia_trainingcamp_location",
		Text= "Build a militia camp. Increases strength of mercenaries and number of recruits in the hamlet.",
		isValid = function(_contract){
			return (!_contract.getHome().hasAttachedLocation(this.ID))
		}
	},
	{
		Name = "Wheat Fields",
		ID = "attached_location.wheat_fields",
		Cost = this.Const.World.Stronghold.LocationPrices["Wheat"],
		Path = "wheat_fields_location",
		Text= "Build Wheat Fields. You don't consume food around the stronghold.",
		isValid = function(_contract){
			return (!_contract.getHome().hasAttachedLocation(this.ID))
		}
	},
	{
		Name = "Herbalists Grove",
		ID = "attached_location.herbalists_grove",
		Cost = this.Const.World.Stronghold.LocationPrices["Herbalists"],
		Path = "herbalists_grove_location",
		Text= "Build a Herbalists Grove. Hitpoints regenerate faster when around the stronghold.",
		isValid = function(_contract){
			return (!_contract.getHome().hasAttachedLocation(this.ID))
		}
	},
	{
		Name = "Gold Mine",
		ID = "attached_location.gold_mine",
		Cost = this.Const.World.Stronghold.LocationPrices["Gold"],
		Path = "gold_mine_location",
		Text= "Build a gold mine. Gold will be generated over time.",
		isValid = function(_contract){
			return (!_contract.getHome().hasAttachedLocation(this.ID))
		}
	}
],

gt.Stronghold <- {}
gt.Stronghold.getPlayerBase <- function()
{
	local playerFaction = this.Stronghold.getPlayerFaction()
	if (playerFaction != null)
	{
		local player_settlements = playerFaction.getSettlements()
		foreach (settlement in player_settlements)
		{
			if(settlement.getFlags().get("isPlayerBase")){
				return settlement
			}
		}
	}
	foreach (settlement in this.World.EntityManager.getSettlements())
	{
		if(settlement.getFlags().get("isPlayerBase")){
			return settlement
		}
	}
	return false
}
gt.Stronghold.getPlayerFaction <- function()
{
	if ("FactionManager" in this.World) return this.World.FactionManager.getFactionOfType(this.Const.FactionType.Player)
	return null
}

gt.Stronghold.getClosestDistance <- function(_destination, _list, _tiles = false)
{
	local chosen = null;
	local closestDist = 9999;
	if(!_tiles)
	{
		foreach (obj in _list)
		{
			if (obj == null) continue
			local dist = obj.getTile().getDistanceTo(_destination.getTile())
			if (chosen == null || dist < closestDist)
			{
				chosen = obj;
				closestDist = dist;
			}
		}
	}
	else {
	    foreach (obj in _list)
		{
			if (obj == null) continue
			local dist = obj.getDistanceTo(_destination)
			if (chosen == null || dist < closestDist)
			{
				chosen = obj;
				closestDist = dist;
			}
		}
	}
	return chosen
}

//modded from vanilla to allow for longer range
gt.Stronghold.checkForCoastal <- function(_tile)
{
	local isCoastal = false;
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
	return isCoastal
}