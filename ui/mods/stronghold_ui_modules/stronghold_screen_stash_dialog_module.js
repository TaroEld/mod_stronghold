"use strict";
var StrongholdScreenStashModule = function(_parent)
{
	StrongholdScreenModuleTemplate.call(this, _parent);
	this.mID = "StashModule"
	this.mTitle = "Your Stash"
	this.mActiveBuilding = null;
	    // event listener
    this.mEventListener = null;

    // list containers
    this.mStashListContainer = null;
    this.mStashListScrollContainer = null;
    this.mShopListContainer = null;
    this.mShopListScrollContainer = null;

    // stash labels
    this.mStashSlotSizeContainer = null;
    this.mStashSlotSizeLabel = null;

    this.mStashSpaceUsed = 0;
    this.mStashSpaceMax = 0;

    // stash & found loot
    this.mStashSlots = null;
    this.mShopSlots = null;

	// lists
	this.mStashList = null;
	this.mShopList = null;

	// sort & filter
	this.mSortInventoryButton = null;
	this.mFilterAllButton = null;
	this.mFilterWeaponsButton = null;
	this.mFilterArmorButton = null;
	this.mFilterMiscButton = null;
    this.mFilterUsableButton = null;

	this.mIsRepairOffered = false;

    // generics
	this.mIsVisible = false;
};

StrongholdScreenStashModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenStashModule.prototype, 'constructor', {
	value: StrongholdScreenStashModule,
	enumerable: false,
	writable: true });

