this.stronghold_screen_stash_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {
		InventoryFilter = this.Const.Items.ItemFilter.All
	},

	function getStash()
	{
		return this.getTown().getStash();
	}

	function getUIData( _ret )
	{
		_ret.Title <- "Warehouse",
		_ret.SubTitle <- "Your Warehouse",
		_ret.Shop <- [],
		_ret.Stash <- [],
		_ret.StashSpaceUsed <- ::Stash.getNumberOfFilledSlots(),
		_ret.StashSpaceMax <- ::Stash.getCapacity(),
		_ret.TownStashSpaceUsed <- this.getStash() == null ? 0 : this.getStash().getNumberOfFilledSlots(),
		_ret.TownStashSpaceMax <- this.getStash() == null ? 0 : this.getStash().getCapacity(),
		_ret.IsRepairOffered <- this.getTown().getLocation("attached_location.blast_furnace") != null;

		this.UIDataHelper.convertItemsToUIData(this.getStash().getItems(), _ret.Shop, this.Const.UI.ItemOwner.Stash, this.m.InventoryFilter);
		this.UIDataHelper.convertItemsToUIData(::Stash.getItems(), _ret.Stash, this.Const.UI.ItemOwner.Stash, this.m.InventoryFilter);
		return _ret
	}

	function loadStashList()
	{
		local result = {
			Stash = this.UIDataHelper.convertStashToUIData(false, this.m.InventoryFilter)
		};
		this.m.JSHandle.asyncCall("loadFromData", result);
	}

	function onLeaveButtonPressed()
	{
		this.m.Parent.onModuleClosed();
	}

	function onSortButtonClicked()
	{
		this.getStash().sort();
		::Stash.sort();

		this.updateData();
	}

	function onFilterButtonPressed(_type)
	{
		if (this.m.InventoryFilter != _type)
		{
			this.m.InventoryFilter = _type;
			this.updateData();
		}
	}

	function onFilterAll()
	{
		return this.onFilterButtonPressed(this.Const.Items.ItemFilter.All);
	}

	function onFilterWeapons()
	{
		return this.onFilterButtonPressed(this.Const.Items.ItemFilter.Weapons);
	}

	function onFilterArmor()
	{
		return this.onFilterButtonPressed(this.Const.Items.ItemFilter.Armor);
	}

	function onFilterMisc()
	{
		return this.onFilterButtonPressed(this.Const.Items.ItemFilter.Misc);
	}

	function onFilterUsable()
	{
		return this.onFilterButtonPressed(this.Const.Items.ItemFilter.Usable);
	}

	function onRepairItem( _itemIndex )
	{
		local location = this.getTown().getLocation("attached_location.blast_furnace");
		if (location == null)
		{
			return null;
		}

		local item = this.getStash().getItemAtIndex(_itemIndex).item;

		if (item.getConditionMax() <= 1 || item.getCondition() >= item.getConditionMax())
		{
			return null;
		}

		local price = (item.getConditionMax() - item.getCondition()) * this.Const.World.Assets.CostToRepairPerPoint;
		local value = item.m.Value * (1.0 - item.getCondition() / item.getConditionMax()) * 0.2 * this.World.State.getCurrentTown().getPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()];
		price = ::Math.max(price, value) * (1.0 - (this.Stronghold.Locations["Blast_Furnace"].RepairMultiplier * location.getLevel()));
		price = price.tointeger();

		if (this.World.Assets.getMoney() < price)
		{
			return null;
		}

		this.World.Assets.addMoney(-price);
		item.setCondition(item.getConditionMax());
		item.setToBeRepaired(false);
		this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
		this.World.Statistics.getFlags().increment("ItemsRepaired");
		this.updateData(["Assets", "TownAssets", "StashModule"]);
		local result = {
			Item = this.UIDataHelper.convertItemToUIData(item, true, this.Const.UI.ItemOwner.Stash)
		};
		return result;
	}

	function onSwapItem( _data )
	{
		local sourceItemIdx = _data[0];
		local sourceItemOwner = _data[1];
		local targetItemIdx = _data[2];
		local targetItemOwner = _data[3];

		if (targetItemOwner == null)
		{
			this.logError("onSwapItem #1");
			return null;
		}
		local sourceStash = sourceItemOwner == "world-town-screen-shop-dialog-module.stash" ? ::Stash : this.getStash();
		local destinationStash = sourceItemOwner == "world-town-screen-shop-dialog-module.stash" ? this.getStash() : ::Stash;
		local sourceItem = sourceStash.getItemAtIndex(sourceItemIdx);

		if (!destinationStash.hasEmptySlot())
			return {Result = this.Const.UI.Error.NotEnoughStashSpace};

		if (sourceItem == null)
		{
			this.logError("onSwapItem(stash) #2");
			return null;
		}

		if (targetItemIdx != null)
		{
			if (sourceItemOwner == targetItemOwner)
			{
				if (sourceStash.swap(sourceItemIdx, targetItemIdx))
				{
					sourceItem.item.playInventorySound(this.Const.Items.InventoryEventType.PlacedInBag);
				}
				else
				{
					this.logError("onSwapItem(stash) #3");
					return null;
				}
			}
			else
			{
				this.logError("onSwapItem(stash) #3.1");
				return null;
			}
		}
		else if (sourceItemOwner == targetItemOwner)
		{
			if (!::Stash.isLastTakenSlot(sourceItemIdx))
			{
				local firstEmptySlotIdx = ::Stash.getFirstEmptySlot();

				if (firstEmptySlotIdx != null)
				{
					if (::Stash.swap(sourceItemIdx, firstEmptySlotIdx))
					{
						sourceItem.item.playInventorySound(this.Const.Items.InventoryEventType.PlacedInBag);
					}
					else
					{
						this.logError("onSwapItem(stash) #4");
						return null;
					}
				}
			}
		}
		else
		{
			local removedItem = sourceStash.removeByIndex(sourceItemIdx);

			if (removedItem != null)
			{
				destinationStash.add(removedItem);
			}
		}

		local result = {
			Result = 0,
		};
		this.updateData(["Assets", "TownAssets", "StashModule", "MiscModule"]);
		return result;
	}

	function onReforgeIsValid(_idx)
	{
		//check if in player base and store
		local town = this.getTown();
		local location = town.getLocation("attached_location.ore_smelters");
		if (!location)
		{
			return { IsValid = false }
		}

		local sourceItem = this.getStash().getItemAtIndex(_idx);
		if (sourceItem == null || sourceItem.item == null || !sourceItem.item.isItemType(this.Const.Items.ItemType.Named))
		{
			return { IsValid = false }
		}
		local price = sourceItem.item.m.Value * (1 - (this.Stronghold.Locations["Ore_Smelter"].ReforgeMultiplier * location.getLevel()));

		return {
			IsValid = true,
			ItemIdx = _idx,
			ItemName = sourceItem.item.getName(),
			Price = price,
			Affordable = price < this.World.Assets.getMoney()
		}
	}

	function onReforgeNamedItem(_idx)
	{
		local sourceItem = this.getStash().removeByIndex(_idx);
		local location = this.getTown().getLocation("attached_location.ore_smelters");
		local name = sourceItem.getName();
		local type = sourceItem.ClassNameHash;
		local price = sourceItem.item.m.Value * (1 - (this.Stronghold.Locations["Ore_Smelter"].ReforgeMultiplier * location.getLevel()));

		//can't savescum quite as easily
		if (!this.World.Flags.get("ReforgeNamedItemSeed"))
		{
			this.World.Flags.set("ReforgeNamedItemSeed", this.World.State.getCurrentTown().getFlags().get("RosterSeed"));
		}
		this.World.Flags.increment("ReforgeNamedItemSeed");
		::Math.seedRandom(this.World.Flags.get("ReforgeNamedItemSeed"));

		local replacementItem = this.new(this.IO.scriptFilenameByHash(type));
		replacementItem.m.Name = name;
		this.World.Assets.addMoney(-price);
		this.getStash().add(replacementItem);
		this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + ::Math.rand(0, 6) + ".wav", 1.0);
		this.updateData(["Assets", "TownAssets", "StashModule"]);
	}
})
