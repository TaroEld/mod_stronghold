var Stronghold = {
	Visuals :
	{
	    SpritePath : "ui/settlement_sprites/",
	    BuildingSpritePath : "ui/buildings/",
	    LocationSpritePath : "ui/locations/",
	    SelectionImagePath : "ui/selection.png",
	    SelectionGoldImagePath : "ui/selection-gold.png",
	    BaseSpriteTypes : ["Default", "Luft_Basic", "Luft_Brigand", "Luft_Necro", "Luft_Fishing"],
	    Sprites : {
	        Default : {
	            "MainSprites" 		: ["stronghold_01", "stronghold_02", "stronghold_03"],
	            "HouseSprites" 		: ["houses_03_01", "", ""],
	            "UnitSprite" 		: "figure_mercenary_01",
	            "HamletSprite" 		: "townhall_01",
	            "Name" 				: "Default",
	            "Author" 			: "Overhype"
	        },
	        Luft_Basic : {
	            "MainSprites" 		: ["luft_basic_01", "luft_basic_02", "luft_basic_03"],
	            "HouseSprites" 		: ["luft_basic_houses_01", "", ""],
	            "UnitSprite" 		: "luft_basic_patrol",
	            "HamletSprite" 		: "townhall_01",
	            "Name" 				: "Basic Village",
	            "Author" 			: "Luftwaffle"
	        },
	        Luft_Brigand : {
	            "MainSprites" 		: ["luft_fort_01", "luft_fort_02", "luft_fort_03"],
	            "HouseSprites" 		: ["luft_fort_houses_01", "", ""],
	            "UnitSprite" 		: "luft_fort_patrol",
	            "HamletSprite" 		: "townhall_01",
	            "Name" 				: "Brigand's Hideout",
	            "Author" 			: "Luftwaffle"
	        },
	        Luft_Necro : {
	            "MainSprites" 		: ["luft_necro_01", "luft_necro_02", "luft_necro_03"],
	            "HouseSprites" 		: ["luft_necro_houses_01", "", ""],
	            "UnitSprite" 		: "luft_necro_patrol",
	            "HamletSprite" 		: "townhall_01",
	            "Name" 				: "Necromancer's Lair",
	            "Author" 			: "Luftwaffle"
	        },
	        Luft_Fishing : {
	            "MainSprites" 		: ["luft_fishing_01", "luft_fishing_02", "luft_fishing_03"],
	            "HouseSprites" 		: ["luft_fishing_houses_01", "", ""],
	            "UnitSprite" 		: "luft_fishing_patrol",
	            "HamletSprite" 		: "townhall_01",
	            "Name" 				: "Fishing Village",
	            "Author" 			: "Luftwaffle"
	        }
	    },
	},
    Roster : {
    	ToggleScroll :
    	{
    	    Max   : 3,
    	    Min   : 1,
    	    Type  :
    	    {
    	        Stats    : 1,
    	        Skills   : 2,
    	        Portrait : 3,
    	    },
    	    Order :
    	    {
    	        Ascending  :  1,
    	        Descending : -1,
    	    },
    	},
    	RosterOwner :
    	{
    	    Stronghold: 'roster.stronghold',
    	    Player: 'roster.player'
    	}
    },
    Style : {
    	TextFont : 'text-font-normal font-style-italic font-bottom-shadow font-color-subtitle',
    	TextFontSmall : 'text-font-medium font-style-italic font-bottom-shadow font-color-subtitle'
    },
    Text : {
    	Requirements : "Requirements",
    	HamletModule : {},
    	MainModuleModule : {},
    	MiscModule : {
    		BuildRoad : {
    			Description : "Building a road to the road network allows your caravans to travel and your patrols to roam. You will also be able to send gifts to connected factions.",
    			BuildTo : "Build Road to: "
    		},
    		SendGifts : {
    			Description : 'You can choose to send a delegation carrying gifts to a faction. This will consume the treasures you have in your warehouse, and will increase relations with that faction depending on the value of the gifts. The caravan will demand 5000 crowns to transport the goods.<br>The caravan will be traveling on roads towards the target town, and while it will be protected by a number of mercenaries, you might want to accompany it.',
    			SendTo : "Send Gifts to: ",
    			Requirements: {
    				Faction : "At least one faction is connected to you by roads and not friendly",
    				Price : "Price: {price} (for transportation of the gifts)",
    				HaveGifts : "Have gifts (treasure items) in your warehouse.",
    			},
    			CurrentRelation : "Current relation: {num} ({numText})",
    			TargetTown : "Target town: {town}",
    			ReputationGain : "Reputation gained from the gifts: {reputation}",
    		},
    		TrainBrother : {
    			Description : "Provide focused training to one of your recruits",
    			Invalid : "Nobody here can provide training beyond the services of a Training Hall."
    		},
    		BuyWater : {
    			Description : "Buy a Water Skin with mythical properties.",
    			Invalid : "You ask the learned men if they could craft you a mythical Water of Life. Unfortunately, the recipe has been lost to time. Perhaps you can recover it."
    		},
    		HireMercenaries : {
    			Description : "Hire a group of mercenaries to follow you in your travels.",
    			Invalid : "There are no mercenary companies available for hire."
    		},
    	},
    	RosterModule : {},
    	StashModule : {},
    	StructureModule : {},
    	BuildingsModule : {},
    	LocationsModule : {},
    	VisualsModule : {},
    	UpgradeModule : {},
    },
    getTextDiv : function(_text)
    {
    	return $("<div/>")
    		.addClass(Stronghold.Style.TextFont)
    		.text(_text || "")
    },
    getTextDivSmall : function(_text)
    {
    	return $("<div/>")
    		.addClass(Stronghold.Style.TextFontSmall)
    		.text(_text || "")
    },
    getTextSpan : function(_text)
    {
    	return $("<span/>")
    		.addClass(Stronghold.Style.TextFont)
    		.text(_text || "")
    },
    getTextSpanSmall : function(_text)
    {
    	return $("<span/>")
    		.addClass(Stronghold.Style.TextFontSmall)
    		.text(_text || "")
    }
}


