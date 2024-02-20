this.stronghold_screen_misc_module <- this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {
		Road = {
			// Cache it, reload it only after a road was build
			Map = {}
		},
		Gifts = {
			FactionMap = {},
			DistanceMap = {},
		}
	},

	function getUIData( _ret )
	{
		_ret.BuildRoad 			<- this.getRoadUIData();
		_ret.SendGifts 			<- this.getGiftUIData();
		_ret.TrainBrother 		<- this.getTrainingUIData();
		_ret.BuyWater 			<- this.getWaterUIData();
		_ret.HireMercenaries 	<- this.getMercenariesUIData();
		_ret.RemoveBase 		<- this.getRemoveBaseUIData();
		return _ret
	}

	function getRoadUIData()
	{
		local town = this.getTown();
		local tile = town.getTile();
		local settlements = this.World.EntityManager.getSettlements();
		local distances = [];
		local longestAllowedDistance = 0;
		local settlementOptions = [];
		local validSettlements = []
		local option;

		foreach (settlement in settlements)
		{

			if (settlement == null || settlement == town)
				continue
			if (settlement.getName() in this.m.Road.Map)
			{
				settlementOptions.push(this.m.Road.Map[settlement.getName()]);
				continue;
			}

			local dist = town.getTile().getDistanceTo(settlement.getTile());
			if (town.m.ConnectedToByRoads.len() != 0 && (dist > 60 || (distances.len() > 10 && dist > distances[10])))  continue;
			local results = town.getRoadCost(settlement);
			local cost = results[0]
			local roadmult = results[1]
			if (cost && cost != 0)
			{
				option = {
					Score = dist,
					Name = settlement.getName(),
					FactionName = settlement.getOwner().getName(),
					ID = settlement.getID(),
					Segments = cost,
					Cost = cost * ::Stronghold.PriceMult,
					Roadmult = roadmult * 100,
					IsValid = cost * ::Stronghold.PriceMult < this.World.Assets.getMoney(),
					UISprite = settlement.m.UISprite
				}
				settlementOptions.push(option);
				this.m.Road.Map[settlement.getName()] <- option;
				distances.push(dist);
				distances.sort();
			}
		}

		local roadSort = function(_d1, _d2){
			if (_d1.Cost < _d2.Cost)
			{
				return -1;
			}
			else if (_d1.Cost > _d2.Cost)
			{
				return 1;
			}

			return 0;
		}

		settlementOptions.sort(roadSort);
		return settlementOptions;
	}

	function onBuildRoad(_target)
	{
		local targetSettlement = this.World.getEntityByID(_target.ID);
		this.World.Assets.addMoney(-_target.Cost);
		this.getTown().buildRoad(targetSettlement, _target.Roadmult * 0.01);
		this.m.Road.Map = {};
		this.updateConnectedToByRoad();
		this.updateData(["Assets", "MiscModule"]);
	}

	function updateConnectedToByRoad()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local navSettings = this.World.getNavigator().createSettings();
		foreach (settlement in settlements)
		{
			local myTile = settlement.getTile();
			foreach( s in settlements )
			{
				if (s.getID() == settlement.getID() || settlement.isConnectedTo(s))
				{
					continue;
				}

				navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
				local path = this.World.getNavigator().findPath(myTile, s.getTile(), navSettings, 0);

				if (!path.isEmpty())
				{
					settlement.m.ConnectedTo.push(s.getID());
					s.m.ConnectedTo.push(settlement.getID());
				}
			}

			if (!settlement.isIsolated())
			{
				foreach( s in settlements )
				{
					if (s.getID() == settlement.getID() || settlement.isConnectedToByRoads(s))
					{
						continue;
					}

					navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost;
					navSettings.RoadOnly = true;
					local path = this.World.getNavigator().findPath(myTile, s.getTile(), navSettings, 0);

					if (!path.isEmpty())
					{
						settlement.m.ConnectedToByRoads.push(s.getID());
						s.m.ConnectedToByRoads.push(settlement.getID());
					}
				}
			}
		}
	}


	function getGiftUIData()
	{
		// SendGifts = main key
		local ret =
		{
			Price = 3000,
			Gifts = [],
			ReputationGain = 0,
			Factions = []
		}

		foreach (i, item in this.getTown().getStash().getItems())
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
			{
				ret.Gifts.push({
					Name = item.m.Name,
					ID = item.getID(),
					Icon = item.m.Icon,
					Value = item.m.Value
				});

				ret.ReputationGain += ::Math.abs(item.m.Value / 200)
			}
		}

		local factions = [];
		factions.extend(this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse));
		factions.extend(this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState));
		foreach (faction in factions)
		{
			if (faction.getID() in this.m.Gifts.FactionMap)
			{
				ret.Factions.push(this.m.Gifts.FactionMap[faction.getID()]);
				continue;
			}
			if (faction.getPlayerRelation() > 80)
				continue
			local militarySettlements = [];
			foreach (settlement in faction.getSettlements())
			{
				if ((faction.m.Type == this.Const.FactionType.OrientalCityState || settlement.isMilitary()) &&
					settlement.isConnectedToByRoads(this.getTown()))
				{
					militarySettlements.push(settlement);
				}
			}
			if (militarySettlements.len() > 0)
			{
				local chosenSettlement = this.getDistanceToTowns(this.getTown(), militarySettlements)
				local innerRet = {
					ID = faction.getID(),
					Name = faction.getName(),
					ImagePath = faction.getUIBanner(),
					Relation = faction.getPlayerRelationAsText(),
					RelationNum = this.Math.round(faction.getPlayerRelation()),
					IsHostile = !faction.isAlliedWithPlayer(),
					FactionName = faction.getName(),
					Distance = chosenSettlement.Distance,
					SettlementName = chosenSettlement.Settlement.getName(),
					SettlementID = chosenSettlement.Settlement.getID()
				}
				ret.Factions.push(innerRet);
				this.m.Gifts.FactionMap[faction.getID()] <- innerRet;
			}
		}
		ret.Factions.sort(function(_d1, _d2){
			if (_d1.RelationNum < _d2.RelationNum)
			{
				return -1;
			}
			else if (_d1.RelationNum > _d2.RelationNum)
			{
				return 1;
			}

			return 0;
		});
		return ret;
	}

	function onSendGift(_target)
	{
		local playerFaction = this.Stronghold.getPlayerFaction();
		local playerBase = this.getTown()
		local targetSettlement = this.World.getEntityByID(_target.SettlementID);

		local patrolStrength = 400 +  100 * (playerBase.getSize()-1)
		patrolStrength += playerBase.countAttachedLocations( "attached_location.militia_trainingcamp" ) * this.Stronghold.Locations["Militia_Trainingcamp"].MercenaryStrengthIncrease

		local party = playerFaction.spawnEntity(playerBase.getTile(), "Caravan of " + playerBase.getName(), true, this.Const.World.Spawn.Caravan, 100);
		this.Const.World.Common.assignTroops(party, this.Const.World.Spawn.Mercenaries, patrolStrength);
		party.setDescription("A caravan bringing gifts to " + targetSettlement.getName());
		party.setFootprintType(this.Const.World.FootprintsType.Caravan);
		party.getSprite("body").setBrush("cart_02")
		party.setVisibilityMult(1.0);
		party.setVisionRadius(this.Const.World.Settings.Vision * 0.25);
		party.getSprite("base").Visible = false;
		party.setVisibleInFogOfWar(true)
		party.setMirrored(true);
		party.getFlags().set("IsCaravan", true);
		party.getFlags().set("Stronghold_Caravan", true);

		// count and remove items
		local itemsToRemove = this.getTown().getStash().getItems().filter(@(_idx, _item)
			_item != null && _item.isItemType(this.Const.Items.ItemType.Loot)
		)
		local stash = this.getTown().getStash();
		foreach(item in itemsToRemove)
			stash.remove(item)



		//add orders to move to destination, 'unload' the gifts and get reputation, despawn
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);

		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(targetSettlement.getTile());
		move.setRoadsOnly(true);

		local unload = this.new("scripts/ai/world/orders/stronghold_unload_gifts_order");
		unload.m.Flags.set("DestinationFaction", _target.ID)
		unload.m.Flags.set("Destination", targetSettlement.getName())
		unload.m.Flags.set("Reputation", _target.ReputationGain)

		local despawn = this.new("scripts/ai/world/orders/despawn_order");

		c.addOrder(move)
		c.addOrder(unload)
		c.addOrder(despawn)
		return true;
	}

	function getDistanceToTowns(_origin, _destinations)
	{
		local chosenSettlement = null;
		local closestDist = 9999;

		foreach (settlement in _destinations)
		{
			if (settlement == null) continue
			local distance = settlement.getTile().getDistanceTo(_origin.getTile())
			if (chosenSettlement == null || distance < closestDist)
			{
				chosenSettlement = settlement;
				closestDist = distance;
			}
		}
		return {
			Settlement = chosenSettlement,
			Distance = closestDist
		}
	}

	function getTrainingUIData()
	{
		// TrainBrother
		local ret = {
			IsUnlocked = this.Stronghold.getPlayerFaction().m.Flags.get("Teacher"),
			ValidBrothers = [],
			Price = ::Stronghold.TrainerPrice * ::Stronghold.PriceMult,
		};
		if (!ret.IsUnlocked)
			return ret;

		local roster = [];
		roster.extend(this.World.getPlayerRoster().getAll());
		roster.extend(this.getTown().getLocalRoster());
		roster = roster.filter(function(idx, bro){
			return bro != null && bro.getLevel() < 11 && !bro.getSkills().hasSkill("effects.trained")
		});
		foreach (bro in roster)
		{
			ret.ValidBrothers.push(
			{
				Name = bro.getName(),
				ID = bro.getID()
			})
		}

		return ret;
	}

	function getWaterUIData()
	{
		local ret = {
			IsUnlocked = this.Stronghold.getPlayerFaction().m.Flags.get("Waterskin"),
			Price = ::Stronghold.WaterPrice * ::Stronghold.PriceMult,
		};
		if (!ret.IsUnlocked)
			return ret;
		return ret;
	}

	function getMercenariesUIData()
	{
		local ret = {
			IsUnlocked = this.Stronghold.getPlayerFaction().m.Flags.get("Mercenaries"),
			AlreadyHasMercenaries = false,
			Price = ::Stronghold.MercenaryPrice * ::Stronghold.PriceMult,
		};
		if (!ret.IsUnlocked)
			return ret;

		return ret;
	}

	function getRemoveBaseUIData()
	{
		local ret = {};
		return ret;
	}


	function onZoomToTargetCity(_townID)
	{
		this.World.getCamera().moveTo(this.World.getEntityByID(_townID));
	}
})
