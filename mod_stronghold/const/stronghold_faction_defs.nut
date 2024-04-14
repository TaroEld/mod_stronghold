::Stronghold.FactionDefs <- {};
::Stronghold.FactionDefs[this.Const.FactionType.Goblins] <- {
	Name = "Goblin Raiders",
	Spawnlist = this.Const.World.Spawn.GoblinRaiders,
	Description = "A warband of goblins.",
	Footprint = this.Const.World.FootprintsType.Goblins,
}
if(this.Const.DLC.Wildmen)
{
	::Stronghold.FactionDefs[this.Const.FactionType.Barbarians] <- {
		Name = "Barbarians",
		Spawnlist = this.Const.World.Spawn.Barbarians,
		Description = "A warband of barbarian tribals.",
		Footprint = this.Const.World.FootprintsType.Barbarians,
	}
}
::Stronghold.FactionDefs[this.Const.FactionType.OrientalBandits] <- {
	Name = "Nomads",
	Spawnlist = this.Const.World.Spawn.NomadDefenders,
	Description = "A warband of nomads.",
	Footprint = this.Const.World.FootprintsType.Nomads,
}
::Stronghold.FactionDefs[this.Const.FactionType.Orcs] <- {
	Name = "Orc Marauders",
	Spawnlist = this.Const.World.Spawn.OrcRaiders,
	Description = "A warband of Orcs.",
	Footprint = this.Const.World.FootprintsType.Orcs,
}
::Stronghold.FactionDefs[this.Const.FactionType.Zombies] <- {
	Name = "Army of the dead",
	Spawnlist = this.Const.World.Spawn.Necromancer,
	Description = "An army of undead lead by a necromancer.",
	Footprint = this.Const.World.FootprintsType.Undead,
}
::Stronghold.FactionDefs[this.Const.FactionType.NobleHouse] <- {
	Name = "Noble Army",
	Spawnlist = this.Const.World.Spawn.Noble,
	Description = "An army of noble soldiers.",
	Footprint = this.Const.World.FootprintsType.Nobles,
}
::Stronghold.FactionDefs[this.Const.FactionType.OrientalCityState] <- {
	Name = "City State Army",
	Spawnlist = this.Const.World.Spawn.Southern,
	Description = "An army of city state soldiers.",
	Footprint = this.Const.World.FootprintsType.CityState,
}