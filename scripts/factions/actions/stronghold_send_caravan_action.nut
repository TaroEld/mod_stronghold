this.stronghold_send_caravan_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		Start = null,
		Dest = null
	},
	function create()
	{
		this.m.ID = "stronghold_send_caravan_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 7;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local player_base = this.Stronghold.getPlayerBase();
		if (!player_base || player_base.isIsolated())
		{
			return;
		}
		this.m.Score = 10;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local player_faction = this.Stronghold.getPlayerFaction();
		local player_base = this.Stronghold.getPlayerBase();
		if (!player_base) return
		
		//check for closest connected settlements. connected settlements are updated after roads are built
		local settlements = this.World.EntityManager.getSettlements();
		local closest = false;
		local closest_dist = 9999;
		foreach (settlement in settlements)
		{
			if (settlement.getOwner() != player_faction &&  player_base.isConnectedToByRoads(settlement) && (settlement.getOwner() == null || settlement.getOwner().isAlliedWith(player_faction.getID())))
			{
				if (!closest)
				{
					closest_dist = settlement.getTile().getDistanceTo(player_base.getTile())
					closest = settlement
				}
				if (settlement.getTile().getDistanceTo(player_base.getTile()) < closest_dist && this.Math.rand(0, 10) > 5)
				{
					{
						closest_dist = settlement.getTile().getDistanceTo(player_base.getTile())
						closest = settlement
					}
				}
			}
		}
		if (!closest) {return}
		
		local patrol_strength = 100 * (player_base.getSize()-1)
		if (player_base.hasAttachedLocation("attached_location.militia_trainingcamp"))
		{
			patrol_strength += 100
		}
		local party = _faction.spawnEntity(player_base.getTile(), "Caravan of " + player_base.getName(), true, this.Const.World.Spawn.Caravan, 50);
		this.Const.World.Common.assignTroops(party, this.Const.World.Spawn.Mercenaries, patrol_strength);

		//reset values to caravan after adding mercs
		party.setDescription("A caravan from your stronghold, escorted by mercenaries");
		party.setFootprintType(this.Const.World.FootprintsType.Caravan);
		party.getSprite("body").setBrush("cart_02")
		party.setMovementSpeed(0.5 * this.Const.World.MovementSettings.Speed);
		party.setVisibilityMult(1.0);
		party.setVisionRadius(this.Const.World.Settings.Vision * 0.25);
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.getFlags().set("IsCaravan", true);
		
		//add food, plus imported produce from target town
		local collected_loot = []
		if (closest.getProduce().len() != 0)
		{
			foreach (i in closest.getProduce())
			{
				//jank way of checking if produce is food
				if (i.slice(0, 3) == "sup" && i != "supplies/ammo_item" && i != "supplies/medicine_item" && i != "supplies/armor_parts_item")
				{
					collected_loot.push(i)
				}
			}
		}
		//add bread and grain if not enough produce is found
		if (collected_loot.len() < 9)
		{
			for (local i = collected_loot.len(); i < 10; i++)
			{
				if (i%2 == 0){party.addToInventory("supplies/bread_item")}
				else {party.addToInventory("supplies/ground_grains_item")}
			}
		}
		foreach ( item in collected_loot){
			party.addToInventory(item)
		}
		
		

		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(closest.getTile());
		move.setRoadsOnly(true);
		
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(5);
		
		local move_back = this.new("scripts/ai/world/orders/move_order");
		move_back.setDestination(player_base.getTile());
		move_back.setRoadsOnly(true);
		
		local unload = this.new("scripts/ai/world/orders/stronghold_unload_order");
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		
		c.addOrder(move);
		c.addOrder(wait);
		c.addOrder(move_back);
		c.addOrder(unload);
		c.addOrder(despawn);
		return true;
	}

});

