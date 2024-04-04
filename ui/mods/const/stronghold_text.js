Stronghold.Text = {
	format : function(_string)
	{
		//adapted from https://coderwall.com/p/flonoa/simple-string-format-in-javascript
		var args = Array.prototype.slice.call(arguments, 1);
		for (k in args) {
			_string = _string.replace("{" + k + "}", "<b>" + args[k] + "</b>");
		}
		return _string;
	},
	Error : "There was an error.",
	Requirements : "Requirements",
	Advantages : "Advantages",
	General : {
		Tier1 : "Outpost",
		Tier2 : "Fort",
		Tier3 : "Castle",
		Tier4 : "Stronghold",
		Hamlet : "Hamlet",
		Houses : "Houses",
		Mercenaries : "Mercenaries",
		Price : "Price: {0} crowns.",
	},
	MainModule : {
		Title : "Overview",
		LastEnterLog : {
			Days : "Days since last visit: {0}",
			Gold : "Accumulated gold: {0}",
			Tools : "Accumulated tools: {0}",
			Items : "Other accumulated items: {0}",
			Experience : "Experience gained: {0}",
		},
		BaseSettings : {
			ShowEffectRadius : "Show the effect radius of your base on the worldmap.",
			ShowBanner : "Show the banner of your base on the worldmap.",
		},
		RaidedTitle : "Raided",
		RaidedText : "Your base has recently been raided. It will take {0} days to clear out the rubble and make the base fully accessible. You can also pay {1} crowns to speed up the cleanup.",
		RaidedButton : "Pay {0} crowns",
		OverflowTitle : "Item overflow",
		OverflowText : "{0} items are overflowing your warehouse. Press this button to add them to your warehouse. <b>Beware!</b> You will need to make space for them, or they will be lost after you leave the base.",
		PopupButton : "Show items",
		OverflowButton : "Take items",
		UpgradingTitle : "Upgrading your base",
		UpgradingText : "While upgrading the base to the next level, many base features are unavailable. You can expect an attack every 12 to 24 hours, with each wave being stronger than the last.",
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
				ValidBrother : "Have at least one brother below level 11 that is not already under training."
			},
			ConfirmButton : "Train this brother",
			ChooseButton : "Choose brother"
		},
		BuyWater : {
			Title : "Buy a Water Skin",
			Description : "Buy a Water Skin with mythical properties.",
			Requirements : {
				Unlocked : "Recovered the recipe to create a mythical Water of Life."
			},
			ConfirmButton : "Buy the Water Skin",
		},
		HireMercenaries : {
			Title : "Hire Mercenaries",
			Description : "Hire a group of mercenaries to follow you in your travels. They will follow your party and join in any fights for a duration of two weeks.",
			Requirements : {
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
	RosterModule : {
		Attributes : "Attributes",
		Skills : "Skills",
		Portrait : "Portrait",
	},
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
		CurrentDetails : "Current level:<br>",
		NextDetails : "Next level:<br>",
	},
	VisualsModule : {
		Title : "Change Visuals",
		Spriteset : "{0} by {1}{2}", // name by author (current visuals)
		Current : " (current visuals)",
		Button : "Apply Sprites",
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
		UpgradeDescription : "Upgrade your {0} to a {1} to unlock the following features:",
		GeneralUnlockDescription : "<li>You can construct an additional building and two additional locations.</li><li>Locations can be upgraded a further level.</li><li>Buy and sell prices improve by 5%, and merchant stock increases in rarity and quantity.</li><li>The effect radius of your base increases.</li>",
		UnlockDescriptions : {
			1 : "<li></li>",
			2 : "<li>You can construct roads to other settlements, connecting your base to the world.</li>",
			3 : "<li>A number of unique contracts will be made available.</li>",
			4 : "<li>A Hamlet will be built and connected to your base.</li>",
		}
	},
	Locations : {
		Warehouse : {
			UpgradeDescription : {
				MaxItemSlots : "<li>Store up to {0} items in your base.</li>",
				UpgradeBase : "<li>Allows you to upgrade your base to level {0}.</li>"
			},
			getUpgradeDescription : function(_element, _level){
				return  Stronghold.Text.format(this.UpgradeDescription.UpgradeBase, _level) + Stronghold.Text.format(this.UpgradeDescription.MaxItemSlots, (_level + 1) * _element.MaxItemSlots);
			}

		},
		Collector : {
			UpgradeDescription : {
				Description : "<li>Each day, the collector has a {0}% chance to find items and add them to your base stash.</li>",
				Rarity : "<li>Upgrading the collector adds rarer items to the lootpool</li>",
			},
			getUpgradeDescription : function(_element, _level){
				return  Stronghold.Text.format(this.UpgradeDescription.Description, _element.Chance) + this.UpgradeDescription.Rarity;
			}
		},
		Workshop : {
			UpgradeDescription : {
				Amounts : "<li>The warehouse will produce {0} tools every day, and your warehouse will be able to store a total of {1}.</li>"
			},
			getUpgradeDescription : function(_element, _level){
				return  Stronghold.Text.format(this.UpgradeDescription.Amounts, _element.DailyIncome * _level, _element.MaxItemSlots * _level);
			},
		},
		Ore_Smelter : {
			UpgradeDescription : {
				Weaponsmith : "<li>The Ore Smelter increases the stock of items at a local weaponsmith.</li>",
				Reforge : "<li>You will be able to reforge named items, with a cost of {0}% of its base value. To reforge a named item, put it in the warehouse and shift-rightclick on it.</li>"
			},
			getUpgradeDescription : function(_element, _level){
				return  this.UpgradeDescription.Weaponsmith +  Stronghold.Text.format(this.UpgradeDescription.Reforge, parseInt((1 - _element.ReforgeMultiplier * _level) * 100));
			},
		},
		Blast_Furnace : {
			UpgradeDescription : {
				Armorsmith : "<li>The Blast Furnace increases the stock of items at a local armorsmith.</li>",
				RepairMultiplier : "<li>Item repair costs will be reduced by {0}%.</li>"
			},
			getUpgradeDescription : function(_element, _level){
				return  this.UpgradeDescription.Armorsmith + Stronghold.Text.format(this.UpgradeDescription.RepairMultiplier,  parseInt(_element.RepairMultiplier * _level * 100));
			},
		},
		Stone_Watchtower : {
			UpgradeDescription : {
				FOV : "<li>Reveals enemies in fog of war around the base, and warns you of incoming attacks when the enemy base is within the effect radius of your base.</li>",
				VisionIncrease : "<li>Vision is increased by {0} when within the base effect radius.</li>",
				MovementSpeedIncrease : "<li>Party movement speed is increased by {0}% when within the base effect radius.</li>",
			},
			getUpgradeDescription : function(_element, _level){
				var text = this.UpgradeDescription.FOV;
				text += Stronghold.Text.format(this.UpgradeDescription.VisionIncrease, _element.VisionIncrease * _level);
				text += Stronghold.Text.format(this.UpgradeDescription.MovementSpeedIncrease,  parseInt(_element.MovementSpeedIncrease * _level * 100));
				return  text
			},
		},
		Troop_Quarters : {
			UpgradeDescription : {
				Slots : "<li>This location provides housing for your brothers, allowing you to leave up to {0} brothers at your base.</li>",
				WageCost : "<li>Brothers at the base cost only {0}% of their normal daily wage.</li>",
			},
			getUpgradeDescription : function(_element, _level){
				var text = Stronghold.Text.format(this.UpgradeDescription.Slots, _element.MaxTroops * _level);
				text += Stronghold.Text.format(this.UpgradeDescription.WageCost, parseInt((_element.WageCost - _level * _element.WageCostPerLevel) * 100));
				return  text
			},
		},
		Militia_Trainingcamp : {
			UpgradeDescription : {
				DailyIncome : "<li>Each trainingcamp generates {0} experience per day, which is divided over all stored brothers below level {1}.</li>",
				NPC : "<li>Your allied mercenaries and auxiliaries will train here, increasing the strength of mercenary parties and caravans.</li>",
				Hamlet : "<li>If your base has a hamlet, each trainingcamp will also increase the amount of recruits that will line up to join you by {0}.</li>"
			},
			getUpgradeDescription : function(_element, _level){
				var text = Stronghold.Text.format(this.UpgradeDescription.DailyIncome, _element.DailyIncome * _level, _element.MaxBrotherExpLevel + _element.MaxBrotherExpLevelUpgrade);
				text += this.UpgradeDescription.NPC;
				text += Stronghold.Text.format(this.UpgradeDescription.Hamlet, _element.RecruitIncrease);
				return  text
			},
		},
		Wheat_Fields : {
			UpgradeDescription : {
				StatBuff : "<li>The brothers in your party get the 'Well Fed' buff, increasing their Resolve, Hitpoints and Fatigue by {0}. This effect lasts for {1} days after leaving the radius of the base.</li>",
			},
			getUpgradeDescription : function(_element, _level){
				var text = Stronghold.Text.format(this.UpgradeDescription.StatBuff, _element.StatGain * _level, _element.EffectTime);
				return  text},
		},
		Gold_Mine : {
			UpgradeDescription : {
				DailyIncome : "<li>The gold mine generates {0} crowns a day, which are added to your coffers when you visit the base.</li>",
			},
			getUpgradeDescription : function(_element, _level){
				return Stronghold.Text.format(this.UpgradeDescription.DailyIncome, _element.DailyIncome)
			},
		}
	}
}
