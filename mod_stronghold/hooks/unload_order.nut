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