$.fn.toggleDisplay = function(_bool)
{
    if(_bool === false)
    {
        this.removeClass('display-block').addClass('display-none')
    }
    else if (_bool === true)
    {
        this.removeClass('display-none').addClass('display-block')
    }
    else
    {
        if(this.hasClass('display-block'))
        {
            this.removeClass('display-block').addClass('display-none')
        }
        else
        {
            this.removeClass('display-none').addClass('display-block')
        }
    }
}

$.fn.toggleOpacity = function(_bool)
{
    if(_bool === false)
    {
        this.removeClass('opacity-full').addClass('opacity-none')
    }
    else if (_bool === true)
    {
        this.removeClass('opacity-none').addClass('opacity-full')
    }
    else
    {
        if(this.hasClass('opacity-full'))
        {
            this.removeClass('opacity-full').addClass('opacity-none')
        }
        else
        {
            this.removeClass('opacity-none').addClass('opacity-full')
        }
    }
}

$.fn.appendRow = function(_subTitle, _classes)
{
    var row = $('<div class="flex-row"/>')
    	.appendTo(this)
    	.addClass(_classes || "")

    if (_subTitle !== undefined && _subTitle !== null)
        row.append($('<div class="sub-title title-font-big font-bold font-bottom-shadow font-color-title">' + _subTitle + '</div>'))
    return row
}

$.fn.changeDialogFooterRows = function(_rows, _big)
{
	//add rows to events to get more options
	this.removeClass('has-one-row-footer has-two-rows-footer has-three-rows-footer has-four-rows-footer has-five-rows-footer has-six-rows-footer has-seven-rows-footer has-eight-rows-footer has-nine-rows-footer has-ten-rows-footer has-eleven-rows-footer has-twelve-rows-footer has-big-footer');
    switch(_rows)
    {
        case 1: this.addClass('has-one-row-footer'); break;
        case 2: this.addClass('has-two-rows-footer'); break;
        case 3: this.addClass('has-three-rows-footer'); break;
    	case 4: this.addClass('has-four-rows-footer'); break;
    	case 5: this.addClass('has-five-rows-footer'); break;
    	case 6: this.addClass('has-six-rows-footer'); break;
		case 7: this.addClass('has-seven-rows-footer'); break;
    	case 8: this.addClass('has-eight-rows-footer'); break;
		case 9: this.addClass('has-nine-rows-footer'); break;
		case 10: this.addClass('has-ten-rows-footer'); break;
    	case 11: this.addClass('has-eleven-rows-footer'); break;
		case 12: this.addClass('has-twelve-rows-footer'); break;
		
        default: this.addClass('has-one-row-footer'); break;
    }

    if(_big !== null && _big === true)
    {
        this.addClass('has-big-footer');
    }

    return this;
};

