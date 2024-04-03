this.stronghold_screen <- ::inherit("scripts/mods/msu/ui_screen", {
	m = {
		ID = "StrongholdScreen",
		Town = null,
		ModulePath = "scripts/ui/screens/stronghold/modules/stronghold_screen_"
		Modules = {
			MainModule = {
				Path = "main_module",
			},
			BuildingsModule = {
				Path = "buildings_module",
			},
			LocationsModule = {
				Path = "locations_module",
			},
			StashModule = {
				Path = "stash_module",
			},
			RosterModule = {
				Path = "roster_module",
			},
			VisualsModule = {
				Path = "visuals_module",
			},
			UpgradeModule = {
				Path = "upgrade_module",
			},
			MiscModule = {
				Path = "misc_module",
			},
		},
	},

	function create()
	{
		this.m.Visible = false;
		foreach (id, module in this.m.Modules)
		{
			module.Module <- this.new(this.m.ModulePath + module.Path);
			module.Module.setID(id);
			module.Module.setParent(this);
		}
	}

	function connect()
	{
		this.js_connection.connect();
		this.onConnected();
	}

	function onConnected()
	{
		foreach (id, module in this.m.Modules)
		{
			module.Module.connectUI(this.m.JSHandle);
		}
		this.sendVisuals();
	}

	function setTown( _t )
	{
		this.m.Town = _t;
	}

	function getTown()
	{
		return this.m.Town;
	}

	function show()
	{

		if (this.m.JSHandle != null && !this.isVisible())
		{
			this.Tooltip.hide();
			this.World.State.m.WorldTownScreen.hideAllDialogs();
			this.World.State.m.MenuStack.push(function ()
			{
				::Stronghold.StrongholdScreen.hide();
				this.m.WorldTownScreen.getMainDialogModule().reload();
				this.m.WorldTownScreen.showLastActiveDialog();
			});
			this.m.JSHandle.asyncCall("show", this.getUIData(["Assets", "TownAssets"]));
		}
	}


	function getModule(_id)
	{
		return this.m.Modules[_id].Module;
	}

	function getUIDataObject()
	{
		local ret = {
			Assets 			= {},
			TownAssets 		= {},
			Requirements 	= {},
		};
		foreach (id, module in this.m.Modules)
		{
			ret[id] <- {};
		}
		return ret
	}

	function getTypeUIData(_typeID, _ret)
	{
		if (_typeID == "Assets")
			return this.queryAssetsInformation(_ret);
		else if (_typeID == "TownAssets")
			return this.getTownUIData(_ret.TownAssets);
		else if (_typeID in this.m.Modules)
			return this.getModule(_typeID).getUIData(_ret[_typeID]);
		else
			this.logError("No such UI data! " + _typeID)
	}

	function queryAssetsInformation(_ret)
	{
		_ret.Assets = this.UIDataHelper.convertAssetsInformationToUIData();
		return _ret;
	}

	function getUIData(_types)
	{
		local ret = this.getUIDataObject();
		foreach(type in _types)
		{
			this.getTypeUIData(type, ret);
		}
		return ret;
	}

	function getTownUIData(_ret)
	{
		local town = this.getTown();
		local maxBuildingSlots = town.getSize() + 4;
		local currentBuildings = 0
		foreach (building in town.m.Buildings){
			if (building != null)
				currentBuildings++
		}
		local currentLocations = 0;
		foreach (location in town.m.AttachedLocations){
			if (location != null && location.m.ID != "attached_location.harbor")
				currentLocations++
		}
		local isRaidedUntil = -1;
		if (town.hasSituation("situation.raided"))
		{
			local until = town.getSituationByID("situation.raided").getValidUntil();
			isRaidedUntil = (until - this.Time.getVirtualTimeF()) / this.World.getTime().SecondsPerDay;
			::logInfo(isRaidedUntil)
			isRaidedUntil = ::Math.round(isRaidedUntil);
			::logInfo(isRaidedUntil)
		}

		_ret.ID <- town.getID();
		_ret.Name <- town.getName();
		_ret.IsMainBase <- town.isMainBase();
		_ret.Size <- town.getSize();
		_ret.SizeName <- town.getSizeName();
		_ret.IsUpgrading <- town.isUpgrading();
		_ret.IsCoastal <- town.isCoastal();
		_ret.HasHamlet <- town.getFlags().get("Child");
		_ret.Spriteset <- town.m.Spriteset;
		_ret.mRosterAsset <- _ret.IsMainBase ? town.getLocalRoster().getAll().len() : -1;
		_ret.mRosterAssetMax <- town.getLocation("attached_location.troop_quarters") != null ?  town.getLocation("attached_location.troop_quarters").getSlots() : 0;
		_ret.mBuildingAsset <- town.getActiveBuildings().len();
		_ret.IsRaidedUntil <- isRaidedUntil;
		_ret.mBuildingAssetMax <- maxBuildingSlots;
		_ret.mLocationAsset <- town.m.AttachedLocations.len() - town.getLocation("attached_location.harbor") != null ? 1 : 0;
		_ret.mLocationAssetMax <- town.m.AttachedLocationsMax;
		_ret.Locations <- {};
		foreach(locationID, location in ::Stronghold.LocationDefs)
		{
			local locObj = town.getLocation(location.ID);
			local requirements = [];
			foreach(requirement in location.Requirements)
			{
				requirements.push({
					Text = requirement.Text,
					IsValid = requirement.IsValid(this.getTown())
				})
			}
			_ret.Locations[locationID] <- {
				ConstID = locationID,
				ImagePath = location.Path + ".png",
				HasStructure = locObj != null,
				Level = locObj == null ? null : locObj.m.Level,
				Requirements = requirements
			}
			::MSU.Table.merge(_ret.Locations[locationID], location, true);
		}
		_ret.BaseSettings <- town.m.BaseSettings;
		_ret.ItemOverflow <- [];
		if (town.isMainBase())
		{
			foreach (item in town.m.OverflowStash.getItems())
			[
				_ret.ItemOverflow.push({
					Name = item.getName(),
					Icon = item.getIcon(),
					ID = item.getInstanceID()
				})
			]
		}
		return _ret
	}

	function updateData(_type)
	{
		// Either pass in a single type, like "VisualsModule", or an array of types, like  ["PlayerAssets", "TownAssets"]
		if (typeof _type == "string")
			_type = [_type];
		this.m.JSHandle.asyncCall("updateData",  [_type, this.getUIData(_type)]);
	}

	function sendVisuals()
	{
		local ret = {}
		foreach(name, entry in ::Stronghold.VisualsMap)
		{
			ret[name] <- {
				ID = entry.ID,
				Name = entry.Name,
				Author = entry.Author,
				WorldmapFigure = entry.WorldmapFigure,
				Base = entry.Base.map(@ (_v) _v[0]),
				Upgrading = entry.Upgrading.map(@ (_v) _v[0]),
				Houses = entry.Houses.map(@ (_v) _v[0]),
			}
		}
		this.m.JSHandle.asyncCall("getVisuals",  ret);
	}

	function onLeaveButtonPressed()
	{
		this.World.State.m.MenuStack.pop();
	}
});
