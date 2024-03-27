"use strict";
var StrongholdScreenRosterModule = function(_parent)
{
    StrongholdScreenModuleTemplate.call(this, _parent);
    this.mID = "RosterModule"
	this.mTitle = "Your Roster"
    this.mRoster = //for assets things
    {
        Brothers              : 0,
        BrothersMax           : 0,
        StrongholdBrothers    : 0,
        StrongholdBrothersMax : 0,
    }


    // for perk tree popup
    this.mPerkTree = null;
    this.mPerkRows = null;

    // stuffs
    this.mSimpleRosterTooltip   = false;
    this.mSelectedBrother =
    {
        Index : 0,
        Tag   : null
    };

    // some shenanigans
    this.mToggledType                  = Stronghold.Roster.ToggleScroll.Type.Stats;
    this.mToggledOrder                 = Stronghold.Roster.ToggleScroll.Order.Ascending;
    this.mDetailsContainer             = null;
    this.mScrollBackgroundContainer    = null;
    this.mDetailsScrollHeaderContainer = null;
    this.mTitleContainer               = null;

    // button bar
    this.mButtonBarContainer           = null;
    this.mStripAllButton               = null;
    this.mRenameButton                 = null;
    this.mDismissButton                = null;
    this.mTooltipButton                = null;
    this.mPlayerBrotherButton          = null;

    this.mPlayerWages = null;
    this.mStrongholdWages = null;
    this.mWageMult = null;

    // stronghold
    this.mStronghold =
    {
        Slots               : null,
        NumActive           : 0,
        NumActiveMax        : 33,
        NumActiveMin        : 0,
        BrothersList        : null,
        ListContainer       : null,
        ListScrollContainer : null,
    };

    // player
    this.mPlayer =
    {
        Slots               : null,
        NumActive           : 0,
        NumActiveMax        : 27,
        NumActiveMin        : 1,
        BrothersList        : null,
        ListContainer       : null,
        ListScrollContainer : null,
    };

    // skills panel
    this.mSkills =
    {
        Container           : null,
        ListContainer       : null,
        ListScrollContainer : null,
        ActiveSkillsRow     : null,
        PassiveSkillsRow    : null,
        StatusEffectsRow    : null,
        PerksRow 			: null,
    };

    // portrait panel
    this.mPortrait =
    {
        Container     : null,
        Image         : null,
        Placeholder   : null,
        NameLabel     : null,
    };

    // stats panel
    this.mStatsContainer  = null;
    this.mStatsRows = {
        Hitpoints: {
            IconPath: Path.GFX + Asset.ICON_HEALTH,
            StyleName: ProgressbarStyleIdentifier.Hitpoints,
            TooltipId: TooltipIdentifier.CharacterStats.Hitpoints,
            Row: null,
            Progressbar: null,
            Talent: null
        },
        Fatigue: {
            IconPath: Path.GFX + Asset.ICON_FATIGUE,
            StyleName: ProgressbarStyleIdentifier.Fatigue,
            TooltipId: TooltipIdentifier.CharacterStats.Fatigue,
            Row: null,
            Progressbar: null,
            Talent: null
        },
        Bravery: {
            IconPath: Path.GFX + Asset.ICON_BRAVERY,
            StyleName: ProgressbarStyleIdentifier.Bravery,
            TooltipId: TooltipIdentifier.CharacterStats.Bravery,
            Row: null,
            Progressbar: null,
            Talent: null
        },
        Initiative: {
            IconPath: Path.GFX + Asset.ICON_INITIATIVE,
            StyleName: ProgressbarStyleIdentifier.Initiative,
            TooltipId: TooltipIdentifier.CharacterStats.Initiative,
            Row: null,
            Progressbar: null,
            Talent: null
        },
        MeleeSkill: {
            IconPath: Path.GFX + Asset.ICON_MELEE_SKILL,
            StyleName: ProgressbarStyleIdentifier.MeleeSkill,
            TooltipId: TooltipIdentifier.CharacterStats.MeleeSkill,
            Row: null,
            Progressbar: null,
            Talent: null
        },
        RangeSkill: {
            IconPath: Path.GFX + Asset.ICON_RANGE_SKILL,
            StyleName: ProgressbarStyleIdentifier.RangeSkill,
            TooltipId: TooltipIdentifier.CharacterStats.RangeSkill,
            Row: null,
            Progressbar: null,
            Talent: null
        },
        MeleeDefense: {
            IconPath: Path.GFX + Asset.ICON_MELEE_DEFENCE,
            StyleName: ProgressbarStyleIdentifier.MeleeDefense,
            TooltipId: TooltipIdentifier.CharacterStats.MeleeDefense,
            Row: null,
            Progressbar: null,
            Talent: null
        },
        RangeDefense: {
            IconPath: Path.GFX + Asset.ICON_RANGE_DEFENCE,
            StyleName: ProgressbarStyleIdentifier.RangeDefense,
            TooltipId: TooltipIdentifier.CharacterStats.RangeDefense,
            Row: null,
            Progressbar: null,
            Talent: null
        },
    };
    this.mItemTypes = {
    	"all" : 0,
    	"weapon" : 1,
    	"armor" : 2,
    	"bag" : 3
    }
};

StrongholdScreenRosterModule.prototype = Object.create(StrongholdScreenModuleTemplate.prototype);
Object.defineProperty(StrongholdScreenRosterModule.prototype, 'constructor', {
    value: StrongholdScreenRosterModule,
    enumerable: false,
    writable: true });

