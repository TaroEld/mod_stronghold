::mods_hookExactClass("factions/actions/patrol_roads_action", function ( o )
{
	//adds stronghold as possible patrol option if friendly with the faction
	local onUpdate = o.onUpdate;
	o.onUpdate = function(_faction)
	{
		onUpdate(_faction)
		if (this.Stronghold.getPlayerFaction() == null) return
		local playerBase = ::MSU.Array.rand(this.Stronghold.getPlayerFaction().getMainBases())
		if (this.m.Score == 0 || playerBase == null || _faction.m.PlayerRelation < 70) return;
		foreach( settlement in this.m.Settlements )
		{
			if (!this.isPathBetween(settlement.getTile(), playerBase.getTile(), true)) return;
		}
		this.m.Settlements.push(playerBase)
	}
	
	//needed for patrol to not start at player base. This whole thing is pretty jank, need to hook whole functions for small changes, would probably be better to separate entirely.
	local onExecute = o.onExecute;
	o.onExecute = function(_faction)
	{
		local waypoints = [];

		for( local i = 0; i != 3; i = ++i )
		{
			local idx = ::Math.rand(0, this.m.Settlements.len() - 1);
			local wp = this.m.Settlements[idx];
			this.m.Settlements.remove(idx);
			waypoints.push(wp);
		}
		//change here
		if (waypoints[0].getFlags().get("IsMainBase"))
		{
			local temp = waypoints.remove(0)
			waypoints.insert(1, temp)
		}
		local party = this.getFaction().spawnEntity(waypoints[0].getTile(), waypoints[0].getName() + " Company", true, this.Const.World.Spawn.Noble, ::Math.rand(120, 250) * this.getReputationToDifficultyLightMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + _faction.getBannerString());
		party.setDescription("Professional soldiers in service to local lords.");
		party.setFootprintType(this.Const.World.FootprintsType.Nobles);
		party.getLoot().Money = ::Math.rand(50, 200);
		party.getLoot().ArmorParts = ::Math.rand(0, 25);
		party.getLoot().Medicine = ::Math.rand(0, 5);
		party.getLoot().Ammo = ::Math.rand(0, 30);
		local r = ::Math.rand(1, 4);

		if (r == 1)
		{
			party.addToInventory("supplies/bread_item");
		}
		else if (r == 2)
		{
			party.addToInventory("supplies/roots_and_berries_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dried_fruits_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/ground_grains_item");
		}

		local c = party.getController();
		local move1 = this.new("scripts/ai/world/orders/move_order");
		move1.setRoadsOnly(true);
		move1.setDestination(waypoints[1].getTile());
		local wait1 = this.new("scripts/ai/world/orders/wait_order");
		wait1.setTime(20.0);
		local move2 = this.new("scripts/ai/world/orders/move_order");
		move2.setRoadsOnly(true);
		move2.setDestination(waypoints[2].getTile());
		local wait2 = this.new("scripts/ai/world/orders/wait_order");
		wait2.setTime(20.0);
		local move3 = this.new("scripts/ai/world/orders/move_order");
		move3.setRoadsOnly(true);
		move3.setDestination(waypoints[0].getTile());
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(move1);
		c.addOrder(wait1);
		c.addOrder(move2);
		c.addOrder(wait2);
		c.addOrder(move3);
		c.addOrder(despawn);
		this.m.Cooldown = this.World.FactionManager.isGreaterEvil() ? 200.0 : 400.0;
		return true;
	}	
})	