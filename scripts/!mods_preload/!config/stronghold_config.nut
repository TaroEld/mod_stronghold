local gt = this.getroottable();
gt.Const.World.Stronghold <- {};
gt.Const.World.Stronghold.PriceMult <- 1000; //fastest way to change prices, everything gets mult by this
gt.Const.World.Stronghold.BuyPrices <- [10, 20, 20]; //base prices for build/upgrade
gt.Const.World.Stronghold.UnlockAdvantages <-[
	"You can leave items and brothers behind, to retrieve them later as you need them.\n You can construct up to three buildings.\nYou can construct up to three locations.",
	"Bands of mercenaries will join your base and guard it against aggressors.\nYou can construct an additional building and three additional locations.\nYou can construct roads to other settlements, connecting your base to the world.",
	"You can construct an additional building, including an arena, and three additional locations.\nA number of unique contracts will be made available.\nYou can now construct an additional Hamlet, connected to your Stronghold."
]
gt.Const.World.Stronghold.RoadCost <- 0.5; // per segment
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