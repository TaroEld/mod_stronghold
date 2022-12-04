"use strict";
var StrongholdScreenStashDialogModule = function(_parent)
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

StrongholdScreenStashDialogModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenStashDialogModule.prototype, 'constructor', {
	value: StrongholdScreenStashDialogModule,
	enumerable: false,
	writable: true });

StrongholdScreenStashDialogModule.prototype.createDIV = function (_parentDiv)
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
		self.mFilterAllButton.addClass('is-active');
		self.mFilterWeaponsButton.removeClass('is-active');
		self.mFilterArmorButton.removeClass('is-active');
        self.mFilterMiscButton.removeClass('is-active');
        self.mFilterUsableButton.removeClass('is-active');
		self.notifyBackendFilterAllButtonClicked();
    }, '', 3);
	self.mFilterAllButton.addClass('is-active');

	var layout = $('<div class="l-button is-weapons-filter"/>');
    buttonContainer.append(layout);
    this.mFilterWeaponsButton = layout.createImageButton(Path.GFX + Asset.BUTTON_WEAPONS_FILTER, function()
	{
		self.mFilterAllButton.removeClass('is-active');
		self.mFilterWeaponsButton.addClass('is-active');
		self.mFilterArmorButton.removeClass('is-active');
        self.mFilterMiscButton.removeClass('is-active');
        self.mFilterUsableButton.removeClass('is-active');
		self.notifyBackendFilterWeaponsButtonClicked();
    }, '', 3);

	var layout = $('<div class="l-button is-armor-filter"/>');
    buttonContainer.append(layout);
    this.mFilterArmorButton = layout.createImageButton(Path.GFX + Asset.BUTTON_ARMOR_FILTER, function()
	{
		self.mFilterAllButton.removeClass('is-active');
		self.mFilterWeaponsButton.removeClass('is-active');
		self.mFilterArmorButton.addClass('is-active');
        self.mFilterMiscButton.removeClass('is-active');
        self.mFilterUsableButton.removeClass('is-active');
		self.notifyBackendFilterArmorButtonClicked();
    }, '', 3);

	var layout = $('<div class="l-button is-misc-filter"/>');
    buttonContainer.append(layout);
    this.mFilterMiscButton = layout.createImageButton(Path.GFX + Asset.BUTTON_MISC_FILTER, function()
	{
		self.mFilterAllButton.removeClass('is-active');
		self.mFilterWeaponsButton.removeClass('is-active');
		self.mFilterArmorButton.removeClass('is-active');
        self.mFilterMiscButton.addClass('is-active');
        self.mFilterUsableButton.removeClass('is-active');
        self.notifyBackendFilterMiscButtonClicked();
    }, '', 3);

    var layout = $('<div class="l-button is-usable-filter"/>');
    buttonContainer.append(layout);
    this.mFilterUsableButton = layout.createImageButton(Path.GFX + Asset.BUTTON_USABLE_FILTER, function ()
    {
        self.mFilterAllButton.removeClass('is-active');
        self.mFilterWeaponsButton.removeClass('is-active');
        self.mFilterArmorButton.removeClass('is-active');
        self.mFilterMiscButton.removeClass('is-active');
        self.mFilterUsableButton.addClass('is-active');
        self.notifyBackendFilterUsableButtonClicked();
    }, '', 3);

    this.mStashSlotSizeContainer = $('<div class="slot-count-container"/>');
    buttonContainer.append(this.mStashSlotSizeContainer);
    var slotSizeImage = $('<img/>');
    slotSizeImage.attr('src', Path.GFX + Asset.ICON_BAG);
    this.mStashSlotSizeContainer.append(slotSizeImage);
    this.mStashSlotSizeLabel = $('<div class="label text-font-small font-bold font-color-value"/>');
    this.mStashSlotSizeContainer.append(this.mStashSlotSizeLabel);

    this.mTownStashSlotSizeContainer = $('<div class="slot-count-container town"/>');
    buttonContainer.append(this.mTownStashSlotSizeContainer);
    var slotSizeImage = $('<img/>');
    slotSizeImage.attr('src', Path.GFX + Asset.ICON_BAG);
    this.mTownStashSlotSizeContainer.append(slotSizeImage);
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
StrongholdScreenStashDialogModule.prototype.destroyDIV = function ()
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

