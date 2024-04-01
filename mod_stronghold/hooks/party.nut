::mods_hookExactClass("entity/world/party", function(o){
	local party_onUpdate = o.onUpdate
	o.onUpdate = function()
	{
		if (this.Stronghold.getPlayerFaction() == null) return party_onUpdate();
		
		foreach(settlement in this.Stronghold.getPlayerFaction().getMainBases()){
			if (settlement.hasAttachedLocation("attached_location.stone_watchtower") 
				&& this.getTile().getDistanceTo(settlement.getTile()) <= settlement.getEffectRadius())
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
