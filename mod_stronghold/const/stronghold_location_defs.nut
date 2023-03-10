::Stronghold.LocationDefs <-
{
	Workshop = {
		ID = "attached_location.workshop",
		Path = "workshop_location",
	},
	Ore_Smelter = {

		ID = "attached_location.ore_smelters",
		Path = "ore_smelters_location",
	},
	Blast_Furnace = {

		ID = "attached_location.blast_furnace",
		Path = "blast_furnace_location",
	},
	Stone_Watchtower = {

		ID = "attached_location.stone_watchtower",
		Path = "stone_watchtower_location",
	},
	Militia_Trainingcamp = {

		ID = "attached_location.militia_trainingcamp",
		Path = "militia_trainingcamp_location",
	},
	Wheat_Fields = {

		ID = "attached_location.wheat_fields",
		Path = "wheat_fields_location",
	},
	Herbalists_Grove = {

		ID = "attached_location.herbalists_grove",
		Path = "herbalists_grove_location",
	},
	Gold_Mine = {
		ID = "attached_location.gold_mine",
		Path = "gold_mine_location",
	}
}

foreach(locationID, location in ::Stronghold.LocationDefs)
{
	location.ConstID <- locationID;
	location.Requirements <- []
	::MSU.Table.merge(location, ::Stronghold.Locations[locationID]);
}