StrongholdScreenRosterModule.prototype.createDIV = function (_parentDiv)
{
    StrongholdScreenModuleTemplate.prototype.createDIV.call(this, _parentDiv);
    var self = this;
    this.mContentContainer.addClass("roster-module");


    // create content
    var content = this.mContentContainer;
    var column = $('<div class="right-column"/>');
    content.append(column);



    //-1 top row
    var row = $('<div class="top-row"/>');
    column.append(row);

    // stronghold roster
    var listContainerLayout = $('<div class="l-list-container"/>');
    row.append(listContainerLayout);
    // the normal way to create the list fails me, so i make a cusom function so i can add the option i want easily
    this.mStronghold.ListContainer = this.createListWithCustomOption(listContainerLayout, {
        delta: 1.24,
        lineDelay: 0,
        lineTimer: 0,
        pageDelay: 0,
        pageTimer: 0,
        bindKeyboard: false,
        smoothScroll: false,
        resizable: false, // to hide the horizontal scroll
        horizontalBar: 'none', // to hide the horizontal scroll
    });
    this.mStronghold.ListScrollContainer = this.mStronghold.ListContainer.findListScrollContainer();
    this.createBrotherSlots(this.mStronghold, Stronghold.Roster.RosterOwner.Stronghold);



    //-2 mid row
    var row = $('<div class="middle-row"/>');
    column.append(row);

    // scroll shenanigans
    this.mDetailsScrollHeaderContainer = $('<div class="is-left"/>');
    row.append(this.mDetailsScrollHeaderContainer);
    this.mDetailsScrollHeaderContainer.click(function()
    {
        self.toggleScrollDiv(true);
    });
    var titleContainer = $('<div class="title-container stronghold-flex-center stronghold-row-background"/>');
    this.mDetailsScrollHeaderContainer.append(titleContainer);
    this.mTitleContainer = Stronghold.getTextSpan()
    titleContainer.append(this.mTitleContainer);
    this.mTitleContainer.html('Stats');

    // buttons bar
    this.mButtonBarContainer = $('<div class="is-right"/>');
    row.append(this.mButtonBarContainer);
    var panelLayout = $('<div class="button-panel"/>');
    this.mButtonBarContainer.append(panelLayout);

    // button 1 - to strip naked a bro
    var layout = $('<div class="l-button is-stripping-all"/>');
    panelLayout.append(layout);
    this.mStripAllButton = layout.createImageButton(Path.GFX + 'ui/buttons/filter_all.png', function ()
    {
        self.transferItemsToStash();
    }, '', 3);
    this.mStripAllButton.bindTooltip({ contentType: 'ui-element', elementId: 'pokebro.strippingnaked' });

    // button 5 - to rename bro
    var layout = $('<div class="l-button is-rename"/>');
    panelLayout.append(layout);
    this.mRenameButton = layout.createImageButton(Path.GFX + 'ui/icons/papers.png', function ()
    {
        self.openRenamePopupDialog(null);
    }, '', 3);
    this.mRenameButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.LeftPanelHeaderModule.ChangeNameAndTitle });

    // button 6 - to dismis bro
    var layout = $('<div class="l-button is-dismiss"/>');
    panelLayout.append(layout);
    this.mDismissButton = layout.createImageButton(Path.GFX + Asset.BUTTON_DISMISS_CHARACTER, function ()
    {
        self.openDismissPopupDialog(null);
    }, '', 3);
    this.mDismissButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.LeftPanelHeaderModule.Dismiss });

    var layout = $('<div class="l-button is-roster-tooltip"/>');
    panelLayout.append(layout);
    this.mTooltipButton = layout.createImageButton(Path.GFX + 'ui/icons/scroll_02.png', function ()
    {
        self.mSimpleRosterTooltip = !self.mSimpleRosterTooltip;
        self.notifyBackendTooltipButtonPressed(self.mSimpleRosterTooltip);
        if(self.mSimpleRosterTooltip === false)
            self.mTooltipButton.changeButtonImage(Path.GFX + 'ui/icons/scroll_02.png');
        else
            self.mTooltipButton.changeButtonImage(Path.GFX + 'ui/icons/scroll_02_sw.png');
    }, '', 3);
    this.mTooltipButton.bindTooltip({ contentType: 'ui-element', elementId: 'pokebro.simplerostertooltip' });


    // last button - assets brother, to display the number of player in roster, also can be pressed to move to inventory screen
    var layout = $('<div class="l-button-brother is-brothers"/>');
    var buttonlayout = $('<div class="l-assets-container"/>');
    var image = $('<img/>');
    image.attr('src', Path.GFX + Asset.ICON_ASSET_BROTHERS);
    buttonlayout.append(image);
    var text = $('<div class="label text-font-small font-bold font-bottom-shadow font-color-assets-positive-value"/>');
    buttonlayout.append(text);
    this.mPlayerBrotherButton = layout.createCustomButton(buttonlayout, function()
    {
        self.notifyBackendBrothersButtonPressed();
    }, '', 2);
    this.mPlayerBrotherButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.Assets.Brothers });
    panelLayout.append(layout);

    var layout = $('<div class="l-button is-wages is-player-wages"/>');
    panelLayout.append(layout);
    layout.bindTooltip({ contentType: 'msu-generic', modId: "mod_stronghold", elementId: "Screen.Module.Roster.PlayerWages"});
    var image = $('<img/>')
    	.attr('src', Path.GFX + Asset.ICON_ASSET_DAILY_MONEY)
    	.appendTo(layout);
    this.mPlayerWages = Stronghold.getTextSpan()
    	.appendTo(layout);

    var layout = $('<div class="l-button is-wages is-stronghold-wages"/>');
    panelLayout.append(layout);
    layout.bindTooltip({ contentType: 'msu-generic', modId: "mod_stronghold", elementId: "Screen.Module.Roster.StrongholdWages"});
    var image = $('<img/>')
    	.attr('src', Path.GFX + Asset.ICON_ASSET_DAILY_MONEY)
    	.appendTo(layout);
    this.mStrongholdWages = Stronghold.getTextSpan()
    	.appendTo(layout);


    //-3 bottom row
    row = $('<div class="bottom-row"/>');
    column.append(row);

    // fancy scroll box for selected player details data
    this.mDetailsContainer = $('<div class="details-container"/>');
    row.append(this.mDetailsContainer);

    // stuffs inside the scroll
    this.mScrollBackgroundContainer = $('<div class="scroll-background-container"/>');
    this.mDetailsContainer.append(this.mScrollBackgroundContainer);
    {
        // create: stats progressbars
        this.mStatsContainer = $('<div class="stats"/>');
        this.mScrollBackgroundContainer.append(this.mStatsContainer);
        this.createRowsDIV(this.mStatsRows, this.mStatsContainer);

        // create: portrait to have a clearer look on your selected bro
        this.mPortrait.Container = $('<div class="portrait"/>').hide();
        this.mScrollBackgroundContainer.append(this.mPortrait.Container);
        {
            var portraitContainer = $('<div class="portrait-container"/>');
            this.mPortrait.Container.append(portraitContainer);

            var portraitImageContainer = $('<div class="l-portrait-image-container"/>');
            portraitContainer.append(portraitImageContainer);

            this.mPortrait.Placeholder = portraitImageContainer.createImage('', function (_image)
            {
                self.mPortrait.Placeholder.centerImageWithinParent(0, 0, 1.0, false);
            }, null, 'opacity-almost-none');

            this.mPortrait.Image = portraitImageContainer.createImage('', function (_image)
            {
                self.mPortrait.Image.centerImageWithinParent(0, 0, 1.0, false);
                self.mPortrait.Image.removeClass('opacity-almost-none');
                self.mPortrait.Placeholder.addClass('opacity-almost-none');
                self.mPortrait.Placeholder.attr('src', self.mPortrait.Image.attr('src'));
            }, null, '');

            var nameContainer = $('<div class="name-container stronghold-flex-center stronghold-row-background"/>');
            this.mPortrait.Container.append(nameContainer);

            this.mPortrait.NameLabel = Stronghold.getTextDiv();
            nameContainer.append(this.mPortrait.NameLabel);

            nameContainer.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.LeftPanelHeaderModule.ChangeNameAndTitle });
            nameContainer.click(function ()
            {
                self.openRenamePopupDialog(null);
            });
        }
    }

    // stuffs outside the scroll
    this.mSkills.Container = $('<div class="l-list-container"/>').hide();
    this.mDetailsContainer.append(this.mSkills.Container);
    {
        this.mSkills.ListContainer = this.mSkills.Container.createList(100, null, true);
        this.mSkills.ListScrollContainer = this.mSkills.ListContainer.findListScrollContainer();

        // create: skills rows
        this.mSkills.ActiveSkillsRow = $('<div class="skills-row"/>');
        this.mSkills.ListScrollContainer.append(this.mSkills.ActiveSkillsRow);
        this.mSkills.PassiveSkillsRow = $('<div class="skills-row"/>');
        this.mSkills.ListScrollContainer.append(this.mSkills.PassiveSkillsRow);
        this.mSkills.StatusEffectsRow = $('<div class="skills-row"/>');
        this.mSkills.ListScrollContainer.append(this.mSkills.StatusEffectsRow);
        this.mSkills.PerksRow = $('<div class="skills-row"/>');
        this.mSkills.ListScrollContainer.append(this.mSkills.PerksRow);
    }



    // player roster
    var detailFrame = $('<div class="background-frame-container"/>');
    row.append(detailFrame);
    this.mPlayer.ListScrollContainer = $('<div class="l-list-container"/>');
    detailFrame.append(this.mPlayer.ListScrollContainer);
    this.createBrotherSlots(this.mPlayer, Stronghold.Roster.RosterOwner.Player);

};

StrongholdScreenRosterModule.prototype.createListWithCustomOption = function(_target, _options, _classes, _withoutFrame)
{
    var result = $('<div class="ui-control list has-frame"/>');
    if (_withoutFrame !== undefined && _withoutFrame === true)
    {
        result.removeClass('has-frame');
    }

    if (_classes !== undefined && _classes !== null && typeof(_classes) === 'string')
    {
        result.addClass(_classes);
    }

    var scrollContainer = $('<div class="scroll-container"/>');
    result.append(scrollContainer);

    _target.append(result);

    if (_options.delta === null || _options.delta === undefined)
    {
        _options.delta = 8;
    }

    // NOTE: create scrollbar (must be after the list was appended to the DOM!)
    result.aciScrollBar(_options);
    return result;
};

