this.stronghold_screen_upgrade_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function getUIData( _ret )
	{
		local price = ::Stronghold.PriceMult * ::Stronghold.BuyPrices[this.getTown().getSize()]
		local currentInventory = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades()]
		local nextInventory = currentInventory;
		if(this.World.Retinue.getInventoryUpgrades() < this.getTown().getSize() + 1)
		{
			nextInventory = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades() + 1]
		}
		_ret.UpgradeAdvantages <- ::Stronghold.UnlockAdvantages;
		_ret.UpgradeRequirements <- {
		    Money  = {
		        TextDone = "You have the required " + price + " crowns.",
		        TextNotDone = "You don't have the required " + price + "crowns.",
		        Done = this.World.Assets.getMoney() >= price
		    },
		    Cart  = {
		        TextDone = format("You have a %s", currentInventory),
		        TextNotDone  = format("You need to level up your %s to a %s!", currentInventory, nextInventory),
		        Done  = this.World.Retinue.getInventoryUpgrades() >= this.getTown().getSize() + 1
		    },
		    ActiveContract  = {
		        TextDone = "You don't have an active contract.",
		        TextNotDone = "You have an active contract.",
		        Done = this.World.Contracts.getActiveContract() == null
		    },
		}
		return _ret
	}
})
