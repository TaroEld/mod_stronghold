::mods_hookNewObjectOnce("states/world/asset_manager", function (o)
{
	local update = o.update;		
	o.update = function(_worldState)
	{			
		//set movementspeed and vision radius if watchtower location
		if(::Stronghold.getPlayerFaction() == null) return update(_worldState)


		foreach(playerBase in ::Stronghold.getPlayerFaction().getMainBases())
		{
			if (this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8 && this.m.IsConsumingAssets)
				playerBase.onNewDay();
			if (this.World.getTime().Hours != this.m.LastHourUpdated)
				playerBase.onNewHour();
		}
		//then run vanilla updte
		update(_worldState)
	}

	//stored brothers draw half wage, for tooltip
	local getDailyMoneyCost = o.getDailyMoneyCost
	o.getDailyMoneyCost = function()
	{
		local money = getDailyMoneyCost();
		if (!this.Stronghold.getPlayerBase())
			return money;

		foreach(playerBase in this.Stronghold.getPlayerFaction().getMainBases())
		{
			local troopQuarters = playerBase.getLocation("attached_location.troop_quarters");
			if (troopQuarters == null)
				continue;

			foreach (bro in playerBase.getLocalRoster().getAll())
			{
				money += ::Math.floor(bro.getDailyCost() * troopQuarters.getWageMult());
			}
		}
		return money;
	}		
});