StrongholdScreenStashDialogModule.prototype.loadFromData = function (_data)
{
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
	    this.mTownStashSpaceUsed = this.mModuleData.StashSpaceUsed;
	}

	if ('TownStashSpaceMax' in this.mModuleData)
	{
	    this.mTownStashSpaceMax = this.mModuleData.StashSpaceMax;
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

WorldTownScreenShopDialogModule.prototype.updateStashFreeSlotsLabel = function ()
{
    var statistics = this.getStashStatistics();
    this.mStashSlotSizeLabel.html('' + this.mModuleData.StashSpaceUsed + '/' + this.mModuleData.StashSpaceMax);
    this.mTownStashSlotSizeLabel.html('' + this.mModuleData.TownStashSpaceUsed + '/' + this.mModuleData.TownStashSpaceMax);

    if(this.mModuleData.StashSpaceUsed >= this.mModuleData.StashSpaceMax)
	     this.mStashSlotSizeLabel.removeClass('font-color-value').addClass('font-color-negative-value');
    else
        this.mStashSlotSizeLabel.removeClass('font-color-negative-value').addClass('font-color-value');

    if (this.mModuleData.TownStashSpaceUsed >= this.mModuleData.TownStashSpaceMax)
	     this.mTownStashSlotSizeLabel.removeClass('font-color-value').addClass('font-color-negative-value');
    else
        this.mTownStashSlotSizeLabel.removeClass('font-color-negative-value').addClass('font-color-value');
};


StrongholdScreenStashDialogModule.prototype.setupEventHandler = function ()
{
    var self = this;
    var dropHandler = function (ev, dd)
	{
        var drag = $(dd.drag);
        var drop = $(dd.drop);

        // do the swapping
        var sourceData = drag.data('item') || {};
        var targetData = drop.data('item') || {};

        var sourceOwner = (sourceData !== null && 'owner' in sourceData) ? sourceData.owner : null;
        var targetOwner = (targetData !== null && 'owner' in targetData) ? targetData.owner : null;

        if(sourceOwner === null || targetOwner === null)
        {
            console.error('Failed to drop item. Owner are invalid.');
            return;
        }

        // we don't allow swapping within the shop container
        if(sourceOwner === WorldTownScreenShop.ItemOwner.Shop && targetOwner === WorldTownScreenShop.ItemOwner.Shop)
        {
            //console.error('Failed to swap item within shop container. Not allowed.');
            return;
        }

        var sourceItemIdx = (sourceData !== null && 'index' in sourceData) ? sourceData.index : null;
        var targetItemIdx = (targetData !== null && 'index' in targetData) ? targetData.index : null;

        if(sourceItemIdx === null)
        {
            console.error('Failed to drop item. Source idx is invalid.');
            return;
        }

        self.swapItem(sourceItemIdx, sourceOwner, targetItemIdx, targetOwner);

        // workaround if the source container was removed before we got here
        if(drag.parent().length === 0)
        {
            $(dd.proxy).remove();
        }
        else
        {
            drag.removeClass('is-dragged');
        }
    };

    // create drop handler for the stash & shop container
    $.drop({ mode: 'middle' });

    this.mStashListContainer.data('item', { owner: WorldTownScreenShop.ItemOwner.Stash });
    //this.mStashListContainer.drop('start', dropStartHandler);
    this.mStashListContainer.drop(dropHandler);
    //this.mStashListContainer.drop('end', dropEndHandler);

    this.mShopListContainer.data('item', { owner: WorldTownScreenShop.ItemOwner.Shop });
    //this.mShopListContainer.drop('start', dropStartHandler);
    this.mShopListContainer.drop(dropHandler);
    //this.mShopListContainer.drop('end', dropEndHandler);
};

StrongholdScreenStashDialogModule.prototype.swapItem = function (_sourceItemIdx, _sourceItemOwner, _targetItemIdx, _targetItemOwner)
{
    var self = this;
    this.notifyBackendSwapItem(_sourceItemIdx, _sourceItemOwner, _targetItemIdx, _targetItemOwner, function (data)
    {
        if (data === undefined || data == null || typeof (data) !== 'object')
        {
            console.error("ERROR: Failed to swap item. Reason: Invalid data result.");
            return;
        }

        // error?
        if (data.Result != 0)
        {
            if (data.Result == ErrorCode.NotEnoughStashSpace)
            {
                self.mStashSlotSizeContainer.shakeLeftRight();
            }
            else
            {
                console.error("Failed to swap item. Reason: Unknown");
            }

            return;
        }
        self.updateStashFreeSlotsLabel();
    });
};

StrongholdScreenStashDialogModule.prototype.updateStashes = function (_data)
{
	this.updateStashList(_data.Stash);
	this.updateShopList(_data.Shop);
    return;
};

StrongholdScreenStashDialogModule.prototype.updateItemPriceLabel = function (_slot, _item, _positiveColor)
{
    return;
};
StrongholdScreenStashDialogModule.prototype.updateItemPriceLabels = function (_itemArray, _items, _allPositiveColors)
{
    return;
};
WorldTownScreenShopDialogModule.prototype.hasEnoughMoneyToBuy = function (_itemIdx)
{
    return true;
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
	"createItemSlot",
	"repairItem",
	"updateStashList",
	"updateShopList",
	"updateSlotItem",
	"updateStashFreeSlotsLabel",
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
	Object.defineProperty(StrongholdScreenStashDialogModule.prototype, copyFunctionList[x], {
	value: WorldTownScreenShopDialogModule.prototype[copyFunctionList[x]],
	enumerable: false,
	writable: true });
}

