this.stronghold_overflow_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {
		Home = null
	},

	function create()
	{
		this.situation.create();
		this.m.ID = "situation.stronghold_overflow";
		this.m.Description = "You have too many items! Enter your keep and collect them before leaving the base."
		this.m.Icon = "ui/settlement_status/stronghold_overflow.png";
		this.m.IsStacking = false;
		
	}

	function isValid()
	{
		return true;
	}
});

