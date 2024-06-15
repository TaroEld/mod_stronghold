::mods_hookExactClass("entity/world/location", function ( o )
{
	local onSpawned = o.onSpawned;
	o.onSpawned = function()
	{
		local entityManager = this.World.EntityManager.get();
		local getSettlements = entityManager.getSettlements;
		entityManager.getSettlements = function(){
			return getSettlements().filter(@(_idx, _settlement) _settlement.getFlags().get("IsPlayerBase") != true);
		}
		local ret = onSpawned();
		entityManager.getSettlements = getSettlements;
		return ret;
	}
})
