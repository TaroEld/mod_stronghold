local gt = this.getroottable();
gt.Stronghold.loadSettings <- function()
{

	// This value determines whether more than one gold mine can be built per stronghold
	gt.Stronghold.AllowMoreThanOneGoldMine <- false; // Boolean value, true or false

	// This value determines how much gold does one goldmine contribute
	gt.Stronghold.DailyGoldPerGoldMine <- 150; // Integer value, any number

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

	// Cost for each attached location, multiplied by PriceMult (1000 by default)
	gt.Stronghold.LocationPrices <-
	{
		Workshop = 10,
		Ore = 5,
		Blast = 5,
		Stone = 10,
		Militia = 5,
		Wheat = 5,
		Herbalists = 5,
		Gold = 10
	};

	// Change settings related to attached locations
	gt.Stronghold.Locations <-
	{
		Workshop = {
			Cost = 10, // Cost for each attached location, multiplied by PriceMult (1000 by default)
			MaxAmount = 1, // Maximum amount allowed per base
			ToolsPerWorkshop = 2 // Amount of tools generated every three days
		}
		Ore_Smelter = 5,
		Blast_Furnace = 5,
		Stone_Watchtower = 10,
		Militia_Trainingcamp = 5,
		Wheat_Fields = 5,
		Herbalists_Grove = 5,
		Gold_Mine = {
			Cost = 10,
			MaxAmount = 1,
			GoldIncomePerMine = 150
		}
	};
}
