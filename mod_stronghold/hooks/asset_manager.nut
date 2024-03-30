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
			foreach(playerBase in playerBases)
			{	
				if (playerBase.hasAttachedLocation("attached_location.stone_watchtower") 
					&& this.World.State.getPlayer().getTile().getDistanceTo(playerBase.getTile()) < this.Stronghold.Locations["Stone_Watchtower"].EffectRange)
				{
					this.World.State.getPlayer().m.BaseMovementSpeed = isRangers ? 111 + this.Stronghold.Locations["Stone_Watchtower"].MovementSpeedIncrease : 105 + this.Stronghold.Locations["Stone_Watchtower"].MovementSpeedIncrease
					this.World.State.getPlayer().m.VisionRadius = hasLookout ? 625 + this.Stronghold.Locations["Stone_Watchtower"].VisionIncrease : 500 + this.Stronghold.Locations["Stone_Watchtower"].VisionIncrease
				}
				//if not in radius
				else
				{
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
