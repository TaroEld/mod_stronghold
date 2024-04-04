"use strict";
var StrongholdScreenMainModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mID = "MainModule";
    this.mTitle = "Overview";
    this.mAlwaysUpdate = true;
    this.mHeaderRow = null;
    this.mBaseSpriteImage = null;
    this.mLastEnterLog = {}; // filled via text
    this.mBaseSettings = {
    	// AutoConsume : null,
    	ShowBanner : true,
    	ShowEffectRadius : true
    }
};

StrongholdScreenMainModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenMainModule.prototype, 'constructor', {
    value: StrongholdScreenMainModule,
    enumerable: false,
    writable: true });

StrongholdScreenMainModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    this.mContentContainer.addClass("main-module");
    var self = this;    
    var text = this.getModuleText();

    this.mHeaderRow = this.mContentContainer.appendRow(null, "stronghold-row-background stronghold-flex-center");
    var inputContainer = $('<div/>').css({
    	"width" : "60.0rem",
    	"height" : " 4.0rem"
    }).appendTo(this.mHeaderRow);
    this.mChangeNameInput = inputContainer.createInput("", 0, 200, 1, null, 'title-font-big font-bold font-color-brother-name', function (_input)
	{
		self.changeBaseName();
	});
	this.mChangeNameInput.css("background-size", "60.0rem 4.0rem")

	var infoContainer = this.mContentContainer.appendRow();
    var baseSpriteContainer = $('<div class="stronghold-half-width stronghold-generic-background stronghold-flex-center"/>')
    	.appendTo(infoContainer);
    this.mBaseSpriteImage = $('<img class="base-sprite-image"/>')
    	.appendTo(baseSpriteContainer);

    var assetsContainer = $('<div class="stronghold-half-width stronghold-generic-background"/>')
    	.appendTo(infoContainer);
    MSU.iterateObject(text.LastEnterLog, function(_key, _value)
    {
    	var ret = $('<div class="main-module-asset-row"/>')
    		.appendTo(assetsContainer);
    	self.mLastEnterLog[_key] = Stronghold.getTextSpan()
    		.appendTo(ret);
    })
    this.createUpgradingContent();

    this.createRaidedContent();

    this.createOverflowContent();

    this.createSettingsContent();
};

StrongholdScreenMainModule.prototype.createUpgradingContent = function ()
{
	this.mUpgradingContainer = this.mContentContainer.appendRow(this.getModuleText().UpgradingTitle, 'base-situation').hide();
	this.mUpgradingImage = $("<img class='base-situation-image'/>")
		.attr('src', Path.GFX + "ui/settlement_status/settlement_effect_15.png")
		.appendTo(this.mUpgradingContainer);
	this.mUpgradingText = Stronghold.getTextDiv(this.getModuleText().UpgradingText)
		.addClass("base-situation-text")
		.appendTo(this.mUpgradingContainer);
}

StrongholdScreenMainModule.prototype.createRaidedContent = function ()
{
	var self = this;
	var text = this.getModuleText();
	this.mRaidedContainer = this.mContentContainer.appendRow(this.getModuleText().RaidedTitle, 'base-situation').hide();
	this.mRaidedImage = $("<img class='base-situation-image'/>")
		.attr('src', Path.GFX + "ui/settlement_status/settlement_effect_08.png")
		.appendTo(this.mRaidedContainer);
	this.mRaidedText = Stronghold.getTextDiv()
		.addClass("base-situation-text")
		.appendTo(this.mRaidedContainer);

	var footer = this.mRaidedContainer.appendRow(null, "stronghold-flex-center");
	this.mRaidedButton = footer.createTextButton(this.getModuleText().RaidedButton, $.proxy(function()
	{
	    this.notifyBackendPayForRaided();
	}, this), "stronghold-button-4", 4)
}

StrongholdScreenMainModule.prototype.createOverflowContent = function ()
{
	var self = this;
	var text = this.getModuleText();
	this.mOverflowContainer = this.mContentContainer.appendRow(text.OverflowTitle).hide();
	this.mOverflowText = Stronghold.getTextDiv().appendTo(this.mOverflowContainer);

	var footer = this.mOverflowContainer.appendRow(null, "stronghold-flex-center");
	this.mOverflowPopupButton = footer.createTextButton(text.PopupButton, function()
	{
	    self.createPopup(text.ChooseButton, null, null, 'overflow-items-popup');
	    var mainContainer =  $('<div class="overflow-items-popup-main"/>')
	    self.mPopupDialog.addPopupDialogContent(mainContainer);
	    self.createOverflowItemsPopupContent(mainContainer)
		self.mPopupDialog.addPopupDialogCancelButton(function (_dialog)
		{
		    self.destroyPopup();
		});
	}, "stronghold-button-4", 4)

	this.mOverflowButton = footer.createTextButton(text.OverflowButton, $.proxy(function()
	{
	    this.notifyBackendConsumeOverflow();
	}, this), "stronghold-button-4", 4)
}

