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

// Cost of each road segment
gt.Stronghold.RoadCost <- 0.5; 


// Maximum amount of each item that can be produced and stored by the base
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
		DailyIncome = 40, // Amount of tools generated every three days
		MaxItemSlots = 40 // Amount added to the maximum amount of stored items of this type
	},
	Ore_Smelter = {
		Cost = 5,
		MaxAmount = 1,
	},
	Blast_Furnace = {
		Cost = 5,
		MaxAmount = 1,
	},
	Stone_Watchtower = {
		Cost = 10,
		MaxAmount = 1,
	},
	Militia_Trainingcamp = {
		Cost = 5,
		MaxAmount = 3,
		DailyIncome = 200
	},
	Wheat_Fields = {
		Cost = 5,
		MaxAmount = 1,
	},
	Herbalists_Grove = {
		Cost = 5,
		MaxAmount = 1,
	},
	Gold_Mine = {
		Cost = 10,
		MaxAmount = 1,
		DailyIncome = 150
	}
};
