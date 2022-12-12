
"use strict";
var StrongholdScreenLocationsModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mID = "LocationsModule"
	this.mTitle = "Your Locations"
    this.mActiveLocation = null;
};

StrongholdScreenLocationsModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenLocationsModule.prototype, 'constructor', {
    value: StrongholdScreenLocationsModule,
    enumerable: false,
    writable: true });

StrongholdScreenLocationsModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    var self = this;

    this.mContentContainer.addClass("locations-module");
    this.mTitle = this.mContentContainer.appendRow("Locations");
    this.mLocationsRow = this.mContentContainer.appendRow(null, "locations-row gold-line-bottom");

    this.mActiveLocationTitle = this.mContentContainer.appendRow("").find(".sub-title");
    this.mDescriptionRow = this.mContentContainer.appendRow(null, "description-row");
    var activeLocationImageContainer = $('<div class="active-location-image-container"/>');
    this.mDescriptionRow.append(activeLocationImageContainer)
    this.mActiveLocationImage = $('<img class="active-location-image"/>') 
    activeLocationImageContainer.append(this.mActiveLocationImage);
    this.mActiveLocationTextContainer = $('<div class="active-location-text-container"/>');
    this.mDescriptionRow.append(this.mActiveLocationTextContainer)
    this.mActiveLocationDescription = this.mActiveLocationTextContainer.appendRow(null, "text-font-normal font-style-italic font-bottom-shadow font-color-subtitle")
    this.mActiveLocationRequirements = this.mActiveLocationTextContainer.appendRow(null, "text-font-normal font-style-italic font-bottom-shadow font-color-subtitle")

    this.mFooterRow = this.mContentContainer.appendRow(null, "footer-button-bar");
    this.mAddLocationButton = this.mFooterRow.createTextButton("Build", function()
    {
        self.addLocation(self.mActiveLocation.ID);
    }, "add-location-button display-none", 1)
    this.mRemoveLocationButton = this.mFooterRow.createTextButton("Remove", function()
    {
        self.removeLocation();
    }, "remove-location-button display-none", 1)
};

StrongholdScreenLocationsModule.prototype.loadFromData = function()
{
    console.error("StrongholdScreenLocationsModule loading data")
    this.createLocationContent();
}

StrongholdScreenLocationsModule.prototype.createLocationContent = function ()
{
    var self = this;
    this.mLocationsRow.empty();
    MSU.iterateObject(this.mModuleData, function(_locationID, _location){
        var locationImageContainer = $('<div class="structure-image-container"/>');
        self.mLocationsRow.append(locationImageContainer);
        locationImageContainer.click(function(){
            self.switchActiveLocation(_locationID)
        })
        var locationImage = $('<img class="structure-image"/>');
        locationImage.attr('src', Path.GFX + StrongholdConst.LocationsSpritePath + _location.ImagePath);
        locationImageContainer.append(locationImage)
        var locationSelection = $('<img class="structure-selection display-none"/>');
        locationSelection.attr('src', Path.GFX + StrongholdConst.SelectionGoldImagePath);
        locationImageContainer.append(locationSelection)
        _location.Selection = locationSelection;

        if (_location.CurrentAmount == 0)
        {
            locationImage.addClass("is-grayscale")
        }
        // var removeImage = $('<div class="remove-image"/>');
        // locationImage.append(removeImage);
    })
    if(this.mActiveLocation == null) this.switchActiveLocation("Wheat_Fields")
    else this.switchActiveLocation(this.mActiveLocation.ConstID)
};

StrongholdScreenLocationsModule.prototype.switchActiveLocation = function( _locationID)
{
    var self = this
    if(this.mActiveLocation != null && this.mActiveLocation != undefined)
    {
        this.mActiveLocation.Selection.toggleDisplay(false)
    }
    this.mActiveLocation = this.mModuleData[_locationID];
    this.mActiveLocationTitle.html(this.mActiveLocation.Name);
    this.mActiveLocation.Selection.toggleDisplay(true)
    this.mActiveLocationImage.attr('src', Path.GFX + StrongholdConst.LocationsSpritePath + this.mActiveLocation.ImagePath);
    this.mActiveLocationDescription.html(this.mActiveLocation.Description)
    if (this.mActiveLocation.Description.length > 240)
    {
        this.mActiveLocationDescription.removeClass("text-font-normal").addClass("text-font-small")
    }
    else
    {
        this.mActiveLocationDescription.removeClass("text-font-small").addClass("text-font-normal")
    }

    if(this.mActiveLocation.CurrentAmount >= this.mActiveLocation.MaxAmount)
    {
        this.mAddLocationButton.toggleDisplay(false)
        this.mRemoveLocationButton.toggleDisplay(true)
        this.mActiveLocationRequirements.html("")
    }
    else
    {
        this.mAddLocationButton.toggleDisplay(true)
        this.mRemoveLocationButton.toggleDisplay(false)
        var requirementsDone = true;
        var requirements = "<ul>Requirements: "
        var maxLocationsText = "Maximum amount of locations for this base level: " + this.mData.TownAssets.mLocationAsset + " / " + this.mData.TownAssets.mLocationAssetMax;
        if(this.mData.TownAssets.mLocationAssetMax <=  this.mData.TownAssets.mLocationAsset)
        {
            requirements += '<li style="color:Red;">' + maxLocationsText + '</li>'
            requirementsDone = false
        }
        else
        {
            requirements += '<li style="color:Green;">' + maxLocationsText + '</li>'
        }
        requirements += '<li style="color:Green;">Maximum amount of locations of this type: ' + this.mActiveLocation.CurrentAmount + " / " + this.mActiveLocation.MaxAmount  + '</li>';
        MSU.iterateObject(this.mActiveLocation.Requirements, function(_, _requirement){
            if(_requirement.IsValid) requirements += '<li style="color:Green;">' + _requirement.Text + '</li>'
            else
            {
                requirements += '<li style="color:Red;">' + _requirement.Text + '</li>'
                requirementsDone = false;
            }
        })
        requirements += "</ul>"
        this.mActiveLocationRequirements.html(requirements);
        this.mAddLocationButton.enableButton(requirementsDone);
    }
}

StrongholdScreenLocationsModule.prototype.addLocation = function ()
{
   SQ.call(this.mSQHandle, 'addLocation', [this.mActiveLocation.Path, this.mActiveLocation.Cost]);
};

StrongholdScreenLocationsModule.prototype.removeLocation = function ()
{
    SQ.call(this.mSQHandle, 'removeLocation', this.mActiveLocation.ID);
};