StrongholdScreenStashModule.prototype.createDIV = function (_parentDiv)
{
	StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
	var self = this;

	this.mContentContainer.addClass("stash-module");
    // create stash
    var leftColumn = $('<div class="column is-left"/>');
    this.mContentContainer.append(leftColumn);
    var headerRow = $('<div class="row is-header title-font-normal font-bold font-color-title">Player Stash</div>');
    leftColumn.append(headerRow);
	var contentRow = $('<div class="row is-content"/>');
    leftColumn.append(contentRow);
    var footerRow = $('<div class="row is-footer"/>');
    leftColumn.append(footerRow);

    var listContainerLayout = $('<div class="l-list-container is-left"></div>');
    contentRow.append(listContainerLayout);
    this.mStashListContainer = listContainerLayout.createList(1.24/*8.63*/);
    this.mStashListScrollContainer = this.mStashListContainer.findListScrollContainer();

    // create middle
    var middleColumn = $('<div class="column is-middle"/>');
    this.mContentContainer.append(middleColumn);
    contentRow = $('<div class="row is-content"/>');
    middleColumn.append(contentRow);
	var buttonContainer = $('<div class="button-container"/>');
    contentRow.append(buttonContainer);

	// sort/filter
	var layout = $('<div class="l-button is-sort"/>');
    buttonContainer.append(layout);
    this.mSortInventoryButton = layout.createImageButton(Path.GFX + Asset.BUTTON_SORT, function()
	{
        self.notifyBackendSortButtonClicked();
    }, '', 3);

	var layout = $('<div class="l-button is-all-filter"/>');
    buttonContainer.append(layout);
    this.mFilterAllButton = layout.createImageButton(Path.GFX + Asset.BUTTON_ALL_FILTER, function()
	{
		$(".stash-module-filter-button").removeClass('is-active');
		self.mFilterAllButton.addClass('is-active');
		self.notifyBackendFilterAllButtonClicked();
    }, 'stash-module-filter-button', 3);
	self.mFilterAllButton.addClass('is-active');

	var layout = $('<div class="l-button is-weapons-filter"/>');
    buttonContainer.append(layout);
    this.mFilterWeaponsButton = layout.createImageButton(Path.GFX + Asset.BUTTON_WEAPONS_FILTER, function()
	{
		$(".stash-module-filter-button").removeClass('is-active');
		self.mFilterWeaponsButton.addClass('is-active');
		self.notifyBackendFilterWeaponsButtonClicked();
    }, 'stash-module-filter-button', 3);

	var layout = $('<div class="l-button is-armor-filter"/>');
    buttonContainer.append(layout);
    this.mFilterArmorButton = layout.createImageButton(Path.GFX + Asset.BUTTON_ARMOR_FILTER, function()
	{
		$(".stash-module-filter-button").removeClass('is-active');
		self.mFilterArmorButton.addClass('is-active');
		self.notifyBackendFilterArmorButtonClicked();
    }, 'stash-module-filter-button', 3);

	var layout = $('<div class="l-button is-misc-filter"/>');
    buttonContainer.append(layout);
    this.mFilterMiscButton = layout.createImageButton(Path.GFX + Asset.BUTTON_MISC_FILTER, function()
	{
		$(".stash-module-filter-button").removeClass('is-active');
        self.mFilterMiscButton.addClass('is-active');
        self.notifyBackendFilterMiscButtonClicked();
    }, 'stash-module-filter-button', 3);

    var layout = $('<div class="l-button is-usable-filter"/>');
    buttonContainer.append(layout);
    this.mFilterUsableButton = layout.createImageButton(Path.GFX + Asset.BUTTON_USABLE_FILTER, function ()
    {
    	$(".stash-module-filter-button").removeClass('is-active');
        self.mFilterUsableButton.addClass('is-active');
        self.notifyBackendFilterUsableButtonClicked();
    }, 'stash-module-filter-button', 3);

    var layout = $('<div class="l-button small-items-button"/>');
    buttonContainer.append(layout);
    this.mSetSmallSizeButton = layout.createImageButton(Path.GFX + "ui/skin/small_icons.png", function ()
    {
		self.mSetSmallSizeButton.toggleClass('is-active');
		self.mContentContainer.toggleClass("small-items");
    }, 'stash-module-filter-button', 3);

    var slotSizeImage = '<img src=" ' + Path.GFX + Asset.ICON_BAG +'"/>';
    this.mStashSlotSizeContainer = $('<div class="slot-count-container"/>').appendTo(buttonContainer);
    $('<div class="slot-count-header text-font-small font-color-title">Player</div>').appendTo(this.mStashSlotSizeContainer);
    this.mStashSlotSizeContainer.append($(slotSizeImage));
    this.mStashSlotSizeLabel = $('<div class="label text-font-small font-bold font-color-value"/>');
    this.mStashSlotSizeContainer.append(this.mStashSlotSizeLabel);

    this.mTownStashSlotSizeContainer = $('<div class="slot-count-container town"/>').appendTo(buttonContainer);
    $('<div class="slot-count-header text-font-small font-color-title">Town</div>').appendTo(this.mTownStashSlotSizeContainer);
    this.mTownStashSlotSizeContainer.append($(slotSizeImage));
    this.mTownStashSlotSizeLabel = $('<div class="label text-font-small font-bold font-color-value"/>');
    this.mTownStashSlotSizeContainer.append(this.mTownStashSlotSizeLabel);

    // create shop loot
    var rightColumn = $('<div class="column is-right"/>');
    this.mContentContainer.append(rightColumn);
    headerRow = $('<div class="row is-header title-font-normal font-bold font-color-title">Town Stash</div>');
    rightColumn.append(headerRow);
    contentRow = $('<div class="row is-content"/>');
    rightColumn.append(contentRow);

    listContainerLayout = $('<div class="l-list-container is-right"></div>');
    contentRow.append(listContainerLayout);
    this.mShopListContainer = listContainerLayout.createList(1.24/*8.63*/);
    this.mShopListScrollContainer = this.mShopListContainer.findListScrollContainer();
    this.setupEventHandler();
};

