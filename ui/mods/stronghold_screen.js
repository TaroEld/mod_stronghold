var StrongholdScreen = function ()
{
	MSUUIScreen.call(this);
	this.mSQHandle 		 = null;
	this.mContainer		 = null;
	this.mActiveModule   = null;
    this.mActiveButton   = null;
	this.mModules = {
		"MainModule" : {
            "ButtonName" : "Main",
        },
        "VisualsModule" : {
            "ButtonName" : "Visuals",
        },
        "StashModule" : {
            "ButtonName" : "Stash",
        },
        "RosterModule" : {
            "ButtonName" : "Roster",
        },
        "BuildingsModule" : {
            "ButtonName" : "Buildings",
        },
        "LocationsModule" : {
            "ButtonName" : "Locations",
        },
        "UpgradeModule" : {
            "ButtonName" : "Upgrade",
        },
        "HamletModule" : {
            "ButtonName" : "Hamlet",
        },
        "MiscModule" : {
            "ButtonName" : "Misc",
        },
	}
	$.each(this.mModules, function(_id, _module)
	{
		_module.Id = _id;
		_module.Button = null;
		_module.Module = null;
		_module.IsLoaded = false;
	})
	this.mAssetValues = null;
	this.mAssets = new WorldTownScreenAssets(this);
    this.mData = null;
    //left side tab container
    this.mModuleOptionsContainer = null;
    //main content container for modules
    this.mModuleContainer = null;
    this.createModules();
};

StrongholdScreen.prototype = Object.create(MSUUIScreen.prototype);
Object.defineProperty(StrongholdScreen.prototype, 'constructor', {
	value: StrongholdScreen,
	enumerable: false,
	writable: true
});

StrongholdScreen.prototype.getData = function ()
{
    return this.mData;
};

StrongholdScreen.prototype.updateTitle = function ( _titleText )
{
    this.mTitle.text(_titleText);
};

StrongholdScreen.prototype.show = function (_data)
{
    if(_data !== undefined && _data !== null && typeof(_data) === 'object')
    {
		this.loadFromData(_data);
    }
    this.mContainer.removeClass('display-none').addClass('display-block');
    this.switchModule("MainModule");
    this.notifyBackendOnShown();
};

StrongholdScreen.prototype.hide = function ()
{
    var self = this;

	this.mActiveModule.hide();
    this.mActiveModule = null;

    $.each(this.mModules, function(_id, _module)
    {
    	_module.mIsLoaded = false;
    	//_module.mHasChangedData = true;
    })
    this.mContainer.removeClass('display-block').addClass('display-none');
    this.notifyBackendOnHidden();
};

StrongholdScreen.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.registerModules();
};

StrongholdScreen.prototype.destroy = function()
{
    this.unregisterModules();
    this.destroyDIV();
};


StrongholdScreen.prototype.createDIV = function (_parentDiv)
{
	this.mContainer = $('<div class="stronghold-screen ui-control dialog-modal-background display-none"/>');
	_parentDiv.append(this.mContainer);
    var dialogLayout = $('<div class="l-stronghold-dialog-container"/>');
    this.mContainer.append(dialogLayout);
    this.mDialogContainer = $('<div class="ui-control dialog dialog-stronghold-main"/>');
    dialogLayout.append(this.mDialogContainer)

    var header = $('<div class="header"/>');
    this.mDialogContainer.append(header);
    var titleTextContainer = $('<div class="text-container"/>');
    header.append(titleTextContainer)
    this.mTitle = $('<div class="title has-no-sub-title title-font-very-big font-bold font-bottom-shadow font-color-title">Your Base</div>');
    titleTextContainer.append(this.mTitle);

    this.mAssetContainer = $('<div class="asset-container"/>');
    this.mDialogContainer.append(this.mAssetContainer);
    this.mAssets.createDIV(this.mAssetContainer);
    this.mAssetContainer.find(".is-brothers").remove();
    this.mAssets.bindTooltips();

    this.mModuleOptionsContainer = $('<div class="vertical-tab-container"/>');
    this.mDialogContainer.append(this.mModuleOptionsContainer);

    this.mModuleContainer  = $('<div class="module-container"/>');
    this.mDialogContainer.append(this.mModuleContainer)

    var footer = this.mDialogContainer.appendRow(null, "stronghold-flex-center footer");
    this.mLeaveButton = footer.createTextButton("Leave", $.proxy(function()
	{
        this.onLeaveButtonPressed();
    }, this), 'stronghold-button-1', 1);

    this.createModuleOptionsButtons();

}

StrongholdScreen.prototype.createAssetDIV = function (_parentDiv, _imagePath, _classExtra)
{
    var layout = $('<div class="asset"/>');
    layout.addClass(_classExtra);
    layout.data('value', 0);
    _parentDiv.append(layout);

    var image = $('<img/>');
    image.attr('src', _imagePath);
    layout.append(image);
    var text = $('<div class="label text-font-normal font-color-assets-positive-value"/>');
    layout.append(text);

    return layout;
};

