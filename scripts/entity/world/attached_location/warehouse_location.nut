this.warehouse_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {
		Stash = null,
		ConsumableItems = {
			"supplies.money" : 0,
			"supplies.medicine" : 0,
			"supplies.ammo" : 0,
			"supplies.armor_parts" : 0,
		}
	},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Warehouse";
		this.m.ID = "attached_location.warehouse";
		this.m.Description = "The warehouse of your company.";
		this.m.Sprite = "stronghold_world_warehouse_location";
		this.m.SpriteDestroyed = "stronghold_world_warehouse_location";
		this.m.Stash = this.new("scripts/items/stash_container");
		this.m.Stash.setID("warehouse");
		this.m.Stash.setResizable(false);
		this.m.Stash.resize(::Stronghold.Locations.Warehouse.MaxItemSlots);
		this.m.Level = 0;
	}

	function getStash()
	{
		return this.m.Stash;
	}

	function setSettlement( _s )
	{
		this.attached_location.setSettlement(_s);
	}

	function addConsumableItem(_i)
	{
		this.m.ConsumableItems[_i.ID] = ::Math.min(this.m.ConsumableItems[_i.ID] + _i.ToAdd, _i.Max);
	}

	function consumeConsumableItems()
	{
		local assets = ::World.Assets;
		foreach (_id, _amount in this.m.ConsumableItems)
		{
			if (_amount == 0)
				continue
			switch (_id)
			{
				case ("supplies.money"):
					assets.addMoney(_amount);
					this.m.ConsumableItems[_id] = 0;
					break;

				case ("supplies.medicine"):
					local current = assets.m.Medicine;
					assets.addMedicine(_amount);
					this.m.ConsumableItems[_id] = assets.m.Medicine - current;
					break;

				case ("supplies.ammo"):
					local current = assets.m.Ammo;
					assets.addAmmo(_amount);
					this.m.ConsumableItems[_id] = assets.m.Ammo - current;
					break;

				case ("supplies.armor_parts"):
					local current = assets.m.ArmorParts;
					assets.addArmorParts(_amount);
					this.m.ConsumableItems[_id] = assets.m.ArmorParts - current;
					break;
			}
		}
	}

	function onUpgrade()
	{
		this.resize();
	}

	function resize()
	{
		this.getStash().resize(::Stronghold.Locations.Warehouse.MaxItemSlots * (this.m.Level + 1));
	}

	function onSerialize(_out)
	{
		::Stronghold.Mod.Serialization.flagSerialize(this.getID().tostring(),  this.m.ConsumableItems, this.getFlags());
		this.attached_location.onSerialize(_out);
		this.m.Stash.onSerialize(_out);
	}

	function onDeserialize(_in)
	{
		this.attached_location.onDeserialize(_in);
		this.m.Stash.onDeserialize(_in);
		this.getStash().m.Capacity = this.getStash().m.Items.len();

		this.m.ConsumableItems = ::Stronghold.Mod.Serialization.flagDeserialize(this.getID().tostring(),  this.m.ConsumableItems, null, this.getFlags());
	}
})
