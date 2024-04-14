
::Stronghold.PlayerFactionActions <- 
[
	"scripts/factions/actions/stronghold_guard_base_action", 
	"scripts/factions/actions/stronghold_send_caravan_action", 
	"scripts/factions/actions/stronghold_patrol_roads_action",
	"scripts/factions/actions/stronghold_send_attacker_action",
];


::Stronghold.FullDraftList <-
[
	"adventurous_noble_background" ,
	"apprentice_background" ,
	"bastard_background" ,
	"beast_hunter_background" ,
	"beggar_background" ,
	"bowyer_background" ,
	"brawler_background" ,
	"butcher_background" ,
	"caravan_hand_background" ,
	"cultist_background" ,
	"daytaler_background" ,
	"deserter_background" ,
	"disowned_noble_background" ,
	"farmhand_background" ,
	"fisherman_background" ,
	"flagellant_background" ,
	"gambler_background" ,
	"gladiator_background" ,
	"gravedigger_background" ,
	"hedge_knight_background" ,
	"historian_background" ,
	"houndmaster_background" ,
	"hunter_background" ,
	"juggler_background" ,
	"killer_on_the_run_background" ,
	"lumberjack_background" ,
	"manhunter_background" ,
	"mason_background" ,
	"messenger_background" ,
	"militia_background" ,
	"miller_background" ,
	"miner_background" ,
	"minstrel_background" ,
	"monk_background" ,
	"nomad_background" ,
	"peddler_background" ,
	"poacher_background" ,
	"raider_background" ,
	"ratcatcher_background" ,
	"retired_soldier_background" ,
	"sellsword_background" ,
	"servant_background" ,
	"shepherd_background" ,
	"squire_background" ,
	"swordmaster_background" ,
	"tailor_background" ,
	"thief_background" ,
	"vagabond_background" ,
	"wildman_background" ,
	"witchhunter_background"
]


//----------------------------------------------- quick access functions ---------------------------------------------------
::Stronghold.getPlayerBase <- function()
{
	local playerFaction = this.Stronghold.getPlayerFaction()
	if (playerFaction != null)
	{
		local player_settlements = playerFaction.getSettlements()
		foreach (settlement in player_settlements)
		{
			if(settlement.getFlags().get("IsPlayerBase")){
				return settlement
			}
		}
	}
	foreach (settlement in this.World.EntityManager.getSettlements())
	{
		if(settlement.getFlags().get("IsPlayerBase")){
			return settlement
		}
	}
	return false
}

::Stronghold.getPlayerFaction <- function()
{
	if ("FactionManager" in this.World)
		return this.World.FactionManager.getFactionOfType(this.Const.FactionType.Player)
}

::Stronghold.getHostileFaction <- function()
{
	if ("FactionManager" in this.World)
		return this.World.FactionManager.getFactionOfType(this.Const.FactionType.StrongholdEnemies)
}

::Stronghold.getNextRenownCost <- function()
{
	local cost = ::Stronghold.Misc.RenownCost;
	local f =  this.getPlayerFaction();
	if (f == null)
		return cost;
	foreach (_base in this.getPlayerFaction().getMainBases())
	{
		cost += (::Stronghold.Misc.RenownCost * _base.getSize());
	}
	return cost;
}

//modded from vanilla to allow for longer range
::Stronghold.isOnTile <- function(_tile, _tileTypes)
{
	foreach(tileType in _tileTypes)
	{
		if (_tile.Type == tileType)
			return true;
		for( local i = 0; i != 6; i = ++i )
		{
			if (_tile.hasNextTile(i) && _tile.getNextTile(i).Type == tileType)
				return true;
		}
	}
	return false
}

