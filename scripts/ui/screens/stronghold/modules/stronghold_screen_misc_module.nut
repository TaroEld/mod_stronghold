this.stronghold_screen_misc_module <- this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {
		Road = {
			// Cache it, reload it only after a road was build
			Map = {}
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


	function getGiftOptions()
	function getGiftUIData()
	{
		local ret =
		{
			Gifts = [],
			Factions = []
		}

		foreach (i, item in this.getTown().getStash().getItems())
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
			{
				ret.Gifts.push({
					Name = item.m.Name,
					Icon = item.m.Icon
				});
			}
		}

		local factions = [];
		factions.extend(this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse));
		factions.extend(this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState));
		foreach (faction in factions)
		{
			::logInfo(faction.getName())
			if (faction.getPlayerRelation() > 80)
			{
				continue
			}
			local militarySettlements = [];
			foreach (settlement in faction.getSettlements())
			{
				::logInfo(faction.m.Type == this.Const.FactionType.OrientalCityState || settlement.isMilitary())
				::logInfo(settlement.isConnectedToByRoads(this.getTown()))
				::MSU.Log.printData(this.getTown().m.ConnectedToByRoads)
				if ((faction.m.Type == this.Const.FactionType.OrientalCityState || settlement.isMilitary()) &&
					settlement.isConnectedToByRoads(this.getTown()))
				{
					::logInfo(settlement.getName())
					militarySettlements.push(settlement);
				}
			}
			if (militarySettlements.len() > 0)
			{
				local chosenSettlement = this.getDistanceToTowns(this.getTown(), militarySettlements)
				::logInfo(chosenSettlement)
				ret.Factions.push
				({
					ID = faction.getID(),
					Name = faction.getName(),
					ImagePath = faction.getUIBanner(),
					Relation = faction.getPlayerRelationAsText(),
					RelationNum = this.Math.round(faction.getPlayerRelation()),
					IsHostile = !faction.isAlliedWithPlayer(),
					FactionName = faction.getName(),
					Distance = chosenSettlement.Distance,
					SettlementName = chosenSettlement.Settlement.getName(),

				})
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

	function onZoomToTargetCity(_townID)
	{
		this.World.getCamera().moveTo(this.World.getEntityByID(_townID));
	}
})
