
"use strict";
var StrongholdScreenRosterDialogModule = function(_parent, _id)
{
	this.mParent = _parent;
	this.mSQHandle = _parent.mSQHandle
	this.mID = _id;
	// main div that can be shown or hidden
	this.mContainer = null;

	// where the actual content is inside
	this.mContentContainer = null;
    // generics
    this.mIsVisible = false;
    console.error("StrongholdScreenRosterDialogModule created")
};

StrongholdScreenRosterDialogModule.prototype.destroyDIV = function ()
{
    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

StrongholdScreenRosterDialogModule.prototype.bindTooltips = function ()
{
};

StrongholdScreenRosterDialogModule.prototype.unbindTooltips = function ()
{
};


StrongholdScreenRosterDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

StrongholdScreenRosterDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};

StrongholdScreenRosterDialogModule.prototype.register = function (_parentDiv)
{
    console.log('WorldTownScreenMainDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register StrongholdScreenRosterDialogModule. Reason: StrongholdScreenRosterDialogModule is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

StrongholdScreenRosterDialogModule.prototype.unregister = function ()
{
    console.log('StrongholdScreenRosterDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister StrongholdScreenRosterDialogModule. Reason: StrongholdScreenRosterDialogModule is not initialized.');
        return;
    }

    this.destroy();
};

StrongholdScreenRosterDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};

StrongholdScreenRosterDialogModule.prototype.show = function ()
{
	this.mIsVisible = true;
	var self = this;
	this.mContainer.removeClass('display-none').addClass('display-block');
	this.loadFromData(this.mParent.mData)
};


StrongholdScreenRosterDialogModule.prototype.hide = function ()
{
	this.mIsVisible = false;
	var self = this;
	this.mContainer.removeClass('display-block').addClass('display-none');
};

StrongholdScreenRosterDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

StrongholdScreenRosterDialogModule.prototype.loadFromData = function()
{
    this.mData = this.mParent.getData();
}

StrongholdScreenRosterDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    this.mContainer = $('<div class="stronghold-module-dialog-container  display-none"/>');
    _parentDiv.append(this.mContainer)

    this.mContentContainer = $('<div class="stronghold-module-content-container"/>');
    this.mContainer.append(this.mContentContainer)
};