
::Stronghold.Flags <- {
	StrongholdAttacker = "StrongholdAttacker",
	UnderAttackBy = "UnderAttackBy",
	StrongholdGuards = "Stronghold_Guards", // backwards compatible
	BaseID = "Stronghold_Base_ID", // backwards compatible

	// cooldowns
	TimeUntilNextMercs = 7, // When next defenders are spawned
	TimeUntilNextPatrol = 7, // When next patrol is sent along the roads
	TimeUntilNextCaravan = 7, // When next caravan is sent to an allied town

	AttackerCooldown = 10, // cooldown of this camp in particular
	AttackedCooldown = 3, // cooldown of any camp
	LastUpgradeDoneAttackCooldown = 10,
}
