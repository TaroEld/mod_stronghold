this.stronghold_trainer_location <- this.inherit("scripts/entity/world/location", {
	//location for the free legendary trainer contract
	m = {},
	function getDescription()
	{
		return "The Fields of War";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.stronghold_trainer";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 0.9;
		this.m.IsDespawningDefenders = false;
	}

	function onSpawned()
	{
		this.m.Name = "Field of War";
		this.location.onSpawned();

	}
	function onDropLootForPlayer( _lootTable )
	{
	}

	function onDiscovered()
	{
		this.location.onDiscovered();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_wildmen_03_snow");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.m.IsAttackable = true;
	}

});

