var Stronghold = {
	Visuals :
	{
	    SpritePath : "ui/settlement_sprites/",
	    BuildingSpritePath : "ui/buildings/",
	    LocationSpritePath : "ui/locations/",
	    SelectionImagePath : "ui/selection.png",
	    SelectionGoldImagePath : "ui/selection-gold.png",
	    BaseSpriteTypes : ["Default", "Luft_Basic", "Luft_Brigand", "Luft_Necro", "Luft_Fishing"],
	    VisualsMap : null, // sent by SQ once stronghold_screen.nut initializes
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

    getTextDiv : function(_text)
    {
    	return $("<div/>")
    		.addClass(Stronghold.Style.TextFont)
    		.html(_text || "")
    },
    getTextDivSmall : function(_text)
    {
    	return $("<div/>")
    		.addClass(Stronghold.Style.TextFontSmall)
    		.html(_text || "")
    },
    getTextSpan : function(_text)
    {
    	return $("<span/>")
    		.addClass(Stronghold.Style.TextFont)
    		.html(_text || "")
    },
    getTextSpanSmall : function(_text)
    {
    	return $("<span/>")
    		.addClass(Stronghold.Style.TextFontSmall)
    		.html(_text || "")
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

$.fn.appendRow = function(_subTitle, _classes, _smallSubText)
{
    var row = $('<div class="flex-row"/>')
    	.appendTo(this)
    	.addClass(_classes || "")

    if (_subTitle !== undefined && _subTitle !== null)
    {
    	var fontSize = "title-font-big";
    	if (_smallSubText)
    		fontSize = "title-font-normal";
        row.append($('<div class="sub-title ' + fontSize + ' font-bold font-bottom-shadow font-color-title">' + _subTitle + '</div>'))
    }
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

WorldCampfireScreenAssets.prototype.createStrongholdDIV = function (_parentDiv)
{
	var self = this;
	var layout = $('<div class="l-button stronghold-generic-background"/>');
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
