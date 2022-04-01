
"use strict";
var StrongholdScreenVisualsDialogModule = function(_parent, _id)
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

    this.mCurrentBaseSprite = null;
    this.mBaseSprite = null;
    this.mBaseSpriteIndex = null;
    this.mBaseSpriteImages = [];
    
    console.error("StrongholdScreenMainDialogModule created")
};


StrongholdScreenVisualsDialogModule.prototype.createDIV = function (_parentDiv)
{
	this.mIsVisible = false;
    var self = this;

    this.mContainer = $('<div class="stronghold-main-dialog-container display-none"/>');
    _parentDiv.append(this.mContainer)

    this.mContentContainer = $('<div class="stronghold-main-content-container visuals-module"/>');
    this.mContainer.append(this.mContentContainer)

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

StrongholdScreenVisualsDialogModule.prototype.destroyDIV = function ()
{
    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
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
	var baseSize = this.mParent.mAllAssetData.Size;

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

StrongholdScreenVisualsDialogModule.prototype.bindTooltips = function ()
{
};

StrongholdScreenVisualsDialogModule.prototype.unbindTooltips = function ()
{
};


StrongholdScreenVisualsDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

StrongholdScreenVisualsDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};

StrongholdScreenVisualsDialogModule.prototype.register = function (_parentDiv)
{
    console.log('WorldTownScreenMainDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register StrongholdScreenVisualsDialogModule. Reason: StrongholdScreenVisualsDialogModule is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

StrongholdScreenVisualsDialogModule.prototype.unregister = function ()
{
    console.log('StrongholdScreenVisualsDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister StrongholdScreenVisualsDialogModule. Reason: StrongholdScreenVisualsDialogModule is not initialized.');
        return;
    }

    this.destroy();
};

StrongholdScreenVisualsDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};

StrongholdScreenVisualsDialogModule.prototype.show = function ()
{
	this.mIsVisible = true;
	console.error(this.mID + "::show")
	var self = this;
	this.mContainer.removeClass('display-none').addClass('display-block');
	this.loadAssetData(this.mParent.mAllAssetData)
};


StrongholdScreenVisualsDialogModule.prototype.hide = function ()
{
	this.mIsVisible = false;
	console.error(this.mID + "::hide")
	var self = this;
	this.mContainer.removeClass('display-block').addClass('display-none');
};

StrongholdScreenVisualsDialogModule.prototype.loadAssetData = function(_data)
{
	this.mBaseSprite = _data.SpriteName;
    this.mCurrentBaseSprite = _data.SpriteName;
	this.mBaseSpriteIndex = this.getSpriteIndex();
	this.setSpriteImage()
}

StrongholdScreenVisualsDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

StrongholdScreenVisualsDialogModule.prototype.changeSprites = function ()
{
    SQ.call(this.mParent.mSQHandle, 'changeSprites', this.mBaseSprite);
};