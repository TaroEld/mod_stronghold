
"use strict";
var StrongholdScreenMainDialogModule = function(_parent, _id)
{
    StrongholdScreenModuleTemplate.call(this, _parent, _id);
    this.mBaseSprite = null;
    this.mBaseSpriteIndex = null;
};

StrongholdScreenMainDialogModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenMainDialogModule.prototype, 'constructor', {
    value: StrongholdScreenMainDialogModule,
    enumerable: false,
    writable: true });

StrongholdScreenMainDialogModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    this.mContentContainer.addClass("main-module");
    var self = this;    

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
	var baseSize = this.mParent.mData.Size;
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

StrongholdScreenMainDialogModule.prototype.loadFromData = function()
{
}

StrongholdScreenMainDialogModule.prototype.changeBaseName = function ()
{
	SQ.call(this.mSQHandle, 'changeBaseName', this.mChangeNameInput.getInputText());
};