StrongholdScreenRosterModule.prototype.loadFromData = function ()
{

	// // stronghold
	// this.mStronghold =
	// {
	//     Slots               : null,
	//     NumActive           : 0,
	//     NumActiveMax        : 33,
	//     NumActiveMin        : 0,
	//     BrothersList        : null,
	//     ListContainer       : null,
	//     ListScrollContainer : null,
	// };

	// // player
	// this.mPlayer =
	// {
	//     Slots               : null,
	//     NumActive           : 0,
	//     NumActiveMax        : 27,
	//     NumActiveMin        : 1,
	//     BrothersList        : null,
	//     ListContainer       : null,
	//     ListScrollContainer : null,
	// };
	if (!StrongholdScreenModuleTemplate.prototype.loadFromData.call(this))
		return;
	this.mStronghold.NumActive = this.mData.mRosterAsset;
    this.mStronghold.NumActiveMax = this.mData.TownAssets.mRosterAssetMax;
    this.mStronghold.BrothersList = this.mModuleData.TownRoster;
    this.onBrothersListLoaded(this.mStronghold, Stronghold.Roster.RosterOwner.Stronghold);
    this.updateBaseSlots(this.mStronghold, Stronghold.Roster.RosterOwner.Stronghold);

    this.mPlayer.NumActive = this.mData.mBrothersAsset;
    this.mPlayer.NumActiveMax = this.mData.mBrothersAssetMax;
    this.mPlayer.BrothersList = this.mModuleData.PlayerRoster;
    this.onBrothersListLoaded(this.mPlayer, Stronghold.Roster.RosterOwner.Player);
    this.updateBaseSlots(this.mPlayer, Stronghold.Roster.RosterOwner.Player);
    this.updateWages();
    for (var i = 0; i < this.mPlayer.BrothersList.length; i++) {
    	if (this.mPlayer.BrothersList[i] !== undefined && this.mPlayer.BrothersList[i] !== null)
    	{
    		this.setBrotherSelected(i, Stronghold.Roster.RosterOwner.Player, true);
    		return;
    	}
    }
};

StrongholdScreenRosterModule.prototype.sumWages = function (_roster, _wageMult)
{
	var total = 0;
	$.each(_roster, function(_idx, _bro){
		if (_bro == null) return;
		total += _bro.character.dailyMoneyCost * _wageMult;
	})
	return Math.round(total);
}

StrongholdScreenRosterModule.prototype.updateWages = function (_roster)
{
	this.mStrongholdWages.text(this.sumWages(this.mStronghold.BrothersList, this.mModuleData.WageMult));
	this.mPlayerWages.text(this.sumWages(this.mPlayer.BrothersList, 1.0));
}

StrongholdScreenRosterModule.prototype.updateBaseSlots = function (_parent , _tag)
{
	var slots = _parent.Slots;
	while (slots.length > _parent.NumActiveMax)
	{
		slots.pop().remove();
	}
	while (slots.length < _parent.NumActiveMax)
	{
		this.createBrotherSlot(_parent , _tag);
	}
}

StrongholdScreenRosterModule.prototype.toggleScrollDiv = function(_withSlideAnimation)
{
	this.mToggledType++;
	if (this.mToggledType > Stronghold.Roster.ToggleScroll.Max)
		this.mToggledType = Stronghold.Roster.ToggleScroll.Min
	this.updateDetailsPanel(null);
};

//- Popup Dialog stuffs
StrongholdScreenRosterModule.prototype.openRenamePopupDialog = function (_brotherId)
{
    var self = this;
    var data =
    {
        Index   : null,
        Tag     : null,
        Brother : null,
    };

    if (_brotherId === null || _brotherId === undefined)
    {
        data.Index = this.mSelectedBrother.Index;
        data.Tag = this.mSelectedBrother.Tag;
        data.Brother = this.getBrotherByIndex(data.Index, data.Tag);
        _brotherId = data.Brother[CharacterScreenIdentifier.Entity.Id];
    }
    else
    {
        data = this.getBrotherByID(_brotherId);
    }

    if (data.Index === null || data.Tag == null)
        return;

    this.createPopup('Change Name & Title', null, null, 'change-name-and-title-popup');

    this.mPopupDialog.addPopupDialogOkButton(function (_dialog)
    {
        self.updateNameAndTitle(_dialog, _brotherId, data.Tag);
        self.destroyPopup();
    });

    this.mPopupDialog.addPopupDialogCancelButton(function (_dialog)
    {
        self.destroyPopup();
    });

    this.mPopupDialog.addPopupDialogContent(this.createChangeNameAndTitleDialogContent(this.mPopupDialog, data.Brother));

    // focus!
    var inputFields = this.mPopupDialog.findPopupDialogContentContainer().find('input');
    $(inputFields[0]).focus();
};
StrongholdScreenRosterModule.prototype.createChangeNameAndTitleDialogContent = function (_dialog, _brother)
{
    var data = _brother;
    var selectedBrother = CharacterScreenIdentifier.Entity.Character.Key in data ? data[CharacterScreenIdentifier.Entity.Character.Key] : null;
    if (selectedBrother === null)
    {
        console.error('Failed to create dialog content. Reason: No brother selected.');
        return null;
    }

    var result = $('<div class="change-name-and-title-container"/>');

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

    if(CharacterScreenIdentifier.Entity.Character.Name in selectedBrother)
        inputField.setInputText(selectedBrother[CharacterScreenIdentifier.Entity.Character.Name]);

    // create & set title
    row = $('<div class="row"/>');
    result.append(row);
    label = $('<div class="label text-font-normal font-color-label font-bottom-shadow">Title</div>');
    row.append(label);

    inputLayout = $('<div class="l-input"/>');
    row.append(inputLayout);
    inputField = inputLayout.createInput('', Constants.Game.MIN_BROTHER_TITLE_LENGTH, Constants.Game.MAX_BROTHER_TITLE_LENGTH, 2, null, 'title-font-big font-bold font-color-brother-name', function (_input)
    {
        var button = _dialog.findPopupDialogOkButton();
        if(button.isEnabled())
            button.click();
    });

    if(CharacterScreenIdentifier.Entity.Character.Title in selectedBrother)
        inputField.setInputText(selectedBrother[CharacterScreenIdentifier.Entity.Character.Title]);

    return result;
};
StrongholdScreenRosterModule.prototype.openDismissPopupDialog = function (_brotherId)
{
    var self = this;
    var data =
    {
        Index   : null,
        Tag     : null,
        Brother : null,
    };

    if (_brotherId === null || _brotherId === undefined)
    {
        data.Index = this.mSelectedBrother.Index;
        data.Tag = this.mSelectedBrother.Tag;
        data.Brother = this.getBrotherByIndex(data.Index, data.Tag);
        _brotherId = data.Brother[CharacterScreenIdentifier.Entity.Id];
    }
    else
    {
        data = this.getBrotherByID(_brotherId);
    }

    if (data.Index === null || data.Tag == null)
        return;

    if (data.Brother[CharacterScreenIdentifier.Entity.Character.Key][CharacterScreenIdentifier.Entity.Character.IsPlayerCharacter] === true)
        return;

    this.mPayDismissalWage = false;
    this.createPopup('Dismiss', null, null, 'dismiss-popup');

    this.mPopupDialog.addPopupDialogOkButton(function (_dialog)
    {
        self.notifyBackendDismissCharacter( self.mPopupDialog.data("PayDismissalWage"), _brotherId, data.Tag);
        self.destroyPopup();
    });

    this.mPopupDialog.addPopupDialogCancelButton(function (_dialog)
    {
        self.destroyPopup();
    });

    this.mPopupDialog.addPopupDialogContent(this.createDismissDialogContent(this.mPopupDialog, data.Brother));
};
StrongholdScreenRosterModule.prototype.createDismissDialogContent = function (_dialog, _brother)
{
    var self = this;
    var data = _brother;
    var selectedBrother = CharacterScreenIdentifier.Entity.Character.Key in data ? data[CharacterScreenIdentifier.Entity.Character.Key] : null;
    if (selectedBrother === null)
    {
        console.error('Failed to create dialog content. Reason: No brother selected.');
        return null;
    }

    var result = $('<div class="dismiss-character-container"/>');
    var titleLabel;

    if (selectedBrother['dailyMoneyCost'] == 0)
        titleLabel = $('<div class="title-label title-font-normal font-bold font-color-title">Really free ' + selectedBrother[CharacterScreenIdentifier.Entity.Character.Name] + '?</div>');
    else
        titleLabel = $('<div class="title-label title-font-normal font-bold font-color-title">Really dismiss ' + selectedBrother[CharacterScreenIdentifier.Entity.Character.Name] + '?</div>');

    result.append(titleLabel);

    var textLabel = $('<div class="label text-font-medium font-color-description font-style-normal">' + selectedBrother[CharacterScreenIdentifier.Entity.Character.Name] + ' will permanently leave you and place his <br/>current equipment in the stash.</div>');
    result.append(textLabel);

    // ---

    var retirementPackage = $('<div class="retirement-package"/>');
    result.append(retirementPackage);

    var checkbox = $('<input type="checkbox" class="compensation-checkbox" id="compensation" name="display"/>');
    retirementPackage.append(checkbox);

    var checkboxLabel;

    if (selectedBrother['dailyMoneyCost'] == 0)
        checkboxLabel = $('<label class="blub text-font-medium font-color-subtitle font-style-normal" for="compensation">Pay <img src="' + Path.GFX + Asset.ICON_MONEY_SMALL + '"/>' + (Math.max(1, selectedBrother['daysWithCompany']) * 10) + ' Reparations</label>');
    else
        checkboxLabel = $('<label class="blub text-font-medium font-color-subtitle font-style-normal" for="compensation">Pay <img src="' + Path.GFX + Asset.ICON_MONEY_SMALL + '"/>' + (Math.max(1, selectedBrother['daysWithCompany']) * 10) + ' Compensation</label>');

    retirementPackage.append(checkboxLabel);

    checkboxLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.DismissPopupDialog.Compensation });

    checkbox.iCheck({
        checkboxClass: 'icheckbox_flat-orange',
        radioClass: 'iradio_flat-orange',
        increaseArea: '0%'
    });

    _dialog.data("PayDismissalWage", false);
    checkbox.on('ifChecked ifUnchecked', null, this, function (_event)
    {
        _dialog.data("PayDismissalWage", checkbox.prop('checked') === true);
    });

    return result;
};
StrongholdScreenRosterModule.prototype.openTransferConfirmationPopupDialog = function (_data)
{
    var self = this;
    this.createPopup('Warning', null, null, 'dismiss-popup');

    this.mPopupDialog.addPopupDialogOkButton(function (_dialog)
    {
        self.notifyBackendTransferItems();
        self.destroyPopup();
    });

    this.mPopupDialog.addPopupDialogCancelButton(function (_dialog)
    {
        self.destroyPopup();
    });

    this.mPopupDialog.addPopupDialogContent(this.createTransferConfirmationDialogContent(this.mPopupDialog, _data));
};
StrongholdScreenRosterModule.prototype.createTransferConfirmationDialogContent = function (_dialog, _data)
{
    var self = this;
    var difference = _data['NumItems'] - _data['NumEmptySlots'];

    var result = $('<div class="dismiss-character-container"/>');
    var titleLabel = $('<div class="title-label title-font-normal font-bold font-color-title">Insufficient Stash Slot</div>');

    result.append(titleLabel);

    var textLabel = $('<div class="label text-font-medium font-color-description font-style-normal">Your stash needs to free ' + difference + ' slot(s) or <br/>any excess will be discarded and lost forever.</div>');
    result.append(textLabel);

    return result;
};

