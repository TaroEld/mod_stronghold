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
	// Wrap the array passed to addChildren in another array, like so : trigger("addChildren", [["a", "b", "c"]]);
	// trigger("set") is a shorthand function. Pass the arguments wrapped into an array
	// The maximum height of the element container is 20rem, but this can be changed via setting data("maxHeight") on the result
	var result = $('<div class="dropdown"/>');

	var text = $('<div class="dropdown-text text-font-normal font-color-label"/>');
	result.append(text);

	var container = $('<div class="dropdown-container"/>');
	result.append(container);

	var scroll = $('<div class="dropdown-container-scroll"/>');
	container.append(scroll);

	result.on("addChildren", function(_event, _children)
	{
		var innerContainer = $(this).find(".dropdown-container-scroll");
		var outerContainer = $(this).find(".dropdown-container");
		var width = 175;
		$.each(_children, function(_idx, _element)
		{
			var child = $('<div class="dropdown-child text-font-normal font-color-label">' + _element + '</div>');
			innerContainer.append(child);
			child.on("click", function(_event)
			{
				var dropDown = $(this).closest(".dropdown");
				dropDown.find(".dropdown-child").removeClass("is-selected");
				$(this).addClass("is-selected");
				dropDown.find(".dropdown-text").text($(this).text());
				if (dropDown.data("callback") !== undefined && dropDown.data("callback") !== null)
				{
					dropDown.data("callback")($(this).text());
				}
				return false;
			})
			width = Math.max(width, getWidthOfDropdownChild(_element.Name))
		})
		var newheight = Math.min($(this).data("maxHeight") || 20, innerContainer.children().length * 3) + "rem";
		outerContainer.css("height", newheight);
		$this.width(width);
	})

	result.on("setDefault", function(_event, _default)
	{
		$(this).find(".dropdown-child").each(function()
		{
			if($(this).text() == _default)
			{
				$(this).click();
			}
		})
	})

	result.on("setCallback", function(_event, _function)
	{
		$(this).data("callback", _function);
	})

	result.on("removeChildren", function()
	{
		$(this).find(".dropdown-container-scroll").empty();
	})

	result.on("set", function(_event, _children, _default, _callback)
	{
		var $this = $(this);
		$this.trigger("removeChildren");
		if (_children !== undefined && _children !== null)
			$this.trigger("addChildren", [_children])

		if (_default !== undefined && _default !== null)
			$this.trigger("setDefault", _default)

		if (_callback !== undefined && _callback !== null)
			$this.trigger("setCallback", _callback)
	})

	result.trigger("set", [_childrenArray, _default, _onChangeCallback]);

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
