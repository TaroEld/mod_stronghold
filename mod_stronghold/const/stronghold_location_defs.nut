::Stronghold.LocationDefs <-
{
	Workshop = {
		Name = "Workshop",
		ID = "attached_location.workshop",
		ConstID = "Workshop",
		Cost = 0, //cost is set below this array
		Path = "workshop_location",
		Description = format("The workers at this workshop will create tools for your use. You can expect to receive %i extra tools every day, and your warehouse will be able to store %i more.",
			::Stronghold.Locations["Workshop"].DailyIncome, ::Stronghold.Locations["Workshop"].MaxItemSlots),
		Requirements = []
	},
	Ore_Smelter = {
		Name = "Ore Smelter",
		ID = "attached_location.ore_smelters",
		ConstID = "Ore_Smelter",
		Cost = 0,
		Path = "ore_smelters_location",
		Description = "This will allow the local weaponsmiths to carry more items. It will also allow them to work with unusual materials, allowing you to reforge named items. \n To reforge a named item, put it in the warehouse and shift-rightclick on it.",
		Requirements = []
	},
	Blast_Furnace = {
		Name = "Blast Furnace",
		ID = "attached_location.blast_furnace",
		ConstID = "Blast_Furnace",
		Cost = 0,
		Path = "blast_furnace_location",
		Description = format("This will allow the local armorsmiths to carry more items. It will also enable them to repair your armors more efficiently, giving you a %i percent discount on repairing armor at the armorsmith.",
			((1 - ::Stronghold.Locations["Blast_Furnace"].RepairMultiplier)*100).tointeger()),
		Requirements = []
	},
	Stone_Watchtower = {
		Name = "Stone Watchtower",
		ID = "attached_location.stone_watchtower",
		ConstID = "Stone_Watchtower",
		Cost = 0,
		Path = "stone_watchtower_location",
		Description = "By building this, you will be informed about other entities that wander around the base. Your party will also move faster and see further when close to the base.",
		Requirements = []
	},
	Militia_Trainingcamp = {
		Name = "Militia Trainingcamp",
		ID = "attached_location.militia_trainingcamp",
		ConstID = "Militia_Trainingcamp",
		Cost = 0,
		Path = "militia_trainingcamp_location",
		Description = format("This trainingcamp will allow the fresh recruits that you leave behind to train and become more experienced. Each trainingcamp generates %i experience per day, which is divided over all stored brothers below level %i.<br>Your allied mercenaries will also train here, increasing the strength of mercenary parties and caravans.<br>If you build a hamlet, each trainingcamp will also increase the amount of recruits that will line up to join you by %i.",
				::Stronghold.Locations["Militia_Trainingcamp"].DailyIncome, ::Stronghold.Locations["Militia_Trainingcamp"].MaxBrotherExpLevel + 1, ::Stronghold.Locations["Militia_Trainingcamp"].RecruitIncrease),
		Requirements = []
	},
	Wheat_Fields = {
		Name = "Wheat Fields",
		ID = "attached_location.wheat_fields",
		ConstID = "Wheat_Fields",
		Cost = 0,
		Path = "wheat_fields_location",
		Description = "This will allow your base to feed your men while close by. You don't consume any food when around the base.",
		Requirements = []
	},
	Herbalists_Grove = {
		Name = "Herbalists Grove",
		ID = "attached_location.herbalists_grove",
		ConstID = "Herbalists_Grove",
		Cost = 0,
		Path = "herbalists_grove_location",
		Description = format("The wise women of the herbalists grove know how to treat wounds with special and curious methods. Hitpoints regenerate faster when around the base.<br>They will also gather herbal medicine for you. You can expect to receive %i extra medicine every day, and your warehouse will be able to store %i more.",
			::Stronghold.Locations["Herbalists_Grove"].DailyIncome, ::Stronghold.Locations["Herbalists_Grove"].MaxItemSlots),
		Requirements = []
	},
	Gold_Mine = {
		Name = "Gold Mine",
		ID = "attached_location.gold_mine",
		ConstID = "Gold_Mine",
		Cost = 0,
		Path = "gold_mine_location",
		Description = format("Hire miners to dig greedily and deep. The resulting gold will be minted into spendable currency, generating %i crowns a day.",
				::Stronghold.Locations["Gold_Mine"].DailyIncome),
		Requirements = []
	}
}

foreach(locationID, location in ::Stronghold.LocationDefs)
{
	location.Cost = ::Stronghold.Locations[locationID].Cost;
	location.MaxAmount <- ::Stronghold.Locations[locationID].MaxAmount;
	location.Requirements.push({
		Text = "Price: " + location.Cost * ::Stronghold.PriceMult,
		IsValid = @(_town) this.World.Assets.getMoney() >= ::Stronghold.Locations[locationID].Cost * ::Stronghold.PriceMult
	})
}
