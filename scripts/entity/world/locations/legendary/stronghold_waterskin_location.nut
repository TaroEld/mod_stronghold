this.stronghold_waterskin_location <- this.inherit("scripts/entity/world/location", {
	//location for the waterskin recipe contract
	m = {},
	function getDescription()
	{
		return "An ancient graveyard.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.stronghold_waterskin";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = false;
		this.m.IsAttackable = true;
		this.m.VisibilityMult = 0.9;
		this.m.Resources = 500;
		this.m.CombatLocation.Template[0] = "tactical.graveyard";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Palisade;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.IsDespawningDefenders = false;
	}

	function onSpawned()
	{
		this.m.Name = "Ancient Graveyard";
		this.location.onSpawned();

		for( local i = 0; i < 3; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SkeletonPriest
			}, false);
		}

		for( local i = 0; i < 9; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SandGolemHIGH
			}, false);
		}

		for( local i = 0; i < 3; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SkeletonHeavyBodyguard
			}, false);
		}

		for( local i = 0; i < 9; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SkeletonHeavyPolearm
			}, false);
		}
	}
	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(200, 500), _lootTable);
		this.dropArmorParts(this.Math.rand(30, 50), _lootTable);
		this.dropAmmo(this.Math.rand(0, 30), _lootTable);
		this.dropMedicine(this.Math.rand(0, 5), _lootTable);
		this.dropTreasure(this.Math.rand(3, 4), [
			"loot/white_pearls_item",
			"loot/jeweled_crown_item",
			"loot/gemstones_item",
			"loot/golden_chalice_item",
			"loot/ancient_gold_coins_item"
		], _lootTable);
	}

	function onDiscovered()
	{
		this.location.onDiscovered();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_graveyard_01");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.m.IsAttackable = true;
	}

});

