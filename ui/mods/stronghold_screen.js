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
        "Test1" : {
            "ButtonName" : "Test1",
            "Button" : null,
            "Module" : null
        },
        "Test2" : {
            "ButtonName" : "Test2",
            "Button" : null,
            "Module" : null
        },
        "Test3" : {
            "ButtonName" : "Test3",
            "Button" : null,
            "Module" : null
        },
        "Test4" : {
            "ButtonName" : "Test4",
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
    this.createModules();
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
	this.Modules["MainModule"].Module = new StrongholdScreenMainDialogModule(this);
    this.Modules["Test1"].Module = new StrongholdScreenMainDialogModule(this);
    this.Modules["Test2"].Module = new StrongholdScreenMainDialogModule(this);
    this.Modules["Test3"].Module = new StrongholdScreenMainDialogModule(this);
    this.Modules["Test4"].Module = new StrongholdScreenMainDialogModule(this);
};

StrongholdScreen.prototype.registerModules = function ()
{
    var self = this;
    Object.keys(this.Modules).forEach(function(_key){
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

StrongholdScreen.prototype.loadAssetData = function( _data )
{
    var self = this;
    Object.keys(_data).forEach(function(_key){
        self.mAssets[_key].data("value", _data[_key])
        var label = self.mAssets[_key].find('.label:first');
        label.html(self.mAssets[_key].data("value"))
    })
}

StrongholdScreen.prototype.show = function (_data)
{
    if(_data !== undefined && _data !== null && typeof(_data) === 'object')
    {
		this.loadAssetData(_data['Assets']);
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
    this.mDialogContainer = $('<div class="ui-control dialog dialog-1024-768"/>');
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

StrongholdScreen.prototype.createModuleOptionsButtons = function()
{
    var self = this;
    this.mModuleOptionsList = this.mModuleOptionsContainer.createList(1.0);
    this.mModuleOptionsListScrollContainer = this.mModuleOptionsList.findListScrollContainer();

    Object.keys(this.Modules).forEach(function(_key){
        var row = $('<div class="l-row"/>');
        self.mModuleOptionsListScrollContainer.append(row);
        self.Modules[_key].Button = row.createTextButton(self.Modules[_key].ButtonName, function ()
        {
            self.switchModule(_key);
        }, '', 2);
    })
}

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

registerScreen("StrongholdScreen", new StrongholdScreen());
