
"use strict";
var StrongholdScreenHamletModule = function(_parent)
{
	StrongholdScreenModuleTemplate.call(this, _parent);
	this.mID = "HamletModule";
	this.mTitle = "Build a Hamlet";
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
	var requirementsDone = requirements.appendRow("Fulfilled", "stronghold-half-width");
	this.mRequirementsDoneTable = $('<table/>')
		.appendTo(requirementsDone)

	var requirementsNotDone = requirements.appendRow("Unfulfilled", "stronghold-half-width");
	this.mRequirementsNotDoneTable = $('<table/>')
		.appendTo(requirementsNotDone)


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
    this.mDescriptionTextContainer.html(this.mModuleData.Description.replace("/n", "<br>"));
}

StrongholdScreenHamletModule.prototype.fillRequirementsText = function()
{

	this.mRequirementsDoneTable.empty();
	this.mRequirementsNotDoneTable.empty();
	var self = this;

    MSU.iterateObject(this.mModuleData.Requirements, $.proxy(function(_key, _requirement){
    	var table = _requirement.Done ? this.mRequirementsDoneTable : this.mRequirementsNotDoneTable;
        this.addRequirementRow(table, Stronghold.getTextDivSmall(_requirement.Text), _requirement.Done);
    }, this))
    this.mBuildHamletButton.enableButton(this.areRequirementsFulfilled(this.mRequirementsDoneTable) && this.areRequirementsFulfilled(this.mRequirementsNotDoneTable))
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