//- Progress bars bah bah bah
StrongholdScreenRosterModule.prototype.createRowsDIV = function(_definitions, _parentDiv)
{
    $.each(_definitions, function (_key, _value)
    {
        _value.Row = $('<div class="stats-row"/>');
        _parentDiv.append(_value.Row);
        var leftStatsRowLayout = $('<div class="l-stats-row"/>');
        _value.Row.append(leftStatsRowLayout);

        var statsRowIconLayout = $('<div class="l-stats-row-icon-column"/>');
        leftStatsRowLayout.append(statsRowIconLayout);
        var statsRowIcon = $('<img/>');
        statsRowIcon.attr('src', _value.IconPath);
        statsRowIconLayout.append(statsRowIcon);

        var statsRowProgressbarLayout = $('<div class="l-stats-row-progressbar-column"/>');
        leftStatsRowLayout.append(statsRowProgressbarLayout);
        var statsRowProgressbarContainer = $('<div class="stats-progressbar-container"/>');
        statsRowProgressbarLayout.append(statsRowProgressbarContainer);

        _value.Progressbar = statsRowProgressbarContainer.createProgressbar(true, _value.StyleName);

        _value.Talent = $('<img class="talent"/>');
        statsRowIconLayout.append(_value.Talent);
        _value.Row.bindTooltip({ contentType: 'ui-element', elementId: _value.TooltipId });
    });
};
StrongholdScreenRosterModule.prototype.destroyRowsDIV = function(_definitions)
{
    $.each(_definitions, function (_key, _value)
    {
        _value.Progressbar.empty();
        _value.Progressbar.remove();
        _value.Progressbar = null;

        _value.Row.empty();
        _value.Row.remove();
        _value.Row = null;
    });
};
StrongholdScreenRosterModule.prototype.setProgressbarValue = function (_progressbarDiv, _data, _valueKey, _valueMaxKey, _labelKey)
{
    if (_valueKey in _data && _data[_valueKey] !== null && _valueMaxKey in _data && _data[_valueMaxKey] !== null)
    {
        _progressbarDiv.changeProgressbarNormalWidth(_data[_valueKey], _data[_valueMaxKey]);

        if (_labelKey in _data && _data[_labelKey] !== null)
        {
            _progressbarDiv.changeProgressbarLabel(_data[_labelKey]);
        }
        else
        {
            switch(_valueKey)
            {
                //case ProgressbarValueIdentifier.ArmorHead:
                //case ProgressbarValueIdentifier.ArmorBody:
                case ProgressbarValueIdentifier.Hitpoints:
                case ProgressbarValueIdentifier.Fatigue:
                {
                    _progressbarDiv.changeProgressbarLabel('' + _data[_valueKey] + ' / ' + _data[_valueMaxKey] + '');
                } break;
                default:
                {
                    _progressbarDiv.changeProgressbarLabel('' + _data[_valueKey]);
                }
            }
        }
    }
};
StrongholdScreenRosterModule.prototype.setTalentValue = function (_something, _data)
{
    _something.Talent.attr('src', Path.GFX + 'ui/icons/talent_' + _data + '.png');
    _something.Talent.css({ 'width': '3.6rem', 'height': '1.8rem' });
}
//------------------------------------



StrongholdScreenRosterModule.prototype.getBrotherPerkPointsSpent = function (_brother)
{
    if (_brother === null || !(CharacterScreenIdentifier.Entity.Character.Key in _brother))
    {
        return 0;
    }

    var character = _brother[CharacterScreenIdentifier.Entity.Character.Key];
    if (character === null)
    {
        return 0;
    }

    if (CharacterScreenIdentifier.Entity.Character.PerkPoints in character)
    {
        var perkPoints = character[CharacterScreenIdentifier.Entity.Character.PerkPointsSpent];
        if (perkPoints !== null && typeof (perkPoints) == 'number')
        {
            return perkPoints;
        }
    }

    return 0;
};
StrongholdScreenRosterModule.prototype.getNumBrothers = function (_brothersList)
{
    var num = 0;

    for (var i = 0; i != _brothersList.length; ++i)
    {
        if(_brothersList[i] !== null)
            ++num;
    }

    return num;
};

StrongholdScreenRosterModule.prototype.getIndexOfFirstEmptySlot = function (_slots)
{
    for (var i = 0; i < _slots.length; i++)
    {
        if (_slots[i].data('child') == null)
        {
            return i;
        }
    }
}

