this.stronghold_screen_main_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function changeBaseName(_data)
	{
		this.getTown().m.Name = _data;
		this.getTown().getFlags().set("CustomName", true);
		this.getTown().getLabel("name").Text = _data;
		this.updateData(["TownAssets", "MainModule"]);
	}
})
