
"use strict";
var StrongholdScreenVisualsDialogModule = function(_parent)
{
	StrongholdScreenModuleTemplate.call(this, _parent);
	this.mID = "VisualsModule"
	this.mTitle = "Visuals"
    this.mCurrentBaseSprite = null;
    this.mBaseSprite = null;
    this.mBaseSpriteIndex = null;
    this.mBaseSpriteImages = [];
};

StrongholdScreenVisualsDialogModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenVisualsDialogModule.prototype, 'constructor', {
    value: StrongholdScreenVisualsDialogModule,
    enumerable: false,
    writable: true });

StrongholdScreenVisualsDialogModule.prototype.createDIV = function (_parentDiv)
{
	StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    var self = this;
    this.mContentContainer.addClass("visuals-module");

    this.mTitleTextContainer = this.mContentContainer.appendRow("Change Visuals").find(".sub-title");
    
    
    var baseSpriteRow = this.mContentContainer.appendRow("", "base-sprites-row gold-line-bottom");
    this.mSpriteNameLabel = baseSpriteRow.find(".sub-title");
    for (var i = 0; i < 3; i++) {
        var changeSpriteContainer = $('<div class="base-sprite-container"/>');
        baseSpriteRow.append(changeSpriteContainer)
        var baseSpriteImage = $('<img class="base-sprite-image"/>');
        changeSpriteContainer.append(baseSpriteImage);
        this.mBaseSpriteImages.push(baseSpriteImage)
    }
    
    
    var otherSpriteRow = this.mContentContainer.appendRow("Other Sprites", "other-sprites-row gold-line-bottom")
    this.mUnitSpriteImage = $('<img class="unit-sprite-image"/>');
    otherSpriteRow.append(this.mUnitSpriteImage)
    this.mHouseSpriteImage = $('<img class="house-sprite-image"/>');
    otherSpriteRow.append(this.mHouseSpriteImage)


    var footerRow = this.mContentContainer.appendRow(null, "footer-button-bar");
    var buttonLayout = $('<div class="switch-button-container"/>');
    footerRow.append(buttonLayout);
    var switchPrevButton = buttonLayout.createImageButton(Path.GFX + "ui/skin/switch_previous.png", function ()
    {
        self.switchSpriteImage(-1);
    }, "switch-image", 3);
    var switchNextButton = buttonLayout.createImageButton(Path.GFX + "ui/skin/switch_next.png", function ()
    {
        self.switchSpriteImage(1);
    }, "switch-image", 3);
    this.mApplySpritesButton = footerRow.createTextButton("Apply Sprites", function()
    {
        self.changeSprites();
    }, "apply-sprites-button", 1)
};

StrongholdScreenVisualsDialogModule.prototype.getSpriteIndex = function()
{
	return StrongholdConst.AllSprites.indexOf(this.mBaseSprite)
}

StrongholdScreenVisualsDialogModule.prototype.switchSpriteImage = function( _idx )
{
	var arrLen = StrongholdConst.AllSprites.length;
	var newIdx = this.getSpriteIndex() + _idx;
	if(newIdx == arrLen) newIdx = 0;
	if(newIdx < 0) newIdx = arrLen - 1
	this.mBaseSprite = StrongholdConst.AllSprites[newIdx];
    this.setSpriteImage();
}

StrongholdScreenVisualsDialogModule.prototype.setSpriteImage = function()
{
	var currentArr = StrongholdConst.Sprites[this.mBaseSprite];
	var baseSize = this.mParent.mData.Size;

    this.mBaseSpriteImages[0].attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.MainSprites[0] + ".png");
    this.mBaseSpriteImages[1].attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.MainSprites[1] + ".png");
    this.mBaseSpriteImages[2].attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.MainSprites[2] + ".png");

	this.mUnitSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.UnitSprite + ".png");
	this.mHouseSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.HouseSprites[0] + ".png");
    var text = currentArr.Name + " by " + currentArr.Author
    if(this.mCurrentBaseSprite == this.mBaseSprite)
    {
        text += (" (current visuals)")
    }
	this.mSpriteNameLabel.text(text)
} 


StrongholdScreenVisualsDialogModule.prototype.loadFromData = function(_data)
{
	this.mBaseSprite = this.mData.TownAssets.SpriteName;
    this.mCurrentBaseSprite = this.mData.TownAssets.SpriteName;
	this.mBaseSpriteIndex = this.getSpriteIndex();
	this.setSpriteImage()
}

StrongholdScreenVisualsDialogModule.prototype.changeSprites = function ()
{
    SQ.call(this.mSQHandle, 'changeSprites', this.mBaseSprite);
};
