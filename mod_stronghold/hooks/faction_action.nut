::mods_hookChildren("factions/faction_action", function(o){
	// Switcheroo to discount stronghold bases
	local getTileToSpawnLocation = ::mods_getMember(o, "getTileToSpawnLocation");
	::mods_override(o, "getTileToSpawnLocation", function(_maxTries = 10, _notOnTerrain = [], _minDistToSettlements = 7, _maxDistToSettlements = 1000, _maxDistanceToAllies = 1000, _minDistToEnemyLocations = 7, _minDistToAlliedLocations = 7, _nearTile = null, _minY = 0.0, _maxY = 1.0)
	{
		local entityManager = this.World.EntityManager.get();
		local getSettlements = entityManager.getSettlements;
		entityManager.getSettlements = function(){
			return getSettlements().filter(@(_idx, _settlement) _settlement.getFlags().get("IsPlayerBase") != true);
		}
		local ret = getTileToSpawnLocation(_maxTries, _notOnTerrain, _minDistToSettlements, _maxDistToSettlements, _maxDistanceToAllies, _minDistToEnemyLocations, _minDistToAlliedLocations, _nearTile, _minY, _maxY);
		entityManager.getSettlements = getSettlements;
		return ret;
	})

	local getDistanceToSettlements = ::mods_getMember(o,  "getDistanceToSettlements");
	::mods_override(o, "getDistanceToSettlements", function(_from)
	{
		local entityManager = this.World.EntityManager.get();
		local getSettlements = entityManager.getSettlements;
		entityManager.getSettlements = function(){
			return getSettlements().filter(@(_idx, _settlement) _settlement.getFlags().get("IsPlayerBase") != true);
		}
		local ret = getDistanceToSettlements(_from);
		entityManager.getSettlements = getSettlements;
		return ret;
	})
})
