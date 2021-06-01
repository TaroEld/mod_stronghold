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
		this.m.Name = "Storage";
		this.m.Description = "Your companies storage building";
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
		this.Stronghold.time <- this.Time.getExactTime()
		_townScreen.getShopDialogModule().setShop(this);
		_townScreen.showShopDialog();
		this.pushUIMenuStack();
	}

	function onSettlementEntered()
	{
	}

	function onUpdateShopList(_daysPassed)
	{
		// adds free items every 3 days. Max of max_each in town store. Sets the price mult to 0 to make them free.
		local town_size = this.m.Settlement.getSize() -1 ;
		local toAdd = [];
		local tool_count = 0;
		local medicine_count = 0;
		local ammo_count = 0;
		local tool_increment = town_size;
		local medicine_increment = town_size;
		local ammo_increment = town_size;
		local tool_max = 8
		local medicine_max = 5
		local ammo_max = 6
		local updates = this.Math.abs(_daysPassed/3);
		if (updates == 0){ 
			updates = 1
		};
		foreach (item in this.m.Stash.getItems()){
			if (item.m.ID == "supplies.ammo"){
				ammo_count++
			}
			else if (item.m.ID == "supplies.armor_parts"){
				tool_count++
			}
			else if (item.m.ID == "supplies.medicine"){
				medicine_count++
			}
		}
		if(this.m.Settlement.hasAttachedLocation("attached_location.workshop"))
		{
			tool_increment +=2;
			tool_max += 2;
		}
		for (local x = 0; x < updates; x++)
		{
			for (local y = 0; y < town_size; y++)
			{
				if(medicine_count < medicine_max){
					toAdd.push(this.new("scripts/items/supplies/medicine_item"));
					medicine_count++
				}
				if(ammo_count < ammo_max){
					toAdd.push(this.new("scripts/items/supplies/ammo_item"));
					ammo_count++
				}
				
			}
			for (local y = 0; y < tool_increment; y++){
				if(tool_count < tool_max){
					toAdd.push(this.new("scripts/items/supplies/armor_parts_item"));
					tool_count++
				}
			}
		}
		if (this.m.Settlement.hasAttachedLocation("attached_location.gold_mine"))
		{
			local money = this.new("scripts/items/supplies/money_item")
			money.setAmount(_daysPassed*150);
			this.m.Stash.add(money)
		}

		foreach (item in toAdd)
		{
			item.m.PriceMult = 0;
			this.m.Stash.add(item);
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

