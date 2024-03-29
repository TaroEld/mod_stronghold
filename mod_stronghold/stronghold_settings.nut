
// General multiplier for crown values of prices
::Stronghold.PriceMult <- 1000; 

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

// Cost of each road segment
::Stronghold.RoadCost <- 0.5; 

// Daily production of each item. Note that this is the 'amount' value; one item of tools has an amount of 25, medicine 20, and ammo 50.
::Stronghold.ToolsPerDay <- 9;
::Stronghold.MedicinePerDay <- 7;
::Stronghold.AmmoPerDay <- 20;

// Cost to make the raided debuff go away; multiplied with the price mult
::Stronghold.RaidedCostPerDay <- 0.5;

// Maximum amount of each item that can be stored in the warehouse. Also the 'amount' value.
::Stronghold.MaxAmountOfStoredTools <- 150;
::Stronghold.MaxAmountOfStoredMedicine <- 100;
::Stronghold.MaxAmountOfStoredAmmo <- 300;

::Stronghold.Tiers <- {};
::Stronghold.Tiers[1] <- {
	Name = "Outpost",
	Size = 1,
	Price = 5,
	MaxAttachments = 4,
	MaxBuildings = 3,
	UnlockDescription = "You can an additional settlement building.\nYou can construct up to four locations, granting various advantages such as storing brothers and items.\n You will be able to upgrade your base, unlocking more features.",
	ThreatRadius = 7,
	Rarity = 1.00, // Rarity dictates the amount of items that spawn in shops, including named items
	BuyPrice = 1.05, // buy price of items, multiplier
	SellPrice = 0.95 // sell price of items, multiplier
};
::Stronghold.Tiers[2] <- {
	Name = "Fort",
	Size = 2,
	Price = 5,
	MaxAttachments = 6,
	MaxBuildings = 4,
	UnlockDescription = "You can construct up to two settlement buildings.\nYou can construct up to eight locations.\nBands of mercenaries will join your base and guard it against aggressors.",
	ThreatRadius = 9,
	Rarity = 1.04,
	BuyPrice = 1.00,
	SellPrice = 1.00
};
::Stronghold.Tiers[3] <- {
	Name = "Castle",
	Size = 3,
	Price = 5,
	MaxAttachments = 8,
	MaxBuildings = 5,
	UnlockDescription = "You can construct up to three settlement buildings.\nYou can construct up to eight locations.\nYou can construct roads to other settlements, connecting your base to the world.",
	ThreatRadius = 11,
	Rarity = 1.08,
	BuyPrice = 0.95,
	SellPrice = 1.05
};
::Stronghold.Tiers[4] <- {
	Name = "Stronghold",
	Size = 4,
	Price = 5,
	MaxAttachments = 10,
	MaxBuildings = 6,
	UnlockDescription = "You can construct up to four settlement buildings, and unlock the arena building.\nYou can construct up to ten locations.\nA number of unique contracts will be made available.\nYou can now construct the Hamlet, a town which is connected to your Stronghold.",
	ThreatRadius = 13,
	Rarity = 1.12,
	BuyPrice = 0.9,
	SellPrice = 1.1
};

::Stronghold.TrainerPrice <- 5;
::Stronghold.WaterPrice <- 5;
::Stronghold.MercenaryPrice <- 5;

// Cost for each building, multiplied by PriceMult (1000 by default)
::Stronghold.Buildings <-
{
	Tavern = {
		Price = 0,
	}
	Kennel = {
		Price = 2.5,
	}
	Taxidermist = {
		Price = 5,
	}
	Temple = {
		Price = 5,
	}
	Training_Hall = {
		Price = 5,
	}
	Alchemist = {
		Price = 5,
	}
	Barber = {
		Price = 1,
	}
	Weaponsmith = {
		Price = 10,
	}
	Armorsmith = {
		Price = 10,
	}
	Fletcher = {
		Price = 5,
	}
	Port = {
		Price = 5,
	}
	Arena = {
		Price = 15
	}
};


// Change settings related to attached locations
::Stronghold.Locations <-
{
	Blast_Furnace = {
		Price = 2.5,
		UpgradePrice = 2.5
		RepairMultiplier = 0.1 // Value by which instant repair will be multiplied
	},

	Collector = {
		Price = 2.5,
		UpgradePrice = 2.5,
		Chance = 10, // percentage chance to get an item for each day
	},

	Gold_Mine = {
		Price = 2,
		UpgradePrice = 2
		DailyIncome = 50,
		AddGoldDirectlyToAssets = false // Add gold generated in base directly to the asset crowns on base enter instead of creating a crowns item
	},

	Herbalists_Grove = {
		Price = 2,
		UpgradePrice = 2,
		DailyIncome = 20, // Amount of extra medicine generated every day
		MaxItemSlots = 40, // Amount added to the maximum amount of stored items of this type
		EffectRange = 25, // Distance in tiles for which the effect works
	},

	Ore_Smelter = {
		Price = 5,
		UpgradePrice = 2.5
		ReforgeMultiplier = 0.1 // Price multiplier applied on the base value of the item being reforged, per level
	},


	Militia_Trainingcamp = {
		Price = 5,
		UpgradePrice = 2.5,
		MaxBrotherExpLevel = 7, //
		MaxBrotherExpLevelUpgrade = 1,
		DailyIncome = 200, // Amount of Experience generated each day
		MercenaryStrengthIncrease = 100, // Amount of strength added to new mercenary and caravan parties
		RecruitIncrease = 2 // Amount of recruits added to the Hamlet roster
	},

	Stone_Watchtower = {
		Price = 5,
		UpgradePrice = 1,
		EffectRange = 5, // Range in which you can see enemies in fog of war
		EffectRangePerLevel = 2, // same as threat radius increase per tier
		VisionIncrease = 30, // Amount of extra vision you get around the base
		MovementSpeedIncrease = 10 // Amount of extra movement speed you get around the base
	},
	Troop_Quarters = {
		Price = 2.5,
		UpgradePrice = 2.5,
		MaxTroops = 6, // Max bros in the base
		// starts out at 60%, then 40%, 20%, 0%
		WageCost = 0.8,
		WageCostPerLevel = 0.2
	}
	Warehouse = {
		Price = 2.5,
		UpgradePrice = 2.5,
		MaxItemSlots = 20, // Max slots in the warehouse per level
	}

	Wheat_Fields = {
		Price = 2.5,
		UpgradePrice = 2.5,
		EffectRange = 5, // Distance in tiles for which the effect works
		StatGain = 2,
		EffectTime = 7,
	},

	Workshop = {
		Price = 5, // Price for each attached location, multiplied by PriceMult (1000 by default)
		UpgradePrice = 2.5,
		DailyIncome = 20, // Amount of tools generated every day
		MaxItemSlots = 40 // Amount added to the maximum amount of stored items of this type
	},
};

foreach (locationID, location in ::Stronghold.Locations)
{
	location.Price *= ::Stronghold.PriceMult;
	location.UpgradePrice *= ::Stronghold.PriceMult;
}

foreach (locationID, location in ::Stronghold.Buildings)
{
	location.Price *= ::Stronghold.PriceMult;
}
