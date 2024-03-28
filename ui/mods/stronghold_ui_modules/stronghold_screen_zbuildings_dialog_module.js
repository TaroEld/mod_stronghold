
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

StrongholdScreenBuildingsModule.prototype.createDIV = function (_parentDiv)
{
	StrongholdScreenStructuresModule.prototype.createDIV.call(this, _parentDiv);
	this.mActiveStructureDetailsRow.hide();
}

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
        this.addRequirementRow(this.mActiveStructureRequirementsTable,
        	Stronghold.Text.format(Stronghold.Text.General.Price, this.mActiveStructure.Price),
        	this.mData.Assets.Money > this.mActiveStructure.Price
        )
        $.each(this.mActiveStructure.Requirements, $.proxy(function(_, _requirement){
            this.addRequirementRow(this.mActiveStructureRequirementsTable, _requirement.Text, _requirement.IsValid);
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
