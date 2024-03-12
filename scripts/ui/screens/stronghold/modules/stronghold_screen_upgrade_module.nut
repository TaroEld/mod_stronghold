this.stronghold_screen_upgrade_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function getUIData( _ret )
	{
		// If level cap is reached, there is no need for the other info
		_ret.MaxSize <- this.getTown().getSize() == 3;
		if (_ret.MaxSize) return;
		local tier = ::Stronghold.Tiers[this.getTown().getSize() + 1];
		local price = ::Stronghold.PriceMult * tier.Price;
		local warehouse = this.getTown().getWarehouse();
		_ret.Requirements <- {
			Price = this.World.Assets.getMoney() >= price,
			Warehouse = warehouse != null && warehouse.m.Level >= this.getTown().getSize()
			NotUpgrading = !this.getTown().isUpgrading(),
			NoContract = this.World.Contracts.getActiveContract() == null,
		}
		_ret.Price <- ::Stronghold.PriceMult * tier.Price;
		return _ret
	}

	function onUpgradeBase()
	{
		this.World.State.m.MenuStack.popAll(true);

		local tier = ::Stronghold.Tiers[this.getTown().getSize() + 1];
		local price = ::Stronghold.PriceMult * tier.Price;
		::World.Assets.addMoney(-price);
		local playerFaction = this.Stronghold.getPlayerFaction();
		local contract = this.new("scripts/contracts/contracts/stronghold_defeat_assailant_contract");
		this.getTown().startUpgrading();
		contract.setEmployerID(playerFaction.getRandomCharacter().getID());
		contract.setFaction(playerFaction.getID());
		contract.setHome(this.getTown());
		contract.setOrigin(this.getTown());
		contract.m.Flags.set("IsUpgrading", true)
		contract.m.TargetLevel = this.getTown().getSize() + 1;
		this.World.Contracts.addContract(contract);
		contract.start();
	}
})
