
"use strict";
var StrongholdScreenUpgradeModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mID = "UpgradeModule";
    this.mTitle = "Upgrade your base";
    this.mBaseSprite = null;
    this.mAlwaysUpdate = true;
};

StrongholdScreenUpgradeModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenUpgradeModule.prototype, 'constructor', {
    value: StrongholdScreenUpgradeModule,
    enumerable: false,
    writable: true });


StrongholdScreenUpgradeModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    var self = this;
    this.mContentContainer.addClass("upgrade-module");
    var upgradeRow = this.mContentContainer.appendRow(null, "upgrade-base-row");

    var upgradeDetailsContainer = $('<div class="upgrade-details-container"/>')
    	.appendTo(upgradeRow)

    var upgradeDetails = upgradeDetailsContainer.appendRow("Advantages")
    this.mDescriptionTextContainer = Stronghold.getTextDiv()
    	.addClass("upgrade-base-text-container")
    	.appendTo(upgradeDetails)

    var upgradeSpriteContainer = $('<div class="upgrade-sprite-container"/>')
    	.appendTo(upgradeRow)
    this.mBaseUpgradeSpriteImage = $('<img class="upgrade-sprite-image"/>')
    	.appendTo(upgradeSpriteContainer)

    var requirements = this.mContentContainer.appendRow(Stronghold.Text.Requirements, "requirements-row");
    var requirementsDone = requirements.appendRow("Fulfilled", "stronghold-half-width");
    this.mRequirementsDoneTable = $('<table/>')
    	.appendTo(requirementsDone)

    var requirementsNotDone = requirements.appendRow("Unfulfilled", "stronghold-half-width");
    this.mRequirementsNotDoneTable = $('<table/>')
    	.appendTo(requirementsNotDone)

    var footerRow = this.mContentContainer.appendRow(null, "footer-button-bar");
    this.mUpgradeBaseButton = footerRow.createTextButton("Upgrade", function()
    {
        self.changeSprites();
    }, "upgrade-base-button", 1)
};

StrongholdScreenUpgradeModule.prototype.setSpriteImage = function()
{
    var currentArr = Stronghold.Visuals.Sprites[this.mBaseSprite];
    var baseSize = this.mData.TownAssets.Size;
    this.mBaseUpgradeSpriteImage.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentArr.MainSprites[baseSize] + ".png");
} 

StrongholdScreenUpgradeModule.prototype.fillUpgradeDetailsText = function()
{
    var text = this.mModuleData.Description[this.mData.TownAssets.Size];
    this.mDescriptionTextContainer.html(text.replace("/n", "<br>"));
}

StrongholdScreenUpgradeModule.prototype.fillRequirementsText = function()
{
	this.mRequirementsDoneTable.empty();
	this.mRequirementsNotDoneTable.empty();
	var self = this;

    MSU.iterateObject(this.mModuleData.Requirements, $.proxy(function(_key, _requirement){
    	var table = _requirement.Done ? this.mRequirementsDoneTable : this.mRequirementsNotDoneTable;
    	var text = _requirement.Done ? _requirement.TextDone :  _requirement.TextNotDone;
        this.addRequirementRow(table, Stronghold.getTextDivSmall(text), _requirement.Done);
    }, this))
    this.mUpgradeBaseButton.enableButton(this.areRequirementsFulfilled(this.mRequirementsDoneTable) && this.areRequirementsFulfilled(this.mRequirementsNotDoneTable))
}

StrongholdScreenUpgradeModule.prototype.loadFromData = function()
{
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;
    this.mBaseSprite = this.mData.TownAssets.SpriteName;
    this.setSpriteImage();
    this.fillUpgradeDetailsText();
    this.fillRequirementsText();
}
