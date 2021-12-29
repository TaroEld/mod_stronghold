this.stronghold_defeat_assailant_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		//spawns the enemy when you build/upgrade the base. Uses a scripted fight to set the location. Sets nobles to enemy
		noble_enemy = null,
		Target = null, 
		Destination = null,
		TargetLevel = null,
		HasSpawnedUnit = false,
		AttacksRemaining = -1,
		TimeOfNextAttack = -1.0
	},
	function create()
	{
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.m.Type = "contract.stronghold_defeat_assailant_contract";
		this.m.Name = ""
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1500.0;
		this.createStates();
		this.createScreens();
	}

	function onImportIntro()
	{
		#this.importSettlementIntro();
	}

	function start()
	{
		//looks for closest settlement. Nobles and southern nobles have multiple options, so loop through and select the closest one
		this.m.IsStarted = true;
		this.m.AttacksRemaining = this.m.TargetLevel
		this.m.TimeOfNextAttack = this.Time.getVirtualTimeF() +  this.Math.rand(12, 24) * this.World.getTime().SecondsPerHour
		this.m.Name = format("Defend your %s", this.getHome().getSizeName());
		this.World.Contracts.setActiveContract(this);
		this.setState("Running")
	}


	
	function getBanner()
	{
		return "ui/banners/factions/banner_06s"
	}
	
	function onDestinationAttacked(_dest, _isPlayerAttacking)
	{
		//sets noble to enemy, also makes sure mercs join
		if (this.m.Flags.get("EnemyNobleHouse"))
		{
			this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse")).setIsTemporaryEnemy(true)
			local entities = this.World.getAllEntitiesAtPos(this.getHome().getPos(), 3.0);
			foreach(entity in entities)
			{
				if (entity.getFlags().get("Stronghold_Guards"))
				{
					local noble = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse"))
					local playerFaction = this.Stronghold.getPlayerFaction()
					noble.removeAlly(playerFaction.getID());
					playerFaction.removeAlly(noble.getID());

				}
			}
		}
		
		
		
		local isPlayerInitiated = false;
		local p;
		//special location if fighting at stronghold
		if (this.getVecDistance(this.getHome().getPos(), this.World.State.getPlayer().getPos()) <= 250)
		{
			p = this.World.State.getLocalCombatProperties(this.getHome().getPos());
			isPlayerInitiated = true;
			p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
			p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
			p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
			p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
			p.LocationTemplate.Template[0] = "tactical.stronghold_fortress_defense";
			p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.WallsAndPalisade;
			p.LocationTemplate.ShiftX = -10;
		}
		else p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
		p.Music = this.Const.Music.NobleTracks;
		p.CombatID = "Stronghold";
		this.World.Contracts.startScriptedCombat(p, isPlayerInitiated, true, true);
		
		
	}


	function createStates()
	{
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					format("Defend against %i more %s", this.Contract.m.AttacksRemaining, this.Contract.m.AttacksRemaining == 1 ? "attack." : "attacks.")
				];
			}
			function update()
			{
				//have to do the intial screen this way, otherwise it doesnt show since the last event is still acti ve

				if (this.Contract.m.Flags.get("Introduced") != true)
				{
					this.Contract.setScreen("Under_Construction")
					//circumvents log spam
					this.World.Contracts.m.LastShown = this.Contract;
					this.World.Contracts.m.IsEventVisible = true;
					this.World.State.showEventScreen(this.Contract, true, true)
				} 
				if (!this.Contract.m.HasSpawnedUnit && this.Time.getVirtualTimeF() > this.Contract.m.TimeOfNextAttack && this.Contract.m.AttacksRemaining > 0)
				{
					this.Contract.setScreen("Enemies_Incoming")
					this.World.Contracts.showActiveContract();
				}
				//different sprites, disabled for now
				/*
				if (!this.Contract.m.Flags.get("Sprite_Set") && this.Contract.m.Home.getSize() == 1)
				{
					this.Contract.setScreen("Select_Sprites")
					this.World.Contracts.showActiveContract();
				}*/
				if (this.Contract.m.HasSpawnedUnit && (this.Contract.m.Target == null || this.Contract.m.Target.isNull()))
				{
					if (this.Contract.m.AttacksRemaining > 0){
						this.Contract.m.HasSpawnedUnit = false
						this.Contract.setScreen("Victory_More_Left");
					}
					else this.Contract.setScreen("Victory_None_Left");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
					
				if (this.Contract.m.Target != null && this.Contract.isPlayerAt(this.Contract.m.Target))
				{
					this.Contract.onDestinationAttacked(this.Contract.m.Target, false);
				}
			}
			
			
			function onCombatVictory( _combatID )
			{
				if (_combatID == "Stronghold"){
					this.Contract.m.Target = null
				}

			}			
			

		});		

	}

	function createScreens()
	{
		this.m.Screens.push({
		
			ID = "Under_Construction",
			Title = "Now under construction",
			Text = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let us prepare.",
					function getResult()
					{
						this.Contract.m.Flags.set("Introduced", true)
						this.Contract.m.Home.setUpgrading(true);
						this.Contract.m.Home.updateTown();

						local playerFaction = this.Stronghold.getPlayerFaction();
						foreach(card in playerFaction.m.Deck){
							if (card.getID() == "stronghold_guard_base_action"){
								card.m.PlayerBase = this.Contract.m.Home;
								card.execute(playerFaction);
							}
						}
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = false,
			ShowEmployer = false,
			ShowDifficulty = false,
			function start()
			{
				
				this.Text = format("Your %s is now under construction. This will take %i %s. Enemies will attack it within the next day.", this.Const.World.Stronghold.BaseNames[this.Contract.m.TargetLevel-1], this.Contract.m.TargetLevel, this.Contract.m.TargetLevel == 1 ? " day" : " days") ;
				this.Contract.m.BulletpointsObjectives = [
					format("Defend against %i more %s", this.Contract.m.AttacksRemaining, this.Contract.m.AttacksRemaining == 1 ? "attack." : "attacks.")
				];
			}
		});
		this.m.Screens.push({
		
			ID = "Select_Sprites",
			Title = "Select faction",
			Text = "What style should your base look like? This is purely cosmetic.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Noble (default).",
					function getResult()
					{
						this.Contract.m.Flags.set("Sprite_Set", true)
					}

				},
				{
					Text = "Barbarian",
					function getResult()
					{
						this.Contract.m.Home.m.Flags.set("BarbarianSprites", true)
						this.Contract.m.Flags.set("Sprite_Set", true)
						this.Contract.m.Home.updateTown()
					}

				},
				{
					Text = "Nomad",
					function getResult()
					{
						this.Contract.m.Home.m.Flags.set("NomadSprites", true)
						this.Contract.m.Flags.set("Sprite_Set", true)
						this.Contract.m.Home.updateTown()

					}

				},
			],
			ShowObjectives = false,
			ShowPayment = false,
			ShowEmployer = false,
			ShowDifficulty = false,
			function start()
			{
			}
		});
		this.m.Screens.push({
		
			ID = "Enemies_Incoming",
			Title = "Incoming!",
			Text = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prepare for battle!",
					function getResult()
					{
						return 0;
					}

				},
			],
			ShowObjectives = false,
			ShowPayment = false,
			ShowEmployer = false,
			ShowDifficulty = false,
			function start()
			{
				this.Contract.spawnNewAttackers()
				this.Text = "Your scouts have informed you that the enemies are imminent, hailing from the " + this.Const.Strings.Direction8[this.Contract.m.Home.getTile().getDirectionTo(this.Contract.m.Target.getTile())]
			}
		});
		this.m.Screens.push({
		
			ID = "Victory_More_Left",
			Title = "Victory!",
			Text = "You have defeated the enemies, but it is not over yet. You can expect another attack during the next day.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let's prepare.",
					function getResult()
					{

						this.Contract.m.TimeOfNextAttack = this.Time.getVirtualTimeF() +  (this.Math.rand(12, 24) * this.World.getTime().SecondsPerHour)
						return 0;
					}

				},
			],
			ShowObjectives = true,
			ShowPayment = false,
			ShowEmployer = false,
			ShowDifficulty = false,
			function start()
			{
				this.Contract.m.BulletpointsObjectives[0] = format("Defend against %i more %s", this.Contract.m.AttacksRemaining, this.Contract.m.AttacksRemaining == 1 ? "attack." : "attacks.")
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}
		});
		this.m.Screens.push({
		
			ID = "Victory_None_Left",
			Title = "Victory!",
			Text = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Excellent.",
					function getResult()
					{
						local playerFaction = this.Stronghold.getPlayerFaction()
						local playerBase = this.Contract.m.Home
						//upgrade looks and situation
						playerBase.m.Size = this.Contract.m.TargetLevel;
						playerBase.buildHouses();
						//spawn new guards to reflect the change in size
						foreach(card in playerFaction.m.Deck){
							if (card.getID() == "stronghold_guard_base_action"){
								card.m.PlayerBase = this.Contract.m.Home;
								card.execute(playerFaction);
							}
						}
						this.Stronghold.getPlayerFaction().updateAlliancesPlayerFaction()
						playerBase.m.Flags.set("LevelOne", false)
						this.Contract.m.Home.setUpgrading(false);
						this.Contract.m.Home.updateTown()
						this.World.Contracts.finishActiveContract();
						return 0;

					}

				},
			],
			ShowObjectives = false,
			ShowPayment = false,
			ShowEmployer = false,
			ShowDifficulty = false,
			function start()
			{
				this.Text = format("You have defeated the enemies. Your %s is now secure.", this.Const.World.Stronghold.BaseNames[this.Contract.m.TargetLevel-1])
			}
		});
		
		this.m.Screens.push({
			ID = "Failure",
			Title = "Failure!",
			Text = "{You ran from the battle. Your fortress has been wiped from the map. You are a failure!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "This was unwise.",
					function getResult()
					{
						this.Stronghold.getPlayerFaction().updateAlliancesPlayerFaction()
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				},
			],
			function start()
			{
			}

		});
	}
	function spawnNewAttackers()
	{
		local playerFaction = this.Stronghold.getPlayerFaction()
		local playerBase = this.m.Home
		local wave =  this.m.TargetLevel / this.m.AttacksRemaining 
		local party_difficulty =  (150 + 50 * wave) * this.getScaledDifficultyMult()
		this.m.Destination = this.WeakTableRef(playerBase);
		local tile = playerBase.getTile();
		local allSettlements = []
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements())
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements())
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getSettlements())
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getSettlements())
		foreach (noble in  this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse)){
			if(noble.getPlayerRelation() < 70 ) allSettlements.extend(noble.getSettlements())
			
		}
		foreach (noble in  this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState)){
			if(noble.getPlayerRelation() < 70 ) allSettlements.extend(noble.getSettlements())
			
		}
		
		local closest = 9999
		local closest_settlement;
		local closest_faction;

		foreach (settlement in allSettlements)
		{
			if(!settlement) continue
			local distance = settlement.getTile().getDistanceTo(tile)
			if (distance && distance < closest)
			{
				closest = distance
				closest_settlement = settlement
				closest_faction = settlement.getOwner() ? settlement.getOwner() : this.World.FactionManager.getFaction(closest_settlement.getFaction());
			}
		}
		//some kinda bug makes distance be 0 sometimes, need to figure it out but until then set to 9999 if 0
		local party;
		local origin;
		
		if (closest_faction.m.Type == this.Const.FactionType.Goblins)
		{
			party = closest_faction.stronghold_spawnEntity(closest_settlement.getTile(), "Goblin Raiders", false, this.Const.World.Spawn.GoblinRaiders, party_difficulty);
			party.setDescription("A warband of goblins.");
			party.setFootprintType(this.Const.World.FootprintsType.Goblins);
		}
		else if (closest_faction.m.Type == this.Const.FactionType.Barbarians)
		{
			party = closest_faction.stronghold_spawnEntity(closest_settlement.getTile(), "Barbarians", false, this.Const.World.Spawn.Barbarians, party_difficulty);
			party.setDescription("A warband of barbarian tribals.");
			party.setFootprintType(this.Const.World.FootprintsType.Barbarians);
		}
		else if (closest_faction.m.Type == this.Const.FactionType.OrientalBandits)
		{
			party = closest_faction.stronghold_spawnEntity(closest_settlement.getTile(), "Nomads", false, this.Const.World.Spawn.NomadDefenders, party_difficulty);
			party.setDescription("A warband of nomads.");
			party.setFootprintType(this.Const.World.FootprintsType.Nomads);
		}
		else if (closest_faction.m.Type == this.Const.FactionType.NobleHouse)
		{
			party = closest_faction.stronghold_spawnEntity(closest_settlement.getTile(), "Noble Army", false, this.Const.World.Spawn.Noble, party_difficulty);
			party.setDescription("An army of noble soldiers.");
			party.setFootprintType(this.Const.World.FootprintsType.Nobles);
			this.m.Flags.set("EnemyNobleHouse", closest_faction.getID());
			
		}
		else if (closest_faction.m.Type == this.Const.FactionType.OrientalCityState)
		{
			party = closest_faction.stronghold_spawnEntity(closest_settlement.getTile(), "City State Army", false, this.Const.World.Spawn.Southern, party_difficulty);
			party.setDescription("An army of city state soldiers.");
			party.setFootprintType(this.Const.World.FootprintsType.Nobles);
			this.m.Flags.set("EnemyNobleHouse", closest_faction.getID())
		}
		else
		{
			party = closest_faction.stronghold_spawnEntity(closest_settlement.getTile(), "Orc Marauders", false, this.Const.World.Spawn.OrcRaiders, party_difficulty);
			party.setDescription("A warband of orcs.");
			party.setFootprintType(this.Const.World.FootprintsType.Orcs);
		}

		origin = closest_settlement;
		//spawn the party, assign AI controller, give the order to intercept the player. switches contract state to running straight away, no offer here
		party.getLoot().ArmorParts = this.Math.rand(10, 30) * wave;
		party.getLoot().Medicine = this.Math.rand(1, 3) * wave;
		party.getLoot().Ammo = this.Math.rand(0, 30) * wave ;
		party.getLoot().Money = this.Math.rand(200, 300) * wave;
		party.getSprite("banner").setBrush(origin.getBanner());
		party.getSprite("selection").Visible = true
		party.setMovementSpeed(70);
		party.setAttackableByAI(false);
		party.setVisibleInFogOfWar(true);
		party.setImportant(true);
		party.setDiscovered(true);
		this.m.Target = this.WeakTableRef(party);
		party.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local destroy = this.new("scripts/ai/world/orders/stronghold_destroy_order");
		destroy.setTargetTile(tile);
		destroy.setTargetID(playerBase.getID());
		destroy.setTime(120.0);
		c.addOrder(destroy);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(despawn);
		this.m.HasSpawnedUnit = true;
		this.m.AttacksRemaining--
	}
	
	function onPrepareVariables( _vars )
	{
	}

	function onHomeSet()
	{
	}
	
	function onCancel()
	{
		throw("You cannot escape"); //big hax to disallow canceling the contract, should probably do something better lmao right
		
	}
	
	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			if(!this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Player)[0].m.Settlements.len() == 0){
				this.m.Home.getSprite("selection").Visible = false;
			}

		}

	}

	function onIsValid()
	{
		return true;
	}
	function cancel()
	{
		this.onCancel();
	}

	function onSerialize( _out )
	{
		_out.writeI32(0);

		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}
		_out.writeF32(this.m.TimeOfNextAttack)
		_out.writeI32(this.m.TargetLevel)
		_out.writeBool(this.m.HasSpawnedUnit)
		_out.writeI32(this.m.AttacksRemaining)
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		_in.readI32();
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
			this.m.Target.getSprite("selection").Visible = true
			this.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
		}
		this.m.TimeOfNextAttack = _in.readF32()
		this.m.TargetLevel = _in.readI32()
		this.m.HasSpawnedUnit = _in.readBool()
		this.m.AttacksRemaining = _in.readI32()
		this.contract.onDeserialize(_in);

	}

});

