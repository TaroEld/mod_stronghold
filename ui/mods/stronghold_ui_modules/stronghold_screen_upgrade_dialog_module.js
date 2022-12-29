
"use strict";
var StrongholdScreenUpgradeModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mID = "UpgradeModule";
    this.mTitle = "Upgrade your base";
    this.mBaseSprite = null;
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

    var upgradeDetailsContainer = $('<div class="upgrade-details-container"/>');
    upgradeRow.append(upgradeDetailsContainer);
    this.mUpgradeNameLabel = upgradeDetailsContainer.appendRow("Advantages").find(".sub-title");
    var upgradeDetails = upgradeDetailsContainer.appendRow();
    this.mDescriptionTextContainer = $(Stronghold.Style.TextFont)
    	.addClass("upgrade-base-text-container")
    	.appendTo(upgradeDetails)

    var upgradeSpriteContainer = $('<div class="upgrade-sprite-container"/>')
    	.appendTo(upgradeRow)
    this.mBaseUpgradeSpriteImage = $('<img class="upgrade-sprite-image"/>')
    	.appendTo(upgradeSpriteContainer)

    this.mContentContainer.appendRow("Requirements", "custom-header-background");
    var requirements = this.mContainer.appendRow(null, "requirements-row");
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

    var allRequirementsDone = true;
    MSU.iterateObject(this.mModuleData.Requirements, function(_key, _requirement){
        self.addRequirementRow(_requirement);
        if (!_requirement.Done)
        	allRequirementsDone = false;
    })
    this.mUpgradeBaseButton.enableButton(allRequirementsDone)
}

StrongholdScreenUpgradeModule.prototype.addRequirementRow = function(_requirement)
{
	if(_requirement.Done)
    {
    	var container = this.mRequirementsDoneTable;
    	var tr = $("<tr/>").appendTo(container);
        tr.append("<td><img src='" + Path.GFX + "ui/icons/unlocked_small.png" + "'/></td>");
        tr.append("<td><div class='text-font-medium font-color-label'>" + _requirement.TextDone + "</div></td>");
    }
    else
    {
    	var container = this.mRequirementsNotDoneTable;
    	var tr = $("<tr/>").appendTo(container);
       	tr.append("<td><img src='" + Path.GFX + "ui/icons/locked_small.png" + "'/></td>");
        tr.append("<td><div class='text-font-medium font-color-disabled'>" + _requirement.TextNotDone + "</div></td>");
    }
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
