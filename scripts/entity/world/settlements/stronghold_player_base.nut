this.stronghold_player_base <- this.inherit("scripts/entity/world/settlement", {
	//custom player base settlement type. spawns custom storage building, modified marketplace that allows for both selling of trash and food and for storing items
	//many of the stronghold features are handled here
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.isPlayerBase <- true;
		this.m.Name = "Fortress"
		this.defineName();
		this.m.DraftList = [];
		this.m.UIDescription = "Your stronghold";
		this.m.Description = "Your stronghold";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/stronghold_01.png";
		this.m.Sprite = "world_stronghold_01";
		this.m.Lighting = "world_stronghold_01_light";
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = true;
		this.m.Size = 1;
		this.m.HousesType = 3;
		this.m.HousesMin = 1;
		this.m.HousesMax = 2;
		this.m.AttachedLocationsMax = 3;
		this.m.IsVisited = true;
		this.m.IsUpgrading <- false;
		this.m.Banner = this.World.Assets.getBannerID();
		this.m.IsShowingBanner = true;
		this.m.Buildings.resize(7, null)
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_storage_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_management_building"), 6);
		this.getFlags().set("IsMainBase", true)
	}
	
	
	function defineName()
	{
		if (this.getFlags().get("CustomName")) return;
		//dynamic name to add distinction for size, also adds the company name
		local company_name = this.World.Assets.getName();
		local final_name = company_name;
		if (company_name.slice(company_name.len()-1, company_name.len()) == "s") final_name +="' "
		else final_name += "'s "
		final_name += this.getSizeName();
		this.m.Name = final_name;
	}
	
	function isEnterable()
	{
		return true;
	}
	
	function onEnter()
	{
		//updates buildings, shops, quests, attached locations
		this.World.State.getTownScreen().getMainDialogModule().loadRename()
		this.addSituation(this.new("scripts/entity/world/settlements/situations/stronghold_well_supplied_situation"), 9999);
		this.updateSituations()
		this.location.onEnter();
		this.m.CurrentBuilding = null;
		this.updateShop();
		this.Math.seedRandom(this.Time.getRealTime());
		this.updateQuests();
		this.rebuildAttachedLocations()
		//jank way to update sprite
		if (this.m.Buildings[5] != null)
		{
			if (this.m.Buildings[5].m.UIImage.slice(0, 5) != "small")
			{
				this.m.Buildings[5].m.UIImage = "small_" + this.m.Buildings[5].m.UIImage
				this.m.Buildings[5].m.UIImageNight = "small_" + this.m.Buildings[5].m.UIImageNight
			}
		}
		return true;
	}
	
	function onLeave()
	{
		this.World.State.getTownScreen().getMainDialogModule().deleteRename()
	}

	function getHamlet(){
		local flag = this.m.Flags.get("Child")
		if (!flag) return false
		return this.World.getEntityByID(flag)
	}

	//I dont trust the roster seed
	function getLocalRoster(){
		return this.World.getRoster(this.getFlags().get("RosterSeed"))
	}

	function fadeOutAndDie(_force = false)
	{
		if (!_force) return
		foreach( h in this.m.HousesTiles )
		{
			local tile = this.World.getTileSquare(h.X, h.Y);
			tile.clear(this.Const.World.DetailType.Houses | this.Const.World.DetailType.Lighting);
			local d = tile.spawnDetail("world_houses_0" + this.m.HousesType + "_0" + h.V + "_ruins", this.Const.World.ZLevel.Object - 3, this.Const.World.DetailType.Houses);
			d.Scale = 0.85;
			this.spawnFireAndSmoke(tile.Pos);
		}
		foreach (unit in this.Stronghold.getPlayerFaction().m.Units)
		{
			unit.fadeOutAndDie()
		}
		
		this.spawnFireAndSmoke(this.getTile().Pos)
		foreach (location in this.m.AttachedLocations)
		{
			this.spawnFireAndSmoke(location.getTile().Pos)
			location.die()
		}
		this.m.IsAlive = false;
		this.fadeAndDie();
	}

	function getTooltip()
	{
		local ret = this.settlement.getTooltip()
		if (this.isUpgrading()){ 
			ret.push({
				id = 99,
				type = "description",
				text = format("\n Currently upgrading to a %s", this.getSizeName(true))
			})
		}
		return ret
	}

	function updateQuests()
	{
		//adds/removes quests when entering town. Takes care of conflicing quests.		
		local fac = this.Stronghold.getPlayerFaction();
		local contracts = fac.getContracts();
		local find_waterskin = false;
		local free_mercenaries = false;
		local find_trainer = false;
		//vars for every quest, allows to plug it in later to remove it
		foreach(contract in contracts)
		{
			
			if (contract.m.Type == "contract.stronghold_find_waterskin_recipe_contract")
			{
				find_waterskin = true;
			}
			if (contract.m.Type == "contract.stronghold_free_mercenaries_contract")
			{
				free_mercenaries = true;
			}
			if (contract.m.Type == "contract.stronghold_free_trainer_contract")
			{
				find_trainer = true;
			}
		}	
				
		if (this.m.Size == 3 && !find_waterskin && !this.m.Flags.get("Waterskin"))
		{
			local contract = this.new("scripts/contracts/contracts/stronghold_find_waterskin_recipe_contract");
			contract.setEmployerID(fac.getRandomCharacter().getID());
			contract.setFaction(fac.getID())
			this.World.Contracts.addContract(contract);
		}
		
		if (this.m.Size == 3 && !free_mercenaries && !this.m.Flags.get("Mercenaries"))
		{
			local contract = this.new("scripts/contracts/contracts/stronghold_free_mercenaries_contract");
			contract.setEmployerID(fac.getRandomCharacter().getID());
			contract.setFaction(fac.getID())
			this.World.Contracts.addContract(contract);
		}
		if (this.m.Size == 3 && !find_trainer && !this.m.Flags.get("Teacher"))
		{
			local contract = this.new("scripts/contracts/contracts/stronghold_free_trainer_contract");
			contract.setEmployerID(fac.getRandomCharacter().getID());
			contract.setFaction(fac.getID())
			this.World.Contracts.addContract(contract);
		}
	}
	
	function clearContracts()
	{
		//clears all contracts after some features
		local contracts = this.Stronghold.getPlayerFaction().getContracts();
		foreach (contract in contracts)
		{
			this.World.Contracts.removeContract(contract)
		}
	}
	
	function updateShop( _force = false )
	{
		//modified vanilla function to allow storage_building to generate free items.
		if (this.m.LastShopUpdate == 0.0){
			this.m.LastShopUpdate = this.Time.getVirtualTimeF() - 3 * this.World.getTime().SecondsPerDay
		}
		local daysPassed = (this.Time.getVirtualTimeF() - this.m.LastShopUpdate) / this.World.getTime().SecondsPerDay;

		if (!_force && this.m.LastShopUpdate != 0 && daysPassed < 3)
		{
			this.updateImportedProduce();
			return;
		}

		if (this.m.ShopSeed != 0)
		{
			this.Math.seedRandom(this.m.ShopSeed);
		}

		this.m.ShopSeed = this.Math.floor(this.Time.getRealTime() + this.Math.rand());
		this.m.LastShopUpdate = this.Time.getVirtualTimeF();

		foreach( building in this.m.Buildings )
		{
			if (building != null)
			{
				if(building.m.ID == "building.storage_building"){
					building.onUpdateShopList(daysPassed);
				}
				else{
					building.onUpdateShopList();
				}

				if (building.getStash() != null)
				{
					foreach( s in this.m.Situations )
					{
						s.onUpdateShop(building.getStash());
					}
				}
			}
		}

		this.updateImportedProduce();
	}

	function setUpgrading(_bool){
		this.m.IsUpgrading = _bool;
	}

	function isUpgrading(){
		return this.m.IsUpgrading
	}

	function getSizeName(_nextLevel = false){
		if (_nextLevel) return this.Const.World.Stronghold.BaseNames[this.getSize()]
		return this.Const.World.Stronghold.BaseNames[this.getSize()-1]
	}
	
	
	function updateTown(){
		//updates town after upgrading and loading the game. Necessary to update the sprites, names etc.
		
		//different looks
		this.defineName()
		local normalSprites = ["world_stronghold_01", "world_stronghold_02", "world_stronghold_03"]
		local upgradingSprites = ["stronghold_02_upgrading", "stronghold_03_upgrading"]
		local barbarianSprites = ["world_wildmen_01", "world_wildmen_02", "world_wildmen_03"]
		local barbarianSpritesSnow = ["world_wildmen_01_snow", "world_wildmen_02_snow", "world_wildmen_03_snow"]
		local nomadSprites = ["world_nomad_camp_02", "world_nomad_camp_03", "world_nomad_camp_04"]
		local backgroundSprites =
		[
			{
				UIBackgroundCenter = "ui/settlements/stronghold_01",
				UIBackgroundLeft = "ui/settlements/bg_houses_01_left",
				UIBackgroundRight = "ui/settlements/bg_houses_01_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
				Lighting = "world_stronghold_01_light"
			},
			{
				UIBackgroundCenter = "ui/settlements/stronghold_02",
				UIBackgroundLeft = "ui/settlements/bg_houses_02_left",
				UIBackgroundRight = "ui/settlements/bg_houses_02_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
				Lighting = "world_stronghold_02_light"
			},
			{
				UIBackgroundCenter = "ui/settlements/stronghold_03",
				UIBackgroundLeft = "ui/settlements/bg_houses_03_left",
				UIBackgroundRight = "ui/settlements/bg_houses_03_right",
				UIRampPathway = "ui/settlements/ramp_01_cobblestone",
				Lighting = "world_stronghold_03_light"
			}
		]
		local selectedBackgroundSprites =  backgroundSprites[this.getSize()-1]
		local sprites;
		sprites = this.isUpgrading() ? upgradingSprites : normalSprites;
		this.m.troopSprites <- "figure_mercenary_01";
		local isOnSnow = this.getTile().Type == this.Const.World.TerrainType.Snow;
		for( local i = 0; i != 6; i = ++i )
		{
			if (this.getTile().hasNextTile(i) && this.getTile().getNextTile(i).Type == this.Const.World.TerrainType.Snow)
			{
				isOnSnow = true;
				break;
			}
		}
		if (this.m.Flags.get("BarbarianSprites"))
		{
			isOnSnow ? sprites = barbarianSpritesSnow : sprites = barbarianSprites
			this.m.troopSprites <- "figure_wildman_01";
		}
		else if (this.m.Flags.get("NomadSprites"))
		{
			this.m.troopSprites <- "figure_nomad_03";
			sprites = nomadSprites
		}
		
		//update size etc after deserialisation
		
		
		this.m.Sprite = sprites[this.getSize()-1]
		if (this.m.Flags.get("LevelOne") && this.isUpgrading()) this.m.Sprite = "stronghold_01_upgrading"

		this.getSprite("body").setBrush(this.m.Sprite);
		if (this.m.Flags.get("BarbarianSprites")||this.m.Flags.get("NomadSprites")){
			this.getSprite("body").Scale = 1.25;
		}
		this.m.UIDescription = format("Your %s", this.getSizeName());
		this.m.Description = format("Your %s", this.getSizeName());

		this.m.UIBackgroundCenter = selectedBackgroundSprites.UIBackgroundCenter + (isOnSnow ? "_snow" : "")
		this.m.UIBackgroundLeft = selectedBackgroundSprites.UIBackgroundLeft + (isOnSnow ? "_snow" : "")
		this.m.UIBackgroundRight = selectedBackgroundSprites.UIBackgroundRight + (isOnSnow ? "_snow" : "")
		this.m.UIRampPathway = selectedBackgroundSprites.UIRampPathway
		this.m.Lighting = selectedBackgroundSprites.Lighting
		if(this.m.IsCoastal){
			this.m.UIBackgroundLeft = "ui/settlements/water_01";
		}

		
		
		//add management building
		if (this.m.Buildings[6] == null)
		{
			this.addBuilding(this.new("scripts/entity/world/settlem ents/buildings/stronghold_management_building"), 6);
		}
		this.m.Buildings[6].updateSprite()
		this.addSituation(this.new("scripts/entity/world/settlements/situations/stronghold_well_supplied_situation"), 9999);
		//need to update building size since it's changed to 9 during serialisation

		this.getLabel("name").Text = this.getName();
		this.getLabel("name").Visible = true;
		local light = this.getSprite("lighting");
		this.setSpriteColorization("lighting", false);
		if (this.m.Lighting != "");
		{
			light.setBrush(this.m.Lighting);
		}
		light.IgnoreAmbientColor = true;
		light.Alpha = 0;
		local tile = this.getTile()
		if (tile.Type == this.Const.World.TerrainType.Desert || tile.Type == this.Const.World.TerrainType.Oasis || tile.TacticalType == this.Const.World.TerrainTacticalType.DesertHills){
			this.getFlags().set("isSouthern", true)
		}
		else
		{
			this.getFlags().set("isSouthern", false)
		}
		this.m.AttachedLocationsMax = this.Const.World.Stronghold.MaxAttachments[this.getSize()-1]
	}
	
	
	
	function addBuilding( _building, _slot = null )
	{
		//modded vanilla function
		_building.setSettlement(this);

		if (_slot != null)
		{
			this.m.Buildings[_slot] = _building;
		}
		else
		{
			local candidates = [];

			for( local i = 0; i < this.m.Buildings.len(); i = ++i )
			{
				if (this.m.Buildings[i] == null)
				{
					this.m.Buildings[i] = _building;
					break;
				}
			}
		}

	}
	
	function onBuild()
	{

	}

	
	function updateRoster( _force = false )
	{
	}
	
	function getPriceMult()
	{
		return 1.3;
	}

	function hasContract( _id )
	{
		return true;
	}
	
	function addImportedProduce( _p )
	{
		//bigger caravan gainz, otherwise limited to 6
		if (this.m.ProduceImported.len() >= 9)
		{
			this.m.ProduceImported.remove(0);
		}

		this.m.ProduceImported.push(_p);
	}
	
	function buildAttachedLocation( _num, _script, _terrain, _nearbyTerrain, _additionalDistance = 0, _mustBeNearRoad = false, _clearTile = true )
	{
		this.settlement.buildAttachedLocation(_num, _script, _terrain, _nearbyTerrain, _additionalDistance, _mustBeNearRoad, _clearTile)
		this.m.AttachedLocations[this.m.AttachedLocations.len()-1].setActive(true)
	}
	
	function buildHouses()
	{
		//add houses while upgrading
		local tile = this.getTile();
		local candidates = [];
		local poorCandidates = [];

		for( local i = 0; i < 6; i = ++i )
		{
			if (!tile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = tile.getNextTile(i);

				if (nextTile.IsOccupied)
				{
				}
				else if (nextTile.Type == this.Const.World.TerrainType.Oasis || nextTile.Type == this.Const.World.TerrainType.Plains || nextTile.Type == this.Const.World.TerrainType.Tundra || nextTile.Type == this.Const.World.TerrainType.Steppe || nextTile.Type == this.Const.World.TerrainType.Snow)
				{
					candidates.push(nextTile);
				}
				else if (nextTile.Type == this.Const.World.TerrainType.Desert || nextTile.Type == this.Const.World.TerrainType.Hills || nextTile.Type == this.Const.World.TerrainType.Forest || nextTile.Type == this.Const.World.TerrainType.SnowyForest || nextTile.Type == this.Const.World.TerrainType.LeaveForest || nextTile.Type == this.Const.World.TerrainType.AutumnForest || nextTile.Type == this.Const.World.TerrainType.Swamp)
				{
					poorCandidates.push(nextTile);
				}
			}
		}

		local houses = 2

		for( local c; houses != 0; houses = --houses )
		{
			local c = candidates.len() != 0 ? candidates : poorCandidates;
			if (c.len() == 0)
			{
				break;
			}
			local i = this.Math.rand(0, c.len() - 1);
			local v = this.Math.rand(1, 2);
			this.m.HousesTiles.push({
				X = c[i].SquareCoords.X,
				Y = c[i].SquareCoords.Y,
				V = v
			});
			c[i].clear();
			c[i].IsOccupied = true;
			local d;
			if (this.m.Flags.get("BarbarianSprites"))
			{
				local isOnSnow = this.getTile().Type == this.Const.World.TerrainType.Snow;
				for( local i = 0; i != 6; i = ++i )
				{
					if (this.getTile().hasNextTile(i) && this.getTile().getNextTile(i).Type == this.Const.World.TerrainType.Snow)
					{
						isOnSnow = true;
						break;
					}
				}
				local detail = isOnSnow? "world_wildmen_01_snow":"world_wildmen_01"
				d = c[i].spawnDetail(detail, this.Const.World.ZLevel.Object - 3, this.Const.World.DetailType.Houses);
			}
			else if (this.m.Flags.get("NomadSprites"))
			{
				d = c[i].spawnDetail("world_nomad_camp_02", this.Const.World.ZLevel.Object - 3, this.Const.World.DetailType.Houses);
			}
			else
			{
				d = c[i].spawnDetail("world_houses_0" + this.m.HousesType + "_0" + v, this.Const.World.ZLevel.Object - 3, this.Const.World.DetailType.Houses);
			}
			d.Scale = 0.85;
			c.remove(i);
		}
	}
	
	function updateImportedProduce()
	{
		//needs to select storage building instead of marketplace
		if (this.m.ProduceImported.len() == 0)
		{
			return;
		}
		local marketplace;

		foreach( building in this.m.Buildings )
		{
			if (building != null && building.getID() == "building.storage_building")
			{
				marketplace = building;
				break;
			}
		}
		if (marketplace == null)
		{
			return;
		}
		foreach( p in this.m.ProduceImported )
		{
			local item = this.new("scripts/items/" + p);
			marketplace.getStash().add(item);
		}

		marketplace.getStash().sort();
		this.m.ProduceImported = [];
	}
	
	function onAttachedLocationsChanged()
	{
		//note destroyed attached locations
		foreach( a in this.m.AttachedLocations )
		{
			if (!a.isActive())
			{
				if (!this.m.Flags.get(a.m.ID))
				{
					this.m.Flags.set(a.m.ID, this.Time.getVirtualTimeF())
				}
			}
		}

	}
	
	function rebuildAttachedLocations()
	{
		//rebuild attached locations
		foreach( a in this.m.AttachedLocations )
		{
			if (!a.isActive())
			{
				if (this.m.Flags.get(a.m.ID) && ((this.m.Flags.get(a.m.ID) + 7 * this.World.getTime().SecondsPerDay) <  this.Time.getVirtualTimeF()))
				{
					a.setActive(true);
					this.m.Flags.remove(a.m.ID)
				}
			}
		}
	}
	
	function getRoadCost(_settlement)
	{
		//display cost before building
		//road multiplier increases in a loop to avoid the game just instantly finding a road and no other options being available
		local closest = _settlement.getTile();
		if (closest == null) return [false, false]

		local navSettings = this.World.getNavigator().createSettings();
		navSettings.RoadMult = 0.15;
		navSettings.StopAtRoad = false;
		local 	roadCost =  clone this.Const.World.TerrainTypeNavCost
		foreach (tile in roadCost) tile *= 1.5
		navSettings.ActionPointCosts = roadCost

		local chosen_road;
		local least_dist = 9999
		while (navSettings.RoadMult < 0.5)
		{

			local path = this.World.getNavigator().findPath(this.getTile(), closest, navSettings, 0);
			if (!path.isEmpty())
			{
				local roadTiles = [];
				roadTiles.push(this.getTile());

				while (path.getSize() >= 1)
				{
					local tile = this.World.getTile(path.getCurrent());
					roadTiles.push(tile);
					path.pop();
				}
				
				local countroads = 0;
				foreach(tile in roadTiles){
					if (tile.HasRoad){
						countroads++
					}
				
				}
				if ((roadTiles.len() - countroads) > 0)
				{
					if (chosen_road == null || roadTiles.len() < least_dist)
					{
						chosen_road = [(roadTiles.len() - countroads), navSettings.RoadMult]
					}
				}
			}
			navSettings.RoadMult = navSettings.RoadMult+0.05
		}
		if (chosen_road != null) return chosen_road
		else return [false, false]

	}
	
	function buildRoad(_settlement, _roadmult = 0.15)
	{
		//actually build the road
		local closest = _settlement.getTile();
		if (closest == null) return false;

		local navSettings = this.World.getNavigator().createSettings();
		navSettings.RoadMult = _roadmult;
		navSettings.StopAtRoad = false;
		local roadCost =  clone this.Const.World.TerrainTypeNavCost
		foreach (tile in roadCost) tile *= 1.5
		navSettings.ActionPointCosts = roadCost

		local path = this.World.getNavigator().findPath(this.getTile(), closest, navSettings, 0);

		if (path.isEmpty())
		{
			return false;
		}

		local roadTiles = [];
		roadTiles.push(this.getTile());

		while (path.getSize() >= 1)
		{
			local tile = this.World.getTile(path.getCurrent());
			roadTiles.push(tile);
			path.pop();
		}
		
		local prevTile;
		foreach( i, tile in roadTiles )
		{
			local dirA = prevTile != null ? tile.getDirectionTo(prevTile) : 0;
			local dirB = i < roadTiles.len() - 1 ? tile.getDirectionTo(roadTiles[i + 1]) : 0;

			if ((tile.RoadDirections & this.Const.DirectionBit[dirA]) == 0 || (tile.RoadDirections & this.Const.DirectionBit[dirB]) == 0)
			{
				tile.RoadDirections = tile.RoadDirections | this.Const.DirectionBit[dirA] | this.Const.DirectionBit[dirB];
			}

			prevTile = tile;
		} 
		foreach(tile in roadTiles)
		{
			if (tile.Type != this.Const.World.TerrainType.Ocean){
				tile.spawnDetail(this.Const.World.RoadBrushes.get(tile.RoadDirections), this.Const.World.ZLevel.Road, this.Const.World.DetailType.Road, false);
			}
		}
		
		//add road connections to each other
		this.updateProperties()
		return true;
	}
	
	
	function checkForCoastal()
	{
		local isCoastal = false;
		for( local i = 0; i < 6; i = ++i )
		{
			if (!this.getTile().hasNextTile(i))
			{
			}
			else if (this.getTile().getNextTile(i).Type == this.Const.World.TerrainType.Ocean || this.getTile().getNextTile(i).Type == this.Const.World.TerrainType.Shore)
			{
				isCoastal = true;
				break;
			}
		}
		return isCoastal
	}


	function buildHarborLocation()
	{
		for( local i = 0; i < 6; i = ++i )
		{
			if (!this.getTile().hasNextTile(i))
			{
				continue
			}
			else if (this.getTile().getNextTile(i).Type == this.Const.World.TerrainType.Ocean || this.getTile().getNextTile(i).Type == this.Const.World.TerrainType.Shore)
			{
				local entity = this.World.spawnLocation("scripts/entity/world/attached_location/harbor_location", this.getTile().getNextTile(i).Coords);
				entity.setSettlement(this);
				entity.onBuild()
				this.m.AttachedLocations.push(entity);
				entity.setActive(true);
				return
			}
		}
	}

	//disables lights when alt location
	function onUpdate()
	{
		local lighting = this.getSprite("lighting");

		if (!this.m.IsActive)
		{
			lighting.Alpha = 0;
			return;
		}

		if (lighting.IsFadingDone)
		{
			if (lighting.Alpha == 0 && this.World.getTime().TimeOfDay >= 4 && this.World.getTime().TimeOfDay <= 7)
			{
				local insideScreen = this.World.getCamera().isInsideScreen(this.getPos(), 0);

				if (insideScreen)
				{
					lighting.fadeIn(5000);
				}
				else
				{
					lighting.Alpha = 255;
				}

				foreach( h in this.m.HousesTiles )
				{
					//disable lights on houses
					if (!this.m.Flags.get("BarbarianSprites") && !this.m.Flags.get("NomadSprites"))
					{
						local tile = this.World.getTileSquare(h.X, h.Y);
						local d = tile.spawnDetail("world_houses_0" + this.m.HousesType + "_0" + h.V + "_light", this.Const.World.ZLevel.Object - 4, this.Const.World.DetailType.Lighting, false, insideScreen);
						d.IgnoreAmbientColor = true;
						d.Scale = 0.85;
					}
				}
			}
			else if (lighting.Alpha != 0 && this.World.getTime().TimeOfDay >= 0 && this.World.getTime().TimeOfDay <= 3)
			{
				local insideScreen = this.World.getCamera().isInsideScreen(this.getPos(), 0);

				if (insideScreen)
				{
					lighting.fadeOut(4000);
				}
				else
				{
					lighting.Alpha = 0;
				}

				foreach( h in this.m.HousesTiles )
				{
					local tile = this.World.getTileSquare(h.X, h.Y);

					if (insideScreen)
					{
						tile.clearAndFade(this.Const.World.DetailType.Lighting);
					}
					else
					{
						tile.clear(this.Const.World.DetailType.Lighting);
					}
				}
			}
		}
	}
	
	function onSerialize( _out )
	{
		this.settlement.onSerialize(_out);
		_out.writeU8(this.m.Size)
		_out.writeBool(this.m.IsUpgrading)
		
	}
	
	function onDeserialize( _in )
	{
		this.settlement.onDeserialize(_in);
		this.m.Size  = _in.readU8();
		this.m.IsUpgrading = _in.readBool()
		this.updateTown()
	}
	

	

});

