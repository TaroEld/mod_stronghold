
"use strict";
var StrongholdScreenMiscModule = function(_parent)
{
	StrongholdScreenModuleTemplate.call(this, _parent);
	this.mID = "MiscModule";
	this.mTitle = "Miscellaneous";
};

StrongholdScreenMiscModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenMiscModule.prototype, 'constructor', {
    value: StrongholdScreenMiscModule,
    enumerable: false,
    writable: true });

StrongholdScreenMiscModule.prototype.createDIV = function (_parentDiv)
{
	StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
	var self = this;
	this.mContentContainer.addClass("misc-module");
	this.mListContainerLayout = $('<div class="l-list-container"/>');
    this.mContentContainer.append(this.mListContainerLayout);
    this.mListContainer = this.mListContainerLayout.createList(5, null, true);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();
    this.mBuildRoadContainer 	= $('<div class="misc-option build-road-container"/>').appendTo(this.mListScrollContainer);
    this.mSendGiftsContainer 	= $('<div class="misc-option send-gifts-container"/>').appendTo(this.mListScrollContainer);
    this.mTrainBrotherContainer = $('<div class="misc-option train-brother-container"/>').appendTo(this.mListScrollContainer);
    this.mBuyWaterContainer 	= $('<div class="misc-option buy-water-container"/>').appendTo(this.mListScrollContainer);
    this.mRemoveBaseContainer 	= $('<div class="misc-option remove-base-container"/>').appendTo(this.mListScrollContainer);
    this.createBuildRoadContent();
    this.createSendGiftsContent();
    this.createTrainBrotherContent();
    this.createBuyWaterContent();
    this.createRemoveBaseContent();
};

StrongholdScreenMiscModule.prototype.createBuildRoadContent = function ()
{
	this.mBuildRoadContentContainer = this.mBuildRoadContainer.appendRow("Build a road");
	var subtitle = this.mBuildRoadContentContainer.find(".sub-title");
	var content = this.mBuildRoadContentContainer;
	this.mRoadDropdown = createDropDownMenu(content, null, null, function(_value)
	{
		subtitle.text(_value);
	})
	this.mRoadDropdown.data("maxHeight", 50)
}

StrongholdScreenMiscModule.prototype.createSendGiftsContent = function ()
{
	this.mSendGiftsContentContainer = this.mSendGiftsContainer.appendRow("Send Gifts");
}

StrongholdScreenMiscModule.prototype.createTrainBrotherContent = function ()
{

}

StrongholdScreenMiscModule.prototype.createBuyWaterContent = function ()
{

}

StrongholdScreenMiscModule.prototype.createRemoveBaseContent = function ()
{

}

StrongholdScreenMiscModule.prototype.loadFromData = function()
{
	var roadOptions = [];
	$.each(this.mModuleData.BuildRoad, function(_idx, _element)
	{
		roadOptions.push(_element.Name)
	})
	this.mRoadDropdown.trigger("set", [roadOptions, roadOptions[0]]);
}
