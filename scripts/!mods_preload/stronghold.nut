::mods_registerMod("mod_stronghold", 0.995);
::mods_registerJS("mod_stronghold.js");
::mods_registerCSS("mod_stronghold.css");
::mods_queue("mod_stronghold", null, function()
{	

	
	::mods_hookNewObjectOnce("states/world/asset_manager", function (o)
	{
		
		//don't consume food if wheat fields attached
		local consumeFood = o.consumeFood;		
		o.consumeFood = function()
		{
			local player_base = this.Stronghold.getPlayerBase()
			if (player_base && player_base.hasAttachedLocation("attached_location.wheat_fields") && this.World.State.getPlayer().getTile().getDistanceTo(player_base.getTile()) < 25)
			{
				return
			}
			//else: vanilla function 
			consumeFood()
		}
		
		local update = o.update;		
		o.update = function(_worldState)
		{			
			//set movementspeed and vision radius if watchtower location
			if (this.World.getTime().Hours != this.m.LastHourUpdated)
			{
				//check for ranger start and lookout follower
				local player_base = this.Stronghold.getPlayerBase()
				if (player_base && player_base.hasAttachedLocation("attached_location.stone_watchtower") && this.World.State.getPlayer().getTile().getDistanceTo(player_base.getTile()) < 25)
				{
					if (this.World.Assets.getOrigin().getID() == "scenario.rangers")
					{
						this.World.State.getPlayer().m.BaseMovementSpeed = 120
					}
					else
					{
						this.World.State.getPlayer().m.BaseMovementSpeed = 111
					}
					
					if (this.World.Retinue.hasFollower("follower.lookout"))
					{
						this.World.State.getPlayer().m.VisionRadius = 750
					}
					else
					{
						this.World.State.getPlayer().m.VisionRadius = 625
					}
					
				}
				//if not in radius
				else
				{
					if (this.World.Assets.getOrigin().getID() == "scenario.rangers")
					{
						this.World.State.getPlayer().m.BaseMovementSpeed = 111
					}
					else
					{
						this.World.State.getPlayer().m.BaseMovementSpeed = 105
					}
					
					if (this.World.Retinue.hasFollower("follower.lookout"))
					{
						this.World.State.getPlayer().m.VisionRadius = 625
					}
					else
					{
						this.World.State.getPlayer().m.VisionRadius = 500
					}
				}
				//same for herbalist grove
				if (player_base && player_base.hasAttachedLocation("attached_location.herbalist_grove") && this.World.State.getPlayer().getTile().getDistanceTo(player_base.getTile()) < 25)
				{
					this.m.HitpointsPerHourMult = 1.2
				}
				else
				{
					this.m.HitpointsPerHourMult = 1.0
				}
				//stored brothers draw half wage
				if (player_base && this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8 && this.m.IsConsumingAssets)
				{
					local town_roster = this.World.getRoster(9999)
					foreach(bro in town_roster.getAll())
					{
						this.m.Money -= this.Math.floor(bro.getDailyCost()/2);
					}
				}
			}
			//then run vanilla updte
			update(_worldState)
		}

		//stored brothers draw half wage, for tooltip
		local getDailyMoneyCost = o.getDailyMoneyCost
		o.getDailyMoneyCost = function()
		{
			local money = getDailyMoneyCost()
			if (this.Stronghold.getPlayerBase())
			{
				foreach (bro in this.World.getRoster(9999).getAll())
				{
					money += this.Math.floor(bro.getDailyCost()/2)
				}
			}
			return money
		}

			
	});
	
	
	::mods_hookDescendants("items/item", function ( o )
	{
		// sets buy/sell price to 0 when using stronghold marketplace
		local getBuyPrice = ::mods_getMember(o, "getBuyPrice")
		local getSellPrice = ::mods_getMember(o, "getSellPrice")
		o.getBuyPrice <- function()
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().m.CurrentBuilding != null && this.World.State.getCurrentTown().m.CurrentBuilding.m.ID == "building.storage_building")
			{	
				return 0.0;
			}
			else
			{	
				return getBuyPrice();
			}
		}

		o.getSellPrice <- function()
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().m.CurrentBuilding != null && this.World.State.getCurrentTown().m.CurrentBuilding.m.ID == "building.storage_building")
			{	
				return 0.0;
			}
			else
			{
				return getSellPrice();
			}
		}
	});

	::mods_hookNewObject("ui/screens/world/modules/world_campfire_screen/campfire_main_dialog_module", function ( o )
	{
		//function to build/upgrade stronghold via retinue menu. Checks for a few things (quest active, already built, already fully upgraded, tile occupied)
		while (!("onCartClicked" in o)) o = o[o.SuperName];
		local onCartClicked = o.onCartClicked;
		o.onCartClicked = function()
		{
			local priceMult = this.Const.World.Stronghold.PriceMult
			local build_cost = this.Const.World.Stronghold.BuyPrices[0] * priceMult
			if (this.Stronghold.getPlayerBase() && this.Stronghold.getPlayerBase().getSize() != 3){
				build_cost = priceMult * this.Const.World.Stronghold.BuyPrices[this.Stronghold.getPlayerBase().getSize()]
			}
			onCartClicked();
			if (this.World.Retinue.getInventoryUpgrades() >= this.Const.World.InventoryUpgradeCosts.len())
			{
				local tile = this.World.State.getPlayer().getTile();

				if(this.Stronghold.getPlayerBase())
				{
					if(this.Stronghold.getPlayerBase().getSize() == 3){
							this.showDialogPopup("Stronghold", "You already have a fully upgraded stronghold!", null, null, true);
						}
					else if(this.World.Contracts.getActiveContract() != null)
						{
							this.showDialogPopup("Upgrade your stronghold", "You can't have an active contract when upgrading a stronghold!", null, null, true);
						}
					else{
						if(this.World.Assets.getMoney() < build_cost){
							this.showDialogPopup("Upgrade your stronghold", "You need " + build_cost + " crowns to upgrade your stronghold!", null, null, true);
						}
						else{
							this.showDialogPopup("Upgrade your stronghold", "You can pay " + build_cost + " crowns to upgrade your stronghold. \n This will add a building slot and increase the value of your trades. \n CAREFUL: You can only remove a stronghold that's not been upgraded. \n CAREFUL: The closest nobles or enemies will attempt to destroy your base. Defend it!", this.onUpgradePlayerBase.bindenv(this), null);
						}
					}
				}
				else{
					if (this.World.Assets.getMoney() >= build_cost){
						if (tile.IsOccupied)
						{
							this.showDialogPopup("Build a stronghold", "Tile is occupied, cannot build a stronghold here!", null, null, true);
						}
						else if(this.World.Contracts.getActiveContract() != null)
						{
							this.showDialogPopup("Build a stronghold", "You can't have an active contract when building a stronghold!", null, null, true);
						}
						else{
							this.showDialogPopup("Build a stronghold", "You can pay " + build_cost + " crowns to build a stronghold at this location. \n CAREFUL: You can only have one stronghold. You can remove this stronghold as long as you don't upgrade it. \n CAREFUL: The closest nobles or enemies will attempt to destroy your base. Defend it!", this.onPurchasePlayerBase.bindenv(this), null);
						}
					}
					else{
						this.showDialogPopup("Build a stronghold", "Gather " + build_cost + " crowns to build a stronghold!", null, null, true);
					}
				}		
			}
		};
		
		o.onPurchasePlayerBase <- function()
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
			player_base.updateTown();
			
			tile.IsOccupied = true;
			tile.TacticalType = this.Const.World.TerrainTacticalType.Urban;
			//spawn assailant quest
			local contract = this.new("scripts/contracts/contracts/stronghold_defeat_assailant_contract");
			contract.setEmployerID(player_faction.getRandomCharacter().getID());
			contract.setFaction(player_faction.getID());
			contract.setHome(player_base);
			contract.setOrigin(player_base);
			this.World.Contracts.addContract(contract);
			contract.start();
		};
		
		o.onUpgradePlayerBase <- function()
		{
			local priceMult = this.Const.World.Stronghold.PriceMult
			local build_cost = this.Const.World.Stronghold.BuyPrices[0] * priceMult
			if (this.Stronghold.getPlayerBase() && this.Stronghold.getPlayerBase().getSize() != 3){
				build_cost = priceMult * this.Const.World.Stronghold.BuyPrices[this.Stronghold.getPlayerBase().getSize()]
			}
			this.World.Assets.addMoney(-build_cost);
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
		};
	});
	

	::mods_hookNewObject("entity/world/settlements/buildings/port_building", function ( o )
	{
		
		while (!("isHidden" in o)) o = o[o.SuperName];
		local isHidden = o.isHidden;
		o.isHidden = function()
		{
			if (this.Stronghold.getPlayerBase() && ("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() == this.Stronghold.getPlayerBase())
			{
				return false
			}
			else
			{
				return isHidden()
			}
		}
	});

	::mods_hookBaseClass("entity/world/location", function ( o )
	{
		//point is to not reduce named item chance based on the  stronghold. first rolls normal onspawned, then adds nameds based on difference of distance. Math is probably off
		
		while (!("onSpawned" in o)) o = o[o.SuperName];
		local onSpawned = o.onSpawned;
		o.onSpawned = function()
		{ 
			onSpawned()
			if (this.Stronghold.getPlayerFaction() != null && this.Stronghold.getPlayerFaction().getSettlements().len() > 0)
			{
				local loot = this.m.Loot.getItems();
				local named_count = 0;
				foreach( item in loot )
				{
					if (item.isItemType(this.Const.Items.ItemType.Named))
					{
						named_count++
					}
				}
				if (named_count > 1){
					return
				}
				local playerBases = []
				foreach (set in this.Stronghold.getPlayerFaction().getSettlements()) playerBases.push(set.getID())

				local location_tile = this.getTile();
				local locationToSettlementDist = 9999;
				local closest_settlement;
				
				foreach( sett in this.World.EntityManager.getSettlements() )
				{
					local d =  location_tile.getDistanceTo(sett.getTile());
					if (d < locationToSettlementDist)
					{
						locationToSettlementDist = d;
						closest_settlement = sett
					}
					
				}
				if (playerBases.find(closest_settlement.getID()) == null){
					return;
				}

				local nearest_dist = 9000;
				foreach( s in this.World.EntityManager.getSettlements() )
				{
					if (playerBases.find(s.getID()) == null)
					{
						local d =  location_tile.getDistanceTo(s.getTile());
						if (d < nearest_dist)
						{
							nearest_dist = d;
						}
					}
				}

				local distance_modifier = sqrt(nearest_dist*nearest_dist - locationToSettlementDist*locationToSettlementDist)
				if (!this.isLocationType(this.Const.World.LocationType.Unique))
				{
					for( local chance = (this.m.Resources + distance_modifier * 4) / 5.0 - 37.0; named_count < 2;  )
					{
						local r = this.Math.rand(1, 100);

						if (r <= chance)
						{
							chance = chance - r;
							named_count++;
							local type = this.Math.rand(20, 100);

							if (type <= 40)
							{
								local weapons = clone this.Const.Items.NamedWeapons;

								if (this.m.NamedWeaponsList != null && this.m.NamedWeaponsList.len() != 0)
								{
									weapons.extend(this.m.NamedWeaponsList);
									weapons.extend(this.m.NamedWeaponsList);
								}

								this.m.Loot.add(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
							}
							else if (type <= 60)
							{
								local shields = clone this.Const.Items.NamedShields;

								if (this.m.NamedShieldsList != null && this.m.NamedShieldsList.len() != 0)
								{
									shields.extend(this.m.NamedShieldsList);
									shields.extend(this.m.NamedShieldsList);
								}

								this.m.Loot.add(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
							}
							else if (type <= 80)
							{
								local helmets = clone this.Const.Items.NamedHelmets;

								if (this.m.NamedHelmetsList != null && this.m.NamedHelmetsList.len() != 0)
								{
									helmets.extend(this.m.NamedHelmetsList);
									helmets.extend(this.m.NamedHelmetsList);
								}

								this.m.Loot.add(this.new("scripts/items/" + helmets[this.Math.rand(0, helmets.len() - 1)]));
							}
							else if (type <= 100)
							{
								local armor = clone this.Const.Items.NamedArmors;

								if (this.m.NamedArmorsList != null && this.m.NamedArmorsList.len() != 0)
								{
									armor.extend(this.m.NamedArmorsList);
									armor.extend(this.m.NamedArmorsList);
								}
								this.m.Loot.add(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
							}
						}
						else
						{
							break;
						}
					}
				}
				
			}
		}
	});
	
	local stronghold_assignTroops = function ( _party, _partyList, _resources, _weightMode = 1)
	{
		
		//this function circumvents the max party sizes. initially had it used universally, now only during  specific calls
		local max_resources = _resources
		local selected_party;
		while (_resources > 15)
		{
			selected_party = this.Const.World.Common.assignTroops( _party, _partyList, _resources, _weightMode = 1)
			foreach (t in _party.m.Troops)
			{
				_resources -= t.Cost
			}
		}

		_party.updateStrength();
		return selected_party;
		
	}
		
	::mods_hookChildren("factions/faction", function ( o )
	{
		o.stronghold_spawnEntity <- function( _tile, _name, _uniqueName, _template, _resources )
		{
			//same as vanilla
			local party = this.World.spawnEntity("scripts/entity/world/party", _tile.Coords);
			party.setFaction(this.getID());

			if (_uniqueName)
			{
				_name = this.getUniqueName(_name);
			}

			party.setName(_name);
			local t;

			if (_template != null)
			{
				//except for this line, allowing more than unit cap
				t = stronghold_assignTroops(party, _template, _resources);
			}

			party.getSprite("base").setBrush(this.m.Base);

			if (t != null)
			{
				party.getSprite("body").setBrush(t.Body);
			}

			if (this.m.BannerPrefix != "")
			{
				party.getSprite("banner").setBrush(this.m.BannerPrefix + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner));
			}

			this.addUnit(party);
			return party;
		}
		
		
	})
	
	::mods_hookNewObject("factions/actions/send_caravan_action", function ( o )
	{
		
		//sends caravans to player base if relation is above 70, gives higher chance to be chosen
		while (!("onUpdate" in o)) o = o[o.SuperName];
		local onUpdate = o.onUpdate;
		o.onUpdate = function(_faction)
		{
			onUpdate(_faction)
			if (this.m.Score == 0 || !this.Stronghold.getPlayerBase() || this.m.Dest == this.Stronghold.getPlayerBase()) return;
			if (_faction.m.PlayerRelation < 70 || (this.m.Start.getOwner() != null && this.m.Start.getOwner().m.PlayerRelation < 70)) return;
			if (!this.isPathBetween(this.m.Start.getTile(), this.Stronghold.getPlayerBase().getTile(), true)) return;
			local exists = false;
			foreach( situation in this.Stronghold.getPlayerBase().m.Situations )
			{
				if (situation.getID() == "situation.stronghold_well_supplied_ai")
				{
					exists = true
				}
			}
			
			local chance = this.Math.round(100/this.World.EntityManager.getSettlements().len())
			if (!exists){
				chance = chance * 5
			}
			
			if (this.Math.rand(0, 100) < chance){
				this.m.Dest = this.Stronghold.getPlayerBase()
			}
		}
	});
	
	//calls custom unload order if stronghold is target. Otheriwse returns vanilla function, which does nothing
	::mods_hookNewObject("ai/world/orders/unload_order", function ( o )
	{
		while (!("onExecute" in o)) o = o[o.SuperName];
		local onExecute = o.onExecute;
		o.onExecute = function(_entity, _hasChanged)
		{
			local entities = this.World.getAllEntitiesAndOneLocationAtPos(_entity.getPos(), 1.0);
			local playerBase = this.Stronghold.getPlayerBase()
			foreach( settlement in entities )
			{
				if (settlement.isLocation() && settlement.isEnterable())
				{
					if (playerBase && settlement.getID() == playerBase.getID())
					{
						settlement.addSituation(this.new("scripts/entity/world/settlements/situations/stronghold_well_supplied_ai_situation"), 7);
						this.getController().popOrder();
						return true;
					}
				}
			}
			return onExecute(_entity, _hasChanged)
		}
	});
	::mods_hookNewObject("factions/actions/patrol_roads_action", function ( o )
	{
		//adds stronghold as possible patrol option if friendly with the faction
		while (!("onUpdate" in o)) o = o[o.SuperName];
		local onUpdate = o.onUpdate;
		o.onUpdate = function(_faction)
		{
			onUpdate(_faction)
			if (this.m.Score == 0 || !this.Stronghold.getPlayerBase() || _faction.m.PlayerRelation < 70) return;
			foreach( settlement in this.m.Settlements )
			{
				if (!this.isPathBetween(settlement.getTile(), this.Stronghold.getPlayerBase().getTile(), true)) return;
			}
			this.m.Settlements.push(this.Stronghold.getPlayerBase())
		}
		
		//needed for patrol to not start at player base. This whole thing is pretty jank, need to hook whole functions for small changes, would probably be better to separate entirely.
		while (!("onExecute" in o)) o = o[o.SuperName];
		local onExecute = o.onExecute;
		o.onExecute = function(_faction)
		{
			local waypoints = [];

			for( local i = 0; i != 3; i = ++i )
			{
				local idx = this.Math.rand(0, this.m.Settlements.len() - 1);
				local wp = this.m.Settlements[idx];
				this.m.Settlements.remove(idx);
				waypoints.push(wp);
			}
			//change here
			if (this.Stronghold.getPlayerBase() && waypoints[0].getID() == this.Stronghold.getPlayerBase().getID())
			{
				local temp = waypoints.remove(0)
				waypoints.insert(1, temp)
			}
			local party = this.getFaction().spawnEntity(waypoints[0].getTile(), waypoints[0].getName() + " Company", true, this.Const.World.Spawn.Noble, this.Math.rand(120, 250) * this.getReputationToDifficultyLightMult());
			party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + _faction.getBannerString());
			party.setDescription("Professional soldiers in service to local lords.");
			party.setFootprintType(this.Const.World.FootprintsType.Nobles);
			party.getLoot().Money = this.Math.rand(50, 200);
			party.getLoot().ArmorParts = this.Math.rand(0, 25);
			party.getLoot().Medicine = this.Math.rand(0, 5);
			party.getLoot().Ammo = this.Math.rand(0, 30);
			local r = this.Math.rand(1, 4);

			if (r == 1)
			{
				party.addToInventory("supplies/bread_item");
			}
			else if (r == 2)
			{
				party.addToInventory("supplies/roots_and_berries_item");
			}
			else if (r == 3)
			{
				party.addToInventory("supplies/dried_fruits_item");
			}
			else if (r == 4)
			{
				party.addToInventory("supplies/ground_grains_item");
			}

			local c = party.getController();
			local move1 = this.new("scripts/ai/world/orders/move_order");
			move1.setRoadsOnly(true);
			move1.setDestination(waypoints[1].getTile());
			local wait1 = this.new("scripts/ai/world/orders/wait_order");
			wait1.setTime(20.0);
			local move2 = this.new("scripts/ai/world/orders/move_order");
			move2.setRoadsOnly(true);
			move2.setDestination(waypoints[2].getTile());
			local wait2 = this.new("scripts/ai/world/orders/wait_order");
			wait2.setTime(20.0);
			local move3 = this.new("scripts/ai/world/orders/move_order");
			move3.setRoadsOnly(true);
			move3.setDestination(waypoints[0].getTile());
			local despawn = this.new("scripts/ai/world/orders/despawn_order");
			c.addOrder(move1);
			c.addOrder(wait1);
			c.addOrder(move2);
			c.addOrder(wait2);
			c.addOrder(move3);
			c.addOrder(despawn);
			this.m.Cooldown = this.World.FactionManager.isGreaterEvil() ? 200.0 : 400.0;
			return true;
		}	
	})
	
	::mods_hookNewObject("states/world_state", function (o)
	{
		//block changing to character screen if changing name of stronghold
		local showCharacterScreenFromTown = o.showCharacterScreenFromTown
		o.showCharacterScreenFromTown = function()
		{
			if ("PopupDialogVisible" in this.World.State.getTownScreen().getMainDialogModule().m){
				if (this.World.State.getTownScreen().getMainDialogModule().m.PopupDialogVisible) return;
			}
			return showCharacterScreenFromTown()
		}

		//llws esc in base management
		local keyHandler = o.helper_handleContextualKeyInput;
		o.helper_handleContextualKeyInput = function(key)
		{
			if(!keyHandler(key) && key.getState() == 0)
			{
				if (key.getKey() == 41)
				{
					foreach (contract in this.World.Contracts.m.Open)
					{
						if ("onEscPressed" in contract){
							contract.onEscPressed()
							return
						}
					}
				}
			}
		}

	});
	
	::mods_hookNewObject("ui/screens/world/modules/world_town_screen/town_main_dialog_module", function ( o )
	{
		//renames town and updates it, sets flag it doesn't get overwritten
		o.renameTown <- function(_data)
		{
			if (_data[0].len() > 0)
			{
				local player_base = this.World.State.getCurrentTown()
				player_base.m.Name = _data[0]
				player_base.getFlags().set("CustomName", true)
				player_base.getLabel("name").Text = _data[0];
				this.reload()
			}
		}
		
		//loads the click function into the town screen if the base is the player base
		o.loadRename <- function()
		{
			this.m.JSHandle.asyncCall("loadRenameUI", null);
		}
		//deletes the click function upon leaving
		o.deleteRename <- function()
		{
			this.m.JSHandle.asyncCall("deleteRenameUI", null);
		}
		//tells backend that its visible so that input to change screen can be blocked
		o.onRenameTownVisible <- function(_data)
		{
			this.m.PopupDialogVisible <- _data;
		}
	});

	::mods_hookNewObject("ui/screens/tooltip/tooltip_events", function ( o )
	{
		local general_queryUIElementTooltipData = o.general_queryUIElementTooltipData
		o.general_queryUIElementTooltipData = function( _entityId, _elementId, _elementOwner )
		{
			local entity;

			if (_entityId != null)
			{
				entity = this.Tactical.getEntityByID(_entityId);
			}

			switch(_elementId)
			{
				case "world-town-screen.main-dialog-module.RenameButton":
					return [
						{
							id = 1,
							type = "title",
							text = "Rename"
						},
						{
							id = 2,
							type = "description",
							text = "Rename your stronghold"
						}
					];

				case "world-town-screen.main-dialog-module.Storage":
					return [
						{
							id = 1,
							type = "title",
							text = "Storage"
						},
						{
							id = 2,
							type = "description",
							text = "Store and retrieve items"
						}
					];

				case "world-town-screen.main-dialog-module.Management":
					return [
						{
							id = 1,
							type = "title",
							text = "Management"
						},
						{
							id = 2,
							type = "description",
							text = "Manage your town"
						}
					];


					
			}
			return general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
		}
	});

	local consumeStashItemsVanilla = function(){
		if (!this.isQualified())
		{
			return;
		}

		this.updateAchievement("IMadeThis", 1, 1);
		this.World.Statistics.getFlags().increment("ItemsCrafted", 1);
		this.World.Ambitions.updateUI();
		local globalStash = this.World.Assets.getStash();
		local townStash = this.Stronghold.getPlayerBase().getBuilding("building.storage_building").getStash()
		local hasAlchemist = this.World.Retinue.hasFollower("follower.alchemist");
		local stash = globalStash
		foreach( c in this.m.PreviewComponents )
		{
			for( local j = 0; j < c.Num; j = ++j )
			{
				if (!stash.getItemByID(c.Instance.getID())) stash = townStash
				local item = stash.getItemByID(c.Instance.getID());

				if (!hasAlchemist || item.getMagicNumber() > 25)
				{
					stash.remove(item);
				}
				else
				{
					item.setMagicNumber(this.Math.rand(1, 100));
				}
				stash = globalStash
			}
		}
		++this.m.TimesCrafted;
		this.onCraft(stash);
	}

	local consumeStashItemsLegends = function(){
		if (!this.isQualified())
		{
			return;
		}

		this.updateAchievement("IMadeThis", 1, 1);
		local globalStash = this.World.Assets.getStash();
		local townStash = this.Stronghold.getPlayerBase().getBuilding("building.storage_building").getStash()
		local hasAlchemist = this.World.Retinue.hasFollower("follower.alchemist");
		local stash = globalStash

		foreach( c in this.m.PreviewComponents )
		{
			if ("LegendsArmor" in c)
			{
				if (c.LegendsArmor && !this.LegendsMod.Configs().LegendArmorsEnabled())
				{
					continue;
				}

				if (!c.LegendsArmor && this.LegendsMod.Configs().LegendArmorsEnabled())
				{
					continue;
				}
			}

			for( local j = 0; j < c.Num; j++ )
			{
				if (!stash.getItemByID(c.Instance.getID())) stash = townStash
				local item = stash.getItemByID(c.Instance.getID());

				if (!hasAlchemist || item.getMagicNumber() > 25)
				{
					stash.remove(item);
				}
				else
				{
					item.setMagicNumber(this.Math.rand(1, 100));
				}
				stash = globalStash
			}
		}

		++this.m.TimesCrafted;
		this.onCraft(stash);
	}

	local getCombinedStash = function()
	{
		local items = []
		items.extend(this.World.Assets.getStash().m.Items);
		items.extend(this.Stronghold.getPlayerBase().getBuilding("building.storage_building").getStash().getItems())
		return items
	}
	::mods_hookBaseClass("crafting/blueprint", function ( o )
	{
		//adds items in storage building to crafting UI
		while("SuperName" in o) o=o[o.SuperName]
		local craftable = o.isCraftable
		o.isCraftable = function()
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && "isPlayerBase" in this.World.State.getCurrentTown().m)
			{

				local getStash = this.World.Assets.getStash().getItems
				this.World.Assets.getStash().getItems = getCombinedStash
				local result = craftable()
				this.World.Assets.getStash().getItems = getStash
				return result
			}
			else
			{
				return craftable()
			}
		}

		local craft = o.craft
		o.craft = function()
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && "isPlayerBase" in this.World.State.getCurrentTown().m)
			{
				return ("LegendsMod" in this.getroottable() ? consumeStashItemsLegends() : consumeStashItemsVanilla())			
			}
			else{
				return craft()
			}
		}

		local getIngredients = o.getIngredients
		o.getIngredients = function()
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && "isPlayerBase" in this.World.State.getCurrentTown().m)
			{
				local getStash = this.World.Assets.getStash().getItems
				this.World.Assets.getStash().getItems = getCombinedStash
				local result = getIngredients()
				this.World.Assets.getStash().getItems = getStash
				return result
			}
			else{
				return getIngredients()
			}
		}
	})
});