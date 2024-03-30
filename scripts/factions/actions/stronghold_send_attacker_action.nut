this.stronghold_send_attacker_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		TargetBase = null,
		EnemyBase = null,
		AttackedMainBaseCooldown = 7
	},
	function create()
	{
		this.m.ID = "stronghold_send_attacker_action";
		this.m.Cooldown = 3;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local playerBases = _faction.getMainBases();
		if (playerBases.len() == 0)
			return;

		local potentialTargets = {};
		local potentialTargetsArray = [];
		foreach (playerBase in playerBases)
		{
			if (playerBase.hasSituation("situation.raided") || !::Stronghold.isCooldownExpired(playerBase, "LastUpgradeDoneCooldown"))
				continue;
			potentialTargets[playerBase] <- [];
			local enemyBases = this.World.getAllEntitiesAtPos(playerBase.getPos(), playerBase.getEffectRadius() * 100);
			foreach (enemyBase in enemyBases)
			{
				if (playerBase.isIsolatedFromLocation(enemyBase) || !enemyBase.isLocation() || !enemyBase.isLocationType(::Const.World.LocationType.Lair))
					continue;
				// Faction mods needs to make a compatibility patch
				if (!(this.World.FactionManager.getFaction(enemyBase.getFaction()).m.Type in ::Stronghold.FactionDefs))
					continue;
				if (enemyBase.getFlags().has("AttackedMainBaseCooldown" + playerBase.getID()) && !::Stronghold.isCooldownExpired(enemyBase, "AttackedMainBaseCooldown" + playerBase.getID()))
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
		local partyDifficulty = (this.m.EnemyBase.m.Resources  +  (30 * playerBase.getSize())) * this.getScaledDifficultyMult();

		local tile = playerBase.getTile();
		::Stronghold.setCooldown(this.m.EnemyBase, "AttackedMainBaseCooldown" + playerBase.getID(), this.m.AttackedMainBaseCooldown);

		local closest_faction = this.World.FactionManager.getFaction(this.m.EnemyBase.getFaction());

		local factionType = ::Stronghold.FactionDefs[closest_faction.m.Type];
		local party = closest_faction.spawnEntity(this.m.EnemyBase.getTile(), factionType.Name, false, factionType.Spawnlist, partyDifficulty);
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
		party.getLoot().Money = ::Math.rand(200, 300) * playerBase.getSize();
		party.getSprite("banner").setBrush(this.m.EnemyBase.getBanner());
		party.getSprite("selection").Visible = true;

		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local destroy = this.new("scripts/ai/world/orders/stronghold_destroy_order");
		destroy.setTargetID(playerBase.getID());
		destroy.setTargetTile(playerBase.getTile());
		destroy.setTime(120.0);
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
		return true;
	}

});

