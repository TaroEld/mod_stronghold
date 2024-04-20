
"use strict";
var StrongholdScreenMiscModule = function(_parent)
{
	StrongholdScreenModuleTemplate.call(this, _parent);
	this.mID = "MiscModule";
	this.mTitle = "Miscellaneous";
	this.mAlwaysUpdate = true;
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
    this.mListContainer = this.mListContainerLayout.createList(1, null, true);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();

	var miscDiv = '<div class="misc-option stronghold-generic-background"/>';
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
	var text = this.getModuleText().BuildRoad;
	this.mBuildRoadContentContainer = this.mBuildRoadContainer.appendRow(text.Title);

	Stronghold.getTextDiv(text.Description)
		.appendTo(this.mBuildRoadContentContainer);

	var leftContent = $('<div class="stronghold-half-width"/>').appendTo(this.mBuildRoadContentContainer);
	var rightContent = $('<div class="stronghold-half-width"/>').appendTo(this.mBuildRoadContentContainer);

	this.mRoadTarget = leftContent.appendRow();
	this.mRoadTargetText = Stronghold.getTextDiv(this.getModuleText().BuildRoad.BuildTo)
		.appendTo(this.mRoadTarget)

	this.mRoadTargetDropdown = createDropDownMenu(this.mRoadTarget, "stronghold-padding-left");
	this.mRoadTargetDropdown.data("maxHeight", 30);

	this.mRoadFactionText = Stronghold.getTextDiv()
		.appendTo(leftContent);
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
	this.RoadTownImg.bindTooltip({ contentType: 'msu-generic', modId: "mod_stronghold", elementId: "Screen.Module.Misc.RoadZoom"})


	var reqs = this.mBuildRoadContentContainer.appendRow();
	this.mRoadRequirementsTable = $("<table>")
		.appendTo(reqs);
	var footer = this.mBuildRoadContentContainer.appendRow(null, "stronghold-flex-center stronghold-row-background");
	this.mRoadButton = footer.createTextButton(text.Title, $.proxy(function()
	{
	    this.notifyBackendBuildRoad();
	}, this), "stronghold-button-4", 4)
}

StrongholdScreenMiscModule.prototype.loadBuildRoadData = function()
{
	this.mRoadRequirementsTable.empty();
	this.addRequirementRow(this.mRoadRequirementsTable, Stronghold.Text.format(this.getModuleText().BuildRoad.Requirements.BaseTier, Stronghold.Text.General.Tier2), this.mData.TownAssets.Size > 1);
	this.mRoadTargetDropdown.set(this.mModuleData.BuildRoad, this.mModuleData.BuildRoad[0], $.proxy(function(_element)
	{
		this.setRoadElement(_element);
	}, this));
}

StrongholdScreenMiscModule.prototype.setRoadElement = function(_element)
{
	var text = this.getModuleText().BuildRoad
	this.mRoadFactionText.html(Stronghold.Text.format(text.Faction, _element.FactionName));
	this.mRoadDistanceText.html(Stronghold.Text.format(text.Distance,  _element.Score));
	this.mRoadPiecesText.html(Stronghold.Text.format(text.Segments, _element.Segments))
	this.mRoadCostText.html(Stronghold.Text.format(Stronghold.Text.General.Price, _element.Cost));
	this.mRoadCostImg.attr("src", Path.GFX + (_element.IsValid ? "ui/icons/unlocked_small.png" : "ui/icons/locked_small.png"))
	this.mRoadButton.attr("disabled", !_element.IsValid || !this.areRequirementsFulfilled(this.mRoadRequirementsTable));
	this.RoadTownImg.attr("src", Path.GFX + _element.UISprite)
}

StrongholdScreenMiscModule.prototype.notifyBackendBuildRoad = function()
{
	var self = this;
	var data = this.mRoadTargetDropdown.get();
	SQ.call(this.mSQHandle, 'onBuildRoad', data, function(_ret){
	});
}

// Send Gifts

