::mods_hookNewObject("ui/screens/world/world_town_screen", function(o){
	local showLastActiveDialog = o.showLastActiveDialog;
	o.showLastActiveDialog = function()
	{
		if (::Stronghold.StrongholdScreen.isVisible())
			return;
		return showLastActiveDialog();
	}
})
