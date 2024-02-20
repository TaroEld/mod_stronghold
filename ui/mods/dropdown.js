var widthTester = $('<div id="WidthTester"/>')
	.css({'position': 'absolute', 'float': 'left', 'white-space': 'nowrap', 'visibility': 'hidden'})
	.addClass("text-font-normal")
	.appendTo($('body'))

var getWidthOfDropdownChild = function(_text)
{
    widthTester.text(_text);
	return widthTester.width();
}

var createDropDownMenu = function(_parentDiv, _classes, _childrenArray, _default, _onChangeCallback)
{
	// NOTE: you need to pass the _parentDiv that the dropdown gets attached to
	// This is due do aciScrollBar
	// The _parentDiv needs to be attached to the DOM!!!
	// The maximum height of the element container is 20rem, but this can be changed via setting data("maxHeight") on the result
	var result = $('<div class="dropdown"/>')
		.addClass(_classes || "")
		.data("activeElement", null)
		.append($('<div class="dropdown-text text-font-normal font-color-label"/>'))

	var container = $('<div class="dropdown-container"/>')
		.append($('<div class="dropdown-container-scroll"/>'))
		.appendTo(result)

	result.addChildren = function(_children)
	{
		var innerContainer = this.find(".dropdown-container-scroll");
		var outerContainer = this.find(".dropdown-container");
		var width = 175;
		$.each(_children, function(_idx, _element)
		{
			var child = $('<div class="dropdown-child text-font-normal font-color-label"/>')
				.data("Element", _element)
				.appendTo(innerContainer)

			if (typeof _element == "object")
			{
				if(_element.Name === undefined)
					console.error("Passed an object as dropdown member but it does not have a .Name member to use as label!")
				child.text(_element.Name)
			}
			else child.text(_element)

			child.on("click", function(_event)
			{
				var dropDown = $(this).closest(".dropdown");
				dropDown.find(".dropdown-child").removeClass("is-selected");
				$(this).addClass("is-selected");
				dropDown.find(".dropdown-text").text($(this).text());
				dropDown.data("activeElement", $(this).data("Element"));
				if (dropDown.data("callback") !== undefined && dropDown.data("callback") !== null)
				{
					dropDown.data("callback")($(this).data("Element"));
				}
				return false;
			})
			width = Math.max(width, getWidthOfDropdownChild(_element.Name))
		})
		var newheight = Math.min(this.data("maxHeight") || 20, innerContainer.children().length * 3) + "rem";
		outerContainer.css("height", newheight);
		this.width(width);
	}

	result.setDefault = function(_default)
	{
		this.find(".dropdown-child").each(function()
		{
			if($(this).data("Element") == _default)
			{
				$(this).click();
			}
		})
	}

	result.setCallback = function(_function)
	{
		this.data("callback", _function);
	}

	result.removeChildren = function()
	{
		this.find(".dropdown-container-scroll").empty();
	}

	result.get = function()
	{
		return this.data("activeElement");
	}

	result.set = function(_children, _default, _callback)
	{
		this.attr('disabled', false);
		this.removeChildren();
		if (_callback !== undefined && _callback !== null)
			this.setCallback(_callback)

		if (_children !== undefined && _children !== null)
			this.addChildren(_children)

		if (_default !== undefined && _default !== null)
			this.setDefault(_default)

		if ((_children === undefined || _children.length == 0) || this.get() === undefined)
		{
    		this.attr('disabled', true);
		}
	}

	result.set(_childrenArray, _default, _onChangeCallback);

	// These must be last!
	_parentDiv.append(result);
	container.aciScrollBar({
         delta: 1,
         lineDelay: 0,
         lineTimer: 0,
         pageDelay: 0,
         pageTimer: 0,
         bindKeyboard: false,
         resizable: false,
         smoothScroll: false
     });

	return result;
}
