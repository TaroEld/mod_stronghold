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
					
					e.setActive(false);
					e.getTile().spawnDetail(e.m.Sprite + "_ruins", this.Const.World.ZLevel.Object - 3, 0, false);
					e.fadeOutAndDie(true);
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

});

