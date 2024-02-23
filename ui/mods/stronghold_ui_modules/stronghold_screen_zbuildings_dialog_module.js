
"use strict";
var StrongholdScreenBuildingsModule = function(_parent)
{
    StrongholdScreenStructuresModule.call(this, _parent);
    this.mID = "BuildingsModule";
	this.mTitle = "Your Buildings";
	this.mDefaultStructure = "Arena";
    this.mStructureImagePath = Stronghold.Visuals.BuildingSpritePath;
    this.mActiveStructureDefs = Stronghold.Text.Buildings;
};

StrongholdScreenBuildingsModule.prototype = Object.create(StrongholdScreenStructuresModule.prototype);
Object.defineProperty(StrongholdScreenBuildingsModule.prototype, 'constructor', {
    value: StrongholdScreenBuildingsModule,
    enumerable: false,
    writable: true });

StrongholdScreenBuildingsModule.prototype.switchActiveStructure = function( _structureID)
{
    StrongholdScreenStructuresModule.prototype.switchActiveStructure.call(this, _structureID)

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
