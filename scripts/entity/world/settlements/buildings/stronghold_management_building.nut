this.stronghold_management_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	//modified marketplace.
	m = {
		Stash = null
	},
	function getStash()
	{
		return this.m.Stash;
	}

	function create()
	{
		this.building.create();
		this.m.ID = "building.management_building";
		this.m.Name = "Management";
		this.m.Description = "Manage your base";
		this.m.UIImage = "ui/settlements/stronghold_01_management";
		this.m.UIImageNight = "ui/settlements/building_06";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Management";
		this.m.TooltipIcon = "ui/icons/buildings/tavern.png";
		this.m.Stash = this.new("scripts/items/stash_container");
		this.m.Stash.setID("shop");
		this.m.Stash.setResizable(true);
		this.m.IsClosedAtNight = false;
		this.m.Sounds = [];
		this.m.SoundsAtNight = [];
	}

	function onClicked( _townScreen )
	{
		local fac = this.Stronghold.getPlayerFaction();
		local contract = this.new("scripts/contracts/contracts/stronghold_management_contract");
		contract.setEmployerID(fac.getRandomCharacter().getID());
		contract.setFaction(fac.getID())
		contract.setHome(this.getSettlement());
		contract.initScreensAndStates()
		this.World.Contracts.addContract(contract);
		this.World.Contracts.showContractByID(contract.getID());
	}

	function onSettlementEntered()
	{
	}

	function onUpdateShopList()
	{
		
	}

	function updateSprite()
	{
		local playerBase = this.m.Settlement
		this.m.UIImage = playerBase.m.UIBackgroundCenter + "_management"
		this.m.UIImageNight = playerBase.m.UIBackgroundCenter + "_night" + "_management"
	}
		
	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
		this.m.Stash.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);
		this.m.Stash.onDeserialize(_in);
	}

});

