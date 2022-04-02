
"use strict";
var StrongholdScreenStructuresDialogModule = function(_parent, _id)
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
    console.error("StrongholdScreenStructuresDialogModule created")
};

StrongholdScreenStructuresDialogModule.prototype.destroyDIV = function ()
{
    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

StrongholdScreenStructuresDialogModule.prototype.bindTooltips = function ()
{
};

StrongholdScreenStructuresDialogModule.prototype.unbindTooltips = function ()
{
};


StrongholdScreenStructuresDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

StrongholdScreenStructuresDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};

StrongholdScreenStructuresDialogModule.prototype.register = function (_parentDiv)
{
    console.log('WorldTownScreenMainDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register StrongholdScreenStructuresDialogModule. Reason: StrongholdScreenStructuresDialogModule is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

StrongholdScreenStructuresDialogModule.prototype.unregister = function ()
{
    console.log('StrongholdScreenStructuresDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister StrongholdScreenStructuresDialogModule. Reason: StrongholdScreenStructuresDialogModule is not initialized.');
        return;
    }

    this.destroy();
};

StrongholdScreenStructuresDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};

StrongholdScreenStructuresDialogModule.prototype.show = function ()
{
    this.mIsVisible = true;
    var self = this;
    this.mContainer.removeClass('display-none').addClass('display-block');
    this.loadFromData(this.mParent.mData)
};


StrongholdScreenStructuresDialogModule.prototype.hide = function ()
{
    this.mIsVisible = false;
    var self = this;
    this.mContainer.removeClass('display-block').addClass('display-none');
};

StrongholdScreenStructuresDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

StrongholdScreenStructuresDialogModule.prototype.loadFromData = function()
{
}

StrongholdScreenStructuresDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    this.mContainer = $('<div class="stronghold-module-dialog-container  display-none"/>');
    _parentDiv.append(this.mContainer)

    this.mContentContainer = $('<div class="stronghold-module-content-container"/>');
    this.mContainer.append(this.mContentContainer)
};