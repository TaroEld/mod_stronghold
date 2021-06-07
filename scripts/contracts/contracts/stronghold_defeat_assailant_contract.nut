this.stronghold_defeat_assailant_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		//spawns the enemy when you build/upgrade the base. Uses a scripted fight to set the location. Sets nobles to enemy
		noble_enemy = null,
		Target = null, 
		Destination = null
	},
	function create()
	{
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.createStates();
		this.createScreens();
		this.m.Type = "contract.stronghold_defeat_assailant_contract";
		this.m.Name = "Defeat the enemy army";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1500.0;
	}

	function onImportIntro()
	{
		#this.importSettlementIntro();
	}

	function start()
	{
		//looks for closest settlement. Nobles and southern nobles have multiple options, so loop through and select the closest one
		//missing nomads and other enemies
		//should probably get revamped to be more dynamic
		
		
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		local player_faction = this.Stronghold.getPlayerFaction()
		local player_base = this.Stronghold.getPlayerBase()
		
		local party_difficulty =  300  +  (200 * player_base.m.Size)
		this.m.Destination = this.WeakTableRef(player_base);
		local tile = player_base.getTile();
		local allSettlements = []
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements())
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements())
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getSettlements())
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
				closest_faction = settlement.getOwner() ? settlement.getOwner(): this.World.FactionManager.getFaction(closest_settlement.getFaction());
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
		party.getLoot().ArmorParts = this.Math.rand(10, 30);
		party.getLoot().Medicine = this.Math.rand(1, 3);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		party.getLoot().Money = this.Math.rand(200, 300);
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
		destroy.setTargetID(player_base.getID());
		destroy.setTime(120.0);
		c.addOrder(destroy);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(despawn);
		this.m.IsStarted = true;
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
			local entities = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 3.0);
			foreach(entity in entities)
			{
				if (entity.getDescription() == "A band of mercenaries defending the stronghold.")
				{
					local noble = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse"))
					local player_faction = this.Stronghold.getPlayerFaction()
					noble.removeAlly(player_faction.getID());
					player_faction.removeAlly(noble.getID());

				}
			}
		}
		local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
		p.CombatID = "HoldChokepoint";
		p.Music = this.Const.Music.NobleTracks;
		local isPlayerInitiated = false;
		//special location if fighting at stronghold
		if (this.isPlayerAt(this.m.Home))
		{
			isPlayerInitiated = false;
			p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
			p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
			p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
			p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
			p.LocationTemplate.Template[0] = "tactical.stronghold_fortress_defense";
			p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.WallsAndPalisade;
			p.LocationTemplate.ShiftX = -10;
		}

		this.World.Contracts.startScriptedCombat(p, isPlayerInitiated, true, true);
		
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Running",
			function start()
			{

			}
			function update()
			{
				//select sprites for the base
				if (!this.Contract.m.Flags.get("Sprite_Set") && this.Contract.m.Home.getSize() == 1)
				{
					this.Contract.setScreen("Select_Sprites")
					this.World.Contracts.showActiveContract();
				}
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
						this.Contract.m.Flags.set("combat_won", true);
						this.Contract.setState("After_Battle");
				}
				else if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setState("After_Battle");
				}
					
				else if (this.Contract.isPlayerAt(this.Contract.m.Target))
				{
					this.Contract.onDestinationAttacked(this.Contract.m.Target, false);
				}
			}
			
			
			function onCombatVictory( _combatID )
			{
				this.Contract.m.Flags.set("combat_won", true);
			}			
			
		
			function end()
			{
			}

		});
		this.m.States.push({
			ID = "After_Battle",
			function start()
			{
				if (this.Contract.m.Flags.get("combat_won"))
				{
					this.Contract.setScreen("Victory");
				}
				else{
					this.Contract.setScreen("Failure");
				}
				this.World.Contracts.showActiveContract();
					
			}
			function update()
			{
			}		
			function end()
			{
			}

		});
		

	}

	function createScreens()
	{
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
						this.Stronghold.getPlayerBase().m.Flags.set("BarbarianSprites", true)
						this.Contract.m.Flags.set("Sprite_Set", true)
						this.Stronghold.getPlayerBase().updateTown()
					}

				},
				{
					Text = "Nomad",
					function getResult()
					{
						this.Stronghold.getPlayerBase().m.Flags.set("NomadSprites", true)
						this.Contract.m.Flags.set("Sprite_Set", true)
						this.Stronghold.getPlayerBase().updateTown()

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
		
			ID = "Victory",
			Title = "Victory!",
			Text = "You have defeated the enemies. Your fortress is now secure and you have placed yourself among the lords of these lands.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Excellent.",
					function getResult()
					{
						this.Stronghold.getPlayerFaction().updateAlliancesPlayerFaction()
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
	
	function onPrepareVariables( _vars )
	{
	}

	function onHomeSet()
	{
	}
	
	function onCancel()
	{
		throw("You cannot escape"); //big hax to disallow canceling the contract, should probably do something better
		
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
		this.contract.onDeserialize(_in);

	}

});

