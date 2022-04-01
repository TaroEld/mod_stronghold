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
				this.m.WorldTownScreen.getMainDialogModule().reload();
				this.m.WorldTownScreen.showLastActiveDialog();
			});
			this.m.JSHandle.asyncCall("show", this.getUIData());
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

	function changeBaseName(_data)
	{
		this.logInfo("changeBaseName " + _data)
		this.m.Town.m.Name = _data;
		this.m.Town.getFlags().set("CustomName", true);
		this.m.Town.getLabel("name").Text = _data;
		
	}

	function getUIData()
	{
		local ret = this.m.Town.getUIData();
		this.getAssetsUIData( ret );
		this.getUpgradeUIData( ret );
		return ret
	}

	function getAssetsUIData( _ret )
	{
		_ret.Assets.mMoneyAsset <- this.World.Assets.getMoney();
		_ret.Assets.mFoodAsset <- this.World.Assets.getFood();
		_ret.Assets.mAmmoAsset <- this.World.Assets.getArmorParts();
		_ret.Assets.mSuppliesAsset <- this.World.Assets.getAmmo();
		_ret.Assets.mMedicineAsset <- this.World.Assets.getMedicine();
		_ret.Assets.mBrothersAssetMax <- this.World.Assets.getBrothersMax();
		_ret.Assets.mInventoryUpgrades <- this.World.Retinue.getInventoryUpgrades();
	}

	function getUpgradeUIData( _ret )
	{
		local price = this.Stronghold.PriceMult * this.Stronghold.BuyPrices[this.m.Town.getSize()]
		local currentInventory = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades()]
		local nextInventory = currentInventory;
		if(this.World.Retinue.getInventoryUpgrades() < this.m.Town.getSize() + 1)
		{
			nextInventory = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades() + 1]
		}
		_ret.mUpgradeRequirements <- {
		    Money  = {
		        TextDone = "You have the required " + price + " crowns.",
		        TextNotDone = "You don't have the required " + price + "crowns.",
		        Done = this.World.Assets.getMoney() >= price
		    },
		    Cart  = {
		        TextDone = format("You have a %s", currentInventory),
		        TextNotDone  = format("You need to level up your %s to a %s!", currentInventory, nextInventory),
		        Done  = this.World.Retinue.getInventoryUpgrades() >= this.m.Town.getSize() + 1
		    },
		    ActiveContract  = {
		        TextDone = "You don't have an active contract.",
		        TextNotDone = "You have an active contract.",
		        Done = this.World.Contracts.getActiveContract() == null
		    },
		}
	}

	function changeSprites(_data)
	{
		this.logInfo("changeSprites " + _data)
		this.m.Town.onVisualsChanged(_data);
		this.m.JSHandle.asyncCall("loadFromData", this.getUIData());
	}

	
};

