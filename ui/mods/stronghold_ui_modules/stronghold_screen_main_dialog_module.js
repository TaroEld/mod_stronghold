
"use strict";
var StrongholdScreenMainModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mID = "MainModule";
    this.mTitle = "Your Base"
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
    this.mContentContainer.load("mods/stronghold_ui_modules/stronghold_screen_main_dialog_module.html", function()
	{
	    self.mBaseSpriteImage = $('#base-sprite-image');
	    self.mChangeNameInput = $('#change-base-name-input-container').createInput("", 0, 200, 1, null, 'title-font-big font-bold font-color-brother-name', function (_input)
		{
			self.mChangeNameButton.click()
		});
		self.mChangeNameButton = $('#change-base-name-button-container').createTextButton("Change Name", function(){
	    	self.changeBaseName();
	    }, '', 1)


	    self.addAssetRow($(this), "Local Roster", "");
		self.addAssetRow($(this), "Local Stash", "");
		self.addAssetRow($(this), "Local Recruits", "");
	});
};

StrongholdScreenMainModule.prototype.addAssetRow = function(_parent, _name, _imgsrc)
{
	var ret = $('<div class="main-module-asset-row"/>');
	var name = $('<div class="title-font-big font-bold font-color-brother-name main-module-asset-name"/>');
	ret.append(name);
	name.html(_name);
	var img = $('<img class="main-module-asset-img">');
	img.src = _imgsrc;
	ret.append(img);
	_parent.append(ret);
	return ret;
}

StrongholdScreenMainModule.prototype.loadFromData = function()
{
	this.mTitle = this.mData.TownAssets.Name;
	this.mParent.updateTitle(this.mTitle);
	this.mChangeNameInput.setInputText(this.mData.TownAssets.Name);
	var baseSprite = this.mData.TownAssets.SpriteName;
	var currentSprite = StrongholdConst.Sprites[baseSprite].MainSprites[this.mData.TownAssets.Size -1];
    this.mBaseSpriteImage.attr('src', Path.GFX + StrongholdConst.SpritePath + currentSprite + ".png");
}

StrongholdScreenMainModule.prototype.changeBaseName = function ()
{
	SQ.call(this.mSQHandle, 'changeBaseName', this.mChangeNameInput.getInputText());
};
