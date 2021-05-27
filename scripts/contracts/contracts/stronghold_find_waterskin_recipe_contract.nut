this.stronghold_find_waterskin_recipe_contract <- this.inherit("scripts/contracts/contract", {
	//unlock the waterskin buyable item
	//spawns a custom camp in the desert
	//success sets flag in stronghold to allow the special action
	m = {
		Reward = 0,
		Destination = null,
		Title = "Find the recipe for the strange water"
	},
	function create()
	{
		this.m.DifficultyMult = this.Math.rand(116, 130) * 0.01;
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.createStates();
		this.createScreens();
		this.m.Type = "contract.stronghold_find_waterskin_recipe_contract";
		this.m.Name = "Find a mythical recipe";
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
		return "ui/banners/factions/banner_05s"
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Find the location in the desert."
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
				else
				{
					local disallowedTerrain = [];
					local camp;
					local distanceToOthers = 15;

					for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
					{
						if (i == this.Const.World.TerrainType.Desert)
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
						camp = this.World.spawnLocation("scripts/entity/world/locations/legendary/stronghold_waterskin_location", tile.Coords);
					}

					if (camp != null)
					{
						tile.TacticalType = this.Const.World.TerrainTacticalType.Desert;
						camp.onSpawned();
						camp.getSprite("selection").Visible = true;
						camp.setDiscovered(true);
						camp.setAttackable(true);
						camp.setOnEnterCallback(this.onDestinationAttacked.bindenv(this));
						this.World.uncoverFogOfWar(camp.getTile().Pos, 500.0);
						this.Contract.m.Destination = this.WeakTableRef(camp)
					}
				}
			}
			
			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("SearchingTheCamp");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}
			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.setScreen("EnteringTheCamp");
				this.World.Contracts.showActiveContract();
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
			Text = "According to legends, an ancient graveyard in the desert holds the recipe for eternal youth. Embark on a quest to retrieve the recipe!",
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
			Text = "Do you wish to start this quest?",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Yes.",
					function getResult()
					{
						this.Contract.setState("Running");
						return 0;
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
			ID = "SearchingTheCamp",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{After defeating the defenders, you search the remains. You find an ancient parchment filled with an unrecognisable script. You also find a flask, filled with a strange liquid. The liquid behaves like water, however through the glass it is hard to tell the true nature of it. You suspect that this is the fabled water of life. You lazily jab at the ribcages of the skeletons nearby — the bones are picked clean and have been so for some time. Either the flask did not do them any good, or they obtained it after their threads were unwound.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to head home.",
					function getResult()
					{
						local item = this.new("scripts/items/special/fountain_of_youth_item");
						this.World.Assets.getStash().makeEmptySlots(1);
						this.World.Assets.getStash().add(item);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/items/consumables/youth_01.png",
					text = "You gain a water skin and a parchment."
				});
			}
		});
		this.m.Screens.push({
			ID = "EnteringTheCamp",
			Title = "As you approach",
			Text = "[img]gfx/ui/events/event_167.png[/img]{You find the remains of a desert camp. It is surrounded by a pickled carpet of human bones. Some of the bones in the center start to move, and a small cohort of fleshless dead assemble themselves — three members of the warband are decorated well, and seem to be far above the station of the others. As you wonder how this pitiful group has managed to survive this long, the ground begins to rumble, and a host of massive, enchanted rocks begin to emerge.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.showCombatDialog();
					}
				},
				{
				Text = "Run, you fools!",
					function getResult()
					{
						return 0;
					}
				}
				
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_15.png[/img]{A historian manages to translate the parchment. It describes the process to create the water of life. It will be costly — but the guild of the alchemists is confident that they will manage to create it.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Excellent.",
					function getResult()
					{
						this.Contract.m.Home.m.Flags.set("Waterskin", true);
						this.Contract.m.Home.clearContracts()
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/items/consumables/youth_01.png",
					text = "You gain the recipe for a Water Flask"
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
				this.m.Destination.die()
			}
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;

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
	function removeThisContract()
	{
		this.World.Contracts.removeContract(this);
		this.m.Home.updateQuests()
		this.World.State.getTownScreen().updateContracts();
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

