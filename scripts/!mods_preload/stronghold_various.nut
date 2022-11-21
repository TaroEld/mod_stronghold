local gt = this.getroottable();

gt.Stronghold.setupVarious <- function()
{
	// max length of menu options, limitation of the text window size. got it at 11 so leave 2 spaces for 'back' etc
	gt.Stronghold.MaxMenuOptionsLen <- 9; 

	gt.Stronghold.MAX_BASE_SIZE <- 3;

	gt.Stronghold.UnlockAdvantages <- [
		"You can leave items and brothers behind, to retrieve them later as you need them.\n You can construct up to three settlement buildings.\nYou can construct up to three locations, granting various advantages.\n You will be able to upgrade your base, unlocking more features.",
		"Bands of mercenaries will join your base and guard it against aggressors.\nYou can construct an additional building and three additional locations.\nYou can construct roads to other settlements, connecting your base to the world.",
		"You can construct an additional building, including an arena, and three additional locations.\nA number of unique contracts will be made available.\nYou can now construct the Hamlet, a town which is connected to your Stronghold."
	]

	gt.Stronghold.PlayerFactionActions <- [
	"scripts/factions/actions/stronghold_guard_base_action", 
	"scripts/factions/actions/stronghold_send_caravan_action", 
	"scripts/factions/actions/stronghold_patrol_roads_action"
	];


	gt.Stronghold.FullDraftList <-
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
	gt.Stronghold.getPlayerBase <- function()
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

	gt.Stronghold.getPlayerFaction <- function()
	{
		if ("FactionManager" in this.World) return this.World.FactionManager.getFactionOfType(this.Const.FactionType.Player)
		return null
	}

	gt.Stronghold.getMaxStrongholdNumber <- function(){
		local renown = this.World.Assets.getBusinessReputation();
		local level = 0;
		foreach(lvl in this.RenownPerLevel){
			if (renown > lvl) level++
		}
		return level
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
	gt.Stronghold.isOnTile <- function(_tile, _tileTypes)
	{
		foreach(tileType in _tileTypes){
			if (_tile.Type == tileType){
				return true
			}
			for( local i = 0; i != 6; i = ++i )
			{
				if (_tile.hasNextTile(i) && _tile.getNextTile(i).Type == tileType){
					return true;
				}
			}
		}
		return false
	}

	::Stronghold.IsCoastal <- function(_tile)
	{
		local isCoastal = false;
		local mapSize = this.World.getMapSize();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else if (_tile.getNextTile(i).Type == this.Const.World.TerrainType.Ocean || _tile.getNextTile(i).Type == this.Const.World.TerrainType.Shore)
			{
				isCoastal = true;
				break;
			}
		}

		if (isCoastal)
		{
			local function findAccessibleOceanEdge(_minX, _maxX, _minY, _maxY )
			{
				local myTile = _tile;
				local navSettings = this.World.getNavigator().createSettings();
				navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Ship;
				local tiles = [];

				for( local x = _minX; x < _maxX; x = ++x )
				{
					for( local y = _minY; y < _maxY; y = ++y )
					{
						if (!this.World.isValidTileSquare(x, y))
						{
						}
						else
						{
							local tile = this.World.getTileSquare(x, y);

							if (tile.Type != this.Const.World.TerrainType.Ocean || tile.IsOccupied)
							{
							}
							else
							{
								local isDeepSea = true;

								for( local i = 0; i != 6; i = ++i )
								{
									if (tile.hasNextTile(i) && tile.getNextTile(i).Type != this.Const.World.TerrainType.Ocean)
									{
										isDeepSea = false;
										break;
									}
								}

								if (!isDeepSea)
								{
								}
								else
								{
									tiles.push(tile);
								}
							}
						}
					}
				}

				while (tiles.len() != 0)
				{
					local idx = this.Math.rand(0, tiles.len() - 1);
					local tile = tiles[idx];
					tiles.remove(idx);
					local path = this.World.getNavigator().findPath(myTile, tile, navSettings, 0);

					if (!path.isEmpty())
					{
						return tile;
					}
				}

				return null;
			}
			local deepOceanTile = null;

			if (deepOceanTile == null)
			{
				deepOceanTile = findAccessibleOceanEdge(0, mapSize.X, 0, 1);
			}

			if (deepOceanTile == null)
			{
				deepOceanTile = findAccessibleOceanEdge(0, 1, 0, mapSize.Y);
			}

			if (deepOceanTile == null)
			{
				deepOceanTile = findAccessibleOceanEdge(mapSize.X - 1, mapSize.X, 0, mapSize.Y);
			}

			if (deepOceanTile == null)
			{
				deepOceanTile = findAccessibleOceanEdge(0, mapSize.X, mapSize.Y - 1, mapSize.Y);
			}

			if (deepOceanTile == null)
			{
				isCoastal = false;
			}
		}
		return isCoastal;
	}

	gt.Stronghold.buildMainBase <- function()
	{
		local priceMult = this.Stronghold.PriceMult
		local build_cost = this.Stronghold.BuyPrices[0] * priceMult
		//called from retinue menu
		this.World.Assets.addMoney(-build_cost);
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
		playerBase.setUpgrading(true);
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


	this.Math.randArray <- function(_array){
		if (typeof _array != "array") {
			this.logWarning("_array not an array or empty")
			return
		}
		if(_array.len() == 0) return null
		return _array[this.Math.rand(0, _array.len()-1)]
	}


	// Effect of the well supplied buff that is activated by default
	// Rarity dictates the amount of items that spawn in shops, including named items
	gt.Stronghold.WellSupplied <-
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

	::Stronghold.removeStrongholdSettlements <- function(_array)
	{
		return _array.filter(@(a, b) !("isPlayerBase" in b.m));
	}

}
