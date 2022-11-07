this.stronghold_screen_stash_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {
		InventoryFilter = this.Const.Items.ItemFilter.All
	},

	function getUIData( _ret )
	{
		_ret.Title <- "Warehouse",
		_ret.SubTitle <- "Your Warehouse",
		_ret.Shop <- [],
		_ret.Stash <- [],
		_ret.StashSpaceUsed <- this.Stash.getNumberOfFilledSlots(),
		_ret.StashSpaceMax <- this.Stash.getCapacity(),
		_ret.TownStashSpaceUsed <- this.getTown().getStash().getNumberOfFilledSlots(),
		_ret.TownStashSpaceMax <- this.getTown().getStash().getCapacity(),
		_ret.IsRepairOffered <- false

		this.UIDataHelper.convertItemsToUIData(this.getTown().getStash().getItems(), _ret.Shop, this.Const.UI.ItemOwner.Stash, this.m.InventoryFilter);
		this.UIDataHelper.convertItemsToUIData(this.World.Assets.getStash().getItems(), _ret.Stash, this.Const.UI.ItemOwner.Stash, this.m.InventoryFilter);
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
		this.getTown().getStash().sort();
		this.World.Assets.getStash().sort();

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
		if (!this.getTown().isRepairOffered())
		{
			return null;
		}

		local item = this.Stash.getItemAtIndex(_itemIndex).item;

		if (item.getConditionMax() <= 1 || item.getCondition() >= item.getConditionMax())
		{
			return null;
		}

		local price = (item.getConditionMax() - item.getCondition()) * this.Const.World.Assets.CostToRepairPerPoint;
		local value = item.m.Value * (1.0 - item.getCondition() / item.getConditionMax()) * 0.2 * this.World.State.getCurrentTown().getPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()];
		price = this.Math.max(price, value);

		if (this.World.Assets.getMoney() < price)
		{
			return null;
		}

		this.World.Assets.addMoney(-price);
		item.setCondition(item.getConditionMax());
		item.setToBeRepaired(false);
		this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
		local result = {
			Item = this.UIDataHelper.convertItemToUIData(item, true, this.Const.UI.ItemOwner.Stash),
			Assets = this.m.Parent.queryAssetsInformation()
		};
		this.World.Statistics.getFlags().increment("ItemsRepaired");
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
		local sourceStash = sourceItemOwner == "world-town-screen-shop-dialog-module.stash" ? this.Stash : this.getTown().getStash();
		local destinationStash = sourceItemOwner == "world-town-screen-shop-dialog-module.stash" ? this.getTown().getStash() : this.Stash;
		local sourceItem = sourceStash.getItemAtIndex(sourceItemIdx);

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
			if (!this.Stash.isLastTakenSlot(sourceItemIdx))
			{
				local firstEmptySlotIdx = this.Stash.getFirstEmptySlot();

				if (firstEmptySlotIdx != null)
				{
					if (this.Stash.swap(sourceItemIdx, firstEmptySlotIdx))
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
		this.updateData();
		return result;
	}


	function updateStashes()
	{
		local ret = this.getUIData({});
		this.m.JSHandle.asyncCall("updateStashes", ret);
	}
})
