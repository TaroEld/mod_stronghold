
"use strict";
var StrongholdScreenLocationsModule = function(_parent)
{
    StrongholdScreenStructuresModule.call(this, _parent);
    this.mID = "LocationsModule";
	this.mTitle = "Your Locations";
	this.mDefaultStructure = "Wheat_Fields";
    this.mStructureImagePath = Stronghold.Visuals.LocationSpritePath;
};

StrongholdScreenLocationsModule.prototype = Object.create(StrongholdScreenStructuresModule.prototype);
Object.defineProperty(StrongholdScreenLocationsModule.prototype, 'constructor', {
    value: StrongholdScreenLocationsModule,
    enumerable: false,
    writable: true });

StrongholdScreenLocationsModule.prototype.switchActiveStructure = function( _structureID)
{
    var self = this
    this.mActiveStructureRequirementsTable.empty();
    if(this.mActiveStructure != null && this.mActiveStructure != undefined)
    {
        this.mActiveStructure.Selection.toggleDisplay(false)
    }
    this.mActiveStructure = this.mModuleData[_structureID];
    this.mActiveStructureDef = Stronghold.Text.Locations[_structureID];
    this.mActiveStructureTitle.html(this.mActiveStructure.Name);
    this.mActiveStructure.Selection.toggleDisplay(true)
    this.mActiveStructureImage.attr('src', Path.GFX + this.mStructureImagePath + this.mActiveStructure.ImagePath);
    this.mActiveStructureDescription.html(this.mActiveStructureDef.getDescription ? this.mActiveStructureDef.getDescription(this.mActiveStructure) : this.mActiveStructureDef.Description);

    if (this.mActiveStructure.CurrentAmount >= this.mActiveStructure.MaxAmount)
    {
        this.mAddStructureButton.toggleDisplay(false)
        this.mRemoveStructureButton.toggleDisplay(true)
    }
    else
    {
        this.mAddStructureButton.toggleDisplay(true)
        this.mRemoveStructureButton.toggleDisplay(false)

        // Price
        this.addRequirementRow(this.mActiveStructureRequirementsTable,
        	Stronghold.getTextSpanSmall(Stronghold.Text.Price.replace("{price}", this.mActiveStructure.Price)),
        	this.mData.Assets.Money > this.mActiveStructure.Price
        )
        // Total locations in town
        this.addRequirementRow(this.mActiveStructureRequirementsTable,
        	Stronghold.getTextSpanSmall(Stronghold.Text.format(this.getModuleText().MaxTotal, this.mData.TownAssets.mLocationAsset, this.mData.TownAssets.mLocationAssetMax)),
        	this.mData.Assets.Money > this.mActiveStructure.Price
        )

        // Total of this type
        this.addRequirementRow(this.mActiveStructureRequirementsTable,
        	Stronghold.getTextSpanSmall(Stronghold.Text.format(this.getModuleText().MaxTotal, this.mActiveStructure.CurrentAmount, this.mActiveStructure.MaxAmount)),
        	this.mData.Assets.Money > this.mActiveStructure.Price
        )

        $.each(this.mActiveStructure.Requirements, $.proxy(function(_, _requirement){
            this.addRequirementRow(this.mActiveStructureRequirementsTable, Stronghold.getTextDivSmall(_requirement.Text), _requirement.IsValid);
        }, this))
        this.mAddStructureButton.enableButton(this.areRequirementsFulfilled(this.mActiveStructureRequirementsTable));
    }
}

StrongholdScreenLocationsModule.prototype.addStructure = function ()
{
   SQ.call(this.mSQHandle, 'addLocation', [this.mActiveStructure.Path, this.mActiveStructure.Price]);
};

StrongholdScreenLocationsModule.prototype.removeStructure = function ()
{
    SQ.call(this.mSQHandle, 'removeLocation', this.mActiveStructure.ID);
};
