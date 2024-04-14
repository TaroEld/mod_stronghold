::Stronghold.Mod.Tooltips.setTooltips({
	Screen = {
		Module = {
			Main = {
				ShowEffectRadius =  ::MSU.Class.BasicTooltip("Effect Radius", "The effect radius of your base determines the range at which location effects apply. Any camps within this radius will also periodically attack your base."),
				ShowBanner = ::MSU.Class.BasicTooltip("Show banner", "Show/hide the banner above your base on the worldmap."),
			},
			Misc = {
				RoadZoom = ::MSU.Class.BasicTooltip("Show location", "[img]gfx/ui/icons/mouse_left_button.png[/img]Left click to move camera to location.\n [img]gfx/ui/icons/mouse_right_button.png[/img]Right click to return to your base."),
			},
			Roster = {
				PlayerWages =  ::MSU.Class.BasicTooltip("Player Party Wages", "The wages of all the brothers in your party."),
				StrongholdWages = ::MSU.Class.BasicTooltip("Base Wages", "The wages of all the brothers in this base, reduced by the effect of the Troop Quarters location."),
				StripAll = ::MSU.Class.BasicTooltip("Strip Gear", "Strip all items from this brother and add them to the stash."),
			},
			Stash = {
				SmallIcons = ::MSU.Class.BasicTooltip("Toggle small icons", "Toggle between smaller and normal icons."),
			},
			Structure = {}
			Upgrade = {},
			Visuals = {},
			Buildings = {},
			Locations = {}
		}
	}
})
