this.stronghold_send_attacker_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		TargetBase = null,
		EnemyBase = null,
	},
	function create()
	{
		this.m.ID = "stronghold_send_attacker_action";
		this.m.Cooldown = 3;
		this.m.IsSettlementsRequired = false;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (!::Stronghold.Misc.BaseAttacksEnabled)
			return;
		local playerFaction = ::Stronghold.getPlayerFaction();
		if (playerFaction == null)
			return;
		local playerBases = playerFaction.getMainBases();
		if (playerBases.len() == 0)
			return;


		local potentialTargets = {};
		local potentialTargetsArray = [];
		foreach (playerBase in playerBases)
		{
			if (::Stronghold.Mod.Debug.isEnabled())
			{
				::Stronghold.Mod.Debug.printLog("Evaluating base attack for player base " + playerBase.getName());
				::Stronghold.Mod.Debug.printLog("LastUpgradeDoneAttackCooldown " + ::Stronghold.isCooldownExpired(playerBase, "LastUpgradeDoneAttackCooldown"));
				::Stronghold.Mod.Debug.printLog("AttackedCooldown " + ::Stronghold.isCooldownExpired(playerBase, "AttackedCooldown"));
			}
			if (playerBase.hasSituation("situation.raided") || playerBase.isUpgrading() || !::Stronghold.isCooldownExpired(playerBase, "LastUpgradeDoneAttackCooldown") || !::Stronghold.isCooldownExpired(playerBase, "AttackedCooldown"))
				continue;
			potentialTargets[playerBase] <- [];
			local enemyBases = this.World.getAllEntitiesAtPos(playerBase.getPos(), playerBase.getEffectRadius() * 120);
			::Stronghold.Mod.Debug.printLog("Number of enemyBases " + enemyBases.len());
			foreach (enemyBase in enemyBases)
			{
				if (::Stronghold.Mod.Debug.isEnabled() && enemyBase.isLocation())
				{
					::Stronghold.Mod.Debug.printLog("Evaluating base attack for enemy base " + enemyBase.getName());
					::Stronghold.Mod.Debug.printLog("isIsolatedFromLocation " + playerBase.isIsolatedFromLocation(enemyBase));
					::Stronghold.Mod.Debug.printLog("isLocationType " + enemyBase.isLocationType(::Const.World.LocationType.Lair));
					::Stronghold.Mod.Debug.printLog("AttackerCooldown " + ::Stronghold.isCooldownExpired(enemyBase, "AttackerCooldown"))
				};
				if (!enemyBase.isLocation() || playerBase.isIsolatedFromLocation(enemyBase) || !enemyBase.isLocationType(::Const.World.LocationType.Lair))
					continue;
				// Faction mods needs to make a compatibility patch
				if (!(this.World.FactionManager.getFaction(enemyBase.getFaction()).m.Type in ::Stronghold.FactionDefs))
					continue;
				if (!::Stronghold.isCooldownExpired(enemyBase, "AttackerCooldown"))
					continue
				potentialTargets[playerBase].push(enemyBase);
				potentialTargetsArray.push(playerBase); // odds increase by number of enemy bases
			}
		}
		if (potentialTargetsArray.len() == 0)
			return;
		local targetBase = ::MSU.Array.rand(potentialTargetsArray);
		this.m.TargetBase = ::WeakTableRef(targetBase);
		this.m.EnemyBase = ::WeakTableRef(::MSU.Array.rand(potentialTargets[targetBase]));
		this.m.Score = 1;
	}

	function onClear()
	{
		this.m.TargetBase = null;
		this.m.EnemyBase = null;
	}

	function onExecute( _faction )
	{
		local playerBase = this.m.TargetBase;
		::Stronghold.Mod.Debug.printLog("SENDING base attack for player base " + playerBase.getName() + " from : " + this.m.EnemyBase.getName());

		local partyDifficulty = (this.m.EnemyBase.m.Resources  +  (30 * playerBase.getSize())) * this.getScaledDifficultyMult() * ::Stronghold.Misc.BaseAttackStrengthMultiplier;

		local tile = playerBase.getTile();

		local closest_faction = this.World.FactionManager.getFaction(this.m.EnemyBase.getFaction());
		::Stronghold.getHostileFaction().copyLooks(closest_faction);

		local factionType = ::Stronghold.FactionDefs[closest_faction.m.Type];
		local party = ::Stronghold.getHostileFaction().spawnEntity(this.m.EnemyBase.getTile(), factionType.Name, false, factionType.Spawnlist, partyDifficulty);
		party.setDescription(factionType.Description);
		party.setFootprintType(factionType.Footprint);
		party.setMovementSpeed(70.0);
		party.setAttackableByAI(true);
		party.setVisibleInFogOfWar(true);
		party.setImportant(true);
		party.setDiscovered(true);
		party.getLoot().ArmorParts = ::Math.rand(10, 30) * playerBase.getSize();
		party.getLoot().Medicine = ::Math.rand(1, 3) * playerBase.getSize();
		party.getLoot().Ammo = ::Math.rand(0, 30) * playerBase.getSize() ;
		party.getLoot().Money = ::Math.rand(partyDifficulty * 0.75, partyDifficulty * 1.5);
		party.getSprite("banner").setBrush(this.m.EnemyBase.getBanner());
		party.getSprite("selection").Visible = true;
		party.getFlags().set(::Stronghold.Flags.StrongholdAttacker, true);

		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(this.World.getTime().SecondsPerDay);
		c.addOrder(wait);

		local destroy = this.new("scripts/ai/world/orders/stronghold_destroy_order");
		destroy.setTargetID(playerBase.getID());
		destroy.setTargetTile(playerBase.getTile());
		destroy.setTime(this.World.getTime().SecondsPerDay * 3);
		c.addOrder(destroy);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(despawn);

		local watchtower = playerBase.getLocation("attached_location.stone_watchtower")
		if (watchtower != null)
		{
			local news = this.World.Statistics.createNews();
			news.set("destination", this.m.TargetBase.getName());
			news.set("origin", this.m.EnemyBase.getName());
			news.set("direction", this.Const.Strings.Direction8[this.m.TargetBase.getTile().getDirection8To(this.m.EnemyBase.getTile())]);
			this.World.Statistics.addNews("stronghold_attackers", news);
		}

		playerBase.getFlags().set(::Stronghold.Flags.UnderAttackBy, party.getID());
		::Stronghold.setCooldown(playerBase.get(), "AttackedCooldown");
		::Stronghold.setCooldown(this.m.EnemyBase, "AttackerCooldown");

		return true;
	}

});