StrongholdScreenStashModule.prototype.bindTooltips = function ()
{
	this.mSortInventoryButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.RightPanelHeaderModule.SortButton });
	this.mFilterAllButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.RightPanelHeaderModule.FilterAllButton });
	this.mFilterWeaponsButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.RightPanelHeaderModule.FilterWeaponsButton });
	this.mFilterArmorButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.RightPanelHeaderModule.FilterArmorButton });
    this.mFilterMiscButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.RightPanelHeaderModule.FilterMiscButton });
    this.mFilterUsableButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.RightPanelHeaderModule.FilterUsableButton });
    this.mSetSmallSizeButton.bindTooltip({ contentType: 'msu-generic', modId: "mod_stronghold", elementId: "Screen.Module.Stash.SmallIcons"});
};

StrongholdScreenStashModule.prototype.unbindTooltips = function ()
{
    this.mAssets.unbindTooltips();
	this.mStashSlotSizeContainer.unbindTooltip();
    this.mLeaveButton.unbindTooltip();

	this.mSortInventoryButton.unbindTooltip();
	this.mFilterAllButton.unbindTooltip();
	this.mFilterWeaponsButton.unbindTooltip();
	this.mFilterArmorButton.unbindTooltip();
    this.mFilterMiscButton.unbindTooltip();
    this.mFilterUsableButton.unbindTooltip();
};


StrongholdScreenStashModule.prototype.destroyDIV = function ()
{
    this.mStashSlots = null;
    this.mShopSlots = null;

    this.mStashSlotSizeLabel.remove();
    this.mStashSlotSizeLabel = null;
    this.mStashSlotSizeContainer.empty();
    this.mStashSlotSizeContainer.remove();
    this.mStashSlotSizeContainer = null;

    this.mStashListContainer.destroyList();
    this.mStashListScrollContainer = null;
    this.mStashListContainer = null;

    this.mShopListContainer.destroyList();
    this.mShopListScrollContainer = null;
    this.mShopListContainer = null;

    this.mAssets.destroyDIV();
	//this.mAssets = null;
};

StrongholdScreenStashModule.prototype.loadFromData = function (_data)
{
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;

    if(this.mModuleData === undefined || this.mModuleData === null || !(typeof(this.mModuleData) === 'object'))
	{
        return;
    }
    if ('StashSpaceUsed' in this.mModuleData)
	{
	    this.mStashSpaceUsed = this.mModuleData.StashSpaceUsed;
	}

	if ('StashSpaceMax' in this.mModuleData)
	{
	    this.mStashSpaceMax = this.mModuleData.StashSpaceMax;
	}
	if ('TownStashSpaceUsed' in this.mModuleData)
	{
	    this.mTownStashSpaceUsed = this.mModuleData.TownStashSpaceUsed;
	}

	if ('TownStashSpaceMax' in this.mModuleData)
	{
	    this.mTownStashSpaceMax = this.mModuleData.TownStashSpaceMax;
	}

	if('Stash' in this.mModuleData && this.mModuleData.Stash !== null)
	{
		this.updateStashList(this.mModuleData.Stash);
	}

	if('Shop' in this.mModuleData && this.mModuleData.Shop !== null)
	{
		this.updateShopList(this.mModuleData.Shop);
	}
	this.updateStashFreeSlotsLabel();
};

