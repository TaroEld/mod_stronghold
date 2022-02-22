local gt = this.getroottable();

gt.Stronghold.setupLocationDefs <- function()
{
	gt.Stronghold.Location_options <-
	[
		{
			Name = "Workshop",
			ID = "attached_location.workshop",
			ConstID = "Workshop",
			Cost = 0, //cost is set below this array
			Path = "workshop_location",
			Text= "Build a workshop. Generates tools.",
			isValid = null //isValid is set below this array if null
		},
		{
			Name = "Ore Smelter",
			ID = "attached_location.ore_smelters",
			ConstID = "Ore_Smelter",
			Cost = 0,
			Path = "ore_smelters_location",
			Text = "Build an ore smelter. Weaponsmiths carry more items.",
			isValid = null
		},
		{
			Name = "Blast Furnace",
			ID = "attached_location.blast_furnace",
			ConstID = "Blast_Furnace",
			Cost = 0,
			Path = "blast_furnace_location",
			Text = "Build a blast furnace. Armourers carry more items.",
			isValid = null
		},
		{
			Name = "Stone Watchtower",
			ID = "attached_location.stone_watchtower",
			ConstID = "Stone_Watchtower",
			Cost = 0,
			Path = "stone_watchtower_location",
			Text = "Build a watchtower. Increases movement speed and sight range around the stronghold.",
			isValid = null
		},
		{
			Name = "Militia Trainingcamp",
			ID = "attached_location.militia_trainingcamp",
			ConstID = "Militia_Trainingcamp",
			Cost = 0,
			Path = "militia_trainingcamp_location",
			Text = "Build a militia camp. Increases strength of mercenaries and number of recruits in the hamlet.",
			isValid = null
		},
		{
			Name = "Wheat Fields",
			ID = "attached_location.wheat_fields",
			ConstID = "Wheat_Fields",
			Cost = 0,
			Path = "wheat_fields_location",
			Text = "Build Wheat Fields. You don't consume food around the stronghold.",
			isValid = null
		},
		{
			Name = "Herbalists Grove",
			ID = "attached_location.herbalists_grove",
			ConstID = "Herbalists_Grove",
			Cost = 0,
			Path = "herbalists_grove_location",
			Text = "Build a Herbalists Grove. Hitpoints regenerate faster when around the stronghold.",
			isValid = null
		},
		{
			Name = "Gold Mine",
			ID = "attached_location.gold_mine",
			ConstID = "Gold_Mine",
			Cost = 0,
			Path = "gold_mine_location",
			Text = "Build a gold mine. Gold will be generated over time.",
			isValid = null
		}
	]

	foreach(location in gt.Stronghold.Location_options)
	{
		location.Cost = this.Stronghold.Locations[location.ConstID].Cost;
		if(location.isValid == null)
		{
			location.isValid = function(_contract)
			{
				return this.Stronghold.Locations[this.ConstID].MaxAmount > this.getHome().countAttachedLocations(this.ID)
			}.bindenv(location)
		}
	}
}