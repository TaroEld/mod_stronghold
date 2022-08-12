
"use strict";
var StrongholdScreenRosterDialogModule = function(_parent, _id)
{
    StrongholdScreenModuleTemplate.call(this, _parent, _id);
};

StrongholdScreenRosterDialogModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenRosterDialogModule.prototype, 'constructor', {
    value: StrongholdScreenRosterDialogModule,
    enumerable: false,
    writable: true });

StrongholdScreenRosterDialogModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    var self = this;
    this.mContentContainer.addClass("roster-module");

    // this.mTitle = this.mContentContainer.addRow("Roster");

    // this.mPlayerRosterRow = this.mContentContainer.addRow(null, "player-roster-row");
    // this.mPlayerRosterListContainer = this.mPlayerRosterRow.createList(5, null, true);
    // this.mPlayerRosterListScrollContainer = this.mPlayerRosterListContainer.findListScrollContainer();

    // this.mMiddleButtonBarRow = this.mContentContainer.addRow(null, "middle-button-bar-row");

    // this.mTownRosterRow = this.mContentContainer.addRow(null, "town-roster-row");
    // this.mTownRosterListContainer = this.mTownRosterRow.createList(5, null, true);
    // this.mTownRosterListScrollContainer = this.mTownRosterListContainer.findListScrollContainer();
};

StrongholdScreenRosterDialogModule.prototype.createScrollContainerContent = function ( _container, _data)
{
    var self = this;
    _container.empty();
    iterateObject(_data, function(_, _brother){
        var brotherImageContainer = $('<div class="brother-image-container"/>');
        _container.append(brotherImageContainer);
        locationImageContainer.click(function(){
            self.switchActiveBrother(_brother)
        })
        var brotherImage = $('<img class="brother-image"/>');
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
}