
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

    this.mBaseSprite = null;
    this.mBaseSpriteIndex = null;
    
    console.error("StrongholdScreenMainDialogModule created")
};


StrongholdScreenMainDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    this.mContainer = $('<div class="stronghold-module-dialog-container  display-none"/>');
    _parentDiv.append(this.mContainer)

    this.mContentContainer = $('<div class="stronghold-module-content-container"/>');
    this.mContainer.append(this.mContentContainer)
    
    this.mChangeNameContainer = this.mContentContainer.appendRow(null, "gold-line-bottom change-name-row")
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


    var changeSpriteRow = this.mContentContainer.appendRow("Visuals", "gold-line-bottom");
    var changeSpriteContainer = $('<div class="base-sprite-container"/>');
    changeSpriteRow.append(changeSpriteContainer)
    this.mBaseSpriteImage = $('<img class="base-sprite-image"/>');
    changeSpriteContainer.append(this.mBaseSpriteImage);
	var buttonLayout = $('<div class="l-button-container"/>');
	changeSpriteContainer.append(buttonLayout);
	var switchPrevButton = buttonLayout.createImageButton(Path.GFX + "ui/skin/switch_previous.png", function ()
    {
    	self.switchSpriteImage(-1);
    }, "switch-image", 3);
	var switchNextButton = buttonLayout.createImageButton(Path.GFX + "ui/skin/switch_next.png", function ()
    {
    	self.switchSpriteImage(1);
    }, "switch-image", 3);

    var spriteDetailsContainer = $('<div class="base-details-container"/>');
    changeSpriteRow.append(spriteDetailsContainer)
    this.mSpriteNameLabel =  spriteDetailsContainer.appendRow("").find(".sub-title")
    var otherSpriteImageContainers = spriteDetailsContainer.appendRow(null, "other-sprites-container")
    this.mUnitSpriteImage = $('<img class="unit-sprite-image"/>');
    otherSpriteImageContainers.append(this.mUnitSpriteImage)
    this.mHouseSpriteImage = $('<img class="house-sprite-image"/>');
    otherSpriteImageContainers.append(this.mHouseSpriteImage)
    this.mApplySpritesButton = otherSpriteImageContainers.createTextButton("Apply Sprites", function()
    {
    	self.changeSprites();
    }, "apply-sprites-button", 1)


    var upgradeRow = this.mContentContainer.appendRow(null, "upgrade-base-row");
    var upgradeSpriteContainer = $('<div class="base-sprite-container"/>');
    upgradeRow.append(upgradeSpriteContainer);
    this.mBaseUpgradeSpriteImage = $('<img class="base-sprite-image"/>');
    upgradeSpriteContainer.append(this.mBaseUpgradeSpriteImage);

    var upgradeDetailsContainer = $('<div class="upgrade-details-container"/>');
    upgradeRow.append(upgradeDetailsContainer);
    this.mUpgradeNameLabel = upgradeDetailsContainer.appendRow("Upgrade Base").find(".sub-title");
    var upgradeDetails = upgradeDetailsContainer.appendRow();
    this.mUpgradeDetailsTextContainer = $('<div class="upgrade-base-text-container text-font-normal font-style-italic font-bottom-shadow font-color-subtitle"/>');
    upgradeDetails.append(this.mUpgradeDetailsTextContainer);
    this.mUpgradeBaseButton = upgradeDetails.createTextButton("Upgrade", function()
    {
    	self.changeSprites();
    }, "upgrade-base-button", 1)
};

StrongholdScreenMainDialogModule.prototype.destroyDIV = function ()
{
    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

StrongholdScreenMainDialogModule.prototype.getSpriteIndex = function()
{
	return StrongholdConst.AllSprites.indexOf(this.mBaseSprite)
}

StrongholdScreenMainDialogModule.prototype.switchSpriteImage = function( _idx )
{
	var arrLen = StrongholdConst.AllSprites.length;
	var newIdx = this.getSpriteIndex() + _idx;
	if(newIdx == arrLen) newIdx = 0;
	if(newIdx < 0) newIdx = arrLen - 1
	this.mBaseSprite = StrongholdConst.AllSprites[newIdx];
    this.setSpriteImage();
}

StrongholdScreenMainDialogModule.prototype.setSpriteImage = function()
{
	var currentArr = StrongholdConst.Sprites[this.mBaseSprite];
	var baseSize = this.mParent.mAllAssetData.Size;
	this.mBaseSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.MainSprites[baseSize - 1] + ".png");
	this.mUnitSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.UnitSprite + ".png");
	this.mHouseSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.HouseSprites[0] + ".png");
	this.mSpriteNameLabel.text(currentArr.Name + " by " + currentArr.Author)

	this.mBaseUpgradeSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.MainSprites[baseSize] + ".png");
} 

StrongholdScreenMainDialogModule.prototype.fillUpgradeDetailsText = function( _data )
{
	var text = _data.UnlockAdvantages[_data.Size];
	this.mUpgradeDetailsTextContainer.text("Upgrade advantages: \n" + text);
}

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
	this.loadFromData(this.mParent.mAllAssetData)
};


StrongholdScreenMainDialogModule.prototype.hide = function ()
{
	this.mIsVisible = false;
	console.error(this.mID + "::hide")
	var self = this;
	this.mContainer.removeClass('display-block').addClass('display-none');
};

StrongholdScreenMainDialogModule.prototype.loadFromData = function(_data)
{
	this.mChangeNameInput.setInputText(_data.Name);
	this.mBaseSprite = _data.SpriteName;
	this.mBaseSpriteIndex = this.getSpriteIndex();
	this.setSpriteImage()
	this.fillUpgradeDetailsText(_data)
}

StrongholdScreenMainDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

StrongholdScreenMainDialogModule.prototype.changeBaseName = function ()
{
	SQ.call(this.mParent.mSQHandle, 'changeBaseName', this.mChangeNameInput.getInputText());
};