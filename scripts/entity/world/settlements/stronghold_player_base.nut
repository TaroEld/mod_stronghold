this.stronghold_player_base <- this.inherit("scripts/entity/world/settlement", {
	//custom player base settlement type. spawns custom storage building, modified marketplace that allows for both selling of trash and food and for storing items
	//many of the stronghold features are handled here
	m = {
		IsUpgrading = false,
		Stash = null,
		Spriteset = "Default",
		TroopSprites = "",
		HouseSprites = [],
		BaseSettings = {
			AutoConsume = true,
			ShowBanner = true,
			ShowEffectRadius = true,
		}
		OverflowStash = null,
		LastEnterLog = {
			Days = -1,
			Gold = 0,
			Tools = 0,
			Items = 0,
			Experience = 0,
		}
	},

	function create()
	{
		this.settlement.create();
		this.m.DraftList = this.Stronghold.FullDraftList;
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = true;
		this.m.Size = 0;
		this.m.HousesType = 3;
		this.m.HousesMin = 1;
		this.m.HousesMax = 2;
		this.m.AttachedLocationsMax = 4;
		this.m.IsVisited = true;
		this.m.Banner = this.World.Assets.getBannerID();
		this.m.IsShowingBanner = this.m.BaseSettings.ShowBanner;
		this.m.Buildings.resize(7, null);
		this.m.Stash = ::new("scripts/items/stash_container");
		this.m.Stash.resize(99);
		this.m.OverflowStash = ::new("scripts/items/stash_container");
		this.m.OverflowStash.setResizable(true);
		this.defineName();
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_management_building"), 6);

		// These flags are convenient to use in hooks, as I don't need to check if x in town.m...
		this.getFlags().set("IsPlayerBase", true);
		this.getFlags().set("IsMainBase", true);
		// Cooldowns
		this.getFlags().set("TimeUntilNextMercs", -1);
		this.getFlags().set("TimeUntilNextCaravan", -1);
		this.getFlags().set("TimeUntilNextPatrol", -1);
	}

	function isMainBase()
	{
		return this.getFlags().get("IsMainBase");
	}

	function getHamlet()
	{
		local flag = this.m.Flags.get("Child");
		return flag ? this.World.getEntityByID(flag) : false;
	}

	function getLocation(_id)
	{
		local loc = this.m.AttachedLocations.filter(@(_idx, _a) _a.getTypeID() == _id)
		return loc.len() > 0 ? loc[0] : null;
	}

	//I dont trust the roster seed
	function getLocalRoster()
	{
		return this.World.getRoster(this.getFlags().get("RosterSeed"));
	}

	function getEffectRadius()
	{
		return this.getSize() == 0 ? 0 : ::Stronghold.BaseTiers[this.getSize()].EffectRadius;
	}

	function getWarehouse()
	{
		return this.getLocation("attached_location.warehouse");
	}

	function getStash()
	{
		return this.getWarehouse().getStash();
	}

	function getOverflowStash()
	{
		return this.m.OverflowStash;
	}

	function isMaxLevel()
	{
		return !this.isUpgrading() && this.getSize() == 4;
	}

	function getTooltip()
	{
		local ret = this.settlement.getTooltip();
		if (this.isUpgrading())
		{
			ret.push({
				id = 99,
				type = "description",
				text = format("\n Currently upgrading to a %s", this.getSizeName(true))
			})
		}
		return ret;
	}

	function isEnterable()
	{
		return true;
	}

	function hasContract( _id )
	{
		return true;
	}

	function getPriceMult()
	{
		return 1.0 * this.m.Modifiers.PriceMult;
	}

	function getSizeName(_nextLevel = false)
	{
		local size = ::Math.max(this.getSize(), 1);
		if (this.isUpgrading()) size = ::Math.max(1, size-1);
		if (_nextLevel) return this.Stronghold.BaseTiers[size + 1].Name;
		return this.Stronghold.BaseTiers[size].Name;
	}

	function getUIInformation()
	{
		local ret = this.settlement.getUIInformation();
		if (this.m.Buildings[5] != null && this.m.Buildings[5].m.ID != "building.crowd")
		{
			ret.Slots[5].stronghold_small <- true;
		}
		return ret;
	}

	function showStrongholdUIDialog()
	{
		::Stronghold.StrongholdScreen.setTown(this);
		::Stronghold.StrongholdScreen.show();
	}

	function onChangeSetting(_setting, _bool)
	{
		this.m.BaseSettings[_setting] = _bool;
		this.updateTown();
	}

	function onBuild()
	{
		this.getFlags().set("IsOnDesert", this.Stronghold.isOnTile(this.getTile(), [this.Const.World.TerrainType.Desert]));
		this.getFlags().set("IsSouthern", this.Stronghold.isOnTile(this.getTile(), [this.Const.World.TerrainType.Desert, this.Const.World.TerrainType.Oasis]) ||  this.getTile().TacticalType == this.Const.World.TerrainTacticalType.DesertHills); // why is desertHills not just a terrain type wtf
		this.getFlags().set("IsOnSnow", this.Stronghold.isOnTile(this.getTile(), [this.Const.World.TerrainType.Snow]));

		this.getFlags().set("RosterSeed", this.toHash(this));
		this.getFlags().set("LastProduceUpdate", this.Time.getVirtualTimeF());
		this.getFlags().set("LastLocationUpdate", this.Time.getVirtualTimeF());
		this.World.createRoster(this.getFlags().get("RosterSeed"));
		this.updateProperties();
		this.updateTown();
		this.buildWarehouseLocation();
		if(this.m.IsCoastal)
		{
			this.buildHarborLocation();
			this.buildRoad(this.m.AttachedLocations[this.m.AttachedLocations.len()-1]);
		}
	}
	

	function onEnter()
	{
		//updates buildings, shops, quests, attached locations
		this.location.onEnter();
		// Update player assets so that we can actually see what we gained and lost from the town
		::Stronghold.StrongholdScreen.updateData(["Assets"]);
		this.m.LastEnterLog.Days = this.m.LastEnterLog.Days == -1 ? 0 : (::World.getTime().Days - this.m.LastEnterLog.Days);
		this.m.CurrentBuilding = null;
		this.addSituation(this.new("scripts/entity/world/settlements/situations/stronghold_well_supplied_situation"), 9999);
		this.updateLocationEffects();
		this.consumeItems();
		this.updateSituations();
		this.updateShop();
		this.updateRoster();

		this.Stronghold.getPlayerFaction().updateQuests();
		this.rebuildAttachedLocations();

		if (!this.m.OverflowStash.isEmpty())
			this.addSituation(::new("scripts/entity/world/settlements/situations/stronghold_overflow_situation.nut"))
		::Math.seedRandom(this.Time.getRealTime());
		return true;
	}

	function onNewDay()
	{
		foreach (location in this.getActiveAttachedLocations())
			location.stronghold_onNewDay()
	}

	function onNewHour()
	{
		foreach (location in this.getActiveAttachedLocations())
			location.stronghold_onNewHour()
	}

	function consumeItems()
	{
		this.getWarehouse().consumeConsumableItems();
	}

	function updateLocationEffects()
	{
		local lastUpdateTime = this.getFlags().get("LastLocationUpdate");
		local daysPassed = ((this.Time.getVirtualTimeF() - lastUpdateTime) / this.World.getTime().SecondsPerDay).tointeger();
		if ( daysPassed == 0)
			return;
		this.getFlags().set("LastLocationUpdate", this.Time.getVirtualTimeF());
		foreach (location in this.getActiveAttachedLocations())
			location.stronghold_onEnterBase(daysPassed);
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
					this.m.Flags.remove(a.m.ID);
				}
			}
		}
	}

	function updateRoster( _force = false )
	{
		local daysPassed = (this.Time.getVirtualTimeF() - this.m.LastRosterUpdate) / this.World.getTime().SecondsPerDay;

		if (!_force && this.m.LastRosterUpdate != 0 && daysPassed < 2)
		{
			return;
		}

		if (this.m.RosterSeed != 0)
		{
			::Math.seedRandom(this.m.RosterSeed);
		}

		this.m.RosterSeed = ::Math.floor(this.Time.getRealTime() + ::Math.rand());
		this.m.LastRosterUpdate = this.Time.getVirtualTimeF();
		local roster = this.World.getRoster(this.getID());
		local current = roster.getAll();
		local iterations = ::Math.max(1, daysPassed / 2);

		local rosterMin = 6
		local rosterMax = 12
		local trainingcamp = this.getLocation("attached_location.militia_trainingcamp" );
		local minMaxIncrease = trainingcamp != null ? ::Stronghold.Locations["Militia_Trainingcamp"].RecruitIncrease * trainingcamp.getLevel() : 0;
		rosterMin += minMaxIncrease;
		rosterMax += minMaxIncrease;

		if (iterations < 7)
		{
			for( local i = 0; i < iterations; i = ++i )
			{
				for( local maxRecruits = ::Math.rand(::Math.max(0, rosterMax / 2 - 1), rosterMax - 1); current.len() > maxRecruits;  )
				{
					local n = ::Math.rand(0, current.len() - 1);
					roster.remove(current[n]);
					current.remove(n);
				}
			}
		}
		else
		{
			roster.clear();
			current = [];
		}

		local maxRecruits = ::Math.rand(rosterMin, rosterMax);
		local draftList;
		draftList = clone this.m.DraftList;

		foreach( loc in this.m.AttachedLocations )
		{
			loc.onUpdateDraftList(draftList);
		}

		foreach( b in this.m.Buildings )
		{
			if (b != null)
			{
				b.onUpdateDraftList(draftList);
			}
		}

		foreach( s in this.m.Situations )
		{
			s.onUpdateDraftList(draftList)
		}
		this.World.Assets.getOrigin().onUpdateDraftList(draftList);

		while (maxRecruits > current.len())
		{
			local bro = roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx(draftList);
			current.push(bro);
		}

		this.World.Assets.getOrigin().onUpdateHiringRoster(roster);
	}

	function onLeave()
	{
		this.settlement.onLeave();
		this.m.LastEnterLog = {
			Days = ::World.getTime().Days,
			Gold = 0,
			Tools = 0,
			Items = 0,
			Experience = 0,
		}
		foreach( i, e in this.m.Situations )
		{
			if (e.getID() == "situation.stronghold_overflow")
			{
				this.m.Situations.remove(i);
			}
		}
		this.consumeItemOverflow();
		this.m.OverflowStash.clear();
	}

	function consumeItemOverflow()
	{
		local stash = this.getStash();
		local playerStash = ::Stash;
		local overflowItems = this.getOverflowStash().getItems();
		while (stash.hasEmptySlot() && overflowItems.len() > 0)
		{
			stash.add(overflowItems.pop());
		}
		while (playerStash.hasEmptySlot() && overflowItems.len() > 0)
		{
			playerStash.add(overflowItems.pop());
		}
	}

	function addItemToWarehouse(item)
	{
		local stash = this.getStash();
		local overflowStash = this.getOverflowStash();
		if (stash.hasEmptySlot())
			stash.add(item);
		else overflowStash.add(item);
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
					// Only enable light on houses if the specified sprite has a lights version
					if (h.Light != "")
					{
						local tile = this.World.getTileSquare(h.X, h.Y);
						local d = tile.spawnDetail(h.Light, this.Const.World.ZLevel.Object - 4, this.Const.World.DetailType.Lighting, false, insideScreen);
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
		local flag = this.getSprite("location_banner")
		flag.Visible = this.m.BaseSettings.ShowBanner;

		local watchtower = this.getLocation("attached_location.stone_watchtower");
		if (watchtower) watchtower.updateFogOfWar();
	}

	function fadeOutAndDie(_force = false)
	{
		if (!_force) return
		foreach( h in this.m.HousesTiles )
		{
			local tile = this.World.getTileSquare(h.X, h.Y);
			tile.clear(this.Const.World.DetailType.Houses | this.Const.World.DetailType.Lighting);
			// local d = tile.spawnDetail(h.Sprite + "_ruins", this.Const.World.ZLevel.Object - 3, this.Const.World.DetailType.Houses);
			// d.Scale = 0.85;
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

	function debugUpgrade()
	{
		this.startUpgrading();
		this.finishUpgrading(true);
	}

	function startUpgrading()
	{
		this.m.IsUpgrading = true;
		::Stronghold.setCooldown(this, "LastUpgradeDoneAttackCooldown");
		this.m.Size += 1;
		this.updateTown();
	}

	function isUpgrading()
	{
		return this.m.IsUpgrading;
	}

	function finishUpgrading(_success)
	{
		this.m.IsUpgrading = false;
		this.getFlags().remove("UpgradeInterrupted");
		this.getFlags().remove("BuildInterrupted");
		if (_success)
		{
			if (this.m.Size > 1)
				this.buildHouses();
		}
		else
		{
			this.m.Size -= 1;
		}
		if (this.m.Size == 4)
			this.buildHamlet();
		this.updateTown()
	}

	function isUnderAttack()
	{
		local flag = this.getFlags().get("UnderAttackBy");
		::logInfo("UnderAttackBy " + flag)
		if (!flag)
			return false;
		local entity = ::World.getEntityByID(flag);
		::logInfo("UnderAttackBy entity " + entity)
		return entity != null;
	}
	
	function updateTown()
	{
		//updates town after upgrading and loading the game. Necessary to update the sprites, names etc.
		this.defineName();
		this.getLabel("name").Text = this.getName();
		this.getLabel("name").Visible = true;
		this.m.UIDescription = format("Your %s", this.getSizeName());
		this.m.Description = format("Your %s", this.getSizeName());

		this.updateLook();
		
		//add management building
		if (this.m.Buildings[6] == null)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_management_building"), 6);
		}
		this.m.Buildings[6].updateSprite();
		this.addSituation(this.new("scripts/entity/world/settlements/situations/stronghold_well_supplied_situation"), 9999);

		this.m.AttachedLocationsMax = this.Stronghold.BaseTiers[this.getSize()].MaxAttachedLocations;
	}

	function defineName()
	{
		if (this.getFlags().get("CustomName")) return;
		//dynamic name to add distinction for size, also adds the company name
		local company_name = this.World.Assets.getName();
		local final_name = company_name;
		if (company_name.slice(company_name.len()-1, company_name.len()) == "s") final_name += "' "
		else final_name += "'s "
		final_name += this.getSizeName();
		this.m.Name = final_name;
	}

	function onVisualsChanged(_newSprite)
	{
		this.m.Spriteset = _newSprite;
		local numHouses = this.m.HousesTiles.len();
		foreach( h in this.m.HousesTiles )
		{
			local tile = this.World.getTileSquare(h.X, h.Y);
			tile.clear(this.Const.World.DetailType.Houses | this.Const.World.DetailType.Lighting);
			tile.IsOccupied = false;
		}
		this.m.HousesTiles.clear();

		this.updateLook();
		this.buildHouses(numHouses);

		foreach(unit in this.getUnitsOfThisBase())
		{
			if (!unit.getFlags().get("IsCaravan"))
			{
				unit.getSprite("body").setBrush(this.m.TroopSprites);
			}
		}
		if (this.getHamlet() != false)
			this.getHamlet().onVisualsChanged(_newSprite)
	}

	function getUnitsOfThisBase()
	{
		local units = [];
		foreach(unit in this.Stronghold.getPlayerFaction().m.Units)
		{
			if (unit.getFlags().get("Stronghold_Base_ID") == this.getID())
			{
				units.push(this.WeakTableRef(unit));
			}
		}
		return units
	}

	function updateLook()
	{

		local isOnSnow = this.getFlags().get("IsOnSnow");
		local isOnDesert = this.getFlags().get("IsOnDesert");
		local sprites = this.Stronghold.VisualsMap[this.m.Spriteset];
		local i = this.getSize()-1;

		this.m.Sprite = this.isUpgrading() ? sprites.Upgrading[i][0] : sprites.Base[i][0];
		this.m.Lighting = this.isUpgrading() ? sprites.Upgrading[i][1] : sprites.Base[i][1];
		this.getSprite("body").setBrush(this.m.Sprite);

		this.m.UIBackgroundCenter = sprites.Background.UIBackgroundCenter[i] + (isOnSnow ? "_snow" : "");
		this.m.UIBackgroundLeft = sprites.Background.UIBackgroundLeft[i] + (isOnSnow ? "_snow" : "");
		this.m.UIBackgroundRight = sprites.Background.UIBackgroundRight[i] + (isOnSnow ? "_snow" : "");
		this.m.UIRampPathway = sprites.Background.UIRampPathway[i];
		
		this.m.TroopSprites = sprites.WorldmapFigure[i];
		this.m.HouseSprites = sprites.Houses;
		if(this.m.IsCoastal)
		{
			this.m.UIBackgroundLeft = "ui/settlements/water_01";
		}

		local light = this.getSprite("lighting");
		this.setSpriteColorization("lighting", false);
		if (this.m.Lighting != "");
		{
			light.setBrush(this.m.Lighting);
		}
		light.IgnoreAmbientColor = true;
		light.Alpha = 0;

		if (!this.hasSprite("threat_radius"))
		{
			local c = this.addSprite("threat_radius");
		}
		local effectRadius =  this.getSprite("threat_radius");
		effectRadius.setBrush("stronghold_threat_radius");
		effectRadius.Scale = this.getEffectRadius() * 0.2;
		effectRadius.Visible = this.m.BaseSettings.ShowEffectRadius;
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
			// crows always goes to slot 5
			if (_building.m.ID == "building.crowd")
			{
				local temp = _building;
				_building = this.m.Buildings[5];
				this.m.Buildings[5] = temp;
				if (_building.m.UIImage.slice(0, 5) == "small")
				{
					_building.m.UIImage = _building.m.UIImage.slice(6);
					_building.m.UIImageNight = _building.m.UIImageNight.slice(6);
				}
			}

			// port
			if (_building.m.ID == "building.port")
			{
				local temp = _building;
				_building = this.m.Buildings[3];
				this.m.Buildings[3] = temp;
			}

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

	function removeBuilding(_buildingID)
	{
		foreach(i, building in this.m.Buildings)
		{
			if(this.m.Buildings[i] != null && this.m.Buildings[i].m.ID == _buildingID)
			{
				this.m.Buildings[i] = null;
				return
			}
		}
	}

	function getActiveBuildings()
	{
		return this.m.Buildings.filter(@(a, b) b != null);
	}

	function getMaxBuildings()
	{
		return ::Math.min(7, ::Stronghold.BaseTiers[this.getSize()].MaxBuildings + 2);
	}

	function removeLocation(_locationID)
	{
		foreach(i, building in this.m.AttachedLocations)
		{
			if(this.m.AttachedLocations[i] != null && this.m.AttachedLocations[i].m.ID == _locationID)
			{
				this.m.AttachedLocations[i].die()
				this.m.AttachedLocations.remove(i);
				return
			}
		}
	}
	
	function addImportedProduce( _p )
	{
		//bigger caravan gainz, otherwise limited to 6
		if (this.m.ProduceImported.len() >= 6)
		{
			this.m.ProduceImported.remove(0);
		}

		this.m.ProduceImported.push(_p);
	}


	function updateImportedProduce()
	{
		//needs to select storage building instead of marketplace
		if (this.m.ProduceImported.len() == 0)
		{
			return;
		}
		foreach( p in this.m.ProduceImported )
		{
			if (typeof p != "string")
			{
				continue;
			}
			local item = this.new("scripts/items/" + p);
			this.addItemToWarehouse(item);
			this.m.LastEnterLog.Items++;
		}
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
					this.m.Flags.set(a.m.ID, this.Time.getVirtualTimeF());
				}
			}
		}
	}
	
	function buildAttachedLocation( _num, _script, _terrain, _nearbyTerrain, _additionalDistance = 0, _mustBeNearRoad = false, _clearTile = true )
	{
		local tries = 0;
		local myTile = this.getTile();
		local foundTile = false;
		_additionalDistance = 0;

		while (_num > 0 && tries++ < 10000 && !foundTile)
		{
			if(tries % 1000 == 0){
				_additionalDistance++;
			}
			local x = ::Math.rand(myTile.SquareCoords.X - 2 - _additionalDistance, myTile.SquareCoords.X + 2 + _additionalDistance);
			local y = ::Math.rand(myTile.SquareCoords.Y - 2 - _additionalDistance, myTile.SquareCoords.Y + 2 + _additionalDistance);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			local tile = this.World.getTileSquare(x, y);

			if (tile.IsOccupied)
			{
				continue;
			}

			if (_mustBeNearRoad && tile.HasRoad)
			{
				continue;
			}

			if (tile.getDistanceTo(myTile) == 1 && _additionalDistance >= 0 || tile.getDistanceTo(myTile) < _additionalDistance)
			{
				continue;
			}

			local terrainFits = false;

			foreach( t in _terrain )
			{
				if (t == tile.Type)
				{
					if (_nearbyTerrain.len() == 0 && !_mustBeNearRoad)
					{
						terrainFits = true;
					}
					else
					{
						for( local i = 0; i < 6; i = ++i )
						{
							if (!tile.hasNextTile(i))
							{
							}
							else
							{
								local next = tile.getNextTile(i);

								if (_mustBeNearRoad && !next.HasRoad)
								{
								}
								else
								{
									if (_nearbyTerrain.len() != 0)
									{
										foreach( n in _nearbyTerrain )
										{
											if (next.Type == n)
											{
												terrainFits = true;
												break;
											}
										}
									}
									else
									{
										terrainFits = true;
									}

									if (terrainFits)
									{
										break;
									}
								}
							}
						}
					}

					if (terrainFits)
					{
						break;
					}
				}
			}

			if (!terrainFits)
			{
				continue;
			}

			if (tile.getDistanceTo(myTile) > 2)
			{
				local navSettings = this.World.getNavigator().createSettings();
				navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
				local path = this.World.getNavigator().findPath(myTile, tile, navSettings, 0);

				if (path.isEmpty())
				{
					continue;
				}
			}

			if (_clearTile)
			{
				tile.clearAllBut(this.Const.World.DetailType.Shore);
			}
			else
			{
				tile.clear(this.Const.World.DetailType.NotCompatibleWithRoad);
			}

			local entity = this.World.spawnLocation(_script, tile.Coords);
			entity.setSettlement(this);

			if (entity.onBuild())
			{
				this.m.AttachedLocations.push(entity);
				_num = --_num;
				tries = 0;
			}
			else
			{
				entity.die();
				continue;
			}
		}
		this.m.AttachedLocations[this.m.AttachedLocations.len()-1].setActive(true)
	}
	
	function buildHouses(_num = 2)
	{
		//add houses while upgrading
		local tile = this.getTile();
		local candidates = [];
		local poorCandidates = [];

		for( local i = 0; i < 6; i = ++i )
		{
			if (!tile.hasNextTile(i))
				continue;

			local nextTile = tile.getNextTile(i);

			if (nextTile.IsOccupied)
				continue;

			if (nextTile.Type == this.Const.World.TerrainType.Oasis || nextTile.Type == this.Const.World.TerrainType.Plains || nextTile.Type == this.Const.World.TerrainType.Tundra || nextTile.Type == this.Const.World.TerrainType.Steppe || nextTile.Type == this.Const.World.TerrainType.Snow)
			{
				candidates.push(nextTile);
			}
			if (nextTile.Type == this.Const.World.TerrainType.Desert || nextTile.Type == this.Const.World.TerrainType.Hills || nextTile.Type == this.Const.World.TerrainType.Forest || nextTile.Type == this.Const.World.TerrainType.SnowyForest || nextTile.Type == this.Const.World.TerrainType.LeaveForest || nextTile.Type == this.Const.World.TerrainType.AutumnForest || nextTile.Type == this.Const.World.TerrainType.Swamp)
			{
				poorCandidates.push(nextTile);
			}
		}

		local houses = _num;

		for( local c; houses != 0; houses = --houses )
		{
			local c = candidates.len() != 0 ? candidates : poorCandidates;
			if (c.len() == 0)
			{
				break;
			}
			local i = ::Math.rand(0, c.len() - 1);
			local v = ::Math.rand(1, 2);
			local spriteArray = ::MSU.Array.rand(this.m.HouseSprites);
			this.m.HousesTiles.push({
				X = c[i].SquareCoords.X,
				Y = c[i].SquareCoords.Y,
				V = v,
				Sprite = spriteArray[0],
				Light = spriteArray[1]
			});
			c[i].clear();
			c[i].IsOccupied = true;
			local d;
			d = c[i].spawnDetail(spriteArray[0], this.Const.World.ZLevel.Object - 3, this.Const.World.DetailType.Houses);

			d.Scale = 0.85;
			c.remove(i);
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
		local roadCost =  clone this.Const.World.TerrainTypeNavCost;
		foreach (tile in roadCost) tile *= 1.5
		navSettings.ActionPointCosts = roadCost;

		local chosen_road;
		local least_dist = 9999;
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
				foreach(tile in roadTiles)
				{
					if (tile.HasRoad)
					{
						countroads++;
					}
				
				}
				if ((roadTiles.len() - countroads) > 0)
				{
					if (chosen_road == null || roadTiles.len() < least_dist)
					{
						chosen_road = [(roadTiles.len() - countroads), navSettings.RoadMult];
					}
				}
			}
			navSettings.RoadMult = navSettings.RoadMult + 0.05;
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
		local roadCost =  clone this.Const.World.TerrainTypeNavCost;
		foreach (tile in roadCost) tile *= 1.5
		navSettings.ActionPointCosts = roadCost;

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
				tile.clear(this.Const.World.DetailType.Road);
				tile.spawnDetail(this.Const.World.RoadBrushes.get(tile.RoadDirections), this.Const.World.ZLevel.Road, this.Const.World.DetailType.Road, false);
			}
		}
		
		//add road connections to each other
		this.updateProperties();
		return true;
	}
	

	function buildHarborLocation()
	{
		for( local i = 0; i < 6; i = ++i )
		{
			if (!this.getTile().hasNextTile(i))
			{
				continue;
			}
			else if (this.getTile().getNextTile(i).Type == this.Const.World.TerrainType.Ocean || this.getTile().getNextTile(i).Type == this.Const.World.TerrainType.Shore)
			{
				local entity = this.World.spawnLocation("scripts/entity/world/attached_location/harbor_location", this.getTile().getNextTile(i).Coords);
				entity.setSettlement(this);
				entity.onBuild();
				this.m.AttachedLocations.push(entity);
				entity.setActive(true);
				return;
			}
		}
	}
	function buildWarehouseLocation()
	{
		local locationDef = ::Stronghold.LocationDefs["Warehouse"];
		this.World.Assets.addMoney(-locationDef.Price)
		local script = "scripts/entity/world/attached_location/" + locationDef.Path
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
			this.Const.World.TerrainType.Oasis,
		]
		this.buildAttachedLocation(1, script, validTerrain, [], 2)
		this.buildRoad(this.m.AttachedLocations[this.m.AttachedLocations.len()-1])
	}

	function buildHamlet()
	{
		local tries = 1;
		local radius = 3
		local used = [];
		local list = this.Const.World.Settlements.Villages_small
		local playerFaction = this.Stronghold.getPlayerFaction()
		local dummyContract = ::new("scripts/contracts/contract")

		local dummyDesertVillage =
		{
			Script = "scripts/entity/world/settlements/small_steppe_village",
			function isSuitable( _terrain )
			{
				if (_terrain.Local == this.Const.World.TerrainType.Desert && (_terrain.Adjacent[this.Const.World.TerrainType.Desert] >= 4 && _terrain.Adjacent[this.Const.World.TerrainType.Ocean] == 0 && _terrain.Adjacent[this.Const.World.TerrainType.Shore] == 0))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}

		local function onTileInRegionQueried( _tile, _region )
		{
			++_region[_tile.Type];
		}
		local function getTerrainInRegion( _tile )
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

			this.World.queryTilesInRange(_tile, 1, 4, onTileInRegionQueried.bindenv(this), terrain.Region);
			return terrain;
		}
		while (tries++ < 1000)
		{
			if (tries % 100 == 0) radius++
			local tile = dummyContract.getTileToSpawnLocation(this.getTile(), radius, radius+1, [], false)
			if (used.find(tile.ID) != null)
			{
				continue;
			}
			used.push(tile.ID);

			local navSettings = this.World.getNavigator().createSettings();
			local path = this.World.getNavigator().findPath(tile, this.getTile(), navSettings, 0);
			if (path.isEmpty()) continue;


			local terrain = getTerrainInRegion(tile);
			local candidates = [];

			foreach( settlement in list )
			{
				if (settlement.isSuitable(terrain))
				{
					candidates.push(settlement);
				}
			}
			if (dummyDesertVillage.isSuitable(terrain))
			{
				candidates.push(dummyDesertVillage);
			}

			if (candidates.len() == 0)
			{
				continue;
			}

			local type = candidates[::Math.rand(0, candidates.len() - 1)];

			if ((terrain.Region[this.Const.World.TerrainType.Ocean] >= 3 || terrain.Region[this.Const.World.TerrainType.Shore] >= 3) && !("IsCoastal" in type) && !("IsFlexible" in type))
			{
				continue;
			}
			local hamlet = this.World.spawnLocation("scripts/entity/world/settlements/stronghold_hamlet", tile.Coords);
			playerFaction.addSettlement(hamlet);
			local result = this.new(type.Script)
			hamlet.assimilateCharacteristics(result);
			hamlet.m.Spriteset = this.m.Spriteset;
			hamlet.updateLook();
			hamlet.setDiscovered(true);
			hamlet.buildHouses();
			this.buildRoad(hamlet);
			this.getFlags().set("Child", hamlet.getID())
			hamlet.getFlags().set("Parent", this.getID())
			playerFaction.getFlags().set("BuildHamlet", true)
			return
		}
		::logError("STRONGHOLD: DID NOT MANAGE TO BUILD HAMLET - PLEASE REPORT BUG");
	}

	function onSerialize( _out )
	{
		::Stronghold.Mod.Serialization.flagSerialize("BaseSettings",  this.m.BaseSettings, this.getFlags());
		::Stronghold.Mod.Serialization.flagSerialize("LastEnterLog",  this.m.LastEnterLog, this.getFlags());
		local management = this.m.Buildings.pop()
		this.m.Buildings.resize(6)
		this.settlement.onSerialize(_out);
		this.m.Stash.onSerialize(_out);
		this.m.OverflowStash.onSerialize(_out);
		_out.writeU8(this.m.Size);
		_out.writeBool(this.m.IsUpgrading);
		_out.writeString(this.m.Spriteset);

		_out.writeU8(this.m.HousesTiles.len());
		for( local i = 0; i != this.m.HousesTiles.len(); i = ++i )
		{
			_out.writeI16(this.m.HousesTiles[i].X);
			_out.writeI16(this.m.HousesTiles[i].Y);
			_out.writeU8(this.m.HousesTiles[i].V);
			_out.writeString(this.m.HousesTiles[i].Sprite);
			_out.writeString(this.m.HousesTiles[i].Light);
		}
		this.m.Buildings.append(management)
	}
	
	function onDeserialize( _in )
	{
		this.settlement.onDeserialize(_in);
		this.m.Stash.onDeserialize(_in);
		this.m.OverflowStash.onDeserialize(_in);
		this.m.Size  = _in.readU8();
		this.m.IsUpgrading = _in.readBool();
		this.m.Spriteset = _in.readString();

		this.m.HousesTiles.clear();
		local numHouses = _in.readU8();
		for( local i = 0; i != numHouses; i = ++i )
		{
			this.m.HousesTiles.push({
				X = _in.readI16(),
				Y = _in.readI16(),
				V = _in.readU8(),
				Sprite = _in.readString(),
				Light = _in.readString(),
			});
		}

		this.m.Buildings.resize(7)
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_management_building"), 6);
		this.m.Buildings[6].updateSprite();
		this.m.BaseSettings = ::Stronghold.Mod.Serialization.flagDeserialize("BaseSettings",  this.m.BaseSettings, null, this.getFlags());
		this.m.LastEnterLog = ::Stronghold.Mod.Serialization.flagDeserialize("LastEnterLog",  this.m.LastEnterLog, null, this.getFlags());
		this.updateTown();
	}
});

