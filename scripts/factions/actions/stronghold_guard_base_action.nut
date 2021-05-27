this.stronghold_guard_base_action <- this.inherit("scripts/factions/faction_action", {
	//spawns the mercs that defend the base.
	//they patrol around the settlement and the attached locations
	m = {},
	function create()
	{
		this.m.ID = "stronghold_guard_base_action";
		//spawn them once a week
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 7;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		//only works with level 2+ base
		local player_base = this.Stronghold.getPlayerBase()
		if (!player_base || player_base.getSize() == 1)
		{
			return
		}

		this.m.Score = 10;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local settlements = _faction.getSettlements();
		local player_base = this.Stronghold.getPlayerBase()
		local patrol_strength = 150 * (player_base.getSize()-1)
		//despawn old mercenaries
		if (_faction.m.Units.len() > 0)
		{
			foreach (unit in _faction.m.Units)
			{
				if (unit.getFlags().get("Stronghold_Guards"))
				{
					unit.fadeOutAndDie();
				}
			}
		}
		//add strength if you have the attachment
		if (player_base.hasAttachedLocation("attached_location.militia_trainingcamp")){
			patrol_strength += 200
		}
		local party = _faction.spawnEntity(player_base.getTile(), "Mercenary guards of " + player_base.getName(), true, this.Const.World.Spawn.Mercenaries, patrol_strength);
		party.m.OnCombatWithPlayerCallback = null;
		party.getSprite("body").setBrush(player_base.m.troopSprites);
		party.setDescription("A band of mercenaries defending the stronghold.");
		party.setFootprintType(this.Const.World.FootprintsType.Mercenaries);
		party.getFlags().set("Stronghold_Guards", true);
		local c = party.getController();
		local totalTime = this.World.getTime().SecondsPerDay * 7
		local locations = player_base.m.AttachedLocations
		foreach(settlement in this.Stronghold.getPlayerFaction().getSettlements())
		{
			if (settlement.getID() != player_base.getID()) {
			    locations.push(settlement)
			}	
		}
		local guard;
		local idleTime = this.World.getTime().SecondsPerDay/3
		//make them patrol the attached locations
		while (totalTime > 0)
		{
			guard = this.new("scripts/ai/world/orders/guard_order");
			guard.setTarget(player_base.getTile());
			guard.setTime(idleTime);
			c.addOrder(guard);
			totalTime -= idleTime
			foreach (location in locations)
			{
				guard = this.new("scripts/ai/world/orders/guard_order");
				guard.setTarget(location.getTile());
				guard.setTime(idleTime);
				c.addOrder(guard);
				totalTime -= idleTime
			}
		}
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(despawn);
		return true;
	}

});

