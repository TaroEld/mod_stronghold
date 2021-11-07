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
		local settlement = this.Stronghold.getPlayerBase()
		this.getController().popOrder();
		if(!settlement) return true

		local items = settlement.getBuilding("building.storage_building").getStash().getItems()
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
			settlement.getBuilding("building.storage_building").getStash().remove(item)
		}

		foreach( item in _entity.getInventory() )
		{
			settlement.addImportedProduce(item);
		}
		_entity.clearInventory();

		return true;
	}

});

