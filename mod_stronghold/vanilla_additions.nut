::Const.FactionType.StrongholdEnemies <- ::Const.FactionType.COUNT;
::Const.FactionType.COUNT++
::Const.Faction.StrongholdEnemies <- ::Const.Faction.COUNT;
::Const.Faction.COUNT++
::Const.World.Spawn.StrongholdMercenaries <- clone ::Const.World.Spawn.Mercenaries;
::Const.World.Spawn.StrongholdMercenaries.insert(0,
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.MercenaryLOW,
				Num = 1
			}
		]
	}
)
::Const.World.Spawn.StrongholdMercenaries.insert(0,
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.MercenaryLOW,
				Num = 2
			}
		]
	}
)

::Const.World.Spawn.StrongholdMercenaries.insert(0,
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.MercenaryLOW,
				Num = 3
			}
		]
	}
)

::Const.World.Spawn.StrongholdMercenaries.insert(0,
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.MercenaryLOW,
				Num = 4
			}
		]
	}
)
function onCostCompare( _t1, _t2 )
{
	if (_t1.Cost < _t2.Cost)
	{
		return -1;
	}
	else if (_t1.Cost > _t2.Cost)
	{
		return 1;
	}

	return 0;
}

function calculateCosts( _p )
{
	foreach( p in _p )
	{
		p.Cost <- 0;

		foreach( t in p.Troops )
		{
			p.Cost += t.Type.Cost * t.Num;
		}

		if (!("MovementSpeedMult" in p))
		{
			p.MovementSpeedMult <- 1.0;
		}
	}

	_p.sort(this.onCostCompare);
}

this.calculateCosts(::Const.World.Spawn.StrongholdMercenaries);
