
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

StrongholdScreenLocationsModule.prototype.createDIV = function (_parentDiv)
{
	StrongholdScreenStructuresModule.prototype.createDIV.call(this, _parentDiv);
	this.mActiveStructureDetailsRow.show();
}

StrongholdScreenLocationsModule.prototype.switchActiveStructure = function( _structureID)
{
    StrongholdScreenStructuresModule.prototype.switchActiveStructure.call(this, _structureID)
    this.mActiveStructureDef = Stronghold.Text.Locations[_structureID];

    if (this.mActiveStructure.HasStructure)
    {
    	this.mActiveStructureTitle.html(this.mActiveStructure.Name + Stronghold.Text.format(this.getModuleText().Level, this.mActiveStructure.Level, 4));
    	this.mActiveStructure.LevelDiv.html(this.mActiveStructure.Level);
        this.mAddStructureButton.toggleDisplay(false);
        this.mRemoveStructureButton.toggleDisplay(!(_structureID == "Warehouse")); // true except for warehouse, cant remove that
        this.mUpgradeStructureButton.toggleDisplay(true);

        if (this.mActiveStructure.Level != 4)
        {
        	this.showUpgradeRequirements();
        }
        else
        {
        	this.showMaxLevelRequirements();
        }
    }
    else
    {
        this.mAddStructureButton.toggleDisplay(true);
        this.mRemoveStructureButton.toggleDisplay(false);
        this.mUpgradeStructureButton.toggleDisplay(false);
        this.showBuildRequirements();
    }
}

StrongholdScreenLocationsModule.prototype.showBuildRequirements = function ()
{
	var moduleText = this.getModuleText();
	// Price
	this.addRequirementRow(this.mActiveStructureRequirementsTable,
		Stronghold.Text.format(Stronghold.Text.General.Price, this.mActiveStructure.Price),
		this.mData.Assets.Money > this.mActiveStructure.Price
	)
	// Total locations in town
	this.addRequirementRow(this.mActiveStructureRequirementsTable,
		Stronghold.Text.format(this.getModuleText().MaxTotal, this.mData.TownAssets.mLocationAsset, this.mData.TownAssets.mLocationAssetMax, this.mData.TownAssets.mLocationAsset),
		this.mData.TownAssets.mLocationAsset < this.mData.TownAssets.mLocationAssetMax
	)
	$.each(this.mActiveStructure.Requirements, $.proxy(function(_, _requirement){
	    this.addRequirementRow(this.mActiveStructureRequirementsTable, _requirement.Text, _requirement.IsValid);
	}, this))

	var details = "<ul>" +  moduleText.NextDetails;
	details += this.mActiveStructureDef.getUpgradeDescription(this.mActiveStructure, 1);
	details += "</ul>";
	this.mActiveStructureDetails.html(details);

	this.mAddStructureButton.enableButton(this.areRequirementsFulfilled(this.mActiveStructureRequirementsTable));
}

StrongholdScreenLocationsModule.prototype.showUpgradeRequirements = function ()
{
	var moduleText = this.getModuleText();
	// Price
	this.addRequirementRow(this.mActiveStructureRequirementsTable,
		Stronghold.Text.format(Stronghold.Text.General.Price, this.mActiveStructure.UpgradePrice),
		this.mData.Assets.Money > this.mActiveStructure.UpgradePrice
	)
	this.addRequirementRow(this.mActiveStructureRequirementsTable,
		Stronghold.Text.format(moduleText.MaxForBaseLevel, this.mData.TownAssets.Size, this.mActiveStructure.Level),
		this.mData.TownAssets.Size > this.mActiveStructure.Level
	)


	var details = "<ul>" + moduleText.CurrentDetails;
	details += this.mActiveStructureDef.getUpgradeDescription(this.mActiveStructure, this.mActiveStructure.Level);
	details += "</ul><ul>" + moduleText.NextDetails;
	details += this.mActiveStructureDef.getUpgradeDescription(this.mActiveStructure,  this.mActiveStructure.Level + 1);
	details += "</ul>";
	this.mActiveStructureDetails.html(details);

	this.mUpgradeStructureButton.enableButton(this.areRequirementsFulfilled(this.mActiveStructureRequirementsTable));
}

StrongholdScreenLocationsModule.prototype.showMaxLevelRequirements = function ()
{
	var moduleText = this.getModuleText();
	this.addRequirementRow(this.mActiveStructureRequirementsTable, moduleText.MaxLevel, false)

	var details = "<ul>" + moduleText.CurrentDetails;
	details += this.mActiveStructureDef.getUpgradeDescription(this.mActiveStructure, this.mActiveStructure.Level);
	details += "</ul>";
	this.mActiveStructureDetails.html(details);


	this.mUpgradeStructureButton.enableButton(this.areRequirementsFulfilled(this.mActiveStructureRequirementsTable));
}


StrongholdScreenLocationsModule.prototype.addStructure = function ()
{
   SQ.call(this.mSQHandle, 'addLocation', this.mActiveStructure.ConstID);
};

StrongholdScreenLocationsModule.prototype.upgradeStructure = function ()
{
   SQ.call(this.mSQHandle, 'upgradeLocation', this.mActiveStructure.ConstID);
};

StrongholdScreenLocationsModule.prototype.removeStructure = function ()
{
    SQ.call(this.mSQHandle, 'removeLocation', this.mActiveStructure.ConstID);
};
