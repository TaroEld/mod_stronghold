this.stronghold_screen_misc_module <- this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {},

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
		// local home = this.getHome()
		// local tile = home.getTile()
		// local settlements = this.World.EntityManager.getSettlements();
		// local distances = [];
		// local longestAllowedDistance = 0;
		// local settlementOptions = [];
		// local validSettlements = []

		// foreach (settlement in settlements)
		// {
		// 	if (settlement == null || settlement == home) continue

		// 	local dist = home.getTile().getDistanceTo(settlement.getTile());
		// 	if (home.m.ConnectedToByRoads.len() != 0 && (dist > 60 || (distances.len() > 10 && dist > distances[10])))  continue;
		// 	local results = home.getRoadCost(settlement);
		// 	local cost = results[0]
		// 	local roadmult = results[1]
		// 	if (cost && cost != 0)
		// 	{
		// 		settlementOptions.push
		// 		({
		// 			Score = dist,
		// 			Name = settlement.getName(),
		// 			Cost = cost,
		// 			Roadmult = roadmult
		// 		})
		// 		distances.push(dist);
		// 		distances.sort();
		// 	}
		// }

		// local roadSort = function(_d1, _d2){
		// 	if (_d1.Score < _d2.Score)
		// 	{
		// 		return -1;
		// 	}
		// 	else if (_d1.Score > _d2.Score)
		// 	{
		// 		return 1;
		// 	}

		// 	return 0;
		// }

		// settlementOptions.sort(roadSort);
		// return settlementOptions;
	}

	function getTrainerOptions()
	{
		local roster = this.World.getPlayerRoster().getAll().filter(function(idx, bro){
			return bro.getLevel() < 11 && !bro.getSkills().hasSkill("effects.trained")});
		this.buildActiveOptions(roster, this.addTrainerScreen)
		return this.getActiveOptions()
	}

	function getGiftOptions()
	{
		local gift_options = clone this.m.Temp_Variable_List
		this.m.Temp_Variable_List = []
		this.buildActiveOptions(gift_options, this.addGiftScreen)
		return this.getActiveOptions()
	}

})
