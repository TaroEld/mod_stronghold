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
				Name = building.Name,
				ID = building.ID,
				ConstID = buildingID,
				Description = building.Description,
				Cost = building.Cost,
				Path = building.Path,
				ImagePath = building.Path + ".png",
				HasStructure = hasBuilding,
				Requirements = requirements
			}
		}
		return _ret
	}

	function addBuilding(_data)
	{
		local cost = _data[1].tointeger() * ::Stronghold.PriceMult
		this.World.Assets.addMoney(-cost)
		local building = this.new("scripts/entity/world/settlements/buildings/" + _data[0]);
		this.getTown().addBuilding(building);
		this.updateData(["TownAssets", "Assets", "BuildingsModule"]);
	}

	function removeBuilding(_data)
	{
		this.getTown().removeBuilding(_data);
	}
})
