this.stronghold_screen_locations_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {
	},
	function getUIData( _ret )
	{
		foreach(locationID, location in ::Stronghold.LocationDefs)
		{
			local locationInTown =  this.getTown().getLocation(location.ID)
			local requirements = [];
			foreach(requirement in location.Requirements)
			{
				requirements.push({
					Text = requirement.Text,
					IsValid = requirement.IsValid(this.getTown())
				})
			}
			_ret[locationID] <- {
				HasStructure = locationInTown != null,
				Level = 0,
				Requirements = requirements,
			}
			if (locationInTown != null)
				_ret[locationID].Level = locationInTown.m.Level
			::MSU.Table.merge(_ret[locationID], location, true);
		}
		return _ret
	}

	function addLocation(_data)
	{
		local home = this.getTown();
		local locationDef = ::Stronghold.LocationDefs[_data];
		this.World.Assets.addMoney(-locationDef.Price)
		local script = "scripts/entity/world/attached_location/" + locationDef.Path
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

	function upgradeLocation(_data)
	{
		local locationDef = ::Stronghold.LocationDefs[_data];
		local location = this.getTown().getLocation(locationDef.ID);
		location.upgrade();
		this.World.Assets.addMoney(-locationDef.UpgradePrice);
		this.getTown().removeLocation(_data);
		this.updateData(["TownAssets", "Assets", "LocationsModule"]);
	}

	function removeLocation(_data)
	{
		local locationDef = ::Stronghold.LocationDefs[_data];
		this.getTown().removeLocation(locationDef.ID);
		this.updateData(["TownAssets", "Assets", "LocationsModule"]);
	}
})
