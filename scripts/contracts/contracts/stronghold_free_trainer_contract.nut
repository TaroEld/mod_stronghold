this.stronghold_free_trainer_contract <- this.inherit("scripts/contracts/contract", {
	//unlock turbo training
	//fight camp in the snow, 1 barb king champ and 2 chosen, select up to 3 of your guys to fight (works with less)
	//sets flag in base on success
	// the more contracts I write, the uglier they get
	m = {
		Reward = 0,
		Title = "Find the legendary trainer",
		LastCombatTime = 0.0,
		Destination = null,
		Chosen = [],
		ChosenOptions = []
	},
	function create()
	{
		this.m.DifficultyMult = ::Math.rand(116, 130) * 0.01;
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.createStates();
		this.createScreens();
		this.m.Type = "contract.stronghold_free_trainer_contract";
		this.m.Name = "Find the legendary trainer";
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
		return "ui/banners/factions/banner_08s"
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Find the Field of War"
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
				if (this.Contract.m.Destination)
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnEnterCallback(this.onDestinationAttacked.bindenv(this));
				}
			}
			
			
			function update()
			{
				if (this.Flags.get("IsVictory"))
				{
					this.Contract.setScreen("IsVictory");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("IsFailure");
					this.World.Contracts.showActiveContract();
				}
			}
			
			function onCombatVictory( _combatID )
			{
				if (_combatID == "ChosenTrainer")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "ChosenTrainer")
				{
					this.Flags.set("IsFailure", true);
				}
			}
			
			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
					this.Contract.setScreen("EnteringTheCamp");
					this.World.Contracts.showActiveContract();
			}
			
			function end()
			{
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
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
					
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
					
				}
			}

		});
	}

	function createScreens()
	{	
		this.m.Screens.push({
			ID = "Task",
			Title = this.m.Title,
			Text = "Escaped slaves from the northern barbarians speak of the Field of War, a location where warriors refine their skills and eventually become Chosen, elite barbarian warriors. Allegedly, a legendary trainer teaches them their skills. This individual would be a great asset to our stronghold. Go and find him!",
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
			Text = "Find the Field of War in the frozen north.",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Yes.",
					function getResult()
					{
						local disallowedTerrain = [];
						local camp;
						local distanceToOthers = 15;

						for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
						{
							if (i == this.Const.World.TerrainType.SnowyForest)
							{
							}
							else
							{
								disallowedTerrain.push(i);
							}
						}

						local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 20, 300, disallowedTerrain);

						if (tile != null)
						{
							camp = this.World.spawnLocation("scripts/entity/world/locations/legendary/stronghold_trainer_location", tile.Coords);
						}

						if (camp != null)
						{
							tile.TacticalType = this.Const.World.TerrainTacticalType.SnowyForest;
							camp.onSpawned();
							camp.getSprite("selection").Visible = true;
							camp.setDiscovered(true);
							camp.setAttackable(true);
							this.World.uncoverFogOfWar(camp.getTile().Pos, 500.0);
							this.Contract.m.Destination = this.WeakTableRef(camp)
							this.Contract.setState("Running");
							return 0;
						}
						else
						{
							this.Contract.removeThisContract()
							this.logInfo("Could not find location to spawn Fields of War!")
							return 0
						}
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
			ID = "EnteringTheCamp",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_08.png[/img]{From a distance, you can already hear the sounds of banging metal and rancious laughter. You approach a great clearing in the woods, where great numbers of barbarian warriors are fighting each other in practice. The smell of blood and mead fills the air. The wary northmen step aside as you make your way to the middle. At the center, you find a great tent, guarded by a plethora of fierce warriors. Your men wait outside as you enter.\n A great king of the barbarians, who calls himself the Lord of War, greets you. He is accompanied by a surprising sight: an old swordmaster. This must be the legendary trainer of the Chosen. You ask him to accompany you, but he refuses. %SPEECH_ON%These people know the true meaning of life: to master the martial arts, and become a fabled warrior. Show me that you have what it takes to deserve my skills!%SPEECH_OFF%. A contest of champions it is.}" ,
			Image = "",
			List = [],
			Options = [
				{
					Text = "We accept the challenge.",
					function getResult()
					{
						this.Contract.updateChosen()
						this.Contract.m.Screens.push({
							ID = "ChooseChampions",
							Title = "Prepare yourself.",
							Text = "[img]gfx/ui/events/event_07.png[/img]{Choose your champions.}",
							Image = "",
							List = [],
							Options = this.Contract.champtionOptions()
							function start()
							{
							}
						});
						return "ChooseChampions"
					}
				},
				{
				Text = "We will practice more and return another day.",
					function getResult()
					{
						return 0;
					}
				}
				
			]
		});
		

		this.m.Screens.push({
			ID = "StartFight",
			Title = "Prepare yourself.",
			Text = "[img]gfx/ui/events/event_139.png[/img]{The northmen form a circle, and your champions step inside. The king emerges from the tent, and two other Chosen join him.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Make me proud, brothers!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Entities = [];
						properties.CombatID = "ChosenTrainer";
						properties.Music = this.Const.Music.ArenaTracks;
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						this.Contract.addToCombat(properties.Entities, this.Const.World.Spawn.Troops.BarbarianChosen, true, "The Lord of War");
						this.Contract.addToCombat(properties.Entities, this.Const.World.Spawn.Troops.BarbarianChampion);
						this.Contract.addToCombat(properties.Entities, this.Const.World.Spawn.Troops.BarbarianChampion);
						foreach (bro in this.Contract.m.Chosen)
						{
							properties.Players.push(bro)
						}
						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						properties.IsWithoutAmbience = true;
						properties.IsFogOfWarVisible = false;
						for( local i = 0; i < properties.Entities.len(); i = ++i )
						{
							properties.Entities[i].Faction <- this.Const.Faction.Enemy
						}
						properties.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();

							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = ::Math.min(1, tile.Level);
									tile.clear()
									tile.removeObject()
								}
							}
						};
						this.World.State.startScriptedCombat(properties, false, false, false);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		
		this.m.Screens.push({
			ID = "IsVictory",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_50.png[/img]Your champions cut down the Lord of War and their Chosen. The once rowdy crowd fail to object as you gather up their gear. The old swordmaster is impressed by the performance of your group.%SPEECH_ON%So there are some true warriors left among the men of the south. Very well, I will accompany you.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to go home.",
					function getResult()
					{
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
			ID = "IsFailure",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_135.png[/img]{Under thunderous cheers by the northmen, your champions are cut down by the Lord of War and his chosen. The old swordmaster sneers: he knew this would happen. You leave the Fields of War, having achieved nothing — aside from losing some of your best men.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "What a disaster.",
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
			ID = "Success1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The old swordmaster appreciates your stronghold. He agrees to teach your new mercenaries, though his services don't come cheap.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Excellent.",
					function getResult()
					{
						this.Stronghold.getPlayerFaction().m.Flags.set("Teacher", true);
						this.Stronghold.getPlayerFaction().clearContracts()
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/events/event_134.png",
					text = "You can now get highly accelerated training for new brothers."
				});

			}
		});
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
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;
		}

	}

	function onIsValid()
	{
		return true;
	}
	
	function removeThisContract()
	{
		this.World.Contracts.removeContract(this);
		this.Stronghold.getPlayerFaction().updateQuests();
		this.World.State.getTownScreen().updateContracts();
	}
	
	function champtionOptions()
	{
		local options = [];
		foreach (bro in this.m.ChosenOptions)
		{
			options.push({
					Text = "You are one of our champions, " + bro.getName() + " .",
					function getResult()
					{
						{
							return "addChosen"
						}
					}

				});
		}
		return options;
	}
	function updateChosen()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local options = []
		roster.sort(function ( _a, _b )
		{
			if (_a.getXP() > _b.getXP())
			{
				return -1;
			}
			else if (_a.getXP() < _b.getXP())
			{
				return 1;
			}

			return 0;
		});
		
		local numslots = ::Math.min(10, roster.len())
		for (local x = 0; x < numslots; x++)
		{
			options.push(roster[x])
		}
		this.m.ChosenOptions = options
	}
	function addToCombat( _list, _entityType, _champion = false, _name = "" )
	{
		local c = clone _entityType;

		if (c.Variant != 0 && _champion)
		{
			c.Variant = 1;
			c.Name <- _name;
		}
		else
		{
			c.Variant = 0;
		}

		_list.push(c);
	}
	
	function processInput( _option )
	{
		//hack into this function for dynamic bro selection
		if (this.m.ActiveScreen == null)
		{
			return false;
		}

		if (_option >= this.m.ActiveScreen.Options.len())
		{
			return true;
		}

		local result = this.m.ActiveScreen.Options[_option].getResult();
		if (result == "addChosen")
		{
			local has_unit = false
			foreach (bro in this.m.Chosen)
			{
				if (bro.getName() == this.m.ChosenOptions[_option].getName())
				{
					has_unit= true
				}
			}
			if (!has_unit)
			{
				this.m.Chosen.push(this.m.ChosenOptions[_option])
				this.m.ChosenOptions.remove(_option)				
				this.m.ActiveScreen.Options.remove(_option)
				this.World.Contracts.showActiveContract();
				
			}
			if(this.m.Chosen.len() == 3 || this.m.Chosen.len() == this.World.getPlayerRoster().getAll().len())
			{
				this.setScreen(this.getScreen("StartFight"));
			}
			return true;
		}
		
		if (typeof result != "string" && result <= 0)
		{
			if (this.isActive())
			{
				this.setScreen(null);
			}

			return false;
		}

		this.setScreen(this.getScreen(result));
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

		this.contract.onDeserialize(_in);
		

	}

});

