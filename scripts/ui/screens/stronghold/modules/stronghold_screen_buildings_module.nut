this.stronghold_screen_buildings_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function getUIData( _ret )
	{
		foreach(buildingID, building in ::Stronghold.BuildingDefs)
		{
			local hasBuilding = this.getTown().hasBuilding(building.ID) || ("SouthID" in building && this.getTown().hasBuilding(building.SouthID))
			local requirements = [
				{
					Text = "Maximum amount of buildings for this base level: " + this.getTown().getActiveBuildings().len() + " / " + this.getTown().getMaxBuildings(),
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
				ImagePath = building.Path + ".png",
				HasStructure = hasBuilding,
			}
			::MSU.Table.merge(_ret[buildingID], building, true);
			_ret[buildingID].Requirements = requirements;
		}
		return _ret
	}

	function addBuilding(_data)
	{
		local price = _data[1].tointeger();
		this.World.Assets.addMoney(-price)
		local building = this.new("scripts/entity/world/settlements/buildings/" + _data[0]);
		this.getTown().addBuilding(building);
		this.updateData(["TownAssets", "Assets", "BuildingsModule"]);
	}

	function removeBuilding(_data)
	{
		this.getTown().removeBuilding(_data);
		this.updateData(["TownAssets", "Assets", "BuildingsModule"]);
	}
})
