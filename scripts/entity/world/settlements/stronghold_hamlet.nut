this.stronghold_hamlet <- this.inherit("scripts/entity/world/settlements/stronghold_player_base", {
	//custom player base settlement type. spawns custom storage building, modified marketplace that allows for both selling of trash and food and for storing items
	//many of the stronghold features are handled here
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = "Fortress"
		this.defineName();
		this.m.DraftList = this.Stronghold.FullDraftList;
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
		this.m.ShopSeed = this.Time.getRealTime() + ::Math.rand();
		this.m.RosterSeed = this.Time.getRealTime() + ::Math.rand();
		this.m.VisibilityMult = 2.0;
		this.m.IsVisited = true;
		this.m.IsUpgrading <- false;
		this.m.Banner = this.World.Assets.getBannerID();
		this.m.IsShowingBanner = true;
		this.m.Buildings.resize(7, null)
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_management_building"), 6);

		this.getFlags().set("IsPlayerBase", true);
		this.getFlags().set("IsMainBase", false);
	}

	function getStash()
	{
		//overwrite player_base one
		return null;
	}

	function updateImportedProduce()
	{
		this.settlement.updateImportedProduce();
	}
	
	function assimilateCharacteristics(_town)
	{
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
		return this.Stronghold.getPlayerFaction();
	}
	
	function getSizeName()
	{
		return this.Stronghold.Hamlet.Name;
	}
	
	function onEnter()
	{
		//updates buildings, shops, quests, attached locations
		this.location.onEnter();
		this.updateRoster();
		this.updateShop();
		::Math.seedRandom(this.Time.getRealTime());

		return true;
	}

	function onLeave()
	{
		this.settlement.onLeave();
	}

	function getParent(){
		local flag = this.m.Flags.get("Parent")
		if (!flag) return false
		return this.World.getEntityByID(flag)
	}

	function getContracts()
	{
		return [];
	}
	
	function updateTown()
	{
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

	function updateLook()
	{
		local constSprites = this.Stronghold.VisualsMap[this.m.Spriteset];
		this.m.TroopSprites = constSprites.WorldmapFigure[3];
		this.m.HouseSprites = constSprites.Houses;
	}

	function onSerialize( _out )
	{
		local management = this.m.Buildings.pop();
		this.m.Buildings.resize(6);
		this.settlement.onSerialize(_out);
		_out.writeU8(this.m.Size)
		_out.writeString(this.m.UIBackgroundCenter)
		_out.writeString(this.m.UIBackgroundLeft)
		_out.writeString(this.m.UIBackgroundRight)
		_out.writeString(this.m.UIRampPathway)
		_out.writeString(this.m.UISprite)
		_out.writeString(this.m.Sprite)
		_out.writeString(this.m.Lighting)

		_out.writeU8(this.m.HousesTiles.len());
		for( local i = 0; i != this.m.HousesTiles.len(); i = ++i )
		{
			_out.writeI16(this.m.HousesTiles[i].X);
			_out.writeI16(this.m.HousesTiles[i].Y);
			_out.writeU8(this.m.HousesTiles[i].V);
			_out.writeString(this.m.HousesTiles[i].Sprite);
			_out.writeString(this.m.HousesTiles[i].Light);
		}
		this.m.Buildings.append(management);
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

		this.m.Buildings.resize(7)
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_management_building"), 6);
		this.m.Buildings[6].updateSprite();

		this.m.HousesTiles.clear();
		local numHouses = _in.readU8();
		for( local i = 0; i != numHouses; i = ++i )
		{
			this.m.HousesTiles.push({
				X = _in.readI16(),
				Y = _in.readI16(),
				V = _in.readU8(),
				Sprite = _in.readString(),
				Light = _in.readString(),
			});
		}
		this.updateTown()
	}
});

