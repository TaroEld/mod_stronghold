this.stronghold_patrol_roads_action <- this.inherit("scripts/factions/faction_action", {
	//Governs the spawning of stronghold patrols.
	m = {

	},
	function create()
	{
		this.m.ID = "stronghold_patrol_roads_action";
		//spawn them every 4 days
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 1;
		this.m.IsSettlementsRequired = true;
		this.m.Settlements <- null;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		//only works with level 2+ base
		local playerFaction = this.Stronghold.getPlayerFaction();
		local playerBases = _faction.getDevelopedBases()
		local nonIsolatedBases = []
		local settlements = this.World.EntityManager.getSettlements();

		foreach(playerBase in playerBases){
			if (playerBase.isIsolated() || !::Stronghold.isCooldownExpired(playerBase, "TimeUntilNextPatrol") || playerBase.isUpgrading()) continue

			local connected = []
			foreach (settlement in settlements)
			{
				if (settlement.getID() == playerBase.getID()) continue
				if (settlement.getOwner().m.Type == this.Const.FactionType.Player && !settlement.isMainBase()) continue
				if (!playerBase.isConnectedToByRoads(settlement)) continue
				if (settlement.getOwner() == null || settlement.getOwner().isAlliedWith(playerFaction.getID()))
				{
					connected.push(settlement)
				}
			}
			if (connected.len() > 2){
				nonIsolatedBases.push({Base = playerBase, Connected = connected})
			}
		}
		if (nonIsolatedBases.len() == 0) return
		this.m.Settlements <- ::MSU.Array.rand(nonIsolatedBases);
		//the more friendlies, the more patrols spawn
		//this.m.Cooldown = (this.World.getTime().SecondsPerDay * 7) / (friendly_factions.len()+1);
		this.m.Score = 100;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local playerBase = this.m.Settlements.Base
		local partyStrength = 100 * (playerBase.getSize());
		local trainingCamp = playerBase.getLocation( "attached_location.militia_trainingcamp" );
		if (trainingCamp)
			partyStrength += trainingCamp.getAlliedPartyStrengthIncrease();
		partyStrength *=  this.getReputationToDifficultyLightMult();
		

		local party = _faction.spawnEntity(playerBase.getTile(), "Mercenary patrol of " + playerBase.getName(), true, this.Const.World.Spawn.Mercenaries, partyStrength);
		party.m.OnCombatWithPlayerCallback = null;
		party.getSprite("body").setBrush(playerBase.m.troopSprites);
		party.setDescription("A band of mercenaries patrolling the roads.");
		party.setFootprintType(this.Const.World.FootprintsType.Mercenaries);
		party.getFlags().set("Stronghold_Patrol", true);
		local c = party.getController();
		local index = 0;
		local valid = this.m.Settlements.Connected
		local target_settlements = [];
		while (valid.len() > 0 && index < 5)
		{
			local rng = ::Math.rand(0, valid.len() -1)
			target_settlements.push(valid[rng])
			valid.remove(rng)
			index++
		}
		local sort_settlements;
		sort_settlements = function(_start, _settlements)
		{
			local sorted_list = clone _settlements
			local furthest = null;
			local furthest_dist = 0
			foreach (set in sorted_list){
				local dist = set.getTile().getDistanceTo(_start.getTile())
				if(furthest == null || furthest_dist < dist){
					furthest = set;
					furthest_dist = dist
				}
			}
			return furthest
		}	
				
		local waypoint_1 = sort_settlements(playerBase, target_settlements)
		local waypoint_2 = sort_settlements(waypoint_1, target_settlements)
		local sorted_list = [waypoint_1, waypoint_2, playerBase];
		foreach (town in sorted_list)
		{
			local move = this.new("scripts/ai/world/orders/move_order");
			move.setDestination(town.getTile());
			move.setRoadsOnly(true);
			c.addOrder(move);
		}
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(despawn);
		::Stronghold.setCooldown(playerBase, "TimeUntilNextPatrol");
		return true;
	}

});

