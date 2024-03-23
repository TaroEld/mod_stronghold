this.stronghold_screen_main_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function getUIData(_ret)
	{
		_ret.RaidedCostPerDay <- ::Stronghold.RaidedCostPerDay * ::Stronghold.PriceMult;
	}

	function changeBaseName(_data)
	{
		this.getTown().m.Name = _data;
		this.getTown().getFlags().set("CustomName", true);
		this.getTown().getLabel("name").Text = _data;
		this.updateData(["TownAssets", "MainModule"]);
	}

	function onChangeSetting(_data)
	{
		this.getTown().onChangeSetting(_data[0], _data[1]);
	}

	function onPayForRaided(_days)
	{
		local situation = this.getTown().getSituationByID("situation.raided");
		local price = (::Stronghold.RaidedCostPerDay * ::Stronghold.PriceMult) * _days;
		this.World.Assets.addMoney(-price);
		this.getTown().removeSituationByID("situation.raided");
		this.updateData(["TownAssets", "MainModule"]);
	}
})
