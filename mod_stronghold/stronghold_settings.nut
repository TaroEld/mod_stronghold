
::Stronghold.BaseFight <- {
	// Base difficulty of the base defence fight
	BaseDifficulty = 100
	// Extra difficulty for waves two, three, four of the higher upgrade levels
	WaveDifficulty = 75
}

::Stronghold.Misc <- {
	BaseAttacksEnabled = true,
	PriceMult = 1000,
	// Cost of each road segment
	RoadCost = 0.5,
	// Cost to make the raided debuff go away; multiplied with the price mult
	RaidedCostPerDay = 0.5,
	TrainerPrice = 20,
	TrainerBuffDurationInDays = 10,
	TrainerBuffDurationExpMult = 1.5,
	WaterPrice = 15,
	MercenaryPrice = 10,
	MercenaryFollowDays = 14,
	// Each level requires this much renown. This stacks with bases.
	RenownCost = 500,
	// Flat cost to send a gift caravan
	GiftFlatCost = 3,

}

::Stronghold.Hamlet <- {
	Name = "Hamlet"
}

::Stronghold.BaseTiers <- {};
::Stronghold.BaseTiers[1] <- {
	Name = "Outpost",
	Size = 1,
	Price = 5,
	MaxAttachedLocations = 4,
	MaxBuildings = 2,
	UnlockDescription = "You can construct up to two settlement buildings.\nYou can construct up to four locations, granting various advantages such as storing brothers and items.\nYou will be able to upgrade your base, unlocking more features.",
	EffectRadius = 7,
	Rarity = 1.00, // Rarity dictates the amount of items that spawn in shops, including named items
	BuyPrice = 1.05, // buy price of items, multiplier
	SellPrice = 0.95, // sell price of items, multiplier
	BattleCount = 1
};
::Stronghold.BaseTiers[2] <- {
	Name = "Fort",
	Size = 2,
	Price = 5,
	MaxAttachedLocations = 6,
	MaxBuildings = 3,
	EffectRadius = 9,
	Rarity = 1.04,
	BuyPrice = 1.00,
	SellPrice = 1.00,
	BattleCount = 2
};
::Stronghold.BaseTiers[3] <- {
	Name = "Castle",
	Size = 3,
	Price = 5,
	MaxAttachedLocations = 8,
	MaxBuildings = 4,
	EffectRadius = 11,
	Rarity = 1.08,
	BuyPrice = 0.95,
	SellPrice = 1.05,
	BattleCount = 3
};
::Stronghold.BaseTiers[4] <- {
	Name = "Stronghold",
	Size = 4,
	Price = 5,
	MaxAttachedLocations = 10,
	MaxBuildings = 5,
	EffectRadius = 13,
	Rarity = 1.12,
	BuyPrice = 0.9,
	SellPrice = 1.1,
	BattleCount = 4
};

// Cost for each building, multiplied by PriceMult (1000 by default)
::Stronghold.Buildings <-
{
	Tavern = {
		Price = 0,
	}
	Kennel = {
		Price = 2,
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
		Price = 2.5,
	}
	Port = {
		Price = 10,
	}
	Arena = {
		Price = 10
	}
	Crowd = {
		Price = 5
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
		Chance = 25, // percentage chance to get an item for each day
	},

	Gold_Mine = {
		Price = 2.5,
		UpgradePrice = 2.5
		DailyIncome = 100,
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
		DailyIncome = 50, // Amount of Experience generated each day
		AlliedPartyStrengthIncrease = 50, // Amount of strength added to new mercenary and caravan parties
		RecruitIncrease = 2 // Amount of recruits added to the Hamlet roster
	},

	Stone_Watchtower = {
		Price = 5,
		UpgradePrice = 1.5,
		VisionIncrease = 20, // Amount of extra vision you get around the base
		MovementSpeedIncrease = 0.05 // Amount of extra movement speed you get around the base, in pct
	},
	Troop_Quarters = {
		Price = 2.5,
		UpgradePrice = 2.5,
		MaxTroops = 6, // Max bros in the base
		// starts out at 60%, then 40%, 20%, 0%
		WageCost = 0.8,
		WageCostPerLevel = 0.2,
		MoodStateStart = ::Const.MoodState.Disgruntled,
		MoodStatePerLevel = 1,
		MoodChange = 0.5,
	}
	Warehouse = {
		Price = 2.5,
		UpgradePrice = 2.5,
		MaxItemSlots = 20, // Max slots in the warehouse per level
	}

	Wheat_Fields = {
		Price = 2.5,
		UpgradePrice = 2.5,
		StatGain = 1,
		EffectTime = 7,
	},

	Workshop = {
		Price = 5, // Price for each attached location, multiplied by PriceMult (1000 by default)
		UpgradePrice = 2.5,
		DailyIncome = 5, // Amount of tools generated every day
		MaxItemSlots = 35 // Amount added to the maximum amount of stored items of this type
	},
};

