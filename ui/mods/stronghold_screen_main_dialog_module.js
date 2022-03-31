
"use strict";
var StrongholdScreenMainDialogModule = function(_parent)
{
	this.mParent = _parent;
	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;
    // generics
    this.mIsVisible = false;
    console.error("StrongholdScreenMainDialogModule created")
};


StrongholdScreenMainDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    // create: containers (init hidden!)
    this.mContainer = $('<div class="stronghold-main-dialog-container display-none"/>');
    this.mIsVisible = false;
};

StrongholdScreenMainDialogModule.prototype.destroyDIV = function ()
{
    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

StrongholdScreenMainDialogModule.prototype.bindTooltips = function ()
{
};

StrongholdScreenMainDialogModule.prototype.unbindTooltips = function ()
{
};


StrongholdScreenMainDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

StrongholdScreenMainDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};

StrongholdScreenMainDialogModule.prototype.register = function (_parentDiv)
{
    console.log('WorldTownScreenMainDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register StrongholdScreenMainDialogModule. Reason: StrongholdScreenMainDialogModule is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

StrongholdScreenMainDialogModule.prototype.unregister = function ()
{
    console.log('StrongholdScreenMainDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister StrongholdScreenMainDialogModule. Reason: StrongholdScreenMainDialogModule is not initialized.');
        return;
    }

    this.destroy();
};

StrongholdScreenMainDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};

StrongholdScreenMainDialogModule.prototype.show = function ()
{
	console.error("StrongholdScreenMainDialogModule show")
	var self = this;
	this.mContainer.removeClass('display-none').addClass('display-block');
	this.mIsVisible = true;
};

StrongholdScreenMainDialogModule.prototype.hide = function ()
{
	console.error("StrongholdScreenMainDialogModule hide")
	var self = this;
	this.mContainer.removeClass('display-block').addClass('display-none');
	this.mIsVisible = false;
};

StrongholdScreenMainDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

StrongholdScreenMainDialogModule.prototype.loadFromData = function (_data)
{

};
