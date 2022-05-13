//sends caravans to player base if relation is above 70, gives higher chance to be chosen
::mods_hookExactClass("factions/actions/send_caravan_action", function ( o )
{
	
	local onUpdate = o.onUpdate;
	o.onUpdate = function(_faction)
	{
		onUpdate(_faction)
		if (this.Stronghold.getPlayerFaction() == null) return
		local playerBase = ::MSU.Array.rand(this.Stronghold.getPlayerFaction().getMainBases())
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
		
		local chance = ::Math.round(100/this.World.EntityManager.getSettlements().len())
		if (!exists){
			chance = chance * 5
		}
		
		if (::Math.rand(0, 100) < chance){
			this.m.Dest = playerBase
		}
	}
});