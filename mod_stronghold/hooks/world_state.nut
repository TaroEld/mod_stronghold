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

	//llws esc in base management
	local keyHandler = o.helper_handleContextualKeyInput;
	o.helper_handleContextualKeyInput = function(key)
	{
		if(!keyHandler(key) && key.getState() == 0)
		{
			if (key.getKey() == 41) // esc
			{
				foreach (contract in this.World.Contracts.m.Open)
				{
					if ("onEscPressed" in contract){
						contract.onEscPressed()
						return
					}
				}
			}
		}
	}

});