var old_createItemSlot = WorldTownScreenShopDialogModule.prototype.createItemSlot
WorldTownScreenShopDialogModule.prototype.createItemSlot = function (_owner, _index, _parentDiv, _screenDiv)
{
    var self = this;
    var result = old_createItemSlot.call(this, _owner, _index, _parentDiv, _screenDiv);
    result.off("mousedown");
    result.assignListItemRightClick(function (_item, _event)
	{
        var data = _item.data('item');

        var isEmpty = (data !== null && 'isEmpty' in data) ? data.isEmpty : true;
        var owner = (data !== null && 'owner' in data) ? data.owner : null;
        //var itemId = (data !== null && 'id' in data) ? data.id : null;
        var itemIdx = (data !== null && 'index' in data) ? data.index : null;
		var repairItem = KeyModiferConstants.AltKey in _event && _event[KeyModiferConstants.AltKey] === true;
		var reforgeItem = KeyModiferConstants.ShiftKey in _event && _event[KeyModiferConstants.ShiftKey] === true;

        if(isEmpty === false && owner !== null && itemIdx !== null)
        {
            switch(owner)
            {
                case WorldTownScreenShop.ItemOwner.Stash:
                {
                    if (repairItem === true)
                    {
                        //console.info('destroy');
                        self.repairItem(itemIdx);
                    }
                    else
                    {
                        //console.error('sell');
                        self.swapItem(itemIdx, owner, null, WorldTownScreenShop.ItemOwner.Shop);
                    }
                } break;
                case WorldTownScreenShop.ItemOwner.Shop:
                {
                	if (reforgeItem == true){
                    	self.checkIfReforgeIsValid(itemIdx)
                    	return false
                    }
                    else{
                    	self.swapItem(itemIdx, owner, null, WorldTownScreenShop.ItemOwner.Stash);
                    }
         
                } break;
            }
        }
    });
    return result
}

WorldTownScreenShopDialogModule.prototype.showConfirmReforgeDialog = function(_sourceItemIdx, _itemName, _price, _affordable){
     var self = this;
     this.mPopupDialog = $('.world-town-screen').createPopupDialog('Confirm reforging', null, null, "confirm-reforge-dialog");
     this.mPopupDialog.addPopupDialogContent(this.createConfirmReforgeContent(this.mPopupDialog, _itemName, _price, _affordable));
     if(_affordable == true){
     	this.mPopupDialog.addPopupDialogOkButton(function (_dialog)
     	{
     	   self.mPopupDialog = null;
     	   self.reforgeNamedItemAfterClick(_sourceItemIdx);
     	   _dialog.destroyPopupDialog();

     	});
     	this.mPopupDialog.addPopupDialogCancelButton(function (_dialog)
     	{
     	   self.mPopupDialog = null;
     	   _dialog.destroyPopupDialog();
     	});
     }
     else{
     	this.mPopupDialog.addPopupDialogOkButton(function (_dialog)
     	{
     	   self.mPopupDialog = null;
     	   _dialog.destroyPopupDialog();
     	});
     }
}

WorldTownScreenShopDialogModule.prototype.createConfirmReforgeContent = function (_dialog, _itemName, _price, _affordable)
{
    var result = $('<div class="confirm-reforge-container"/>');

    var row = $('<div class="row"/>');
    result.append(row);

    var label = $('<div class="text-font-normal font-color-label"></div>');
    if(_affordable === true){
    	label.html("Are you sure you want to reforge the " + _itemName + " ? This will cost " + _price + " crowns.")
    }
    else{
    	label.html("You can't afford to reforge the " + _itemName + " ! (" + _price + " crowns.)")
    }
    row.append(label);

    return result;
};

