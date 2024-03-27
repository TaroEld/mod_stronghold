this.collector_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {
		ItemOverflow = []
	},
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
		::logInfo("stronghold_updateLocationEffects collector")
		local baseArray = [];
		local basePath = "scripts/items/misc/";
		local stash = this.getSettlement().getStash();
		local generated = 0;
		::logInfo("a")
		for (local i = 0; i < this.m.Level; ++i)
		{
			::logInfo(i)
			baseArray.extend(::Stronghold.CollectorItemsByLevel[i]);
		}
		::logInfo("b")
		for (local i = 0; i < _daysPassed; ++i)
		{
			::logInfo(i)
			if (::Math.rand(0, 100) > ::Stronghold.Locations.Collector.Chance)
				continue;
			generated++;
			local item = ::MSU.Array.rand(baseArray);
			if (stash.hasEmptySlot())
				stash.add(::new(basePath + item.Path));
			else this.m.ItemOverflow.push(item);
		}
		::logInfo("c")
		return generated;
	}

	function consumeItemOverflow()
	{
		local stash = this.getSettlement().getStash();
		foreach (item in this.m.ItemOverflow)
		{
			stash.add(::new(basePath + item));
		}
	}

	function onSerialize(_out)
	{
		::Stronghold.Mod.Serialization.flagSerialize(this.getID().tostring(),  this.m.ItemOverflow, this.getFlags());
		this.attached_location.onSerialize(_out);
	}

	function onDeserialize(_in)
	{
		this.attached_location.onDeserialize(_in);
		this.m.ItemOverflow.clear();
		this.m.ItemOverflow = ::Stronghold.Mod.Serialization.flagDeserialize(this.getID().tostring(),  this.m.ItemOverflow, null, this.getFlags());
	}
})
