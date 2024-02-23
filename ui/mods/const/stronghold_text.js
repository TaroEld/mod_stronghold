Stronghold.Text = {
	format : function(_string)
	{
		//adapted from https://coderwall.com/p/flonoa/simple-string-format-in-javascript
		var args = Array.prototype.slice.call(arguments, 1);
		for (k in args) {
			_string = _string.replace("{" + k + "}", args[k])
		}
		return _string
	},
	Error : "There was an error.",
	Price : "Price: {price}",
	Requirements : "Requirements",
	HamletModule : {
		Title : "Build a Hamlet",
		Name : "Hamlet",
		Description : "A hamlet serves as additional living space for your retainers. You will be able to construct additional buildings, buy goods, and hire from a variety of recruits. Each base can only have one hamlet.",
		Requirements : {
			BaseSize : "Required base size: Stronghold (3/3)",
			MaxHamlet : "Maximum amount of Hamlets per base: 1"
		}
	},
	MainModuleModule : {},
	MiscModule : {
		BuildRoad : {
			Title : "Build a road",
			Description : "Building a road to the road network allows your caravans to travel and your patrols to roam. You will also be able to send gifts to connected factions.",
			BuildTo : "Build Road to: "
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
				NotUpgrading : "You can't be upgrading your base.",
			},
			Warning : "LAST WARNING! Are you sure you want to remove your base?"
		}
	},
	RosterModule : {},
	StashModule : {},
	StructureModule : {
		Build : "Build",
		Remove : "Remove",
	},
	BuildingsModule : {
		Build : "Build",
		Remove : "Remove",
	},
	LocationsModule : {
		MaxTotal : "Maximum amount of locations for this base level: {0} / {1}",
		MaxType : "Maximum amount of locations of this type: {0} / {1}",
		Build : "Build",
		Remove : "Remove",
	},
	VisualsModule : {},
	UpgradeModule : {
		Title : "Upgrade your base",
		Name : "Upgrade",
		Description : "A hamlet serves as additional living space for your retainers. You will be able to construct additional buildings, buy goods, and hire from a variety of recruits. Each base can only have one hamlet.",
		Requirements : {
			BaseSize : "Required base size: Stronghold (3/3)",
			MaxHamlet : "Maximum amount of Hamlets per base: 1"
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
						Text : "Required base size: Stronghold (3/3).",
						IsValid : _module.mData.TownAssets.Size == 3
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
		Build : "Build",
		Remove : "Remove",
		Workshop : {
			Name : "Workshop",
			Path : "workshop_location",
			Description : "",
			getDescription : function(_element){
				return Stronghold.Text.format("The workers at this workshop will create tools for your use. You can expect to receive {0} extra tools every day, and your warehouse will be able to store {1} more.",
				_element.DailyIncome, _element.MaxItemSlots)
			},

		},
		Ore_Smelter : {
			Name : "Ore Smelter",
			Path : "ore_smelters_location",
			Description : "This will allow the local weaponsmiths to carry more items. It will also allow them to work with unusual materials, allowing you to reforge named items. \n To reforge a named item, put it in the warehouse and shift-rightclick on it.",

		},
		Blast_Furnace : {
			Name : "Blast Furnace",
			Path : "blast_furnace_location",
			Description : "This will allow the local armorsmiths to carry more items. It will also enable them to repair your armors more efficiently, giving you a {0}% discount on repairing armor at the armorsmith.",
			getDescription : function(_element){
				return Stronghold.Text.format(this.Description,	parseInt(_element.RepairMultiplier * 100))
			}

		},
		Stone_Watchtower : {
			Name : "Stone Watchtower",
			Path : "stone_watchtower_location",
			Description : "By building this, you will be informed about other entities that wander around the base. Your party will also move faster and see further when close to the base.",

		},
		Militia_Trainingcamp : {
			Name : "Militia Trainingcamp",
			Path : "militia_trainingcamp_location",
			Description : "This trainingcamp will allow the fresh recruits that you leave behind to train and become more experienced. Each trainingcamp generates {0} experience per day, which is divided over all stored brothers below level {1}.<br>Your allied mercenaries will also train here, increasing the strength of mercenary parties and caravans.<br>If you build a hamlet, each trainingcamp will also increase the amount of recruits that will line up to join you by {2}.",
			getDescription : function(_element)
			{
				return Stronghold.Text.format(this.Description, _element.DailyIncome, _element.MaxBrotherExpLevel + 1, _element.RecruitIncrease)
			}

		},
		Wheat_Fields : {
			Name : "Wheat Fields",
			Path : "wheat_fields_location",
			Description : "This will allow your base to feed your men while close by. You don't consume any food when around the base.",

		},
		Herbalists_Grove : {
			Name : "Herbalists Grove",
			Path : "herbalists_grove_location",
			Description : "The wise women of the herbalists grove know how to treat wounds with special and curious methods. Hitpoints regenerate faster when around the base.<br>You can also expect to receive {0} extra medicine every day, and your warehouse will be able to store {1} more.",
			getDescription : function(_element)
			{
				return Stronghold.Text.format(this.Description,	_element.DailyIncome, _element.MaxItemSlots)
			}

		},
		Gold_Mine : {
			Name : "Gold Mine",
			Path : "gold_mine_location",
			Description : "Hire miners to dig greedily and deep. The resulting gold will be minted into spendable currency, generating {0} crowns a day.",
			getDescription : function(_element)
			{
				return Stronghold.Text.format(this.Description, _element.DailyIncome)
			}

		}
	}
}
