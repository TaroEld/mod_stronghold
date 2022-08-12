this.stronghold_management_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	//modified marketplace.
	m = {
	},

	function create()
	{
		this.building.create();
		this.m.ID = "building.management_building";
		this.m.Name = "Management";
		this.m.Description = "Manage your base";
		this.m.UIImage = "ui/settlements/stronghold_01_management";
		this.m.UIImageNight = "ui/settlements/building_06";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Management";
		this.m.TooltipIcon = "ui/icons/buildings/tavern.png";
		this.m.IsClosedAtNight = false;
		this.m.Sounds = [];
		this.m.SoundsAtNight = [];
	}

	function onClicked( _townScreen )
	{
		this.m.Settlement.showStrongholdUIDialog();
	}

	function updateSprite()
	{
		local playerBase = this.m.Settlement
		this.m.UIImage = playerBase.m.UIBackgroundCenter + "_management"
		this.m.UIImageNight = playerBase.m.UIBackgroundCenter + "_night" + "_management"
	}

});

