this.stronghold_hamlet <- this.inherit("scripts/entity/world/settlements/stronghold_player_base", {
	//custom player base settlement type. spawns custom storage building, modified marketplace that allows for both selling of trash and food and for storing items
	//many of the stronghold features are handled here
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = "Fortress"
		this.defineName();
		this.m.DraftList = this.Const.World.Stronghold.FullDraftList;
		this.m.UIDescription = "Your hamlet";
		this.m.Description = "Your hamlet";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/stronghold_01.png";
		this.m.Sprite = "world_stronghold_01";
		this.m.Lighting = "world_stronghold_01_light";
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
		this.m.Size = 1;
		this.m.HousesType = 2;
		this.m.HousesMin = 1;
		this.m.HousesMax = 3;
		this.m.AttachedLocationsMax = 3;
		this.m.LocationType = this.Const.World.LocationType.Settlement;
		this.m.ShopSeed = this.Time.getRealTime() + this.Math.rand();
		this.m.RosterSeed = this.Time.getRealTime() + this.Math.rand();
		this.m.VisibilityMult = 2.0;
		this.m.IsVisited = true;
		this.m.IsUpgrading <- false;
		this.m.Banner = this.World.Assets.getBannerID();
		this.m.IsShowingBanner = true;
		this.m.Buildings.resize(7, null)
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_management_building"), 6);
		this.getFlags().set("IsSecondaryBase", true)
	}
	
	function assimilateCharacteristics(_town)
	{
		this.m.DraftList = _town.m.DraftList
		this.m.UIDescription = _town.m.UIDescription
		this.m.Description = _town.m.Description
		this.m.UIBackgroundCenter =  _town.m.UIBackgroundCenter 
		this.m.UIBackgroundLeft =   _town.m.UIBackgroundLeft 
		this.m.UIBackgroundRight =   _town.m.UIBackgroundRight 
		this.m.UIRampPathway =   _town.m.UIRampPathway 
		this.m.UISprite =  _town.m.UISprite 
		this.m.Sprite =  _town.m.Sprite 
		this.m.Lighting =   _town.m.Lighting 
		this.m.Rumors =  _town.m.Rumors 
		this.m.Culture = _town.m.Culture 
		this.updateTown()
	}
	function getFactionOfType(_type)
	{
		return this.Stronghold.getPlayerFaction()
	}
	
	/*function defineName()
	{
		if (this.getFlags().get("CustomName")) return;
		//dynamic name to add distinction for size, also adds the company name
		local name_by_size = ["Hamlet", "Hamlet", "Hamlet"]
		local company_name = this.World.Assets.getName();
		local final_name = "";
		if (company_name.slice(company_name.len()-1, company_name.len()) == "s")
		{
			company_name = company_name.slice(0, company_name.len()-1);
		}
		final_name += company_name + "'s " + name_by_size[this.m.Size -1];
		this.logDebug("Name is now: " +final_name);
		this.m.Name = final_name;
	}*/

	function getSizeName(){
		return this.Const.World.Stronghold.HamletName
	}
	
	function onEnter()
	{
		//updates buildings, shops, quests, attached locations
		this.World.State.getTownScreen().getMainDialogModule().loadRename()
		this.location.onEnter();
		this.updateRoster();
		this.updateShop();
		this.Math.seedRandom(this.Time.getRealTime());

		return true;
	}

	function getParent(){
		local flag = this.m.Flags.get("Parent")
		if (!flag) return false
		return this.World.getEntityByID(flag)
	}

	function updateQuests()
	{
	}
	

	function getContracts()
	{
		return [];
	}
	
	function updateTown(){
		//updates town after upgrading and loading the game. Necessary to update the sprites, names etc.
		
		//different looks
		this.defineName()
		this.getSprite("body").setBrush(this.m.Sprite);
		this.getLabel("name").Text = this.getName();
		local light = this.getSprite("lighting");
		if (this.m.Lighting != "");
		{
			light.setBrush(this.m.Lighting);
		}
		this.getLabel("name").Text = this.getName();
		this.getLabel("name").Visible = true;
		this.m.Buildings[6].updateSprite()
		
	}
	
	
	function updateRoster( _force = false )
	{
		local daysPassed = (this.Time.getVirtualTimeF() - this.m.LastRosterUpdate) / this.World.getTime().SecondsPerDay;

		if (!_force && this.m.LastRosterUpdate != 0 && daysPassed < 2)
		{
			return;
		}

		if (this.m.RosterSeed != 0)
		{
			this.Math.seedRandom(this.m.RosterSeed);
		}

		this.m.RosterSeed = this.Math.floor(this.Time.getRealTime() + this.Math.rand());
		this.m.LastRosterUpdate = this.Time.getVirtualTimeF();
		local roster = this.World.getRoster(this.getID());
		local current = roster.getAll();
		local iterations = this.Math.max(1, daysPassed / 2);
		local activeLocations = 0;

		foreach( loc in this.m.AttachedLocations )
		{
			if (loc.isActive())
			{
				activeLocations = ++activeLocations;
			}
		}

		local rosterMin = 6
		local rosterMax = 10
		
		if (this.getParent().hasAttachedLocation("attached_location.militia_trainingcamp")){
			rosterMin += 2;
			rosterMax += 2;
		}

		if (iterations < 7)
		{
			for( local i = 0; i < iterations; i = ++i )
			{
				for( local maxRecruits = this.Math.rand(this.Math.max(0, rosterMax / 2 - 1), rosterMax - 1); current.len() > maxRecruits;  )
				{
					local n = this.Math.rand(0, current.len() - 1);
					roster.remove(current[n]);
					current.remove(n);
				}
			}
		}
		else
		{
			roster.clear();
			current = [];
		}

		local maxRecruits = this.Math.rand(rosterMin, rosterMax);
		local draftList;
		draftList = clone this.m.DraftList;

		foreach( loc in this.m.AttachedLocations )
		{
			if("LegendMod" in this.Const){
				b.onUpdateDraftList(draftList, false)
			}
			else loc.onUpdateDraftList(draftList);
		}

		foreach( b in this.m.Buildings )
		{
			if (b != null)
			{
				if("LegendMod" in this.Const){
					b.onUpdateDraftList(draftList, false)
				}
				else b.onUpdateDraftList(draftList);
			}
		}

		foreach( s in this.m.Situations )
		{
			if("LegendMod" in this.Const){
				b.onUpdateDraftList(draftList, false)
			}
			else b.onUpdateDraftList(draftList)
		}
		if("LegendMod" in this.Const){
			this.World.Assets.getOrigin().onUpdateDraftList(draftList, false);
		}
		else this.World.Assets.getOrigin().onUpdateDraftList(draftList);

		while (maxRecruits > current.len())
		{
			local bro = roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx(draftList);
			current.push(bro);
		}

		this.World.Assets.getOrigin().onUpdateHiringRoster(roster);
	}



	
	function onSerialize( _out )
	{
		this.settlement.onSerialize(_out);
		_out.writeU8(this.m.Size)
		_out.writeString(this.m.UIBackgroundCenter)
		_out.writeString(this.m.UIBackgroundLeft)
		_out.writeString(this.m.UIBackgroundRight)
		_out.writeString(this.m.UIRampPathway)
		_out.writeString(this.m.UISprite)
		_out.writeString(this.m.Sprite)
		_out.writeString(this.m.Lighting)
		
	}
	
	function onDeserialize( _in )
	{
		this.settlement.onDeserialize(_in);
		this.m.Size  = _in.readU8();
		this.m.UIBackgroundCenter = _in.readString()
		this.m.UIBackgroundLeft = _in.readString()
		this.m.UIBackgroundRight = _in.readString()
		this.m.UIRampPathway = _in.readString()
		this.m.UISprite = _in.readString()
		this.m.Sprite = _in.readString()
		this.m.Lighting = _in.readString()
		this.updateTown()
	}
	

	

});