StrongholdScreenMainModule.prototype.createSettingsContent = function ()
{
	var self = this;
	var text = this.getModuleText();
	this.mSettingsContainer = this.mContentContainer.appendRow("Settings");
	var settingsContainer = $('<div class="stronghold-generic-background"/>')
		.appendTo(this.mSettingsContainer);
	this.mSettingsTable = $('<table/>')
		.appendTo(settingsContainer)
	MSU.iterateObject(this.mBaseSettings, function(_key, _value)
	{
		var row = $("<tr/>").appendTo(self.mSettingsTable);
		$("<td/>").appendTo(row).append(Stronghold.getTextDiv(text.BaseSettings[_key]));
		var checkboxContainer = $("<td/>").appendTo(row);
		var checkbox = $('<input type="checkbox"/>')
			.appendTo(checkboxContainer);
		self.mBaseSettings[_key] = checkbox;
		checkbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		checkbox.iCheck("check");

		checkbox.on('ifChecked ifUnchecked', null, this, function (_event) {
			self.changeSetting(_key, checkbox.prop('checked') === true);
		});
		row.bindTooltip({ contentType: 'msu-generic', modId: "mod_stronghold", elementId: "Screen.Module.Main." + _key});
	})
}

StrongholdScreenMainModule.prototype.loadFromData = function()
{
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;
	var self = this;
	var text = this.getModuleText();

	this.mParent.updateTitle(text.Title);
	this.mChangeNameInput.setInputText(this.mData.TownAssets.Name);

	var baseSprite = this.mData.TownAssets.Spriteset;
	var currentSprite = Stronghold.Visuals.VisualsMap[baseSprite].Base[this.mData.TownAssets.Size -1];
    this.mBaseSpriteImage.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentSprite + ".png");
    MSU.iterateObject(this.mBaseSettings, function(_key, _value)
    {
    	_value.iCheck(self.mData.TownAssets.BaseSettings[_key] === true ? 'check' : 'uncheck');
    });

	this.updateLastEnterLog();

	this.updateUpgrading();

    this.updateRaided();

    this.updateOverflow();
}

StrongholdScreenMainModule.prototype.updateLastEnterLog = function()
{
	var self = this;
	var text = this.getModuleText();
	$.each(this.mLastEnterLog, function(_key, _value){
		_value.html(Stronghold.Text.format(text.LastEnterLog[_key], self.mModuleData.LastEnterLog[_key]));
	})
}

StrongholdScreenMainModule.prototype.updateUpgrading= function ()
{
	if (this.mData.TownAssets.IsUpgrading === true)
	{
		this.mUpgradingContainer.show();
	}
	else this.mUpgradingContainer.hide();
}


StrongholdScreenMainModule.prototype.updateRaided = function ()
{
	var self = this;
	var text = this.getModuleText();
	if (this.mData.TownAssets.IsRaidedUntil > 0)
	{
		var price = this.mData.TownAssets.IsRaidedUntil * this.mModuleData.RaidedCostPerDay;
		this.mRaidedText.html(Stronghold.Text.format(text.RaidedText, this.mData.TownAssets.IsRaidedUntil, price));
		this.mRaidedButton.find(".label").html(Stronghold.Text.format(text.RaidedButton, price))
		this.mRaidedButton.attr("disabled", price > this.mData.Assets.Money)
		this.mRaidedContainer.show();
	}
	else this.mRaidedContainer.hide();
}



StrongholdScreenMainModule.prototype.updateOverflow = function ()
{
	if (this.mData.TownAssets.ItemOverflow.length > 0)
	{
		this.mOverflowText.html(Stronghold.Text.format(this.getModuleText().OverflowText, this.mData.TownAssets.ItemOverflow.length));
		this.mOverflowButton.attr("disabled", false)
		this.mOverflowContainer.show();
	}
	else this.mOverflowContainer.hide();
}

StrongholdScreenMainModule.prototype.createOverflowItemsPopupContent = function (_parent)
{
	var self = this;
	var scrollContainer = $('<div class=overflow-items-popup-scroll/>')
		.appendTo(_parent);

	$.each(this.mData.TownAssets.ItemOverflow, function(_idx, _entry){
		var entryContainer = $('<div class="overflow-items-popup-entry stronghold-generic-background"/>')
			.appendTo(scrollContainer)
		entryContainer.data("entry", _entry)
		$('<img class="st-portrait"/>')
			.appendTo(entryContainer)
			.attr("src", Path.ITEMS + _entry.Icon)
		entryContainer.append(Stronghold.getTextDiv(_entry.Name));
	})
	_parent.aciScrollBar({
         delta: 2,
         lineDelay: 0,
         lineTimer: 0,
         pageDelay: 0,
         pageTimer: 0,
         bindKeyboard: false,
         resizable: false,
         smoothScroll: false
   });
}

StrongholdScreenMainModule.prototype.changeBaseName = function ()
{
	SQ.call(this.mSQHandle, 'changeBaseName', this.mChangeNameInput.getInputText());
};

StrongholdScreenMainModule.prototype.changeSetting = function (_setting, _value)
{
	SQ.call(this.mSQHandle, 'onChangeSetting', [_setting, _value]);
};

StrongholdScreenMainModule.prototype.notifyBackendPayForRaided = function (_setting, _value)
{
	SQ.call(this.mSQHandle, 'onPayForRaided', this.mData.TownAssets.IsRaidedUntil);
};

StrongholdScreenMainModule.prototype.notifyBackendConsumeOverflow = function ()
{
	SQ.call(this.mSQHandle, 'onConsumeOverflow');
};


