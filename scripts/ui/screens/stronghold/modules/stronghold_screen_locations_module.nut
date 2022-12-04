this.stronghold_screen_locations_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function getUIData( _ret )
	{
		foreach(locationID, location in ::Stronghold.LocationDefs)
		{
			local hasLocation = this.getTown().countAttachedLocations(location.ID)
			local requirements = []
			if ("Requirements" in location)
			{
				foreach(requirement in location.Requirements)
				{
					requirements.push({
						Text = requirement.Text,
						IsValid = requirement.IsValid(this.getTown())
					})
				}
			}
			_ret[locationID] <- {
				Name = location.Name,
				ID = location.ID,
				ConstID = location.ConstID,
				Description = location.Description,
				Cost = location.Cost,
				Path = location.Path,
				ImagePath = location.Path + ".png",
				CurrentAmount = hasLocation,
				MaxAmount = location.MaxAmount,
				Requirements = requirements
			}
		}
		return _ret
	}

	function addLocation(_data)
	{
		local home = this.getTown();
		local cost = _data[1].tointeger() * ::Stronghold.PriceMult
		this.World.Assets.addMoney(-cost)
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
		this.updateData(["TownAssets", "Assets", "LocationsModule"]);
	}

	function removeLocation(_data)
	{
		this.getTown().removeLocation(_data);
		this.updateData(["TownAssets", "Assets", "LocationsModule"]);
	}
})
