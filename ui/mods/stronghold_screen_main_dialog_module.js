
"use strict";
var StrongholdScreenMainDialogModule = function(_parent, _id)
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
    
    console.error("StrongholdScreenMainDialogModule created")
};


StrongholdScreenMainDialogModule.prototype.createDIV = function (_parentDiv)
{
	this.mIsVisible = false;
    var self = this;

    this.mContainer = $('<div class="stronghold-main-dialog-container display-none"/>');
    _parentDiv.append(this.mContainer)

    this.mContentContainer = $('<div class="stronghold-main-content-container"/>');
    this.mContainer.append(this.mContentContainer)
    
    this.mChangeNameContainer = $('<div class="row"/>');
    this.mContentContainer.append(this.mChangeNameContainer)
    var inputLayout = $('<div class="change-base-name-input-container"/>');
    this.mChangeNameInput = inputLayout.createInput("??", 0, 200, 1, null, 'title-font-big font-bold font-color-brother-name', function (_input)
	{
		self.mChangeNameButton.click()
	});

	var buttonLayout = $('<div class="change-base-name-button-container"/>');
    this.mChangeNameButton = buttonLayout.createTextButton("Change Name", function(){
    	self.changeBaseName();
    }, '', 1)
    this.mChangeNameContainer.append(inputLayout)
    this.mChangeNameContainer.append(buttonLayout)
    var testRow = $('<div class="row"/>');
    this.mContentContainer.append(testRow)
};

StrongholdScreenMainDialogModule.prototype.destroyDIV = function ()
{
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
	this.mIsVisible = true;
	console.error(this.mID + "::show")
	var self = this;
	this.mContainer.removeClass('display-none').addClass('display-block');
	this.loadAssetData(this.mParent.mAllAssetData)
};


StrongholdScreenMainDialogModule.prototype.hide = function ()
{
	this.mIsVisible = false;
	console.error(this.mID + "::hide")
	var self = this;
	this.mContainer.removeClass('display-block').addClass('display-none');
};

StrongholdScreenMainDialogModule.prototype.loadAssetData = function(_data)
{
	this.mChangeNameInput.setInputText(_data.Name);
}

StrongholdScreenMainDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

StrongholdScreenMainDialogModule.prototype.loadFromData = function (_data)
{

};

StrongholdScreenMainDialogModule.prototype.changeBaseName = function ()
{
	SQ.call(this.mParent.mSQHandle, 'changeBaseName', this.mChangeNameInput.getInputText());
};