StrongholdScreen.prototype.createAssetDIVs = function()
{
    Asset["ICON_ASSET_ROSTER_STRONGHOLD"] = 'ui/icons/asset_brothers.png';
    Asset["ICON_ASSET_BUILDING_STRONGHOLD"] = 'ui/icons/asset_brothers.png';
    Asset["ICON_ASSET_LOCATION_STRONGHOLD"] = 'ui/icons/asset_brothers.png';
    this.mAssets.mMoneyAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_MONEY, 'is-money');
    this.mAssets.mFoodAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_FOOD, 'is-food');
    this.mAssets.mAmmoAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_AMMO, 'is-ammo');
    this.mAssets.mSuppliesAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_SUPPLIES, 'is-supplies');
    this.mAssets.mMedicineAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_MEDICINE, 'is-medicine');
    this.mAssets.mBrothersAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_BROTHERS, 'is-brothers');
    this.mAssets.mRosterAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_ROSTER_STRONGHOLD, 'is-roster');
    this.mAssets.mBuildingAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_BUILDING_STRONGHOLD, 'is-building');
    this.mAssets.mLocationAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_LOCATION_STRONGHOLD, 'is-location');
}


StrongholdScreen.prototype.createModules = function ()
{
	var self = this;
	// Maybe I shouldn't be doing this
	MSU.iterateObject(this.mModules, function(_key, _module){
		_module.Module = new window["StrongholdScreen" + _key](self);
	})
};

StrongholdScreen.prototype.createModuleOptionsButtons = function()
{
    var self = this;
    this.mModuleOptionsList = this.mModuleOptionsContainer.createList(1.0);
    this.mModuleOptionsListScrollContainer = this.mModuleOptionsList.findListScrollContainer();

    MSU.iterateObject(this.mModules, function(_key, _module){
        var row = $('<div class="row"/>');
        self.mModuleOptionsListScrollContainer.append(row);
        _module.Button = row.createTextButton(_module.ButtonName, function ()
        {
            self.switchModule(_key);
        }, '', 2);
    })
}

StrongholdScreen.prototype.registerModules = function ()
{
    var self = this;
    Object.keys(this.mModules).forEach(function(_key){
        self.mModules[_key].Module.register(self.mModuleContainer);
    })
};

StrongholdScreen.prototype.unregisterModules = function ()
{
    var self = this;
    Object.keys(this.mModules).forEach(function(_key){
        self.mModules[_key].Module.unregister();
    })
};

StrongholdScreen.prototype.getModule = function ( _module )
{
    return this.mModules[_module].Module;
};

StrongholdScreen.prototype.getModuleObject = function ( _module )
{
    return this.mModules[_module];
};

StrongholdScreen.prototype.switchModule = function ( _module )
{
    if(this.mActiveModule !== null)
    {
        this.mActiveModule.hide();
    }
    if (this.mActiveButton !== null)
    {
        this.mActiveButton.enableButton(true);
    }

    this.mActiveModule = this.getModuleObject(_module).Module;
    this.mActiveButton = this.getModuleObject(_module).Button;
    this.mActiveButton.enableButton(false);
    this.mActiveModule.show();
    this.updateTitle(this.mActiveModule.mTitle);
};

StrongholdScreen.prototype.loadFromData = function(_data)
{
    var self = this;
    this.mData = _data;
    this.loadPlayerAssetsData();
    this.loadTownAssetsData();
}

StrongholdScreen.prototype.updateData = function(_data)
{
    var types = _data[0];
    var data = _data[1]
    for (var i = 0; i < types.length; i++)
    {
        var typeID = types[i];
        var typeValue = data[typeID]
        this.mData[typeID] = typeValue;
        if (typeID == "Assets")
        {
        	this.loadPlayerAssetsData();
        }
        else if (typeID == "TownAssets")
        {
        	this.loadTownAssetsData();
        }
        else if (typeID in this.mModules)
        {
        	this.mModules[typeID].Module.setModuleData(data);
        }
    }
}

StrongholdScreen.prototype.loadPlayerAssetsData = function()
{
	console.error("loadPlayerAssetsData")
	this.mAssets.loadFromData(this.mData['Assets']);
}

StrongholdScreen.prototype.loadTownAssetsData = function()
{
	this.getModuleObject("StashModule").Button.enableButton(this.mData.TownAssets.Locations.Warehouse.HasStructure);
	this.getModuleObject("RosterModule").Button.enableButton(this.mData.TownAssets.Locations.Troop_Quarters.HasStructure);
	if (this.mData['TownAssets'].IsMainBase === false)
	{
		this.getModuleObject("StashModule").Button.enableButton(false);
		this.getModuleObject("RosterModule").Button.enableButton(false);
		this.getModuleObject("LocationsModule").Button.enableButton(false);
		this.getModuleObject("UpgradeModule").Button.enableButton(false);
		this.getModuleObject("HamletModule").Button.enableButton(false);
		this.getModuleObject("MiscModule").Button.enableButton(false);
		return;
	}
	var self = this;
	$.each(["UpgradeModule","HamletModule","MiscModule","LocationsModule", "BuildingsModule"], function(_idx, _str){
		self.getModuleObject(_str).Button.enableButton(self.mData['TownAssets'].IsUpgrading === false);
	})
}


StrongholdScreen.prototype.onLeaveButtonPressed = function()
{
	SQ.call(this.mSQHandle, 'onLeaveButtonPressed');
}

StrongholdScreen.prototype.getVisuals = function(_data)
{
	Stronghold.Visuals.VisualsMap = _data;
	Stronghold.Visuals.VisualsKeys = Object.keys(_data);
}

registerScreen("StrongholdScreen", new StrongholdScreen());
