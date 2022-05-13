::mods_hookDescendants("items/item", function ( o )
{
	// sets buy/sell price to 0 when using stronghold marketplace
	local getBuyPrice = ::mods_getMember(o, "getBuyPrice")
	local getSellPrice = ::mods_getMember(o, "getSellPrice")
	o.getBuyPrice <- function()
	{
		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().m.CurrentBuilding != null && this.World.State.getCurrentTown().m.CurrentBuilding.m.ID == "building.storage_building")
		{	
			return 0.0;
		}
		else
		{	
			return getBuyPrice();
		}
	}

	o.getSellPrice <- function()
	{
		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().m.CurrentBuilding != null && this.World.State.getCurrentTown().m.CurrentBuilding.m.ID == "building.storage_building")
		{	
			return 0.0;
		}
		else
		{
			return getSellPrice();
		}
	}
});