this.stronghold_screen_locations_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function getUIData( _ret )
	{
		foreach(locationID, location in ::Stronghold.LocationDefs)
		{
			local countLocation = this.getTown().countAttachedLocations(location.ID)
			local requirements = [];
			foreach(requirement in location.Requirements)
			{
				requirements.push({
					Text = requirement.Text,
					IsValid = requirement.IsValid(this.getTown())
				})
			}
			_ret[locationID] <- {
				ConstID = locationID,
				ImagePath = location.Path + ".png",
				HasStructure = countLocation > 0,
				CurrentAmount = countLocation,
				Requirements = requirements
			}
			::MSU.Table.merge(_ret[locationID], location, true);
			::MSU.Log.printData(_ret[locationID])
		}
		return _ret
	}

	function addLocation(_data)
	{
		local home = this.getTown();
		local price = _data[1].tointeger()
		this.World.Assets.addMoney(-price)
		local script = "scripts/entity/world/attached_location/" + _data[0]
		local validTerrain =
		[
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Desert,
			this.Const.World.TerrainType.Land,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.SnowyForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.Farmland,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Badlands,
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Oasis,
		]
		home.buildAttachedLocation(1, script, validTerrain, [], 2)
		home.buildRoad(home.m.AttachedLocations[home.m.AttachedLocations.len()-1])
		::logInfo("adding LocationsModule")
		this.updateData(["TownAssets", "Assets", "LocationsModule"]);
	}

	function removeLocation(_data)
	{
		this.getTown().removeLocation(_data);
		this.updateData(["TownAssets", "Assets", "LocationsModule"]);
	}
})
