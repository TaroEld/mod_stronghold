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
			Text = format("The workers at this workshop will create tools for your use. You can expect to receive %i extra tools every day, and your warehouse will be able to store %i more.", 
				gt.Stronghold.Locations["Workshop"].DailyIncome, gt.Stronghold.Locations["Workshop"].MaxItemSlots),
			isValid = null //isValid is set below this array if null
		},
		{
			Name = "Ore Smelter",
			ID = "attached_location.ore_smelters",
			ConstID = "Ore_Smelter",
			Cost = 0,
			Path = "ore_smelters_location",
			Text = "This will allow the local weaponsmiths to carry more items. It will also allow them to work with unusual materials, allowing you to reforge named items. \n To reforge a named item, put it in the warehouse and shift-rightclick on it.",
			isValid = null
		},
		{
			Name = "Blast Furnace",
			ID = "attached_location.blast_furnace",
			ConstID = "Blast_Furnace",
			Cost = 0,
			Path = "blast_furnace_location",
			Text = format("This will allow the local armorsmiths to carry more items. It will also enable them to repair your armors more efficiently, giving you a %i percent discount on repairing armor at the armorsmith.",  
				((1 - gt.Stronghold.Locations["Blast_Furnace"].RepairMultiplier)*100).tointeger()),
			isValid = null
		},
		{
			Name = "Stone Watchtower",
			ID = "attached_location.stone_watchtower",
			ConstID = "Stone_Watchtower",
			Cost = 0,
			Path = "stone_watchtower_location",
			Text = "By building this, you will be informed about other entities that wander around the base. Your party will also move faster and see further when close to the base.",
			isValid = null
		},
		{
			Name = "Militia Trainingcamp",
			ID = "attached_location.militia_trainingcamp",
			ConstID = "Militia_Trainingcamp",
			Cost = 0,
			Path = "militia_trainingcamp_location",
			Text = format("This trainingcamp will allow the fresh recruits that you leave behind to train and become more experienced. Each trainingcamp generates %i experience per day, which is divided over all stored brothers below level 8.\nFurthermore, your allied mercenaries will also train here, increasing the strength of mercenary parties and caravans.\nIf you build a hamlet, each trainingcamp will also increase the amount of recruits that will line up to join you by %i.", 
					gt.Stronghold.Locations["Militia_Trainingcamp"].DailyIncome, gt.Stronghold.Locations["Militia_Trainingcamp"].RecruitIncrease),
			isValid = null
		},
		{
			Name = "Wheat Fields",
			ID = "attached_location.wheat_fields",
			ConstID = "Wheat_Fields",
			Cost = 0,
			Path = "wheat_fields_location",
			Text = "This will allow your base to feed your men while close by. You don't consume any food when around the base.",
			isValid = null
		},
		{
			Name = "Herbalists Grove",
			ID = "attached_location.herbalists_grove",
			ConstID = "Herbalists_Grove",
			Cost = 0,
			Path = "herbalists_grove_location",
			Text = "The wise women of the herbalists grove know how to treat wounds with special and curious methods. Hitpoints regenerate faster when around the stronghold.",
			isValid = null
		},
		{
			Name = "Gold Mine",
			ID = "attached_location.gold_mine",
			ConstID = "Gold_Mine",
			Cost = 0,
			Path = "gold_mine_location",
			Text = format("Hire miners to dig greedily and deep. The resulting gold will be minted into spendable currency, generating %i crowns a day.",
					gt.Stronghold.Locations["Gold_Mine"].DailyIncome),
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
				return this.Stronghold.Locations[this.ConstID].MaxAmount > _contract.getHome().countAttachedLocations(this.ID)
			}.bindenv(location)
		}
	}
}