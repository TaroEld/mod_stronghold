
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
    var text = this.getModuleText();

    this.mContentContainer.addClass("structures-module");
    this.mStructuresRow = this.mContentContainer.appendRow(null, "structure-row gold-line-bottom");
    this.mActiveStructureTitle = this.mContentContainer.appendRow("").find(".sub-title");




    this.mDescriptionRow = this.mContentContainer.appendRow(null, "description-row");
    this.mListContainer = this.mDescriptionRow.createList(1, null, true);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();
    this.mListScrollContainer.addClass("flex-row");

    this.mImageAndDescriptionContainer = this.mListScrollContainer.appendRow();


    var activeStructureImageContainer = $('<div class="active-structure-image-container"/>')
    	.appendTo(this.mImageAndDescriptionContainer);
    this.mActiveStructureImage = $('<img class="active-structure-image"/>')
    	.appendTo(activeStructureImageContainer);

    this.mActiveStructureDescription = Stronghold.getTextSpan().addClass("active-structure-text-container").appendTo(this.mImageAndDescriptionContainer);

    this.mActiveStructureDetailsRow = this.mListScrollContainer.appendRow("Advantages", "text-font-medium font-style-italic font-bottom-shadow font-color-subtitle").hide();
    this.mActiveStructureDetails = Stronghold.getTextDivSmall().appendTo(this.mActiveStructureDetailsRow);

    var activeStructureRequirements = this.mListScrollContainer.appendRow(Stronghold.Text.Requirements);
    this.mActiveStructureRequirementsTable = $("<table>").appendTo(activeStructureRequirements);

    this.mFooterRow = this.mContentContainer.appendRow(null, "footer-button-bar");
    this.mUpgradeStructureButton = this.mFooterRow.createTextButton(text.Upgrade, function()
    {
        self.upgradeStructure(self.mActiveStructure.ID);
    }, "display-none", 1)
    this.mAddStructureButton = this.mFooterRow.createTextButton(text.Build, function()
    {
        self.addStructure(self.mActiveStructure.ID);
    }, "display-none", 1)
    this.mRemoveStructureButton = this.mFooterRow.createTextButton(text.Remove, function()
    {
        self.removeStructure();
    }, "display-none", 1)
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
        var structureImage = $('<img class="structure-image"/>')
        	.attr('src', Path.GFX + self.mStructureImagePath + _structure.ImagePath)
        	.appendTo(structureImageContainer)
        var structureSelection = $('<img class="structure-selection display-none"/>')
        	.attr('src', Path.GFX + Stronghold.Visuals.SelectionGoldImagePath)
        	.appendTo(structureImageContainer)
        _structure.Selection = structureSelection;
        if (_structure.Level !== undefined)
        {
        	var structureLevel = $('<div class="structure-level"/>')
        		.appendTo(structureImageContainer)

        	_structure.LevelDiv = Stronghold.getTextDiv(_structure.Level).appendTo(structureLevel);
        }

        if (!_structure.HasStructure)
        {
            structureImage.addClass("is-grayscale")
        }
    })
	if (this.mActiveStructure == null)
		this.switchActiveStructure(this.mDefaultStructure)
    else this.switchActiveStructure(this.mActiveStructure.ConstID)
};

StrongholdScreenStructuresModule.prototype.switchActiveStructure = function( _structureID)
{
    var self = this
    this.mActiveStructureRequirementsTable.empty();
    if(this.mActiveStructure != null && this.mActiveStructure != undefined)
    {
        this.mActiveStructure.Selection.toggleDisplay(false)
    }
    this.mActiveStructure = this.mModuleData[_structureID];
    this.mActiveStructureTitle.html(this.mActiveStructure.Name);
    this.mActiveStructure.Selection.toggleDisplay(true)
    this.mActiveStructureImage.attr('src', Path.GFX + this.mStructureImagePath + this.mActiveStructure.ImagePath);
    this.mActiveStructureDescription.html(this.mActiveStructure.Description);
}

StrongholdScreenStructuresModule.prototype.addStructure = function ()
{
};

StrongholdScreenStructuresModule.prototype.removeStructure = function ()
{
};
