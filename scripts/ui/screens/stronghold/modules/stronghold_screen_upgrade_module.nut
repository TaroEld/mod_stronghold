this.stronghold_screen_upgrade_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function getUIData( _ret )
	{
		// If level cap is reached, there is no need for the other info
		_ret.MaxSize <- this.getTown().getSize() == 4;
		if (_ret.MaxSize) return _ret;
		local tier = ::Stronghold.BaseTiers[this.getTown().getSize() + 1];
		local price = ::Stronghold.Misc.PriceMult * tier.Price;
		local warehouse = this.getTown().getWarehouse();
		_ret.CurrentRenown <- ::World.Assets.getBusinessReputation();
		_ret.RenownRequired <- ::Stronghold.getNextRenownCost();
		_ret.Requirements <- {
			Price = this.World.Assets.getMoney() >= price,
			Warehouse = warehouse != null && warehouse.m.Level >= this.getTown().getSize()
			NotUpgrading = !this.getTown().isUpgrading(),
			NoContract = this.World.Contracts.getActiveContract() == null,
			Renown = _ret.CurrentRenown > _ret.RenownRequired,
		}

		_ret.Price <- ::Stronghold.Misc.PriceMult * tier.Price;
		return _ret
	}

	function onUpgradeBase()
	{
		this.World.State.m.MenuStack.popAll(true);
		this.getTown().startUpgrading();

		local targetLevel = this.getTown().getSize();
		local price = ::Stronghold.Misc.PriceMult * ::Stronghold.BaseTiers[targetLevel].Price;
		::Stronghold.addRoundedMoney(-price);

		local playerFaction = this.Stronghold.getPlayerFaction();
		local contract = this.new("scripts/contracts/contracts/stronghold_defeat_assailant_contract");

		contract.setEmployerID(playerFaction.getRandomCharacter().getID());
		contract.setFaction(playerFaction.getID());
		contract.setHome(this.getTown());
		contract.setOrigin(this.getTown());
		contract.m.TargetLevel = targetLevel;
		this.World.Contracts.addContract(contract);
		contract.start();
	}
})
