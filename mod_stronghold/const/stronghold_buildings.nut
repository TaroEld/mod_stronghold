::Stronghold.BuildingDefs <-
{
	Tavern = {
		Name = "Tavern",
		ID = "building.tavern",
		Cost = this.Stronghold.BuildingPrices["Tavern"],
		Path = "tavern_building",
		SouthPath = false,
		Description = "A large tavern filled with patrons from all over the lands, offering beverages, food and a lively atmosphere in which to share news and rumors.",
		Requirements = []
	},
	Kennel = {
		Name = "Kennel",
		Description = "A kennel where strong and fast dogs are bred for war.",
		ID = "building.kennel",
		Cost = this.Stronghold.BuildingPrices["Kennel"],
		Path = "kennel_building",
		SouthPath = false,
		Requirements = []
	},
	Taxidermist = {
		Name = "Taxidermist",
		Description = "For the right price, a taxidermist can create useful items from all kinds of trophies you bring him.",
		ID = "building.taxidermist",
		SouthID = "building.taxidermist_oriental",
		Cost = this.Stronghold.BuildingPrices["Taxidermist"],
		Path = "taxidermist_building",
		SouthPath = "taxidermist_oriental_building",
		Requirements = []
	},
	Temple = {
		Name = "Temple",
		Description = "A refuge from the harsh world outside. You can seek healing here for your wounded and pray for salvation of your eternal soul.",
		ID = "building.temple",
		SouthID = "building.temple",
		Cost = this.Stronghold.BuildingPrices["Temple"],
		Path = "temple_building",
		SouthPath = "temple_oriental_building",
		Requirements = []
	},
	Training_Hall = {
		Name = "Training Hall",
		Description = "A meeting point for those of the fighting profession. Have your men train with and learn from experienced fighters here, so you can mold them faster into hardened mercenaries.",
		ID = "building.training_hall",
		Cost = this.Stronghold.BuildingPrices["Training_Hall"],
		Path = "training_hall_building",
		SouthPath = false,
		Requirements = []
	},
	Alchemist = {
		Name = "Alchemist",
		Description = "An alchemist offering exotic and quite dangerous contraptions for a tidy sum.",
		ID = "building.alchemist",
		Cost = this.Stronghold.BuildingPrices["Alchemist"],
		Path = "alchemist_building",
		SouthPath = false,
		Requirements = []
	},
	Weaponsmith = {
		Name = "Weaponsmith",
		Description = "A weapon smith\'s workshop displaying all kinds of well crafted weapons. Damaged equipment can also be repaired here for a price.",
		ID = "building.weaponsmith",
		SouthID = "building.weaponsmith_oriental",
		Cost = this.Stronghold.BuildingPrices["Weaponsmith"],
		Path = "weaponsmith_building",
		SouthPath = "weaponsmith_oriental_building",
		Requirements = []
	},
	Armorsmith = {
		Name = "Armorsmith",
		Description = "This armorer\'s workshop is the right place to look for well-made and durable protection. Damaged equipment can also be repaired here for a price.",
		ID = "building.armorsmith",
		SouthID = "building.armorsmith_oriental",
		Cost = this.Stronghold.BuildingPrices["Armorsmith"],
		Path = "armorsmith_building",
		SouthPath = "armorsmith_oriental_building",
		Requirements = []
	},
	Fletcher = {
		Name = "Fletcher",
		Description = "A fletcher offering all kinds of expertly crafted ranged weaponry.",
		ID = "building.fletcher",
		Cost = this.Stronghold.BuildingPrices["Fletcher"],
		Path = "fletcher_building",
		SouthPath = false,
		Requirements = []
	},
	Port = {
		Name = "Port",
		Description = "A harbor that serves both foreign trading ships and local fishermen. You\'ll likely be able to book passage by sea to other parts of the continent here.",
		ID = "building.port",
		Cost = this.Stronghold.BuildingPrices["Port"],
		Path = "port_building",
		SouthPath = false,
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
		Cost = this.Stronghold.BuildingPrices["Arena"],
		Path = "arena_building",
		SouthPath = false,
		Requirements =
		[{
			Text = "Upgrade your base to a Stronghold.",
			IsValid = @(_town) _town.getSize() == 3
		}]

	},
	Barber = {
		Name = "Barber",
		Description = "Customize the appearance of your men at the barber. Have their hair cut and their beards trimmed or buy dubious potions to lose weight.",
		ID = "building.barber",
		Cost = this.Stronghold.BuildingPrices["Barber"],
		Path = "barber_building",
		SouthPath = false,
		Requirements = []
	},
}
foreach(buildingID, building in ::Stronghold.BuildingDefs)
{
	building.Requirements.push({
		Text = "Cost: " + ::Stronghold.BuildingPrices[buildingID] * ::Stronghold.PriceMult,
		IsValid = @(_town) this.World.Assets.getMoney() >= ::Stronghold.BuildingPrices[buildingID] * ::Stronghold.PriceMult
	})

}
