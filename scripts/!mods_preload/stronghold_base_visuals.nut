local gt = this.getroottable();
gt.Stronghold.setupVisuals <- function()
{


	gt.Stronghold.Visuals <- [];
	gt.Stronghold.Visuals.push(
	{
		ID = "Default",
		Name = "Default",
		Author = "Overhype",
		Levels = 
		[
			{
				Base =  "world_stronghold_01",
				BaseNight = "world_stronghold_01_light",
				Upgrading =  "stronghold_01_upgrading",
				UpgradingNight =  "",
				Houses =  "world_houses_03_0",
				Background = {
					UIBackgroundCenter = "ui/settlements/stronghold_01",
					UIBackgroundLeft = "ui/settlements/bg_houses_01_left",
					UIBackgroundRight = "ui/settlements/bg_houses_01_right",
					UIRampPathway = "ui/settlements/ramp_01_planks",
				}
			},
			{
				Base =  "world_stronghold_02",
				BaseNight =  "world_stronghold_02_light",
				Upgrading =  "stronghold_02_upgrading",
				UpgradingNight =  "",
				Houses =  "world_houses_03_0",
				Background = {
					UIBackgroundCenter = "ui/settlements/stronghold_02",
					UIBackgroundLeft = "ui/settlements/bg_houses_02_left",
					UIBackgroundRight = "ui/settlements/bg_houses_02_right",
					UIRampPathway = "ui/settlements/ramp_01_planks",
				}
			},
			{
				Base =  "world_stronghold_03",
				BaseNight =  "world_stronghold_03_light",
				Upgrading =  "stronghold_03_upgrading",
				UpgradingNight =  "world_stronghold_03_upgrading_light",
				Houses =  "world_houses_03_0",
				Background = {
					UIBackgroundCenter = "ui/settlements/stronghold_03",
					UIBackgroundLeft = "ui/settlements/bg_houses_03_left",
					UIBackgroundRight = "ui/settlements/bg_houses_03_right",
					UIRampPathway = "ui/settlements/ramp_01_cobblestone",
				}
			}
		]
	}) 
	gt.Stronghold.Visuals.push(
	{
		ID = "Mercenary_Camp",
		Name = "Mercenary Camp",
		Author = "Luftwaffle",
		Levels = 
		[
			{
				Base =  "world_luft_01",
				BaseNight = "world_stronghold_01_light",
				Upgrading =  "world_luft_01u",
				UpgradingNight =  "",
				Houses =  "world_houses_03_0",
				Background = {
					UIBackgroundCenter = "ui/settlements/stronghold_01",
					UIBackgroundLeft = "ui/settlements/bg_houses_01_left",
					UIBackgroundRight = "ui/settlements/bg_houses_01_right",
					UIRampPathway = "ui/settlements/ramp_01_planks",
				}
			},
			{
				Base =  "world_luft_02",
				BaseNight =  "world_stronghold_02_light",
				Upgrading =  "world_luft_02u",
				UpgradingNight =  "",
				Houses =  "world_houses_03_0",
				Background = {
					UIBackgroundCenter = "ui/settlements/stronghold_02",
					UIBackgroundLeft = "ui/settlements/bg_houses_02_left",
					UIBackgroundRight = "ui/settlements/bg_houses_02_right",
					UIRampPathway = "ui/settlements/ramp_01_planks",
				}
			},
			{
				Base =  "world_luft_03",
				BaseNight =  "world_stronghold_03_light",
				Upgrading =  "world_luft_03u",
				UpgradingNight =  "world_stronghold_03_upgrading_light",
				Houses =  "world_houses_03_0",
				Background = {
					UIBackgroundCenter = "ui/settlements/stronghold_03",
					UIBackgroundLeft = "ui/settlements/bg_houses_03_left",
					UIBackgroundRight = "ui/settlements/bg_houses_03_right",
					UIRampPathway = "ui/settlements/ramp_01_cobblestone",
				}
			}
		]
	})


	gt.Stronghold.VisualsMap <- {}
	foreach(idx, value in gt.Stronghold.Visuals){
		gt.Stronghold.VisualsMap[value.ID] <- idx
	}
	// gt.Stronghold.Visuals.BaseMercenary < 
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

}