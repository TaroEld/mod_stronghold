	local consumeStashItemsVanilla = function(){
		if (!this.isQualified())
		{
			return;
		}

		this.updateAchievement("IMadeThis", 1, 1);
		this.World.Statistics.getFlags().increment("ItemsCrafted", 1);
		this.World.Ambitions.updateUI();
		local globalStash = this.World.Assets.getStash();
		local townStash = this.World.State.getCurrentTown().getWarehouse().getStash()
		local hasAlchemist = this.World.Retinue.hasFollower("follower.alchemist");
		local stash = globalStash
		foreach( c in this.m.PreviewComponents )
		{
			for( local j = 0; j < c.Num; j = ++j )
			{
				if (!stash.getItemByID(c.Instance.getID())) stash = townStash
				local item = stash.getItemByID(c.Instance.getID());

				if (!hasAlchemist || item.getMagicNumber() > 25)
				{
					stash.remove(item);
				}
				else
				{
					item.setMagicNumber(::Math.rand(1, 100));
				}
				stash = globalStash
			}
		}
		++this.m.TimesCrafted;
		this.onCraft(stash);
	}

	local consumeStashItemsLegends = function(){
		if (!this.isQualified())
		{
			return;
		}

		this.updateAchievement("IMadeThis", 1, 1);
		local globalStash = this.World.Assets.getStash();
		local townStash = this.World.State.getCurrentTown().getWarehouse().getStash()
		local hasAlchemist = this.World.Retinue.hasFollower("follower.alchemist");
		local stash = globalStash

		foreach( c in this.m.PreviewComponents )
		{
			if ("LegendsArmor" in c)
			{
				if (c.LegendsArmor && !this.LegendsMod.Configs().LegendArmorsEnabled())
				{
					continue;
				}

				if (!c.LegendsArmor && this.LegendsMod.Configs().LegendArmorsEnabled())
				{
					continue;
				}
			}

			for( local j = 0; j < c.Num; j++ )
			{
				if (!stash.getItemByID(c.Instance.getID())) stash = townStash
				local item = stash.getItemByID(c.Instance.getID());

				if (!hasAlchemist || item.getMagicNumber() > 25)
				{
					stash.remove(item);
				}
				else
				{
					item.setMagicNumber(::Math.rand(1, 100));
				}
				stash = globalStash
			}
		}

		++this.m.TimesCrafted;
		this.onCraft(stash);
	}

	local getCombinedStash = function()
	{
		local items = []
		items.extend(this.World.Assets.getStash().m.Items);
		items.extend(this.World.State.getCurrentTown().getWarehouse().getStash().getItems())
		return items
	}
	
	::mods_hookBaseClass("crafting/blueprint", function ( o ) 
	{
		//adds items in storage building to crafting UI
		while("SuperName" in o) o=o[o.SuperName]
		local craftable = o.isCraftable
		o.isCraftable = function()
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null &&  this.World.State.getCurrentTown().getFlags().get("IsMainBase"))
			{

				local getStash = this.World.Assets.getStash().getItems
				this.World.Assets.getStash().getItems = getCombinedStash
				local result = craftable()
				this.World.Assets.getStash().getItems = getStash
				return result
			}
			else
			{
				return craftable()
			}
		}

		local craft = o.craft
		o.craft = function()
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getFlags().get("IsMainBase"))
			{
				return ("LegendsMod" in this.getroottable() ? consumeStashItemsLegends() : consumeStashItemsVanilla())			
			}
			else{
				return craft()
			}
		}

		local getIngredients = o.getIngredients
		o.getIngredients = function()
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getFlags().get("IsMainBase"))
			{
				local getStash = this.World.Assets.getStash().getItems
				this.World.Assets.getStash().getItems = getCombinedStash
				local result = getIngredients()
				this.World.Assets.getStash().getItems = getStash
				return result
			}
			else{
				return getIngredients()
			}
		}
	})
