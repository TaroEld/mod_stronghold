this.stronghold_patrol_roads_action <- this.inherit("scripts/factions/faction_action", {
	//Governs the spawning of stronghold patrols.
	m = {},
	function create()
	{
		this.m.ID = "stronghold_patrol_roads_action";
		//spawn them every 4 days
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 4;
		this.m.IsSettlementsRequired = true;
		this.m.Settlements <- null;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		//only works with level 2+ base
		local player_bases = _faction.getDevelopedBases()
		local nonIsolatedBases = []
		foreach(settlement in player_bases){
			if(!player_base.isIsolated()) nonIsolatedBases.push({Base = settlement, Connected = []})
		}
		if (nonIsolatedBases.len() == 0) return

		local connected_settlements = [];
		local friendly_factions = 0
		foreach (faction in this.World.FactionManager.getFactions())
		{
			if (faction != null && faction.m.PlayerRelation > 70 && (faction.m.Type == this.Const.FactionType.NobleHouse || faction.m.Type == this.Const.FactionType.OrientalCityState))
			{
				friendly_factions++
				foreach( playerbase in nonIsolatedBases)
				{
					foreach (settlement in faction.getSettlements())
					{
						if (settlement.isConnectedToByRoads(playerbase.Base))
						{
							playerbase.Connected.push(settlement)
						}
					}
				}
			}
		}
		local valid = []
		foreach (playerBase in nonIsolatedBases)
		{
			if (playerBase.Connected.len() > 2) valid.push(playerBase)
		}

		if (valid.len() < 3) {return}
		this.m.Settlements <- this.Math.randArray(valid);
		//the more friendlies, the more patrols spawn
		this.m.Cooldown = (this.World.getTime().SecondsPerDay * 7) / (friendly_factions.len()+1);
		this.m.Score = 10;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local player_base = this.m.Settlements.Base
		local patrol_strength = 200 * (player_base.getSize()-1)
		
		//add strength if you have the attachment
		if (player_base.hasAttachedLocation("attached_location.militia_trainingcamp")){
			patrol_strength += 200
		}
		local party = _faction.stronghold_spawnEntity(player_base.getTile(), "Mercenary patrol of " + player_base.getName(), true, this.Const.World.Spawn.Mercenaries, patrol_strength);
		party.m.OnCombatWithPlayerCallback = null;
		party.getSprite("body").setBrush(player_base.m.troopSprites);
		party.setDescription("A band of mercenaries patrolling the roads.");
		party.setFootprintType(this.Const.World.FootprintsType.Mercenaries);
		party.getFlags().set("Stronghold_Patrol", true);
		local c = party.getController();
		local index = 0;
		local valid = this.m.Settlements.Connected
		local target_settlements = [];
		while (valid.len() > 0 && index < 5)
		{
			local rng = this.Math.rand(0, valid.len() -1)
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
				
		local waypoint_1 = sort_settlements(player_base, target_settlements)
		local waypoint_2 = sort_settlements(waypoint_1, target_settlements)
		local sorted_list = [waypoint_1, waypoint_2, player_base];
		foreach (town in sorted_list)
		{
			local move = this.new("scripts/ai/world/orders/move_order");
			move.setDestination(town.getTile());
			move.setRoadsOnly(true);
			c.addOrder(move);
		}
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(despawn);
		return true;
	}

});

