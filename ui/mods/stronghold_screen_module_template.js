
"use strict";
var StrongholdScreenModuleTemplate = function(_parent)
{
	MSUUIScreen.call(this);
	this.mParent = _parent;
	this.mAssets = this.mParent.mAssets;
	this.mIsLoaded = false;
	this.mHasChangedData = false;
	// main div that can be shown or hidden
	this.mContainer = null;

	// where the actual content is inside
	this.mContentContainer = null;
    // generics
    this.mIsVisible = false;

    this.mData = null;
    this.mModuleData = null;
    this.mAlwaysUpdate = false;
    this.mUpdateOn = [];
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
    this.mData = null;
    this.mModuleData = null;
};

StrongholdScreenModuleTemplate.prototype.show = function ()
{
	var self = this;
	if (!this.mIsLoaded)
	{
		SQ.call(this.mParent.mSQHandle, 'getUIData', [this.mID], function(_data)
		{
			self.setModuleData(_data);
			self.onShow();
		});
	}
	else
	{
		this.onShow();
	}
};

StrongholdScreenModuleTemplate.prototype.onShow = function ()
{
	this.mIsVisible = true;
	this.notifyBackendOnShown();
	this.loadFromData();
	this.mContainer.removeClass('display-none').addClass('display-block');
};

StrongholdScreenModuleTemplate.prototype.setModuleData = function(_data)
{
	this.mData = this.mParent.mData;
	this.mModuleData = _data[this.mID];
	this.mIsLoaded = true;
	this.mHasChangedData = true;
	if (this.mIsVisible)
		this.loadFromData();
};

StrongholdScreenModuleTemplate.prototype.hide = function ()
{
	this.mIsVisible = false;
	this.notifyBackendOnHidden();
	this.mContainer.removeClass('display-block').addClass('display-none');
};

StrongholdScreenModuleTemplate.prototype.loadFromData = function()
{
	if (!this.mHasChangedData)
	{
		return false;
	}
	this.mHasChangedData = false;
	return true;
};

StrongholdScreenModuleTemplate.prototype.reloadData = function()
{
	SQ.call(this.mSQHandle, 'updateData');
};

// Refer popups to the parent
StrongholdScreenModuleTemplate.prototype.createPopup = function(_title, _subTitle, _headerImagePath, _classes, _modalBackground)
{
	var popup = this.mParent.mContainer.createPopupDialog(_title, _subTitle, _headerImagePath, _classes, _modalBackground);
	this.mParent.setPopupDialog(popup);
	this.mPopupDialog = popup;
	return popup;
};

StrongholdScreenModuleTemplate.prototype.destroyPopup = function()
{
	this.mParent.destroyPopupDialog();
	this.mPopupDialog = null;
};

StrongholdScreenModuleTemplate.prototype.addRequirementRow = function(_table, _requirement, _isValid)
{
	var icon = "";

	var tr = $("<tr/>")
		.appendTo(_table);
	if (_isValid === true)
		tr.append($("<td><img src='" + Path.GFX + "ui/icons/unlocked_small.png'/></td>"));
	else if (_isValid === false)
		tr.append($("<td><img src='" + Path.GFX + "ui/icons/locked_small.png'/></td>"));
	var font = _isValid ? "" : "font-color-disabled"
    var container = $("<td/>")
    	.appendTo(tr);
    tr.data("IsValid", _isValid);

    if (_requirement)
    {
    	_requirement
    		.appendTo(container)
    		.addClass(font)
    		.children()
    			.addClass(font);
    }
    return {
    	Row : tr,
    	Img : tr.find("img"),
    	Container : container
    };
};

StrongholdScreenModuleTemplate.prototype.areRequirementsFulfilled = function(_table)
{
	var fulfilled = true;
	_table.find("tr").each(function(_idx)
	{
		if ($(this).data("IsValid") === false)
			fulfilled = false;
	});
	return fulfilled;
};

StrongholdScreenModuleTemplate.prototype.getModuleText = function()
{
	return Stronghold.Text[this.mID];
};
