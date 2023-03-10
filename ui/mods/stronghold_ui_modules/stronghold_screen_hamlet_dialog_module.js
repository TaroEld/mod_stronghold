
"use strict";
var StrongholdScreenHamletModule = function(_parent)
{
	StrongholdScreenModuleTemplate.call(this, _parent);
	this.mID = "HamletModule";
	this.mTitle = this.getModuleText().Title;
    this.mBaseSprite = null;
    this.mBuildHamletButton = null;
};

StrongholdScreenHamletModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenHamletModule.prototype, 'constructor', {
    value: StrongholdScreenHamletModule,
    enumerable: false,
    writable: true });

StrongholdScreenHamletModule.prototype.createDIV = function (_parentDiv)
{
	StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
	var self = this;
	this.mContentContainer.addClass("hamlet-module");
	var hamletRow = this.mContentContainer.appendRow(null, "build-hamlet-row");

	var hamletDetailsContainer = $('<div class="hamlet-details-container"/>')
		.appendTo(hamletRow)
	var hamletDetails = hamletDetailsContainer.appendRow("Advantages");
	this.mDescriptionTextContainer = Stronghold.getTextDiv()
		.addClass("hamlet-details-text-container")
		.appendTo(hamletDetails)

	var hamletSpriteContainer = $('<div class="hamlet-sprite-container"/>')
		.appendTo(hamletRow)
	this.mBaseHamletSpriteImage = $('<img class="hamlet-sprite-image"/>')
	 	.appendTo(hamletSpriteContainer)

	var requirements = this.mContentContainer.appendRow(Stronghold.Text.Requirements, "requirements-row");
	this.mRequirementsTable = $('<table/>')
		.appendTo(requirements)


	var footerRow = this.mContentContainer.appendRow(null, "footer-button-bar");
	this.mBuildHamletButton = footerRow.createTextButton("Build", function()
	{
	    self.notifyBackendBuildHamlet();
	}, "build-hamlet-button", 1)
};

StrongholdScreenHamletModule.prototype.setSpriteImage = function()
{
    var currentArr = Stronghold.Visuals.Sprites[this.mBaseSprite];
    this.mBaseHamletSpriteImage.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentArr.HamletSprite + ".png");
}

StrongholdScreenHamletModule.prototype.fillHamletDetailsText = function()
{
    this.mDescriptionTextContainer.html(this.getModuleText().Description);
}

StrongholdScreenHamletModule.prototype.fillRequirementsText = function()
{
	var moduleText = this.getModuleText();
	var self = this;

	this.mRequirementsTable.empty();
	this.addRequirementRow(this.mRequirementsTable, Stronghold.getTextSpanSmall(Stronghold.Text.Price.replace("{price}", this.mModuleData.Price)), this.mData.Assets.Money > this.mModuleData.Price);
	this.addRequirementRow(this.mRequirementsTable, Stronghold.getTextSpanSmall(moduleText.Requirements.BaseSize), this.mData.TownAssets.Size == 3);
	this.addRequirementRow(this.mRequirementsTable, Stronghold.getTextSpanSmall(moduleText.Requirements.MaxHamlet), this.mData.TownAssets.HasHamlet == false);

    this.mBuildHamletButton.enableButton(this.areRequirementsFulfilled(this.mRequirementsTable))
}

StrongholdScreenHamletModule.prototype.loadFromData = function()
{
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;
    this.mBaseSprite = this.mData.TownAssets.SpriteName;
    this.setSpriteImage();
    this.fillHamletDetailsText();
    this.fillRequirementsText();
}

StrongholdScreenHamletModule.prototype.notifyBackendBuildHamlet = function()
{
	 SQ.call(this.mSQHandle, 'spawnHamlet');
}
