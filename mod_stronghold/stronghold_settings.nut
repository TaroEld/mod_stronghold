
// General multiplier for crown values of prices
::Stronghold.PriceMult <- 1000; 

// Maximum amount of attachments per level
::Stronghold.MaxAttachments <- [3, 6, 9]; 

// Max amount of main bases, essentially infinite at the moment
::Stronghold.MaxStrongholdNumber <- 999; 

// How much renown is required to build the next main base, maxes out at 15000 
::Stronghold.RenownPerLevel <- [
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
::Stronghold.InitialFightBaseStrength <- 70; 

// Extra difficulty added per base you already have, includes the first one
::Stronghold.InitialFightStrengthPerMainBase <- 50; 

// Extra difficulty based on the target level
::Stronghold.InitialFightStrengthPerTargetLevel <- 30; 

// Extra difficulty for waves two and three of the higher upgrade levels
::Stronghold.InitialFightStrengthPerWave <- 30; 

::Stronghold.getBaseFightDifficulty <- function(_contract)
{
	local wave = _contract.m.TargetLevel / _contract.m.AttacksRemaining;
	local numBases = this.Stronghold.getPlayerFaction().getMainBases().len();
	local difficulty = this.Stronghold.InitialFightBaseStrength;
	difficulty += this.Stronghold.InitialFightStrengthPerTargetLevel * _contract.m.TargetLevel;
	difficulty += this.Stronghold.InitialFightStrengthPerWave * wave;
	difficulty += this.Stronghold.InitialFightStrengthPerMainBase * numBases;
	difficulty = ((difficulty / 2) * _contract.getScaledDifficultyMult()) + (difficulty / 2);
	return difficulty
}

// Effect of the well supplied buff that is activated by default
// Rarity dictates the amount of items that spawn in shops, including named items
::Stronghold.WellSupplied <-
[
	{
		Rarity = 1.04,
		BuyPrice = 1.00,
		SellPrice = 1.00
	},
	{
		Rarity = 1.08,
		BuyPrice = 0.95,
		SellPrice = 1.05
	},
	{
		Rarity = 1.12,
		BuyPrice = 0.9,
		SellPrice = 1.1
	}
]

// Cost of each road segment
::Stronghold.RoadCost <- 0.5; 

// Daily production of each item. Note that this is the 'amount' value; one item of tools has an amount of 25, medicine 20, and ammo 50.
::Stronghold.ToolsPerDay <- 9;
::Stronghold.MedicinePerDay <- 7;
::Stronghold.AmmoPerDay <- 20;

// Maximum amount of each item that can be stored in the warehouse. Also the 'amount' value.
::Stronghold.MaxAmountOfStoredTools <- 150;
::Stronghold.MaxAmountOfStoredMedicine <- 100;
::Stronghold.MaxAmountOfStoredAmmo <- 300;

::Stronghold.Tiers <-
{
	1 = {
		Name = "Fort",
		Size = 1,
		Price = 10,
		MaxAttachments = 3,
		UnlockDescription = "You can leave items and brothers behind, to retrieve them later as you need them.\n You can construct up to three settlement buildings.\nYou can construct up to three locations, granting various advantages.\n You will be able to upgrade your base, unlocking more features.",
	},
	2 = {
		Name = "Castle",
		Size = 2,
		Price = 20,
		MaxAttachments = 6,
		UnlockDescription = "Bands of mercenaries will join your base and guard it against aggressors.\nYou can construct an additional building and three additional locations.\nYou can construct roads to other settlements, connecting your base to the world.",
	},
	3 = {
		Name = "Stronghold",
		Size = 3,
		Price = 30,
		MaxAttachments = 9,
		UnlockDescription = "You can construct an additional building, including an arena, and three additional locations.\nA number of unique contracts will be made available.\nYou can now construct the Hamlet, a town which is connected to your Stronghold.",
	},
}

// Name of the hamlet used in descriptions
::Stronghold.HamletName <- "Hamlet" 

// Cost for each building, multiplied by PriceMult (1000 by default)
::Stronghold.BuildingPrices <-
{
	Tavern = 5,
	Kennel = 5,
	Taxidermist = 5,
	Temple = 5,
	Training_Hall = 5,
	Alchemist = 5,
	Barber = 1,
	Weaponsmith = 10,
	Armorsmith = 10,
	Fletcher = 10,
	Port = 15,
	Arena = 20
};


// Change settings related to attached locations
::Stronghold.Locations <-
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
