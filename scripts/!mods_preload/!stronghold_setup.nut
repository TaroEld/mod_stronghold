local gt = this.getroottable();
gt.Stronghold <- {};
::mods_registerMod("mod_stronghold", 1.23);
::mods_queue("mod_stronghold", ">mod_MSU", function()
{	
	
	::mods_registerJS("mod_stronghold.js");
	::mods_registerCSS("mod_stronghold.css");
	
	this.include("stronghold/stronghold_settings")

	gt.Stronghold.setupVarious();
	delete gt.Stronghold.setupVarious;

	gt.Stronghold.setupVisuals();
	delete gt.Stronghold.setupVisuals;

	gt.Stronghold.setupMainManagementOptions();
	delete gt.Stronghold.setupMainManagementOptions;

	gt.Stronghold.setupLocationDefs();
	delete gt.Stronghold.setupLocationDefs;

	gt.Stronghold.setupBuildingDefs();
	delete gt.Stronghold.setupBuildingDefs;

	::mods_hookNewObjectOnce("states/world/asset_manager", function (o)
	{

		//don't consume food if wheat fields attached
		local consumeFood = o.consumeFood;		
		o.consumeFood = function()
		{
			if(this.Stronghold.getPlayerFaction() == null) return consumeFood()
			local playerBases = this.Stronghold.getPlayerFaction().getMainBases()
			foreach(playerBase in playerBases)
			{	
				if (playerBase.hasAttachedLocation("attached_location.wheat_fields") && this.World.State.getPlayer().getTile().getDistanceTo(playerBase.getTile()) < this.Stronghold.Locations["Wheat_Fields"].EffectRange)
				{
					return
				}
			}	
			return consumeFood()
		}
		
		local update = o.update;		
		o.update = function(_worldState)
		{			
			//set movementspeed and vision radius if watchtower location
			if(this.Stronghold.getPlayerFaction() == null) return update(_worldState)
			if (this.World.getTime().Hours != this.m.LastHourUpdated)
			{
				//check for ranger start and lookout follower
				local playerBases = this.Stronghold.getPlayerFaction().getMainBases()
				local isRangers = this.World.Assets.getOrigin().getID() == "scenario.rangers";
				local hasLookout = this.World.Retinue.hasFollower("follower.lookout");
				foreach(playerBase in playerBases)
				{	
					if (playerBase.hasAttachedLocation("attached_location.stone_watchtower") 
						&& this.World.State.getPlayer().getTile().getDistanceTo(playerBase.getTile()) < this.Stronghold.Locations["Stone_Watchtower"].EffectRange)
					{
						this.World.State.getPlayer().m.BaseMovementSpeed = isRangers ? 111 + this.Stronghold.Locations["Stone_Watchtower"].MovementSpeedIncrease : 105 + this.Stronghold.Locations["Stone_Watchtower"].MovementSpeedIncrease
						this.World.State.getPlayer().m.VisionRadius = hasLookout ? 625 + this.Stronghold.Locations["Stone_Watchtower"].VisionIncrease : 500 + this.Stronghold.Locations["Stone_Watchtower"].VisionIncrease
					}
					//if not in radius
					else
					{
						this.World.State.getPlayer().m.BaseMovementSpeed = isRangers ? 111 : 105
						this.World.State.getPlayer().m.VisionRadius = hasLookout ? 625 : 500 
					}
					//same for herbalist grove
					if (playerBase.hasAttachedLocation("attached_location.herbalist_grove") 
						&& this.World.State.getPlayer().getTile().getDistanceTo(playerBase.getTile()) < this.Stronghold.Locations["Herbalists_Grove"].EffectRange)
					{
						this.m.HitpointsPerHourMult = 1.4
					}
					else
					{
						this.m.HitpointsPerHourMult = 1.0
					}

					//stored brothers draw half wage
					if (this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8 && this.m.IsConsumingAssets)
					{
						foreach(bro in playerBase.getLocalRoster().getAll())
						{
							this.m.Money -= this.Math.floor(bro.getDailyCost()/2);
						}
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
				foreach(playerBase in this.Stronghold.getPlayerFaction().getMainBases()){
					foreach(bro in playerBase.getLocalRoster().getAll()){
						money += this.Math.floor(bro.getDailyCost()/2)
					}
				}
			}
			return money
		}

			
	});

	::mods_hookExactClass("entity/world/party", function(o){
		local party_onUpdate = o.onUpdate
		o.onUpdate = function()
		{
			if(this.Stronghold.getPlayerFaction() == null) return party_onUpdate()
			foreach(settlement in this.Stronghold.getPlayerFaction().getMainBases()){
				if (settlement.hasAttachedLocation("attached_location.stone_watchtower") 
					&& this.getTile().getDistanceTo(settlement.getTile()) < this.Stronghold.Locations["Stone_Watchtower"].VisionInFogOfWarRange)
				{
					this.setVisibleInFogOfWar(true);
					break;
				}
				else{
					this.setVisibleInFogOfWar(false);
				}
			}
			party_onUpdate();
		}
	})

	::mods_hookNewObject("ui/screens/world/modules/world_town_screen/town_shop_dialog_module", function(o){
		o.onReforgeIsValid <- function(_idx)
		{
			//check if in player base and store
			local town = this.World.State.getCurrentTown();
			if (!town.getFlags().get("IsMainBase") ||
				!town.hasAttachedLocation("attached_location.ore_smelters") ||
				this.World.State.getTownScreen().getShopDialogModule().getShop().m.ID != "building.storage_building")
			{
				return
				{
					IsValid = false
				}
			}

			local sourceItem = this.m.Shop.getStash().getItemAtIndex(_idx);
			if (sourceItem == null || sourceItem.item == null || !sourceItem.item.isItemType(this.Const.Items.ItemType.Named))
			{
				return { IsValid = false }
			}
			local price = sourceItem.item.m.Value * this.Stronghold.Locations["Ore_Smelter"].ReforgeMultiplier;

			return {
				IsValid = true,
				ItemIdx = _idx,
				ItemName = sourceItem.item.getName(),
				Price = price,
				Affordable = price < this.World.Assets.getMoney()
			}
		}

		o.onReforgeNamedItem <- function(_idx)
		{
			local sourceItem = this.m.Shop.getStash().removeByIndex(_idx);
			local name = sourceItem.getName();
			local type = sourceItem.ClassNameHash;
			local price = sourceItem.m.Value * this.Stronghold.Locations["Ore_Smelter"].ReforgeMultiplier;

			//can't savescum quite as easily
			if (!this.World.Flags.get("ReforgeNamedItemSeed"))
			{
				this.World.Flags.set("ReforgeNamedItemSeed", this.World.State.getCurrentTown().getFlags().get("RosterSeed"));
			}
			this.World.Flags.increment("ReforgeNamedItemSeed");
			this.Math.seedRandom(this.World.Flags.get("ReforgeNamedItemSeed"));

			local replacementItem = this.new(this.IO.scriptFilenameByHash(type));
			replacementItem.setName(name);
			this.World.Assets.addMoney(-price);
			this.m.Shop.getStash().add(replacementItem);
			this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
			local result = {
				Item = this.UIDataHelper.convertItemToUIData(replacementItem, true, null),
				Assets = this.m.Parent.queryAssetsInformation()
			};
			return result;
		}

		local onRepairItem = o.onRepairItem
		o.onRepairItem <- function(_itemIndex)
		{
			local town = this.World.State.getCurrentTown();
			if (!town.getFlags().get("IsMainBase") || !town.hasAttachedLocation("attached_location.blast_furnace"))
			{
				return onRepairItem(_itemIndex);
			}

			if (!this.m.Shop.isRepairOffered())
			{
				return null;
			}

			local item = this.Stash.getItemAtIndex(_itemIndex).item;

			if (item.getConditionMax() <= 1 || item.getCondition() >= item.getConditionMax())
			{
				return null;
			}

			local price = (item.getConditionMax() - item.getCondition()) * this.Const.World.Assets.CostToRepairPerPoint;
			local value = item.m.Value * (1.0 - item.getCondition() / item.getConditionMax()) * 0.2 * this.World.State.getCurrentTown().getPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()];
			price = this.Math.max(price, value) * this.Stronghold.Locations["Blast_Furnace"].RepairMultiplier;
			price = price.tointeger();

			if (this.World.Assets.getMoney() < price)
			{
				return null;
			}

			this.World.Assets.addMoney(-price);
			item.setCondition(item.getConditionMax());
			item.setToBeRepaired(false);
			this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
			local result = {
				Item = this.UIDataHelper.convertItemToUIData(item, true, this.Const.UI.ItemOwner.Stash),
				Assets = this.m.Parent.queryAssetsInformation()
			};
			this.World.Statistics.getFlags().increment("ItemsRepaired");
			return result;
		}
	})
	
	
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


	//to help adding retinue button
	::mods_hookNewObject("ui/screens/world/modules/world_campfire_screen/campfire_main_dialog_module", function ( o )
	{
		local queryData = o.queryData
		o.queryData <- function()
		{
			local result = queryData()
			local show = this.Stronghold.getPlayerFaction() == null || this.Stronghold.getPlayerFaction().getMainBases().len() < this.Stronghold.getMaxStrongholdNumber()
			result.Assets.showStrongholdButton <- show;
			return result;
		}
	});

	::mods_hookNewObject("ui/screens/world/world_campfire_screen", function ( o )
	{
		o.onStrongholdClicked <- function()
		{
			this.World.State.getMenuStack().popAll(true)
			local event = this.new("scripts/events/mod_stronghold/stronghold_intro_event")
			this.World.Events.m.Events.push(event)
			this.World.Events.fire(event.getID())
		};
	})

	
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
	
	//function to spawn units above pop cap
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
	//sends caravans to player base if relation is above 70, gives higher chance to be chosen
	::mods_hookExactClass("factions/actions/send_caravan_action", function ( o )
	{
		
		local onUpdate = o.onUpdate;
		o.onUpdate = function(_faction)
		{
			onUpdate(_faction)
			if (this.Stronghold.getPlayerFaction() == null) return
			local playerBase = this.Math.randArray(this.Stronghold.getPlayerFaction().getMainBases())
			if (playerBase == null || this.m.Score == 0 || this.m.Dest == playerBase) return;
			if (_faction.m.PlayerRelation < 70 || (this.m.Start.getOwner() != null && this.m.Start.getOwner().m.PlayerRelation < 70)) return;
			if (!this.isPathBetween(this.m.Start.getTile(), playerBase.getTile(), true)) return;
			local exists = false;
			foreach( situation in playerBase.m.Situations )
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
				this.m.Dest = playerBase
			}
		}
	});
	
	//calls custom unload order if stronghold is target. Otheriwse returns vanilla function, which does nothing
	::mods_hookExactClass("ai/world/orders/unload_order", function ( o )
	{
		local onExecute = o.onExecute;
		o.onExecute = function(_entity, _hasChanged)
		{
			local entities = this.World.getAllEntitiesAndOneLocationAtPos(_entity.getPos(), 1.0);
			foreach( settlement in entities )
			{
				if (settlement.isLocation() && settlement.isEnterable() && settlement.getFlags().get("IsMainBase"))
				{
					settlement.addSituation(this.new("scripts/entity/world/settlements/situations/stronghold_well_supplied_ai_situation"), 7);
					this.getController().popOrder();
					return true;
				}
			}
			return onExecute(_entity, _hasChanged)
		}
	});
	::mods_hookExactClass("factions/actions/patrol_roads_action", function ( o )
	{
		//adds stronghold as possible patrol option if friendly with the faction
		local onUpdate = o.onUpdate;
		o.onUpdate = function(_faction)
		{
			onUpdate(_faction)
			if (this.Stronghold.getPlayerFaction() == null) return
			local playerBase = this.Math.randArray(this.Stronghold.getPlayerFaction().getMainBases())
			if (this.m.Score == 0 || playerBase == null || _faction.m.PlayerRelation < 70) return;
			foreach( settlement in this.m.Settlements )
			{
				if (!this.isPathBetween(settlement.getTile(), playerBase.getTile(), true)) return;
			}
			this.m.Settlements.push(playerBase)
		}
		
		//needed for patrol to not start at player base. This whole thing is pretty jank, need to hook whole functions for small changes, would probably be better to separate entirely.
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
			if (waypoints[0].getFlags().get("IsMainBase"))
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
				if (key.getKey() == 41) // esc
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
				local playerBase = this.World.State.getCurrentTown()
				playerBase.m.Name = _data[0]
				playerBase.getFlags().set("CustomName", true)
				playerBase.getLabel("name").Text = _data[0];
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
		// adapt armorsmith discount tooltip
		local tactical_helper_addHintsToTooltip = o.tactical_helper_addHintsToTooltip;
		o.tactical_helper_addHintsToTooltip = function ( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
		{
			local result = tactical_helper_addHintsToTooltip( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked)
			local town = this.World.State.getCurrentTown();
			if (_itemOwner != "world-town-screen-shop-dialog-module.stash" || town == null || town.getCurrentBuilding() == null || !town.getCurrentBuilding().isRepairOffered() || !town.getFlags().get("IsMainBase") || !town.hasAttachedLocation("attached_location.blast_furnace"))
			{
				return result;
			}

			local price = (_item.getConditionMax() - _item.getCondition()) * this.Const.World.Assets.CostToRepairPerPoint;
			local value = _item.m.Value * (1.0 - _item.getCondition() / _item.getConditionMax()) * 0.2 * this.World.State.getCurrentTown().getPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()];
			price = this.Math.max(price, value) * this.Stronghold.Locations["Blast_Furnace"].RepairMultiplier;
			price = price.tointeger();
			foreach(entry in result){
				if("text" in entry && entry.text.find("to have it repaired") != null){
					entry.text = "Pay [img]gfx/ui/tooltips/money.png[/img]" + price + " to have it repaired"
					break;
				}
			}
			return result
		}

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
							text = "Rename your settlement"
						}
					];

				case "world-town-screen.main-dialog-module.Storage":
					return [
						{
							id = 1,
							type = "title",
							text = "Warehouse"
						},
						{
							id = 2,
							type = "description",
							text = "Your companies warehouse. Here, you can store items to retrieve them at a later date."
						}
					];

				case "world-town-screen.main-dialog-module.Management":
					return [
						{
							id = 1,
							type = "title",
							text = "The Keep"
						},
						{
							id = 2,
							type = "description",
							text = "Manage your settlement"
						}
					];

				case "stronghold-retinue-button":
					local ret = [
						{
							id = 1,
							type = "title",
							text = "Stronghold"
						},
						{
							id = 2,
							type = "description",
							text = "Click here to learn more about Stronghold."
						}
					];
					return ret;


					
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
		local townStash = this.World.State.getCurrentTown().getBuilding("building.storage_building").getStash()
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
		local townStash = this.World.State.getCurrentTown().getBuilding("building.storage_building").getStash()
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
		items.extend(this.World.State.getCurrentTown().getBuilding("building.storage_building").getStash().getItems())
		return items
	}
	::mods_hookBaseClass("crafting/blueprint", function ( o ) 
	{
		//adds items in storage building to crafting UI
		while("SuperName" in o) o=o[o.SuperName]
		local craftable = o.isCraftable
		o.isCraftable = function()
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && "isMainBase" in this.World.State.getCurrentTown() && this.World.State.getCurrentTown().isMainBase())
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
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && "isMainBase" in this.World.State.getCurrentTown() && this.World.State.getCurrentTown().isMainBase())
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
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && "isMainBase" in this.World.State.getCurrentTown() && this.World.State.getCurrentTown().isMainBase())
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

	// don't want to be able to pick player faction
	::mods_hookExactClass("factions/actions/send_greenskin_army_action", function(o)
	{
		local onExecute = o.onExecute;
		o.onExecute = function(_faction)
		{
			local entityManager = this.World.EntityManager.get();
			local old_getSettlements = entityManager.getSettlements;
			entityManager.getSettlements = function()
			{
				return ::Stronghold.removeStrongholdSettlements(this.m.Settlements);
			}
			local result = onExecute(_faction)
			entityManager.getSettlements = old_getSettlements;
			return result;
		}
	})

	::mods_hookExactClass("factions/actions/send_military_army_action", function(o)
	{
		local onExecute = o.onExecute;
		o.onExecute = function(_faction)
		{
			local entityManager = this.World.EntityManager.get();
			local old_getSettlements = entityManager.getSettlements;
			entityManager.getSettlements = function()
			{
				return ::Stronghold.removeStrongholdSettlements(this.m.Settlements);
			}
			local result = onExecute(_faction)
			entityManager.getSettlements = old_getSettlements;
			return result;
		}
	})

	::mods_hookExactClass("factions/actions/send_citystate_army_action", function(o)
	{
		local onExecute = o.onExecute;
		o.onExecute = function(_faction)
		{
			local entityManager = this.World.EntityManager.get();
			local old_getSettlements = entityManager.getSettlements;
			entityManager.getSettlements = function()
			{
				return ::Stronghold.removeStrongholdSettlements(this.m.Settlements);
			}
			local result = onExecute(_faction)
			entityManager.getSettlements = old_getSettlements;
			return result;
		}
	})

	::mods_hookExactClass("factions/actions/send_undead_army_action", function(o)
	{
		local onExecute = o.onExecute;
		o.onExecute = function(_faction)
		{
			local entityManager = this.World.EntityManager.get();
			local old_getSettlements = entityManager.getSettlements;
			entityManager.getSettlements = function()
			{
				return ::Stronghold.removeStrongholdSettlements(this.m.Settlements);
			}
			local result = onExecute(_faction)
			entityManager.getSettlements = old_getSettlements;
			return result;
		}
	})

	

});