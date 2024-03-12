// max length of menu options, limitation of the text window size. got it at 11 so leave 2 spaces for 'back' etc
::Stronghold.MAX_MENU_OPTIONS <- 9; 

::Stronghold.MAX_BASE_SIZE <- 3;

::Stronghold.PlayerFactionActions <- 
[
	"scripts/factions/actions/stronghold_guard_base_action", 
	"scripts/factions/actions/stronghold_send_caravan_action", 
	"scripts/factions/actions/stronghold_patrol_roads_action"
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
			if(settlement.getFlags().get("isPlayerBase")){
				return settlement
			}
		}
	}
	foreach (settlement in this.World.EntityManager.getSettlements())
	{
		if(settlement.getFlags().get("isPlayerBase")){
			return settlement
		}
	}
	return false
}

::Stronghold.getPlayerFaction <- function()
{
	if ("FactionManager" in this.World) return this.World.FactionManager.getFactionOfType(this.Const.FactionType.Player)
	return null
}

::Stronghold.getMaxStrongholdNumber <- function()
{
	local renown = this.World.Assets.getBusinessReputation();
	local level = 0;
	foreach(lvl in this.RenownPerLevel){
		if (renown > lvl) level++
	}
	return level
}

::Stronghold.getClosestDistance <- function(_destination, _list)
{
	local chosen = null;
	local closestDist = 9999;
	foreach (obj in _list)
	{
		if (obj == null) continue
		local dist = obj.getTile().getDistanceTo(_destination.getTile())
		if (chosen == null || dist < closestDist)
		{
			chosen = obj;
			closestDist = dist;
		}
	}
	return
	{
		settlement = obj
	}
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

::Stronghold.buildMainBase <- function()
{
	local buildPrice = ::Stronghold.Tiers[1].Price * ::Stronghold.PriceMult
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
	}
	
	local playerBase = this.World.spawnLocation("scripts/entity/world/settlements/stronghold_player_base", tile.Coords);
	playerFaction.addSettlement(playerBase);
	playerBase.startUpgrading();
	playerBase.onBuild()
	

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

::Stronghold.assignTroops <- function ( _party, _partyList, _resources, _weightMode = 1)
{
	//this function circumvents the max party sizes. initially had it used universally, now only during  specific calls
	local max_resources = _resources;
	local selected_party;
	while (_resources > 15)
	{
		selected_party = this.Const.World.Common.assignTroops( _party, _partyList, _resources, _weightMode = 1)
		foreach (t in _party.m.Troops)
		{
			_resources -= t.Cost;
		}
	}
	_party.updateStrength();
	return selected_party;
}

::Stronghold.spawnEntity <- function( _faction, _tile, _name, _uniqueName, _template, _resources )
{
	//same as vanilla
	local party = this.World.spawnEntity("scripts/entity/world/party", _tile.Coords);
	party.setFaction(_faction.getID());

	if (_uniqueName)
	{
		_name = _faction.getUniqueName(_name);
	}

	party.setName(_name);
	local t;

	if (_template != null)
	{
		//except for this line, allowing more than unit cap
		t = ::Stronghold.assignTroops(party, _template, _resources);
	}

	party.getSprite("base").setBrush(_faction.m.Base);

	if (t != null)
	{
		party.getSprite("body").setBrush(t.Body);
	}

	if (_faction.m.BannerPrefix != "")
	{
		party.getSprite("banner").setBrush(_faction.m.BannerPrefix + (_faction.m.Banner < 10 ? "0" + _faction.m.Banner : _faction.m.Banner));
	}

	_faction.addUnit(party);
	return party;
}
