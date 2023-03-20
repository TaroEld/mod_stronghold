::Stronghold.BuildingDefs <-
{
	Tavern = {
		Name = "Tavern",
		ID = "building.tavern",
		Path = "tavern_building",
		SouthPath = "",
		Description = "A large tavern filled with patrons from all over the lands, offering beverages, food and a lively atmosphere in which to share news and rumors.",
		Requirements = []
	},
	Kennel = {
		Name = "Kennel",
		Description = "A kennel where strong and fast dogs are bred for war.",
		ID = "building.kennel",
		Path = "kennel_building",
		SouthPath = "",
		Requirements = []
	},
	Taxidermist = {
		Name = "Taxidermist",
		Description = "For the right price, a taxidermist can create useful items from all kinds of trophies you bring him.",
		ID = "building.taxidermist",
		SouthID = "building.taxidermist_oriental",
		Path = "taxidermist_building",
		SouthPath = "taxidermist_oriental_building",
		Requirements = []
	},
	Temple = {
		Name = "Temple",
		Description = "A refuge from the harsh world outside. You can seek healing here for your wounded and pray for salvation of your eternal soul.",
		ID = "building.temple",
		SouthID = "building.temple",
		Path = "temple_building",
		SouthPath = "temple_oriental_building",
		Requirements = []
	},
	Training_Hall = {
		Name = "Training Hall",
		Description = "A meeting point for those of the fighting profession. Have your men train with and learn from experienced fighters here, so you can mold them faster into hardened mercenaries.",
		ID = "building.training_hall",
		Path = "training_hall_building",
		SouthPath = "",
		Requirements = []
	},
	Alchemist = {
		Name = "Alchemist",
		Description = "An alchemist offering exotic and quite dangerous contraptions for a tidy sum.",
		ID = "building.alchemist",
		Path = "alchemist_building",
		SouthPath = "",
		Requirements = []
	},
	Weaponsmith = {
		Name = "Weaponsmith",
		Description = "A weapon smith\'s workshop displaying all kinds of well crafted weapons. Damaged equipment can also be repaired here for a price.",
		ID = "building.weaponsmith",
		SouthID = "building.weaponsmith_oriental",
		Path = "weaponsmith_building",
		SouthPath = "weaponsmith_oriental_building",
		Requirements = []
	},
	Armorsmith = {
		Name = "Armorsmith",
		Description = "This armorer\'s workshop is the right place to look for well-made and durable protection. Damaged equipment can also be repaired here for a price.",
		ID = "building.armorsmith",
		SouthID = "building.armorsmith_oriental",
		Path = "armorsmith_building",
		SouthPath = "armorsmith_oriental_building",
		Requirements = []
	},
	Fletcher = {
		Name = "Fletcher",
		Description = "A fletcher offering all kinds of expertly crafted ranged weaponry.",
		ID = "building.fletcher",
		Path = "fletcher_building",
		SouthPath = "",
		Requirements = []
	},
	Port = {
		Name = "Port",
		Description = "A harbor that serves both foreign trading ships and local fishermen. You\'ll likely be able to book passage by sea to other parts of the continent here.",
		ID = "building.port",
		Path = "port_building",
		SouthPath = "",
		Requirements =
		[{
			Text = "Live next to the sea.",
			IsValid = @(_town) _town.isCoastal()
		}]
	},
	Arena = {
		Name = "Arena",
		Description = "The arena offers an opportunity to earn gold and fame in fights that are to the death, and in front of crowds that cheer for the most gruesome manner in which lives are dispatched.",
		ID = "building.arena",
		Path = "arena_building",
		SouthPath = "",
		Requirements =
		[{
			Text = "Required base size: Stronghold (3/3).",
			IsValid = @(_town) _town.getSize() == 3
		}]

	},
	Barber = {
		Name = "Barber",
		Description = "Customize the appearance of your men at the barber. Have their hair cut and their beards trimmed or buy dubious potions to lose weight.",
		ID = "building.barber",
		Path = "barber_building",
		SouthPath = "",
		Requirements = []
	},
}
foreach(buildingID, building in ::Stronghold.BuildingDefs)
{
	::MSU.Table.merge(building, ::Stronghold.Buildings[buildingID]);
}
