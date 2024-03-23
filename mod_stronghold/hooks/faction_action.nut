// ::mods_hookDescendants("factions/faction_action", function(o){
// 	// Switcheroo to discount stronghold bases
// 	local getTileToSpawnLocation = ::o.getTileToSpawnLocation;
// 	o.getTileToSpawnLocation = function(_maxTries = 10, _notOnTerrain = [], _minDistToSettlements = 7, _maxDistToSettlements = 1000, _maxDistanceToAllies = 1000, _minDistToEnemyLocations = 7, _minDistToAlliedLocations = 7, _nearTile = null, _minY = 0.0, _maxY = 1.0)
// 	{
// 		local getSettlements = this.World.EntityManager.getSettlements();
// 		this.World.EntityManager.getSettlements = function(){
// 			return getSettlements().filter(@(_idx, _settlement) _settlement.getFlags().get("isPlayerBase") != true);
// 		}
// 		local ret = getTileToSpawnLocation(_maxTries, _notOnTerrain, _minDistToSettlements, _maxDistToSettlements, _maxDistanceToAllies, _minDistToEnemyLocations, _minDistToAlliedLocations, _nearTile, _minY, _maxY);
// 		this.World.EntityManager.getSettlements = getSettlements;
// 		return ret;
// 	}
// })