StrongholdScreenRosterModule.prototype.setBrotherSelected = function (_rosterPosition, _rosterTag, _withoutNotify)
{
    var brother = this.getBrotherByIndex(_rosterPosition, _rosterTag);

    if (brother === null || brother === undefined)
        return;

    this.mSelectedBrother.Index = _rosterPosition;
    this.mSelectedBrother.Tag = _rosterTag;
    this.removeCurrentBrotherSlotSelection();
    this.selectBrotherSlot(brother[CharacterScreenIdentifier.Entity.Id]);
    this.updateDetailsPanel(brother);

    // notify update
    if (_withoutNotify === undefined || _withoutNotify !== true)
    {
        var parent = _rosterTag == Stronghold.Roster.RosterOwner.Player ? this.mPlayer : this.mStronghold;
        this.onBrothersListLoaded(parent, _rosterTag);
    }
};

StrongholdScreenRosterModule.prototype.getBrotherByIndex = function (_index, _tag)
{
    if (_tag === Stronghold.Roster.RosterOwner.Player)
    {
        if (_index < this.mPlayer.BrothersList.length)
            return this.mPlayer.BrothersList[_index];
    }
    else
    {
        if (_index < this.mStronghold.BrothersList.length)
            return this.mStronghold.BrothersList[_index];
    }

    return null;
};


StrongholdScreenRosterModule.prototype.getBrotherByID = function (_brotherId)
{
    var data =
    {
        Index   : null,
        Tag     : null,
        Brother : null,
    };

    // find selected one
    if (this.mPlayer.BrothersList !== null && jQuery.isArray(this.mPlayer.BrothersList))
    {
        for (var i = 0; i < this.mPlayer.BrothersList.length; ++i)
        {
            var brother = this.mPlayer.BrothersList[i];

            if (brother != null && CharacterScreenIdentifier.Entity.Id in brother && brother[CharacterScreenIdentifier.Entity.Id] === _brotherId)
            {
                data.Index = i;
                data.Tag = Stronghold.Roster.RosterOwner.Player;
                data.Brother = brother;
                return data;
            }
        }
    }

    if (this.mStronghold.BrothersList !== null && jQuery.isArray(this.mStronghold.BrothersList))
    {
        for (var i = 0; i < this.mStronghold.BrothersList.length; ++i)
        {
            var brother = this.mStronghold.BrothersList[i];

            if (brother !== null && CharacterScreenIdentifier.Entity.Id in brother && brother[CharacterScreenIdentifier.Entity.Id] === _brotherId)
            {
                data.Index = i;
                data.Tag = Stronghold.Roster.RosterOwner.Stronghold;
                data.Brother = brother;
                return data;
            }
        }
    }

    return data;
};

StrongholdScreenRosterModule.prototype.setBrotherSelectedByID = function (_brotherId)
{
    var data = this.getBrotherByID(_brotherId);

    if (data.Index !== null && data.Tag !== null)
    {
        this.mSelectedBrother.Index = data.Index;
        this.mSelectedBrother.Tag = data.Tag;
        this.removeCurrentBrotherSlotSelection();
        this.selectBrotherSlot(_brotherId);
        this.updateDetailsPanel(data.Brother);
    }
};


StrongholdScreenRosterModule.prototype.removeCurrentBrotherSlotSelection = function ()
{
    this.mStronghold.ListScrollContainer.find('.is-selected').each(function (index, element)
    {
        var slot = $(element);
        slot.removeClass('is-selected');
    });
    this.mPlayer.ListScrollContainer.find('.is-selected').each(function (index, element)
    {
        var slot = $(element);
        slot.removeClass('is-selected');
    });
};


StrongholdScreenRosterModule.prototype.selectBrotherSlot = function (_brotherId)
{
    var listScrollContainer = this.mSelectedBrother.Tag == Stronghold.Roster.RosterOwner.Player ? this.mPlayer.ListScrollContainer : this.mStronghold.ListScrollContainer;
    var slot = listScrollContainer.find('#slot-index_' + _brotherId + ':first');
    if (slot.length > 0)
    {
        slot.addClass('is-selected');
    }
};


// move brother to the other roster on right-click
StrongholdScreenRosterModule.prototype.quickMoveBrother = function (_source)
{
    var _brother = _source.data('brother');

    // check if both roster is full
    if (this.mStronghold.NumActive === this.mStronghold.NumActiveMax && this.mPlayer.NumActive === this.mPlayer.NumActiveMax)
    {
        return false;
    }

    var data = this.getBrotherByID(_brother[CharacterScreenIdentifier.Entity.Id]);

    if (data.Index === null || data.Tag === null)
    {
        return false;
    }

    // selected brother is in player roster
    if (data.Tag === Stronghold.Roster.RosterOwner.Player)
    {
        // deny when the selected brother is a player character
        if (_source.data('player') === true)
            return false;

        // deny when player roster only has 1 bro
        if (this.mPlayer.NumActive === this.mPlayer.NumActiveMin)
            return false;

        // deny when stronghold roster is full
        if (this.mStronghold.NumActive === this.mStronghold.NumActiveMax)
            return false;

        // transfer brother from player roster to stronghold roster
        var firstEmptySlot = this.getIndexOfFirstEmptySlot(this.mStronghold.Slots);
        this.swapSlots(data.Index, Stronghold.Roster.RosterOwner.Player, firstEmptySlot, Stronghold.Roster.RosterOwner.Stronghold);
    }
    // selected brother is in stronghold roster
    else
    {
        // deny when player roster has reached brothers max
        if (this.mPlayer.NumActive >= this.mData.mBrothersAssetMax)
            return false;

        // deny when player roster is full
        if (this.mPlayer.NumActive === this.mPlayer.NumActiveMax)
            return false;

        // transfer brother from stronghold roster to player roster
        var firstEmptySlot = this.getIndexOfFirstEmptySlot(this.mPlayer.Slots);
        this.swapSlots(data.Index, Stronghold.Roster.RosterOwner.Stronghold, firstEmptySlot, Stronghold.Roster.RosterOwner.Player);
    }

    return true;
};


// swap the brother data so i don't have to update the whole roster
StrongholdScreenRosterModule.prototype.swapBrothers = function (_a, _parentA, _b, _parentB)
{
    var tmp = _parentA.BrothersList[_a];
    _parentA.BrothersList[_a] = _parentB.BrothersList[_b];
    _parentB.BrothersList[_b] = tmp;
}


StrongholdScreenRosterModule.prototype.swapSlots = function (_a, _tagA, _b, _tagB)
{
    var isDifferenceRoster = _tagA != _tagB;
    var parentA = _tagA == Stronghold.Roster.RosterOwner.Player ? this.mPlayer : this.mStronghold;
    var parentB = _tagB == Stronghold.Roster.RosterOwner.Player ? this.mPlayer : this.mStronghold;
    var slotA = parentA.Slots[_a];
    var slotB = parentB.Slots[_b];

    // dragging or transfering into empty slot
    if(slotB.data('child') == null)
    {
        var A = slotA.data('child');

        A.data('idx', _b);
        A.appendTo(slotB);

        if (isDifferenceRoster)
        {
            A.data('tag', _tagB);
        }

        slotB.data('child', A);
        slotA.data('child', null);

        if (isDifferenceRoster)
        {
            --parentA.NumActive;
            ++parentB.NumActive;
            this.notifyBackendMoveAtoB(A.data('ID'), _tagA, _b, _tagB);
        }
        else
        {
            this.notifyBackendUpdateRosterPosition(A.data('ID'), _b);
        }

        this.swapBrothers(_a, parentA, _b, parentB);

        if(this.mSelectedBrother.Index == _a && this.mSelectedBrother.Tag == _tagA)
        {
            this.setBrotherSelected(_b, _tagB, true);
        }
    }

    // swapping two full slots
    else
    {
        var A = slotA.data('child');
        var B = slotB.data('child');

        A.data('idx', _b);
        B.data('idx', _a);

        if (isDifferenceRoster)
        {
            A.data('tag', _tagB);
            B.data('tag', _tagA);
        }

        B.detach();

        A.appendTo(slotB);
        slotB.data('child', A);

        B.appendTo(slotA);
        slotA.data('child', B);

        if (isDifferenceRoster)
        {
            this.notifyBackendMoveAtoB(A.data('ID'), _tagA, _b, _tagB);
            this.notifyBackendMoveAtoB(B.data('ID'), _tagB, _a, _tagA);
        }
        else
        {
            this.notifyBackendUpdateRosterPosition(A.data('ID'), _b);
            this.notifyBackendUpdateRosterPosition(B.data('ID'), _a);
        }

        this.swapBrothers(_a, parentA, _b, parentB);

        if(this.mSelectedBrother.Index == _a && this.mSelectedBrother.Tag == _tagA)
        {
            this.setBrotherSelected(_b, _tagB, true);
        }
        else if(this.mSelectedBrother.Index == _b && this.mSelectedBrother.Tag == _tagB)
        {
            this.setBrotherSelected(_a, _tagA, true);
        }
    }
    this.updateWages();

    //this.updateRosterLabel();
}


