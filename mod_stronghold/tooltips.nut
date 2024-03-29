::Stronghold.Mod.Tooltips.setTooltips({
	Screen = {
		Module = {
			Main = {},
			Misc = {
				RoadZoom = ::MSU.Class.BasicTooltip("Show location", "[img]gfx/ui/icons/mouse_left_button.png[/img]Left click to move camera to location.\n [img]gfx/ui/icons/mouse_right_button.png[/img]Right click to return to your base."),
			},
			Roster = {
				PlayerWages =  ::MSU.Class.BasicTooltip("Player Party Wages", "The wages of all the brothers in your party."),
				StrongholdWages = ::MSU.Class.BasicTooltip("Base Wages", "The wages of all the brothers in this base, reduced by the effect of the Troop Quarters location."),
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
