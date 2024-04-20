::Stronghold.VisualsMap <- {}
::Stronghold.VisualsMap["Default"] <-
{
	ID = "Default",
	Name = "Default",
	Author = "Overhype",
	WorldmapFigure = [
		"figure_mercenary_01",
		"figure_mercenary_01",
		"figure_mercenary_01",
		"figure_mercenary_01",
	]
	Base = [
		["stronghold_00", "stronghold_00_light"],
		["stronghold_01", "stronghold_01_light"],
		["stronghold_02", "stronghold_02_light"],
		["stronghold_03", "stronghold_03_light"]
	],
	Upgrading = [
		["stronghold_00u", "stronghold_00_light"],
		["stronghold_01u", "stronghold_01u_light"],
		["stronghold_02u", "stronghold_02_light"],
		["stronghold_03u", "stronghold_03_light"]
	]
	Houses =  [
		["world_houses_03_01", "world_houses_03_01_light"]
	]
	Background = {
		UIBackgroundCenter = [
			"ui/settlements/stronghold_01",
			"ui/settlements/stronghold_01",
			"ui/settlements/stronghold_02",
			"ui/settlements/stronghold_03",
			]
		UIBackgroundLeft = [
			"ui/settlements/bg_houses_01_left",
			"ui/settlements/bg_houses_02_left"
			"ui/settlements/bg_houses_03_left",
			"ui/settlements/bg_houses_03_left",
		]
		UIBackgroundRight = [
			"ui/settlements/bg_houses_01_right",
			"ui/settlements/bg_houses_02_right",
			"ui/settlements/bg_houses_03_right",
			"ui/settlements/bg_houses_03_right",
		]
		UIRampPathway = [
			"ui/settlements/ramp_01_planks",
			"ui/settlements/ramp_01_planks",
			"ui/settlements/ramp_01_planks",
			"ui/settlements/ramp_01_cobblestone",
		]
	}
}
::Stronghold.VisualsMap["Luft_Basic"] <-
{
	ID = "Luft_Basic",
	Name = "Basic Camp",
	Author = "Luftwaffle",
	WorldmapFigure = [
		"luft_basic_patrol",
		"luft_basic_patrol",
		"luft_basic_patrol",
		"luft_basic_patrol",
	]
	Base = [
		["luft_basic_01", ""],
		["luft_basic_02", "luft_basic_02_light"],
		["luft_basic_03", "luft_basic_03_light"],
		["luft_basic_04", "luft_basic_04_light"]
	],
	Upgrading = [
		["luft_basic_01u", ""],
		["luft_basic_02u", "luft_basic_02u_light"],
		["luft_basic_03u", "luft_basic_03u_light"],
		["luft_basic_04u", "luft_basic_04u_light"]
	]
	Houses =  [
		["luft_basic_houses_01", ""],
		["luft_basic_houses_02", ""],
		["luft_basic_houses_03", ""],
		["luft_basic_houses_04", ""]
	]
}
::Stronghold.VisualsMap["Luft_Basic"].Background <- clone ::Stronghold.VisualsMap["Default"].Background;

::Stronghold.VisualsMap["Luft_Brigand"] <-
{
	ID = "Luft_Brigand",
	Name = "Brigand Fort",
	Author = "Luftwaffle",
	WorldmapFigure = [
		"luft_fort_patrol",
		"luft_fort_patrol",
		"luft_fort_patrol",
		"luft_fort_patrol",
	]
	Base = [
		["luft_fort_01", "luft_fort_01_light"],
		["luft_fort_02", "luft_fort_02_light"],
		["luft_fort_03", "luft_fort_03_light"],
		["luft_fort_04", "luft_fort_04_light"]
	],
	Upgrading = [
		["luft_fort_01u", "luft_fort_01u_light"],
		["luft_fort_02u", "luft_fort_02u_light"],
		["luft_fort_03u", "luft_fort_03u_light"],
		["luft_fort_04u", "luft_fort_04u_light"]
	]
	Houses =  [
		["luft_fort_houses_01", ""],
		["luft_fort_houses_02", ""],
	]
}
::Stronghold.VisualsMap["Luft_Brigand"].Background <- clone ::Stronghold.VisualsMap["Default"].Background;

::Stronghold.VisualsMap["Luft_Fishing"] <-
{
	ID = "Luft_Fishing",
	Name = "Fishing Village",
	Author = "Luftwaffle",
	WorldmapFigure = [
		"luft_fishing_patrol",
		"luft_fishing_patrol",
		"luft_fishing_patrol",
		"luft_fishing_patrol",
	]
	Base = [
		["luft_fishing_01", ""],
		["luft_fishing_02", "luft_fishing_02_light"],
		["luft_fishing_03", "luft_fishing_03_light"],
		["luft_fishing_04", "luft_fishing_04_light"]
	],
	Upgrading = [
		["luft_fishing_01u", ""],
		["luft_fishing_02u", ""],
		["luft_fishing_03u", "luft_fishing_03u_light"],
		["luft_fishing_04u", "luft_fishing_04u_light"]
	]
	Houses =  [
		["luft_fishing_houses_01", "luft_fishing_houses_01_light"],
		["luft_fishing_houses_02", "luft_fishing_houses_02_light"],
		["luft_fishing_houses_03", ""]
	]
}
::Stronghold.VisualsMap["Luft_Fishing"].Background <- clone ::Stronghold.VisualsMap["Default"].Background;

::Stronghold.VisualsMap["Luft_Necro"] <-
{
	ID = "Luft_Necro",
	Name = "Necromancer's Lair [unfinished]",
	Author = "Luftwaffle",
	WorldmapFigure = [
		"luft_necro_patrol",
		"luft_necro_patrol",
		"luft_necro_patrol",
		"luft_necro_patrol",
	]
	Base = [
		["luft_necro_01", "luft_necro_01_light"],
		["luft_necro_02", "luft_necro_02_light"],
		["luft_necro_03", "luft_necro_03_light"],
		["luft_necro_04", "luft_necro_04_light"]
	],
	Upgrading = [
		["luft_necro_01u", ""],
		["luft_necro_02u", ""],
		["luft_necro_03u", "luft_necro_03u_light"],
		["luft_necro_04u", "luft_necro_04u_light"]
	]
	Houses =  [
		["luft_necro_houses_01", ""],
		["luft_necro_houses_02", ""],
		["luft_necro_houses_03", ""],
	]
}
::Stronghold.VisualsMap["Luft_Necro"].Background <- clone ::Stronghold.VisualsMap["Default"].Background;
