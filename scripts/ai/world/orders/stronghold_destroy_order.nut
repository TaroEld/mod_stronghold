this.stronghold_destroy_order <- this.inherit("scripts/ai/world/orders/destroy_order", {
	//inherited vanilla destroy, removed crisis checks
	m = {
	},
	function onExecute( _entity, _hasChanged )
	{
		local myTile = _entity.getTile();


		if (this.m.TargetTile != null && myTile.ID != this.m.TargetTile.ID)
		{
			local move = this.new("scripts/ai/world/orders/move_order");
			move.setDestination(this.m.TargetTile);
			this.getController().addOrderInFront(move);
			return true;
		}

		_entity.setOrders("Destroying");

		if (this.m.Start == 0.0)
		{
			this.m.Start = this.Time.getVirtualTimeF();
		}
		else if (this.Time.getVirtualTimeF() - this.m.Start >= this.m.Time)
		{
			local entities = this.World.getAllEntitiesAndOneLocationAtPos(_entity.getPos(), 1.0);

			foreach( e in entities )
			{
				if (e.isAlive() && e.getID() == this.m.TargetID)
				{
					if (e.isUpgrading())
					{
						if (e.getSize() == 1)
							e.getFlags().set("BuildInterrupted", true);
						else
							e.getFlags().set("UpgradeInterrupted", true);
					}
					else
					{
						local situation = this.new("scripts/entity/world/settlements/situations/raided_situation");
						situation.setValidForDays(7);
						e.addSituation(situation);
					}
					break;
				}
			}

			this.getController().popOrder();
		}

		if (!this.m.IsBurning)
		{
			this.m.IsBurning = true;
			local entities = this.World.getAllEntitiesAndOneLocationAtPos(_entity.getPos(), 1.0);

			foreach( e in entities )
			{
				if (e.isLocation())
				{
					e.spawnFireAndSmoke();
					break;
				}
			}
		}

		return true;
	}

	function onDestinationAttacked(_dest, _isPlayerAttacking)
	{
		local isPlayerInitiated = true;
		local p;
		local playerBases = ::Stronghold.getPlayerFaction().getMainBases();
		local target = null;
		foreach(playerBase in playerBases)
		{
			if (this.getVecDistance(playerBase.getPos(), this.World.State.getPlayer().getPos()) <= 250)
			{
				target = playerBase;
				break;
			}
		}
		if (target != null)
		{
			p = this.World.State.getLocalCombatProperties(target.getPos());
			isPlayerInitiated = true;
			p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
			p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
			p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
			p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
			p.LocationTemplate.Template[0] = "tactical.stronghold_fortress_defense";
			p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.WallsAndPalisade;
			p.LocationTemplate.ShiftX = -10;
		}
		else p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
		p.Music = this.Const.Music.NobleTracks;
		p.CombatID = "Stronghold";
		this.World.Contracts.startScriptedCombat(p, isPlayerInitiated, true, true);
	}

	function setController(_a)
	{
		this.destroy_order.setController(_a);
		this.getEntity().setOnCombatWithPlayerCallback(this.onDestinationAttacked);
	}
});

