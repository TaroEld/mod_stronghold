this.stronghold_well_supplied_ai_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	//buff when AI caravans arrive at stronghold
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.stronghold_well_supplied_ai";
		this.m.Name = "Well Supplied";
		this.m.Description = "This place has been recently supplied with fresh wares, and shops will now have more items for sale.";
		this.m.Icon = "ui/settlement_status/settlement_effect_03.png";
		this.m.Rumors = [
			"Trade with %settlement% is prospering, my friend! Safe roads and full stocks, let\'s hope it stays this way...",
			"My cousin over in %settlement% keeps bragging about how good they have it there. Well stocked market stands and all. Not like this rotten place."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " now is " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " no longer is " + this.m.Name;
	}

	function onAdded( _settlement )
	{

	}

	function onUpdate( _modifiers )
	{
		//number might need tweaking
		_modifiers.RarityMult *= 1.05;
	}

});

