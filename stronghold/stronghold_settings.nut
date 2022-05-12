local gt = this.getroottable();

// General multiplier for crown values of prices
gt.Stronghold.PriceMult <- 1000; 

// Base price to build / upgrade / upgrade
gt.Stronghold.BuyPrices <- [10, 20, 20]; 

// Maximum amount of attachments per level
gt.Stronghold.MaxAttachments <- [3, 6, 9]; 

// Max amount of main bases, essentially infinite at the moment
gt.Stronghold.MaxStrongholdNumber <- 999; 

// How much renown is required to build the next main base, maxes out at 15000 
gt.Stronghold.RenownPerLevel <- [
		500,
		1500,
		3000,
		5000,
		7000,
		9000,
		11000,
		13000,
		15000
]

// Base difficulty of the base defence fight
gt.Stronghold.InitialFightBaseStrength <- 50; 

// Extra difficulty added per base you already have, includes the first one
gt.Stronghold.InitialFightStrengthPerMainBase <- 50; 

// Extra difficulty based on the target level
gt.Stronghold.InitialFightStrengthPerTargetLevel <- 30; 

// Extra difficulty for waves two and three of the higher upgrade levels
gt.Stronghold.InitialFightStrengthPerWave <- 30; 




// Cost of each road segment
gt.Stronghold.RoadCost <- 0.5; 

// Daily production of each item. Note that this is the 'amount' value; one item of tools has an amount of 25, medicine 20, and ammo 50.
gt.Stronghold.ToolsPerDay <- 9;
gt.Stronghold.MedicinePerDay <- 7;
gt.Stronghold.AmmoPerDay <- 20;

// Maximum amount of each item that can be stored in the warehouse. Also the 'amount' value.
gt.Stronghold.MaxAmountOfStoredTools <- 150;
gt.Stronghold.MaxAmountOfStoredMedicine <- 100;
gt.Stronghold.MaxAmountOfStoredAmmo <- 300;


// Base name for each tier, used in descriptions
gt.Stronghold.BaseNames <- [
	"Fort",
	"Castle",
	"Stronghold"
]

// Name of the hamlet used in descriptions
gt.Stronghold.HamletName <- "Hamlet" 

// Cost for each building, multiplied by PriceMult (1000 by default)
gt.Stronghold.BuildingPrices <- 
{
	Tavern = 5,
	Kennel = 5,
	Taxidermist = 5,
	Temple = 5, 
	Training = 5,
	Alchemist = 5,
	Weaponsmith = 10,
	Armorsmith = 10,
	Fletcher = 10,
	Port = 15,
	Arena = 20
};


// Change settings related to attached locations
gt.Stronghold.Locations <-
{
	Workshop = {
		Cost = 10, // Cost for each attached location, multiplied by PriceMult (1000 by default)
		MaxAmount = 1, // Maximum amount allowed per base
		DailyIncome = 20, // Amount of tools generated every day
		MaxItemSlots = 40 // Amount added to the maximum amount of stored items of this type
	},

	Ore_Smelter = {
		Cost = 10,
		MaxAmount = 1,
		ReforgeMultiplier = 1.5 // Price multiplier applied on the base value of the item being reforged
	},

	Blast_Furnace = {
		Cost = 5,
		MaxAmount = 1,
		RepairMultiplier = 0.7 // Value by which instant repair will be multiplied
	},

	Stone_Watchtower = {
		Cost = 10,
		MaxAmount = 1,
		VisionInFogOfWarRange = 15, // Range in which you can see enemies in fog of war
		EffectRange = 25, // Distance in tiles for which the next two effects work
		VisionIncrease = 125, // Amount of extra vision you get around the base
		MovementSpeedIncrease = 9 // Amount of extra movement speed you get around the base
	},

	Militia_Trainingcamp = {
		Cost = 10,
		MaxAmount = 3,
		MaxBrotherExpLevel = 7, //
		DailyIncome = 200, // Amount of Experience generated each day
		MercenaryStrengthIncrease = 100, // Amount of strength added to new mercenary and caravan parties
		RecruitIncrease = 2 // Amount of recruits added to the Hamlet roster
	},

	Wheat_Fields = {
		Cost = 5,
		MaxAmount = 1,
		EffectRange = 25, // Distance in tiles for which the effect works
	},

	Herbalists_Grove = {
		Cost = 5,
		MaxAmount = 1,
		DailyIncome = 20, // Amount of extra medicine generated every day
		MaxItemSlots = 40, // Amount added to the maximum amount of stored items of this type
		EffectRange = 25, // Distance in tiles for which the effect works
	},

	Gold_Mine = {
		Cost = 10,
		MaxAmount = 1,
		DailyIncome = 150,
		AddGoldDirectlyToAssets = false // Add gold generated in base directly to the asset crowns on base enter instead of creating a crowns item
	}
};
