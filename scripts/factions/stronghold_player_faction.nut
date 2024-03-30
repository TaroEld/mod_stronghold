this.stronghold_player_faction <- this.inherit("scripts/factions/faction", {
	//custom player faction. Uses the same ID as basic player
	m = {
		HairColor = 0,
		Traits = [],
		Deck = []
	},
	
	function create()
	{
		this.faction.create();
		this.m.Type = this.Const.FactionType.Player;
		this.m.HairColor = ::Math.rand(0, this.Const.HairColors.Lineage.len() - 1);
		this.m.Base = "world_base_09";
		this.m.TacticalBase = "bust_base_military";
		this.m.CombatMusic = this.Const.Music.NobleTracks;
		this.m.RelationDecayPerDay = 0;
		this.m.BannerPrefix = "banner_"
		this.addTrait(this.Stronghold.PlayerFactionActions)
	}
	function getName()
	{
		return this.m.Name;
	}

	function getNameOnly()
	{	
		return this.m.Name;
	}

	function getColor()
	{
		return this.Const.BannerColor[this.m.Banner];
	}
	
	function addTrait( _t )
	{
		//add orders to the faction, during upgrades
		this.m.Deck = []
		foreach( c in _t )
		{
			local card = this.new(c);
			card.setFaction(this);
			this.m.Deck.push(card);
		}
	}
	
	function update( _ignoreDelay = false, _isNewCampaign = false )
	{
		if (this.m.Settlements.len() == 0)
		{
			return;
		}
		//ghetto way of implementing alliances for previous users, should improve
		if(this.m.Allies.len() < 5)
		{
			this.updateAlliancesPlayerFaction();
		}

		if (!this.m.IsActive)
		{
			return;
		}
		
		local playerBase = this.getMainBases()
		foreach(settlement in this.getMainBases())
		{
			if (settlement.hasSituation("situation.raided")) settlement.updateSituations()
		}
		
		//no actions on lvl1 playerbase, too small, would be too powerful

		if (!_ignoreDelay && this.m.LastActionTime + this.World.getTime().SecondsPerDay > this.Time.getVirtualTimeF())
		{
			return;
		}

		if (!_ignoreDelay)
		{
			this.m.LastActionTime = this.Time.getVirtualTimeF();
		}

		foreach( u in this.m.Units )
		{
			if (u.getTroops().len() == 0)
			{
				u.die();
			}

			if (!_ignoreDelay && this.m.Settlements.len() != 0)
			{

				if (u.isAlive() && !u.getController().hasOrders())
				{
					local move = this.new("scripts/ai/world/orders/move_order");
					move.setDestination(playerBase.getTile());
					local despawn = this.new("scripts/ai/world/orders/despawn_order");
					u.getController().addOrder(move);
					u.getController().addOrder(despawn);
				}
			}
		}
		
		//check and execute the orders
		foreach (card in this.m.Deck)
		{
			//checks cooldown and requirements
			card.update();
			if (card.m.Score > 0)
			{
				card.execute()
			}
		}
	}

	function getMainBases()
	{
		return this.getSettlements().filter(@(a, b) b.isMainBase())
	}

	function getDevelopedBases()
	{
		return this.getMainBases().filter(@(a, b) b.getSize() > 1)
	}

	function getHamlets()
	{
		return this.getSettlements().filter(@(a, b) !b.isMainBase())
	}
	
	function updateAlliancesPlayerFaction()
	{
		//sync alliances with player
		foreach (faction in this.World.FactionManager.m.Factions)
		{
			if(faction != null)
			{
				if (faction.m.PlayerRelation > 20)
				{
					this.addAlly(faction.getID());
					faction.addAlly(this.getID());
				}
				else
				{
					this.removeAlly(faction.getID());
					faction.removeAlly(this.getID());
				}
			}
		}
	}
	
	function updateAlliancePlayerFaction(_faction)
	{
		//sync alliances with player, singular faction for performance
		if(_faction != null)
		{
			if (_faction.m.PlayerRelation >20)
			{
				this.addAlly(_faction.getID());
				_faction.addAlly(this.getID());
			}
			else
			{
				this.removeAlly(_faction.getID());
				_faction.removeAlly(this.getID());
			}
		}
	}
	
	//I think there are some issues with one of these 3
	function getBannerSmall()
	{
		local result =  this.m.BannerPrefix + (this.m.Banner < 10 ? "0":"") + this.m.Banner
		return result;
	}
	
	function getUIBanner()
	{
		return "ui/banners/" + this.m.BannerPrefix + (this.m.Banner < 10 ? "0":"") + this.m.Banner  + ".png";
	}

	function getUIBannerSmall()
	{
		return "ui/banners/" + this.m.BannerPrefix + (this.m.Banner < 10 ? "0":"") + this.m.Banner  +   "s.png";
	}
	
	//relation with stronghold can't change, this also disables you being able to attack stronghold units
	function addPlayerRelation( _r, _reason = "" )
	{

	}

	function makeSettlementsFriendlyToPlayer()
	{

	}

	function isReadyToSpawnUnit()
	{
		return this.m.Units.len() <= this.m.Settlements.len() + 1;
	}

	function onUpdateRoster()
	{
		//add a single noble for the roster, later has retired units
		for( local roster = this.getRoster(); roster.getSize() < 1;  )
		{
			local character = roster.create("scripts/entity/tactical/humans/noble");
			character.setFaction(this.m.ID);
			character.m.HairColors = this.Const.HairColors.Lineage[this.m.HairColor];
			character.setAppearance();
			character.setTitle(" the Castellan");
			character.m.Items.equip(this.new("scripts/items/armor/noble_gear"));
			character.m.Items.equip(this.new("scripts/items/helmets/noble_headgear"))
		}
	}

	function isReadyForContract()
	{
		return false;
	}

	function clearContracts()
	{
		//clears all contracts after some features
		local contracts = this.getContracts();
		foreach (contract in contracts)
		{
			this.World.Contracts.removeContract(contract)
		}
	}
	
	function updateQuests()
	{
		//adds/removes quests when entering town. Takes care of conflicing quests.	
		local bases = this.getMainBases().filter(@(a, b) b.getSize() > 2);
		if (bases.len() == 0) return
		local contracts = this.getContracts();
		local find_waterskin = false;
		local free_mercenaries = false;
		local find_trainer = false;
		//vars for every quest, allows to plug it in later to remove it
		foreach(contract in contracts)
		{
			if (contract.m.Type == "contract.stronghold_find_waterskin_recipe_contract")
			{
				find_waterskin = true;
			}
			if (contract.m.Type == "contract.stronghold_free_mercenaries_contract")
			{
				free_mercenaries = true;
			}
			if (contract.m.Type == "contract.stronghold_free_trainer_contract")
			{
				find_trainer = true;
			}
		}	
				
		if (!find_waterskin && !this.m.Flags.get("Waterskin"))
		{
			local contract = this.new("scripts/contracts/contracts/stronghold_find_waterskin_recipe_contract");
			contract.setEmployerID(this.getRandomCharacter().getID());
			contract.setFaction(this.getID())
			this.World.Contracts.addContract(contract);
		}
		
		if (!free_mercenaries && !this.m.Flags.get("Mercenaries"))
		{
			local contract = this.new("scripts/contracts/contracts/stronghold_free_mercenaries_contract");
			contract.setEmployerID(this.getRandomCharacter().getID());
			contract.setFaction(this.getID())
			this.World.Contracts.addContract(contract);
		}
		if (!find_trainer && !this.m.Flags.get("Teacher") && this.Const.DLC.Wildmen)
		{
			local contract = this.new("scripts/contracts/contracts/stronghold_free_trainer_contract");
			contract.setEmployerID(this.getRandomCharacter().getID());
			contract.setFaction(this.getID())
			this.World.Contracts.addContract(contract);
		}
	}
	
	//should it ever change, this returns it
	function normalizeRelation()
	{
		this.m.PlayerRelation = 100
	}
	function onSerialize( _out )
	{
		this.faction.onSerialize(_out);
		_out.writeU8(this.m.HairColor);
	}

	function onDeserialize( _in )
	{
		this.faction.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 52)
		{
			this.m.HairColor = _in.readU8();
		}
		//need to update alliances with every load of the save
		this.updateAlliancesPlayerFaction();
	}

});

