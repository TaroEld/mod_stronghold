
"use strict";
var StrongholdScreenBuildingsDialogModule = function(_parent, _id)
{
    StrongholdScreenModuleTemplate.call(this, _parent, _id);
    this.mActiveBuilding = null;
};

StrongholdScreenBuildingsDialogModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenBuildingsDialogModule.prototype, 'constructor', {
    value: StrongholdScreenBuildingsDialogModule,
    enumerable: false,
    writable: true });

StrongholdScreenBuildingsDialogModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    var self = this;

    this.mContentContainer.addClass("buildings-module");
    this.mTitle = this.mContentContainer.appendRow("Buildings");
    this.mBuildingsRow = this.mContentContainer.appendRow(null, "buildings-row gold-line-bottom");

    this.mActiveBuildingTitle = this.mContentContainer.appendRow("").find(".sub-title");
    this.mDescriptionRow = this.mContentContainer.appendRow(null, "description-row");
    var activeBuildingImageContainer = $('<div class="active-building-image-container"/>');
    this.mDescriptionRow.append(activeBuildingImageContainer)
    this.mActiveBuildingImage = $('<img class="active-building-image"/>') 
    activeBuildingImageContainer.append(this.mActiveBuildingImage);
    this.mActiveBuildingTextContainer = $('<div class="active-building-text-container"/>');
    this.mDescriptionRow.append(this.mActiveBuildingTextContainer)
    this.mActiveBuildingDescription = this.mActiveBuildingTextContainer.appendRow(null, "text-font-normal font-style-italic font-bottom-shadow font-color-subtitle")
    this.mActiveBuildingRequirements = this.mActiveBuildingTextContainer.appendRow(null, "text-font-normal font-style-italic font-bottom-shadow font-color-subtitle")

    this.mFooterRow = this.mContentContainer.appendRow(null, "footer-button-bar");
    this.mAddBuildingButton = this.mFooterRow.createTextButton("Build", function()
    {
        self.addBuilding(self.mActiveBuilding.ID);
    }, "add-building-button display-none", 1)
    this.mRemoveBuildingButton = this.mFooterRow.createTextButton("Remove", function()
    {
        self.removeBuilding();
    }, "remove-building-button display-none", 1)
};

StrongholdScreenBuildingsDialogModule.prototype.loadFromData = function()
{
    console.error("StrongholdScreenBuildingsDialogModule loading data")
    this.createBuildingContent();
}

StrongholdScreenBuildingsDialogModule.prototype.createBuildingContent = function ()
{
    var self = this;
    this.mBuildingsRow.empty();
    iterateObject(this.mModuleData, function(_buildingID, _building){
        var buildingImageContainer = $('<div class="structure-image-container"/>');
        self.mBuildingsRow.append(buildingImageContainer);
        buildingImageContainer.click(function(){
            self.switchActiveBuilding(_buildingID)
        })
        var buildingImage = $('<img class="structure-image"/>');
        buildingImage.attr('src', Path.GFX + StrongholdConst.BuildingSpritePath + _building.ImagePath);
        buildingImageContainer.append(buildingImage)
        var buildingSelection = $('<img class="structure-selection display-none"/>');
        buildingSelection.attr('src', Path.GFX + StrongholdConst.SelectionGoldImagePath);
        buildingImageContainer.append(buildingSelection)
        _building.Selection = buildingSelection;

        if (!_building.HasBuilding)
        {
            buildingImage.addClass("is-grayscale")
        }
        // var removeImage = $('<div class="remove-image"/>');
        // buildingImage.append(removeImage);
    })
    this.switchActiveBuilding("Arena")
};

StrongholdScreenBuildingsDialogModule.prototype.switchActiveBuilding = function( _buildingID)
{
    var self = this
    if(this.mActiveBuilding != null && this.mActiveBuilding != undefined)
    {
        this.mActiveBuilding.Selection.toggleDisplay(false)
    }
    this.mActiveBuilding = this.mModuleData[_buildingID];
    this.mActiveBuildingTitle.html(this.mActiveBuilding.Name);
    this.mActiveBuilding.Selection.toggleDisplay(true)
    this.mActiveBuildingImage.attr('src', Path.GFX + StrongholdConst.BuildingSpritePath + this.mActiveBuilding.ImagePath);
    this.mActiveBuildingDescription.html(this.mActiveBuilding.Description)

    if(this.mActiveBuilding.HasBuilding)
    {
        this.mAddBuildingButton.toggleDisplay(false)
        this.mRemoveBuildingButton.toggleDisplay(true)
        this.mActiveBuildingRequirements.html("")
    }
    else
    {
        this.mAddBuildingButton.toggleDisplay(true)
        this.mRemoveBuildingButton.toggleDisplay(false)
        var requirementsDone = true;
        var requirements = "<ul>Requirements: "
        var maxBuildingsText = "Maximum amount of buildings for this base level: " + this.mData.TownAssets.mBuildingAsset + " / " + this.mData.TownAssets.mBuildingAssetMax;
        if(this.mData.TownAssets.mBuildingAssetMax <=  this.mData.TownAssets.mBuildingAsset)
        {
            requirements += '<li style="color:Red;">' + maxBuildingsText + '</li>'
            requirementsDone = false
        }
        else
        {
            requirements += '<li style="color:Green;">' + maxBuildingsText + '</li>'
        }
        iterateObject(this.mActiveBuilding.Requirements, function(_, _requirement){
            if(_requirement.IsValid) requirements += '<li style="color:Green;">' + _requirement.Text + '</li>'
            else
            {
                requirements += '<li style="color:Red;">' + _requirement.Text + '</li>'
                requirementsDone = false;
            }
        })
        requirements += "</ul>"
        this.mActiveBuildingRequirements.html(requirements);
        this.mAddBuildingButton.enableButton(requirementsDone);
    }
}

StrongholdScreenBuildingsDialogModule.prototype.addBuilding = function ()
{
	SQ.call(this.mSQHandle, 'addBuilding', [this.mActiveBuilding.Path, this.mActiveBuilding.Cost])
};

StrongholdScreenBuildingsDialogModule.prototype.removeBuilding = function ()
{
    SQ.call(this.mSQHandle, 'removeBuilding', this.mActiveBuilding.ID);
};
