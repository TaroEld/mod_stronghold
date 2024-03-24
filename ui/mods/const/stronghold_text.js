Stronghold.Text = {
	format : function(_string)
	{
		//adapted from https://coderwall.com/p/flonoa/simple-string-format-in-javascript
		var args = Array.prototype.slice.call(arguments, 1);
		for (k in args) {
			_string = _string.replace("{" + k + "}", args[k]);
		}
		return _string;
	},
	Error : "There was an error.",
	Price : "Price: {price}",
	Requirements : "Requirements",
	Advantages : "Advantages",
	General : {
		Tier1 : "Outpost",
		Tier2 : "Fort",
		Tier3 : "Castle",
		Tier4 : "Stronghold",
		Hamlet : "Hamlet",
		Mercenaries : "Mercenaries",
		Price : "Price: {0} crowns.",
	},
	HamletModule : {
		Title : "Build a Hamlet",
		Name : "Hamlet",
		Description : "A hamlet serves as additional living space for your retainers. You will be able to construct additional buildings, buy goods, and hire from a variety of recruits. Each base can only have one hamlet.",
		Requirements : {
			BaseSize : "Required base size: Stronghold (4/4)",
			MaxHamlet : "Maximum amount of Hamlets per base: 1"
		}
	},
	MainModule : {
		Title : "Overview",
		Assets : {
			Tier : "Tier",
			Defenders : "Defenders",
			Roster : "Local Roster",
			Stash : "Local Stash",
			Recruits : "Local Recruits",
			LastVisit : "Days since last visit",
			Gold : "Accumulated Gold",
			Tools : "Accumulated Tools",
			Medicine : "Accumulated Medicine",
			Arrows : "Accumulated Arrows",
		},
		BaseSettings : {
			AutoConsume : "Automatically take consumable items (tools, medicine, arrows, gold) from the base stash.",
			ShowBanner : "Show the banner of your base on the worldmap.",
		},
		RaidedTitle : "Raided",
		RaidedText : "Your base has recently been raided. It will take {0} days to clear out the rubble and make the base fully accessible. You can also pay {1} crowns to speed up the cleanup.",
		RaidedButton : "Pay {0} crowns"
	},
	MiscModule : {
		BuildRoad : {
			Title : "Build a road",
			Description : "Building a road to the road network allows your caravans to travel and your patrols to roam. You will also be able to send gifts to connected factions.",
			BuildTo : "Build Road to: ",
			Faction : "Faction: {0}",
			Distance : "Distance (by air): {0}",
			Segments : "Road Segments: {0}",
			Requirements : {
				BaseTier : "Upgrade your base to a {0} to be able to build roads to other settlements."
			}
		},
		SendGifts : {
			Title : "Send Gifts",
			Description : 'You can choose to send a delegation carrying gifts to a faction. This will consume the treasures you have in your warehouse, and will increase relations with that faction depending on the value of the gifts. The caravan will demand 5000 crowns to transport the goods.<br>The caravan will be traveling on roads towards the target town, and while it will be protected by a number of mercenaries, you might want to accompany it.',
			SendTo : "Send Gifts to: ",
			Requirements: {
				Faction : "At least one faction is connected to you by roads and not friendly",
				Price : "Price: {price} (for transportation of the gifts)",
				HaveGifts : "Have gifts (treasure items) in your warehouse.",
			},
			CurrentRelation : "Current relation: {num} ({numText})",
			TargetTown : "Target town: {town}",
			ReputationGain : "Reputation gained from the gifts: {reputation}",
			OnSend : "The caravan is traveling to {town}"
		},
		TrainBrother : {
			Title : "Train a brother",
			Description : "Provide focused training to one of your recruits which exceeds the skills of a Training Hall.",
			Invalid : "Nobody here can provide training beyond the services of a Training Hall.",
			Requirements : {
				FoundTrainer : "Find someone that can provide better training than a mere Training Hall.",
				Price : "Have sufficient money ({price})",
				ValidBrother : "Have at least one brother below level 11 that is not already under training."
			},
			ConfirmButton : "Train this brother",
			ChooseButton : "Choose brother"
		},
		BuyWater : {
			Title : "Buy a Water Skin",
			Description : "Buy a Water Skin with mythical properties.",
			Requirements : {
				Price : "Have sufficient money ({price})",
				Unlocked : "Recovered the recipe to create a mythical Water of Life."
			},
			ConfirmButton : "Buy the Water Skin",
		},
		HireMercenaries : {
			Title : "Hire Mercenaries",
			Description : "Hire a group of mercenaries to follow you in your travels. They will follow your party and join in any fights.",
			Requirements : {
				Price : "Have sufficient money ({price})",
				Unlocked : "You have attracted mercenary companies to hire.",
				NoMercenaries : "Currently have no mercenaries following you."
			},
			ConfirmButton : "Hire the mercenaries",
		},
		RemoveBase : {
			Title : "Remove your base",
			Description : "Remove this base and the connected Hamlet, if it exists. This action cannot be undone.",
			Requirements: {
				NoContract : "You can't have an active contract.",
			},
			Warning : "LAST WARNING! Are you sure you want to remove your base?"
		}
	},
	RosterModule : {},
	StashModule : {},
	StructureModule : {
		Build : "Build",
		Remove : "Remove",
		Upgrade : "Upgrade",
	},
	BuildingsModule : {
		Build : "Build",
		Remove : "Remove",
		Upgrade : "Upgrade",
	},
	LocationsModule : {
		Build : "Build",
		Upgrade : "Upgrade",
		Remove : "Remove",
		Level : " (Level: {0}/{1})",
		MaxForBaseLevel : "Your base tier ({0}) needs to be higher than the location level ({1})",
		MaxTotal : "Your base tier ({0}) can support up to {1} different locations. (Currently: {2})",
		MaxLevel : "You have reached the highest possible level for this location.",
	},
	VisualsModule : {
		Title : "Change Visuals",
		SpriteName : "{0} by {1}{2}", // name by author (current visuals)
		Current : " (current visuals)",
		Button : "Apply Sprites"
	},
	UpgradeModule : {
		Title : "Upgrade your base",
		Name : "Upgrade",
		Description : "Upgrade your base to unlock additional features. A base can have a total of four levels.",
		Requirements : {
			MaxSize : "Your base is fully upgraded!",
			Warehouse : "Your warehouse needs to be upgraded to the same level of the base.",
			Price : "Have sufficient money ({0})",
			NoContract : "You can't have an active contract.",
		},
		GeneralUnlockDescriptions : "Upgrade your {0} to a {1} to unlock the following features:<br>You can construct an additional building and two additional locations.<br>Locations can be upgraded a further level.<br>Buy and sell prices improve by 5%, and merchant stock increases in rarity and quantity.",
		UnlockDescriptions : {
			1 : "",
			2 : "You can construct roads to other settlements, connecting your base to the world.",
			3 : "A number of unique contracts will be made available.",
			4 : "A Hamlet will be built and connected to your base.",
		}
	},
	Buildings : {
		Tavern : {
			Name : "Tavern",
			Path : "tavern_building",
			SouthPath : false,
			Description : "A large tavern filled with patrons from all over the lands, offering beverages, food and a lively atmosphere in which to share news and rumors.",
		},
		Kennel : {
			Name : "Kennel",
			Description : "A kennel where strong and fast dogs are bred for war.",
			Path : "kennel_building",
			SouthPath : false,
		},
		Taxidermist : {
			Name : "Taxidermist",
			Description : "For the right price, a taxidermist can create useful items from all kinds of trophies you bring him.",
			Path : "taxidermist_building",
			SouthPath : "taxidermist_oriental_building",
		},
		Temple : {
			Name : "Temple",
			Description : "A refuge from the harsh world outside. You can seek healing here for your wounded and pray for salvation of your eternal soul.",
			Path : "temple_building",
			SouthPath : "temple_oriental_building",
		},
		Training_Hall : {
			Name : "Training Hall",
			Description : "A meeting point for those of the fighting profession. Have your men train with and learn from experienced fighters here, so you can mold them faster into hardened mercenaries.",
			Path : "training_hall_building",
			SouthPath : false,
		},
		Alchemist : {
			Name : "Alchemist",
			Description : "An alchemist offering exotic and quite dangerous contraptions for a tidy sum.",
			Path : "alchemist_building",
			SouthPath : false,
		},
		Weaponsmith : {
			Name : "Weaponsmith",
			Description : "A weapon smith\'s workshop displaying all kinds of well crafted weapons. Damaged equipment can also be repaired here for a price.",
			Path : "weaponsmith_building",
			SouthPath : "weaponsmith_oriental_building",
		},
		Armorsmith : {
			Name : "Armorsmith",
			Description : "This armorer\'s workshop is the right place to look for well-made and durable protection. Damaged equipment can also be repaired here for a price.",
			Path : "armorsmith_building",
			SouthPath : "armorsmith_oriental_building",
		},
		Fletcher : {
			Name : "Fletcher",
			Description : "A fletcher offering all kinds of expertly crafted ranged weaponry.",
			Path : "fletcher_building",
			SouthPath : false,
		},
		Port : {
			Name : "Port",
			Description : "A harbor that serves both foreign trading ships and local fishermen. You\'ll likely be able to book passage by sea to other parts of the continent here.",
			Path : "port_building",
			SouthPath : false,
			Requirements : [
				function (_element, _module){
					return {
						Text : Stronghold.Text.format("Required base size: {0} (4/4).", Stronghold.Text.General.Tier4),
						IsValid : _module.mData.TownAssets.Size == 4
					}
				}
			]
		},
		Arena : {
			Name : "Arena",
			Description : "The arena offers an opportunity to earn gold and fame in fights that are to the death, and in front of crowds that cheer for the most gruesome manner in which lives are dispatched.",
			Path : "arena_building",
			SouthPath : false,
			Requirements : [
				function (_element, _module){
					return {
						Text : "Live next to the sea.",
						IsValid : _module.mData.TownAssets.IsCoastal === true
					}
				}
			]

		},
		Barber : {
			Name : "Barber",
			Description : "Customize the appearance of your men at the barber. Have their hair cut and their beards trimmed or buy dubious potions to lose weight.",
			Path : "barber_building",
			SouthPath : false,
		},
	},
	Locations : {
		Warehouse : {
			Name : "Warehouse",
			Path : "warehouse_location",
			Description : "In the warehouse, you can store items. Each warehouse level increases its size by {0}. Upgrading the warehouse is necessary to upgrading your base.",
			getDescription : function(_element){
				return Stronghold.Text.format(this.Description,
				_element.MaxItemSlots)
			},
			getUpgradeDescription : function(_element){return "placeholder"}

		},
		Workshop : {
			Name : "Workshop",
			Path : "workshop_location",
			Description : "The workers at this workshop will create tools for your use. You can expect to receive {0} extra tools every day, and your warehouse will be able to store {1} more.",
			getDescription : function(_element){
				return Stronghold.Text.format(this.Description,
				_element.DailyIncome, _element.MaxItemSlots)
			},
			getUpgradeDescription : function(_element){return "placeholder"},
		},
		Ore_Smelter : {
			Name : "Ore Smelter",
			Path : "ore_smelters_location",
			Description : "This will allow the local weaponsmiths to carry more items. It will also allow them to work with unusual materials, allowing you to reforge named items.<br>To reforge a named item, put it in the warehouse and shift-rightclick on it.",
			getUpgradeDescription : function(_element){return "placeholder"},
		},
		Blast_Furnace : {
			Name : "Blast Furnace",
			Path : "blast_furnace_location",
			Description : "This will allow the local armorsmiths to carry more items. It will also enable them to repair your armors more efficiently, giving you a {0}% discount per level on repairing armor at the armorsmith.",
			getDescription : function(_element){
				return Stronghold.Text.format(this.Description,
					parseInt(_element.RepairMultiplier * 100))
			},
			getUpgradeDescription : function(_element){return "placeholder"},
		},
		Stone_Watchtower : {
			Name : "Stone Watchtower",
			Path : "stone_watchtower_location",
			Description : "By building this, you will be informed about other entities that wander around the base. Your party will also move faster and see further when close to the base.",
			getUpgradeDescription : function(_element){return "placeholder"},
		},
		Troop_Quarters : {
			Name : "Troop Quarters",
			Path : "troop_quarters_location",
			Description : "This location provides housing for your brothers. Each level allows you to leave up to {0} brothers at your base.",
			getDescription : function(_element)
			{
				return Stronghold.Text.format(this.Description, _element.MaxTroops)
			},
			getUpgradeDescription : function(_element){return "placeholder"},
		},
		Militia_Trainingcamp : {
			Name : "Militia Trainingcamp",
			Path : "militia_trainingcamp_location",
			Description : "This trainingcamp will allow the fresh recruits that you leave behind to train and become more experienced. Each trainingcamp generates {0} experience per day, which is divided over all stored brothers below level {1}.<br>Your allied mercenaries will also train here, increasing the strength of mercenary parties and caravans.<br>If you build a hamlet, each trainingcamp will also increase the amount of recruits that will line up to join you by {2}.",
			getDescription : function(_element)
			{
				return Stronghold.Text.format(this.Description, _element.DailyIncome, _element.MaxBrotherExpLevel + 1, _element.RecruitIncrease)
			},
			getUpgradeDescription : function(_element){return "placeholder"},
		},
		Wheat_Fields : {
			Name : "Wheat Fields",
			Path : "wheat_fields_location",
			Description : "This will allow your base to feed your men while close by. You don't consume any food when around the base.",
			getUpgradeDescription : function(_element){return "placeholder"},
		},
		Herbalists_Grove : {
			Name : "Herbalists Grove",
			Path : "herbalists_grove_location",
			Description : "The wise women of the herbalists grove know how to treat wounds with special and curious methods. Hitpoints regenerate faster when around the base.<br>You can also expect to receive {0} extra medicine every day, and your warehouse will be able to store {1} more.",
			getDescription : function(_element)
			{
				return Stronghold.Text.format(this.Description, _element.DailyIncome, _element.MaxItemSlots)
			},
			getUpgradeDescription : function(_element){return "placeholder"},
		},
		Gold_Mine : {
			Name : "Gold Mine",
			Path : "gold_mine_location",
			Description : "Hire miners to dig greedily and deeply. The resulting gold will be minted into spendable currency, generating {0} crowns per level a day.",
			getDescription : function(_element)
			{
				return Stronghold.Text.format(this.Description, _element.DailyIncome)
			},
			getUpgradeDescription : function(_element){return "placeholder"},
		}
	}
}
