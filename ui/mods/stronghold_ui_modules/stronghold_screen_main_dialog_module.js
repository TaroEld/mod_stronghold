"use strict";
var StrongholdScreenMainModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mID = "MainModule";
    this.mTitle = "Your Base";
    this.mAlwaysUpdate = true;
    this.mHeaderRow = null;
    this.mBaseSpriteImage = null;
};

StrongholdScreenMainModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenMainModule.prototype, 'constructor', {
    value: StrongholdScreenMainModule,
    enumerable: false,
    writable: true });

StrongholdScreenMainModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    this.mContentContainer.addClass("main-module");
    var self = this;    

    this.mHeaderRow = this.mContentContainer.appendRow("", "gold-line-bottom description-row");
    var baseSpriteContainer = $('<div class="base-sprite-container"/>')
    	.appendTo(this.mHeaderRow);
    this.mBaseSpriteImage = $('<img class="base-sprite-image"/>')
    	.appendTo(baseSpriteContainer);

    var changeNameRow = $('<div class="change-name-row"/>')
    	.appendTo(this.mHeaderRow)
    this.mChangeNameInput = changeNameRow.createInput("", 0, 200, 1, null, 'title-font-big font-bold font-color-brother-name', function (_input)
	{
		self.mChangeNameButton.click()
	});
	this.mChangeNameButton = changeNameRow.createTextButton("Change Name", function(){
    	self.changeBaseName();
    }, '', 1)

    var addAssetRow = function(_parent, _name, _imgsrc)
    {
    	var ret = $('<div class="main-module-asset-row"/>')
    		.appendTo(_parent)
    	Stronghold.getTextSpan(_name)
    		.appendTo(ret)
    	$('<img class="main-module-asset-img">')
    		.attr("src", _imgsrc)
    		.appendTo(ret)
    	return ret;
    }

	addAssetRow(this.mContentContainer, "Tier", "");
    addAssetRow(this.mContentContainer, "Local Roster", "");
	addAssetRow(this.mContentContainer, "Local Stash", "");
	addAssetRow(this.mContentContainer, "Local Recruits", "");
	addAssetRow(this.mContentContainer, "Days since last visit", "");
	addAssetRow(this.mContentContainer, "Accumulated Gold", "");
	addAssetRow(this.mContentContainer, "Accumulated Tools", "");
	addAssetRow(this.mContentContainer, "Accumulated Medicine", "");
	addAssetRow(this.mContentContainer, "Accumulated Arrows", "");
};

StrongholdScreenMainModule.prototype.loadFromData = function()
{
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;
	this.mTitle = this.mData.TownAssets.Name;
	this.mParent.updateTitle(this.mTitle);
	this.mChangeNameInput.setInputText(this.mData.TownAssets.Name);
	var baseSprite = this.mData.TownAssets.SpriteName;
	var currentSprite = Stronghold.Visuals.Sprites[baseSprite].MainSprites[this.mData.TownAssets.Size -1];
    this.mBaseSpriteImage.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentSprite + ".png");
}

StrongholdScreenMainModule.prototype.changeBaseName = function ()
{
	SQ.call(this.mSQHandle, 'changeBaseName', this.mChangeNameInput.getInputText());
};
