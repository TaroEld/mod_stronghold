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
	
	function getOptions()
	{
		//adds all the possible options into a list
		this.setHome(this.World.State.getCurrentTown());
		local player_base = this.m.Home
		local contract_options = [];
		local possibilities = [
			{
				Text = format("Add a building to your %s", player_base.getSizeName()),
				ID = "Building",
				isValid = function(){
					local current_buildings = 0;
					local free_building_slots = player_base.getSize() + 4
					foreach (building in player_base.m.Buildings){
						if (building != null){
							current_buildings++
						}
					}
					return current_buildings < free_building_slots && !player_base.isUpgrading()
				}
			},
			{

				Text = format("Remove a building from your %s", player_base.getSizeName()),
				ID = "Building_Remove",
				isValid = function(){
					local current_buildings = 0;
					local free_building_slots = player_base.getSize() + 4
					foreach (building in player_base.m.Buildings){
						if (building != null){
							current_buildings++
						}	
					}
					return current_buildings >= free_building_slots && !player_base.isUpgrading()
				}
			},
			{
				Text = "Build a road to another settlement.",
				ID = "Road",
				isValid = function(){
					return player_base.m.Size > 1 && !player_base.isUpgrading()
				}
			},
			{
				Text = format("Remove your %s", player_base.getSizeName()),
				ID = "Remove_Base",
				isValid = function(){
					return !player_base.isUpgrading()
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
		if (_text == "Building")
		{
			this.m.Screens.push
			({
				ID = "Building_Choice",
				Title = "Choose a building",
				Text = format("You can construct a new building for your %s. These are your available options.", this.Stronghold.getPlayerBase().getSizeName()),
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
		//this one only kicks in after the player returned to the settlement
		else if (_text == "Remove_Base")
		{
			this.m.Screens.push
			({
				ID = "Remove_Base",
				Title = "Confirm your choice",
				Text = format("Are you sure you want to remove your %s? This is free, but can't be undone.", this.Stronghold.getPlayerBase().getSizeName()),
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
			this.m.Text = format("FINAL WARNING! Are you really sure you want to remove your %s?", this.Stronghold.getPlayerBase().getSizeName());
			this.m.Title = "Remove your base"
			this.addOverviewScreen()
			if(this.World.Contracts.getActiveContract() != null)
			{
				this.m.Screens.push
				({
					ID = "Enough",
					Title = this.m.Title,
					Text = format("You can't remove your %s while having an active contract!", this.Stronghold.getPlayerBase().getSizeName()),
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
					Text = format("You removed your %s.", this.Stronghold.getPlayerBase().getSizeName()),
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


