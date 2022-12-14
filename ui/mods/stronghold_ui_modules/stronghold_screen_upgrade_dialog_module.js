
"use strict";
var StrongholdScreenUpgradeModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mID = "UpgradeModule";
    this.mTitle = "Upgrade your base";
    this.mBaseSprite = null;
    this.UpgradeRequirements = {}
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
    this.mUpgradeAdvantagesTextContainer = $('<div class="upgrade-base-text-container text-font-normal font-style-italic font-bottom-shadow font-color-subtitle"/>');
    upgradeDetails.append(this.mUpgradeAdvantagesTextContainer);
    var upgradeSpriteContainer = $('<div class="upgrade-sprite-container"/>');
    upgradeRow.append(upgradeSpriteContainer);
    this.mBaseUpgradeSpriteImage = $('<img class="upgrade-sprite-image"/>');
    upgradeSpriteContainer.append(this.mBaseUpgradeSpriteImage);
    this.mContainer.appendRow("Requirements", "custom-header-background");
    var upgradeRequirements = this.mContainer.appendRow(null, "requirements-row");
    var requirementsDone = upgradeRequirements.appendRow("Fulfilled", "upgrade-requirements-container");
    this.mRequirementsDoneTable = $('<table/>');
    requirementsDone.append(this.mRequirementsDoneTable);

    var requirementsNotDone = upgradeRequirements.appendRow("Unfulfilled", "upgrade-requirements-container");
    this.mRequirementsNotDoneTable = $('<table/>');
    requirementsNotDone.append(this.mRequirementsNotDoneTable);


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
    var text = this.mModuleData.UpgradeAdvantages[this.mData.TownAssets.Size];
    this.mUpgradeAdvantagesTextContainer.html(text.replace("/n", "<br>"));
}

StrongholdScreenUpgradeModule.prototype.fillRequirementsText = function()
{
	this.mRequirementsDoneTable.empty();
	this.mRequirementsNotDoneTable.empty();
	var self = this;

    var allRequirementsDone = true;
    MSU.iterateObject(this.mModuleData.UpgradeRequirements, function(_key, _requirement){
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
    this.mBaseSprite = this.mData.TownAssets.SpriteName;
    this.setSpriteImage();
    this.fillUpgradeDetailsText();
    this.fillRequirementsText();
}
