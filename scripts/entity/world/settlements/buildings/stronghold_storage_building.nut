this.stronghold_storage_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	//modified marketplace.
	m = {
		Stash = null
	},
	function getStash()
	{
		return this.m.Stash;
	}

	function create()
	{
		this.building.create();
		this.m.ID = "building.storage_building";
		this.m.Name = "Warehouse";
		this.m.Description = "Your companies warehouse";
		this.m.UIImage = "ui/settlements/building_06";
		this.m.UIImageNight = "ui/settlements/building_06";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Storage";
		this.m.TooltipIcon = "ui/icons/buildings/tavern.png";
		this.m.Stash = this.new("scripts/items/stash_container");
		this.m.Stash.setID("shop");
		this.m.Stash.setResizable(true);
		this.m.IsClosedAtNight = false;
		this.m.Sounds = [
			{
				File = "ambience/buildings/market_people_00.wav",
				Volume = 0.4,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_01.wav",
				Volume = 0.6,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_02.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_03.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_04.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_05.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_07.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_08.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_09.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_10.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_11.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_12.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_13.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_14.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_00.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_01.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_02.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_03.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_04.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_00.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_01.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_02.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_03.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_04.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_05.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_bottles_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			}
		];
		this.m.SoundsAtNight = [];
	}

	function onClicked( _townScreen )
	{
		this.getStash().sort()
		_townScreen.getShopDialogModule().setShop(this);
		_townScreen.showShopDialog();
		this.pushUIMenuStack();
	}

	function updateProducedItems(_daysPassed)
	{
		local townSize = this.m.Settlement.getSize();

		local itemsToAdd = {
			Armor = {
				ID = "supplies.armor_parts",
				Script = "scripts/items/supplies/armor_parts_item"
				Max = this.Stronghold.MaxAmountOfStoredTools,
				MaxPerStack = 25,
				ToAdd = townSize * _daysPassed * 9
			},
			Medicine = {
				ID = "supplies.medicine",
				Script = "scripts/items/supplies/medicine_item",
				Max = this.Stronghold.MaxAmountOfStoredMedicine,
				MaxPerStack = 20,
				ToAdd = townSize * _daysPassed * 7
			},
			Ammo = {
				ID = "supplies.ammo",
				Script = "scripts/items/supplies/ammo_item",
				Max = this.Stronghold.MaxAmountOfStoredAmmo,
				MaxPerStack = 50,
				ToAdd = townSize * _daysPassed * 20
			},
		}

		if (this.m.Settlement.hasAttachedLocation("attached_location.workshop"))
		{
			local toolPerWorkshop = this.Stronghold.Locations["Workshop"].DailyIncome;
			local toolMaxPerWorkshop = this.Stronghold.Locations["Workshop"].MaxItemSlots;
			local numberOfWorkshops = this.m.Settlement.countAttachedLocations("attached_location.workshop");
			itemsToAdd.Armor.ToAdd += toolPerWorkshop * numberOfWorkshops * _daysPassed;
			itemsToAdd.Armor.Max += toolMaxPerWorkshop * numberOfWorkshops;
		}

		// iterates through items in stash to add the current to the total to be added, also finds money item because that can just be one stack
		local moneyItem = null;
		local toRemove = [];
		foreach (idx, item in this.m.Stash.getItems())
		{
			if (item == null) continue;
			if (item.getID() == "supplies.money") 
			{
				moneyItem = item;
				continue;
			}
			foreach(itemToAdd in itemsToAdd)
			{
				if (itemToAdd.ID == item.m.ID)
				{
					itemToAdd.ToAdd += item.getAmount();
					toRemove.push(item);
					break;
				}
			}
		}
		// Remove current items and just go off total. Can't remove items from array while iterating through it so do that here
		foreach(item in toRemove)
		{
			this.m.Stash.remove(item);
		}

		local item;
		local amount;
		foreach(itemToAdd in itemsToAdd)
		{
			// can't add more than storage max of each item in total
			itemToAdd.ToAdd = this.Math.min(itemToAdd.ToAdd, itemToAdd.Max);
			while (itemToAdd.ToAdd > 0)
			{
				item = this.new(itemToAdd.Script);
				amount = this.Math.min(itemToAdd.MaxPerStack, itemToAdd.ToAdd).tointeger();
				item.setAmount(amount);
				itemToAdd.ToAdd -= amount;
				item.m.PriceMult = 0;
				this.m.Stash.add(item);
			}
		}
		
		if (this.m.Settlement.hasAttachedLocation("attached_location.gold_mine"))
		{
			local moneyPerMine = this.Stronghold.Locations["Gold_Mine"].DailyIncome;
			local numberOfMines = this.m.Settlement.countAttachedLocations("attached_location.gold_mine");
			local totalMoney = _daysPassed * numberOfMines * moneyPerMine;
			if(moneyItem == null)
			{
				moneyItem = this.new("scripts/items/supplies/money_item");
				moneyItem.setAmount(totalMoney);
				this.m.Stash.add(moneyItem);
			}
			else
			{
				moneyItem.setAmount(moneyItem.getAmount() + totalMoney);
			}
		}

		if (this.m.Settlement.hasAttachedLocation("attached_location.militia_trainingcamp"))
		{
			local XpPerDay = this.Stronghold.Locations["Militia_Trainingcamp"].DailyIncome;
			local numberOfTrainingGrounds = this.m.Settlement.countAttachedLocations("attached_location.militia_trainingcamp");
			local validBros = this.m.Settlement.getLocalRoster().getAll().filter( @(a, b) b.getLevel() <= 7);
			local totalXP = XpPerDay * _daysPassed * numberOfTrainingGrounds;
			local XpPerBro = totalXP  / validBros.len();
			foreach (bro in validBros)
			{
				bro.addXP(XpPerBro.tointeger(), false);
				bro.updateLevel();
			}
		}
	}

	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
		this.m.Stash.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);
		this.m.Stash.onDeserialize(_in);
	}

});

