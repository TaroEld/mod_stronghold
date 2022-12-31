
"use strict";
var StrongholdScreenBuildingsModule = function(_parent)
{
    StrongholdScreenStructuresModule.call(this, _parent);
    this.mID = "BuildingsModule";
	this.mTitle = "Your Buildings";
	this.mDefaultStructure = "Arena";
    this.mStructureImagePath = Stronghold.Visuals.BuildingSpritePath;
};

StrongholdScreenBuildingsModule.prototype = Object.create(StrongholdScreenStructuresModule.prototype);
Object.defineProperty(StrongholdScreenBuildingsModule.prototype, 'constructor', {
    value: StrongholdScreenBuildingsModule,
    enumerable: false,
    writable: true });

StrongholdScreenBuildingsModule.prototype.switchActiveStructure = function( _structureID)
{
    var self = this
    this.mActiveStructureRequirementsTable.empty();
    if(this.mActiveStructure != null && this.mActiveStructure != undefined)
    {
        this.mActiveStructure.Selection.toggleDisplay(false)
    }
    console.error("_structureID" + _structureID)
    this.mActiveStructure = this.mModuleData[_structureID];
    this.mActiveStructureTitle.html(this.mActiveStructure.Name);
    this.mActiveStructure.Selection.toggleDisplay(true)
    this.mActiveStructureImage.attr('src', Path.GFX + this.mStructureImagePath + this.mActiveStructure.ImagePath);
    this.mActiveStructureDescription.html(this.mActiveStructure.Description)

    if (this.mActiveStructure.HasStructure)
    {
        this.mAddStructureButton.toggleDisplay(false)
        this.mRemoveStructureButton.toggleDisplay(true)
    }
    else
    {
        this.mAddStructureButton.toggleDisplay(true)
        this.mRemoveStructureButton.toggleDisplay(false)
        $.each(this.mActiveStructure.Requirements, $.proxy(function(_, _requirement){
            this.addRequirementRow(this.mActiveStructureRequirementsTable, Stronghold.getTextDivSmall(_requirement.Text), _requirement.IsValid);
        }, this))
        this.mAddStructureButton.enableButton(this.areRequirementsFulfilled(this.mActiveStructureRequirementsTable));
    }
}

StrongholdScreenBuildingsModule.prototype.addStructure = function ()
{
	SQ.call(this.mSQHandle, 'addBuilding', [this.mActiveStructure.Path, this.mActiveStructure.Price])
};

StrongholdScreenBuildingsModule.prototype.removeStructure = function ()
{
    SQ.call(this.mSQHandle, 'removeBuilding', this.mActiveStructure.ID);
};
