::Stronghold.LocationDefs <-
{
	Blast_Furnace = {
		Name = "Blast Furnace",
		ID = "attached_location.blast_furnace",
		Path = "blast_furnace_location",
		Description = "The blast furnace produces the blazing temperatures needed to make the most durable of metal alloys. Handy armorsmiths will use these alloys to create sturdy armor in the nearest settlement."
	},
	Collector = {
		Name = "Collector",
		ID = "attached_location.collector",
		Path = "collector_location",
		Description = "The collector gathers common and rare substances from plants and creatures for use in crafting."
	}
	Gold_Mine = {
		Name = "Gold Mine",
		ID = "attached_location.gold_mine",
		Path = "gold_mine_location",
		Description = "A deep mine build atop a gold ore vein. This rare metal has a tendency to bring out the worst in people."
	}
	Ore_Smelter = {
		Name = "Ore Smelter",
		ID = "attached_location.ore_smelters",
		Path = "ore_smelters_location",
		Description = "The burning hot ore smelters produce high quality metal ingots used by able weapon smiths to create the most sophisticated of arms."
	},
	Stone_Watchtower = {
		Name = "Stone Watchtower",
		ID = "attached_location.stone_watchtower",
		Path = "stone_watchtower_location",
		Description = "A stone watchtower occupied by well trained soldiers on guard duty."
	},
	Militia_Trainingcamp = {
		Name = "Militia Trainingcamp",
		ID = "attached_location.militia_trainingcamp",
		Path = "militia_trainingcamp_location",
		Description = "A large compound of militia barracks. This camp will turn ordinary peasants into somewhat able soldiers that can defend their home and their loved ones."
	},
	Troop_Quarters = {
		Name = "Troop Quarters",
		ID = "attached_location.troop_quarters",
		Path = "troop_quarters_location",
		Description = "A collection of housing units, with space for unwashed mercenaries and their partners for the night."
	}
	Warehouse = {
		Name = "Warehouse",
		ID = "attached_location.warehouse",
		Path = "warehouse_location",
		Description = "A big warehouse, used to store various items and construction materials.",
	},
	Wheat_Fields = {
		Name = "Wheat Fields",
		ID = "attached_location.wheat_fields",
		Path = "wheat_fields_location",
		Description = "Golden wheat can be seen glistening in the sun from afar. Many people from the nearby settlement work here, farmhands and daytalers mostly."
	},
	Workshop = {
		Name = "Workshop",
		ID = "attached_location.workshop",
		Path = "workshop_location",
		Description = "The workshop is proficient in making all kinds of tools and other supplies needed to keep carts and machines working."
	},
}

foreach(locationID, location in ::Stronghold.LocationDefs)
{
	location.ConstID <- locationID;
	location.Requirements <- []
	::MSU.Table.merge(location, ::Stronghold.Locations[locationID]);
}