StrongholdScreenStashModule.prototype.updateShopList = function (_data)
{
    if(this.mShopList === null || !jQuery.isArray(this.mShopList) || this.mShopList.length === 0)
    {
		this.loadShopData(_data);
        return;
    }

	// create more slots?
	if(_data.length > this.mShopSlots.length)
	{
		this.createItemSlots(WorldTownScreenShop.ItemOwner.Shop, _data.length - this.mShopSlots.length, this.mShopSlots, this.mShopListScrollContainer);
	}

    // check shop for changes
	var maxLength = this.mShopList.length >= _data.length ? this.mShopList.length : _data.length;

    for(var i = 0; i < maxLength; ++i)
    {
        var oldItem = this.mShopList[i];
        var newItem = _data[i];

        // item added to shop slot
        if(i >= this.mShopList.length || (oldItem === null && newItem !== null))
        {
			//console.info('SHOP: Item inserted (Index: ' + i + ')');
			this.updateSlotItem(WorldTownScreenShop.ItemOwner.Shop, this.mShopSlots, newItem, i, WorldTownScreenShop.ItemFlag.Inserted);
        }

        // item removed from shop slot
        else if(i >= _data.length || (oldItem !== null && newItem === null))
        {
			//console.info('SHOP: Item removed (Index: ' + i + ')');
			this.updateSlotItem(WorldTownScreenShop.ItemOwner.Shop, this.mShopSlots, oldItem, i, WorldTownScreenShop.ItemFlag.Removed);
        }

        // item might have changed within shop slot
        else
        {
            if((oldItem !== null && newItem !== null) && ('id' in oldItem && 'id' in newItem))
            {
				if(oldItem.id !== newItem.id)
				{
					//console.info('SHOP: Item updated (Index: ' + i + ')');
					this.updateSlotItem(WorldTownScreenShop.ItemOwner.Shop, this.mShopSlots, newItem, i, WorldTownScreenShop.ItemFlag.Updated);
				}
				else
				{
					 this.updateItemPriceLabel(this.mShopSlots[i], newItem, false);
				}
            }
        }
    }

	// update list
	this.mShopList = _data;
};

StrongholdScreenStashModule.prototype.updateSlotItem = function (_owner, _itemArray, _item, _index, _flag)
{
    var slot = this.querySlotByIndex(_itemArray, _index);
    if(slot === null)
    {
        console.error('ERROR: Failed to update slot item: Reason: Invalid slot index: ' + _index);
        return;
    }

    switch(_flag)
    {
        case WorldTownScreenShop.ItemFlag.Inserted:
        case WorldTownScreenShop.ItemFlag.Updated:
        {
            this.removeItemFromSlot(slot);
            this.assignItemToSlot(_owner, slot, _item);
            this.updateItemPriceLabel(slot, _item, _owner === WorldTownScreenShop.ItemOwner.Stash);
			break;
        }
        case WorldTownScreenShop.ItemFlag.Removed:
        {
            this.removeItemFromSlot(slot);
			break;
        }
    }
};

StrongholdScreenStashModule.prototype.updateStashFreeSlotsLabel = function ()
{
    var statistics = this.getStashStatistics();
    this.mStashSlotSizeLabel.html('' + this.mModuleData.StashSpaceUsed + '/' + this.mModuleData.StashSpaceMax);
    this.mTownStashSlotSizeLabel.html('' + this.mTownStashSpaceUsed + '/' + this.mTownStashSpaceMax);

    if(this.mModuleData.StashSpaceUsed >= this.mModuleData.StashSpaceMax)
	     this.mStashSlotSizeLabel.removeClass('font-color-value').addClass('font-color-negative-value');
    else
        this.mStashSlotSizeLabel.removeClass('font-color-negative-value').addClass('font-color-value');

    if (this.mModuleData.TownStashSpaceUsed >= this.mModuleData.TownStashSpaceMax)
	     this.mTownStashSlotSizeLabel.removeClass('font-color-value').addClass('font-color-negative-value');
    else
        this.mTownStashSlotSizeLabel.removeClass('font-color-negative-value').addClass('font-color-value');
};


StrongholdScreenStashModule.prototype.setupEventHandler = function ()
{
};

StrongholdScreenStashModule.prototype.swapItem = function (_sourceItemIdx, _sourceItemOwner, _targetItemIdx, _targetItemOwner)
{
    var self = this;
    this.notifyBackendSwapItem(_sourceItemIdx, _sourceItemOwner, _targetItemIdx, _targetItemOwner, function (data){
    	// error?
    	if (data.Result != 0)
    	{
    	    if (data.Result == ErrorCode.NotEnoughMoney)
    	    {
    	        self.mAssets.mMoneyAsset.shakeLeftRight();
    	    }
    	    else if (data.Result == ErrorCode.NotEnoughStashSpace)
    	    {
    	        self.mStashSlotSizeContainer.shakeLeftRight();
    	    }
    	    else
    	    {
    	        console.error("Failed to swap item. Reason: Unknown");
    	    }

    	    return;
    	}
    });

};

