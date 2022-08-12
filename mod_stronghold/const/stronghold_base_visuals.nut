::Stronghold.Visuals <- [];
::Stronghold.Visuals.push(
{
	ID = "Default",
	Name = "Default",
	Author = "Overhype",
	// One table for each level ( 3 levels )
	Levels =
	[
		{
			// First entry in array is base sprite, second is lights during night
			Base =  ["world_stronghold_01", "world_stronghold_01_light"]
			// First entry in array is base sprite, second is lights during night
			Upgrading =  ["stronghold_01u", ""]
			// Multiple variations of houses are possible, will be randomised ; First entry in subarray is base sprite, second is lights during night
			Houses =  [["world_houses_03_01", "world_houses_03_01_light"]],
			// Look of the parties that are spawned by the base
			WorldmapFigure = "figure_mercenary_01",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_01",
				UIBackgroundLeft = "ui/settlements/bg_houses_01_left",
				UIBackgroundRight = "ui/settlements/bg_houses_01_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["world_stronghold_02", "world_stronghold_02_light"]
			Upgrading =  ["stronghold_02u", ""]
			Houses =  [["world_houses_03_01", "world_houses_03_01_light"]],
			WorldmapFigure = "figure_mercenary_01",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_02",
				UIBackgroundLeft = "ui/settlements/bg_houses_02_left",
				UIBackgroundRight = "ui/settlements/bg_houses_02_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["world_stronghold_03", "world_stronghold_03_light"]
			Upgrading =  ["stronghold_03u", ""]
			Houses =  [["world_houses_03_01", "world_houses_03_01_light"]],
			WorldmapFigure = "figure_mercenary_01",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_03",
				UIBackgroundLeft = "ui/settlements/bg_houses_03_left",
				UIBackgroundRight = "ui/settlements/bg_houses_03_right",
				UIRampPathway = "ui/settlements/ramp_01_cobblestone",
			}
		}
	]
})
::Stronghold.Visuals.push(
{
	ID = "Luft_Basic",
	Name = "Basic Camp",
	Author = "Luftwaffle",
	Levels =
	[
		{
			Base =  ["luft_basic_01", "",],
			Upgrading =  ["luft_basic_01u", ""],
			Houses =  [["luft_basic_houses_01", ""], ["luft_basic_houses_02", ""], ["luft_basic_houses_03", ""]],
			WorldmapFigure = "luft_basic_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_01",
				UIBackgroundLeft = "ui/settlements/bg_houses_01_left",
				UIBackgroundRight = "ui/settlements/bg_houses_01_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["luft_basic_02", "luft_basic_02_light",],
			Upgrading =  ["luft_basic_02u", "luft_basic_02u_light"],
			Houses =  [["luft_basic_houses_01", ""], ["luft_basic_houses_02", ""]],
			WorldmapFigure = "luft_basic_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_02",
				UIBackgroundLeft = "ui/settlements/bg_houses_02_left",
				UIBackgroundRight = "ui/settlements/bg_houses_02_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["luft_basic_03", "luft_basic_03_light",],
			Upgrading =  ["luft_basic_03u", "luft_basic_03_light"],
			Houses =  [["luft_basic_houses_01", ""], ["luft_basic_houses_02", ""]],
			WorldmapFigure = "luft_basic_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_03",
				UIBackgroundLeft = "ui/settlements/bg_houses_03_left",
				UIBackgroundRight = "ui/settlements/bg_houses_03_right",
				UIRampPathway = "ui/settlements/ramp_01_cobblestone",
			}
		}
	]
}),
::Stronghold.Visuals.push(
{
	ID = "Luft_Brigand",
	Name = "Brigand Fort",
	Author = "Luftwaffle",
	Levels =
	[
		{
			Base =  ["luft_fort_01", "luft_fort_01_light",],
			Upgrading =  ["luft_fort_01u", "luft_fort_01_light"],
			Houses =  [["luft_fort_houses_01", ""], ["luft_fort_houses_02", ""]],
			WorldmapFigure = "luft_fort_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_01",
				UIBackgroundLeft = "ui/settlements/bg_houses_01_left",
				UIBackgroundRight = "ui/settlements/bg_houses_01_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["luft_fort_02", "luft_fort_02_light",],
			Upgrading =  ["luft_fort_02u", "luft_fort_02_light"],
			Houses =  [["luft_fort_houses_01", ""], ["luft_fort_houses_02", ""]],
			WorldmapFigure = "luft_fort_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_02",
				UIBackgroundLeft = "ui/settlements/bg_houses_02_left",
				UIBackgroundRight = "ui/settlements/bg_houses_02_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["luft_fort_03", "luft_fort_03_light",],
			Upgrading =  ["luft_fort_03u", "luft_fort_03_light"],
			Houses =  [["luft_fort_houses_01", ""], ["luft_fort_houses_02", ""]],
			WorldmapFigure = "luft_fort_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_03",
				UIBackgroundLeft = "ui/settlements/bg_houses_03_left",
				UIBackgroundRight = "ui/settlements/bg_houses_03_right",
				UIRampPathway = "ui/settlements/ramp_01_cobblestone",
			}
		}
	]
})
::Stronghold.Visuals.push(
{
	ID = "Luft_Fishing",
	Name = "Fishing Village",
	Author = "Luftwaffle",
	Levels =
	[
		{
			Base =  ["luft_fishing_01", "luft_fishing_01_light",],
			Upgrading =  ["luft_fishing_01u", "luft_fishing_01_light"],
			Houses =  [["luft_fishing_houses_01", "luft_fishing_houses_01_light"], ["luft_fishing_houses_02", "luft_fishing_houses_02_light"]],
			WorldmapFigure = "luft_fishing_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_01",
				UIBackgroundLeft = "ui/settlements/bg_houses_01_left",
				UIBackgroundRight = "ui/settlements/bg_houses_01_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["luft_fishing_02", "luft_fishing_02_light",],
			Upgrading =  ["luft_fishing_02u", "luft_fishing_02u_light"],
			Houses =  [["luft_fishing_houses_01", "luft_fishing_houses_01_light"], ["luft_fishing_houses_02", "luft_fishing_houses_02_light"]],
			WorldmapFigure = "luft_fishing_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_02",
				UIBackgroundLeft = "ui/settlements/bg_houses_02_left",
				UIBackgroundRight = "ui/settlements/bg_houses_02_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["luft_fishing_03", "luft_fishing_03_light",],
			Upgrading =  ["luft_fishing_03u", "luft_fishing_03u_light"],
			Houses =  [["luft_fishing_houses_01", "luft_fishing_houses_01_light"], ["luft_fishing_houses_02", "luft_fishing_houses_02_light"]],
			WorldmapFigure = "luft_fishing_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_03",
				UIBackgroundLeft = "ui/settlements/bg_houses_03_left",
				UIBackgroundRight = "ui/settlements/bg_houses_03_right",
				UIRampPathway = "ui/settlements/ramp_01_cobblestone",
			}
		}
	]
})
::Stronghold.Visuals.push(
{
	ID = "Luft_Necro",
	Name = "Necromancer's Lair",
	Author = "Luftwaffle",
	Levels =
	[
		{
			Base =  ["luft_necro_01", "luft_necro_01_light",],
			Upgrading =  ["luft_necro_01u", "luft_necro_01_light"],
			Houses =  [["luft_necro_houses_01", ""], ["luft_necro_houses_02", ""], ["luft_necro_houses_03", ""]],
			WorldmapFigure = "luft_necro_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_01",
				UIBackgroundLeft = "ui/settlements/bg_houses_01_left",
				UIBackgroundRight = "ui/settlements/bg_houses_01_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["luft_necro_02", "luft_necro_02_light",],
			Upgrading =  ["luft_necro_02u", "luft_necro_02u_light"],
			Houses =  [["luft_necro_houses_01", ""], ["luft_necro_houses_02", ""]],
			WorldmapFigure = "luft_necro_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_02",
				UIBackgroundLeft = "ui/settlements/bg_houses_02_left",
				UIBackgroundRight = "ui/settlements/bg_houses_02_right",
				UIRampPathway = "ui/settlements/ramp_01_planks",
			}
		},
		{
			Base =  ["luft_necro_03", "luft_necro_03_light",],
			Upgrading =  ["luft_necro_03u", "luft_necro_03u_light"],
			Houses =  [["luft_necro_houses_01", ""], ["luft_necro_houses_02", ""]],
			WorldmapFigure = "luft_necro_patrol",
			Background = {
				UIBackgroundCenter = "ui/settlements/stronghold_03",
				UIBackgroundLeft = "ui/settlements/bg_houses_03_left",
				UIBackgroundRight = "ui/settlements/bg_houses_03_right",
				UIRampPathway = "ui/settlements/ramp_01_cobblestone",
			}
		}
	]
})

::Stronghold.VisualsMap <- {}
foreach(idx, value in ::Stronghold.Visuals){
	::Stronghold.VisualsMap[value.ID] <- idx
}
// ::Stronghold.Visuals.BaseMercenary <
// {
// 	[
// 		Base <- [],
// 		BaseNight <- [],
// 		Upgrading <- [],
// 		UpgradingNight <- [],
// 		Houses <- [],
// 		Background <- {
// 			UIBackgroundCenter = "ui/settlements/stronghold_01",
// 			UIBackgroundLeft = "ui/settlements/bg_houses_01_left",
// 			UIBackgroundRight = "ui/settlements/bg_houses_01_right",
// 			UIRampPathway = "ui/settlements/ramp_01_planks",
// 			Lighting = "world_stronghold_01_light"
// 		}
// 	],


// }

