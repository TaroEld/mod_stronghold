local gt = this.getroottable();
gt.Const.World.Stronghold <- {};
gt.Const.World.Stronghold.MaxMenuOptionsLen <- 9; // max length of menu options, limitation of the text window size. got it at 11 so leave 2 spaces for 'back' etc
gt.Const.World.Stronghold.PriceMult <- 1000; //fastest way to change prices, everything gets mult by this
gt.Const.World.Stronghold.BuyPrices <- [10, 20, 20]; //base prices for build/upgrade
gt.Const.World.Stronghold.MaxAttachments <- [3, 6, 9]; //base prices for build/upgrade

gt.Const.World.Stronghold.UnlockAdvantages <-[
	"You can leave items and brothers behind, to retrieve them later as you need them.\n You can construct up to three settlement buildings.\nYou can construct up to three locations, granting various advantages.\n You will be able to upgrade your base, unlocking more features.",
	"Bands of mercenaries will join your base and guard it against aggressors.\nYou can construct an additional building and three additional locations.\nYou can construct roads to other settlements, connecting your base to the world.",
	"You can construct an additional building, including an arena, and three additional locations.\nA number of unique contracts will be made available.\nYou can now construct an additional Hamlet, connected to your Stronghold."
]
gt.Const.World.Stronghold.RoadCost <- 0.5; // per segment
gt.Const.World.Stronghold.BaseNames <- [
"Fort",
"Castle",
"Stronghold"]

gt.Const.World.Stronghold.PlayerFactionActions <- [
"scripts/factions/actions/stronghold_guard_base_action", 
"scripts/factions/actions/stronghold_send_caravan_action", 
"scripts/factions/actions/stronghold_patrol_roads_action"];


gt.Const.World.Stronghold.BuildingPrices <- 
{
	Tavern = 5,
	Kennel = 5,
	Taxidermist = 5,
	Temple = 5, 
	Training = 5,
	Alchemist = 5,
	Weaponsmith = 10,
	Armorsmith = 10,
	Fletcher = 10,
	Port = 15,
	Arena = 20
};
gt.Const.World.Stronghold.LocationPrices <-
{
	Workshop = 10,
	Ore = 10,
	Blast = 10,
	Stone = 10,
	Militia = 10,
	Wheat = 10,
	Herbalists = 10,
	Gold = 10
};
gt.Const.World.Stronghold.WellSupplied <-
[
	{
		Rarity = 1.04,
		BuyPrice = 1.00,
		SellPrice = 1.00
	},
	{
		Rarity = 1.08,
		BuyPrice = 0.95,
		SellPrice = 1.05
	},
	{
		Rarity = 1.12,
		BuyPrice = 0.9,
		SellPrice = 1.1
	}
]

