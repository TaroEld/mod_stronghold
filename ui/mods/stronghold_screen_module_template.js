
"use strict";
var StrongholdScreenModuleTemplate = function(_parent, _id)
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

    this.mData = null;
    this.mModuleData = null;
    console.error(this.mID + " created")
};


StrongholdScreenModuleTemplate.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    this.mContainer = $('<div class="stronghold-module-dialog-container  display-none"/>');
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

StrongholdScreenModuleTemplate.prototype.bindTooltips = function ()
{
};

StrongholdScreenModuleTemplate.prototype.unbindTooltips = function ()
{
};


StrongholdScreenModuleTemplate.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

StrongholdScreenModuleTemplate.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};

StrongholdScreenModuleTemplate.prototype.register = function (_parentDiv)
{
    console.log(this.mID + '::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register' + this.mID + '. Reason: is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

StrongholdScreenModuleTemplate.prototype.unregister = function ()
{
     console.log(this.mID + 'UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister' + this.mID + '. Reason: is not initialized.');
        return;
    }

    this.destroy();
};

StrongholdScreenModuleTemplate.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};

StrongholdScreenModuleTemplate.prototype.show = function ()
{
	this.mIsVisible = true;
	console.error(this.mID + "::show")
	var self = this;
	this.mContainer.removeClass('display-none').addClass('display-block');
	this.loadFromData()
};


StrongholdScreenModuleTemplate.prototype.hide = function ()
{
	this.mIsVisible = false;
	console.error(this.mID + "::hide")
	var self = this;
	this.mContainer.removeClass('display-block').addClass('display-none');
};

StrongholdScreenModuleTemplate.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

StrongholdScreenModuleTemplate.prototype.loadFromData = function()
{
}
