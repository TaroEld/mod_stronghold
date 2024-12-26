this.stronghold_screen_buildings_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function getUIData( _ret )
	{
		foreach(buildingID, building in ::Stronghold.Buildings)
		{
			local hasBuilding = this.getTown().hasBuilding(building.ID) || ("SouthID" in building && this.getTown().hasBuilding(building.SouthID))
			local requirements = [
				{
					Text = "Maximum amount of buildings for this base level: " + this.getTown().getActiveBuildings().len() - 2 + " / " + this.getTown().getMaxBuildings() - 2, // minus two for management building and marketplace
					IsValid = this.getTown().getActiveBuildings().len() < this.getTown().getMaxBuildings()
				}
			]
			foreach(requirement in building.Requirements)
			{
				requirements.push({
					Text = requirement.Text,
					IsValid = requirement.IsValid(this.getTown())
				})
			}
			_ret[buildingID] <- {
				HasStructure = hasBuilding,
			}
			::MSU.Table.merge(_ret[buildingID], building, true);
			_ret[buildingID].Requirements = requirements;
			_ret[buildingID].Price *= ::Stronghold.Misc.PriceMult;
		}
		return _ret
	}

	function addBuilding(_data)
	{
		local buildingDef = ::Stronghold.Buildings[_data];
		this.World.Assets.addMoney(-buildingDef.Price * ::Stronghold.Misc.PriceMult)
		local building = this.new("scripts/entity/world/settlements/buildings/" + buildingDef.Path);
		this.getTown().addBuilding(building);
		building.onUpdateShopList();

		if (building.getStash() != null)
		{
			foreach( s in this.getTown().m.Situations )
			{
				s.onUpdateShop(building.getStash());
			}
		}
		this.updateData(["TownAssets", "Assets", "BuildingsModule"]);
	}

	function removeBuilding(_data)
	{
		local buildingDef = ::Stronghold.Buildings[_data];
		this.getTown().removeBuilding(buildingDef.ID);
		this.updateData(["TownAssets", "Assets", "BuildingsModule"]);
	}
})
