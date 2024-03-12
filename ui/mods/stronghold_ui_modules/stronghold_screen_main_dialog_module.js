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
};

StrongholdScreenMainModule.prototype.loadFromData = function()
{
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;
	var text = this.getModuleText();
	this.mParent.updateTitle(text.Title);

	this.mChangeNameInput.setInputText(this.mData.TownAssets.Name);

	var baseSprite = this.mData.TownAssets.SpriteName;
	var currentSprite = Stronghold.Visuals.VisualsMap[baseSprite].Base[this.mData.TownAssets.Size -1];
    this.mBaseSpriteImage.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentSprite + ".png");
}

StrongholdScreenMainModule.prototype.changeBaseName = function ()
{
	SQ.call(this.mSQHandle, 'changeBaseName', this.mChangeNameInput.getInputText());
};
