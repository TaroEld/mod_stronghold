::mods_hookNewObject("states/world_state", function (o)
{
	//block changing to character screen if changing name of stronghold
	local showCharacterScreenFromTown = o.showCharacterScreenFromTown
	o.showCharacterScreenFromTown = function()
	{
		if ("PopupDialogVisible" in this.World.State.getTownScreen().getMainDialogModule().m){
			if (this.World.State.getTownScreen().getMainDialogModule().m.PopupDialogVisible) return;
		}
		return showCharacterScreenFromTown()
	}
});
