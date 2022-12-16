var StrongholdScreen = function ()
{
	MSUUIScreen.call(this);
	this.mSQHandle 		 = null;
	this.mContainer		 = null;
	this.mActiveModule   = null;
    this.mActiveButton   = null;
	this.Modules = {
		"MainModule" : {
            "ButtonName" : "Main",
            "Button" : null,
            "Module" : null
        },
        "VisualsModule" : {
            "ButtonName" : "Visuals",
            "Button" : null,
            "Module" : null
        },
        "StashModule" : {
            "ButtonName" : "Stash",
            "Button" : null,
            "Module" : null
        },
        "RosterModule" : {
            "ButtonName" : "Roster",
            "Button" : null,
            "Module" : null
        },
        "BuildingsModule" : {
            "ButtonName" : "Buildings",
            "Button" : null,
            "Module" : null
        },
        "LocationsModule" : {
            "ButtonName" : "Locations",
            "Button" : null,
            "Module" : null
        },
        "UpgradeModule" : {
            "ButtonName" : "Upgrade",
            "Button" : null,
            "Module" : null
        },
        "HamletModule" : {
            "ButtonName" : "Hamlet",
            "Button" : null,
            "Module" : null
        },
        "MiscModule" : {
            "ButtonName" : "Misc",
            "Button" : null,
            "Module" : null
        },
	}
	this.mAssetValues = null;
	this.mAssets = new WorldTownScreenAssets(this);
    // this.mAssetContainer = null;
    // this.mAssets = {
    //     "mMoneyAsset"        : null,
    //     "mFoodAsset"         : null,
    //     "mAmmoAsset"         : null,
    //     "mSuppliesAsset"     : null,
    //     "mMedicineAsset"     : null,
    //     "mBrothersAsset"     : null,
    //     "mRosterAsset"       : null,
    //     "mBuildingAsset"     : null,
    //     "mLocationAsset"     : null,
    // }
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

    this.mFooter = $('<div class="footer"/>');
    this.mDialogContainer.append(this.mFooter);
    var layout = $('<div class="l-leave-button"/>');
    this.mFooter.append(layout);
    this.mLeaveButton = layout.createTextButton("Leave", $.proxy(function()
	{
        this.onLeaveButtonPressed();
    }, this), '', 1);

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
    Asset["ICON_ASSET_ROSTER"] = 'ui/icons/asset_brothers.png';
    Asset["ICON_ASSET_BUILDING"] = 'ui/icons/asset_brothers.png';
    Asset["ICON_ASSET_LOCATION"] = 'ui/icons/asset_brothers.png';
    this.mAssets.mMoneyAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_MONEY, 'is-money');
    this.mAssets.mFoodAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_FOOD, 'is-food');
    this.mAssets.mAmmoAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_AMMO, 'is-ammo');
    this.mAssets.mSuppliesAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_SUPPLIES, 'is-supplies');
    this.mAssets.mMedicineAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_MEDICINE, 'is-medicine');
    this.mAssets.mBrothersAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_BROTHERS, 'is-brothers');
    this.mAssets.mRosterAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_ROSTER, 'is-roster');
    this.mAssets.mBuildingAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_BUILDING, 'is-building');
    this.mAssets.mLocationAsset = this.createAssetDIV(this.mAssetContainer, Path.GFX + Asset.ICON_ASSET_LOCATION, 'is-location');
}


StrongholdScreen.prototype.createModules = function ()
{
	var self = this;
	// Maybe I shouldn't be doing this
	MSU.iterateObject(this.Modules, function(_key, _module){
		_module.Module = new window["StrongholdScreen" + _key](self);
	})
};

StrongholdScreen.prototype.createModuleOptionsButtons = function()
{
    var self = this;
    this.mModuleOptionsList = this.mModuleOptionsContainer.createList(1.0);
    this.mModuleOptionsListScrollContainer = this.mModuleOptionsList.findListScrollContainer();

    MSU.iterateObject(this.Modules, function(_key, _module){
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
    Object.keys(this.Modules).forEach(function(_key){
        self.Modules[_key].Module.register(self.mModuleContainer);
    })
};

StrongholdScreen.prototype.unregisterModules = function ()
{
    var self = this;
    Object.keys(this.Modules).forEach(function(_key){
        self.Modules[_key].Module.unregister();
    })
};

StrongholdScreen.prototype.getModule = function ( _module )
{
    return this.Modules[_module].Module;
};

StrongholdScreen.prototype.getModuleObject = function ( _module )
{
    return this.Modules[_module];
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
    this.loadAssetsData();
    this.loadModuleData()
}

StrongholdScreen.prototype.loadModuleData = function()
{
    var self = this;
    MSU.iterateObject(this.Modules, function(_key){
        var curModule = self.Modules[_key];
        if(curModule !== undefined && curModule.Module !== null)
        {
            curModule.Module.mData = self.mData;
            curModule.Module.mModuleData = self.mData[_key];
        }
    })
    if (this.mActiveModule != null) this.mActiveModule.loadFromData();
}

StrongholdScreen.prototype.updateData = function(_data)
{
    var updateAssets = false;
    var types = _data[0];
    var data = _data[1]
    for (var i = 0; i < types.length; i++)
    {
        var typeID = types[i];
        var typeValue = data[typeID]
        this.mData[typeID] = typeValue;
        if(typeID == "Assets" || typeID == "TownAssets")
        {
            updateAssets = true;
        }
    }
    if(updateAssets) this.loadAssetsData();
    this.loadModuleData()
}

StrongholdScreen.prototype.loadAssetsData = function()
{
	this.mAssets.loadFromData(this.mData['Assets']);
	this.mAssetValues = this.mData['Assets'];
}

StrongholdScreen.prototype.onLeaveButtonPressed = function()
{
	SQ.call(this.mSQHandle, 'onLeaveButtonPressed');
}

registerScreen("StrongholdScreen", new StrongholdScreen());
