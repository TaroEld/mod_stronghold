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
		this.m.Score = 10;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local playerBase = this.Math.randArray(_faction.getMainBases())
		local patrol_strength = 150 * (playerBase.getSize()-1)
		//despawn old mercenaries
		if (_faction.m.Units.len() > 0)
		{
			foreach (unit in _faction.m.Units)
			{
				if (unit.getFlags().get("Stronghold_Guards") && unit.getFlags().get("Stronghold_Base_ID") == playerBase.getID())
				{
					unit.fadeOutAndDie();
				}
			}
		}
		//add strength if you have the attachment
		if (playerBase.hasAttachedLocation("attached_location.militia_trainingcamp")){
			patrol_strength += 200
		}
		local party = _faction.spawnEntity(playerBase.getTile(), "Mercenary guards of " + playerBase.getName(), true, this.Const.World.Spawn.Mercenaries, patrol_strength);
		party.m.OnCombatWithPlayerCallback = null;
		party.getSprite("body").setBrush(playerBase.m.troopSprites);
		party.setDescription(format("A band of mercenaries defending the %s.", playerBase.getSizeName()));
		party.setFootprintType(this.Const.World.FootprintsType.Mercenaries);
		party.getFlags().set("Stronghold_Guards", true);
		party.getFlags().set("Stronghold_Base_ID", playerBase.getID());
		local c = party.getController();

		local totalTime = this.World.getTime().SecondsPerDay * 7
		local locations = playerBase.m.AttachedLocations
		local hamlet = playerBase.getHamlet()
		if (hamlet != false) {
		    locations.push(hamlet)
		}	
		local guard;
		local idleTime = this.World.getTime().SecondsPerDay/3
		//make them patrol the attached locations
		while (totalTime > 0)
		{
			guard = this.new("scripts/ai/world/orders/guard_order");
			guard.setTarget(playerBase.getTile());
			//keep the boys home if upgrading
			if(playerBase.isUpgrading()){
				guard.setTime(totalTime);
				c.addOrder(guard);
				break
			}
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

