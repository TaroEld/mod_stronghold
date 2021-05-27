this.stronghold_unload_gifts_order <- this.inherit("scripts/ai/world/world_behavior", {
	//called when gift caravan arrives at the destination_faction
	//adds reputation to the target faction based on the items carried (determined in advance)
	m = {},
	function create()
	{
		this.world_behavior.create();
		this.m.ID = this.Const.World.AI.Behavior.ID.Unload;
		//needs flags
		this.m.Flags <- this.new("scripts/tools/tag_collection");
	}

	function onExecute( _entity, _hasChanged )
	{
		//add the reputation based on the items
		local destination_faction = this.World.FactionManager.getFaction(this.m.Flags.get("DestinationFaction"))
		local reputation_to_add = this.m.Flags.get("Reputation")
		destination_faction.addPlayerRelation(reputation_to_add);
		this.Stronghold.getPlayerFaction().updateAlliancePlayerFaction(destination_faction);
		
		//adds event to event manager
		local hasEvent = false;
		foreach (event in this.World.Events.m.Events)
		{
			if (event.m.ID == "event.caravan_gifts"){
				hasEvent= true;
				break;
				}
		}
		if (!hasEvent)
		{
			local event = this.new("scripts/events/mod_stronghold/stronghold_caravan_gifts_event")
			this.World.Events.m.Events.push(event)
		}
		
		//sets the event to tell you that a caravan has arrived
		local news = this.World.Statistics.createNews();
		news.set("Destination", this.m.Flags.get("Destination"));
		news.set("DestinationFaction", destination_faction.getName());
		news.set("Reputation", this.m.Flags.get("Reputation"));
		this.World.Statistics.addNews("gifts_arrived_at_town", news);
		this.getController().popOrder();
		return true;
	}
	function onSerialize( _out )
	{
		_out.writeBool(this.m.IsEnabled);
		this.m.Flags.onSerialize(_out);
	}

	function onDeserialize( _in )	
	{
		this.m.IsEnabled = _in.readBool();
		this.m.Flags.onDeserialize(_in, false);
	}

});

