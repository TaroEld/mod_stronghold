
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

	var hamletDetailsContainer = $('<div class="hamlet-details-container"/>');
	hamletRow.append(hamletDetailsContainer);
	this.mHamletNameLabel = hamletDetailsContainer.appendRow("Advantages").find(".sub-title");
	var hamletDetails = hamletDetailsContainer.appendRow();
	this.mDescriptionTextContainer = $('<div class="hamlet-details-text-container text-font-normal font-style-italic font-bottom-shadow font-color-subtitle"/>');
	hamletDetails.append(this.mDescriptionTextContainer);
	var hamletSpriteContainer = $('<div class="hamlet-sprite-container"/>');
	hamletRow.append(hamletSpriteContainer);
	this.mBaseHamletSpriteImage = $('<img class="hamlet-sprite-image"/>');
	hamletSpriteContainer.append(this.mBaseHamletSpriteImage);
	this.mContentContainer.appendRow("Requirements", "custom-header-background");
	var requirements = this.mContentContainer.appendRow(null, "requirements-row");
	var requirementsDone = requirements.appendRow("Fulfilled", "hamlet-requirements-container");
	this.mRequirementsDoneTable = $('<table/>');
	requirementsDone.append(this.mRequirementsDoneTable);

	var requirementsNotDone = requirements.appendRow("Unfulfilled", "hamlet-requirements-container");
	this.mRequirementsNotDoneTable = $('<table/>');
	requirementsNotDone.append(this.mRequirementsNotDoneTable);


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

    var allRequirementsDone = true;
    MSU.iterateObject(this.mModuleData.Requirements, function(_key, _requirement){
        self.addRequirementRow(_requirement);
        // if (!_requirement.Done)
        // 	allRequirementsDone = false;
    })
    this.mBuildHamletButton.enableButton(allRequirementsDone)
}

StrongholdScreenHamletModule.prototype.addRequirementRow = function(_requirement)
{
	var container = _requirement.Done ? this.mRequirementsDoneTable : this.mRequirementsNotDoneTable;
	var imgPath = _requirement.Done ? "ui/icons/unlocked_small.png" : "ui/icons/locked_small.png";

	var tr = $("<tr/>").appendTo(container);
    tr.append("<td><img src='" + Path.GFX + imgPath + "'/></td>");
    tr.append("<td><div class='text-font-medium font-color-label'>" + _requirement.Text + "</div></td>");
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