StrongholdScreenMiscModule.prototype.createSendGiftsContent = function ()
{
	var text = this.getModuleText().SendGifts;
	this.mSendGiftsContentContainer = this.mSendGiftsContainer.appendRow(text.Title);
	this.mSendGiftsDescription = Stronghold.getTextSpan()
		.appendTo(this.mSendGiftsContentContainer);


	var leftContent = $('<div class="stronghold-half-width"/>')
		.appendTo(this.mSendGiftsContentContainer)
	leftContent.appendRow(text.TargetTitle, null, true);
	var rightContent = $('<div class="stronghold-half-width"/>')
		.appendTo(this.mSendGiftsContentContainer)
	var requirementsContainer = rightContent.appendRow(Stronghold.Text.Requirements, null, true);
	this.mGiftRequirementsTable = $("<table>")
		.appendTo(requirementsContainer);

	Stronghold.getTextSpanSmall(text.SendTo)
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
	this.mGiftsReputationGain = Stronghold.getTextDivSmall()
		.appendTo(this.mGiftsDetails)


	var footer = this.mSendGiftsContentContainer.appendRow(null, "stronghold-flex-center stronghold-row-background");
	this.mGiftsButton = footer.createTextButton(text.Title, $.proxy(function()
	{
	    this.notifyBackendSendGift();
	}, this), "stronghold-button-4", 4)
}

StrongholdScreenMiscModule.prototype.loadSendGiftsData = function()
{
	var giftText = this.getModuleText().SendGifts;
	this.mSendGiftsDescription.html(Stronghold.Text.format(giftText.Description, this.mModuleData.SendGifts.Price));
	this.mGiftsTargetDropdown.set(this.mModuleData.SendGifts.Factions, this.mModuleData.SendGifts.Factions[0], $.proxy(function(_element)
	{
		this.setGiftElement(_element);
	}, this));
	this.updateGiftRequirements();

	this.mGiftsReputationGain.text(giftText.ReputationGain.replace("{reputation}", this.mModuleData.SendGifts.ReputationGain))
}

StrongholdScreenMiscModule.prototype.setGiftElement = function(_element)
{
	var giftText = this.getModuleText().SendGifts;
	this.mGiftsFactionImage.attr("src", Path.GFX + _element.ImagePath);
	this.mGiftsCurrentRelation.html(giftText.CurrentRelation.replace("{num}", _element.RelationNum).replace("{numText}", _element.Relation))
	this.mGiftsTargetTown.html(giftText.TargetTown.replace("{town}", _element.SettlementName));
}

StrongholdScreenMiscModule.prototype.updateGiftRequirements = function(_element)
{
	var giftText = this.getModuleText().SendGifts;
	this.mGiftRequirementsTable.empty();

	// Check if player has gifts to send in stash
	var requirement = $("<div/>")
	var text = Stronghold.getTextDivSmall(giftText.Requirements.HaveGifts)
		.appendTo(requirement)
	if (this.mModuleData.SendGifts.Gifts.length > 0)
	{
		var giftContainer = $("<div/>")
			.appendTo(requirement)
		$.each(this.mModuleData.SendGifts.Gifts, function(_idx, _element){
			$('<img class="misc-gift"/>')
				.appendTo(giftContainer)
				.attr("src", Path.ITEMS + _element.Icon)
				//.bindTooltip({ contentType: 'ui-item', itemId: _element.ID, itemOwner: 'craft' })
		})
	}
	this.addRequirementRow(this.mGiftRequirementsTable, requirement, this.mModuleData.SendGifts.Gifts.length > 0)

	this.addRequirementRow(this.mGiftRequirementsTable,
		giftText.Requirements.Faction,
		this.mModuleData.SendGifts.Factions.length > 0)

	var price = this.mModuleData.SendGifts.Price;
	this.addRequirementRow(this.mGiftRequirementsTable,
		Stronghold.Text.format(Stronghold.Text.General.Price, price),
		this.mData.Assets.Money > price)
	this.mGiftsButton.attr("disabled", !this.areRequirementsFulfilled(this.mGiftRequirementsTable))
}

StrongholdScreenMiscModule.prototype.notifyBackendSendGift = function()
{
	var self = this;
	var data = this.mGiftsTargetDropdown.get();
	data.ReputationGain = this.mModuleData.SendGifts.ReputationGain;
	SQ.call(this.mSQHandle, 'onSendGift', data, function(_ret){
		var text = _ret === true ? self.getModuleText().SendGifts.OnSend.replace("{town}", self.mGiftsTargetDropdown.data("activeElement").SettlementName) : Stronghold.Text.Error;
		self.createPopup(self.getModuleText().SendGifts.Title, null, null, 'stronghold-small-popup');
		self.mPopupDialog.addPopupDialogContent(Stronghold.getTextDiv(text))

		self.mPopupDialog.addPopupDialogOkButton(function (_dialog)
		{
		    self.reloadData();
		    self.destroyPopup();
		});
	});
}



