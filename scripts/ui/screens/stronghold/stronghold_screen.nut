this.stronghold_screen <- ::inherit("scripts/mods/msu/ui_screen", {
	m = {
		ID = "StrongholdScreen",
		Town = null,
		ModulePath = "scripts/ui/screens/stronghold/modules/stronghold_screen_"
		Modules = {
			MainModule = {
				Module = null,
				Path = "main_module",
			},
			BuildingsModule = {
				Module = null,
				Path = "buildings_module",
			},
			LocationsModule = {
				Module = null,
				Path = "locations_module",
			},
			StashModule = {
				Module = null,
				Path = "stash_module",
			},
			RosterModule = {
				Module = null,
				Path = "roster_module",
			},
			VisualsModule = {
				Module = null,
				Path = "visuals_module",
			},
			UpgradeModule = {
				Module = null,
				Path = "upgrade_module",
			},
			HamletModule = {
				Module = null,
				Path = "hamlet_module",
			},
		},
	},

	function create()
	{
		this.m.Visible = false;
		foreach (id, module in this.m.Modules)
		{
			module.Module = this.new(this.m.ModulePath + module.Path);
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
			this.m.JSHandle.asyncCall("show", this.getFullUIData());
		}
	}

	function getModule(_id)
	{
		return this.m.Modules[_id].Module;
	}

	function getUIDataObject()
	{
		local ret = {
			Assets 				= {},
			TownAssets 			= {},
			UpgradeRequirements = {},
		};
		foreach (id, module in this.m.Modules)
		{
			ret[id] <- {};
		}
		return ret
	}

	function getFullUIData()
	{
		local ret = this.getUIDataObject();

		this.getTypeUIData("Assets", ret);
		this.getTypeUIData("TownAssets", ret);
		foreach (id, module in this.m.Modules)
		{
			this.getTypeUIData(id, ret);
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
		local townRoster = town.getLocalRoster().getAll().len();
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
		
		_ret.ID <- town.getID();
		_ret.Name <- town.getName();
		_ret.Size <- town.getSize();
		_ret.SizeName <- town.getSizeName();
		_ret.Upgrading <- town.isUpgrading();
		_ret.SpriteName <- town.getFlags().get("CustomSprite");
		_ret.mRosterAsset <- townRoster;
		_ret.mRosterAssetMax <- 16;
		_ret.mBuildingAsset <- town.getActiveBuildings().len();
		_ret.mBuildingAssetMax <- maxBuildingSlots;
		_ret.mLocationAsset <- town.m.AttachedLocations.len() - town.countAttachedLocations("attached_location.harbor");
		_ret.mLocationAssetMax <- town.m.AttachedLocationsMax;
		return _ret
	}

	function getPlayerAssetsUIData( _ret )
	{
		_ret.mMoneyAsset <- this.World.Assets.getMoney();
		_ret.mFoodAsset <- this.World.Assets.getFood();
		_ret.mAmmoAsset <- this.World.Assets.getArmorParts();
		_ret.mSuppliesAsset <- this.World.Assets.getAmmo();
		_ret.mMedicineAsset <- this.World.Assets.getMedicine();
		_ret.mBrothersAsset <-this.World.getPlayerRoster().getAll().len();
		_ret.mBrothersAssetMax <- this.World.Assets.getBrothersMax();
		_ret.mInventoryUpgrades <- this.World.Retinue.getInventoryUpgrades();
		return _ret
	}

	function updateData(_type)
	{
		// Either pass in a single type, like "VisualsModule", or an array of types, like  ["PlayerAssets", "TownAssets"]
		if (typeof _type == "string")
			_type = [_type];
		this.m.JSHandle.asyncCall("updateData",  [_type, this.getUIData(_type)]);
	}

	function onLeaveButtonPressed()
	{
		this.World.State.m.MenuStack.pop();
	}
});
