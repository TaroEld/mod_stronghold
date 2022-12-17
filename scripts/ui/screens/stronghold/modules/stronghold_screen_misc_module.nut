this.stronghold_screen_misc_module <- this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {
		Road = {
			// Cache it, reload it only after a road was build
			Map = {}
		}
	},

	function getUIData( _ret )
	{
		// Build Road
		_ret.BuildRoad <- this.getRoadOptions();

		// Send Gifts
		_ret.Gifts <-
		{

		}
		// Hire Mercenaries
		_ret.HireMercenaries <-
		{

		}
		// Focused Training
		_ret.Training <-
		{

		}

		// Remove Base
		_ret.RemoveBase <-
		{

		}
		return _ret
	}

	function getRoadOptions()
	{
		local town = this.getTown()
		local tile = town.getTile()
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
			if (settlement.getName() in this.m.Road.Map)
			{
				settlementOptions.push(this.m.Road.Map[settlement.getName()]);
				continue;
			}

			local dist = town.getTile().getDistanceTo(settlement.getTile());
			if (town.m.ConnectedToByRoads.len() != 0 && (dist > 60 || (distances.len() > 10 && dist > distances[10])))  continue;
			local results = town.getRoadCost(settlement);
			local cost = results[0]
			local roadmult = results[1]
			if (cost && cost != 0)
			{
				option = {
					Score = dist,
					Name = settlement.getName(),
					Cost = cost,
					Roadmult = roadmult
				}
				settlementOptions.push(option);
				this.m.Road.Map[settlement.getName()] <- option;
				distances.push(dist);
				distances.sort();
			}
		}

		local roadSort = function(_d1, _d2){
			if (_d1.Score < _d2.Score)
			{
				return -1;
			}
			else if (_d1.Score > _d2.Score)
			{
				return 1;
			}

			return 0;
		}

		settlementOptions.sort(roadSort);
		return settlementOptions;
	}

	// function getTrainerOptions()
	// {
	// 	local roster = this.World.getPlayerRoster().getAll().filter(function(idx, bro){
	// 		return bro.getLevel() < 11 && !bro.getSkills().hasSkill("effects.trained")});
	// 	this.buildActiveOptions(roster, this.addTrainerScreen)
	// 	return this.getActiveOptions()
	// }

	// function getGiftOptions()
	// {
	// 	local gift_options = clone this.m.Temp_Variable_List
	// 	this.m.Temp_Variable_List = []
	// 	this.buildActiveOptions(gift_options, this.addGiftScreen)
	// 	return this.getActiveOptions()
	// }

})
