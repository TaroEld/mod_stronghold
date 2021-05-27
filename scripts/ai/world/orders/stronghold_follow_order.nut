this.stronghold_follow_order <- this.inherit("scripts/ai/world/world_behavior", {
	//follow order for the hired mercenaries. They keep up with the player party by constantly pathing towards them.
	m = {
		Duration = 0,
		Start = 0,
		WaitTimeStart = 0,
		WaitTime = 10
		
	},
	
	function setDuration(_dur)
	{
		this.m.Duration = _dur * this.World.getTime().SecondsPerDay;
	}
	

	function create()
	{
		this.world_behavior.create();
		this.m.ID = this.Const.World.AI.Behavior.ID.Move;
		this.m.Start = this.Time.getVirtualTimeF();
	}

	function onSerialize( _out )
	{
		this.world_behavior.onSerialize(_out);
		_out.writeF32(this.m.Duration);
		_out.writeF32(this.m.Start);
		
	}

	function onDeserialize( _in )
	{
		this.world_behavior.onDeserialize(_in);
		this.m.Duration = _in.readF32();
		this.m.Start = _in.readF32();
	}

	function onExecute( _entity, _hasChanged )
	{
		//despawns after a week
		if (this.Time.getVirtualTimeF() > this.m.Start + this.m.Duration)
		{
			local despawn = this.new("scripts/ai/world/orders/despawn_order");
			this.getController().clearOrders();
			this.getController().addOrder(despawn);
			return true;
		}
		else
		{
			local player_tile = this.World.State.getPlayer().getTile()
			if (_entity.getTile().ID != player_tile.ID)
			{
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(player_tile);
				this.getController().addOrderInFront(move);
				return true;
			}
		}
	}

});

