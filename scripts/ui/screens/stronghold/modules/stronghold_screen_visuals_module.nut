this.stronghold_screen_visuals_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function changeSprites(_data)
	{
		this.getTown().onVisualsChanged(_data);
		this.updateData(["TownAssets", "VisualsModule"]);
	}
})