// End Send Gifts

// Train Brother

StrongholdScreenMiscModule.prototype.createTrainBrotherContent = function ()
{
	var self = this;
	var text = this.getModuleText().TrainBrother;
	this.mTrainBrotherContentContainer = this.mTrainBrotherContainer.appendRow(text.Title);
	this.mTrainBrotherDescriptionText = Stronghold.getTextDiv(text.Description)
		.appendTo(this.mTrainBrotherContentContainer)
		.css("width", "100%")

	//Left Side
	var leftContent = $('<div class="stronghold-half-width"/>')
		.appendTo(this.mTrainBrotherContentContainer)
	leftContent.appendRow("Brother", null, true);
	var buttonRow = leftContent.appendRow();
	this.mTrainChooseBrotherButton = buttonRow.createTextButton(text.ChooseButton, function()
	{
	    self.createPopup(text.ChooseButton, null, null, 'train-brother-popup');
	    var mainContainer =  $('<div class="train-brother-popup-main"/>')
	    self.mPopupDialog.addPopupDialogContent(mainContainer); //just attach it to dom for list...
	    self.createTrainBrotherPopupContent(mainContainer)
		self.mPopupDialog.addPopupDialogCancelButton(function (_dialog)
		{
		    self.destroyPopup();
		});
		mainContainer.find(".train-brother-popup-entry").click(function(){
			self.selectBrotherToTrain($(this).data("entry"));
			self.destroyPopup();
		})
	}, "stronghold-button-4", 4)

	this.mTrainChooseAttributeButton = createDropDownMenu(buttonRow);
	this.mTrainChooseAttributeButton.data("maxHeight", 30);
	this.mTrainChooseAttributeButton.css("margin-top", "1rem");
	this.mTrainChooseAttributeButton.bindTooltip({ contentType: 'msu-generic', modId: "mod_stronghold", elementId: "Screen.Module.Misc.TrainBrotherChooseAttribute"})



	var imgContainer = $('<div class = "train-brother-img-container">')
		.appendTo(leftContent)
	this.mTrainBrotherImg = $('<img class="train-brother-img"/>')
		.appendTo(imgContainer)
	this.mTrainBrotherName = Stronghold.getTextDiv()
		.appendTo(leftContent)
		.css("text-align", "center")
	this.mTrainBrotherLevel = Stronghold.getTextDiv()
		.appendTo(leftContent)
		.css("text-align", "center")


	//Right Side
	var rightContent = $('<div class="stronghold-half-width"/>')
		.appendTo(this.mTrainBrotherContentContainer)
	var requirementsContainer = rightContent.appendRow(Stronghold.Text.Requirements, null, true);
	this.mTrainBrotherRequirementsTable = $("<table>")
		.appendTo(requirementsContainer);

	var footer = this.mTrainBrotherContentContainer.appendRow(null, "stronghold-flex-center stronghold-row-background");
	this.mTrainBrotherConfirmButton = footer.createTextButton(text.ConfirmButton, function()
		{
	    self.notifyBackendTrainBrother();
	}, "stronghold-button-4", 4) ;
}

StrongholdScreenMiscModule.prototype.createTrainBrotherPopupContent = function (_parent)
{
	var self = this;
	var scrollContainer = $('<div class=train-brother-popup-scroll/>')
		.appendTo(_parent);

	$.each(this.mModuleData.TrainBrother.ValidBrothers, function(_idx, _entry){
		var entryContainer = $('<div class="train-brother-popup-entry stronghold-generic-background"/>')
			.appendTo(scrollContainer)
		entryContainer.data("entry", _entry)
		$('<img class="st-portrait"/>')
			.appendTo(entryContainer)
			.attr("src", Path.PROCEDURAL + _entry.ImagePath)
		entryContainer.append(Stronghold.getTextDiv(_entry.Name))
		entryContainer.append(Stronghold.getTextDiv("Level: " + _entry.Level))
		// selection
		$('<img class="train-brother-popup-entry-selection display-none"/>')
			.attr('src', Path.GFX + Stronghold.Visuals.SelectionGoldImagePath)
			.appendTo(entryContainer)
	})
	_parent.aciScrollBar({
         delta: 0.1,
         lineDelay: 0,
         lineTimer: 0,
         pageDelay: 0,
         pageTimer: 0,
         bindKeyboard: false,
         resizable: false,
         smoothScroll: false
   });
}

