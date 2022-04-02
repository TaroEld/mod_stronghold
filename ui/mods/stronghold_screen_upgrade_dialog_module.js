
"use strict";
var StrongholdScreenUpgradeDialogModule = function(_parent, _id)
{
    this.mParent = _parent;
    this.mSQHandle = _parent.mSQHandle
    this.mID = _id;
    // main div that can be shown or hidden
    this.mContainer = null;

    // where the actual content is inside
    this.mContentContainer = null;
    // generics
    this.mIsVisible = false;    
    this.mBaseSprite = null;
    this.mBaseSpriteIndex = null;
    this.mTitleTextContainer = null;
    this.mUpgradeRequirements = {}
    console.error("StrongholdScreenUpgradeDialogModule created")
};

StrongholdScreenUpgradeDialogModule.prototype.destroyDIV = function ()
{
    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

StrongholdScreenUpgradeDialogModule.prototype.bindTooltips = function ()
{
};

StrongholdScreenUpgradeDialogModule.prototype.unbindTooltips = function ()
{
};


StrongholdScreenUpgradeDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

StrongholdScreenUpgradeDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};

StrongholdScreenUpgradeDialogModule.prototype.register = function (_parentDiv)
{
    console.log('WorldTownScreenMainDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register StrongholdScreenUpgradeDialogModule. Reason: StrongholdScreenUpgradeDialogModule is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

StrongholdScreenUpgradeDialogModule.prototype.unregister = function ()
{
    console.log('StrongholdScreenUpgradeDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister StrongholdScreenUpgradeDialogModule. Reason: StrongholdScreenUpgradeDialogModule is not initialized.');
        return;
    }

    this.destroy();
};

StrongholdScreenUpgradeDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};

StrongholdScreenUpgradeDialogModule.prototype.show = function ()
{
    this.mIsVisible = true;
    var self = this;
    this.mContainer.removeClass('display-none').addClass('display-block');
    this.loadFromData(this.mParent.mData)
};


StrongholdScreenUpgradeDialogModule.prototype.hide = function ()
{
    this.mIsVisible = false;
    var self = this;
    this.mContainer.removeClass('display-block').addClass('display-none');
};

StrongholdScreenUpgradeDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

StrongholdScreenUpgradeDialogModule.prototype.loadFromData = function(_data)
{

}

StrongholdScreenUpgradeDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    this.mContainer = $('<div class="stronghold-module-dialog-container display-none"/>');
    _parentDiv.append(this.mContainer)

    this.mContentContainer = $('<div class="stronghold-module-content-container upgrade-module"/>');
    this.mContainer.append(this.mContentContainer)
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
    var baseSize = this.mParent.mData.Size;
    this.mBaseUpgradeSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentArr.MainSprites[baseSize] + ".png");
} 

StrongholdScreenUpgradeDialogModule.prototype.fillUpgradeDetailsText = function( _data )
{
    var text = _data.UnlockAdvantages[_data.Size];
    this.mUpgradeAdvantagesTextContainer.html(text.replace("/n", "<br>"));
}

StrongholdScreenUpgradeDialogModule.prototype.fillRequirementsText = function( _data )
{
    var TextDone = "";
    var TextNotDone = "";
    var allRequirementsDone = true;
    iterateObject(_data.mUpgradeRequirements, function(_key, _value){
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
    this.mData = this.mParent.getData()
    this.mBaseSprite = data.SpriteName;
    this.mBaseSpriteIndex = this.getSpriteIndex();
    this.setSpriteImage()
    this.fillUpgradeDetailsText(data)
    this.fillRequirementsText(data);
}