WorldTownScreenShopDialogModule.prototype.reforgeNamedItemAfterClick = function(_sourceItemIdx){
    
    var self = this;
   	SQ.call(this.mSQHandle, 'onReforgeNamedItem', _sourceItemIdx, function (data)
    {
        // check if we have an error
        if (ErrorCode.Key in data)
        {
            self.notifyEventListener(ErrorCode.Key, data[ErrorCode.Key]);
        }
        else
        {
            if(data.Item != null)
            {
                self.updateSlotItem(WorldTownScreenShop.ItemOwner.Shop, self.mShopSlots, data.Item, _sourceItemIdx, WorldTownScreenShop.ItemFlag.Updated);
            }

            self.mParent.loadAssetData(data.Assets);
        }
    });
};

WorldTownScreenShopDialogModule.prototype.checkIfReforgeIsValid = function (_sourceItemIdx)
{
	var self = this;
    SQ.call(this.mSQHandle, 'onReforgeIsValid', _sourceItemIdx, function(data){
    	if (data === undefined || data == null || typeof (data) !== 'object')
    	{
    	    console.error('ERROR: Failed to reforge item.');
    	    return;
    	}
    	if (data["IsValid"] === false){
    		return
    	}
    	self.showConfirmReforgeDialog(data["ItemIdx"], data["ItemName"], data["Price"], data["Affordable"]);
    });
};


WorldTownScreenMainDialogModule.prototype.renameTown = function (_dialog)
{
	
    var contentContainer = _dialog.findPopupDialogContentContainer();
    var inputFields = contentContainer.find('input');
	SQ.call(this.mSQHandle, 'renameTown', [$(inputFields[0]).getInputText()]);

};



WorldTownScreenMainDialogModule.prototype.deleteRenameUI = function ()
{
	this.mDialogContainer.findDialogTextContainer().off("click");
	this.mDialogContainer.findDialogTextContainer().unbindTooltip()

};

WorldTownScreenMainDialogModule.prototype.loadRenameUI = function ()
{
	var self = this;
	if (typeof this.mCurrentPopupDialog === "undefined")
	{
		this.mCurrentPopupDialog = null;
	}
	this.mDialogContainer.findDialogTextContainer().bindTooltip({ contentType: 'ui-element', elementId: 'world-town-screen.main-dialog-module.RenameButton' });
	this.mDialogContainer.findDialogTextContainer().click(function ()
	{
		self.mCurrentPopupDialog = self.mContainer.createPopupDialog('Change name', null, null, 'rename-town-popup');
		self.notifyBackendPopupDialogIsVisible(true)
		self.mCurrentPopupDialog.addPopupDialogOkButton(function (_dialog)
		{
			self.renameTown(_dialog);
			self.mCurrentPopupDialog = null;
			_dialog.destroyPopupDialog();
			self.notifyBackendPopupDialogIsVisible(false)
		});
		
		self.mCurrentPopupDialog.addPopupDialogCancelButton(function (_dialog)
		{
			self.mCurrentPopupDialog = null;
			_dialog.destroyPopupDialog();
			self.notifyBackendPopupDialogIsVisible(false)
		});
		self.mCurrentPopupDialog.addPopupDialogContent(self.createRenameTownContent(self.mCurrentPopupDialog));


		// focus!
		var inputFields = self.mCurrentPopupDialog.findPopupDialogContentContainer().find('input');
		$(inputFields[0]).focus();
	});

};