StrongholdScreenMiscModule.prototype.selectBrotherToTrain = function(_entry)
{
	var text = this.getModuleText().TrainBrother;
	this.mTrainBrotherImg.attr("src", Path.PROCEDURAL + _entry.ImagePath);
	this.mTrainBrotherImg.show();
	this.mTrainBrotherName.text(_entry.Name);
	this.mTrainBrotherLevel.text("Level: " + _entry.Level);
	this.mTrainBrotherConfirmButton.attr("disabled", false);
	var dropdownItems = [];
	var def = null;
	$.each(_entry.Talents, function(_idx, _talent){
		var ret = {
			Name : text.AttributeNames[_idx] + ": " + _talent + "*",
			Idx : _idx,
			Disabled : _talent === 3,
			BrotherID : _entry.ID
		}
		if (def == null && ret.Disabled === false)
			def = ret;
		dropdownItems.push(ret);
	})
	this.mTrainChooseAttributeButton.set(dropdownItems, def);
	this.mTrainChooseAttributeButton.show();
}

StrongholdScreenMiscModule.prototype.loadTrainBrotherData = function()
{
	var text = this.getModuleText().TrainBrother;
	this.mTrainBrotherImg.hide();
	this.mTrainBrotherName.text("");
	this.mTrainBrotherLevel.text("");
	this.mTrainBrotherConfirmButton.attr("disabled", true);

	this.mTrainBrotherRequirementsTable.empty()
	var reqs = this.buildRequirements(this.mTrainBrotherRequirementsTable, this.mModuleData.TrainBrother.Requirements, text.Requirements);
	this.mTrainChooseBrotherButton.attr("disabled", !reqs)
	this.mTrainChooseAttributeButton.set();
	this.mTrainChooseAttributeButton.hide();
}

StrongholdScreenMiscModule.prototype.notifyBackendTrainBrother = function()
{
	var self = this;
	var text = this.getModuleText().TrainBrother;
	var data = this.mTrainChooseAttributeButton.get();
	SQ.call(this.mSQHandle, 'onTrainBrother', data, function(_ret){
		var content = Stronghold.Text.format(text.SuccessTalent, text.AttributeNames[data.Idx], _ret.Talent);
		if (_ret.ToAdd > 0)
			content += Stronghold.Text.format(text.SuccessAttribute, text.AttributeNames[data.Idx], _ret.ToAdd);
		else content += Stronghold.Text.format(text.NoChangeAttribute, text.AttributeNames[data.Idx]);
		self.createPopup(text.Title, null, null, 'stronghold-small-popup');
		self.mPopupDialog.addPopupDialogContent(Stronghold.getTextDiv(content))

		self.mPopupDialog.addPopupDialogOkButton(function (_dialog)
		{
		    self.reloadData();
		    self.destroyPopup();
		});
	});
}

// End train brother

// Buy water

StrongholdScreenMiscModule.prototype.createBuyWaterContent = function ()
{
	var text = this.getModuleText().BuyWater;
	this.mBuyWaterContentContainer = this.mBuyWaterContainer.appendRow(text.Title);
	this.mBuyWaterDescriptionText = Stronghold.getTextSpan(text.Description)
		.appendTo(this.mBuyWaterContentContainer);
	var requirementsContainer = this.mBuyWaterContentContainer.appendRow(Stronghold.Text.Requirements, null, true);
	this.mBuyWaterRequirementsTable = $("<table>")
		.appendTo(requirementsContainer);
	var footer = this.mBuyWaterContentContainer.appendRow(null, "stronghold-flex-center stronghold-row-background");
	this.mBuyWaterConfirmButton = footer.createTextButton(text.ConfirmButton, function()
	{
	    self.notifyBackendBuyWater();
	}, "stronghold-button-4", 4)
}

