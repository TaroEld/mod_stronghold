this.stronghold_screen_module <- this.inherit("scripts/ui/screens/ui_module", {
	m = {
	}

	function setID(_id)
	{
		this.m.ID = _id;
	}

	function updateData(_types)
	{
		this.m.Parent.updateData(_types);
	}

	function getUIData(_ret)
	{
		return _ret;
	}

	function getTown()
	{
		return this.m.Parent.getTown();
	}
})
