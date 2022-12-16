this.stronghold_screen_hamlet_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

	function getUIData( _ret )
	{
		local town = this.getTown();
		_ret.Price <- ::Stronghold.PriceMult * ::Stronghold.Hamlet.Price,
		_ret.Name <- ::Stronghold.Hamlet.Name,
		_ret.Description <- ::Stronghold.Hamlet.Description,
		_ret.Requirements <- []
		foreach (requirement in ::Stronghold.Hamlet.Requirements)
		{
			_ret.Requirements.push({
				Text = requirement.Text(town),
				Done = requirement.IsValid(town)
			})
		}
		return _ret
	}

	function spawnHamlet()
	{
		local tries = 0;
		local radius = 3
		local used = [];
		local list = this.Const.World.Settlements.Villages_small
		local playerBase = this.getTown()
		local playerFaction = this.Stronghold.getPlayerFaction()
		while (tries++ < 1000)
		{
			if (tries%100 == 0) radius++
			local tile = this.getTileToSpawnLocation(playerBase.getTile(), radius, radius+1, [], false)
			if (used.find(tile.ID) != null)
			{
				continue;
			}
			used.push(tile.ID);

			local navSettings = this.World.getNavigator().createSettings();
			local path = this.World.getNavigator().findPath(tile, playerBase.getTile(), navSettings, 0);
			if (path.isEmpty()) continue;


			local terrain = this.getTerrainInRegion(tile);
			local candidates = [];

			foreach( settlement in list )
			{
				if (settlement.isSuitable(terrain))
				{
					candidates.push(settlement);
				}
			}

			if (candidates.len() == 0)
			{
				continue;
			}

			local type = candidates[::Math.rand(0, candidates.len() - 1)];

			if ((terrain.Region[this.Const.World.TerrainType.Ocean] >= 3 || terrain.Region[this.Const.World.TerrainType.Shore] >= 3) && !("IsCoastal" in type) && !("IsFlexible" in type))
			{
				continue;
			}
			local hamlet = this.World.spawnLocation("scripts/entity/world/settlements/stronghold_hamlet", tile.Coords);
			playerFaction.addSettlement(hamlet);
			local result = this.new(type.Script)
			hamlet.assimilateCharacteristics(result)
			hamlet.getFlags().set("CustomSprite", playerBase.getFlags().get("CustomSprite"));
			hamlet.updateLook();
			hamlet.setDiscovered(true);
			hamlet.buildHouses();
			playerBase.buildRoad(hamlet);
			playerBase.getFlags().set("Child", hamlet.getID())
			hamlet.getFlags().set("Parent", playerBase.getID())
			playerFaction.getFlags().set("BuildHamlet", true)
			this.World.Assets.addMoney(-(::Stronghold.PriceMult * ::Stronghold.Hamlet.Price));
			return
		}
		::logError("STRONGHOLD: DID NOT MANAGE TO BUILD HAMLET - PLEASE REPORT BUG");
	}

	// copied from contract.nut
	function getTileToSpawnLocation( _pivot, _minDist, _maxDist, _notOnTerrain = [], _allowRoad = true, _needsLandConnection = true, _needsLandConnectionToPlayer = false )
	{
		local mapSize = this.World.getMapSize();
		local tries = 0;
		local myTile = _pivot;
		local minDistToLocations = _minDist == 0 ? 0 : this.Math.min(4, _minDist - 1);
		local used = [];
		local pathDistanceMult = 2;

		while (1)
		{
			tries = ++tries;

			if (tries == 500)
			{
				_maxDist = _maxDist * 2;
				_minDist = _minDist / 2;
			}
			else if (_needsLandConnection && tries == 2000)
			{
				used = [];
				pathDistanceMult = 4;
			}

			local x = this.Math.rand(myTile.SquareCoords.X - _maxDist, myTile.SquareCoords.X + _maxDist);
			local y = this.Math.rand(myTile.SquareCoords.Y - _maxDist, myTile.SquareCoords.Y + _maxDist);

			if (x <= 3 || x >= mapSize.X - 3 || y <= 3 || y >= mapSize.Y - 3)
			{
				continue;
			}

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			local tile = this.World.getTileSquare(x, y);

			if (used.find(tile.ID) != null)
			{
				continue;
			}

			used.push(tile.ID);

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			if (tile.IsOccupied)
			{
				continue;
			}

			if (tile.HasRoad && !_allowRoad)
			{
				continue;
			}

			if (tile.getDistanceTo(myTile) < _minDist)
			{
				continue;
			}

			local abort = false;

			foreach( t in _notOnTerrain )
			{
				if (t == tile.Type)
				{
					abort = true;
					break;
				}
			}

			if (abort)
			{
				continue;
			}

			if (!_allowRoad)
			{
				local hasRoad = false;

				for( local j = 0; j != 6; j = ++j )
				{
					if (tile.hasNextTile(j) && tile.getNextTile(j).HasRoad)
					{
						hasRoad = true;
						break;
					}
				}

				if (hasRoad)
				{
					continue;
				}
			}

			local settlements = this.World.EntityManager.getSettlements();

			foreach( s in settlements )
			{
				local d = s.getTile().getDistanceTo(tile);

				if (d < this.Math.max(_minDist, 4))
				{
					abort = true;
					break;
				}
			}

			if (abort)
			{
				continue;
			}

			if (minDistToLocations > 0)
			{
				local locations = this.World.EntityManager.getLocations();

				foreach( v in locations )
				{
					local d = tile.getDistanceTo(v.getTile());

					if (d < minDistToLocations)
					{
						abort = true;
						break;
					}
				}

				if (abort)
				{
					continue;
				}
			}

			if (_needsLandConnection)
			{
				local navSettings = this.World.getNavigator().createSettings();
				navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
				local path = this.World.getNavigator().findPath(myTile, tile, navSettings, 0);

				if (path.isEmpty())
				{
					continue;
				}

				for( ; path.getSize() > _maxDist * pathDistanceMult;  )
				{
				}
			}

			if (_needsLandConnectionToPlayer)
			{
				local navSettings = this.World.getNavigator().createSettings();
				navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
				local path = this.World.getNavigator().findPath(this.World.State.getPlayer().getTile(), tile, navSettings, 0);

				if (path.isEmpty())
				{
					continue;
				}
			}

			return tile;
		}

		return null;
	}

	function getTerrainInRegion( _tile )
	{
		local terrain = {
			Local = _tile.Type,
			Adjacent = [],
			Region = []
		};
		terrain.Adjacent.resize(this.Const.World.TerrainType.COUNT, 0);
		terrain.Region.resize(this.Const.World.TerrainType.COUNT, 0);

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else
			{
				++terrain.Adjacent[_tile.getNextTile(i).Type];
			}
		}

		this.World.queryTilesInRange(_tile, 1, 4, this.onTileInRegionQueried.bindenv(this), terrain.Region);
		return terrain;
	}

	function onTileInRegionQueried( _tile, _region )
	{
		++_region[_tile.Type];
	}
})
