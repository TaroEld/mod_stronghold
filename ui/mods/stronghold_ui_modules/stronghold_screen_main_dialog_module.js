
"use strict";
var StrongholdScreenMainDialogModule = function(_parent, _id)
{
    StrongholdScreenModuleTemplate.call(this, _parent, _id);
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

    // Top row: Base image, base name and change, upgrading?
    this.mDescriptionRow = this.mContentContainer.appendRow(null, "gold-line-bottom description-row")


    this.mBaseSpriteContainer = $('<div class="base-sprite-container"/>');
    this.mDescriptionRow.append(this.mBaseSpriteContainer);
    this.mBaseSpriteImage = $('<img class="base-sprite-image"/>');
    this.mBaseSpriteContainer.append(this.mBaseSpriteImage);

    this.mOtherDescriptionContainer = $('<div class="other-description-container"/>');
    this.mDescriptionRow.append(this.mOtherDescriptionContainer);
    this.mChangeNameContainer = this.mOtherDescriptionContainer.appendRow(null, "gold-line-bottom change-name-row")
    var inputLayout = $('<div class="change-base-name-input-container"/>');
    this.mChangeNameInput = inputLayout.createInput("", 0, 200, 1, null, 'title-font-big font-bold font-color-brother-name', function (_input)
	{
		self.mChangeNameButton.click()
	});

	var buttonLayout = $('<div class="change-base-name-button-container"/>');
    this.mChangeNameButton = buttonLayout.createTextButton("Change Name", function(){
    	self.changeBaseName();
    }, '', 1)
    this.mChangeNameContainer.append(inputLayout)
    this.mChangeNameContainer.append(buttonLayout)

    // Bottom row: Assets
    	// Stash items / Stash max
    	// Roster bros / roster max
    	// Locations
    	// Buildings

};

StrongholdScreenMainDialogModule.prototype.loadFromData = function()
{
	this.mChangeNameInput.setInputText(this.mData.TownAssets.Name);
	var baseSprite = this.mData.TownAssets.SpriteName;
	var currentSprite = StrongholdConst.Sprites[baseSprite].MainSprites[this.mData.TownAssets.Size];
	console.error(currentSprite)

    this.mBaseSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentSprite + ".png");
}

StrongholdScreenMainDialogModule.prototype.changeBaseName = function ()
{
	SQ.call(this.mSQHandle, 'changeBaseName', this.mChangeNameInput.getInputText());
};
