var StrongholdScreen = function ()
{
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
	}
    this.mAssetContainer = null;
    this.mAssets = {
        "mMoneyAsset"        : null,
        "mFoodAsset"         : null,
        "mAmmoAsset"         : null,
        "mSuppliesAsset"     : null,
        "mMedicineAsset"     : null,
        "mBrothersAsset"     : null,
        "mRosterAsset"       : null,
        "mBuildingAsset"     : null,
        "mLocationAsset"     : null
    }
    this.mData = null;
    //left side tab container
    this.mModuleOptionsContainer = null;
    //main content container for modules
    this.mModuleContentContainer = null;
    this.createModules();
};

StrongholdScreen.prototype.getData = function ()
{
    return this.mData;
};

StrongholdScreen.prototype.isConnected = function ()
{
	return this.mSQHandle !== null;
};

StrongholdScreen.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;
	this.register($('.root-screen'));
};

StrongholdScreen.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
	this.unregister();
};


StrongholdScreen.prototype.destroyDIV = function ()
{
    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

StrongholdScreen.prototype.notifyBackendOnShown = function ()
{
    console.error("StrongholdScreen::notifyBackendOnShown")
    console.error(this.mSQHandle)
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenShown');
    }
};

StrongholdScreen.prototype.notifyBackendOnHidden = function ()
{
    console.error("StrongholdScreen::notifyBackendOnShown")
    console.error(this.mSQHandle)
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenHidden');
    }
};


StrongholdScreen.prototype.registerModules = function ()
{
    var self = this;
    Object.keys(this.Modules).forEach(function(_key){
        console.error("registering module: " + _key)
        self.Modules[_key].Module.register(self.mModuleContentContainer);
    })
};

StrongholdScreen.prototype.unregisterModules = function ()
{
    var self = this;
    Object.keys(this.Modules).forEach(function(_key){
        self.Modules[_key].Module.unregister();
    })
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

    this.mActiveModule = this.getModule(_module).Module;
    this.mActiveButton = this.getModule(_module).Button;
    this.mActiveButton.enableButton(false);
    this.mActiveModule.show();
};

StrongholdScreen.prototype.getModule = function ( _module )
{
    return this.Modules[_module];
};

StrongholdScreen.prototype.createModules = function ()
{
    this.Modules["MainModule"].Module = new StrongholdScreenMainDialogModule(this, "MainModule");
    this.Modules["VisualsModule"].Module = new StrongholdScreenVisualsDialogModule(this, "VisualsModule");
    this.Modules["RosterModule"].Module = new StrongholdScreenRosterDialogModule(this, "RosterModule");
    this.Modules["BuildingsModule"].Module = new StrongholdScreenBuildingsDialogModule(this, "BuildingsModule");
    this.Modules["LocationsModule"].Module = new StrongholdScreenLocationsDialogModule(this, "LocationsModule");
    this.Modules["UpgradeModule"].Module = new StrongholdScreenUpgradeDialogModule(this, "UpgradeModule");
};

StrongholdScreen.prototype.show = function (_data)
{
    if(_data !== undefined && _data !== null && typeof(_data) === 'object')
    {
		this.loadFromData(_data);
    }
    console.error("StrongholdScreen show")
    this.mContainer.removeClass('display-none').addClass('display-block');
    this.switchModule("MainModule");
    this.notifyBackendOnShown();
};

StrongholdScreen.prototype.hide = function ()
{
    var self = this;

	this.mActiveModule.hide();
    this.mActiveModule = null;
    console.error("StrongholdScreen hide")
    this.mContainer.removeClass('display-block').addClass('display-none');
    this.notifyBackendOnHidden();
};

StrongholdScreen.prototype.register = function (_parentDiv)
{
    console.log('StrongholdScreen::REGISTER');

    if(this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Stronghold Screen. Reason: Stronghold Screen is already initialized.');
        return;
    }

    if(_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

StrongholdScreen.prototype.unregister = function ()
{
    console.log('StrongholdScreen::UNREGISTER');

    if(this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Stronghold Screen. Reason: Stronghold Screen is not initialized.');
        return;
    }

    this.destroy();
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

    this.mModuleOptionsContainer = $('<div class="vertical-tab-container"/>');
    this.mDialogContainer.append(this.mModuleOptionsContainer);

    this.mModuleContentContainer  = $('<div class="module-content"/>');
    this.mDialogContainer.append(this.mModuleContentContainer)

    this.mFooter = $('<div class="footer"/>');
    this.mDialogContainer.append(this.mFooter);

    this.createModuleOptionsButtons();
    this.createAssetDIVs();
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

StrongholdScreen.prototype.createModuleOptionsButtons = function()
{
    var self = this;
    this.mModuleOptionsList = this.mModuleOptionsContainer.createList(1.0);
    this.mModuleOptionsListScrollContainer = this.mModuleOptionsList.findListScrollContainer();

    iterateObject(this.Modules, function(_key, _module){
        var row = $('<div class="row"/>');
        self.mModuleOptionsListScrollContainer.append(row);
        _module.Button = row.createTextButton(_module.ButtonName, function ()
        {
            self.switchModule(_key);
        }, '', 2);
    })
}

StrongholdScreen.prototype.loadFromData = function(_data)
{
    var self = this;
    this.mData = _data;
    this.mTitle.html(this.mData.Name)
    this.loadAssetsData();
    this.loadModuleData()
}

StrongholdScreen.prototype.loadModuleData = function()
{
    var self = this;
    iterateObject(this.Modules, function(_key){
        var curModule = self.Modules[_key];
        if(curModule !== undefined && curModule.Module !== null)
        {
            curModule.Module.mData = self.mData;
            curModule.Module.mModuleData = self.mData[_key];
        }
    })
    if(this.mActiveModule != null) this.mActiveModule.loadFromData();
}

StrongholdScreen.prototype.updateData = function(_data)
{
    var updateAssets = false;
    var types = _data[0];
    var data = _data[1]
    if(typeof types == "string")
    {
        types = [types];
    }
    for (var i = 0; i < types.length; i++) {
        var typeID = types[i];
        var typeValue = data[typeID]
        this.mData[typeID] = typeValue;
        if(typeID == "PlayerAssets" || typeID == "TownAssets")
        {
            updateAssets = true;
        }
    }
    if(updateAssets) this.loadAssetsData();
    this.loadModuleData()
}

StrongholdScreen.prototype.loadAssetsData = function()
{
    var self = this;
    var playerAssets = this.mData['PlayerAssets']
    var townAssets = this.mData['TownAssets']
    Object.keys(this.mAssets).forEach(function(_key){
        var assets;
        if (_key in playerAssets) assets = playerAssets;
        else if (_key in townAssets) assets = townAssets;
        else return
        self.mAssets[_key].data("value", assets[_key]);
        var label = self.mAssets[_key].find('.label:first');
        var labelText = assets[_key]
        if(_key + "Max" in assets)
        {
            labelText += " / " + assets[_key + "Max"] 
        }
        label.html(labelText)
    })
}


registerScreen("StrongholdScreen", new StrongholdScreen());