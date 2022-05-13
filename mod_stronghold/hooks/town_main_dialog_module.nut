::mods_hookNewObject("ui/screens/world/modules/world_town_screen/town_main_dialog_module", function ( o )
{
	//renames town and updates it, sets flag it doesn't get overwritten
	o.renameTown <- function(_data)
	{
		if (_data[0].len() > 0)
		{
			local playerBase = this.World.State.getCurrentTown()
			playerBase.m.Name = _data[0]
			playerBase.getFlags().set("CustomName", true)
			playerBase.getLabel("name").Text = _data[0];
			this.reload()
		}
	}
	
	//loads the click function into the town screen if the base is the player base
	o.loadRename <- function()
	{
		this.m.JSHandle.asyncCall("loadRenameUI", null);
	}
	//deletes the click function upon leaving
	o.deleteRename <- function()
	{
		this.m.JSHandle.asyncCall("deleteRenameUI", null);
	}
	//tells backend that its visible so that input to change screen can be blocked
	o.onRenameTownVisible <- function(_data)
	{
		this.m.PopupDialogVisible <- _data;
	}
});