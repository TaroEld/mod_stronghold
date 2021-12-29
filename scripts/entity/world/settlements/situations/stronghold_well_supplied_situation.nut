this.stronghold_well_supplied_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	//had to use a very hacky way to select player base, as otherwise deserialisation errors (or custom addSituation function)
	m = {
		Home = null
	},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.stronghold_well_supplied";
		this.m.Name = this.defineName();
		this.m.Description = ""
		this.m.Icon = "ui/settlement_status/settlement_effect_03.png";
		this.m.Rumors = [
			"Trade with %settlement% is prospering, my friend! Safe roads and full stocks, let\'s hope it stays this way...",
			"My cousin over in %settlement% keeps bragging about how good they have it there. Well stocked market stands and all. Not like this rotten place."
		];
		this.m.IsStacking = false;
		
	}
	function defineName()
	{
		local company_name = this.World.Assets.getName();
		local final_name = "The ";
		if (company_name.slice(company_name.len()-1, company_name.len()) == "s")
		{
			company_name = company_name.slice(0, company_name.len()-1);
		}
		final_name += company_name + "'s boon";
		return final_name;
	}
	function isValid()
	{
		return true;
	}

	//should be dynamic and check the properties
	function defineDescription(_town)
	{
		local description = "With no noble house asking for tariffs, you can get very good prices for your goods. ";
		local mults = this.Const.World.Stronghold.WellSupplied[_town.getSize()-1]
		return description
	}

	function getAddedString( _s )
	{
		return _s + " now has " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " no longer has " + this.m.Name;
	}

	function onUpdate( _modifiers )
	{ 
		local playerBase = this.World.State.getCurrentTown();
		if (playerBase == null) return
		this.defineDescription(playerBase);
		local mults = this.Const.World.Stronghold.WellSupplied[playerBase.getSize()-1]
		_modifiers.RarityMult = mults.Rarity;
		_modifiers.BuyPriceMult = mults.BuyPrice;
		_modifiers.SellPriceMult = mults.SellPrice;
	}

});

