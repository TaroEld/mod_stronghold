
"use strict";
var StrongholdScreenVisualsModule = function(_parent)
{
	StrongholdScreenModuleTemplate.call(this, _parent);
	this.mID = "VisualsModule"
	this.mTitle = "Change Visuals"
    this.mCurrentBaseSprite = null;
    this.mBaseSprite = null;
    this.mBaseSpriteIndex = null;
    this.mSpriteImages = {
    	Tier1 : null,
    	Tier2 : null,
    	Tier3 : null,
    	Tier4 : null,
    	Mercenaries : null,
    	Houses : null
    };
};

StrongholdScreenVisualsModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenVisualsModule.prototype, 'constructor', {
    value: StrongholdScreenVisualsModule,
    enumerable: false,
    writable: true });

StrongholdScreenVisualsModule.prototype.createDIV = function (_parentDiv)
{
	StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    var self = this;
    var text = this.getModuleText();
    this.mContentContainer.addClass("visuals-module");
    
    var spritesHeader = this.mContentContainer.appendRow("");
    this.mSpritesetLabel = spritesHeader.find(".sub-title");
    this.mSpritesContainer = this.mContentContainer.appendRow(null, "sprites-container stronghold-generic-background");

    MSU.iterateObject(this.mSpriteImages, function(_key, _value){
    	var changeSpriteContainer = $('<div class="sprite-container"/>');
    	self.mSpritesContainer.append(changeSpriteContainer)
    	self.mSpriteImages[_key] = $('<img class="sprite-image"/>');
    	changeSpriteContainer.append(self.mSpriteImages[_key]);
    	Stronghold.getTextDiv(Stronghold.Text.General[_key])
    		.addClass("stronghold-flex-center")
    		.appendTo(changeSpriteContainer);
    });
    this.mSpriteImages.Mercenaries.css({
    	"width" : "10rem",
    	"height" : "auto"
    })


    var footerRow = this.mContentContainer.appendRow(null, "footer-button-bar");
    var buttonLayout = $('<div class="switch-button-container"/>');
    footerRow.append(buttonLayout);
    var switchPrevButton = buttonLayout.createImageButton(Path.GFX + "ui/skin/switch_previous.png", function ()
    {
        self.switchSpriteImage(-1);
    }, "switch-image", 3);
    var switchNextButton = buttonLayout.createImageButton(Path.GFX + "ui/skin/switch_next.png", function ()
    {
        self.switchSpriteImage(1);
    }, "switch-image", 3);
    this.mApplySpritesButton = footerRow.createTextButton(text.Button, function()
    {
        self.changeSprites();
    }, "apply-sprites-button", 1);
};

StrongholdScreenVisualsModule.prototype.getSpriteIndex = function()
{
	return Stronghold.Visuals.VisualsKeys.indexOf(this.mBaseSprite);
}

StrongholdScreenVisualsModule.prototype.switchSpriteImage = function( _idx )
{
	var arrLen = Stronghold.Visuals.VisualsKeys.length;
	var newIdx = this.getSpriteIndex() + _idx;
	if(newIdx == arrLen) newIdx = 0;
	if(newIdx < 0) newIdx = arrLen - 1;
	this.mBaseSprite = Stronghold.Visuals.VisualsKeys[newIdx];
    this.setSpriteImage();
}

StrongholdScreenVisualsModule.prototype.loadFromData = function(_data)
{
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;
	this.mBaseSprite = this.mData.TownAssets.Spriteset;
    this.mCurrentBaseSprite = this.mData.TownAssets.Spriteset;
	this.mBaseSpriteIndex = this.getSpriteIndex();
	this.setSpriteImage()
}

StrongholdScreenVisualsModule.prototype.setSpriteImage = function()
{
	var currentArr = Stronghold.Visuals.VisualsMap[this.mBaseSprite];
	var text = this.getModuleText();

    this.mSpriteImages.Tier1.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentArr.Base[0] + ".png");
    this.mSpriteImages.Tier2.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentArr.Base[1] + ".png");
    this.mSpriteImages.Tier3.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentArr.Base[2] + ".png");
    this.mSpriteImages.Tier4.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentArr.Base[3] + ".png");
	this.mSpriteImages.Mercenaries.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentArr.WorldmapFigure[0] + ".png");
	this.mSpriteImages.Houses.attr('src', Path.GFX + Stronghold.Visuals.SpritePath + currentArr.Houses[0] + ".png");
	var name = Stronghold.Text.format(text.Spriteset, currentArr.Name, currentArr.Author, this.mCurrentBaseSprite == this.mBaseSprite ? text.Current : "")
	this.mSpritesetLabel.html(name)
}

StrongholdScreenVisualsModule.prototype.changeSprites = function ()
{
    SQ.call(this.mSQHandle, 'changeSprites', this.mBaseSprite);
};