local settingsPage = ::Stronghold.Mod.ModSettings.addPage("Settings");

local keyInc = 0;
local function initDefs()
{
	foreach(locationID, location in ::Stronghold.LocationDefs)
	{
		location.ConstID <- locationID;
		location.ImagePath <- location.Path + ".png";
		location.Requirements <- [];
		::MSU.Table.merge(::Stronghold.Locations[locationID], location, true);
	}

	foreach(buildingID, building in ::Stronghold.BuildingDefs)
	{
		building.ConstID <- buildingID;
		::MSU.Table.merge(::Stronghold.Buildings[buildingID], building, true);
	}
}
::include(::Stronghold.ID + "/const/stronghold_building_defs.nut");
::include(::Stronghold.ID + "/const/stronghold_location_defs.nut");
initDefs();
::include(::Stronghold.ID + "/const/stronghold_settings_defs.nut");
local ref = ::Stronghold.SettingsDefs;
local refStack = [];
local function reduce(_arr, _key)
{
	if (_arr.len() == 0)
		return _key;
	local ret = "";
	foreach (entry in _arr)
	{
		ret += entry[1] + ".";
	}
	return ret.slice(0, ret.len() - 1) + "." + _key;
}
local createSettings;
createSettings = function(_container)
{
	foreach(key, value in _container)
	{
		if (!(key.tostring() in ref))
			continue;
		local keyID =  reduce(refStack, key);
		local keyClosure = key;
		local inner = ref[key.tostring()];
		switch (typeof value){
			case "string":
				local setting = settingsPage.addStringSetting(keyID, value, inner.SettingsName, inner.SettingsDescription);
				setting.addAfterChangeCallback(@(_value) _container[keyClosure] = this.getValue());
				break;
			case "bool":
				local setting = settingsPage.addBooleanSetting(keyID, value, inner.SettingsName, inner.SettingsDescription);
				setting.addAfterChangeCallback(@(_value) _container[keyClosure] = this.getValue());
				break;
			case "integer":
				local setting = settingsPage.addStringSetting(keyID, value.tostring(), inner.SettingsName, inner.SettingsDescription);
				setting.addAfterChangeCallback(@(_value) _container[keyClosure] = this.getValue().tointeger());
				break;
			case "float":
				local setting = settingsPage.addStringSetting(keyID, value.tostring(), inner.SettingsName, inner.SettingsDescription);
				setting.addAfterChangeCallback(@(_value) _container[keyClosure] = this.getValue().tofloat());
				break;
			case "array":
				local setting = settingsPage.addArraySetting(keyID, value, inner.SettingsName, inner.SettingsDescription);
				setting.addAfterChangeCallback(@(_value) _container[keyClosure] = this.getValue());
				break;
			case "table":
				settingsPage.addDivider( "divider2_" + keyID);
				settingsPage.addTitle( "section_" + keyID, inner.SettingsName);
				refStack.push([ref, key]);
				ref = inner;
				createSettings(value);
				ref = refStack.pop()[0];
			default:
				break;
		}
	}
}
createSettings(::Stronghold);
delete ::Stronghold.SettingsDefs;
refStack = null;
