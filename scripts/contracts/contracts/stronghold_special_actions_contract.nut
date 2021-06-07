this.stronghold_special_actions_contract <- this.inherit("scripts/contracts/contract", {
	//main settlement interface of the stronghold.
	//General flow: "Task" screen lists all the available options. Clicking on one calls the respective function, which checks if some condition is fulfilled and adds the respective options
	//Completing or aborting an action returns the user to the "Task" screen
	m = {
		Reward = 0,
		Title = "Manage your settlement",
		Cost = 0,
		Text = "",
		Building_options = this.Const.World.Stronghold.Building_options,
		Location_options = this.Const.World.Stronghold.Location_options,
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
		this.m.Name = "Manage your base";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1500.0;
		this.m.IsSouthern <- this.Stronghold.getPlayerBase().getFlags().get("isSouthern")
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
	
	function getOptions()
	{
		//adds all the possible options into a list
		local player_base = this.Stronghold.getPlayerBase()
		local contract_options = [];
		local possibilities = [
			{
				Text = "Upgrade your stronghold",
				ID = "Upgrade",
				isValid = function(){
					return player_base.m.Size < 3
				}
			},
			{
				Text = "Add a building to your town",
				ID = "Building",
				isValid = function(){
					local current_buildings = 0;
					local free_building_slots = player_base.getSize() + 4
					foreach (building in player_base.m.Buildings){
						if (building != null){
							current_buildings++
						}
					}
					return current_buildings < free_building_slots
				}
			},
			{
				Text = "Remove a building from your town",
				ID = "Building_Remove",
				isValid = function(){
					local current_buildings = 0;
					local free_building_slots = player_base.getSize() + 4
					foreach (building in player_base.m.Buildings){
						if (building != null){
							current_buildings++
						}	
					}
					return current_buildings >= free_building_slots
				}
			},
			{
				Text = "Add a location to your town.",
				ID = "Location",
				isValid = function(){
					local current_locations = 0;
					foreach (location in player_base.m.AttachedLocations){
						if (location != null){
							current_locations++
						}
					}
					return current_locations < player_base.m.AttachedLocationsMax && !player_base.m.Flags.get("AllLocationsBuilt")
				}
			},
			{
				Text = "Build a road to another settlement.",
				ID = "Road",
				isValid = function(){
					return player_base.m.Size > 1
				}
			},
			{
				Text = "Buy a Water Skin.",
				ID = "Waterskin",
				isValid = function(){
					return player_base.m.Size == 3
				}
			},
			{
				Text = "Hire mercenaries.",
				ID = "Mercenaries",
				isValid = function(){
					return player_base.m.Size == 3
				}
			},
			{
				Text = "Provide special training to one of your recruits",
				ID = "Teacher",
				isValid = function(){
					return player_base.m.Size == 3
				}
			},
			{
				Text = "Send gifts to a faction",
				ID = "Gift",
				isValid = function(){
					return player_base.m.Size > 1
				}
			},
			{
				Text = "Leave a brother behind",
				ID = "Store_Brother",
				isValid = function(){
					local playerRoster = this.World.getPlayerRoster().getAll()
					return (playerRoster != null && playerRoster.len() > 1)
				}
			},			
			{
				Text = "Retrieve a brother",
				ID = "Retrieve_Brother",
				isValid = function(){
					local playerRoster = this.World.getRoster(9999).getAll()
					return (playerRoster != null && playerRoster.len() > 0)
				}
			},			
			{
				Text = "Build a Hamlet",
				ID = "Hamlet",
				isValid = function(){
					return (player_base.m.Size == 3 && !this.Stronghold.getPlayerFaction().getFlags().get("BuildHamlet"))
				}
			},
			{
				Text = "Remove your base",
				ID = "Remove_Base",
				isValid = function(){
					return true
				}
			},
		]
		local validOptions = []

		foreach (option in possibilities) {
		   if (option.isValid()){
		   		validOptions.push(option.ID)
			   	contract_options.push
				({
					Text = option.Text,
					function getResult(_option)
					{
						return this.Contract.addConditionalScreens(validOptions[_option])
					}
				})				
		   }
		}


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
	
	function addConditionalScreens(_text)
	{
		// adds the different screens and effects corresponding to an option
		if (_text == "Waterskin")
		{
			if (!this.Stronghold.getPlayerBase().m.Flags.get("Waterskin"))
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
				return "Overview_Building"
			}
		}
		else if (_text == "Mercenaries")
		{
			foreach ( unit in this.Stronghold.getPlayerFaction().m.Units){
				if (unit.getFlags().get("Stronghold_Mercenaries")){
					this.m.Flags.set("has_mercs", true)
				}
			}
			if (!this.Stronghold.getPlayerBase().m.Flags.get("Mercenaries"))
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
			else if (this.m.Flags.get("has_mercs"))
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
				this.m.Cost = 20 * this.Const.World.Stronghold.PriceMult;
				this.m.Text = "You can hire a group of local mercenaries to follow you on your travels. They demand " + this.m.Cost + " crowns for one week of their time."
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
								local player_base =  this.Stronghold.getPlayerBase()
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
				return "Overview_Building"
			}
		}
		else if (_text == "Hamlet")
		{
			this.m.Cost = 20 * this.Const.World.Stronghold.PriceMult;
			this.m.Text = "Your stronghold has grown large enough that many common people flock to it. It would be wise to construct a hamlet for these people to live at. This would cost " + this.m.Cost + " crowns."
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
			return "Overview_Building"
		}
		//dynaimic options
		else if (_text == "Teacher")
		{
			this.m.Cost = 10 * this.Const.World.Stronghold.PriceMult;
			if (!this.Stronghold.getPlayerBase().m.Flags.get("Teacher"))
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
			    this.m.Screens.push
				({
					ID = "Teacher_Choice",
					Title = "Train a brother",
					Text = "The legendary swordmaster spends his days honing his skills. He can give one of your brothers an intensive lesson- for a considerable fee of " + this.m.Cost + " crowns. Choose a brother to receive special training by the swordmaster.",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = this.getTeacherOptions()
				})	
				return "Teacher_Choice"
			}	
		}
		else if (_text == "Gift")
		{
			local isValid = this.isGiftValid(true)
			if (isValid[0])
			{
				this.m.Screens.push
				({
					ID = "Send_Gift",
					Title = "Send gifts to a faction",
					Text = "You can choose to send gifts to a faction. This will consume the valuables you have in your inventory, and will increase relations with that faction depending on the value of the gifts. The caravan will demand 5000 crowns to transport the goods.",
					Image = "",
					List = [],
					ShowEmployer = true,
					Options = this.getGiftOptions()
				})
				return "Send_Gift"
			}
			else
			{
				local text = "You can choose to send gifts to a faction. This will consume the valuables you have in your inventory, and will increase relations with that faction depending on the value of the gifts. The caravan will demand 5000 crowns to transport the goods.\n\n"
				if (!isValid[1]) text += "You need at least 5000 crowns to send a gift!\n"
				if (!isValid[2]) text += "You need at least 2 trophies in your inventory or storage to send a gift!\n"
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
		else if (_text == "Upgrade")
		{
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
			local player_base = this.Stronghold.getPlayerBase()
			local advantages = this.Const.World.Stronghold.UnlockAdvantages[player_base.m.Size]
			this.m.Cost =  this.Const.World.Stronghold.PriceMult * this.Const.World.Stronghold.BuyPrices[player_base.getSize()]
			this.m.Text = "You can upgrade your base to a greater size. This would add these options: \n" + advantages +"\n This costs " + this.m.Cost + " crowns. \n\nCAREFUL: The closest nobles or enemies will attempt to destroy your base. Defend it!"
			this.m.Title = "Upgrade your base"
			this.addOverviewScreen()
			
			this.m.Screens.push({
				ID = "Enough",
				Title = this.m.Title,
				Text = "You upgraded your base.",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = [
					{
						Text = "Good.", 
						function getResult(_option)
						{
							this.World.Assets.addMoney(-this.Contract.m.Cost);
							this.Contract.onUpgradePlayerBase()
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
			return "Overview_Building"
		}
		else if (_text == "Building")
		{
			this.m.Screens.push
			({
				ID = "Building_Choice",
				Title = "Choose a building",
				Text = "You can construct a new building for your town. These are your available options.",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getBuildingOptions()
			})
			return "Building_Choice"
		}

		else if (_text == "Building_Remove")
		{
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
		else if (_text == "Location")
		{
			this.m.Screens.push
			({
				ID = "Location_Choice",
				Title = "Choose a location",
				Text = "You can construct a new location close to your town. This can provide various benefits. Each costs 10000 crowns.",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getLocationOptions()
			})
			return "Location_Choice"	
		}
		else if (_text == "Road")
		{
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
		else if (_text== "Store_Brother")
		{
			this.m.Temp_Var = 0
			this.m.Screens.push
			({
				ID = "Store_Brother",
				Title = "Leave a brother behind",
				Text = "Which brother would you like to leave behind?\nStored brothers draw half their wage while they wait for your return.",
				Image = "",
				List = [],
				ShowEmployer = true,
				Options = this.getStoreBrotherOptions()
			})
			return "Store_Brother";
		}
		else if (_text == "Retrieve_Brother")
		{
			this.m.Temp_Var = 0
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
		//this one only kicks in after the player returned to the settlement
		else if (_text == "Remove_Base")
		{
			this.m.Screens.push
			({
				ID = "Remove_Base",
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
							return this.Contract.addConditionalScreens("Confirm_Remove")
						}

					},
					this.addGenericOption("No.")
				],
			})
			return "Remove_Base"
		}
		else if (_text == "Confirm_Remove")
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
			return "Overview_Building"
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
						this.Contract.m.Text = "Go ahead and give " + this.Text + " a lesson.";
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
		local player_base = this.Stronghold.getPlayerBase()
		local hasMoney = false;
		local hasFriends = false;
		local hasGifts = false;

		hasMoney = this.World.Assets.getMoney() >= 5000

		local numGifts = 0
		local items = []
		items.extend(this.World.Assets.getStash().m.Items);
		items.extend(player_base.getBuilding("building.storage_building").getStash().getItems())
		foreach( i, item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
			{
				numGifts++
			}
		}
		hasGifts = numGifts >= 2

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
				if ((faction.m.Type == this.Const.FactionType.OrientalCityState || settlement.isMilitary()) &&  
					settlement.isConnectedToByRoads(player_base))
				{
						militarySettlements.push(settlement);
				}
			}
			if (militarySettlements.len() > 0)
			{
				local chosenSettlement = this.Stronghold.getClosestDistance(player_base, militarySettlements)

				validFactions.push
				({
					"Faction" : faction
					"Town" : chosenSettlement
				})
			}
		}
		hasFriends = validFactions.len() >= 1
		local all = [true, hasMoney, hasGifts, hasFriends, _set]
		if(all.reduce(@(a, b) a&&b)){
			this.setGiftFactions(validFactions)
			return all
		}
		else{
			all[0] = false;
			return all
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
			Text = "Your caravan is on their way to " +  this.m.Temp_Var.Town.getName() + ". Protect it!",
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
					local player_base = this.Stronghold.getPlayerBase()
					local destination = this.Contract.m.Temp_Var;
					local destination_faction = destination.Faction;
					local destination_town = destination.Town;
					
					local patrol_strength = 400 +  100 * (player_base.getSize()-1)
					if (player_base.hasAttachedLocation("attached_location.militia_trainingcamp"))
					{
						patrol_strength += 100
					}
					local party = player_faction.spawnEntity(player_base.getTile(), "Caravan of " + player_base.getName(), true, this.Const.World.Spawn.Caravan, 100);
					this.Const.World.Common.assignTroops(party, this.Const.World.Spawn.Mercenaries, patrol_strength);
					party.setDescription("A caravan bringing gifts to " + destination_town.getName() );
					party.setFootprintType(this.Const.World.FootprintsType.Caravan);
					party.getSprite("body").setBrush("cart_02")
					party.setVisibilityMult(1.0);
					party.setVisionRadius(this.Const.World.Settings.Vision * 0.25);
					party.getSprite("base").Visible = false;
					party.setVisibleInFogOfWar(true)
					party.setMirrored(true);
					party.getFlags().set("IsCaravan", true);
					party.getFlags().set("Stronghold_Caravan", true);
					
					
					local totalReputation = 0
					local stash = this.World.Assets.getStash().getItems();
					
					//remove treasure from player inventory and add 0.05x their value as reputation on arrival
					//ex: 10000 worth of items, gain 50 reputation
					foreach( i, item in stash )
					{
						if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
						{
							totalReputation += this.Math.abs(item.m.Value / 200)
							stash[i] = null;
						}
					}
					local stash = player_base.getBuilding("building.storage_building").getStash().getItems()
		
					foreach( i, item in stash )
					{
						if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
						{
							totalReputation += this.Math.abs(item.m.Value / 200)
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
				local items = []
				items.extend(this.World.Assets.getStash().m.Items);
				items.extend(this.Stronghold.getPlayerBase().getBuilding("building.storage_building").getStash().getItems())
				foreach( i, item in items )
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

	
	function yieldNext(_list)
	{
		local i = 0
		if (i < _list.len()-1) yield _list[i]
		else{
			i = 0
			yield _list[i]
		}
	}


	
	function getBuildingOptions()
	{
		local contract_options = [];
		this.m.Temp_Options = []
		#local nextBuilding = yieldNext(this.m.Building_options)

		foreach (building in this.m.Building_options)
		{
			if (building.isValid())
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
			if (this.Stronghold.getPlayerBase().hasBuilding((this.m.IsSouthern && "SouthID" in building)? building.SouthID : building.ID))
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
						local home = this.Stronghold.getPlayerBase()
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
		local home = this.Stronghold.getPlayerBase();
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
		local home = this.Stronghold.getPlayerBase()
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
			local mult = this.Const.World.Stronghold.RoadCost * this.Const.World.Stronghold.PriceMult
			
			for (local i=0; i < i_max; i++)
			{
				contract_options.push(
				{
					Text = "Road to " + local_sorted_settlements[i].Name + " (" + local_sorted_settlements[i].Cost * mult + " Crowns)",
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
						local home = this.Stronghold.getPlayerBase();
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
		local max_brother_options = this.Const.World.Stronghold.MaxMenuOptionsLen //options len of 11 minus 2 for generics
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
		local max_brother_options = this.Const.World.Stronghold.MaxMenuOptionsLen
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

	function spawnHamlet()
	{
		local tries = 0;
		local radius = 3
		local used = [];
		local list = this.Const.World.Settlements.Villages_small
		local playerBase = this.Stronghold.getPlayerBase()
		local player_faction = this.Stronghold.getPlayerFaction()
		while (tries++ < 3000)
		{
			if (tries%100 == 0) radius++
			local tile = this.getTileToSpawnLocation(playerBase.getTile(), radius, radius+1, [], false)
			if (used.find(tile.ID) != null)
			{
				continue;
			}
			used.push(tile.ID);

			local navSettings = this.World.getNavigator().createSettings();
			local path = this.World.getNavigator().findPath(tile, playerBase.getTile(), navSettings, 0);
			if (path.isEmpty()) continue;
			

			local terrain = this.getTerrainInRegion(tile);
			local candidates = [];

			foreach( settlement in list )
			{
				if (settlement.isSuitable(terrain))
				{
					candidates.push(settlement);
				}
			}

			if (candidates.len() == 0)
			{
				continue;
			}

			local type = candidates[this.Math.rand(0, candidates.len() - 1)];

			if ((terrain.Region[this.Const.World.TerrainType.Ocean] >= 3 || terrain.Region[this.Const.World.TerrainType.Shore] >= 3) && !("IsCoastal" in type) && !("IsFlexible" in type))
			{
				continue;
			}
			local hamlet = this.World.spawnLocation("scripts/entity/world/settlements/stronghold_hamlet", tile.Coords);
			player_faction.addSettlement(hamlet);
			local result = this.new(type.Script)
			hamlet.assimilateCharacteristics(result)
			playerBase.buildRoad(hamlet)
			player_faction.getFlags().set("BuildHamlet", true)

			return
		}
	}

	function onUpgradePlayerBase()
	{
		local player_faction = this.Stronghold.getPlayerFaction()
		local player_base = this.Stronghold.getPlayerBase()
		//upgrade looks and situation
		player_base.m.Size = player_base.m.Size +1;
		player_base.buildHouses()
		player_base.updateTown();
		
		if (player_faction.m.Deck.len() < 2)
		{
			local order = ["scripts/factions/actions/stronghold_guard_base_action", "scripts/factions/actions/stronghold_send_caravan_action"];
			player_faction.addTrait(order);
		}
		//spawn new guards to reflect the change in size
		local actionToFire = player_faction.m.Deck[0]
		actionToFire.execute(player_faction);
		
		//spawn assailant quest
		local contract = this.new("scripts/contracts/contracts/stronghold_defeat_assailant_contract");
		contract.setEmployerID(player_faction.getRandomCharacter().getID());
		contract.setFaction(player_faction.getID());
		contract.setHome(player_base);
		contract.setOrigin(player_base);
		this.World.Contracts.addContract(contract);
		contract.start();
	}

	function removeBase()
	{
		local player_faction = this.Stronghold.getPlayerFaction()
		local player_base = this.Stronghold.getPlayerBase()
		local contracts = player_faction.getContracts()
		foreach (contract in contracts)
		{
			this.World.Contracts.removeContract(contract)
		}
		foreach (unit in player_faction.m.Units)
		{
			unit.fadeOutAndDie()
		}
		
		foreach( h in player_base.m.HousesTiles )
		{
			local tile = this.World.getTileSquare(h.X, h.Y);
			tile.clear(this.Const.World.DetailType.Houses | this.Const.World.DetailType.Lighting);
			local d = tile.spawnDetail("world_houses_0" + player_base.m.HousesType + "_0" + h.V + "_ruins", this.Const.World.ZLevel.Object - 3, this.Const.World.DetailType.Houses);
			d.Scale = 0.85;
			player_base.spawnFireAndSmoke(tile.Pos);
		}
		player_base.spawnFireAndSmoke(player_base.getTile().Pos)
		foreach (location in player_base.m.AttachedLocations)
		{
			player_base.spawnFireAndSmoke(location.getTile().Pos)
			location.die()
		}
		foreach (settlement in player_faction.getSettlements())
		{
			settlement.fadeOutAndDie(true)
		}
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


