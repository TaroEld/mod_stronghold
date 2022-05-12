
"use strict";
var StrongholdScreenUpgradeDialogModule = function(_parent, _id)
{
    StrongholdScreenModuleTemplate.call(this, _parent, _id);
    this.mBaseSprite = null;
    this.mBaseSpriteIndex = null;
    this.mTitleTextContainer = null;
    this.UpgradeRequirements = {}
};

StrongholdScreenUpgradeDialogModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenUpgradeDialogModule.prototype, 'constructor', {
    value: StrongholdScreenUpgradeDialogModule,
    enumerable: false,
    writable: true });


StrongholdScreenUpgradeDialogModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    var self = this;
    this.mContentContainer.addClass("upgrade-module");

    this.mTitleTextContainer = this.mContentContainer.appendRow("Upgrade your Base").find(".sub-title");

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

    var upgradeRequirements = this.mContainer.appendRow("Requirements", "requirements-row");
    var requirementsDone = upgradeRequirements.appendRow("Fulfilled", "upgrade-requirements-container");
    this.mRequirementsDoneTextContainer = $('<div class="upgrade-requirements-text-container text-font-normal font-style-italic font-bottom-shadow font-color-positive-value"/>');
    requirementsDone.append(this.mRequirementsDoneTextContainer);

    var requirementsNotDone = upgradeRequirements.appendRow("Unfulfilled", "upgrade-requirements-container");
    this.mRequirementsNotDoneTextContainer = $('<div class="upgrade-requirements-text-container text-font-normal font-style-italic font-bottom-shadow font-color-negative-value"/>');
    requirementsNotDone.append(this.mRequirementsNotDoneTextContainer);


    var footerRow = this.mContentContainer.appendRow(null, "footer-button-bar");
    this.mUpgradeBaseButton = footerRow.createTextButton("Upgrade", function()
    {
        self.changeSprites();
    }, "upgrade-base-button", 1)
};

StrongholdScreenUpgradeDialogModule.prototype.getSpriteIndex = function()
{
    return StrongholdConst.AllSprites.indexOf(this.mBaseSprite)
}

StrongholdScreenUpgradeDialogModule.prototype.switchSpriteImage = function( _idx )
{
    var arrLen = StrongholdConst.AllSprites.length;
    var newIdx = this.getSpriteIndex() + _idx;
    if(newIdx == arrLen) newIdx = 0;
    if(newIdx < 0) newIdx = arrLen - 1
    this.mBaseSprite = StrongholdConst.AllSprites[newIdx];
    this.setSpriteImage();
}

StrongholdScreenUpgradeDialogModule.prototype.setSpriteImage = function()
{
    var currentArr = StrongholdConst.Sprites[this.mBaseSprite];
    var baseSize = this.mData.TownAssets.Size;
    this.mBaseUpgradeSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.MainSprites[baseSize] + ".png");
} 

StrongholdScreenUpgradeDialogModule.prototype.fillUpgradeDetailsText = function()
{
    var text = this.mModuleData.UpgradeAdvantages[this.mData.TownAssets.Size];
    this.mUpgradeAdvantagesTextContainer.html(text.replace("/n", "<br>"));
}

StrongholdScreenUpgradeDialogModule.prototype.fillRequirementsText = function()
{
    var TextDone = "";
    var TextNotDone = "";
    var allRequirementsDone = true;
    iterateObject(this.mModuleData.UpgradeRequirements, function(_key, _value){
        if(_value.Done === true)
        {
            TextDone += _value.TextDone + "<br>"
        }
        else
        {
            TextNotDone += _value.TextNotDone
            allRequirementsDone = false;
        }
    })
    this.mRequirementsDoneTextContainer.html(TextDone);
    this.mRequirementsNotDoneTextContainer.html(TextNotDone);
    this.mUpgradeBaseButton.enableButton(allRequirementsDone)
}

StrongholdScreenUpgradeDialogModule.prototype.loadFromData = function()
{
    this.mBaseSprite = this.mData.TownAssets.SpriteName;
    this.mBaseSpriteIndex = this.getSpriteIndex();
    this.setSpriteImage();
    this.fillUpgradeDetailsText();
    this.fillRequirementsText();
}