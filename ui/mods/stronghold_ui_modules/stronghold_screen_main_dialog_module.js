"use strict";
var StrongholdScreenMainModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mID = "MainModule";
    this.mTitle = "Overview";
    this.mAlwaysUpdate = true;
    this.mHeaderRow = null;
    this.mBaseSpriteImage = null;
    this.mAssets = {
    	Tier : {
    		Img : "",
    		Div : null
    	},
    	Defenders : {
    		Img : "",
    		Div : null
    	},
    	Roster : {
    		Img : "",
    		Div : null
    	},
    	Stash : {
    		Img : "",
    		Div : null
    	},
    	Recruits : {
    		Img : "",
    		Div : null
    	},
    	LastVisit : {
    		Img : "",
    		Div : null
    	},
    	Gold : {
    		Img : "",
    		Div : null
    	},
    	Tools : {
    		Img : "",
    		Div : null
    	},
    	Medicine : {
    		Img : "",
    		Div : null
    	},
    	Arrows : {
    		Img : "",
    		Div : null
    	},
    }
    this.mBaseSettings = {
    	// AutoConsume : null,
    	ShowBanner : null,
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
    MSU.iterateObject(this.mAssets, function(_key, _value)
    {
    	var ret = $('<div class="main-module-asset-row"/>')
    		.appendTo(assetsContainer);
    	Stronghold.getTextSpan(	text.Assets[_key])
    		.appendTo(ret);
    	$('<img class="main-module-asset-img">')
    		.attr("src", _value.Img)
    		.appendTo(ret)
    	_value.Div = $('<img class="main-module-asset-value">')
    		.appendTo(ret);
    	return ret;
    })
    this.mRaidedContainer = this.mContentContainer.appendRow(text.RaidedTitle).hide();
    this.mRaidedImage = $("<img/>").css({"width" : "5rem", "height" : "5rem", "margin-left" : "2rem"}).attr('src', Path.GFX + "ui/settlement_status/settlement_effect_08.png").appendTo(this.mRaidedContainer);
    this.mRaidedText = Stronghold.getTextDiv().css({"width" : "90%", "padding-left" : "5rem"}).appendTo(this.mRaidedContainer);
    var footer = this.mRaidedContainer.appendRow(null, "stronghold-flex-center");
    this.mRaidedButton = footer.createTextButton(text.RaidedButton, $.proxy(function()
    {
        this.notifyBackendPayForRaided();
    }, this), "stronghold-button-4", 4)

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

    	checkbox.on('ifChecked ifUnchecked', null, this, function (_event) {
    		self.changeSetting(_key, checkbox.prop('checked') === true);
    	});
    	checkbox.iCheck("check");
    })
};

StrongholdScreenMainModule.prototype.loadFromData = function()
{
	var self = this;
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;
	var text = this.getModuleText();
	this.mParent.updateTitle(text.Title);

	this.mChangeNameInput.setInputText(this.mData.TownAssets.Name);

	var baseSprite = this.mData.TownAssets.SpriteName;
	var currentSprite = Stronghold.Visuals.VisualsMap[baseSprite].Base[this.mData.TownAssets.Size -1];
    this.mBaseSpriteImage.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentSprite + ".png");
    MSU.iterateObject(this.mBaseSettings, function(_key, _value)
    {
    	_value.iCheck(self.mData.TownAssets.BaseSettings[_key] === true ? 'check' : 'uncheck');
    });

    if (this.mData.TownAssets.IsRaidedUntil > 0)
    {
    	var price = this.mData.TownAssets.IsRaidedUntil * this.mModuleData.RaidedCostPerDay;
    	this.mRaidedText.text(Stronghold.Text.format(text.RaidedText, this.mData.TownAssets.IsRaidedUntil, price));
    	this.mRaidedButton.find(".label").text(Stronghold.Text.format(text.RaidedButton, price))
    	this.mRaidedButton.attr("disabled", price > this.mData.Assets.Money)
    	this.mRaidedContainer.show();
    }
    else this.mRaidedContainer.hide();
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

