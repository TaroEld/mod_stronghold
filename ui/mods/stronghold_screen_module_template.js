
"use strict";
var StrongholdScreenModuleTemplate = function(_parent)
{
	MSUUIScreen.call(this);
	this.mParent = _parent;
	this.mAssets = this.mParent.mAssets;
	// main div that can be shown or hidden
	this.mContainer = null;

	// where the actual content is inside
	this.mContentContainer = null;
    // generics
    this.mIsVisible = false;

    this.mData = null;
    this.mModuleData = null;
};

StrongholdScreenModuleTemplate.prototype = Object.create(MSUUIScreen.prototype);
Object.defineProperty(StrongholdScreenModuleTemplate.prototype, 'constructor', {
	value: StrongholdScreenModuleTemplate,
	enumerable: false,
	writable: true
});

// Need to overwrite UI screen onConnection() since modules don't need to be registered
StrongholdScreenModuleTemplate.prototype.onConnection = function (_handle, _parentDiv)
{
    this.mSQHandle = _handle;
};

StrongholdScreenModuleTemplate.prototype.onDisconnection = function ()
{
    this.mSQHandle = null;
};

StrongholdScreenModuleTemplate.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    this.mContainer = $('<div class="stronghold-module-dialog-container display-none"/>');
    _parentDiv.append(this.mContainer)

    this.mContentContainer = $('<div class="stronghold-module-content-container"/>');
    this.mContainer.append(this.mContentContainer)
};

StrongholdScreenModuleTemplate.prototype.destroyDIV = function ()
{
    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

StrongholdScreenModuleTemplate.prototype.show = function ()
{
	this.mIsVisible = true;
	this.notifyBackendOnShown();
	this.mContainer.removeClass('display-none').addClass('display-block');
	this.loadFromData()
};

StrongholdScreenModuleTemplate.prototype.hide = function ()
{
	this.mIsVisible = false;
	this.notifyBackendOnHidden();
	this.mContainer.removeClass('display-block').addClass('display-none');
};

StrongholdScreenModuleTemplate.prototype.loadFromData = function()
{
}

// Refer popups to the parent
StrongholdScreenModuleTemplate.prototype.createPopup = function(_title, _subTitle, _headerImagePath, _classes, _modalBackground)
{
	var popup = this.mParent.mContainer.createPopupDialog(_title, _subTitle, _headerImagePath, _classes, _modalBackground);
	this.mParent.setPopupDialog(popup);
	this.mPopupDialog = popup;
}

StrongholdScreenModuleTemplate.prototype.destroyPopup = function()
{
	this.mParent.destroyPopupDialog();
	this.mPopupDialog = null;
}