// create empty slots
StrongholdScreenRosterModule.prototype.createBrotherSlots = function ( _parent , _tag )
{
    var self = this;
    var isPlayer = _tag === Stronghold.Roster.RosterOwner.Player;
    _parent.Slots = [];
    // event listener when dragging then drop bro to an empty slot
    for (var i = 0; i < _parent.NumActiveMax; ++i)
    {
    	this.createBrotherSlot(_parent, _tag);
    }
};

StrongholdScreenRosterModule.prototype.createBrotherSlot = function ( _parent , _tag )
{
	_parent.Slots.push(null);
	var i = _parent.Slots.length - 1;
	var isPlayer = _tag === Stronghold.Roster.RosterOwner.Player;
	if (isPlayer)
	    _parent.Slots[i] = $('<div class="ui-control is-brother-slot is-roster-slot"/>');
	else
	    _parent.Slots[i] = $('<div class="ui-control is-brother-slot is-reserve-slot"/>');

	var slot = _parent.Slots[i];
	_parent.ListScrollContainer.append(slot);

	slot.data('idx', i);
	slot.data('tag', _tag);
	slot.data('child', null);
	this.createSlotDragHandler(slot);
	this.createSlotDropHandler(slot);
	this.createSlotClickHandler(slot)
	// event listener when left-click the brother
}

StrongholdScreenRosterModule.prototype.createSlotDragHandler = function ( _slot )
{
	_slot.drag("init", function (ev, dd)
	{
		if ($(this).data("child") === null)
		{
			return false;
		}
		dd.brother = $(this).data("child");
	})

	_slot.drag("start", function (ev, dd)
	{
	    // build proxy
	    var proxy = $('<div class="ui-control brother is-proxy"/>');
	    proxy.appendTo(document.body);
	    proxy.data('idx', $(this).data("idx"));

	    var imageLayer =  dd.brother.find('.image-layer:first');
	    if (imageLayer.length > 0)
	    {
	        imageLayer = imageLayer.clone();
	        proxy.append(imageLayer);
	    }

	    dd.brother.addClass('is-dragged');

	    return proxy;
	}, { distance: 3 });
	_slot.drag(function (ev, dd)
	{
	    $(dd.proxy).css({ top: dd.offsetY, left: dd.offsetX });
	}, { relative: false, distance: 3 });
	_slot.drag("end", function (ev, dd)
	{
	    var proxy = $(dd.proxy);
	    // not dropped into anything?
	    if ($(dd.drop).length === 0)
	    {
	        proxy.velocity("finish", true).velocity({ top: dd.originalY, left: dd.originalX },
	        {
	            duration: 300,
	            complete: function ()
	            {
	                proxy.remove();
	                dd.brother.removeClass('is-dragged');
	            }
	        });
	    }
	    else
	    {
	        proxy.remove();
	    }
	}, { drop: '.is-brother-slot' });
}

StrongholdScreenRosterModule.prototype.createSlotDropHandler = function ( _slot )
{
	var self = this;
	var dropHandler = function (ev, dd)
	{
	    var drag = $(dd.drag);
	    var drop = $(dd.drop);
	    var proxy = $(dd.proxy);
	    var brother = dd.brother;
	    brother.removeClass('is-dragged');

	    if (proxy === undefined || proxy.data('idx') === undefined || drop === undefined || drop.data('idx') === undefined)
	    {
	        return false;
	    }

	    if (drag.data('tag') == drop.data('tag'))
	    {
	        if (drag.data('idx') == drop.data('idx'))
	            return false;
	    }
	    else
	    {
	        // deny when the player roster has reached brothers max
	        if (drag.data('tag') === Stronghold.Roster.RosterOwner.Stronghold && self.mPlayer.NumActive >= self.mPlayerRosterLimit)
	            return false;
	    }
	    var parent = drag.data('tag') == Stronghold.Roster.RosterOwner.Player ? self.mPlayer : self.mStronghold;

	    // number in formation is limited
	    if (parent.NumActive >= parent.NumActiveMax && drag.data('idx') > parent.NumActiveMax && drop.data('idx') <= parent.NumActiveMax && $(this).data('child') == null)
	    {
	        return false;
	    }

	    // always keep at least 1 in formation
	    if (parent.NumActive == parent.NumActiveMin && drag.data('tag') != drop.data('tag'))
	    {
	        return false;
	    }

	    // do the swapping
	    self.swapSlots(drag.data('idx'), drag.data('tag'), drop.data('idx'), drop.data('tag'));
	};
	_slot.drop(dropHandler);
}

StrongholdScreenRosterModule.prototype.createSlotClickHandler = function ( _slot )
{
	var self = this;
	_slot.mousedown(function (_event)
	{
		if ($(this).data("child") === null)
			return;

		if (_event.which === 1)
		{
		    var data = $(this).data("child").data('brother')[CharacterScreenIdentifier.Entity.Id];
		    var dismissBrother = (KeyModiferConstants.CtrlKey in _event && _event[KeyModiferConstants.CtrlKey] === true);

		    if (dismissBrother)
		        return self.openDismissPopupDialog(data);
		    else
		        return self.setBrotherSelectedByID(data);
		}

	    if (_event.which === 3)
	    {
	        return self.quickMoveBrother($(this).data("child"));
	    }
	});
}

// add brother to empty slot
StrongholdScreenRosterModule.prototype.addBrotherSlotDIV = function(_parent, _data, _index, _tag)
{
    var self = this;
    var parentDiv = _parent.Slots[_index];
    var character = _data[CharacterScreenIdentifier.Entity.Character.Key];
    var id = _data[CharacterScreenIdentifier.Entity.Id];

    // create: slot & background layer
    var result = parentDiv.createListBrother(id);
    result.attr('id', 'slot-index_' + id);
    result.data('ID', id);
    result.data('player', (CharacterScreenIdentifier.Entity.Character.IsPlayerCharacter in character ? character[CharacterScreenIdentifier.Entity.Character.IsPlayerCharacter] : false));
    result.data('idx', _index);
    result.data('tag', _tag);

    result.unbindTooltip();
    result.bindTooltip({ contentType: 'roster-entity', entityId: id });
    parentDiv.data('child', result);
    ++_parent.NumActive;

    // update image & name
    var imageOffsetX = (CharacterScreenIdentifier.Entity.Character.ImageOffsetX in character ? character[CharacterScreenIdentifier.Entity.Character.ImageOffsetX] : 0);
    var imageOffsetY = (CharacterScreenIdentifier.Entity.Character.ImageOffsetY in character ? character[CharacterScreenIdentifier.Entity.Character.ImageOffsetY] : 0);

    result.assignListBrotherImage(Path.PROCEDURAL + character[CharacterScreenIdentifier.Entity.Character.ImagePath], imageOffsetX, imageOffsetY, 0.66);

    // the mood icon is messed up in the screen, i hate it so i hide it, problem solve with minimum effort
    //result.showListBrotherMoodImage(this.IsMoodVisible, character['moodIcon']);

    for(var i = 0; i != _data['injuries'].length && i < 3; ++i)
    {
        result.assignListBrotherStatusEffect(_data['injuries'][i].imagePath, _data[CharacterScreenIdentifier.Entity.Id], _data['injuries'][i].id)
    }

    if(_data['injuries'].length <= 2 && _data['stats'].hitpoints < _data['stats'].hitpointsMax)
    {
        result.assignListBrotherDaysWounded();
    }
};


