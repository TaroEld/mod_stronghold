//to help adding retinue button
::mods_hookNewObject("ui/screens/world/modules/world_campfire_screen/campfire_main_dialog_module", function ( o )
{
	local queryData = o.queryData
	o.queryData <- function()
	{
		local result = queryData()
		local show = this.Stronghold.getPlayerFaction() == null;
		result.Assets.showStrongholdButton <- show;
		return result;
	}
});
