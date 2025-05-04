::mods_hookExactClass("ai/world/behaviors/ai_world_attack", function(o)
{
	local onEvaluate = o.onEvaluate;
	onEvaluate = function(_entity)
	{
		local ret = onEvaluate(_entity);
		if (this.m.Target == null || !_entity.getFlags().get(::Stronghold.Flags.StrongholdGuards))
			return ret;

		local town = ::World.getEntityByID(_entity.getFlags().get(::Stronghold.Flags.BaseID));
		if (!town.isUnderAttack())
			return ret;

		local enemy = ::World.getEntityByID(town.getFlags().get("UnderAttackBy"));
		if (enemy != this.m.Target)
		{
			this.m.Target = null;
			return this.Const.World.AI.Behavior.Score.Zero;
		}
		return ret;
	}
})
