this.stronghold_screen <- {
	m = {
		JSHandle = null,
		Visible = null,
		OnConnectedListener = null,
		OnDisconnectedListener = null,
		OnScreenShownListener = null,
		OnScreenHiddenListener = null,
		OnClosePressedListener = null,
		Town = null,
	},

	function create()
	{
		this.m.Visible = false;
	}

	function destroy()
	{
		this.clearEventListener();
		this.m.JSHandle = this.UI.disconnect(this.m.JSHandle);
	}

	function isVisible()
	{
		return this.m.Visible != null && this.m.Visible == true;
	}

	function setOnConnectedListener( _listener )
	{
		this.m.OnConnectedListener = _listener;
	}

	function setOnDisconnectedListener( _listener )
	{
		this.m.OnDisconnectedListener = _listener;
	}
	
	function setOnClosePressedListener( _listener )
	{
		this.m.OnClosePressedListener = _listener;
	}

	function onCancelButtonPressed()
	{
		if (this.m.OnCancelButtonPressedListener != null)
		{
			this.m.OnCancelButtonPressedListener();
		}
	}

	function clearEventListener()
	{
		this.m.OnConnectedListener = null;
		this.m.OnDisconnectedListener = null;
		this.m.OnScreenHiddenListener = null;
		this.m.OnScreenShownListener = null;
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
				this.logWarning("Menustack pop")
				::Stronghold.StrongholdScreen.hide();
				this.m.WorldTownScreen.getMainDialogModule().reload();
				this.m.WorldTownScreen.showLastActiveDialog();
			});
			this.m.JSHandle.asyncCall("show", this.getUIData());
		}
	}
	

	function hide()
	{
		this.logWarning("stronghold_screen hide")
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.logWarning("stronghold_screen hide past if")
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("hide", null);
		}
	}

	function onCancelButtonPressed()
	{

	}

	function onScreenConnected()
	{
		if (this.m.OnConnectedListener != null)
		{
			this.m.OnConnectedListener();
		}
	}

	function onScreenDisconnected()
	{
		if (this.m.OnDisconnectedListener != null)
		{
			this.m.OnDisconnectedListener();
		}
	}


	function onScreenShown()
	{
		this.logWarning("onScreenShown")
		this.m.Visible = true;
	}

	function onScreenHidden()
	{
		this.logWarning("onScreenHidden")
		this.m.Visible = false;
	}

	function changeBaseName(_data)
	{
		this.logInfo("changeBaseName " + _data)
		this.m.Town.m.Name = _data;
		this.m.Town.getFlags().set("CustomName", true);
		this.m.Town.getLabel("name").Text = _data;
		
	}

	function getUIDataObject()
	{
		local ret = {
			PlayerAssets = {},
			TownAssets = {},
			UpgradeRequirements = {},
			MainModule =	{},
			VisualsModule =	{},
			UpgradeModule =	
			{
				UpgradeAdvantages = "",
				UpgradeRequirements = "",

			},
			BuildingsModule = {},
			LocationsModule = {},
			RosterModule = {}
		};
		return ret
	}

	function getUIData()
	{
		local ret = this.getUIDataObject();

		this.getTypeUIData("PlayerAssets", ret);
		this.getTypeUIData("TownAssets", ret);
		this.getTypeUIData("MainModule", ret);
		this.getTypeUIData("VisualsModule", ret);
		this.getTypeUIData("UpgradeModule", ret);
		this.getTypeUIData("BuildingsModule", ret);
		this.getTypeUIData("LocationsModule", ret);
		this.getTypeUIData("RosterModule", ret);
		return ret
	}

	function getSingleUIData(_type)
	{
		return this.getTypeUIData(_type, this.getUIDataObject());
	}

	function getMultipleUIData(_types)
	{
		local ret = this.getUIDataObject();
		foreach(type in _types)
		{
			this.getTypeUIData(type, ret);
		}
		return ret
	}

	function updateData(_type)
	{
		//either pass in a single type, like "VisualsModule", or an array of types, like  ["PlayerAssets", "TownAssets"]
		if(typeof _type == "string")
		{
			return [_type, this.getSingleUIData(_type)]
		}
		else
		{
			return [_type, this.getMultipleUIData(_type)]
		}
	}

	function getTypeUIData(_typeID, _ret)
	{
		switch(_typeID)
		{
			case "PlayerAssets":
				return this.getPlayerAssetsUIData(_ret.PlayerAssets);
			case "TownAssets":
				return this.getTownUIData(_ret.TownAssets);
			case "MainModule":
				return this.getMainUIData(_ret.MainModule);
			case "VisualsModule":
				return this.getVisualsUIData(_ret.VisualsModule);
			case "UpgradeModule":
				return this.getUpgradeUIData(_ret.UpgradeModule);
			case "BuildingsModule":
				return this.getBuildingsUIData(_ret.BuildingsModule);
			case "LocationsModule":
				return this.getLocationsUIData(_ret.LocationsModule);
			case "RosterModule":
				return this.getRosterUIData(_ret.RosterModule);
			default:
				this.logError("no such UI data! " + _typeID)
		}
		 
	}

	function getTownUIData(_ret)
	{
		local town = this.m.Town;
		local townRoster = town.getLocalRoster().getAll().len();
		local maxBuildingSlots = town.getSize() + 4;
		local currentBuildings = 0
		foreach (building in town.m.Buildings){
			if (building != null){
				currentBuildings++
			}
		}
		local currentLocations = 0;
		foreach (location in town.m.AttachedLocations){
			if (location != null && location.m.ID != "attached_location.harbor"){
				currentLocations++
			}
		}
		
		_ret.ID <- town.getID();
		_ret.Name <- town.getName();
		_ret.Size <- town.getSize();
		_ret.SizeName <- town.getSizeName();
		_ret.Upgrading <- town.isUpgrading();
		_ret.SpriteName <- town.getFlags().get("CustomSprite");
		_ret.mRosterAsset <- townRoster;
		_ret.mRosterAssetMax <- 16;
		_ret.mBuildingAsset <- currentBuildings;
		_ret.mBuildingAssetMax <- maxBuildingSlots;
		_ret.mLocationAsset <- currentLocations;
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

	function getMainUIData( _ret )
	{
		return _ret
	}

	function getHome()
	{
		return this.m.Town
	}

	function getUpgradeUIData( _ret )
	{
		local price = this.Stronghold.PriceMult * this.Stronghold.BuyPrices[this.m.Town.getSize()]
		local currentInventory = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades()]
		local nextInventory = currentInventory;
		if(this.World.Retinue.getInventoryUpgrades() < this.m.Town.getSize() + 1)
		{
			nextInventory = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades() + 1]
		}
		_ret.UpgradeAdvantages <- ::Stronghold.UnlockAdvantages;
		_ret.UpgradeRequirements <- {
		    Money  = {
		        TextDone = "You have the required " + price + " crowns.",
		        TextNotDone = "You don't have the required " + price + "crowns.",
		        Done = this.World.Assets.getMoney() >= price
		    },
		    Cart  = {
		        TextDone = format("You have a %s", currentInventory),
		        TextNotDone  = format("You need to level up your %s to a %s!", currentInventory, nextInventory),
		        Done  = this.World.Retinue.getInventoryUpgrades() >= this.m.Town.getSize() + 1
		    },
		    ActiveContract  = {
		        TextDone = "You don't have an active contract.",
		        TextNotDone = "You have an active contract.",
		        Done = this.World.Contracts.getActiveContract() == null
		    },
		}
		return _ret
	}

	function getBuildingsUIData( _ret )
	{
		foreach(buildingID, building in ::Stronghold.BuildingDefs)
		{
			local hasBuilding = this.getHome().hasBuilding(building.ID) || ("SouthID" in building && this.getHome().hasBuilding(building.SouthID))
			local requirements = []
			if ("Requirements" in building)
			{
				foreach(requirement in building.Requirements)
				{
					requirements.push({
						Text = requirement.Text,
						IsValid = requirement.IsValid(this.getHome())
					})
				}
			}
			_ret[buildingID] <- {
				Name = building.Name,
				ID = building.ID,
				Description = building.Description,
				Cost = building.Cost,
				Path = building.Path,
				ImagePath = building.Path + ".png",
				HasBuilding = hasBuilding,
				Requirements = requirements
			}
		}
		return _ret
	}

	function getLocationsUIData( _ret )
	{
		foreach(locationID, location in ::Stronghold.LocationDefs)
		{
			local hasLocation = this.getHome().countAttachedLocations(location.ID)
			local requirements = []
			if ("Requirements" in location)
			{
				foreach(requirement in location.Requirements)
				{
					requirements.push({
						Text = requirement.Text,
						IsValid = requirement.IsValid(this.getHome())
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

	function getVisualsUIData( _ret )
	{
		this.logInfo("getVisualsUIData")
		return _ret
	}

	function getRosterUIData( _ret )
	{
		return _ret
	}

	function changeSprites(_data)
	{
		this.logInfo("changeSprites " + _data)
		this.m.Town.onVisualsChanged(_data);
		this.m.JSHandle.asyncCall("updateData", this.updateData(["TownAssets", "VisualsModule"]));
	}

	function addBuilding(_data)
	{
		local cost = _data[1].tointeger() * ::Stronghold.PriceMult
		this.World.Assets.addMoney(-cost)
		local building = this.new("scripts/entity/world/settlements/buildings/" + _data[0]);
		this.getHome().addBuilding(building);
		this.m.JSHandle.asyncCall("updateData", this.updateData(["TownAssets", "PlayerAssets", "BuildingsModule"]));
	}

	function removeBuilding(_data)
	{
		this.getHome().removeBuilding(_data);
		this.m.JSHandle.asyncCall("updateData", this.updateData(["TownAssets", "PlayerAssets", "BuildingsModule"]));
	}

	function addLocation(_data)
	{
		local home = this.getHome();
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
		this.m.JSHandle.asyncCall("updateData", this.updateData(["TownAssets", "PlayerAssets", "LocationsModule"]));
	}

	function removeLocation(_data)
	{
		this.getHome().removeLocation(_data);
		this.m.JSHandle.asyncCall("updateData", this.updateData(["TownAssets", "PlayerAssets", "LocationsModule"]));
	}



	
};