StrongholdScreenRosterModule.prototype.onBrothersListLoaded = function (_parent, _tag)
{
    for(var i = 0; i != _parent.Slots.length; ++i)
    {
        _parent.Slots[i].empty();
        _parent.Slots[i].data('child', null);
    }

    _parent.NumActive = 0;

    if (_parent.BrothersList === null || !jQuery.isArray(_parent.BrothersList) || _parent.BrothersList.length === 0)
    {
        return;
    }

    for (var i = 0; i < _parent.BrothersList.length; ++i)
    {
        var brother = _parent.BrothersList[i];

        if (brother !== null)
        {
            this.addBrotherSlotDIV(_parent, brother, i, _tag);
        }
    }

    //this.updateRosterLabel();
};


//- Update some shits
StrongholdScreenRosterModule.prototype.updateAssets = function (_data)
{
    var value = null;
    var maxValue = null;
    var previousValue = null;
    var valueDifference = null;
    var currentAssetInformation = _data;
    var previousAssetInformation = this.mRoster;

    if ('Brothers' in _data && 'BrothersMax' in _data)
    {
        value = currentAssetInformation['Brothers'];
        maxValue = currentAssetInformation['BrothersMax'];
        previousValue = previousAssetInformation['Brothers'];
        valueDifference = value - previousValue;

        this.updateAssetValue(this.mPlayerBrotherButton, value, maxValue, valueDifference);
    }

    if ('StrongholdBrothers' in _data && 'StrongholdBrothersMax' in _data)
    {
        value = currentAssetInformation['StrongholdBrothers'];
        maxValue = currentAssetInformation['StrongholdBrothersMax'] > this.mStronghold.NumActiveMax ? this.mStronghold.NumActiveMax : currentAssetInformation['StrongholdBrothersMax'];
        previousValue = previousAssetInformation['StrongholdBrothers'];
        valueDifference = value - previousValue;

        this.updateAssetValue(this.mAssets.mBrothersAsset, value, maxValue, valueDifference);
    }
}

StrongholdScreenRosterModule.prototype.updateAssetValue = function (_container, _value, _valueMax, _valueDifference)
{
    var label = _container.find('.label:first');

    if(label.length > 0)
    {
        if(_valueMax !== undefined && _valueMax !== null)
        {
            label.html('' + Helper.numberWithCommas(_value) + '/' + Helper.numberWithCommas(_valueMax));
        }
        else
        {
            label.html(Helper.numberWithCommas(_value));
        }

        if(_valueDifference !== null && _valueDifference !== 0)
        {
            label.animateValueAndFadeOut(_valueDifference < 0, function (_element)
            {
                _element.html(_valueDifference);
            });
        }

        if(_value <= 0)
        {
            label.removeClass('font-color-assets-positive-value').addClass('font-color-assets-negative-value');
        }
        else
        {
            label.removeClass('font-color-assets-negative-value').addClass('font-color-assets-positive-value');
        }
    }
};
// update a currently selected brother
StrongholdScreenRosterModule.prototype.updateSelectedBrother = function (_data)
{
    if (_data === undefined || _data === null || typeof (_data) !== 'object')
    {
        console.error('ERROR: Failed to update selected brother. Invalid data result.');
        return;
    }

    var index = this.mSelectedBrother.Index;
    var tag = this.mSelectedBrother.Tag;
    var parent = tag == Stronghold.Roster.RosterOwner.Player ? this.mPlayer : this.mStronghold;
    parent.BrothersList[index] = _data;
    parent.Slots[index].empty();
    parent.Slots[index].data('child', null);
    this.addBrotherSlotDIV(parent, _data, index, tag);
    this.updateDetailsPanel(_data);
}

StrongholdScreenRosterModule.prototype.updateDetailsPanel = function (_brother)
{
	this.mPortrait.Container.hide();
    this.mSkills.Container.hide();
    this.mStatsContainer.hide();

    if (_brother === null)
    {
        var find = this.getBrotherByIndex(this.mSelectedBrother.Index, this.mSelectedBrother.Tag);

        if (find === null)
        {
        	this.rollUpScrollDiv();
            return;
        }
        else
            _brother = find;
    }

    switch(this.mToggledType)
    {
    case Stronghold.Roster.ToggleScroll.Type.Portrait:
    	this.mPortrait.Container.show();
        this.mTitleContainer.html(this.getModuleText().Portrait);
        if (_brother !== undefined && CharacterScreenIdentifier.Entity.Character.Key in _brother)
        {
            var character = _brother[CharacterScreenIdentifier.Entity.Character.Key];

            if (CharacterScreenIdentifier.Entity.Character.ImagePath in character)
                this.setPortraitImage(character[CharacterScreenIdentifier.Entity.Character.ImagePath]);

            if (CharacterScreenIdentifier.Entity.Character.Name in character)
                this.mPortrait.NameLabel.html(character[CharacterScreenIdentifier.Entity.Character.Name]);
        }
        break;

    case Stronghold.Roster.ToggleScroll.Type.Skills:
    	this.mSkills.Container.show();
        this.mTitleContainer.html(this.getModuleText().Skills);
        if (_brother !== undefined && CharacterScreenIdentifier.Entity.Id in _brother)
        {
            if (CharacterScreenIdentifier.SkillTypes.ActiveSkills in _brother)
                this.addSkills(this.mSkills.ActiveSkillsRow, _brother[CharacterScreenIdentifier.Entity.Id], _brother[CharacterScreenIdentifier.SkillTypes.ActiveSkills], true);

            if (CharacterScreenIdentifier.SkillTypes.PassiveSkills in _brother)
                this.addSkills(this.mSkills.PassiveSkillsRow, _brother[CharacterScreenIdentifier.Entity.Id], _brother[CharacterScreenIdentifier.SkillTypes.PassiveSkills], false);

            if (CharacterScreenIdentifier.SkillTypes.StatusEffects in _brother)
                this.addSkills(this.mSkills.StatusEffectsRow, _brother[CharacterScreenIdentifier.Entity.Id], _brother[CharacterScreenIdentifier.SkillTypes.StatusEffects], false);
            this.mSkills.PerksRow.empty();
            this.addSkillsDIV(this.mSkills.PerksRow, _brother[CharacterScreenIdentifier.Entity.Id], _brother.perkuidata, false, true);
        }
        break;

    default:
    	this.mStatsContainer.show();
        this.mTitleContainer.html(this.getModuleText().Attributes);
        if (_brother !== undefined && CharacterScreenIdentifier.Entity.Stats in _brother)
            this.setProgressbarValues(_brother[CharacterScreenIdentifier.Entity.Stats]);
    }
};

StrongholdScreenRosterModule.prototype.setPortraitImage = function(_imagePath)
{
    if (this.mPortrait.Image.attr('src') == Path.PROCEDURAL + _imagePath)
        return;

    this.mPortrait.Placeholder.removeClass('opacity-almost-none');
    this.mPortrait.Image.attr('src', Path.PROCEDURAL + _imagePath);
};

StrongholdScreenRosterModule.prototype.addSkills = function (_parentDiv, _brotherId, _data, _isSkill)
{
    var self = this;

    _parentDiv.empty();
    jQuery.each(_data, function (_index, _value)
    {
        self.addSkillsDIV(_parentDiv, _brotherId, _value, _isSkill);
    });
};

//- Skills Panel
StrongholdScreenRosterModule.prototype.addSkillsDIV = function (_parentDiv, _entityId, _data, _isSkill, _isPerk)
{
    if (_data === undefined ||_data === null || !jQuery.isArray(_data))
    {
        // console.error('ERROR: Failed to add Skills. Reason: Invalid data.');
        return;
    }

    if (_data.length > 0)
    {
        var containerLayout = $('<div class="l-skills-group-container"/>');
        var container = $('<div class="l-skill-groups-container"/>');
        containerLayout.append(container);

        for (var i = 0; i < _data.length; ++i)
        {
            if (!(CharacterScreenIdentifier.Skill.Id in _data[i]) || !(CharacterScreenIdentifier.Skill.ImagePath in _data[i]))
            {
                continue;
            }

            var image = $('<img/>');
            image.attr('src', Path.GFX + _data[i].imagePath);
            container.append(image);

            if (_isSkill === true)
            {
                image.bindTooltip({ contentType: 'skill', entityId: _entityId, skillId: _data[i].id });
            }
            else
            {
                image.bindTooltip({ contentType: 'status-effect', entityId: _entityId, statusEffectId: _data[i].id });
            }
            if (_isPerk === true)
            {
            		// image.css("outline", "1px solid gold");
            		// image.css("border-radius", "50%");
            	    // image.css("-webkit-border-radius", "50%");
            	    // image.css("-moz-border-radius", "50%");
            	// var perkSelectionImage = $('<img class="selection-image-layer"/>');
            	// perkSelectionImage.attr('src', Path.GFX + Asset.PERK_SELECTION_FRAME);
            	// image.append(perkSelectionImage);
            }
        }

        if (container.children().length > 0)
        {
            _parentDiv.append(containerLayout);
        }
    }
};
//---------------------------------------