StrongholdScreenMiscModule.prototype.loadBuyWaterData = function()
{
	var text = this.getModuleText().BuyWater;
	this.mBuyWaterRequirementsTable.empty()
	var reqs = this.buildRequirements(this.mBuyWaterRequirementsTable, this.mModuleData.BuyWater.Requirements, text.Requirements);
	this.mBuyWaterConfirmButton.attr("disabled", !reqs);
}

StrongholdScreenMiscModule.prototype.notifyBackendBuyWater = function()
{
	SQ.call(this.mSQHandle, 'onWaterSkinBought');
}

// End Buy Water

// Hire Mercenaries

StrongholdScreenMiscModule.prototype.createHireMercenariesContent = function ()
{
	var text = this.getModuleText().HireMercenaries;
	this.mHireMercenariesContentContainer = this.mHireMercenariesContainer.appendRow(text.Title);
	this.mHireMercenariesDescriptionText = Stronghold.getTextSpan(text.Description)
		.appendTo(this.mHireMercenariesContentContainer)
	var requirementsContainer = this.mHireMercenariesContentContainer.appendRow(Stronghold.Text.Requirements, null, true);
	this.mHireMercenariesRequirementsTable = $("<table>")
		.appendTo(requirementsContainer);
	var footer = this.mHireMercenariesContentContainer.appendRow(null, "stronghold-flex-center stronghold-row-background");
	this.mHireMercenariesConfirmButton = footer.createTextButton(text.ConfirmButton, function()
	{
	    self.notifyBackendHireMercenaries();
	}, "stronghold-button-4", 4)
}

StrongholdScreenMiscModule.prototype.loadHireMercenariesData = function()
{
	var text = this.getModuleText().HireMercenaries;
	this.mHireMercenariesRequirementsTable.empty()
	var reqs = this.buildRequirements(this.mHireMercenariesRequirementsTable, this.mModuleData.HireMercenaries.Requirements, text.Requirements);
	this.mHireMercenariesConfirmButton.attr("disabled", !reqs)
}

StrongholdScreenMiscModule.prototype.notifyBackendHireMercenaries = function()
{
	SQ.call(this.mSQHandle, 'onHireMercenaries');
}

// End Hire Mercenaries


// Remove base

StrongholdScreenMiscModule.prototype.createRemoveBaseContent = function()
{
	var self = this;
	var text = this.getModuleText().RemoveBase;
	this.mRemoveBaseContentContainer = this.mRemoveBaseContainer.appendRow(text.Title);
	this.mRemoveBaseDescriptionText = Stronghold.getTextSpan()
		.appendTo(this.mRemoveBaseContentContainer)
		.text(text.Description)
	var requirementsContainer = this.mRemoveBaseContentContainer.appendRow(Stronghold.Text.Requirements, null, true);
	this.mRemoveBaseRequirementsTable = $("<table>")
		.appendTo(requirementsContainer);


	var footer = this.mRemoveBaseContentContainer.appendRow(null, "stronghold-flex-center stronghold-row-background");
	this.mRemoveBaseButton = footer.createTextButton(text.Title, function()
	{
	    self.createPopup(text.Title, null, null, 'change-name-and-title-popup');
	    self.mPopupDialog.addPopupDialogContent(Stronghold.getTextDiv(text.Warning))
		self.mPopupDialog.addPopupDialogOkButton(function (_dialog)
		{
		    self.destroyPopup();
		    self.notifyBackEndRemoveBase();
		});
		self.mPopupDialog.addPopupDialogCancelButton(function (_dialog)
		{
		    self.destroyPopup();
		});
	}, "stronghold-button-4", 4)
}

StrongholdScreenMiscModule.prototype.loadRemoveBaseData = function()
{
	var text = this.getModuleText().RemoveBase;
	this.mRemoveBaseRequirementsTable.empty()
	this.addRequirementRow(this.mRemoveBaseRequirementsTable, text.Requirements.NoContract, this.mModuleData.RemoveBase.NoContract);
	this.mRemoveBaseButton.attr("disabled", !this.areRequirementsFulfilled(this.mRemoveBaseRequirementsTable))
}

StrongholdScreenMiscModule.prototype.notifyBackEndRemoveBase = function()
{
	SQ.call(this.mSQHandle, 'onRemoveBase');
}


StrongholdScreenMiscModule.prototype.zoomToTargetCity = function(_townID)
{
	 SQ.call(this.mSQHandle, 'onZoomToTargetCity', _townID);
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
