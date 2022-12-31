
"use strict";
var StrongholdScreenMiscModule = function(_parent)
{
	StrongholdScreenModuleTemplate.call(this, _parent);
	this.mID = "MiscModule";
	this.mTitle = "Miscellaneous";
	this.mUpdateOn.push("StashModule");
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
    this.mBuildRoadContainer 		= $(miscDiv).addClass("build-road-container").appendTo(this.mListScrollContainer);
    this.mSendGiftsContainer 		= $(miscDiv).addClass("send-gifts-container").appendTo(this.mListScrollContainer);
    this.mTrainBrotherContainer 	= $(miscDiv).addClass("train-brother-container").appendTo(this.mListScrollContainer);
    this.mBuyWaterContainer 		= $(miscDiv).addClass("buy-water-container").appendTo(this.mListScrollContainer);
    this.mHireMercenariesContainer 	= $(miscDiv).addClass("hire-mercenaries-container").appendTo(this.mListScrollContainer);
    this.mRemoveBaseContainer 		= $(miscDiv).addClass("remove-base-container").appendTo(this.mListScrollContainer);

    this.createBuildRoadContent();
    this.createSendGiftsContent();
    this.createTrainBrotherContent();
    this.createHireMercenariesContent();
    this.createBuyWaterContent();
    this.createRemoveBaseContent();
};

