this.stronghold_guard_base_action <- this.inherit("scripts/factions/faction_action", {
	//spawns the mercs that defend the base.
	//they patrol around the settlement and the attached locations
	m = {
		PlayerBase = null,
	},
	function create()
	{
		this.m.ID = "stronghold_guard_base_action";
		//spawn them once a week
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 1;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local basesRequiringMercs = [];
		local mercIDs = [];
		foreach(playerBase in _faction.getMainBases())
		{
			if (mercIDs.find(playerBase.getID()) == null && ::Stronghold.isCooldownExpired(playerBase, "TimeUntilNextMercs"))
				basesRequiringMercs.push(playerBase);
		}
		if (basesRequiringMercs.len() == 0) return
		this.m.PlayerBase = ::MSU.Array.rand(basesRequiringMercs);
		//only works with level 2+ base
		this.m.Score = 100;
	}

	function onClear()
	{
		this.m.PlayerBase = null;
		this.m.Score = 0;
	}

	function onExecute( _faction)
	{
		local playerBase = this.m.PlayerBase
		if (playerBase == null) return //failsave
		foreach(unit in _faction.m.Units){
			if (unit.getFlags().get("Stronghold_Guards") && unit.getFlags().get("Stronghold_Base_ID") == playerBase.getID()){
				unit.fadeOutAndDie();
			}
		}

		local partyStrength = 50 * (playerBase.getSize() + 1);
		local trainingCamp = playerBase.getLocation( "attached_location.militia_trainingcamp" );
		if (trainingCamp)
			partyStrength += trainingCamp.getAlliedPartyStrengthIncrease();
		partyStrength *=  this.getReputationToDifficultyLightMult();


		local party = _faction.spawnEntity(playerBase.getTile(), "Mercenary guards of " + playerBase.getName(), true, this.Const.World.Spawn.Mercenaries, partyStrength);
		party.m.OnCombatWithPlayerCallback = null;
		party.getSprite("body").setBrush(playerBase.m.TroopSprites);
		party.setDescription(format("A band of mercenaries defending the %s.", playerBase.getSizeName()));
		party.setFootprintType(this.Const.World.FootprintsType.Mercenaries);
		party.getFlags().set("Stronghold_Guards", true);
		party.getFlags().set("Stronghold_Base_ID", playerBase.getID());
		::Stronghold.setCooldown(playerBase, "TimeUntilNextMercs");
		local c = party.getController();

		local totalTime = this.World.getTime().SecondsPerDay * 7
		local locations = []
		locations.extend(playerBase.m.AttachedLocations)
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
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false)
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false)
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

