this.stronghold_screen <- {
	m = {
		JSHandle = null,
		Visible = null,
		OnConnectedListener = null,
		OnDisconnectedListener = null,
		OnScreenShownListener = null,
		OnScreenHiddenListener = null,
		OnClosePressedListener = null,
		Town = null,
	},

	function create()
	{
		this.m.Visible = false;
	}

	function destroy()
	{
		this.clearEventListener();
		this.m.JSHandle = this.UI.disconnect(this.m.JSHandle);
	}

	function isVisible()
	{
		return this.m.Visible != null && this.m.Visible == true;
	}

	function setOnConnectedListener( _listener )
	{
		this.m.OnConnectedListener = _listener;
	}

	function setOnDisconnectedListener( _listener )
	{
		this.m.OnDisconnectedListener = _listener;
	}
	
	function setOnClosePressedListener( _listener )
	{
		this.m.OnClosePressedListener = _listener;
	}

	function onCancelButtonPressed()
	{
		if (this.m.OnCancelButtonPressedListener != null)
		{
			this.m.OnCancelButtonPressedListener();
		}
	}

	function clearEventListener()
	{
		this.m.OnConnectedListener = null;
		this.m.OnDisconnectedListener = null;
		this.m.OnScreenHiddenListener = null;
		this.m.OnScreenShownListener = null;
	}

	function setTown( _t )
	{
		this.m.Town = _t;
	}

	function getTown()
	{
		return this.m.Town;
	}

	function show()
	{

		if (this.m.JSHandle != null && !this.isVisible())
		{
			this.Tooltip.hide();
			this.World.State.m.WorldTownScreen.hideAllDialogs();
			this.World.State.m.MenuStack.push(function ()
			{
				this.logWarning("Menustack pop")
				::Stronghold.StrongholdScreen.hide();
				this.m.WorldTownScreen.showLastActiveDialog();
			}, function ()
			{
				return true;
			});
			this.m.JSHandle.asyncCall("show", this.m.Town.getUIData());
		}
	}
	

	function hide()
	{
		this.logWarning("stronghold_screen hide")
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.logWarning("stronghold_screen hide past if")
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("hide", null);
		}
	}

	function onCancelButtonPressed()
	{

	}

	function onScreenConnected()
	{
		if (this.m.OnConnectedListener != null)
		{
			this.m.OnConnectedListener();
		}
	}

	function onScreenDisconnected()
	{
		if (this.m.OnDisconnectedListener != null)
		{
			this.m.OnDisconnectedListener();
		}
	}


	function onScreenShown()
	{
		this.logWarning("onScreenShown")
		this.m.Visible = true;
	}

	function onScreenHidden()
	{
		this.logWarning("onScreenHidden")
		this.m.Visible = false;
	}
};

