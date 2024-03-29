this.collector_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Collector";
		this.m.ID = "attached_location.collector";
		this.m.Description = "A collector of various common and rare natural goods.";
		this.m.Sprite = "stronghold_world_collector_location";
		this.m.SpriteDestroyed = "stronghold_world_collector_location";
	}

	function stronghold_updateLocationEffects(_daysPassed)
	{
		local baseArray = [];
		local basePath = "scripts/items/misc/";
		local generated = 0;
		for (local i = 0; i < this.m.Level; ++i)
		{
			baseArray.extend(::Stronghold.CollectorItemsByLevel[i]);
		}
		for (local i = 0; i < _daysPassed; ++i)
		{
			if (::Math.rand(0, 100) > ::Stronghold.Locations.Collector.Chance)
				continue;
			generated++;
			local item = ::new(basePath + ::MSU.Array.rand(baseArray).Path);
			this.getSettlement().addItemToWarehouse(item);
		}
		return generated;
	}

	function onSerialize(_out)
	{
		this.attached_location.onSerialize(_out);
	}

	function onDeserialize(_in)
	{
		this.attached_location.onDeserialize(_in);
	}
})
