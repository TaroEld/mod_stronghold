::mods_hookNewObject("ui/screens/tooltip/tooltip_events", function ( o )
{
	// adapt armorsmith discount tooltip
	local tactical_helper_addHintsToTooltip = o.tactical_helper_addHintsToTooltip;
	o.tactical_helper_addHintsToTooltip = function ( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
	{
		local result = tactical_helper_addHintsToTooltip( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked);
		local town = this.World.State.getCurrentTown();
		if (_itemOwner != "world-town-screen-shop-dialog-module.stash" || town == null || !town.getFlags().get("IsMainBase") || !::Stronghold.StrongholdScreen.isVisible())
		{
			return result;
		}

		// remove sell info
		foreach (idx, entry in result)
		{
			if ("icon" in entry && entry.icon == "ui/icons/mouse_right_button.png")
			{
				result.remove(idx);
				break
			}
		}

		if (town.hasAttachedLocation("attached_location.blast_furnace"))
		{
			local price = (_item.getConditionMax() - _item.getCondition()) * this.Const.World.Assets.CostToRepairPerPoint;
			local value = _item.m.Value * (1.0 - _item.getCondition() / _item.getConditionMax()) * 0.2 * this.World.State.getCurrentTown().getPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()];
			price = ::Math.max(price, value) * (1.0 - (this.Stronghold.Locations["Blast_Furnace"].RepairMultiplier * town.getLocation("attached_location.blast_furnace").getLevel()));
			price = price.tointeger();

			if (this.World.Assets.getMoney() >= price)
			{
				result.push({
					id = 3,
					type = "hint",
					icon = "ui/icons/mouse_right_button_alt.png",
					text = "Pay [img]gfx/ui/tooltips/money.png[/img]" + price + " to have it repaired"
				});
			}
			else
			{
				result.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Not enough crowns to pay for repairs!"
				});
			}
		}
		if (town.hasAttachedLocation("attached_location.ore_smelters") && _item.isItemType(this.Const.Items.ItemType.Named))
		{
			result.push({
				id = 3,
				type = "hint",
				icon = "ui/icons/mouse_right_button.png",
				text = "Press SHIFT + Right Mouse Button to reforge this named item "
			});
		}
		return result
	}
	local strategic_queryUIItemTooltipData = o.strategic_queryUIItemTooltipData;
	o.strategic_queryUIItemTooltipData = function(_entityId, _itemId, _itemOwner)
	{
		if (_itemOwner != "world-town-screen-shop-dialog-module.shop")
			return strategic_queryUIItemTooltipData(_entityId, _itemId, _itemOwner);
		if (!::Stronghold.StrongholdScreen.isVisible())
			return strategic_queryUIItemTooltipData(_entityId, _itemId, _itemOwner);

		local stash = ::Stronghold.StrongholdScreen.getTown().getStash();
		local result = stash.getItemByInstanceID(_itemId);
		local entity = _entityId != null ? this.Tactical.getEntityByID(_entityId) : null;

		if (result != null)
		{
			return this.tactical_helper_addHintsToTooltip(null, entity, result.item, "world-town-screen-shop-dialog-module.stash", true);
		}
	}

	local general_queryUIElementTooltipData = o.general_queryUIElementTooltipData
	o.general_queryUIElementTooltipData = function( _entityId, _elementId, _elementOwner )
	{
		local entity;

		if (_entityId != null)
		{
			entity = this.Tactical.getEntityByID(_entityId);
		}

		switch(_elementId)
		{
			case "world-town-screen.main-dialog-module.Management":
				return [
					{
						id = 1,
						type = "title",
						text = "The Keep"
					},
					{
						id = 2,
						type = "description",
						text = "Manage your settlement"
					}
				];

			case "stronghold-retinue-button":
				local ret = [
					{
						id = 1,
						type = "title",
						text = "Stronghold"
					},
					{
						id = 2,
						type = "description",
						text = "Click here to learn more about Stronghold."
					}
				];
				return ret;
		}
		return general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
	}
});
