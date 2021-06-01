this.stronghold_special_actions_contract_hamlet <- this.inherit("scripts/contracts/contract", {
	//main settlement interface of the stronghold.
	//General flow: "Task" screen lists all the available options. Clicking on one calls the respective function, which checks if some condition is fulfilled and adds the respective options
	//Completing or aborting an action returns the user to the "Task" screen
	m = {
		Reward = 0,
		Title = "Manage your hamlet",
		Cost = 0,
		Text = "",
		Building_options =
		[
			{
				Name = "Tavern",
				NameSmall = "tavern",
				ID = "building.tavern",
				Cost = this.Const.World.Stronghold.BuildingPrices["Tavern"],
				Path = "tavern_building",
				SouthPath = false,
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID))
				}
			},
			{
				Name = "Kennel",
				ID = "building.kennel",
				Cost = this.Const.World.Stronghold.BuildingPrices["Kennel"],
				Path = "kennel_building",
				SouthPath = false,
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID))
				}
			},
			{
				Name = "Taxidermist",
				ID = "building.taxidermist",
				SouthID = "building.taxidermist_oriental",
				Cost = this.Const.World.Stronghold.BuildingPrices["Taxidermist"],
				Path = "taxidermist_building",
				SouthPath = "taxidermist_oriental_building",
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID) && !(_town.hasBuilding(this.SouthID)))
				}
			},
			{
				Name = "Temple",
				ID = "building.temple",
				SouthID = "building.temple",
				Cost = this.Const.World.Stronghold.BuildingPrices["Temple"],
				Path = "temple_building",
				SouthPath = "temple_oriental_building",
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID) && !(_town.hasBuilding(this.SouthID)))
				}
			},
			{
				Name = "Training Hall",
				ID = "building.training_hall",
				Cost = this.Const.World.Stronghold.BuildingPrices["Training"],
				Path = "training_hall_building",
				SouthPath = false,
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID))
				}
			},
			{
				Name = "Alchemist",
				ID = "building.alchemist",
				Cost = this.Const.World.Stronghold.BuildingPrices["Alchemist"],
				Path = "alchemist_building",
				SouthPath = false,
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID))
				}
			},
			{
				Name = "Weaponsmith",
				ID = "building.weaponsmith",
				SouthID = "building.weaponsmith_oriental",
				Cost = this.Const.World.Stronghold.BuildingPrices["Weaponsmith"],
				Path = "weaponsmith_building",
				SouthPath = "weaponsmith_oriental_building",
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID) && !(_town.hasBuilding(this.SouthID)))
				}
			},
			{
				Name = "Armorsmith",
				ID = "building.armorsmith",
				SouthID = "building.armorsmith_oriental",
				Cost = this.Const.World.Stronghold.BuildingPrices["Armorsmith"],
				Path = "armorsmith_building",
				SouthPath = "armorsmith_oriental_building",
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID) && !(_town.hasBuilding(this.SouthID)))
				}
			},
			{
				Name = "Fletcher",
				ID = "building.fletcher",
				Cost = this.Const.World.Stronghold.BuildingPrices["Fletcher"],
				Path = "fletcher_building",
				SouthPath = false,
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID))
				}
			},
			{
				Name = "Port",
				ID = "building.port",
				Cost = this.Const.World.Stronghold.BuildingPrices["Port"],
				Path = "port_building",
				SouthPath = false,
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID) && _town.isCoastal())
				}
			},
			{
				Name = "Arena",
				ID = "building.arena",
				Cost = this.Const.World.Stronghold.BuildingPrices["Arena"],
				Path = "arena_building",
				SouthPath = false,
				isValid = function(_town){
					return (!_town.hasBuilding(this.ID) && _town.m.Size == 3)
				}
			}
		],
		Location_options =
		[
			{
				Name = "Workshop",
				ID = "attached_location.workshop",
				Cost = this.Const.World.Stronghold.LocationPrices["Workshop"],
				Path = "workshop_location",
				Text= "Build a workshop. Generates tools."
			},
			{
				Name = "Ore Smelter",
				ID = "attached_location.ore_smelters",
				Cost = this.Const.World.Stronghold.LocationPrices["Ore"],
				Path = "ore_smelters_location",
				Text= "Build an ore smelter. Weaponsmiths carry more items."
			},
			{
				Name = "Blast Furnace",
				ID = "attached_location.blast_furnace",
				Cost = this.Const.World.Stronghold.LocationPrices["Blast"],
				Path = "blast_furnace_location",
				Text= "Build a blast furnace. Armourers carry more items."
			},
			{
				Name = "Stone Watchtower",
				ID = "attached_location.stone_watchtower",
				Cost = this.Const.World.Stronghold.LocationPrices["Stone"],
				Path = "stone_watchtower_location",
				Text= "Build a watchtower. Increases speed and sight range around the stronghold."
			},
			{
				Name = "Militia Trainingcamp",
				ID = "attached_location.militia_trainingcamp",
				Cost = this.Const.World.Stronghold.LocationPrices["Militia"],
				Path = "militia_trainingcamp_location",
				Text= "Build a militia camp. Increases strength of mercenaries."
			},
			{
				Name = "Wheat Fields",
				ID = "attached_location.wheat_fields",
				Cost = this.Const.World.Stronghold.LocationPrices["Wheat"],
				Path = "wheat_fields_location",
				Text= "Build Wheat Fields. You don't consume food around the stronghold."
			},
			{
				Name = "Herbalists Grove",
				ID = "attached_location.herbalists_grove",
				Cost = this.Const.World.Stronghold.LocationPrices["Herbalists"],
				Path = "herbalists_grove_location",
				Text= "Build a Herbalists Grove. Hitpoints regenerate faster when around the stronghold."
			},
			{
				Name = "Gold Mine",
				ID = "attached_location.gold_mine",
				Cost = this.Const.World.Stronghold.LocationPrices["Gold"],
				Path = "gold_mine_location",
				Text= "Build a gold mine. Gold will be generated over time."
			}
		],
		//for valid locations for attachments
		LocationTerrain = 
		[
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Desert,
			this.Const.World.TerrainType.Land,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.SnowyForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.Farmland,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Badlands,
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Shore
		],
		Temp_Var = null, //used as a generic variable to record the choice of the player
		Temp_Options = [] //used as a generic container to record options, used to index in and get the right choice.
		
	},
	function create()
	{
		this.m.DifficultyMult = 130;
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.createStates();
		this.createScreens();
		this.m.Type = "contract.stronghold_special_actions_contract";
		this.m.Name = "Perform special actions";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1500.0;
		this.m.IsSouthern <- this.m.Home.getFlags().get("isSouthern")
	}
	
	function onImportIntro()
	{
		#this.importSettlementIntro();
	}

	function start()
	{
		this.contract.start();
	}
	
	function getBanner()
	{
		return "ui/banners/factions/banner_06s"
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.setScreen("Task");
			}

			function end()
			{
			}

		});
		//only for remove base, forces the user to return to the world map and avoids leave errors
		this.m.States.push({
			ID = "Running",
			function start()
			{
			}
			function update()
			{
				if(this.Contract.m.Flags.get("Remove_Base"))
				{
					this.World.Contracts.finishActiveContract();
					this.Contract.removeBase()
					return 0;
				}
			}


			function end()
			{
			}

		});
	}

	function createScreens()
	{	
	
		//screen to choose the action
		this.m.Screens.push({
			ID = "Task",
			Title = this.m.Title,
			Text = "Which action do you want to do?",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = this.getOptions()
		});
		
		//universial not enough screen
		this.m.Screens.push({
			ID = "Not_Enough",
			Title = this.m.Title,
			Text = "[img]gfx/ui/events/event_04.png[/img]{You don't have enough crowns! Try again later.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [this.addGenericOption("Oh well.")]
			function start()
			{
			}

		});
	}
	
	function getOptions(){
		//adds all the possible options into a list
		local contract_options = [];
		this.setHome(this.World.State.getCurrentTown());
		local player_base = this.m.Home
		local current_buildings = 0;
		local current_locations = 0;
		local free_building_slots = 7
		
		foreach (building in player_base.m.Buildings){
			if (building != null){
				current_buildings++
			}
		}
		foreach (location in player_base.m.AttachedLocations){
			if (location != null){
				current_locations++
			}
		}
		if (current_buildings < free_building_slots)
		{
			contract_options.push
			({
				Text = "Add a building to your town",
				function getResult(_option)
				{

					this.Contract.m.Screens.push
					({
						ID = "Building_Choice",
						Title = "Choose a building",
						Text = "Which building do you want to build?",
						Image = "",
						List = [],
						ShowEmployer = true,
						Options = this.Contract.getBuildingOptions()
					})
					this.Contract.addNegScreen("Building")
					return "Building_Choice";
				}
			})
		}
		else
		{
			contract_options.push
			({
				Text = "Remove a building from your town",
				function getResult(_option)
				{

					this.Contract.m.Screens.push
					({
						ID = "Building_Remove_Choice",
						Title = "Choose a building",
						Text = "Which building do you want to remove?",
						Image = "",
						List = [],
						ShowEmployer = true,
						Options = this.Contract.getBuildingRemoveOptions()
					})
					this.Contract.addNegScreen("Building_Remove")
					return "Building_Remove_Choice";
				}
			})
		}
		if (!player_base.m.Flags.get("AllRoadsBuilt"))
		{
			contract_options.push
			({
				Text = "Build a road to another settlement.",
				function getResult(_option)
				{

					this.Contract.m.Screens.push
					({
						ID = "Road_Choice",
						Title = "Choose a settlement",
						Text = "Where to you want your road to lead to?",
						Image = "",
						List = [],
						ShowEmployer = true,
						Options = this.Contract.getRoadOptions()
					})
					this.Contract.addNegScreen("Road")
					return "Road_Choice";
				}
			})
		}
			
		
		//remove base, sets contract to active to force the placer to return to world map before removing- avoids issues with leaving the base
		contract_options.push
		({
			Text = "Remove your base",
			function getResult(_option)
			{
				this.Contract.m.Screens.push
				({
					ID = "Confirm_Remove",
					Title = "Confirm your choice",
					Text = "Are you sure you want to remove your base? This is free, but can't be undone.",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [
						{
							Text = "Yes.",
							function getResult(_option)
							{
								this.Contract.addNegScreen("Remove_Base")
								return "Overview_Building"

							}

						},
						this.Contract.addGenericOption("No.")
					],
				})
				return "Confirm_Remove";
			}
		})
		
		
		contract_options.push
		({
			Text = "Not right now.",
			function getResult(_option)
			{
				this.Contract.removeThisContract()
				return 0;
			}
		})
		return contract_options;
	}
	
	function addNegScreen(_text)
	{
		// adds the different screens and effects after you've chosen an option
		if (_text == "Waterskin")
		{
			this.m.Cost = 40 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "You choose to buy a Water Skin. This will cost " + this.m.Cost + " crowns."
			this.m.Title = "Buy a Water Skin"
			this.addOverviewScreen()
			
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
							this.World.Assets.addMoney(-this.Contract.m.Cost);
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
						text = "You lose " +this.Contract.m.Cost + " crowns."
					});
				}
			})
		}
		else if (_text == "Mercenaries")
		{
			this.m.Cost = 20 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "You choose to hire mercenaries. This will cost " + this.m.Cost + " crowns."
			this.m.Title = "Hire mercenaries"
			this.addOverviewScreen()
			
			this.m.Screens.push({
				ID = "Enough",
				Title = this.m.Title,
				Text = "You hired a group of mercenaries.",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = [
					{
						Text = "Good.", 
						function getResult(_option)
						{
							this.World.Assets.addMoney(-this.Contract.m.Cost);
							local player_faction = this.Stronghold.getPlayerFaction();
							local player_base =  player_faction.m.Settlements[0];
							local mercenary_size = 200
							if (player_base.hasAttachedLocation("attached_location.militia_trainingcamp"))
							{
								mercenary_size += 100
							}
							local party = player_faction.spawnEntity(player_base.getTile(), "Mercenary band of " + player_base.getName(), true, this.Const.World.Spawn.Mercenaries, mercenary_size);
							party.getSprite("body").setBrush("figure_mercenary_01");
							party.setDescription("A band of mercenaries following you around.");
							party.getFlags().set("Stronghold_Mercenaries", true);
							party.setFootprintType(this.Const.World.FootprintsType.CityState);
							party.setMovementSpeed(150)
							local c = party.getController();
							c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false)
							c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false)
							local follow = this.new("scripts/ai/world/orders/stronghold_follow_order");
							follow.setDuration(7);
							c.addOrder(follow);
							this.Contract.removeThisContract()
							return 0;
						}

					}
				],
				function start()
				{
					this.List.push({
						id = 10,
						icon = "ui/events/event_134.png",
						text = "You lose " +this.Contract.m.Cost + " crowns."
					});
				}
			});
		}
		else if (_text == "Hamlet")
		{
			this.m.Cost = 20 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "You choose to build a Hamlet. This will cost " + this.m.Cost + " crowns."
			this.m.Title = "Build a Hamlet"
			this.addOverviewScreen()
			
			this.m.Screens.push({
				ID = "Enough",
				Title = this.m.Title,
				Text = "You built a Hamlet.",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = [
					{
						Text = "Good.", 
						function getResult(_option)
						{
							this.World.Assets.addMoney(-this.Contract.m.Cost);
							this.Contract.spawnHamlet()
							this.Contract.removeThisContract()
							return 0;
						}

					}
				],
				function start()
				{
					this.List.push({
						id = 10,
						icon = "ui/events/event_134.png",
						text = "You lose " +this.Contract.m.Cost + " crowns."
					});
				}
			});
		}
		//dynaimic options
		else if (_text == "Teacher")
		{
			this.m.Cost = 10 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "Choose a brother to receive special training by the swordmaster. This will cost " + this.m.Cost + " crowns."
			this.m.Title = "Train a brother"			
		}
		else if (_text == "Gift")
		{
			this.m.Cost = 0 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "Choose a faction to send gifts to. This will consume the valuables you have in your inventory, and give you positive reputation with that faction depending on their value. The caravan will demand 5000 crowns to transport the goods."
			this.m.Title = "Send gifts"			
		}
		else if (_text == "Building")
		{
			this.m.Cost = 0 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "Add a building to your town"
			this.m.Title = "Add building"			
		}
		else if (_text == "Building_Remove")
		{
			this.m.Cost = 0 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "Remove a building from your town"
			this.m.Title = "Remove building"			
		}
		else if (_text == "Location")
		{
			this.m.Cost = 0 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "Add a location to your town"
			this.m.Title = "Add location"			
		}
		else if (_text == "Road")
		{
			this.m.Cost = 0 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "Build a road to another settlement"
			this.m.Title = "Build road"			
		}
		//this one only kicks in after the player returned to the settlement
		else if (_text == "Remove_Base")
		{
			this.m.Cost = 0 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "FINAL WARNING! Are you really sure you want to remove your base?"
			this.m.Title = "Remove your base"
			this.addOverviewScreen()
			if(this.World.Contracts.getActiveContract() != null)
			{
				this.m.Screens.push
				({
					ID = "Enough",
					Title = this.m.Title,
					Text = "You can't remove your base while having an active contract!",
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
			    this.m.Screens.push
				({
					ID = "Enough",
					Title = this.m.Title,
					Text = "You removed your base.",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = [
						{
							Text = "Good.",
							function getResult(_option)
							{
								this.World.Contracts.setActiveContract(this.Contract);
								this.Contract.m.Flags.set("Remove_Base", true)
								this.Contract.setState("Running")
								return 0
							}

						}
					],
					function start()
					{
					}
				})// code
			}
			
		}
	}
	function addOverviewScreen()
	{
		this.m.Screens.push
		({
			ID = "Overview_Building",
			Title = this.m.Title,
			Text = this.m.Text,
			Image = "",
			List = [],
			Options = [
				{
					Text = "Yes.",
					function getResult(_option)
					{
						if (this.World.Assets.getMoney() >= this.Contract.m.Cost)
						{
							return "Enough"

						}
						else
						{
							return "Not_Enough"
						}
					}

				},
				this.addGenericOption()
			],
			ShowObjectives = true,
			ShowPayment = true,
			ShowEmployer = true,
			ShowDifficulty = false,
		});
	}
	
		
	function getTeacherOptions()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local options = []
		foreach (bro in roster)
		{
			if (bro.getLevel() < 11 && !bro.getSkills().hasSkill("effects.trained") && options.len() < 11)
			{
				options.push(
				{
					Text = bro.getName(),
					function getResult(_option)
					{
						// if only I learned this before
						this.Contract.m.Temp_Var = this.Contract.m.Temp_Options[_option];
						this.Contract.m.Text = " The brother to be trained is " + this.Text;
						this.Contract.addOverviewScreen()
						this.Contract.addTeacherEnoughScreen()
						return "Overview_Building";
					}
				})
				this.m.Temp_Options.push(bro);
			}
		}
		options.push(this.addGenericOption("Not right now."))
		
		return options
	}
	
	function addTeacherEnoughScreen()
	{
		this.m.Screens.push({
			ID = "Enough",
			Title = this.m.Title,
			Text = this.m.Text,
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Good.",
					function getResult(_option)
					{
						this.World.Assets.addMoney(-this.Contract.m.Cost);							
						local effect = this.new("scripts/skills/effects_world/new_trained_effect");
						effect.m.Duration = 10;
						effect.m.XPGainMult = 1.5;
						effect.m.Icon = "skills/status_effect_75.png";
						local bro = this.Contract.m.Temp_Var;
						bro.getSkills().add(effect);						
						this.Contract.removeThisContract()
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/events/event_134.png",
					text = "You lose " +this.Contract.m.Cost + " crowns."
				});
			}
		});
	}
	
	function isGiftValid( _set = false)
	{
		local player_base = this.m.Home
		if (player_base.getSize() < 2)
		{
			return false;
		}
		if (this.World.Assets.getMoney() < 5000)
		{
			return false;
		}
		local numGifts = 0
		local stash = this.World.Assets.getStash().getItems();
		foreach( i, item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
			{
				numGifts++
			}
		}
		if (numGifts < 1)
		{
			return false
		}
		local factions = [];
		factions.extend(this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse));
		factions.extend(this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState));
		local validFactions = []
		foreach (faction in factions)
		{
			if (faction.getPlayerRelation() > 80)
			{
				continue
			}
			local militarySettlements = [];
			foreach (settlement in faction.getSettlements())
			{
				if (faction.m.Type == this.Const.FactionType.OrientalCityState)
				{
					if (settlement.isConnectedToByRoads(player_base))
					{
						militarySettlements.push(settlement);
					}
				}
				else
				{
					if (settlement.isMilitary() && settlement.isConnectedToByRoads(player_base))
					{
						militarySettlements.push(settlement);

					}
				}
			}
			if (militarySettlements.len() > 0)
			{
				local chosenSettlement = null;
				if (militarySettlements.len() > 1)
				{
					//randoms one of the settlements, can be cheesed but oh well
					chosenSettlement = militarySettlements[this.Math.rand(0, militarySettlements.len()-1)]
				}
				else{
					chosenSettlement = militarySettlements[0]
				}
					
				validFactions.push
				({
					"Faction" : faction
					"Town" : chosenSettlement
				})
			}
		}
		if (validFactions.len() < 1)
		{
			return false;
		}
		else
		{
			if (_set)
			{
				this.setGiftFactions(validFactions);
			}
			return true
		}
	}
	
	function setGiftFactions(_factions)
	{
		this.m.Temp_Options <- _factions
	}
	
	function getGiftOptions()
	{
		local options = []
		foreach (entry in this.m.Temp_Options)
		{
			options.push(
			{
				Text = entry.Faction.getName(),
				function getResult(_option)
				{
					this.Contract.m.Temp_Var = this.Contract.m.Temp_Options[_option];;
					this.Contract.m.Text = " The faction you're sending a gift to is " + this.Text;
					this.Contract.addGiftEnoughScreen()
					this.Contract.addOverviewScreen()
					return "Overview_Building";
				}
			})
		}
		options.push(this.addGenericOption("Not right now."))
		if (options.len() > 0)
		{
			return options
		}
	}
	function addGiftEnoughScreen()
	{
		this.m.Screens.push
		({
			ID = "Enough",
			Title = this.m.Title,
			Text = "Your caravan is on their way to " +  this.m.Temp_Var.Town.getName() + " Protect it!",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = 
			[{
				Text = "Good.", 
				function getResult(_option)
				{
					this.World.Assets.addMoney(-5000);	
					local player_faction = this.Stronghold.getPlayerFaction();
					local player_base =  player_faction.m.Settlements[0];
					local destination = this.Contract.m.Temp_Var;
					local destination_faction = destination.Faction;
					local destination_town = destination.Town;
					
					local patrol_strength = 100 * (player_base.getSize()-1)
					if (player_base.hasAttachedLocation("attached_location.militia_trainingcamp"))
					{
						patrol_strength += 100
					}
					local party = player_faction.spawnEntity(player_base.getTile(), "Caravan of " + player_base.getName(), true, this.Const.World.Spawn.Caravan, 50);
					this.Const.World.Common.assignTroops(party, this.Const.World.Spawn.Mercenaries, patrol_strength);
					party.setDescription("A caravan bringing gifts to " + destination_town.getName() );
					party.setFootprintType(this.Const.World.FootprintsType.Caravan);
					party.getSprite("body").setBrush("cart_02")
					party.setMovementSpeed(5 * this.Const.World.MovementSettings.Speed);
					party.setVisibilityMult(1.0);
					party.setVisionRadius(this.Const.World.Settings.Vision * 0.25);
					party.getSprite("base").Visible = false;
					party.setVisibleInFogOfWar(true)
					party.setMirrored(true);
					party.getFlags().set("IsCaravan", true);
					party.getFlags().set("Stronghold_Caravan", true);
					
					
					local totalReputation = 0
					local stash = this.World.Assets.getStash().getItems();
					
					//remove treasure from player inventory and add 0.1x their value as reputation on arrival
					foreach( i, item in stash )
					{
						if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
						{
							totalReputation += this.Math.abs(item.m.Value / 100)
							stash[i] = null;
						}
					}
					
					//add orders to move to destination, 'unload' the gifts and get reputation, despawn
					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					
					local move = this.new("scripts/ai/world/orders/move_order");
					move.setDestination(destination_town.getTile());
					move.setRoadsOnly(true);
					
					local unload = this.new("scripts/ai/world/orders/stronghold_unload_gifts_order");
					unload.m.Flags.set("DestinationFaction", destination_faction.getID())
					unload.m.Flags.set("Destination", destination_town.getName())
					unload.m.Flags.set("Reputation", totalReputation)
					
					local despawn = this.new("scripts/ai/world/orders/despawn_order");
					
					c.addOrder(move)
					c.addOrder(unload)
					c.addOrder(despawn)
					this.Contract.clearScreens()
					return "Task"
				}
			}],
			function start()
			{
				local stash = this.World.Assets.getStash().getItems();
				foreach( i, item in stash )
				{
					if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
					}
				}
				this.List.push({
						id = 10,
						icon = "ui/events/event_134.png",
						text = "You lose 5000 crowns."
					});
			}
		});
	}

	
	

	function removeBase()
	{
		this.getPlayerFaction().getFlags().set("BuildHamlet", false)
		this.m.Home.fadeOutAndDie(true)
	}
	
	function getBuildingOptions()
	{
		local contract_options = [];
		this.m.Temp_Options = []

		foreach (building in this.m.Building_options)
		{
			if (building.isValid(this.m.Home))
			{
				contract_options.push
				({
					Text = "Build a" + (building.Name[0] == "A" ? "n ":" ") + building.Name + " (" +  (building.Cost * this.Const.World.Stronghold.PriceMult) + " crowns)",
					function getResult(_option)
					{
						local building = this.Contract.m.Temp_Options[_option]
						this.Contract.m.Temp_Var <- (this.Contract.m.IsSouthern &&  building.SouthPath) ? building.SouthPath : building.Path
						this.Contract.m.Cost = building.Cost * this.Const.World.Stronghold.PriceMult		
						this.Contract.addBuildingOverviewScreen(building.Name)
						return "Overview_Building";
					}
				});
				this.m.Temp_Options.push(building);
			}
		}		
		
		contract_options.push(this.addGenericOption("Not right now."))
		return contract_options;
	}
		

	function addBuildingOverviewScreen(_text){
		//dynamic to add the name
		this.m.Screens.push({
			ID = "Overview_Building",
			Title = "Confirm your choice",
			Text = "You selected a " + _text +". This will cost " + this.m.Cost + " crowns. Do you wish to build this?",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Yes.",
					function getResult(_option)
					{
						if (this.World.Assets.getMoney() >= this.Contract.m.Cost)
						{
							this.Contract.addBuildingEnoughScreen()
							return "Enough"

						}
						else
						{
							return "Not_Enough"
						}
					}

				},
				this.addGenericOption()
			],
			ShowObjectives = true,
			ShowPayment = true,
			ShowEmployer = true,
			ShowDifficulty = false,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}
		});
	}
	
	function addBuildingEnoughScreen()
	{
		this.m.Screens.push({
			ID = "Enough",
			Title = "Purchase a new building",
			Text = "Your building is finished.",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Good.",	
					function getResult(_option)
					{
						this.World.Assets.addMoney(-this.Contract.m.Cost);
						local home = this.Contract.m.Home;
						local building_type = this.Contract.m.Temp_Var
						local text = "scripts/entity/world/settlements/buildings/" + building_type
						local building = this.new(text)
						//make space at leftmost spot if port was added
						if (building_type != "port_building")
						{
							home.addBuilding(building);
						}
						else
						{
							if (home.m.Buildings[3] == null)
							{
								home.addBuilding(building, 3);
							}
							else
							{
								local tempbuilding = home.m.Buildings[3];
								home.m.Buildings[3] = null;
								home.addBuilding(building, 3)
								foreach (i, building in home.m.Buildings){
									if (building == null)
									{
										home.addBuilding(tempbuilding, i)
										break;
									}
								}
										
							}
						}
						building.onUpdateShopList();
						this.Contract.removeThisContract()
						this.World.State.m.WorldTownScreen.show()
						return 0
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose " + this.Contract.m.Cost + " crowns."
				});
			}

		});
	}
	
	function getBuildingRemoveOptions()
	{
		local contract_options = [];
		this.m.Temp_Options = []
		foreach (building in this.m.Building_options)
		{
			if (this.m.Home.hasBuilding((this.m.IsSouthern && "SouthID" in building)? building.SouthID : building.ID))
			{
				contract_options.push(
				{
					Text = "Remove a" + (building.Name[0] == "A" ? "n ":" ") + building.Name + " (this is free).",
					function getResult(_option)
					{
						local building = this.Contract.m.Temp_Options[_option]
						this.Contract.m.Temp_Var <- (this.Contract.m.IsSouthern &&  building.SouthPath) ? building.SouthID : building.ID
						this.Contract.m.Cost = 0
						this.Contract.addBuildingRemoveOverviewScreen(building.Name)
						return "Overview_Building";
					}
				});
				this.m.Temp_Options.push(building);
			}
		}
		
		contract_options.push(this.addGenericOption())
		return contract_options;
	}
	
	function addBuildingRemoveOverviewScreen(_text){
		//dynamic to add the name
		this.m.Screens.push({
			ID = "Overview_Building",
			Title = "Confirm your choice",
			Text = "You selected a " + _text +". Do you wish to remove this?",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Yes.",
					function getResult(_option)
					{
						this.Contract.addBuildingRemoveEnoughScreen()
						return "Enough"

					}

				},
				this.addGenericOption()
			],
			ShowObjectives = true,
			ShowPayment = true,
			ShowEmployer = true,
			ShowDifficulty = false,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}
		});
	}
	
	function addBuildingRemoveEnoughScreen()
	{
		this.m.Screens.push({
			ID = "Enough",
			Title = "Remove a building",
			Text = "You removed the building.",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Good.",
					function getResult(_option)
					{
						local result = this.Contract.m.Temp_Var
						local home = this.Contract.m.Home
						foreach(i, building in home.m.Buildings){
							if(home.m.Buildings[i] != null && home.m.Buildings[i].m.ID == result){
								home.m.Buildings[i] = null;
								break;
							}
						}
						this.Contract.removeThisContract()
						this.World.State.m.WorldTownScreen.show()
						return 0
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "This was free."
				});
			}

		});
	}
	
	
	function getLocationOptions(){
		local home = this.m.Home;
		local tile = home.getTile()
		local contract_options = [];
		this.m.Temp_Options = [];
		foreach (building in this.m.Location_options)
		{
			if (!home.hasAttachedLocation(building.ID))
			{
				contract_options.push
				({
					Text = building.Text,
					function getResult(_option)
					{
						local building = this.Contract.m.Temp_Options[_option]
						this.Contract.m.Temp_Var <- building.Path
						this.Contract.m.Cost = building.Cost * this.Const.World.Stronghold.PriceMult		
						this.Contract.addLocationOverviewScreen(building.Name)
						return "Overview_Building";
					}
				})
				this.m.Temp_Options.push(building);
			}
		}

		contract_options.push(this.addGenericOption("Not right now."))
		return contract_options;
	}
	
	function addLocationOverviewScreen(_text){
		this.m.Screens.push({
			ID = "Overview_Building",
			Title = "Confirm your choice",
			Text = "You selected a " + _text +". Do you wish to build this?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Yes.",
					function getResult(_option)
					{
						if (this.World.Assets.getMoney() >= this.Contract.m.Cost)
						{
							this.Contract.addLocationEnoughScreen()
							return "Enough"

						}
						else
						{
							return "Not_Enough"
						}
					}

				},
				this.addGenericOption()
			],
			ShowObjectives = true,
			ShowPayment = true,
			ShowEmployer = false,
			ShowDifficulty = false,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}
		});
	}
	function addLocationEnoughScreen()
	{
		this.m.Screens.push({
			ID = "Enough",
			Title = "Purchase a new location",
			Text = "Your location is finished.",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Good.",
					function getResult(_option)
					{
						this.World.Assets.addMoney(-this.Contract.m.Cost);
						local home = this.Contract.m.Home;
						local location_type = this.Contract.m.Temp_Var
						local text = "scripts/entity/world/attached_location/" + location_type
						home.buildAttachedLocation(1, text, this.Contract.m.LocationTerrain, [], 1)
						home.buildRoad(home.m.AttachedLocations[home.m.AttachedLocations.len()-1])
						if (this.Contract.m.Location_options.len() == home.m.AttachedLocations.len())
						{
							home.getFlags().set("AllLocationsBuilt", true)
						}
						this.Contract.clearScreens()
						return "Task"
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose 10000 crowns."
				});
			}

		});
	}
	function getRoadOptions()
	{
		local home = this.m.Home
		local tile = home.getTile()
		local settlements = this.World.EntityManager.getSettlements();
		local contract_options = []
		local local_sorted_settlements = [];
		this.m.Temp_Options = [];
		local dist_map = []
		
		foreach (settlement in settlements)
		{
			if (settlement != null && settlement != home){
				local dist = home.getTile().getDistanceTo(settlement.getTile());
				if (home.m.ConnectedToByRoads.len() != 0 && (dist > 60 || (dist_map.len() > 10 && dist > dist_map[10])))  continue;
				local results = home.getRoadCost(settlement);
				local cost = results[0] 
				local roadmult = results[1] 
				if (cost && cost != 0)
				{
					local_sorted_settlements.push
					({
					Score = dist, 
					Name = settlement.getName(),
					Cost = cost,
					Roadmult = roadmult,
					Set = this.WeakTableRef(settlement)
					
					})
					dist_map.push(dist)
					dist_map.sort()
				}

			}
		}
		
		if (local_sorted_settlements.len() == 0){
			contract_options.push(
			{
				Text = "You have built all possible roads!",
				function getResult(_option)
				{
					this.Contract.m.Home.m.Flags.set("AllRoadsBuilt", true)
					this.Contract.clearScreens()
					return "Task"
				}
			})
		}
		else
		{
			local_sorted_settlements.sort(this.sortRoadByScore);
			this.m.Temp_Options = local_sorted_settlements;
			local i_max = 11 < local_sorted_settlements.len() ? 11 : local_sorted_settlements.len();
			
			for (local i=0; i < i_max; i++)
			{
				contract_options.push(
				{
					Text = "Road to " + local_sorted_settlements[i].Name,
					function getResult(_option)
					{
						local chosen = this.Contract.m.Temp_Options[_option];
						this.Contract.m.Temp_Var <- chosen;
						this.Contract.m.Cost = chosen.Cost * this.Const.World.Stronghold.RoadCost * this.Const.World.Stronghold.PriceMult
						this.Contract.addRoadOverviewScreen(chosen.Name)
						return "Overview_Building"
					}
				})
			}
			
			contract_options.push(this.addGenericOption("Not right now."))
		}
		return contract_options;
	}
	
	function addRoadOverviewScreen(_name){
		this.m.Screens.push({	

			ID = "Overview_Building",
			Title = "Build a road",
			Text = "You will try to build a road to " + this.m.Temp_Var.Name +". This will cost " + this.m.Cost + " crowns. Do you wish to do this?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Yes.",
					function getResult(_option)
					{
						if (this.World.Assets.getMoney() >= this.Contract.m.Cost)
						{
							this.Contract.addRoadEnoughScreen()
							return "Enough"

						}
						else
						{
							return "Not_Enough"
						}
					}

				},
				this.addGenericOption()
			],
			ShowObjectives = true,
			ShowPayment = true,
			ShowDifficulty = false,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}
		});
	}
	
	function addRoadEnoughScreen()
	{
		this.m.Screens.push({
			ID = "Enough",
			Title = "Build a new road",
			Text = "Your road is finished.",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Good.",
					function getResult(_option)
					{
						local home = this.Contract.m.Home;
						home.buildRoad(this.Contract.m.Temp_Var.Set, this.Contract.m.Temp_Var.Roadmult)
						this.World.Assets.addMoney(-this.Contract.m.Cost);
						this.Contract.clearScreens()
						return "Task"
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose " + this.Contract.m.Cost + " crowns."
				});
			}

		});
	}
	function getStoreBrotherOptions()
	{
		local max_brother_options = 9 //options len of 11 minus 2 for generics
		local options = []
		local playerRoster = this.World.getPlayerRoster().getAll()
		local idx = 0
		if (this.m.Temp_Var > 0)
		{
			this.m.Temp_Var = this.Math.max(0,  playerRoster.len() - max_brother_options)
		}
		for (local i = this.m.Temp_Var; i < max_brother_options + this.m.Temp_Var && i < playerRoster.len(); i++)
		{
			local bro = playerRoster[i]
			options.push(
			{
				Text = bro.getName(),
				function getResult(_option)
				{
					local last = false;
					last = this.Contract.storeBro(this.World.getPlayerRoster().getAll()[_option + this.Contract.m.Temp_Var])
					if (last)
					{
						this.Contract.m.Screens.push(
						{
							ID = "Last_Brother",
							Title = "Last Brother",
							Text = "You can't store your last brother or your avatar!",
							Image = "",
							List = [],
							ShowEmployer = true,
							Options = [this.Contract.addGenericOption("True.")]
						})
						return "Last_Brother"
					}
					this.Contract.m.Temp_Var = this.Math.max(0, this.Contract.m.Temp_Var-1)

					foreach (screen in this.Contract.m.Screens)
					{
						if (screen.ID == "Store_Brother") screen.Options = this.Contract.getStoreBrotherOptions()
					}
					
					return "Store_Brother"
				}
			})
			idx++
		}

			options.push(
			{
				Text = "More options",
				function getResult(_option)
				{
					this.Contract.m.Temp_Var += max_brother_options
					if (this.Contract.m.Temp_Var >= this.World.getPlayerRoster().getAll().len()) this.Contract.m.Temp_Var = 0;
					foreach (screen in this.Contract.m.Screens)
					{
						if (screen.ID == "Store_Brother") screen.Options = this.Contract.getStoreBrotherOptions()
					}
					return "Store_Brother"
				}
			})
		
		options.push(this.addGenericOption("Not right now."))
		return options
	}
	function getRetrieveBrotherOptions()
	{
		local max_brother_options = 9
		local options = []
		local playerRoster = this.World.getRoster(9999).getAll()
		local idx = 0
		if (this.m.Temp_Var > 0)
		{
			this.m.Temp_Var = this.Math.max(0,  playerRoster.len()- max_brother_options)
		}
		for (local i = this.m.Temp_Var; i < max_brother_options + this.m.Temp_Var && i < playerRoster.len(); i++)
		{
			local bro = playerRoster[i]
			options.push(
			{
				Text = bro.getName(),
				function getResult(_option)
				{
					this.Contract.retrieveBro(this.World.getRoster(9999).getAll()[_option + this.Contract.m.Temp_Var])
					this.Contract.m.Temp_Var = this.Math.max(0, this.Contract.m.Temp_Var-1)
					foreach (screen in this.Contract.m.Screens)
					{
						if (screen.ID == "Retrieve_Brother") screen.Options = this.Contract.getRetrieveBrotherOptions()
					}
					
					if (this.World.getRoster(9999).getAll().len() == 0){
						this.Contract.clearScreens()
						return "Task"
					}
					else return "Retrieve_Brother"
				}
			})
			idx++
		}

		options.push(
		{
			Text = "More options",
			function getResult(_option)
			{
				this.Contract.m.Temp_Var += max_brother_options
				if (this.Contract.m.Temp_Var >= this.World.getRoster(9999).getAll().len()) this.Contract.m.Temp_Var = 0;
				foreach (screen in this.Contract.m.Screens)
				{
					if (screen.ID == "Retrieve_Brother") screen.Options = this.Contract.getRetrieveBrotherOptions()
				}
				return "Retrieve_Brother"
			}
		})
	
		options.push(this.addGenericOption("Not right now."))
		return options
	}

	function storeBro(_bro)
	{
		local townRoster = this.World.getRoster(9999)
	    local playerRoster = this.World.getPlayerRoster()
	    if (playerRoster.getAll().len() == 1 || _bro.getFlags().get("IsPlayerCharacter")) return true;
		townRoster.add(_bro)
		playerRoster.remove(_bro)
		return false;
	}
	function retrieveBro(_bro)
	{
		local townRoster = this.World.getRoster(9999)
	    local playerRoster = this.World.getPlayerRoster()
		playerRoster.add(_bro)
		townRoster.remove(_bro)
	}

	function getTerrainInRegion( _tile )
	{
		local terrain = {
			Local = _tile.Type,
			Adjacent = [],
			Region = []
		};
		terrain.Adjacent.resize(this.Const.World.TerrainType.COUNT, 0);
		terrain.Region.resize(this.Const.World.TerrainType.COUNT, 0);

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else
			{
				++terrain.Adjacent[_tile.getNextTile(i).Type];
			}
		}

		this.World.queryTilesInRange(_tile, 1, 4, this.onTileInRegionQueried.bindenv(this), terrain.Region);
		return terrain;
	}
	function onTileInRegionQueried( _tile, _region )
	{
		++_region[_tile.Type];
	}

	//makes sure there are no lingering screens or other variables after returning to the first window.
	function clearScreens()
	{
		this.m.Screens = [];
		this.m.Temp_Var = null;
		this.m.Temp_Options = [];
		this.m.Title = "Manage your settlement";
		this.m.Cost = 0;
		this.createScreens()
	}
	
	function sortRoadByScore( _d1, _d2 )
	{
		if (_d1.Score < _d2.Score)
		{
			return -1;
		}
		else if (_d1.Score > _d2.Score)
		{
			return 1;
		}

		return 0;
	}

	function processInput( _option )
	{
		if (this.m.ActiveScreen == null)
		{
			return false;
		}

		if (_option >= this.m.ActiveScreen.Options.len())
		{
			return true;
		}

		local result = this.m.ActiveScreen.Options[_option].getResult(_option);

		if (typeof result != "string" && result <= 0)
		{
			if (this.isActive())
			{
				this.setScreen(null);
			}

			return false;
		}

		this.setScreen(this.getScreen(result));
		return true;
	}
	
	//generic return to main menu answer
	function addGenericOption(_text = "No.")
	{
		return ({
			Text = _text,
			function getResult(_option)
			{
				this.Contract.clearScreens()
				return "Task"
			}

		})
	}
	
	function onPrepareVariables( _vars )
	{
	}

	function onHomeSet()
	{
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;

		}

	}

	function onIsValid()
	{
		return true;
	}
	
	function cancel()
	{
		this.onCancel();
	}

	function removeThisContract()
	{
		this.World.Contracts.removeContract(this);
		this.m.Home.updateQuests()
		this.World.State.getTownScreen().updateContracts();
	}

	function onEscPressed()
	{
		local idx = this.m.ActiveScreen.Options.len()-1
		this.World.Contracts.processInput( idx )
	}

	function onSerialize( _out )
	{

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);

	}

});