StrongholdScreenStashModule.prototype.updateItemPriceLabel = function (_slot, _item, _positiveColor)
{
    return;
};
StrongholdScreenStashModule.prototype.updateItemPriceLabels = function (_itemArray, _items, _allPositiveColors)
{
    return;
};

StrongholdScreenStashModule.prototype.hasEnoughMoneyToBuy = function (_itemIdx)
{
    return true;
};


StrongholdScreenStashModule.prototype.createItemSlot = function (_owner, _index, _parentDiv, _screenDiv)
{
    var self = this;
    var result = WorldTownScreenShopDialogModule.prototype.createItemSlot.call(this, _owner, _index, _parentDiv, _screenDiv);
    result.off("mousedown");
    result.assignListItemRightClick(function (_item, _event)
	{
        var data = _item.data('item');

        var isEmpty = (data !== null && 'isEmpty' in data) ? data.isEmpty : true;
        var owner = (data !== null && 'owner' in data) ? data.owner : null;
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

StrongholdScreenStashModule.prototype.showConfirmReforgeDialog = function(_sourceItemIdx, _itemName, _price, _affordable){
     var self = this;
     this.createPopup('Confirm reforging', null, null, "confirm-reforge-dialog");
     this.mPopupDialog.addPopupDialogContent(this.createConfirmReforgeContent(this.mPopupDialog, _itemName, _price, _affordable));
     if(_affordable == true){
     	this.mPopupDialog.addPopupDialogOkButton(function (_dialog)
     	{
     	   self.reforgeNamedItemAfterClick(_sourceItemIdx);
     	   self.destroyPopup();
     	});
     	this.mPopupDialog.addPopupDialogCancelButton(function (_dialog)
     	{
     	   self.destroyPopup();
     	});
     }
     else{
     	this.mPopupDialog.addPopupDialogOkButton(function (_dialog)
     	{
     	   self.destroyPopup();
     	});
     }
}

StrongholdScreenStashModule.prototype.createConfirmReforgeContent = function (_dialog, _itemName, _price, _affordable)
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

StrongholdScreenStashModule.prototype.reforgeNamedItemAfterClick = function(_sourceItemIdx)
{
    var self = this;
   	SQ.call(this.mSQHandle, 'onReforgeNamedItem', _sourceItemIdx, function (data){});
};

StrongholdScreenStashModule.prototype.checkIfReforgeIsValid = function (_sourceItemIdx)
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


var copyFunctionList = [
	"loadStashData",
	"loadShopData",
	"assignItems",
	"destroyItemSlots",
	"removeItemFromSlot",
	"assignItemToSlot",
	"querySlotByIndex",
	"createItemSlots",
	"clearItemSlots",
	"repairItem",
	"updateStashList",
	"updateShopList",
	"updateSlotItem",
	"isStashSpaceLeft",
	"getStashStatistics",
	"notifyBackendSwapItem",
	"notifyBackendSortButtonClicked",
	"notifyBackendFilterAllButtonClicked",
	"notifyBackendFilterWeaponsButtonClicked",
	"notifyBackendFilterArmorButtonClicked",
	"notifyBackendFilterMiscButtonClicked",
	"notifyBackendFilterUsableButtonClicked",
]

for (var x = 0; x < copyFunctionList.length; x++)
{
	if (!(copyFunctionList[x] in StrongholdScreenStashModule.prototype))
	{
		Object.defineProperty(StrongholdScreenStashModule.prototype, copyFunctionList[x], {
		value: WorldTownScreenShopDialogModule.prototype[copyFunctionList[x]],
		enumerable: false,
		writable: true });
	}
}