StrongholdScreenRosterModule.prototype.setProgressbarValues = function (_data)
{
    this.setProgressbarValue(this.mStatsRows.Hitpoints.Progressbar, _data, ProgressbarValueIdentifier.Hitpoints, ProgressbarValueIdentifier.HitpointsMax, ProgressbarValueIdentifier.HitpointsLabel);
    this.setProgressbarValue(this.mStatsRows.Fatigue.Progressbar, _data, ProgressbarValueIdentifier.Fatigue, ProgressbarValueIdentifier.FatigueMax, ProgressbarValueIdentifier.FatigueLabel);
    this.setProgressbarValue(this.mStatsRows.Bravery.Progressbar, _data, ProgressbarValueIdentifier.Bravery, ProgressbarValueIdentifier.BraveryMax, ProgressbarValueIdentifier.BraveryLabel);
    this.setProgressbarValue(this.mStatsRows.Initiative.Progressbar, _data, ProgressbarValueIdentifier.Initiative, ProgressbarValueIdentifier.InitiativeMax, ProgressbarValueIdentifier.InitiativeLabel);
    this.setProgressbarValue(this.mStatsRows.MeleeSkill.Progressbar, _data, ProgressbarValueIdentifier.MeleeSkill, ProgressbarValueIdentifier.MeleeSkillMax, ProgressbarValueIdentifier.MeleeSkillLabel);
    this.setProgressbarValue(this.mStatsRows.RangeSkill.Progressbar, _data, ProgressbarValueIdentifier.RangeSkill, ProgressbarValueIdentifier.RangeSkillMax, ProgressbarValueIdentifier.RangeSkillLabel);
    this.setProgressbarValue(this.mStatsRows.MeleeDefense.Progressbar, _data, ProgressbarValueIdentifier.MeleeDefense, ProgressbarValueIdentifier.MeleeDefenseMax, ProgressbarValueIdentifier.MeleeDefenseLabel);
    this.setProgressbarValue(this.mStatsRows.RangeDefense.Progressbar, _data, ProgressbarValueIdentifier.RangeDefense, ProgressbarValueIdentifier.RangeDefenseMax, ProgressbarValueIdentifier.RangeDefenseLabel);

    this.setTalentValue(this.mStatsRows.Hitpoints, _data.hitpointsTalent);
    this.setTalentValue(this.mStatsRows.Fatigue, _data.fatigueTalent);
    this.setTalentValue(this.mStatsRows.Bravery, _data.braveryTalent);
    this.setTalentValue(this.mStatsRows.Initiative, _data.initiativeTalent);
    this.setTalentValue(this.mStatsRows.MeleeSkill, _data.meleeSkillTalent);
    this.setTalentValue(this.mStatsRows.RangeSkill, _data.rangeSkillTalent);
    this.setTalentValue(this.mStatsRows.MeleeDefense, _data.meleeDefenseTalent);
    this.setTalentValue(this.mStatsRows.RangeDefense, _data.rangeDefenseTalent);
};

StrongholdScreenRosterModule.prototype.updateNameAndTitle = function(_dialog, _brotherId, _tag)
{
    var self = this;
    var contentContainer = _dialog.findPopupDialogContentContainer();
    var parent = _tag === Stronghold.Roster.RosterOwner.Player ? this.mPlayer : this.mStronghold;
    var inputFields = contentContainer.find('input');
    var name = $(inputFields[0]).getInputText();
    var title = $(inputFields[1]).getInputText();

    if (_brotherId === null)
    {
        console.error('ERROR: Failed to update name & title. No entity selected.');
        return;
    }

    this.notifyBackendUpdateNameAndTitle(_brotherId, name, title, _tag, function(data)
    {
        if (data === undefined || data === null || typeof (data) !== 'object')
        {
            console.error('ERROR: Failed to update name & title. Invalid data result.');
            return;
        }

        var find = self.getBrotherByID(_brotherId);

        if (find.Index !== null)
        {
            parent.BrothersList[find.Index] = data;

            if (self.mToggledType === Stronghold.Roster.ToggleScroll.Type.Portrait)
                self.updateDetailsPanel(data);
        }
        else
        {
            console.error('ERROR: Failed to update name & title. Can not update new name to current database.');
        }
    });
};

StrongholdScreenRosterModule.prototype.transferItemsToStash = function ()
{
    var self = this;
    var brother = this.getBrotherByIndex(this.mSelectedBrother.Index, this.mSelectedBrother.Tag);

    if (brother === null || brother === undefined)
        return;

    this.notifyBackendCheckCanTransferItems(function(data)
    {
        if (data.NumItems < data.NumEmptySlots)
        {
            self.notifyBackendTransferItems();
        }
        else
        {
            self.openTransferConfirmationPopupDialog(data);
        }
    });
};

StrongholdScreenRosterModule.prototype.notifyBackendBrothersButtonPressed = function ()
{
    SQ.call(this.mSQHandle, 'onBrothersButtonPressed');
};

StrongholdScreenRosterModule.prototype.notifyBackendTooltipButtonPressed = function (_data)
{
    SQ.call(this.mSQHandle, 'onTooltipButtonPressed', [_data]);
};

StrongholdScreenRosterModule.prototype.notifyBackendCheckCanTransferItems = function (_callback)
{
	var brother = this.getBrotherByIndex(this.mSelectedBrother.Index, this.mSelectedBrother.Tag);
    SQ.call(this.mSQHandle, 'onCheckCanTransferItems', {
    	"ID"  : brother[CharacterScreenIdentifier.Entity.Id],
    	"RosterTag" : this.mSelectedBrother.Tag
    }, _callback);
};

StrongholdScreenRosterModule.prototype.notifyBackendTransferItems = function ()
{
	var brother = this.getBrotherByIndex(this.mSelectedBrother.Index, this.mSelectedBrother.Tag);
    SQ.call(this.mSQHandle, 'onTransferItems', {
    	"ID"  : brother[CharacterScreenIdentifier.Entity.Id],
    	"RosterTag" : this.mSelectedBrother.Tag
    });
};

StrongholdScreenRosterModule.prototype.notifyBackendUpdateNameAndTitle = function (_brotherId, _name, _title, _tag, _callback)
{
    SQ.call(this.mSQHandle, 'onUpdateNameAndTitle', [_brotherId, _name, _title, _tag], _callback);
};

StrongholdScreenRosterModule.prototype.notifyBackendDismissCharacter = function (_payCompensation, _brotherId, _tag)
{
    SQ.call(this.mSQHandle, 'onDismissCharacter', {
    	"ID"  : _brotherId,
    	"RosterTag" : _tag,
    	"Compensation" : _payCompensation
    });
};

StrongholdScreenRosterModule.prototype.notifyBackendUpdateRosterPosition = function (_id, _pos)
{
    SQ.call(this.mSQHandle, 'onUpdateRosterPosition', [ _id, _pos ]);
};

StrongholdScreenRosterModule.prototype.notifyBackendMoveAtoB = function (_id, _tagA, _pos, _tagB)
{
    SQ.call(this.mSQHandle, 'MoveAtoB', {
    	"ID" : _id,
    	"OriginTag" : _tagA,
    	"Position" : _pos,
    	"DestinationTag" : _tagB
    });
};
//----------------------------------------------------------------------------------------




