this.stronghold_fortress_defense <- this.inherit("scripts/mapgen/tactical_template", {
	//special location for defeat assailant quest
	m = {
		},
	function init()
	{
		this.m.Name = "tactical.stronghold_fortress_defense";
		this.m.MinX = 32;
		this.m.MinY = 32;
	}

	function fill( _rect, _properties, _pass = 1 )
	{
		local middleObjects = [
			"entity/tactical/objects/cartwheel",
			"entity/tactical/objects/human_camp_supplies",
			"entity/tactical/objects/human_camp_furniture",
			"entity/tactical/objects/human_camp_wood",
		]
		local centerTile = this.Tactical.getTileSquare(_rect.W / 2 + _properties.ShiftX, _rect.H / 2 + _properties.ShiftY);
		local isOnHill = centerTile.Level == 3;
		local hasPalisade = _properties.Fortification != 0;
		local radius = this.Const.Tactical.Settings.CampRadius + _properties.AdditionalRadius;
		
		for( local x = _rect.X; x < _rect.X + _rect.W; x = ++x )
		{
			for( local y = _rect.Y; y < _rect.Y + _rect.H; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);
				local d = centerTile.getDistanceTo(tile);
				if (d == radius+1 && ::Math.rand(0, 100) < 25)
				{
				}
				else if  (d == radius+2 && ::Math.rand(0, 100) < 50)
				{

				}
				else if  (d == radius+3 && ::Math.rand(0, 100) < 75)
				{

				}
				else if  (d > radius+3)
				{

				}
				else
				{
					tile.removeObject();
					tile.clear()
					tile.Type = this.Const.Tactical.TerrainType.PavedGround;
					tile.BlendPriority = this.Const.Tactical.TileBlendPriority.Road;
					tile.setBrush("tile_road");
				}
			}
		}

		for( local x = _rect.X; x < _rect.X + _rect.W; x = ++x )
		{
			for( local y = _rect.Y; y < _rect.Y + _rect.H; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);
				local d = centerTile.getDistanceTo(tile);				
				if (hasPalisade && d == radius && y != centerTile.SquareCoords.Y && x != centerTile.SquareCoords.X+1 && y != centerTile.SquareCoords.Y+1 && x != centerTile.SquareCoords.X+2)
				{
					local hasAdjacentWall = 0;
					for( local i = 0; i < 6; i = ++i )
					{
						if (!tile.hasNextTile(i))
						{
						}
						else
						{
							local adjacentTile = tile.getNextTile(i);
							if (!adjacentTile.IsEmpty)
							{
								 hasAdjacentWall++;
							}
						}
					}
					
					if (hasAdjacentWall <3)
					{
						tile.removeObject();
						local o;
						o = tile.spawnObject("entity/tactical/objects/graveyard_wall");
						o.setDirBasedOnCenter(centerTile, radius);
					}
				}		
				if (d > -5 && d < 5)
				{
					if ((!isOnHill || tile.Level >= 2) && (::Math.rand(1, 100) < 20) && y != centerTile.SquareCoords.Y && x != centerTile.SquareCoords.X)
					{
						tile.removeObject();
						local chosenObject = middleObjects[::Math.rand(0, middleObjects.len()-1)]
						local o;
						o = tile.spawnObject(chosenObject);
					}
				}
				if (d == 0)
				{
					if ((!isOnHill || tile.Level >= 2))
					{
						tile.removeObject();
						local o;
						o = tile.spawnObject("entity/tactical/objects/cart");
					}
				}
			}
		}
	}

});

