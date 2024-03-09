this.troop_quarters_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {
	},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Troop Quarters";
		this.m.ID = "attached_location.troop_quarters";
		this.m.Description = "Housing for your brothers.";
		this.m.Sprite = "stronghold_world_troop_quarters_location";
		this.m.SpriteDestroyed = "stronghold_world_troop_quarters_location";
	}
})
