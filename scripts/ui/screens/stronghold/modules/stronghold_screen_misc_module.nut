this.stronghold_screen_misc_module <- this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {
		Road = {
			// Cache it, reload it only after a road was build
			Map = {}
		},
	},

	function getUIData( _ret )
	{
		_ret.BuildRoad 			<- this.getRoadUIData();
		_ret.SendGifts 			<- this.getGiftUIData();
		_ret.TrainBrother 		<- this.getTrainingUIData();
		_ret.BuyWater 			<- this.getWaterUIData();
		_ret.HireMercenaries 	<- this.getMercenariesUIData();
		_ret.RemoveBase 		<- this.getRemoveBaseUIData();
		return _ret
	}

	function getRoadUIData()
	{
		local town = this.getTown();
		local tile = town.getTile();
		local settlements = this.World.EntityManager.getSettlements();
		local distances = [];
		local longestAllowedDistance = 0;
		local settlementOptions = [];
		local validSettlements = []
		local option;

		foreach (settlement in settlements)
		{

			if (settlement == null || settlement == town)
				continue
			if (settlement.getID() in this.m.Road.Map)
			{
				settlementOptions.push(this.m.Road.Map[settlement.getID()]);
				continue;
			}

			local dist = town.getTile().getDistanceTo(settlement.getTile());
			if (town.m.ConnectedToByRoads.len() != 0 && (dist > 60 || (distances.len() > 10 && dist > distances[10])))  continue;
			local results = town.getRoadCost(settlement);
			local segments = results[0]
			local roadmult = results[1]
			if (segments && segments != 0)
			{
				local cost = segments * ::Stronghold.Misc.RoadCost * ::Stronghold.Misc.PriceMult;
				option = {
					Score = dist,
					Name = settlement.getName(),
					FactionName = settlement.getOwner().getName(),
					ID = settlement.getID(),
					Segments = segments,
					Cost = cost,
					Roadmult = roadmult * 100,
					IsValid = cost < this.World.Assets.getMoney(),
					UISprite = settlement.m.UISprite
				}
				settlementOptions.push(option);
				this.m.Road.Map[settlement.getID()] <- option;
				distances.push(dist);
				distances.sort();
			}
		}

		local roadSort = function(_d1, _d2){
			if (_d1.Cost < _d2.Cost)
			{
				return -1;
			}
			else if (_d1.Cost > _d2.Cost)
			{
				return 1;
			}

			return 0;
		}

		settlementOptions.sort(roadSort);
		return settlementOptions;
	}

	function onBuildRoad(_target)
	{
		local targetSettlement = this.World.getEntityByID(_target.ID);
		this.World.Assets.addMoney(-_target.Cost);
		this.getTown().buildRoad(targetSettlement, _target.Roadmult * 0.01);
		this.m.Road.Map = {};
		::Stronghold.updateConnectedToByRoad();
		this.updateData(["Assets", "MiscModule"]);
	}

	function getGiftUIData()
	{
		::Stronghold.updateConnectedToByRoad();
		// SendGifts = main key
		local ret =
		{
			Price = ::Stronghold.Misc.GiftFlatCost * ::Stronghold.Misc.PriceMult,
			Gifts = [],
			ReputationGain = 0,
			Factions = [],
			HasValidFactions = false,
			HasValidTargets = false
		}

		foreach (i, item in this.getTown().getStash().getItems())
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Loot))
			{
				ret.Gifts.push({
					Name = item.m.Name,
					ID = item.getID(),
					Icon = item.m.Icon,
					Value = item.m.Value
				});

				ret.ReputationGain += ::Math.abs(item.m.Value / 200)
			}
		}

		local factions = [];
		factions.extend(this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse));
		factions.extend(this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState));
		foreach (faction in factions)
		{
			if (faction.getPlayerRelation() == 100)
				continue
			local militarySettlements = [];
			foreach (settlement in faction.getSettlements())
			{
				if ((faction.m.Type == this.Const.FactionType.OrientalCityState || settlement.isMilitary()) &&
					settlement.isConnectedToByRoads(this.getTown()))
				{
					militarySettlements.push(settlement);
				}
			}
			if (militarySettlements.len() > 0)
			{
				local chosenSettlement = this.getDistanceToTowns(this.getTown(), militarySettlements)
				local innerRet = {
					ID = faction.getID(),
					Name = faction.getName(),
					ImagePath = faction.getUIBanner(),
					Relation = faction.getPlayerRelationAsText(),
					RelationNum = this.Math.round(faction.getPlayerRelation()),
					IsHostile = !faction.isAlliedWithPlayer(),
					FactionName = faction.getName(),
					Distance = chosenSettlement.Distance,
					SettlementName = chosenSettlement.Settlement.getName(),
					SettlementID = chosenSettlement.Settlement.getID()
				}
				ret.Factions.push(innerRet);
			}
		}
		ret.Factions.sort(function(_d1, _d2){
			if (_d1.RelationNum < _d2.RelationNum)
			{
				return -1;
			}
			else if (_d1.RelationNum > _d2.RelationNum)
			{
				return 1;
			}

			return 0;
		});
		return ret;
	}

	function getDistanceToTowns(_origin, _destinations)
	{
		local chosenSettlement = null;
		local closestDist = 9999;

		foreach (settlement in _destinations)
		{
			if (settlement == null) continue
			local distance = settlement.getTile().getDistanceTo(_origin.getTile())
			if (chosenSettlement == null || distance < closestDist)
			{
				chosenSettlement = settlement;
				closestDist = distance;
			}
		}
		return {
			Settlement = chosenSettlement,
			Distance = closestDist
		}
	}

	function onSendGift(_target)
	{
		local playerFaction = this.Stronghold.getPlayerFaction();
		local playerBase = this.getTown()
		local targetSettlement = this.World.getEntityByID(_target.SettlementID);

		local partyStrength = (::Stronghold.Misc.CaravanStrength * playerBase.getSize()) + (_target.ReputationGain * 10);
		local trainingCamp = playerBase.getLocation( "attached_location.militia_trainingcamp" );
		if (trainingCamp)
			partyStrength += trainingCamp.getAlliedPartyStrengthIncrease();

		// getReputationToDifficultyLightMult
		local d = 1.0 + this.Math.minf(2.0, this.World.getTime().Days * 0.014) - 0.1;
		partyStrength *= (d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()]);

		local party = playerFaction.spawnEntity(playerBase.getTile(), "Giftbearers of " + playerBase.getName(), true, this.Const.World.Spawn.Caravan, 100);
		this.Const.World.Common.assignTroops(party, this.Const.World.Spawn.Mercenaries, partyStrength);
		party.setDescription("A caravan bringing gifts to " + targetSettlement.getName());
		party.setFootprintType(this.Const.World.FootprintsType.Caravan);
		party.getSprite("body").setBrush("cart_02")
		party.setVisibilityMult(1.0);
		party.setVisionRadius(this.Const.World.Settings.Vision * 0.25);
		party.getSprite("base").Visible = false;
		party.setVisibleInFogOfWar(true)
		party.setMirrored(true);
		party.getFlags().set("IsCaravan", true);
		party.getFlags().set("Stronghold_Caravan", true);

		// count and remove items
		local itemsToRemove = this.getTown().getStash().getItems().filter(@(_idx, _item)
			_item != null && _item.isItemType(this.Const.Items.ItemType.Loot)
		)
		local stash = this.getTown().getStash();
		foreach(item in itemsToRemove)
			stash.remove(item)



		//add orders to move to destination, 'unload' the gifts and get reputation, despawn
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);

		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(targetSettlement.getTile());
		move.setRoadsOnly(true);

		local unload = this.new("scripts/ai/world/orders/stronghold_unload_gifts_order");
		unload.m.Flags.set("DestinationFaction", _target.ID)
		unload.m.Flags.set("Destination", targetSettlement.getName())
		unload.m.Flags.set("Reputation", _target.ReputationGain)

		local despawn = this.new("scripts/ai/world/orders/despawn_order");

		c.addOrder(move)
		c.addOrder(unload)
		c.addOrder(despawn)
		this.updateData(["Assets", "MiscModule"]);
		return true;
	}

	function getTrainingUIData()
	{
		// TrainBrother
		local ret = {
			Requirements = {
				FoundTrainer = this.Stronghold.getPlayerFaction().m.Flags.get("Teacher"),
				Price = ::Stronghold.Misc.TrainerPrice * ::Stronghold.Misc.PriceMult
			}
			Price = ::Stronghold.Misc.TrainerPrice * ::Stronghold.Misc.PriceMult,
			Duration = ::Stronghold.Misc.TrainerBuffDurationInDays,
			XPGainMult = ::Stronghold.Misc.TrainerBuffDurationExpMult,
			ValidBrothers = []
		};
		local roster = [];
		roster.extend(this.World.getPlayerRoster().getAll());
		roster.extend(this.getTown().getLocalRoster().getAll());
		roster = roster.filter(function(idx, bro){
			return bro != null && !bro.getFlags().get("stronghold_trained");
		});

		foreach (bro in roster)
		{
			local uiData = {
				Name = bro.getName(),
				ID = bro.getID(),
				Level = bro.getLevel(),
				ImagePath = bro.getImagePath(),
				ImageOffsetX = bro.getImageOffsetX(),
				ImageOffsetY = bro.getImageOffsetY(),
				Talents = bro.getTalents(),
			}
			ret.ValidBrothers.push(uiData)
		}
		return ret;
	}

	function onTrainBrother(_obj)
	{
		local bro = ::Tactical.getEntityByID(_obj.BrotherID);
		local talentIndex = _obj.Idx
		local talents = bro.m.Talents;
		local attributeToChange = bro.m.Attributes[talentIndex];
		local maxIdx = attributeToChange.len() - 1;

		local oldTalent = talents[talentIndex];
		local newTalent = oldTalent + 1;
		talents[talentIndex] = newTalent;

		local toAdd = 0;
		local attributeDefs = this.Const.AttributesLevelUp[talentIndex];
		local nameHash = ::toHash(bro.getName());
		local oldArray = [];
		::Math.seedRandom(nameHash); // seed both times the same
		for( local i = this.Const.XP.MaxLevelWithPerkpoints - 2; i > -1 ; i-- )
		{
			oldArray.insert(0, this.Math.rand(attributeDefs.Min + (oldTalent== 3 ? 2 : oldTalent), attributeDefs.Max + (oldTalent == 3 ? 1 : 0)));
		}
		local newArray = [];
		::Math.seedRandom(nameHash); // seed both times the same
		for( local i = this.Const.XP.MaxLevelWithPerkpoints - 2; i > -1 ; i-- )
		{
			newArray.insert(0, this.Math.rand(attributeDefs.Min + (newTalent== 3 ? 2 : newTalent), attributeDefs.Max + (newTalent == 3 ? 1 : 0)));
		}
		for( local i = this.Const.XP.MaxLevelWithPerkpoints - 2; i > -1 ; i-- )
		{
			if (i > maxIdx)
				toAdd += (newArray[i] - oldArray[i]);
			else
				attributeToChange[i] = newArray[i];
		}
		toAdd = ::Math.max(0, toAdd); // can't reduce value
		local b = bro.getBaseProperties();
		local attrKey;
		switch (talentIndex)
		{
			case ::Const.Attributes.Hitpoints:
				bro.m.Hitpoints += toAdd;
				attrKey = "Hitpoints";
				break;
			case ::Const.Attributes.Bravery:
				attrKey = "Bravery";
				break;
			case ::Const.Attributes.Fatigue:
				attrKey = "Stamina";
				break;
			case ::Const.Attributes.Initiative:
				attrKey = "Initiative";
				break;
			case ::Const.Attributes.MeleeSkill:
				attrKey = "MeleeSkill";
				break;
			case ::Const.Attributes.RangedSkill:
				attrKey = "RangedSkill";
				break;
			case ::Const.Attributes.MeleeDefense:
				attrKey = "MeleeDefense";
				break;
			case ::Const.Attributes.RangedDefense:
				attrKey = "RangedDefense";
				break;
		}
		b[attrKey] += toAdd;

		local effect = this.new("scripts/skills/effects_world/new_trained_effect");
		effect.m.Duration = ::Stronghold.Misc.TrainerBuffDurationInDays;
		effect.m.XPGainMult = ::Stronghold.Misc.TrainerBuffDurationExpMult;
		effect.m.Icon = "skills/status_effect_75.png";
		bro.getSkills().add(effect);

		bro.getSkills().update();
		bro.setDirty(true);

		bro.getFlags().set("stronghold_trained", true);
		this.World.Assets.addMoney(-(::Stronghold.Misc.TrainerPrice * ::Stronghold.Misc.PriceMult));
		this.updateData(["Assets"]);
		return {
			Talent = newTalent,
			ToAdd = toAdd,
		};
	}

	function getWaterUIData()
	{
		local ret = {
			Requirements =
			{
				Unlocked = this.Stronghold.getPlayerFaction().m.Flags.get("Waterskin"),
				Price = ::Stronghold.Misc.WaterPrice * ::Stronghold.Misc.PriceMult,
				EmptySlot = ::Stash.hasEmptySlot()
			},
			Price = ::Stronghold.Misc.WaterPrice * ::Stronghold.Misc.PriceMult
		};
		return ret;
	}

	function onWaterSkinBought()
	{
		local item = this.new("scripts/items/special/fountain_of_youth_item");
		this.World.Assets.getStash().add(item);
		this.World.Assets.addMoney(-(::Stronghold.Misc.WaterPrice * ::Stronghold.Misc.PriceMult));
		this.updateData(["Assets", "MiscModule", "StashModule"]);
	}

	// Mercenaries

	function getMercenariesUIData()
	{

		local ret = {
			Requirements =
			{
				Unlocked = this.Stronghold.getPlayerFaction().m.Flags.get("Mercenaries"),
				NoMercenaries = true,
				Price = ::Stronghold.Misc.MercenaryPrice * ::Stronghold.Misc.PriceMult,
			},
			Price = ::Stronghold.Misc.MercenaryPrice * ::Stronghold.Misc.PriceMult,
			Duration = ::Stronghold.Misc.MercenaryFollowDays,
		};
		foreach ( unit in this.Stronghold.getPlayerFaction().m.Units){
			if (unit.getFlags().get("Stronghold_Mercenaries")){
				ret.Requirements.NoMercenaries = false;
				break;
			}
		}
		return ret;
	}

	function onHireMercenaries()
	{
		local playerBase = this.getTown();
		local playerFaction = this.Stronghold.getPlayerFaction();
		local partyStrength = 200;
		local trainingCamp = playerBase.getLocation( "attached_location.militia_trainingcamp" );
		if (trainingCamp)
			partyStrength += trainingCamp.getAlliedPartyStrengthIncrease();
		// getReputationToDifficultyLightMult
		local d = 1.0 + this.Math.minf(2.0, this.World.getTime().Days * 0.014) - 0.1;
		partyStrength *= (d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()]);

		local party = playerFaction.spawnEntity(playerBase.getTile(), "Mercenary band of " + playerBase.getName(), true, this.Const.World.Spawn.Mercenaries, partyStrength);
		party.getSprite("body").setBrush("figure_mercenary_01");
		party.setDescription("A band of mercenaries accompanying your party.");
		party.getFlags().set("Stronghold_Mercenaries", true);
		party.setFootprintType(this.Const.World.FootprintsType.CityState);
		party.setMovementSpeed(150)
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false)
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false)
		local follow = this.new("scripts/ai/world/orders/stronghold_follow_order");
		follow.setDuration(::Stronghold.Misc.MercenaryFollowDays);
		c.addOrder(follow);
		this.World.Assets.addMoney(-(::Stronghold.Misc.MercenaryPrice * ::Stronghold.Misc.PriceMult));
		this.updateData(["Assets", "MiscModule"]);
	}

	function onZoomToTargetCity(_townID)
	{
		this.World.getCamera().moveTo(this.World.getEntityByID(_townID));
	}

	function getRemoveBaseUIData()
	{
		local ret = {
			NotUpgrading = !this.getTown().isUpgrading(),
			NoContract = this.World.Contracts.getActiveContract() == null
		};
		return ret;
	}

	function onRemoveBase()
	{
		this.World.State.m.MenuStack.popAll(true);
		this.removeBase();
	}

	function removeBase()
	{
		local playerFaction = ::Stronghold.getPlayerFaction();
		local contracts = playerFaction.getContracts();
		foreach (contract in contracts)
		{
			this.World.Contracts.removeContract(contract);
		}
		this.getTown().fadeOutAndDie(true);
	}
})