::Stronghold.getDays <- function(_i)
{
	return _i * this.World.getTime().SecondsPerDay;
}
::Stronghold.setCooldown <- function(_obj, _flag, _i = null)
{
	if (_i == null)
	{
		if (!(_flag in ::Stronghold.Flags))
			throw "Did not find flag " + _flag + " in ::Stronghold.Flags !";
		_i = ::Stronghold.Flags[_flag];
	}
	return _obj.getFlags().set(_flag, ::Time.getVirtualTimeF() + ::Stronghold.getDays(_i));
}
::Stronghold.isCooldownExpired <- function(_obj, _flag)
{
	local flag =  _obj.getFlags().get(_flag);
	if(!flag)
		return true;
	return ::Time.getVirtualTimeF() > flag;
}

::Stronghold.buildMainBase <- function()
{
	local buildPrice = ::Stronghold.BaseTiers[1].Price * ::Stronghold.Misc.PriceMult
	//called from retinue menu
	this.World.Assets.addMoney(-buildPrice);
	local tile = this.World.State.getPlayer().getTile(); 
	tile.IsOccupied = true;
	tile.TacticalType = this.Const.World.TerrainTacticalType.Urban;

	//create new faction if it doesn't exist already
	local playerFaction = this.Stronghold.getPlayerFaction()
	if (playerFaction == null)
	{
		playerFaction = this.new("scripts/factions/stronghold_player_faction");
		playerFaction.setID(this.World.FactionManager.m.Factions.len());
		playerFaction.setName("The " + this.World.Assets.getName());
		playerFaction.setMotto("\"" + "Soldiers Live" + "\"");
		playerFaction.setDescription("The only way to leave the company is feet first.");
		playerFaction.m.Banner = this.World.Assets.getBannerID()
		playerFaction.setDiscovered(true);
		playerFaction.m.PlayerRelation = 100;		
		playerFaction.updatePlayerRelation()
		this.World.FactionManager.m.Factions.push(playerFaction);
		playerFaction.onUpdateRoster();

		local enemyFaction = this.new("scripts/factions/stronghold_enemy_faction");
		enemyFaction.setID(::World.FactionManager.m.Factions.len());
		::World.FactionManager.m.Factions.push(enemyFaction);
	}
	
	local playerBase = this.World.spawnLocation("scripts/entity/world/settlements/stronghold_player_base", tile.Coords);
	playerFaction.addSettlement(playerBase);
	playerBase.startUpgrading();
	playerBase.onBuild();
	::Stronghold.updateConnectedToByRoad();
	

	//spawn assailant quest
	local contract = this.new("scripts/contracts/contracts/stronghold_defeat_assailant_contract");
	contract.setEmployerID(playerFaction.getRandomCharacter().getID());
	contract.setFaction(playerFaction.getID());
	contract.setHome(playerBase);
	contract.setOrigin(playerBase);
	contract.m.TargetLevel = 1
	this.World.Contracts.addContract(contract);
	contract.start();
}

::Stronghold.updateConnectedToByRoad <- function()
{
	local settlements = this.World.EntityManager.getSettlements();
	local navSettings = this.World.getNavigator().createSettings();
	foreach (settlement in settlements)
	{
		local myTile = settlement.getTile();
		foreach( s in settlements )
		{
			if (s.getID() == settlement.getID() || settlement.isConnectedTo(s))
			{
				continue;
			}

			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(myTile, s.getTile(), navSettings, 0);

			if (!path.isEmpty())
			{
				settlement.m.ConnectedTo.push(s.getID());
				s.m.ConnectedTo.push(settlement.getID());
			}
		}

		if (!settlement.isIsolated())
		{
			foreach( s in settlements )
			{
				if (s.getID() == settlement.getID() || settlement.isConnectedToByRoads(s))
				{
					continue;
				}

				navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost;
				navSettings.RoadOnly = true;
				local path = this.World.getNavigator().findPath(myTile, s.getTile(), navSettings, 0);

				if (!path.isEmpty())
				{
					settlement.m.ConnectedToByRoads.push(s.getID());
					s.m.ConnectedToByRoads.push(settlement.getID());
				}
			}
		}
	}
}