WorldTownScreenMainDialogModule.prototype.createRenameTownContent = function (_dialog)
{
    var result = $('<div class="rename-town-container"/>');

    // create & set name
    var row = $('<div class="row"/>');
    result.append(row);
    var label = $('<div class="label text-font-normal font-color-label font-bottom-shadow">Name</div>');
    row.append(label);

	var self = this;

    var inputLayout = $('<div class="l-input"/>');
    row.append(inputLayout);
    var inputField = inputLayout.createInput('', 0, Constants.Game.MAX_BROTHER_NAME_LENGTH, 1, function (_input)
	{
        _dialog.findPopupDialogOkButton().enableButton(_input.getInputTextLength() >= Constants.Game.MIN_BROTHER_NAME_LENGTH);
    }, 'title-font-big font-bold font-color-brother-name', function (_input)
	{
		var button = _dialog.findPopupDialogOkButton();
		if(button.isEnabled())
		{
			button.click();
		}
	});

    return result;
};

$.fn.findDialogTextContainer = function()
{
    var result = this.find('.text-container:first');
    if (result.length > 0)
    {
        return result;
    }
    return null;
};
WorldTownScreenMainDialogModule.prototype.notifyBackendPopupDialogIsVisible = function (_visible)
{
    this.mIsPopupOpen = _visible;
    SQ.call(this.mSQHandle, 'onRenameTownVisible', _visible);
};


WorldCampfireScreenAssets.prototype.createStrongholdDIV = function (_parentDiv)
{
	var self = this;
	var layout = $('<div class="l-button"/>');
	_parentDiv.append(layout);
	this.mStrongholdButton = layout.createImageButton(Path.GFX + 'ui/settlements/stronghold_01_retinue.png', function ()
	{
	    self.mParent.notifyBackendStrongholdButtonPressed();
	}, "stronghold-retinue-button");
    return layout;
};

var retinue_createDIV = WorldCampfireScreenAssets.prototype.createDIV
WorldCampfireScreenAssets.prototype.createDIV = function (_parentDiv)
{
	retinue_createDIV.call(this, _parentDiv)
	this.createStrongholdDIV(_parentDiv);
};

var retinue_loadFromData = WorldCampfireScreenAssets.prototype.loadFromData
WorldCampfireScreenAssets.prototype.loadFromData = function (_data){
	if(this.mStrongholdButton != null && 'showStrongholdButton' in _data && _data['showStrongholdButton'] === false){
		this.mStrongholdButton.remove();
		this.mStrongholdButton = null;
	}
	retinue_loadFromData.call(this, _data)
}
var hire_show = WorldCampfireScreenHireDialogModule.prototype.show
WorldCampfireScreenHireDialogModule.prototype.show = function (_withSlideAnimation)
{
	hire_show.call(this, _withSlideAnimation)
	if(this.mAssets.mStrongholdButton != null) this.mAssets.mStrongholdButton.toggleDisplay(false);
}

var hire_hide = WorldCampfireScreenHireDialogModule.prototype.hide
WorldCampfireScreenHireDialogModule.prototype.hide = function ()
{
	hire_hide.call(this)
	if(this.mAssets.mStrongholdButton != null) this.mAssets.mStrongholdButton.toggleDisplay(true);
}

WorldCampfireScreen.prototype.notifyBackendStrongholdButtonPressed = function ()
{
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onStrongholdClicked', null);
    }
};

var retinue_bindTooltips = WorldCampfireScreenAssets.prototype.bindTooltips
WorldCampfireScreenAssets.prototype.bindTooltips = function ()
{
    retinue_bindTooltips.call(this)
    if (this.mStrongholdButton != null){
        this.mStrongholdButton.bindTooltip({ contentType: 'ui-element', elementId: "stronghold-retinue-button" });
    } 
};

var retinue_unbindTooltips = WorldCampfireScreenAssets.prototype.unbindTooltips
WorldCampfireScreenAssets.prototype.unbindTooltips = function ()
{
    retinue_unbindTooltips.call(this)
    if (this.mStrongholdButton != null){
        this.mStrongholdButton.unbindTooltip();
    }

};

var retinue_destroyDIV = WorldCampfireScreenAssets.prototype.destroyDIV
WorldCampfireScreenAssets.prototype.destroyDIV = function ()
{
    retinue_destroyDIV.call(this)
    if (this.mStrongholdButton != null){
    	this.mStrongholdButton.remove();
    	this.mStrongholdButton = null;
    }
};


