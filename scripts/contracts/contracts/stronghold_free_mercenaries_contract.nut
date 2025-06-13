this.stronghold_free_mercenaries_contract <- this.inherit("scripts/contracts/contract", {
	//unlock hiring mercenaries
	//fight noble patrol going between two settlements
	//get hired mercenaries on success + flag in base to hire more in the future 
	m = {
		Reward = 0,
		Origin = null,
		Target = null,
		Title = "Free the mercenaries",
		LastCombatTime = 0.0,
		Destination = null,
		Enemy_Faction = null,
	},
	function create()
	{
		this.m.DifficultyMult = ::Math.rand(116, 130) * 0.01;
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.createStates();
		this.createScreens();
		this.m.Type = "contract.stronghold_free_mercenaries_contract";
		this.m.Name = "Free the mercenaries";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1500.0;
	}

	function onImportIntro()
	{
		#this.importSettlementIntro();
	}

	function start()
	{
		this.contract.start();
	}
	
	function getBanner()
	{
		return "ui/banners/factions/banner_09s"
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Hunt down the noble caravan",
					"Don't let their men escape"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{					
				this.World.Contracts.setActiveContract(this.Contract);
				this.Contract.setScreen("Overview_Building");
			}

		});
		
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target)
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setVisibleInFogOfWar(true);
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
					local originTown = null;
					local originID = this.Contract.m.Flags.get("OriginID");
					foreach(settlement in ::World.EntityManager.getSettlements())
					{
						if (settlement.getID() == originID)
						{
							originTown = settlement;
							break;
						}
					}
					local originTownName = originTown == null ? "" : originTown.getName();

					this.Contract.m.BulletpointsObjectives = [
						"Hunt down the noble caravan moving from " + originTownName + " to " + this.Contract.m.Destination.getName(),
						"Don't let it reach its destination, and don't let anyone flee the battle!"
					];
				}
			}
			
			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("TalkingToTheSurvivors");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isEntityAt(this.Contract.m.Target, this.Contract.m.Destination))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Target))
				{
					this.onTargetAttacked(this.Contract.m.Target, false);
				}
			}
			
			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Time.getVirtualTimeF() >= this.Contract.m.LastCombatTime + 5.0)
				{
					this.Contract.m.LastCombatTime = this.Time.getVirtualTimeF();
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}
			
			function onActorRetreated( _actor, _combatID )
			{
				if (!_actor.isNonCombatant() && _actor.getFaction() == ::World.FactionManager.getFactionOfType(this.Const.FactionType.StrongholdEnemies).getID())
				{
					this.Contract.m.Flags.set("Survivors", this.Contract.m.Flags.get("Survivors") + 1);
				}
			}
			
		
		});
		
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Return to " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Contract.m.Flags.get("Survivors") > 3)
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Success1");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
	}

	function createScreens()
	{	
		this.m.Screens.push({
			ID = "Task",
			Title = this.m.Title,
			Text = "Word has reached us that a band of mercenaries is being transported to a fortress, awaiting execution for a crime they almost certainly weren't being spotted committing. The mercenary community is in uproar about yet another unfair treatment of entirely honest brothers in arms.\n%randombrother% suggests that we could score some points if we went and helped those poor souls out of their predicatment. We probably shouldn't be seen doing it, though.",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "What are my options?",
					function getResult()
					{
						
						return "Overview_Building";
					}

				},
				{
					Text = "I don't want to embark on this quest right now.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		
		this.m.Screens.push({
			ID = "Overview_Building",
			Title = this.m.Title,
			Text = "Defeat the patrol that escorts the prisoners before they reach their destination. Don't let too many of them escape!",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Yes.",
					function getResult()
					{
						return "Details"
					}

				},
				{
					Text = "No.",
					function getResult()
					{
						this.Contract.removeThisContract()
						return 0;
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = true,
			ShowEmployer = true,
			ShowDifficulty = false,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}
		});

		this.m.Screens.push({
			ID = "Details",
			Title = this.m.Title,
			Text = "",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Understood.",
					function getResult()
					{
						if (this.Contract.m.Target == null)
						{
							this.Contract.setSuccessFlag();
							this.World.Contracts.finishActiveContract();
							return 0;
						}
						this.Contract.setState("Running");
						return 0;
					}

				}
			],
			function start()
			{
				local params = this.Contract.determineOriginAndDestination();
				//failsafe
				if (params.Origin == null || params.Destination == null)
				{
					this.Text = "Stronghold failed to find suitable settlements for this quest. It will be auto-completed. You can now hire mercenaries.";
					return;
				}
				::Stronghold.getHostileFaction().copyLooks(params.Faction);
				local party = ::Stronghold.getHostileFaction().spawnEntity(params.Origin.getTile(), "Noble Army", false, this.Const.World.Spawn.Noble, 800);
				party.setDescription("An army of noble soldiers, escorting prisoners.");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
				party.setAttackableByAI(false);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setMovementSpeed(100);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(3 * this.World.getTime().SecondsPerDay);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(params.Destination.getTile());
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(wait);
				c.addOrder(move);
				c.addOrder(despawn);
				this.Contract.m.Flags.set("Survivors", 0);

				this.Contract.m.Target = this.WeakTableRef(party);
				this.Contract.m.Enemy_Faction = party.getFaction();

				this.Contract.m.Flags.set("OriginID", params.Origin.getID());
				this.Contract.m.Destination = this.WeakTableRef(params.Destination);

				this.Text = "The caravan will prepare for three days at " + params.Origin.getName() + " before starting to move towards " + params.Destination.getName() + ". Make sure you move in time!"
			}
		});
		
		this.m.Screens.push({
			ID = "TalkingToTheSurvivors",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{After defeating the noble army, you release the mercenaries from their chains. They turn on the corpses of their captors and strip them for anything they can carry — partly out of spite, partly out of nessessity. When they are finished, they indicate that they are ready to follow you home.}"
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to bring the boys home.",
					function getResult()
					{
						this.Contract.spawnMercenaries();
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The mercenaries are rejoiced after being freed. They ask if they can settle down in your stronghold, and you readily agree: you can never have enough strong arms.\nAfter this stunt, we are in high favours with the other mercenary companies. They might even follow us on our adventures at discount rates.}"
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "You can tag along.",
					function getResult()
					{
						this.Stronghold.getPlayerFaction().clearContracts()
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				},
				{
					Text = "You deserve a break.",
					function getResult()
					{
						foreach ( unit in this.Stronghold.getPlayerFaction().m.Units){
							if (unit.getFlags().get("Stronghold_Mercenaries")){
								unit.fadeOutAndDie()
							}
						}
						this.Stronghold.getPlayerFaction().clearContracts()
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setSuccessFlag();
				this.List.push({
					id = 10,
					icon = "ui/events/event_134.png",
					text = "You can now hire mercenaries"
				});

			}
		});
		
		this.m.Screens.push({
			ID = "Failure1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_95.png[/img]{You couldn't save the mercenaries in time. They will be abandoned to whatever fate has chosen for them, which most likely means the hangman's noose in short order. This one's on you!}"
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "That's terrible.",
					function getResult()
					{
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}
		});
		
		this.m.Screens.push({
			ID = "Failure2",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The mercenaries are rejoiced after being freed. They ask if they can settle down in your stronghold, and you readily agree: you can never have enough strong arms. However, your castellan informs you that your actions have not gone unnoticed. Too many of their soldiers lived to tell their story, and the nobles have declared you their enemy.\nStill: after this stunt, we are in high favours with the other mercenary companies. They might even follow us on our adventures at discount rates.}"
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Damnit!",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.m.Enemy_Faction).addPlayerRelationEx( -50, "Murdered their men to free condemned criminals")
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setSuccessFlag();
				this.List.push({
					id = 10,
					icon = "ui/events/event_134.png",
					text = "You can now hire mercenaries"
				});

			}
		});
	}

	function determineOriginAndDestination()
	{
		local playerBase = this.m.Home;
		local noble_factions = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local selected_faction = null;
		local selected_start_settlement = null;
		local selected_end_settlememt = null;
		local total_dist = 0;

		foreach (faction in noble_factions)
		{
			local settlements = faction.getSettlements()
			if (settlements.len() < 2)
			{
				continue;
			}
			local start_settlement = null
			local end_settlement = null
			local longestDistanceBetweenSettlements = 0
			local distFurthestFromBase = 0
			foreach (settlement in settlements)
			{
				if (!settlement.isIsolated() && settlement.getTile().getDistanceTo(playerBase.getTile()) > distFurthestFromBase)
				{
					start_settlement = settlement
					distFurthestFromBase = settlement.getTile().getDistanceTo(playerBase.getTile())
				}
			}
			if (start_settlement == null) continue
			foreach (settlement in settlements)
			{
				if (settlement != start_settlement && settlement.isMilitary() && settlement.isConnectedToByRoads(start_settlement) && settlement.getTile().getDistanceTo(start_settlement.getTile()) > longestDistanceBetweenSettlements)
				{
					end_settlement = settlement
					longestDistanceBetweenSettlements = settlement.getTile().getDistanceTo(start_settlement.getTile())
				}
			}
			if (end_settlement == null) continue
			if (selected_faction == null || longestDistanceBetweenSettlements > total_dist)
			{
				selected_faction = faction;
				total_dist = longestDistanceBetweenSettlements;
				selected_start_settlement = start_settlement
				selected_end_settlememt = end_settlement
			}
		}
		if (selected_end_settlememt == null || selected_start_settlement == null)
		{
			local settlements = this.World.EntityManager.getSettlements()
			local start_settlement = null
			local end_settlement = null
			local longestDistanceBetweenSettlements = 0
			local distFurthestFromBase = 0
			foreach (settlement in settlements)
			{
				if (!settlement.isIsolated() && settlement.m.Culture != this.Const.World.Culture.Southern && settlement.getTile().getDistanceTo(playerBase.getTile()) > distFurthestFromBase)
				{
					start_settlement = settlement
					distFurthestFromBase = settlement.getTile().getDistanceTo(playerBase.getTile())
				}
			}
			if (start_settlement != null)
			{
				foreach (settlement in settlements)
				{
					if (settlement != start_settlement && settlement.isAlliedWith( start_settlement ) && settlement.isMilitary() && settlement.isConnectedToByRoads(start_settlement)
						&& settlement.getTile().getDistanceTo(start_settlement.getTile()) > longestDistanceBetweenSettlements)
					{
						end_settlement = settlement
						longestDistanceBetweenSettlements = settlement.getTile().getDistanceTo(start_settlement.getTile())
					}
				}
			}
			if (end_settlement != null)
			{
				selected_faction = start_settlement.getFactionOfType(this.Const.FactionType.NobleHouse);
				total_dist = longestDistanceBetweenSettlements;
				selected_start_settlement = start_settlement
				selected_end_settlememt = end_settlement
			}
		}
		return {
			Origin = selected_start_settlement,
			Destination = selected_end_settlememt,
			Faction = selected_faction
		}
	}

	function setSuccessFlag()
	{
		this.Stronghold.getPlayerFaction().m.Flags.set("Mercenaries", true);
	}

	function onPrepareVariables( _vars )
	{
	}

	function onHomeSet()
	{
	}

	function onClear()
	{

		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;
		}
	}
	
	function cancel()
	{
		this.onCancel();
	}
	function removeThisContract()
	{
		this.World.Contracts.removeContract(this);
		this.Stronghold.getPlayerFaction().updateQuests();
		this.World.State.getTownScreen().updateContracts();
	}
	function spawnMercenaries()
	{
		local playerBase =  this.getHome()
		local playerFaction = this.Stronghold.getPlayerFaction()
		local partyStrength = 200
		local trainingCamp = playerBase.getLocation( "attached_location.militia_trainingcamp" );
		if (trainingCamp)
			partyStrength += trainingCamp.getAlliedPartyStrengthIncrease();

		local party = playerFaction.spawnEntity(this.World.State.getPlayer().getTile(), "Freed mercenaries", true, this.Const.World.Spawn.Mercenaries, partyStrength);
		party.getSprite("body").setBrush("figure_mercenary_01");
		party.setDescription("A band of mercenaries following you around.");
		party.setFootprintType(this.Const.World.FootprintsType.CityState);
		party.setMovementSpeed(200)
		party.getFlags().set("Stronghold_Mercenaries", true);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false)
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false)
		local follow = this.new("scripts/ai/world/orders/stronghold_follow_order");
		follow.setDuration(::Stronghold.Misc.MercenaryFollowDays);
		c.addOrder(follow);
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.m.Enemy_Faction);
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
		this.m.Enemy_Faction = _in.readU8()

		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}
		this.contract.onDeserialize(_in);
	}
});

