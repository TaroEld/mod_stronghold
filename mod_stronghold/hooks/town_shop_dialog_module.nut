::mods_hookNewObject("ui/screens/world/modules/world_town_screen/town_shop_dialog_module", function(o){
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
		price = ::Math.max(price, value) * (1.0 - (this.Stronghold.Locations["Blast_Furnace"].RepairMultiplier * town.getLocation("attached_location.blast_furnace").getLevel()));
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