gt.Const.World.Stronghold.FullDraftList <-
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
	"cripple_background" ,
	"cultist_background" ,
	"daytaler_background" ,
	"deserter_background" ,
	"disowned_noble_background" ,
	"eunuch_background" ,
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
	"refugee_background" ,
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
gt.Const.World.Stronghold.Building_options <-
[
	{
		Name = "Tavern",
		ID = "building.tavern",
		Cost = this.Const.World.Stronghold.BuildingPrices["Tavern"],
		Path = "tavern_building",
		SouthPath = false,
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID))
		}
	},
	{
		Name = "Kennel",
		ID = "building.kennel",
		Cost = this.Const.World.Stronghold.BuildingPrices["Kennel"],
		Path = "kennel_building",
		SouthPath = false,
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID))
		}
	},
	{
		Name = "Taxidermist",
		ID = "building.taxidermist",
		SouthID = "building.taxidermist_oriental",
		Cost = this.Const.World.Stronghold.BuildingPrices["Taxidermist"],
		Path = "taxidermist_building",
		SouthPath = "taxidermist_oriental_building",
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID) && !(this.Stronghold.getPlayerBase().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Temple",
		ID = "building.temple",
		SouthID = "building.temple",
		Cost = this.Const.World.Stronghold.BuildingPrices["Temple"],
		Path = "temple_building",
		SouthPath = "temple_oriental_building",
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID) && !(this.Stronghold.getPlayerBase().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Training Hall",
		ID = "building.training_hall",
		Cost = this.Const.World.Stronghold.BuildingPrices["Training"],
		Path = "training_hall_building",
		SouthPath = false,
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID))
		}
	},
	{
		Name = "Alchemist",
		ID = "building.alchemist",
		Cost = this.Const.World.Stronghold.BuildingPrices["Alchemist"],
		Path = "alchemist_building",
		SouthPath = false,
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID))
		}
	},
	{
		Name = "Weaponsmith",
		ID = "building.weaponsmith",
		SouthID = "building.weaponsmith_oriental",
		Cost = this.Const.World.Stronghold.BuildingPrices["Weaponsmith"],
		Path = "weaponsmith_building",
		SouthPath = "weaponsmith_oriental_building",
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID) && !(this.Stronghold.getPlayerBase().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Armorsmith",
		ID = "building.armorsmith",
		SouthID = "building.armorsmith_oriental",
		Cost = this.Const.World.Stronghold.BuildingPrices["Armorsmith"],
		Path = "armorsmith_building",
		SouthPath = "armorsmith_oriental_building",
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID) && !(this.Stronghold.getPlayerBase().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Fletcher",
		ID = "building.fletcher",
		Cost = this.Const.World.Stronghold.BuildingPrices["Fletcher"],
		Path = "fletcher_building",
		SouthPath = false,
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID))
		}
	},
	{
		Name = "Port",
		ID = "building.port",
		Cost = this.Const.World.Stronghold.BuildingPrices["Port"],
		Path = "port_building",
		SouthPath = false,
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID) && this.Stronghold.getPlayerBase().isCoastal())
		}
	},
	{
		Name = "Arena",
		ID = "building.arena",
		Cost = this.Const.World.Stronghold.BuildingPrices["Arena"],
		Path = "arena_building",
		SouthPath = false,
		isValid = function(){
			return (!this.Stronghold.getPlayerBase().hasBuilding(this.ID) && this.Stronghold.getPlayerBase().m.Size == 3)
		}
	}
],
gt.Const.World.Stronghold.Location_options <-
[
	{
		Name = "Workshop",
		ID = "attached_location.workshop",
		Cost = this.Const.World.Stronghold.LocationPrices["Workshop"],
		Path = "workshop_location",
		Text= "Build a workshop. Generates tools."
	},
	{
		Name = "Ore Smelter",
		ID = "attached_location.ore_smelters",
		Cost = this.Const.World.Stronghold.LocationPrices["Ore"],
		Path = "ore_smelters_location",
		Text= "Build an ore smelter. Weaponsmiths carry more items."
	},
	{
		Name = "Blast Furnace",
		ID = "attached_location.blast_furnace",
		Cost = this.Const.World.Stronghold.LocationPrices["Blast"],
		Path = "blast_furnace_location",
		Text= "Build a blast furnace. Armourers carry more items."
	},
	{
		Name = "Stone Watchtower",
		ID = "attached_location.stone_watchtower",
		Cost = this.Const.World.Stronghold.LocationPrices["Stone"],
		Path = "stone_watchtower_location",
		Text= "Build a watchtower. Increases movement speed and sight range around the stronghold."
	},
	{
		Name = "Militia Trainingcamp",
		ID = "attached_location.militia_trainingcamp",
		Cost = this.Const.World.Stronghold.LocationPrices["Militia"],
		Path = "militia_trainingcamp_location",
		Text= "Build a militia camp. Increases strength of mercenaries and number of recruits in the hamlet."
	},
	{
		Name = "Wheat Fields",
		ID = "attached_location.wheat_fields",
		Cost = this.Const.World.Stronghold.LocationPrices["Wheat"],
		Path = "wheat_fields_location",
		Text= "Build Wheat Fields. You don't consume food around the stronghold."
	},
	{
		Name = "Herbalists Grove",
		ID = "attached_location.herbalists_grove",
		Cost = this.Const.World.Stronghold.LocationPrices["Herbalists"],
		Path = "herbalists_grove_location",
		Text= "Build a Herbalists Grove. Hitpoints regenerate faster when around the stronghold."
	},
	{
		Name = "Gold Mine",
		ID = "attached_location.gold_mine",
		Cost = this.Const.World.Stronghold.LocationPrices["Gold"],
		Path = "gold_mine_location",
		Text= "Build a gold mine. Gold will be generated over time."
	}
],

gt.Stronghold <- {}
gt.Stronghold.getPlayerBase <- function()
{
	local player_faction = this.Stronghold.getPlayerFaction()
	if (player_faction)
	{
		local player_settlements = player_faction.getSettlements()
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
gt.Stronghold.getPlayerFaction <- function()
{
	if ("FactionManager" in this.World) return this.World.FactionManager.getFactionOfType(this.Const.FactionType.Player)
	return false
}

gt.Stronghold.getClosestDistance <- function(_destination, _list, _tiles = false)
{
	local chosen = null;
	local closestDist = 9999;
	if(!_tiles)
	{
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
	}
	else {
	    foreach (obj in _list)
		{
			if (obj == null) continue
			local dist = obj.getDistanceTo(_destination)
			if (chosen == null || dist < closestDist)
			{
				chosen = obj;
				closestDist = dist;
			}
		}
	}
	return chosen
}

//modded from vanilla to allow for longer range
gt.Stronghold.checkForCoastal <- function(_tile)
{
	local recursiveCheck;
	recursiveCheck = function (_tile, _index = 0)
	{	
		if(_tile.Type == this.Const.World.TerrainType.Ocean || _tile.Type == this.Const.World.TerrainType.Shore){
			return true;
		}
		if(_index == 2) return false
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else
			{
				local next = _tile.getNextTile(i);
				if(next.Type == this.Const.World.TerrainType.Ocean || next.Type == this.Const.World.TerrainType.Shore){
					return true;
				}
				return recursiveCheck(next, _index+1)
			}
		}
	}
	local isCoastal = recursiveCheck(_tile)
	return isCoastal
}