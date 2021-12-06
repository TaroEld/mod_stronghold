this.stronghold_management_contract <- this.inherit("scripts/contracts/contract", {
	//main settlement interface of the stronghold.
	//General flow: "Task" screen lists all the available options. Clicking on one calls the respective function, which checks if some condition is fulfilled and adds the respective options
	//Completing or aborting an action returns the user to the "Task" screen
	//main menu options, buildings and locations are stored in the config file in tables, so should be easy to add more
	//screen options should accomodate more options than the height allows, in which case you get a 'more options' option
	m = {
		Reward = 0,
		Title = "",
		Cost = 0,
		Text = "",
		//for valid locations for attachments
		Temp_Var = null, //used as a generic variable to record the choice of the player
		Temp_Variable_List = [], //used as a generic container to record options, used to index in and get the right choice.
		//gathers the screen options, getActiveOptions() grabs them from here
		Temp_Options = [],
		ActiveIdx = 0,

	},

	function create()
	{
		this.m.DifficultyMult = 130;
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.m.Type = "contract.stronghold_special_actions_contract";
		this.m.Name = ""
		this.m.Title = ""
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1500.0;
		
	}
	//allows to use this for both main base and hamlet

	function onHomeSet()
	{
		this.m.Name = format("Manage your %s", this.getHome().getSizeName());
		this.m.Title = format("Manage your %s", this.getHome().getSizeName());
		this.m.IsSouthern <- this.getHome().getFlags().get("isSouthern")
	}
	//do these after variables are set
	function initScreensAndStates()
	{
		this.createStates();
		this.createScreens();
	}

	function setCost(_cost){
		this.m.Cost = _cost
	}

	function getCost(){
		return this.m.Cost
	}

	//disable some options for hamlet
	function isMainBase(){
		return this.getHome().m.Flags.get("IsMainBase")
	}

	function onImportIntro()
	{
	}

	function getBanner()
	{
		return "ui/banners/factions/banner_06s"
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

	function addCrownSymbol(_crowns){
		return "[img]gfx/ui/tooltips/money.png[/img]" + _crowns
	}

	//makes sure there are no lingering screens or other variables after returning to the first window.
	function clearScreens()
	{
		this.m.Screens = [];
		this.m.Temp_Var = null;
		this.m.ActiveIdx = 0;
		this.m.Temp_Variable_List = [];
		this.m.Title = format("Manage your %s", this.getHome().getSizeName());
		this.setCost(0)
		this.createScreens()
	}
	
//pass the _option number
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
		local chosenOption =  this.m.ActiveScreen.Options[_option]
		local result = chosenOption.getResult(_option);

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
	
	//generic return to main menu answer, if already in main menu return to town
	function addGenericOption(_text = "No.")
	{
		return ({
			Text = _text,
			function getResult(_option)
			{
				if (this.Contract.m.ActiveScreen == null || this.Contract.m.ActiveScreen.ID == "Task"){
					this.Contract.removeThisContract()
					return 0
				}
				else{
					this.Contract.clearScreens()
					return "Task"
				}
			}

		})
	}
	

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;

		}

	}

	
	function cancel()
	{
		this.onCancel();
	}

	function removeThisContract()
	{
		if ("LegendMod" in this.getroottable().Const) this.World.State.getPlayer().calculateModifiers();
		this.World.Contracts.removeContract(this);
		this.m.Home.updateQuests()
		this.World.State.getTownScreen().updateContracts();
	}

	function onEscPressed()
	{
		local idx = this.m.ActiveScreen.Options.len()-1
		this.World.Contracts.processInput( idx )
	}

	//change the options to add all keys and values to the new screen
	function setScreen( _screen, _restartIfAlreadyActive = true )
	{
		if (_screen == null)
		{
			this.m.ActiveScreen = null;
			return;
		}

		if (typeof _screen == "string")
		{
			_screen = this.getScreen(_screen);
		}

		local oldID = "";

		if (this.m.ActiveScreen != null)
		{
			oldID = this.m.ActiveScreen.ID;
		}

		this.m.ActiveScreen = clone _screen;
		this.m.ActiveScreen.Contract <- this;
		this.m.ActiveScreen.Flags <- this.m.Flags;
		this.m.ActiveScreen.TempFlags <- this.m.TempFlags;
		this.m.ActiveScreen.Options = [];
		
		//here
		foreach( o in _screen.Options )
		{
			local option = {};
			foreach(key, value in o) option[key] <- value; 
			this.m.ActiveScreen.Options.push(option);
		}

		if ("List" in this.m.ActiveScreen)
		{
			this.m.ActiveScreen.List = [];
		}

		if ("Characters" in this.m.ActiveScreen)
		{
			this.m.ActiveScreen.Characters = [];
		}

		if (("start" in this.m.ActiveScreen) && (_restartIfAlreadyActive || this.m.ActiveScreen.ID != oldID))
		{
			this.m.ActiveScreen.start();
		}

		this.m.ActiveScreen.Title = this.buildText(this.m.ActiveScreen.Title);
		this.m.ActiveScreen.Text = this.buildText(this.m.ActiveScreen.Text);

		foreach( option in this.m.ActiveScreen.Options )
		{
			option.Contract <- this;
			option.Flags <- this.m.Flags;
			option.TempFlags <- this.m.TempFlags;
			option.Text <- this.buildText(option.Text);
		}
	}

	function createStates()
	{
		//uses the default contract pattern, just sets to main screen right away
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
		local taskText = ""
		if(this.getHome().isUpgrading()) taskText += format("Your %s is currently upgrading. Some options are not available.\n", this.getHome().getSizeName()) 
		taskText += "What do you wish to do?"
		this.m.Screens.push({
			ID = "Task",
			Title = this.m.Title,
			Text = taskText,
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = this.getMainMenuOptions()
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

	function addOverviewScreen(_title, _text, _callBackFunction = null){
		//adds the screen after you've chosen a main menu option, or a sub-option in a multiple choice menu
		//checks if the monetary requirements have been met
		this.m.Screens.push({
			ID = "Overview_Building",
			Title = _title,
			Text = _text,
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Yes.",
					function getResult(_option)
					{
						if (this.World.Assets.getMoney() >= this.Contract.getCost())
						{
							if (_callBackFunction != null) _callBackFunction()
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
		});
	}

	function addEnoughScreen(_title, _text, _callBackFunction, overrideStart = null){
		//adds the final screen if the money fits
		//calls the callback function that resolves the result, such as adding a building
		local start = function(){
			if(this.Contract.getCost() > 0){
				this.List.push({
					id = 10,
					icon = "ui/events/event_134.png",
					text = format("You lose %i crowns.", this.Contract.getCost())
				});
			}
		}
		//start adds the info about crowns spent, items lost etc, most of the time it's just crowns but here you can add alternative versions
		if (overrideStart != null) start = overrideStart;
		this.m.Screens.push({
			ID = "Enough",
			Title = _title,
			Text = _text,
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Good.",
					function getResult(_option)
					{
						if (this.Contract.getCost() > 0 ) this.World.Assets.addMoney(-this.Contract.getCost());
						return _callBackFunction.call(this.Contract)
					}

				}
			],
			start = start
		});
	}
	
	//gathers all the options of a screen in a list
	//pass an array of options, such as a list of buildings, brothers etc
	//if the option has an isValid function, calls it while passing the contract, to allow for functions like getHome()
	// _addOptionFunction must return a screen, which is then pushed to the Temp_Options array
	//Temp_Variable_List is unused in this context, but might be worthwhile
	//_checkValidity to check for isValid functions
	//_clearIdx can be set to false to preserve the active option index, such as for the store brother screens


	function buildActiveOptions(_optionsArray, _addOptionFunction, _checkValidity = true, _clearIdx = true){
		if (_clearIdx) this.m.ActiveIdx = 0;
		this.m.Temp_Options = []
		foreach(option in _optionsArray)
		{
			if (!_checkValidity || !("isValid" in option) || option.isValid(this))
			{
				local idx = this.m.Temp_Options.len()
				this.m.Temp_Variable_List.push(option);
				this.m.Temp_Options.push(_addOptionFunction(option, idx))
			}
		}
	}

	//grabs a number of options from the stored list, also fixes the index and adds the 'more options' and return screens
	//good luck
	function getActiveOptions(_newIdx = null, genericOption = null){
		if (_newIdx != null) this.m.ActiveIdx = _newIdx
		if (this.m.ActiveIdx < 0) this.m.ActiveIdx += this.m.Temp_Options.len()
		if (this.m.ActiveIdx == this.m.Temp_Options.len()) this.m.ActiveIdx = 0

		local newOptions = [];
		for (local x = 0; x < this.m.Temp_Options.len() && x < this.Const.World.Stronghold.MaxMenuOptionsLen; x++){
			newOptions.push(clone this.m.Temp_Options[this.m.ActiveIdx])
			this.m.ActiveIdx++
			if (this.m.ActiveIdx == this.m.Temp_Options.len()){
				this.m.ActiveIdx = 0;
				break;
			}

		}
		if (this.m.Temp_Options.len() > this.Const.World.Stronghold.MaxMenuOptionsLen){
			newOptions.push(getMoreOptionsOption())
		}
		newOptions.push(this.addGenericOption("Not right now."))
		return newOptions
	}

	//gets the next page of options
	//uses the ActiveIdx variable
	function getMoreOptionsOption(){

		return {
			Text = "More options",
			function getResult(_option)
			{
				foreach (screen in this.Contract.m.Screens)
				{
					if (screen.ID == this.Contract.m.ActiveScreen.ID){
						screen.Options = this.Contract.getActiveOptions()
					}
				}
				return this.Contract.m.ActiveScreen.ID
			}
		}
	}


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
								CONTENT
---------------------------------------------------------------------------------------------------------------------------------------------------------------------*/


	function getMainMenuOptions()
	{
		this.buildActiveOptions(this.Const.World.Stronghold.Main_Management_Options, this.addMainMenuScreen)
		return this.getActiveOptions();
	}


	function getBuildingOptions()
	{
		this.buildActiveOptions(this.Const.World.Stronghold.Building_options, this.addBuildingScreen)
		return this.getActiveOptions()
	}

	function getBuildingRemoveOptions()
	{
		local contract_options = clone this.Const.World.Stronghold.Building_options
		local isSouthern = this.m.IsSouthern
		local home = this.getHome()
		contract_options = contract_options.filter(function(index, building){
			return home.hasBuilding((isSouthern && "SouthID" in building)? building.SouthID : building.ID)
		});
		this.buildActiveOptions(contract_options, this.addBuildingRemoveScreen, false)
		return this.getActiveOptions()
	}

	function getLocationOptions()
	{	
		this.buildActiveOptions(this.Const.World.Stronghold.Location_options, this.addLocationScreen)
		return this.getActiveOptions()
	}

	function getRoadOptions()
	{
		local home = this.getHome()
		local tile = home.getTile()
		local settlements = this.World.EntityManager.getSettlements();
		local dist_map = []
		this.m.Temp_Variable_List = [];
		local road_options = [];
		local validSettlements = []
		
		foreach (settlement in settlements)
		{
			if (settlement == null || settlement == home) continue
			
			local dist = home.getTile().getDistanceTo(settlement.getTile());
			if (home.m.ConnectedToByRoads.len() != 0 && (dist > 60 || (dist_map.len() > 10 && dist > dist_map[10])))  continue;
			local results = home.getRoadCost(settlement);
			local cost = results[0] 
			local roadmult = results[1] 
			if (cost && cost != 0)
			{
				road_options.push
				({
				Score = dist, 
				Name = settlement.getName(),
				Cost = cost,
				Roadmult = roadmult,
				Settlement = this.WeakTableRef(settlement)
				
				})
				dist_map.push(dist)
				dist_map.sort()
			}
		}
		
		if (road_options.len() == 0){
			return[{
				Text = "You have built all possible roads!",
				function getResult(_option)
				{
					this.Contract.m.Home.m.Flags.set("AllRoadsBuilt", true)
					this.Contract.clearScreens()
					return "Task"
				}
			}]
		}
		local roadSort = function(_d1, _d2){
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

		road_options.sort(roadSort);
		this.buildActiveOptions(road_options, this.addRoadScreen)
		return this.getActiveOptions()
	}
	function getTrainerOptions()
	{
		local roster = this.World.getPlayerRoster().getAll().filter(function(idx, bro){
			return bro.getLevel() < 11 && !bro.getSkills().hasSkill("effects.trained")});
		this.buildActiveOptions(roster, this.addTrainerScreen)
		return this.getActiveOptions()
	}
	function getGiftOptions()
	{
		local gift_options = clone this.m.Temp_Variable_List
		this.m.Temp_Variable_List = []
		this.buildActiveOptions(gift_options, this.addGiftScreen)
		return this.getActiveOptions()
	}

	function getStoreBrotherOptions()
	{
		this.buildActiveOptions(this.World.getPlayerRoster().getAll(), this.addStoreBrotherScreen)
		return this.getActiveOptions()
	}

	function getRetrieveBrotherOptions()
	{
		this.buildActiveOptions(this.World.getRoster(9999).getAll(), this.addRetrieveBrotherScreen)
		return this.getActiveOptions()
	}

	function addMainMenuScreen(_screenVar, _idx){
		return {
			Text = _screenVar.Text.call(this),
			function getResult(_option)
			{
				return this.Option.onChosen.call(this.Contract)
			},
			IDX = _idx,
			Option = _screenVar
		}
	}


	function addStoreBrotherScreen(_screenVar, _idx){
		return {
			Text = _screenVar.getName(),
			function getResult(_option)
			{
				if (!this.Contract.storeBro(this.Option))
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
				this.Contract.m.Temp_Variable_List = []
				//allows to stay in the screen while removing the option
				this.Contract.buildActiveOptions(this.World.getPlayerRoster().getAll(), this.Contract.addStoreBrotherScreen, false, false)
				local newIdx = this.IDX - _option
				foreach (screen in this.Contract.m.Screens)
				{
					if (screen.ID == this.Contract.m.ActiveScreen.ID){
						screen.Options = this.Contract.getActiveOptions(newIdx)
					}
				}
				return "Store_Brother"
			},
			IDX = _idx,
			Option = _screenVar
		}
	}
	function addRetrieveBrotherScreen(_screenVar, _idx){
		return {
			Text = _screenVar.getName(),
			function getResult(_option)
			{
				this.Contract.retrieveBro(this.Option)
				if (this.World.getRoster(9999).getAll().len() == 0){
					this.Contract.clearScreens()
					return "Task"
				}
				this.Contract.m.Temp_Variable_List = []
				this.Contract.buildActiveOptions(this.World.getRoster(9999).getAll(), this.Contract.addRetrieveBrotherScreen, false, false)
				local newIdx = this.IDX - _option
				foreach (screen in this.Contract.m.Screens)
				{
					if (screen.ID == this.Contract.m.ActiveScreen.ID){
						screen.Options = this.Contract.getActiveOptions(newIdx)
					}
				}
				return "Retrieve_Brother"
			},
			IDX = _idx,
			Option = _screenVar
		}
	}

	function addBuildingScreen(_screenVar, _idx){
		return {
			Text = "Build a" + (_screenVar.Name[0] == "A" ? "n ":" ") + _screenVar.Name + " (" +  (_screenVar.Cost * this.Const.World.Stronghold.PriceMult) + " crowns)",
			function getResult(_option)
			{
				local building = this.Option
				this.Contract.m.Temp_Var <- (this.Contract.m.IsSouthern &&  building.SouthPath) ? building.SouthPath : building.Path
				this.Contract.setCost(building.Cost * this.Const.World.Stronghold.PriceMult)	
				this.Contract.addOverviewScreen(
					format("Build a %s", building.Name), 
					format("You selected a %s. This will cost %i. Do you wish to build this?", building.Name, this.Contract.getCost())
				)
				this.Contract.addEnoughScreen(
					format("Build a %s", building.Name),
					format("Your %s is finished.", building.Name),
					this.Contract.onBuildingAdded
				)
				return "Overview_Building";
			},
			IDX = _idx,
			Option = _screenVar
		}
	}
	
	function addBuildingRemoveScreen(_screenVar, _idx){
		return {
			Text = "Remove a" + (_screenVar.Name[0] == "A" ? "n ":" ") + _screenVar.Name + " (this is free).",
			function getResult(_option)
			{
				local building = this.Option
				this.Contract.m.Temp_Var <- (this.Contract.m.IsSouthern &&  building.SouthPath) ? building.SouthID : building.ID
				this.Contract.addOverviewScreen(
					format("Remove a %s", building.Name), 
					format("You selected to remove a %s. This will cost nothing. Do you wish to proceed?", building.Name)
				)
				this.Contract.addEnoughScreen(
					"Remove a building",
					format("Your %s has been removed.", building.Name),
					this.Contract.onBuildingRemoved
				)
				return "Overview_Building";
			},
			IDX = _idx,
			Option = _screenVar
		}
	}

	function addLocationScreen(_screenVar, _idx){
		return {
			Text = "Build a" + (_screenVar.Name[0] == "A" ? "n ":" ") + _screenVar.Name + " (" +  (_screenVar.Cost * this.Const.World.Stronghold.PriceMult) + " crowns)",
			function getResult(_option)
			{
				local building = this.Option
				this.Contract.m.Temp_Var <- building.Path
				this.Contract.setCost(building.Cost * this.Const.World.Stronghold.PriceMult)	
				this.Contract.addOverviewScreen(
					format("Build a %s", building.Name), 
					format("You selected a %s. This will cost %i. Do you wish to build this?", building.Name,
					this.Contract.getCost())
				)
				this.Contract.addEnoughScreen(
					"Purchase a new location",
					format("Your %s is finished.", building.Name),
					this.Contract.onLocationAdded
				)
				return "Overview_Building";
			},
			IDX = _idx,
			Option = _screenVar
		}
	}

	function addRoadScreen(_screenVar, _idx){
		local price = _screenVar.Cost * this.Const.World.Stronghold.RoadCost * this.Const.World.Stronghold.PriceMult
		return{
			Text = format("Road to %s (%i Crowns)", _screenVar.Name, price)
			function getResult(_option)
			{
				this.Contract.m.Temp_Var <- this.Option;
				this.Contract.setCost(this.Option.Cost * this.Const.World.Stronghold.RoadCost * this.Const.World.Stronghold.PriceMult)
				this.Contract.addOverviewScreen(
					format("Build a road"), 
					format("You will try to build a road to %s. This will cost %i crowns. Do you wish to do this?", this.Option.Name, this.Contract.getCost())
				)
				this.Contract.addEnoughScreen(
					format("Build a road"), 
					format("Your road to %s has been built.", this.Option.Name),
					this.Contract.onRoadBuild
				)
				return "Overview_Building"
			},
			IDX = _idx,
			Option = _screenVar
		}
	}

	function addTrainerScreen(_screenVar, _idx){
		return{
			Text = _screenVar.getName(),
			function getResult(_option)
			{
				this.Contract.m.Temp_Var = this.Option;
				local name = this.Option.getName()
				local text = format("Go ahead and give %s a lesson.\n", name);
				text += "\n1.5x combat experience for the next 10 fights.";
				text += "\nThis brother will lose any other training hall buffs.";
				text += format("\nThis will cost %i crowns", this.Contract.getCost())
				this.Contract.addOverviewScreen(
					format("Train %s", name), 
					text
				)
				this.Contract.addEnoughScreen(
					"Training completed",
					format("%s has received his training.", name),
					this.Contract.onTrainerBought
				)
				return "Overview_Building";
			},
			IDX = _idx,
			Option = _screenVar
		}
		
	}
	function addGiftScreen(_screenVar, _idx){
		return{
			Text = _screenVar.Faction.getName(),
			function getResult(_option)
			{
				this.Contract.m.Temp_Var = this.Option;
				this.Contract.addOverviewScreen(
					"Send a gift,"
					format("The faction you're sending a gift to is %s, do you wish to proceed?", this.Option.Faction.getName())
				)

				local start = function()
				{
					local items = []
					items.extend(this.World.Assets.getStash().m.Items);
					items.extend(this.getHome().getBuilding("building.storage_building").getStash().getItems())
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
				//overwrite start to consume the treasures
				this.Contract.addEnoughScreen(
					"Send a gift,"
					Text = format("Your caravan is on their way to %s. Protect it!", this.Option.Town.getName()),
					this.Contract.onGiftSend,
					start
					)
				return "Overview_Building";
			},
			IDX = _idx,
			Option = _screenVar
		}
	}


	
	function onBuildingAdded()
	{
		local home = this.m.Home;
		local building_type = this.m.Temp_Var
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
		this.removeThisContract()
		this.World.State.m.WorldTownScreen.show()
		return 0
	}

	function onBuildingRemoved()
	{
		local result = this.m.Temp_Var
		local home = this.getHome()
		foreach(i, building in home.m.Buildings){
			if(home.m.Buildings[i] != null && home.m.Buildings[i].m.ID == result){
				home.m.Buildings[i] = null;
				break;
			}
		}
		this.removeThisContract()
		this.World.State.m.WorldTownScreen.show()
		return 0
	}	
	
	
	function onLocationAdded()
	{
		local home = this.m.Home;
		local location_type = this.m.Temp_Var
		local text = "scripts/entity/world/attached_location/" + location_type
		local validTerrain = 
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
		]
		home.buildAttachedLocation(1, text, validTerrain, [], 1)
		home.buildRoad(home.m.AttachedLocations[home.m.AttachedLocations.len()-1])
		if (this.Const.World.Stronghold.Location_options.len() == home.m.AttachedLocations.len())
		{
			home.getFlags().set("AllLocationsBuilt", true)
		}
		this.clearScreens()
		return "Task"
	}
	
	
	function onRoadBuild()
	{

		local home = this.getHome();
		home.buildRoad(this.m.Temp_Var.Settlement, this.m.Temp_Var.Roadmult)
		this.clearScreens()
		return "Task"
	}
	
	function onTrainerBought()
	{						
		local effect = this.new("scripts/skills/effects_world/new_trained_effect");
		effect.m.Duration = 10;
		effect.m.XPGainMult = 1.5;
		effect.m.Icon = "skills/status_effect_75.png";
		local bro = this.m.Temp_Var;
		bro.getSkills().add(effect);	
		this.clearScreens()					
		return "Task"
	}
	
	function isGiftValid( _set = false)
	{
		local hasMoney = this.World.Assets.getMoney() >= 5000
		local hasFriends = false;
		local hasGifts = false;

		local numGifts = 0
		local items = []
		items.extend(this.World.Assets.getStash().m.Items);
		items.extend(this.getHome().getBuilding("building.storage_building").getStash().getItems())
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
					settlement.isConnectedToByRoads(this.getHome()))
				{
						militarySettlements.push(settlement);
				}
			}
			if (militarySettlements.len() > 0)
			{
				local chosenSettlement = this.Stronghold.getClosestDistance(this.getHome(), militarySettlements)

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
			this.m.Temp_Variable_List = validFactions
			return all
		}
		else{
			all[0] = false;
			return all
		}
	}
	
	function onGiftSend(){
		local player_faction = this.Stronghold.getPlayerFaction();
		local player_base = this.getHome()
		local destination = this.m.Temp_Var;
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
		local playerStash = this.World.Assets.getStash()
		local storageStash = player_base.getBuilding("building.storage_building").getStash()
		local toRemoveStorage = []
		local toRemovePlayer = []
		//remove treasure from player inventory and add 0.05x their value as reputation on arrival
		//ex: 10000 worth of items, gain 50 reputation
		foreach( i, item in playerStash.getItems() )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
			{
				totalReputation += this.Math.abs(item.m.Value / 200)
				toRemovePlayer.push(item)
			}
		}
		local stash = player_base.getBuilding("building.storage_building").getStash().getItems()
		
		foreach( i, item in storageStash.getItems() )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
			{
				totalReputation += this.Math.abs(item.m.Value / 200)
				toRemoveStorage.push(item)
			}
		}
		foreach(item in toRemoveStorage) storageStash.remove(item)
		foreach(item in toRemovePlayer) playerStash.remove(item)

		

		
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

		this.clearScreens()
		return "Task"
	}



	function storeBro(_bro)
	{
		local townRoster = this.World.getRoster(9999)
	    local playerRoster = this.World.getPlayerRoster()
	    if (playerRoster.getAll().len() == 1 || _bro.getFlags().get("IsPlayerCharacter")) return false;
		townRoster.add(_bro)
		playerRoster.remove(_bro)
		return true;
	}
	function retrieveBro(_bro)
	{
		local townRoster = this.World.getRoster(9999)
	    local playerRoster = this.World.getPlayerRoster()
		playerRoster.add(_bro)
		townRoster.remove(_bro)
	}

	function onHamletBuild(){
		this.spawnHamlet()
		this.removeThisContract()
		return 0;
	}

	function spawnHamlet()
	{
		local tries = 0;
		local radius = 3
		local used = [];
		local list = this.Const.World.Settlements.Villages_small
		local playerBase = this.getHome()
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
			hamlet.setDiscovered(true);
			hamlet.buildHouses()
			playerBase.buildRoad(hamlet)
			playerBase.getFlags().set("Child", hamlet.getID())
			hamlet.getFlags().set("Parent", playerBase.getID())
			player_faction.getFlags().set("BuildHamlet", true)

			return
		}
	}

	function onUpgradeBought(){
		local player_faction = this.Stronghold.getPlayerFaction()
		local contract = this.new("scripts/contracts/contracts/stronghold_defeat_assailant_contract");
		contract.setEmployerID(player_faction.getRandomCharacter().getID());
		contract.setFaction(player_faction.getID());
		contract.setHome(this.getHome());
		contract.setOrigin(this.getHome());
		contract.m.TargetLevel = this.getHome().getSize() + 1
		this.World.Contracts.addContract(contract);
		contract.start();
		this.removeThisContract()
		return 0;
	}

	function onWaterSkinBought(){
		this.World.Assets.getStash().makeEmptySlots(1);
		local item = this.new("scripts/items/special/fountain_of_youth_item");
		this.World.Assets.getStash().add(item);
		this.clearScreens()
		return "Task";
	}

	function onMercenariesHired(){
		local player_base = this.getHome()
		local player_faction = this.Stronghold.getPlayerFaction();
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
		this.clearScreens()
		return "Task";
	}

	function onRemoveBase(){
		this.World.Contracts.setActiveContract(this);
		this.m.Flags.set("Remove_Base", true)
		this.setState("Running")
		return 0
	}


	function removeBase()
	{
		local player_faction = this.Stronghold.getPlayerFaction()
		local contracts = player_faction.getContracts()
		foreach (contract in contracts)
		{
			this.World.Contracts.removeContract(contract)
		}

		foreach (settlement in player_faction.getSettlements())
		{
			settlement.fadeOutAndDie(true)
		}
	}

});


