this.stronghold_unload_order <- this.inherit("scripts/ai/world/world_behavior", {
	//unloads items from the caravan starting at the stronghold
	//adds food items to the storage building of the stronghold
	m = {},
	function create()
	{
		this.world_behavior.create();
		this.m.ID = this.Const.World.AI.Behavior.ID.Unload;
	}

	function onExecute( _entity, _hasChanged )
	{
		local entities = this.World.getAllEntitiesAndOneLocationAtPos(_entity.getPos(), 2.0);
		local settlement;
		foreach( ent in entities )
		{
			if (ent.getFlags().get("IsMainBase")) settlement = ent
		}
		this.getController().popOrder();
		if(settlement == null) return true

		local items = settlement.getWarehouse().getStash().getItems()
		local food = [];
		foreach( i, item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				food.push(item);
			}
		}
		//removes old food from storage
		foreach (item in food)
		{
			settlement.getWarehouse().getStash().remove(item)
		}

		foreach( item in _entity.getInventory() )
		{
			settlement.addImportedProduce(item);
		}
		_entity.clearInventory();

		return true;
	}

});

