::mods_hookNewObject("ui/screens/world/modules/world_town_screen/town_shop_dialog_module", function(o){
	o.onReforgeIsValid <- function(_idx)
	{
		//check if in player base and store
		local town = this.World.State.getCurrentTown();
		if (!town.getFlags().get("IsMainBase") ||
			!town.hasAttachedLocation("attached_location.ore_smelters") ||
			this.World.State.getTownScreen().getShopDialogModule().getShop().m.ID != "building.storage_building")
		{
			return
			{
				IsValid = false
			}
		}

		local sourceItem = this.m.Shop.getStash().getItemAtIndex(_idx);
		if (sourceItem == null || sourceItem.item == null || !sourceItem.item.isItemType(this.Const.Items.ItemType.Named))
		{
			return { IsValid = false }
		}
		local price = sourceItem.item.m.Value * this.Stronghold.Locations["Ore_Smelter"].ReforgeMultiplier;

		return {
			IsValid = true,
			ItemIdx = _idx,
			ItemName = sourceItem.item.getName(),
			Price = price,
			Affordable = price < this.World.Assets.getMoney()
		}
	}

	o.onReforgeNamedItem <- function(_idx)
	{
		local sourceItem = this.m.Shop.getStash().removeByIndex(_idx);
		local name = sourceItem.getName();
		local type = sourceItem.ClassNameHash;
		local price = sourceItem.m.Value * this.Stronghold.Locations["Ore_Smelter"].ReforgeMultiplier;

		//can't savescum quite as easily
		if (!this.World.Flags.get("ReforgeNamedItemSeed"))
		{
			this.World.Flags.set("ReforgeNamedItemSeed", this.World.State.getCurrentTown().getFlags().get("RosterSeed"));
		}
		this.World.Flags.increment("ReforgeNamedItemSeed");
		::Math.seedRandom(this.World.Flags.get("ReforgeNamedItemSeed"));

		local replacementItem = this.new(this.IO.scriptFilenameByHash(type));
		replacementItem.setName(name);
		this.World.Assets.addMoney(-price);
		this.m.Shop.getStash().add(replacementItem);
		this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + ::Math.rand(0, 6) + ".wav", 1.0);
		local result = {
			Item = this.UIDataHelper.convertItemToUIData(replacementItem, true, null),
			Assets = this.m.Parent.queryAssetsInformation()
		};
		return result;
	}

	local onRepairItem = o.onRepairItem
	o.onRepairItem <- function(_itemIndex)
	{
		local town = this.World.State.getCurrentTown();
		if (!town.getFlags().get("IsMainBase") || !town.hasAttachedLocation("attached_location.blast_furnace"))
		{
			return onRepairItem(_itemIndex);
		}

		if (!this.m.Shop.isRepairOffered())
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
		price = ::Math.max(price, value) * this.Stronghold.Locations["Blast_Furnace"].RepairMultiplier;
		price = price.tointeger();

		if (this.World.Assets.getMoney() < price)
		{
			return null;
		}

		this.World.Assets.addMoney(-price);
		item.setCondition(item.getConditionMax());
		item.setToBeRepaired(false);
		this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + ::Math.rand(0, 6) + ".wav", 1.0);
		local result = {
			Item = this.UIDataHelper.convertItemToUIData(item, true, this.Const.UI.ItemOwner.Stash),
			Assets = this.m.Parent.queryAssetsInformation()
		};
		this.World.Statistics.getFlags().increment("ItemsRepaired");
		return result;
	}
})