StrongholdScreenMiscModule.prototype.createBuildRoadContent = function ()
{
	this.mBuildRoadContentContainer = this.mBuildRoadContainer.appendRow("Build a road");

	Stronghold.getTextDiv(this.getModuleText().BuildRoad.Description)
		.appendTo(this.mBuildRoadContentContainer)

	var leftContent = $('<div class="stronghold-half-width"/>').appendTo(this.mBuildRoadContentContainer);
	var rightContent = $('<div class="stronghold-half-width"/>').appendTo(this.mBuildRoadContentContainer);

	this.mRoadTarget = leftContent.appendRow();
	this.mRoadTargetText = Stronghold.getTextDiv(this.getModuleText().BuildRoad.BuildTo)
		.appendTo(this.mRoadTarget)

	this.mRoadTargetDropdown = createDropDownMenu(this.mRoadTarget, "stronghold-padding-left");
	this.mRoadTargetDropdown.data("maxHeight", 30);

	// this.mRoadDistance = leftContent.appendRow();
	this.mRoadDistanceText = Stronghold.getTextDiv()
		.appendTo(leftContent);

	// this.mRoadPieces = leftContent.appendRow();
	this.mRoadPiecesText = Stronghold.getTextDiv()
		.appendTo(leftContent);

	this.mRoadCost = $("<div/>")
		.appendTo(leftContent)
	this.mRoadCostImg = $('<img class="road-cost"/>')
		.appendTo(this.mRoadCost)
	this.mRoadCostText = Stronghold.getTextSpan()
		.appendTo(this.mRoadCost)

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

StrongholdScreenMiscModule.prototype.loadBuildRoadData = function()
{
	this.mRoadTargetDropdown.trigger("set", [this.mModuleData.BuildRoad, this.mModuleData.BuildRoad[0], $.proxy(function(_element)
	{
		this.setRoadElement(_element);
	}, this)]);
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

StrongholdScreenMiscModule.prototype.createSendGiftsContent = function ()
{
	this.mSendGiftsContentContainer = this.mSendGiftsContainer.appendRow("Send Gifts");
	Stronghold.getTextSpan(this.getModuleText().SendGifts.Description)
		.appendTo(this.mSendGiftsContentContainer)


	var leftContent = $('<div class="stronghold-half-width"/>')
		.appendTo(this.mSendGiftsContentContainer)
	leftContent.appendRow("Gift Target");
	var rightContent = $('<div class="stronghold-half-width"/>')
		.appendTo(this.mSendGiftsContentContainer)
	var requirementsContainer = rightContent.appendRow(Stronghold.Text.Requirements);
	this.mGiftRequirementsTable = $("<table>")
		.appendTo(requirementsContainer);

	Stronghold.getTextSpanSmall(this.getModuleText().SendGifts.SendTo)
		.appendTo(leftContent)

	this.mGiftsTargetDropdown = createDropDownMenu(leftContent, "stronghold-padding-left")
		.data("maxHeight", 30);


	this.mGiftsDetailsContainer = $('<div class="gifts-details-container"/>')
		.appendTo(leftContent);
	this.mGiftsFactionImageContainer = $('<div class="gifts-image-container"/>')
		.appendTo(this.mGiftsDetailsContainer)
		.mousedown($.proxy(function(_event){
		switch (_event.which) {
	        case 1:
	            this.zoomToTargetCity(this.mGiftsTargetDropdown.data("activeElement").SettlementID);
	            break;
	        case 3:
	            this.zoomToTargetCity(this.mData.TownAssets.ID);
	            break;
	    }
	}, this));
	this.mGiftsFactionImage = $('<img/>')
		.appendTo(this.mGiftsFactionImageContainer)

	// Text details right of image
	this.mGiftsDetails = $('<div class="gifts-details"/>')
		.appendTo(this.mGiftsDetailsContainer)
	this.mGiftsCurrentRelation = Stronghold.getTextDivSmall()
		.appendTo(this.mGiftsDetails)
	this.mGiftsTargetTown = Stronghold.getTextDivSmall()
		.appendTo(this.mGiftsDetails)


	this.mGiftsButtonContainer = leftContent.appendRow(null, "stronghold-generic-element-container");
	this.mGiftsButton = this.mGiftsButtonContainer.createTextButton("Build", $.proxy(function()
	{
	    this.notifyBackendSendGift();
	}, this), "", 1)
}

StrongholdScreenMiscModule.prototype.loadSendGiftsData = function()
{
	var giftText = this.getModuleText().SendGifts;
	this.mGiftsTargetDropdown.trigger("set", [this.mModuleData.SendGifts.Factions, this.mModuleData.SendGifts.Factions[0], $.proxy(function(_element)
	{
		this.setGiftElement(_element);
	}, this)]);

	this.mGiftRequirementsTable.empty();

	// Check if player has gifts to send in stash
	var requirement = $("<div/>")
	var text = Stronghold.getTextSpan(giftText.Requirements.HaveGifts)
		.appendTo(requirement)
	$.each(this.mModuleData.SendGifts.Gifts, function(_idx, _element){
		$('<img class="misc-gift"/>')
			.appendTo(requirement)
			.attr("src", Path.ITEMS + _element.Icon)
			//.bindTooltip({ contentType: 'ui-item', itemId: _element.ID, itemOwner: 'craft' })
	})
	this.addRequirementRow(this.mGiftRequirementsTable, requirement, this.mModuleData.SendGifts.Gifts.length > 0)

	this.addRequirementRow(this.mGiftRequirementsTable,
		Stronghold.getTextSpan().text(giftText.Requirements.Faction),
		this.mModuleData.SendGifts.Factions.length > 0)

	var price = this.mModuleData.SendGifts.Price;
	this.addRequirementRow(this.mGiftRequirementsTable,
		Stronghold.getTextSpan().text(giftText.Requirements.Price.replace("{price}", price)),
		this.mData.Assets.Money > price)
	this.mGiftsButton.attr("disabled", !this.areRequirementsFulfilled(this.mGiftRequirementsTable))
}

StrongholdScreenMiscModule.prototype.setGiftElement = function(_element)
{
	var giftText = this.getModuleText().SendGifts;
	this.mGiftsFactionImage.attr("src", Path.GFX + _element.ImagePath);
	this.mGiftsCurrentRelation.text(giftText.CurrentRelation.replace("{num}", _element.RelationNum).replace("{numText}", _element.Relation))
	this.mGiftsTargetTown.text(giftText.TargetTown.replace("{town}", _element.SettlementName))
}

StrongholdScreenMiscModule.prototype.notifyBackendSendGift = function()
{
	 SQ.call(this.mSQHandle, 'onSendGift', this.mGiftsTargetDropdown.data("activeElement"));
}

StrongholdScreenMiscModule.prototype.createTrainBrotherContent = function ()
{
	this.mTrainBrotherContentContainer = this.mTrainBrotherContainer.appendRow("Train Brother");
	this.mTrainBrotherDescriptionContainer = $("<div/>");
	this.mTrainBrotherDescriptionText = Stronghold.getTextSpan()
		.appendTo(this.mTrainBrotherContentContainer)
}

StrongholdScreenMiscModule.prototype.loadTrainBrotherData = function()
{
	if (!this.mModuleData.TrainBrother.IsUnlocked)
	{
		this.mTrainBrotherDescriptionText.text(this.getModuleText().TrainBrother.Invalid)
		return;
	}
	this.mTrainBrotherDescriptionText.text(this.getModuleText().TrainBrother.Description)
}

StrongholdScreenMiscModule.prototype.createBuyWaterContent = function ()
{
	this.mBuyWaterContentContainer = this.mBuyWaterContainer.appendRow("Buy Water");
	this.mBuyWaterDescriptionContainer = $("<div/>");
	this.mBuyWaterDescriptionText = Stronghold.getTextSpan()
		.appendTo(this.mBuyWaterContentContainer)
}

StrongholdScreenMiscModule.prototype.loadBuyWaterData = function()
{
	if (!this.mModuleData.BuyWater.IsUnlocked)
	{
		this.mBuyWaterDescriptionText.text(this.getModuleText().BuyWater.Invalid)
		return;
	}
	this.mBuyWaterDescriptionText.text(this.getModuleText().BuyWater.Description)
}

StrongholdScreenMiscModule.prototype.createHireMercenariesContent = function ()
{
	this.mHireMercenariesContentContainer = this.mHireMercenariesContainer.appendRow("Hire Mercenaries");
	this.mHireMercenariesDescriptionContainer = $("<div/>");
	this.mHireMercenariesDescriptionText = Stronghold.getTextSpan()
		.appendTo(this.mHireMercenariesContentContainer)
}

StrongholdScreenMiscModule.prototype.loadHireMercenariesData = function()
{
	if (!this.mModuleData.HireMercenaries.IsUnlocked)
	{
		this.mHireMercenariesDescriptionText.text(this.getModuleText().HireMercenaries.Invalid)
		return;
	}
	this.mHireMercenariesDescriptionText.text(this.getModuleText().HireMercenaries.Description)
}

StrongholdScreenMiscModule.prototype.loadFromData = function()
{
	var self = this;
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;

	this.loadBuildRoadData();
	this.loadSendGiftsData();
	this.loadTrainBrotherData();
	this.loadBuyWaterData();
	this.loadHireMercenariesData();
	this.loadRemoveBaseData();
}

StrongholdScreenMiscModule.prototype.createRemoveBaseContent = function()
{

}

StrongholdScreenMiscModule.prototype.loadRemoveBaseData = function()
{

}

StrongholdScreenMiscModule.prototype.zoomToTargetCity = function(_townID)
{
	 SQ.call(this.mSQHandle, 'onZoomToTargetCity', _townID);
}
