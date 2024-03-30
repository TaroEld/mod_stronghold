::mods_hookNewObjectOnce("states/world/asset_manager", function (o)
{
	local update = o.update;		
	o.update = function(_worldState)
	{			
		//set movementspeed and vision radius if watchtower location
		if(this.Stronghold.getPlayerFaction() == null) return update(_worldState)
		if (this.World.getTime().Hours != this.m.LastHourUpdated)
		{
			//check for ranger start and lookout follower
			local playerBases = this.Stronghold.getPlayerFaction().getMainBases()
			local isRangers = this.World.Assets.getOrigin().getID() == "scenario.rangers";
			local hasLookout = this.World.Retinue.hasFollower("follower.lookout");
			local player = this.World.State.getPlayer();
			foreach(playerBase in playerBases)
			{	
				local troopQuarters = playerBase.getLocation("attached_location.troop_quarters");
				//stored brothers draw less
				if (troopQuarters != null && this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8 && this.m.IsConsumingAssets)
				{
					local wageMult = troopQuarters.getWageMult();
					foreach(bro in playerBase.getLocalRoster().getAll())
					{
						this.m.Money -= ::Math.floor(bro.getDailyCost() * wageMult);
					}
				}

				local effectRadius = playerBase.getEffectRadius();

				// do effects that depend on effect range
				if (::World.State.getPlayer().getTile().getDistanceTo(playerBase.getTile()) > effectRadius)
					continue;

				local watchtower = playerBase.getLocation("attached_location.stone_watchtower");
				if (watchtower != null)
				{
					if (!("Stronghold_Stone_Watchtower" in player.m.MovementSpeedMultFunctions))
						player.m.MovementSpeedMultFunctions.Stronghold_Stone_Watchtower <- watchtower.getMovementSpeedMult.bindenv(watchtower);
					local vision = this.Stronghold.Locations["Stone_Watchtower"].VisionIncrease * watchtower.getLevel();
					this.World.State.getPlayer().m.VisionRadius = hasLookout ? 625 + vision : 500 + vision;
				}
				//if not in radius
				else
				{
					if ("Stronghold_Stone_Watchtower" in player.m.MovementSpeedMultFunctions)
						delete player.m.MovementSpeedMultFunctions.Stronghold_Stone_Watchtower;
					this.World.State.getPlayer().m.BaseMovementSpeed = isRangers ? 111 : 105
					this.World.State.getPlayer().m.VisionRadius = hasLookout ? 625 : 500 
				}

				local wheatFields = playerBase.getLocation("attached_location.wheat_fields");
				if (wheatFields != null)
				{
					foreach(bro in ::World.getPlayerRoster().getAll())
					{
						wheatFields.setSkillOnPlayer(bro);
					}
				}
			}
		}
		//then run vanilla updte
		update(_worldState)
	}

	//stored brothers draw half wage, for tooltip
	local getDailyMoneyCost = o.getDailyMoneyCost
	o.getDailyMoneyCost = function()
	{
		local money = getDailyMoneyCost();
		if (this.Stronghold.getPlayerBase())
		{
			foreach(playerBase in this.Stronghold.getPlayerFaction().getMainBases())
			{
				foreach(bro in playerBase.getLocalRoster().getAll())
				{
					money += ::Math.floor(bro.getDailyCost()/2);
				}
			}
		}
		return money;
	}		
});
