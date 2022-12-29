
"use strict";
var StrongholdScreenStructuresModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mActiveStructure = null;
    this.mStructureImagePath = "";
};

StrongholdScreenStructuresModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenStructuresModule.prototype, 'constructor', {
    value: StrongholdScreenStructuresModule,
    enumerable: false,
    writable: true });

StrongholdScreenStructuresModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    var self = this;

    this.mContentContainer.addClass("structures-module");
    this.mStructuresRow = this.mContentContainer.appendRow(null, "structure-row gold-line-bottom");

    this.mActiveStructureTitle = this.mContentContainer.appendRow("").find(".sub-title");
    this.mDescriptionRow = this.mContentContainer.appendRow(null, "description-row");
    var activeStructureImageContainer = $('<div class="active-structure-image-container"/>');
    this.mDescriptionRow.append(activeStructureImageContainer)
    this.mActiveStructureImage = $('<img class="active-structure-image"/>')
    activeStructureImageContainer.append(this.mActiveStructureImage);
    this.mActiveStructureTextContainer = $('<div class="active-structure-text-container"/>');
    this.mDescriptionRow.append(this.mActiveStructureTextContainer)
    this.mActiveStructureDescription = this.mActiveStructureTextContainer.appendRow(null, "text-font-normal font-style-italic font-bottom-shadow font-color-subtitle")

    var activeStructureRequirements = this.mActiveStructureTextContainer.appendRow();
    this.mActiveStructureRequirementsTable = $("<table>").appendTo(activeStructureRequirements);

    this.mFooterRow = this.mContentContainer.appendRow(null, "footer-button-bar");
    this.mAddStructureButton = this.mFooterRow.createTextButton("Build", function()
    {
        self.addStructure(self.mActiveStructure.ID);
    }, "add-structure-button display-none", 1)
    this.mRemoveStructureButton = this.mFooterRow.createTextButton("Remove", function()
    {
        self.removeStructure();
    }, "remove-structure-button display-none", 1)
};

StrongholdScreenStructuresModule.prototype.loadFromData = function()
{
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;
    this.createStructureContent();
}

StrongholdScreenStructuresModule.prototype.createStructureContent = function ()
{
    var self = this;
    this.mStructuresRow.empty();
    MSU.iterateObject(this.mModuleData, function(_structureID, _structure){
        var structureImageContainer = $('<div class="structure-image-container"/>');
        self.mStructuresRow.append(structureImageContainer);
        structureImageContainer.click(function(){
            self.switchActiveStructure(_structureID)
        })
        var structureImage = $('<img class="structure-image"/>');
        structureImage.attr('src', Path.GFX + self.mStructureImagePath + _structure.ImagePath);
        structureImageContainer.append(structureImage)
        var structureSelection = $('<img class="structure-selection display-none"/>');
        structureSelection.attr('src', Path.GFX + Stronghold.Visuals.SelectionGoldImagePath);
        structureImageContainer.append(structureSelection)
        _structure.Selection = structureSelection;

        if (!_structure.HasStructure)
        {
            structureImage.addClass("is-grayscale")
        }
    })
	if (this.mActiveStructure == null)
		this.switchActiveStructure(this.mDefaultStructure)
    else this.switchActiveStructure(this.mActiveStructure.ConstID)
};

StrongholdScreenStructuresModule.prototype.addRequirementRow = function(_requirement)
{
	var container = this.mActiveStructureRequirementsTable;
	if(_requirement.IsValid)
    {
    	var tr = $("<tr/>").appendTo(container);
        tr.append($("<td><img src='" + Path.GFX + "ui/icons/unlocked_small.png" + "'/></td>"));
        tr.append($("<td><div class='text-font-medium font-color-label'>" + _requirement.Text + "</div></td>"));
    }
    else
    {

    	var tr = $("<tr/>").appendTo(container);
       	tr.append($("<td><img src='" + Path.GFX + "ui/icons/locked_small.png" + "'/></td>"));
        tr.append($("<td><div class='text-font-medium font-color-disabled'>" + _requirement.Text + "</div></td>"));
    }
}

StrongholdScreenStructuresModule.prototype.addStructure = function ()
{
};

StrongholdScreenStructuresModule.prototype.removeStructure = function ()
{
};
