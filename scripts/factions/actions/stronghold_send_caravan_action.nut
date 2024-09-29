this.stronghold_send_caravan_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		PlayerBase = null,
	},
	function create()
	{
		this.m.ID = "stronghold_send_caravan_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 1;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local basesRequiringCaravan = [];
		foreach(playerBase in _faction.getDevelopedBases())
		{
			if (::Stronghold.isCooldownExpired(playerBase, "TimeUntilNextCaravan") && !playerBase.isUpgrading())
			{
				basesRequiringCaravan.push(playerBase)
			}
		}
		if (basesRequiringCaravan.len() == 0) return
		this.m.PlayerBase = ::MSU.Array.rand(basesRequiringCaravan);
		//only works with level 2+ base
		this.m.Score = 100;
	}

	function onClear()
	{
		this.m.PlayerBase = null
	}

	function getValidSettlements(_idx, _settlement)
	{
		local playerFaction = ::Stronghold.getPlayerFaction();
		local playerBase = this.m.PlayerBase;
		if (_settlement.getFlags().get("IsPlayerBase"))
			return false;
		if (!playerBase.isConnectedToByRoads(_settlement))
			return false;

		local settlementFaction = _settlement.getFactionOfType(this.Const.FactionType.Settlement);
		if (_settlement.isMilitary() || this.isKindOf(_settlement, "city_state"))
			settlementFaction = _settlement.getOwner();
		if (settlementFaction == null || !settlementFaction.isAlliedWith(playerFaction.getID()))
			return false;
		return true;
	}

	function onExecute( _faction )
	{
		local playerFaction = this.Stronghold.getPlayerFaction();
		local playerBase = this.m.PlayerBase;
		
		//check for closest connected settlements. connected settlements are updated after roads are built
		local settlements = this.World.EntityManager.getSettlements().filter(this.getValidSettlements.bindenv(this));
		local candidates = [];
		local closest_dist = 9999;
		foreach (settlement in settlements)
		{
			local dist = ::Stronghold.getDistanceOnRoads(playerBase.getTile(), settlement.getTile());

			if (candidates.len() == 0)
			{
				closest_dist = dist;
			}
			else if (dist < closest_dist)
			{
				closest_dist = dist;
			}
			else if (::Math.abs(closest_dist - dist) > 10)
			{
				continue;
			}
			candidates.push(settlement);
		}
		local target = ::MSU.Array.rand(candidates);
		if (target == null)
			return
		
		local partyStrength = ::Stronghold.Misc.CaravanStrength * playerBase.getSize();
		local trainingCamp = playerBase.getLocation( "attached_location.militia_trainingcamp");
		if (trainingCamp)
			partyStrength += trainingCamp.getAlliedPartyStrengthIncrease();
		partyStrength *= this.getReputationToDifficultyLightMult();

		local party = _faction.spawnEntity(playerBase.getTile(), "Caravan of " + playerBase.getName(), true, this.Const.World.Spawn.Caravan, 50);
		this.Const.World.Common.assignTroops(party, this.Const.World.Spawn.Mercenaries, partyStrength);

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
		local produce = target.getProduce().filter(function(_idx, _item){
			return _item.slice(0, 3) == "sup" && _item != "supplies/ammo_item" && _item != "supplies/medicine_item" && _item != "supplies/armor_parts_item";
		});
		if (produce.len() == 0)
		{
			produce.push("supplies/bread_item");
			produce.push("supplies/ground_grains_item");
		}
		for (local i = 0; i < 6; ++i)
		{
			party.addToInventory(::MSU.Array.rand(produce));
		}

		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(target.getTile());
		move.setRoadsOnly(true);
		
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(5);
		
		local move_back = this.new("scripts/ai/world/orders/move_order");
		move_back.setDestination(playerBase.getTile());
		move_back.setRoadsOnly(true);
		
		local unload = this.new("scripts/ai/world/orders/stronghold_unload_order");
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		
		c.addOrder(move);
		c.addOrder(wait);
		c.addOrder(move_back);
		c.addOrder(unload);
		c.addOrder(despawn);

		::Stronghold.setCooldown(playerBase, "TimeUntilNextCaravan");
		return true;
	}

});

