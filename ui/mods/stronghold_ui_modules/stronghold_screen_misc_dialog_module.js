
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

	this.mListContainerLayout = $('<div class="l-list-container"/>')
   		.appendTo(this.mContentContainer);
    this.mListContainer = this.mListContainerLayout.createList(5, null, true);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();

	var miscDiv = '<div class="misc-option"/>';
    this.mBuildRoadContainer 	= $(miscDiv).addClass("build-road-container").appendTo(this.mListScrollContainer);
    this.mSendGiftsContainer 	= $(miscDiv).addClass("send-gifts-container").appendTo(this.mListScrollContainer);
    this.mTrainBrotherContainer = $(miscDiv).addClass("train-brother-container").appendTo(this.mListScrollContainer);
    this.mBuyWaterContainer 	= $(miscDiv).addClass("buy-water-container").appendTo(this.mListScrollContainer);
    this.mRemoveBaseContainer 	= $(miscDiv).addClass("remove-base-container").appendTo(this.mListScrollContainer);

    this.createBuildRoadContent();
    this.createSendGiftsContent();
    this.createTrainBrotherContent();
    this.createBuyWaterContent();
    this.createRemoveBaseContent();
};

StrongholdScreenMiscModule.prototype.createBuildRoadContent = function ()
{
	this.mBuildRoadContentContainer = this.mBuildRoadContainer.appendRow("Build a road");

	$(Stronghold.Style.TextFont)
		.appendTo(this.mBuildRoadContentContainer)
		.text("Building a road to the road network allows your caravans to travel and your patrols to roam. You will also be able to send gifts to connected factions.");

	var leftContent = $('<div class="stronghold-half-width"/>').appendTo(this.mBuildRoadContentContainer);
	var rightContent = $('<div class="stronghold-half-width"/>').appendTo(this.mBuildRoadContentContainer);

	this.mRoadTarget = leftContent.appendRow();
	this.mRoadTargetText = $(Stronghold.Style.TextFont)
		.appendTo(this.mRoadTarget)
		.text("Build a road to:");

	this.mRoadTargetDropdown = createDropDownMenu(this.mRoadTarget, "stronghold-padding-left");
	this.mRoadTargetDropdown.data("maxHeight", 30);

	this.mRoadDistance = leftContent.appendRow();
	this.mRoadDistanceText = $(Stronghold.Style.TextFont)
		.appendTo(this.mRoadDistance);

	this.mRoadPieces = leftContent.appendRow();
	this.mRoadPiecesText = $(Stronghold.Style.TextFont)
		.appendTo(this.mRoadPieces);

	this.mRoadCost = leftContent.appendRow(null, "road-cost");
	this.mRoadCostImg = $('<img/>').appendTo(this.mRoadCost);
	this.mRoadCostText = $(Stronghold.Style.TextFont).appendTo(this.mRoadCost);

	this.mRoadButtonContainer = leftContent.appendRow(null, "stronghold-generic-element-container");
	this.mRoadButton = this.mRoadButtonContainer.createTextButton("Build", $.proxy(function()
	{
	    this.notifyBackendBuildRoad();
	}, this), "", 1)

	this.RoadTownImg = $('<img class="road-town-img"/>').appendTo(rightContent);
	this.RoadTownImg.mousedown($.proxy(function(_event){
		switch (_event.which) {
	        case 1:
	            this.zoomToTargetCity(this.mRoadTargetDropdown.data("activeElement").ID);
	            break;
	        case 3:
	            this.zoomToTargetCity(this.mData.TownAssets.ID);
	            break;
	    }
	}, this));
}

StrongholdScreenMiscModule.prototype.setRoadElement = function(_element)
{
	this.mRoadDistanceText.text("Distance (by air): " + _element.Score);
	this.mRoadPiecesText.text("Segments: " + _element.Segments)
	this.mRoadCostText.text("Price: " + _element.Cost);
	this.mRoadCostImg.attr("src", Path.GFX + (_element.IsValid ? "ui/icons/unlocked_small.png" : "ui/icons/locked_small.png"))
	this.mRoadButton.attr("disabled", !_element.IsValid)
	this.RoadTownImg.attr("src", Path.GFX + _element.UISprite)
}

StrongholdScreenMiscModule.prototype.notifyBackendBuildRoad = function()
{
	 SQ.call(this.mSQHandle, 'onBuildRoad', this.mRoadTargetDropdown.data("activeElement"));
}

StrongholdScreenMiscModule.prototype.createSendGiftsContent = function ()
{
	this.mSendGiftsContentContainer = this.mSendGiftsContainer.appendRow("Send Gifts");
	$(Stronghold.Style.TextFont)
		.appendTo(this.mSendGiftsContentContainer)
		.text("You can choose to send gifts to a faction. This will consume the treasures you have in your warehouse, and will increase relations with that faction depending on the value of the gifts. The caravan will demand 5000 crowns to transport the goods.");

	var leftContent = $('<div class="stronghold-half-width"/>')
		.appendTo(this.mSendGiftsContentContainer)
	leftContent.appendRow("Gift Target");
	var rightContent = $('<div class="stronghold-half-width"/>')
		.appendTo(this.mSendGiftsContentContainer)
	rightContent.appendRow("Requirements")

	this.mGiftsTarget = leftContent.appendRow();
	$(Stronghold.Style.TextFont)
		.appendTo(this.mGiftsTarget)
		.text("Send Gifts to:")
	this.mGiftsTargetDropdown = createDropDownMenu(this.mGiftsTarget, "stronghold-padding-left")
	this.mGiftsTargetDropdown.data("maxHeight", 30);
	this.mGiftsDetailsContainer = $('<div class="gifts-details-container"/>')
		.appendTo(leftContent);
	this.mGiftsFactionImageContainer = $('<div class="gifts-image-container"/>')
		.appendTo(this.mGiftsDetailsContainer);
	this.mGiftsFactionImage = $('<img/>')
		.appendTo(this.mGiftsFactionImageContainer);
	// ui\banners\factions
}

StrongholdScreenMiscModule.prototype.setGiftElement = function(_element)
{
	this.mGiftsFactionImage.attr("src", Path.GFX + _element.ImagePath)
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

StrongholdScreenMiscModule.prototype.zoomToTargetCity = function(_townID)
{
	 SQ.call(this.mSQHandle, 'onZoomToTargetCity', _townID);
}

StrongholdScreenMiscModule.prototype.loadFromData = function()
{
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;

	// Roads
	var self = this;
	var roadOptions = [];
	this.mRoadTarget = null;
	this.mRoadTargetDropdown.trigger("set", [this.mModuleData.BuildRoad, this.mModuleData.BuildRoad[0], function(_element)
	{
		self.setRoadElement(_element);
	}]);

	// Gift
	var self = this;
	var giftOptions = [];
	this.mGiftTarget = null;
	console.error(JSON.stringify(this.mModuleData.Gifts))
	this.mGiftsTargetDropdown.trigger("set", [this.mModuleData.Gifts.Factions, this.mModuleData.Gifts.Factions[0], function(_element)
	{
		self.setGiftElement(_element);
	}]);
}


