this.stronghold_defeat_assailant_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		//spawns the enemy when you build/upgrade the base. Uses a scripted fight to set the location. Sets nobles to enemy
		Target = null, 
		Destination = null,
		TargetLevel = null,
		HasSpawnedUnit = false,
		AttacksRemaining = -1,
		TimeOfNextAttack = -1.0,
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
		this.m.TimeOfNextAttack = this.Time.getVirtualTimeF() +  ::Math.rand(12, 24) * this.World.getTime().SecondsPerHour
		this.m.Name = format("Defend your %s", this.getHome().getSizeName());
		this.World.Contracts.setActiveContract(this);
		this.setState("Running")
	}

	function getBanner()
	{
		return "ui/banners/factions/banner_06s"
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
				else if (!this.Contract.m.HasSpawnedUnit && this.Time.getVirtualTimeF() > this.Contract.m.TimeOfNextAttack && this.Contract.m.AttacksRemaining > 0)
				{
					this.Contract.setScreen("Enemies_Incoming")
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.HasSpawnedUnit && (this.Contract.m.Target == null || this.Contract.m.Target.isNull()))
				{
					if (this.Contract.m.AttacksRemaining > 0){
						this.Contract.m.HasSpawnedUnit = false
						this.Contract.setScreen("Victory_More_Left");
					}
					else this.Contract.setScreen("Victory_None_Left");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Origin.getFlags().get("BuildInterrupted"))
				{
					this.Contract.setScreen("FailureBuild");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Origin.getFlags().get("UpgradeInterrupted")){
					this.Contract.setScreen("FailureInterrupt");
					this.World.Contracts.showActiveContract();
				}
			}
			
			
			function onCombatVictory( _combatID )
			{
				if (_combatID == "Stronghold"){
					this.Contract.m.Target = null
				}
			}
			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Stronghold")
				{
					if(this.Contract.m.Origin.getSize() == 1)
						this.Contract.m.Origin.getFlags().set("UpgradeInterrupted", true);
					else
						this.Contract.m.Origin.getFlags().set("BuildInterrupted", true);
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
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = false,
			ShowEmployer = false,
			ShowDifficulty = false,
			function start()
			{
				
				this.Text = format("Your %s is now under construction. This will take %i %s. Enemies will attack it within the next day.", ::Stronghold.Tiers[this.Contract.m.TargetLevel].Name, this.Contract.m.TargetLevel, this.Contract.m.TargetLevel == 1 ? " day" : " days") ;
				this.Contract.m.BulletpointsObjectives = [
					format("Defend against %i more %s", this.Contract.m.AttacksRemaining, this.Contract.m.AttacksRemaining == 1 ? "attack." : "attacks.")
				];
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
				this.Text = "Your scouts have informed you that the enemies are imminent, hailing from the " + this.Const.Strings.Direction8[this.Contract.m.Home.getTile().getDirection8To(this.Contract.m.Target.getTile())]
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

						this.Contract.m.TimeOfNextAttack = this.Time.getVirtualTimeF() +  (::Math.rand(12, 24) * this.World.getTime().SecondsPerHour)
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
						this.Contract.m.Home.finishUpgrading(true);
						local playerFaction = this.Stronghold.getPlayerFaction()
						//spawn new guards to reflect the change in size
						this.Stronghold.getPlayerFaction().updateAlliancesPlayerFaction()
						foreach(card in playerFaction.m.Deck){
							if (card.getID() == "stronghold_guard_base_action"){
								card.m.PlayerBase = this.Contract.m.Home;
								card.execute(playerFaction);
							}
						}
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
				this.Text = format("You have defeated the enemies. Your %s is now secure.", this.Stronghold.Tiers[this.Contract.m.TargetLevel].Name)
			}
		});
		
		this.m.Screens.push({
			ID = "FailureBuild",
			Title = "Failure!",
			Text = "{You ran from the battle. Your fortress has been wiped from the map. You are a failure!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "This was unwise.",
					function getResult()
					{
						if (this.Contract.m.Target != null || !this.Contract.m.Target.isNull())
						{
							this.Contract.m.Target.die()
						}
						this.Contract.m.Home.fadeOutAndDie(true)
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
		this.m.Screens.push({
			ID = "FailureInterrupt",
			Title = "Failure!",
			Text = "{You ran from the battle. Your upgrade has been interrupted, and your base knocked back to the previous level.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We'll get them next time.",
					function getResult()
					{
						if (this.Contract.m.Target != null || !this.Contract.m.Target.isNull())
						{
							this.Contract.m.Target.die()
						}
						this.Contract.m.Home.finishUpgrading(false);
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
		local playerFaction = this.Stronghold.getPlayerFaction();
		local playerBase = this.m.Home;
		local partyDifficulty = this.Stronghold.getBaseFightDifficulty(this);
		local wave = this.m.TargetLevel / this.m.AttacksRemaining;
		
		this.m.Destination = this.WeakTableRef(playerBase);
		local tile = playerBase.getTile();
		local allSettlements = []
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements())
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements())
		if(this.Const.DLC.Wildmen) allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getSettlements())
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getSettlements())
		allSettlements.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements())
		foreach (noble in  this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse)){
			if(noble.getPlayerRelation() < 70 ) allSettlements.extend(noble.getSettlements())
			
		}
		foreach (noble in  this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState)){
			if(noble.getPlayerRelation() < 70 ) allSettlements.extend(noble.getSettlements())
			
		}
		
		local closest = 9999
		local closest_settlement;
		foreach (settlement in allSettlements)
		{
			if( settlement == null || this.m.Flags.has(settlement.getID())) continue
			if (playerBase.isIsolatedFromLocation(settlement)) continue;

			local distance = settlement.getTile().getDistanceTo(tile)
			if (closest_settlement == null || distance < closest)
			{
				
				closest = distance
				closest_settlement = settlement
			}
		}
		local closest_faction = closest_settlement.getOwner() ? closest_settlement.getOwner() : this.World.FactionManager.getFaction(closest_settlement.getFaction());
		::Stronghold.getHostileFaction().copyLooks(closest_faction);

		local factionType = ::Stronghold.FactionDefs[closest_faction.m.Type]
		local party = ::Stronghold.getHostileFaction().spawnEntity(closest_settlement.getTile(), factionType.Name, false, factionType.Spawnlist, partyDifficulty);
		party.setDescription(factionType.Description);
		party.setFootprintType(factionType.Footprint);
		party.setMovementSpeed(70.0);
		party.setAttackableByAI(false);
		party.setVisibleInFogOfWar(true);
		party.setImportant(true);
		party.setDiscovered(true);
		party.getLoot().ArmorParts = ::Math.rand(10, 30) * wave;
		party.getLoot().Medicine = ::Math.rand(1, 3) * wave;
		party.getLoot().Ammo = ::Math.rand(0, 30) * wave ;
		party.getLoot().Money = ::Math.rand(200, 300) * wave;
		party.getSprite("banner").setBrush(closest_settlement.getBanner());
		party.getSprite("selection").Visible = true
		this.m.Target = this.WeakTableRef(party);


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

		//spawn new mercs to help you in the fight
		local playerFaction = this.Stronghold.getPlayerFaction();
		foreach(card in playerFaction.m.Deck)
		{
			if (card.getID() == "stronghold_guard_base_action")
			{
				card.m.PlayerBase = this.m.Home;
				card.execute(playerFaction);
			}
		}

		//can't get the same location twice
		this.m.Flags.set(closest_settlement.getID(), true)
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
		}
		this.m.TimeOfNextAttack = _in.readF32()
		this.m.TargetLevel = _in.readI32()
		this.m.HasSpawnedUnit = _in.readBool()
		this.m.AttacksRemaining = _in.readI32()
		this.contract.onDeserialize(_in);
	}
});

