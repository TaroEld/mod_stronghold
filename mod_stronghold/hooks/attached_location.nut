::mods_hookExactClass("entity/world/attached_location", function(o)
{
	local create = o.create;
	o.create = function()
	{
		create();
		this.m.Level <- 1;
	}

	function getLevel()
	{
		return this.m.Level;
	}

	local onSerialize = o.onSerialize;
	o.onSerialize = function( _out )
	{
		::Stronghold.Mod.Serialization.flagSerialize(this.getID().tostring(),  {Level = this.m.Level}, this.getFlags());
		onSerialize(_out);
	}

	local onDeserialize = o.onDeserialize;
	o.onDeserialize = function( _in )
	{
		onDeserialize(_in);
		this.m.Level = ::Stronghold.Mod.Serialization.flagDeserialize(this.getID().tostring(), {Level = 1}, null, this.getFlags()).Level;
	}

	o.stronghold_updateLocationEffects <- function(_daysPassed)
	{

	}

	o.upgrade <- function()
	{
		this.m.Level++;
		this.onUpgrade();
	}

	o.onUpgrade <- function()
	{
	}
})

::mods_hookExactClass("entity/world/attached_location/blast_furnace_location", function(o)
{
	o.stronghold_updateLocationEffects <- function(_daysPassed)
	{

	}
})

::mods_hookExactClass("entity/world/attached_location/herbalists_grove_location", function(o)
{
	o.stronghold_updateLocationEffects <- function(_daysPassed)
	{
		local item = {
			ID = "supplies.medicine",
			Script = "scripts/items/supplies/medicine_item",
			Max = this.Stronghold.Locations["Herbalists_Grove"].MaxItemSlots * this.m.Level,
			MaxPerStack = 20,
			ToAdd = this.Stronghold.Locations["Herbalists_Grove"].DailyIncome * _daysPassed * this.m.Level
		}
		if (item.ToAdd == 0)
			return;
		this.m.Settlement.getWarehouse().addConsumableItem(item);
	}
})

::mods_hookExactClass("entity/world/attached_location/gold_mine_location", function(o)
{
	o.stronghold_updateLocationEffects <- function(_daysPassed)
	{
		local item = {
			ID = "supplies.money",
			Script = "scripts/items/supplies/money_item",
			ToAdd = this.m.Level * _daysPassed * this.Stronghold.Locations["Gold_Mine"].DailyIncome
			Max = 999999,
			MaxPerStack = 999999
		}
		if (item.ToAdd == 0)
			return;
		this.m.Settlement.getWarehouse().addConsumableItem(item);
	}
})

::mods_hookExactClass("entity/world/attached_location/militia_trainingcamp_location", function(o)
{
	o.stronghold_updateLocationEffects <- function(_daysPassed)
	{
		local XpPerDay = this.Stronghold.Locations["Militia_Trainingcamp"].DailyIncome;
		local totalXP = XpPerDay * _daysPassed ;
		local validBros = this.m.Settlement.getLocalRoster().getAll().filter( @(a, b) b.getLevel() <= ::Stronghold.Locations["Militia_Trainingcamp"].MaxBrotherExpLevel);
		local XpPerBro = totalXP  / validBros.len();
		foreach (bro in validBros)
		{
			bro.addXP(XpPerBro.tointeger(), false);
			bro.updateLevel();
		}
	}
})

::mods_hookExactClass("entity/world/attached_location/ore_smelter", function(o)
{
	o.stronghold_updateLocationEffects <- function(_daysPassed)
	{

	}
})

::mods_hookExactClass("entity/world/attached_location/stone_watchtower_location", function(o)
{
	o.stronghold_updateLocationEffects <- function(_daysPassed)
	{

	}
})

::mods_hookExactClass("entity/world/attached_location/wheat_fields_location", function(o)
{
	o.stronghold_updateLocationEffects <- function(_daysPassed)
	{

	}

	o.onBuild <- function()
	{
		local ret = this.attached_location.onBuild();
		this.onUpgrade();
		return ret;
	}

	o.onUpgrade <- function()
	{
		foreach (player in ::World.getPlayerRoster().getAll())
		{
			this.setSkillOnPlayer(player);
		}
	}

	o.setSkillOnPlayer <- function(_player)
	{
		local skill = _player.getSkills().getSkillByID("effects.stronghold_well_fed");
		if (skill == null)
		{
			skill = ::new("scripts/skills/effects_world/stronghold_well_fed_effect");
			_player.getSkills().add(skill);
		}
		skill.m.Bonus = ::Stronghold.Locations["Wheat_Fields"].StatGain * this.getLevel();
		skill.setTimeRemaining(7);
	}
})

::mods_hookExactClass("entity/world/attached_location/workshop_location", function(o)
{
	o.stronghold_updateLocationEffects <- function(_daysPassed)
	{
		local item = {
			ID = "supplies.armor_parts",
			Script = "scripts/items/supplies/armor_parts_item"
			Max = this.Stronghold.Locations["Workshop"].MaxItemSlots * this.Stronghold.ToolsPerDay,
			MaxPerStack = 25,
			ToAdd = this.m.Level * _daysPassed * this.Stronghold.ToolsPerDay
		}
		this.m.Settlement.getWarehouse().addConsumableItem(item);
	}
})


