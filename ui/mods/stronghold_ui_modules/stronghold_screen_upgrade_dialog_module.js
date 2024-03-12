
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
    this.mDescriptionTextContainer = Stronghold.getTextDiv(this.getModuleText().Description)
    	.addClass("stronghold-flex-center")
    	.appendTo(this.mContentContainer)

    var upgradeRow = this.mContentContainer.appendRow(null, "upgrade-base-row");

    var upgradeDetailsContainer = $('<div class="upgrade-details-container"/>')
    	.appendTo(upgradeRow)

    var upgradeDetails = upgradeDetailsContainer.appendRow(Stronghold.Text.Advantages, null, true)
    this.mAdvantagesTextContainer = Stronghold.getTextDiv()
    	.addClass("upgrade-base-text-container")
    	.appendTo(upgradeDetails)

    var upgradeSpriteContainer = $('<div class="upgrade-sprite-container"/>')
    	.appendTo(upgradeRow)
    this.mBaseUpgradeSpriteImage = $('<img class="upgrade-sprite-image"/>')
    	.appendTo(upgradeSpriteContainer)

    var requirements = this.mContentContainer.appendRow(Stronghold.Text.Requirements, "", true);
    this.mRequirementsTable = $('<table/>')
    	.appendTo(requirements)

    var footerRow = this.mContentContainer.appendRow(null, "footer-button-bar");
    this.mUpgradeBaseButton = footerRow.createTextButton(this.getModuleText().Name, function()
    {
        self.notifyBackendUpgradeBase();
    }, "upgrade-base-button", 1)
};

StrongholdScreenUpgradeModule.prototype.setSpriteImage = function()
{
    var currentArr = Stronghold.Visuals.VisualsMap[this.mBaseSprite];
    var baseSize = this.mData.TownAssets.Size;
    this.mBaseUpgradeSpriteImage.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentArr.MainSprites[baseSize] + ".png");
} 

StrongholdScreenUpgradeModule.prototype.fillUpgradeDetailsText = function()
{
    this.mAdvantagesTextContainer.html(this.getModuleText().UnlockDescriptions[this.mData.TownAssets.Size + 1]);
}

StrongholdScreenUpgradeModule.prototype.fillRequirementsText = function()
{
	this.mRequirementsTable.empty();
	var self = this;
	var reqs = this.mModuleData.Requirements;
	var text = this.getModuleText().Requirements;
	if (this.mModuleData.MaxSize)
	{
		this.addRequirementRow(this.mRequirementsTable, Stronghold.getTextDivSmall(text.MaxSize), true);
		this.mUpgradeBaseButton.enableButton(false);
		return;
	}

    this.addRequirementRow(this.mRequirementsTable, Stronghold.getTextDivSmall(text.NotUpgrading), reqs.NotUpgrading);
    this.addRequirementRow(this.mRequirementsTable, Stronghold.getTextDivSmall(Stronghold.Text.format(text.Price, this.mModuleData.Price)), reqs.Price);
    this.addRequirementRow(this.mRequirementsTable, Stronghold.getTextDivSmall(text.Warehouse), reqs.Warehouse);
    this.addRequirementRow(this.mRequirementsTable, Stronghold.getTextDivSmall(text.NoContract), reqs.NoContract);

    this.mUpgradeBaseButton.enableButton(this.areRequirementsFulfilled(this.mRequirementsTable))
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

StrongholdScreenUpgradeModule.prototype.notifyBackendUpgradeBase = function()
{
	SQ.call(this.mSQHandle, 'onUpgradeBase');
}
