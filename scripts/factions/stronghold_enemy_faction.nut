this.stronghold_enemy_faction <- this.inherit("scripts/factions/faction", {
	// used for base attacks
	m = {
		HairColor = 0,
		Traits = [],
		Deck = []
	},

	function create()
	{
		this.faction.create();
		this.m.Type = this.Const.FactionType.StrongholdEnemies;
		this.m.Base = "world_base_10";
		this.m.TacticalBase = "bust_base_beasts";
		this.m.CombatMusic = this.Const.Music.BeastsTracks;
		this.m.Footprints = this.Const.BeastFootprints;
		this.m.IsHidden = true;
		this.m.PlayerRelation = 0.0;
		this.m.IsRelationDecaying = false;
		this.addTrait(this.Stronghold.EnemyFactionActions);
	}

	function addTrait( _t )
	{
		// on deserialize
		if (typeof _t == "integer")
		{
			this.m.Traits.push(_t);
		}
		// on init
		else
		{
			//add orders to the faction, during upgrades
			this.m.Deck = []
			foreach( c in _t )
			{
				local card = this.new(c);
				card.setFaction(this);
				this.m.Deck.push(card);
			}
		}
	}

	function copyLooks(_faction)
	{
		this.m.Base = _faction.m.Base;
		this.m.TacticalBase = _faction.m.TacticalBase;
		this.m.CombatMusic = _faction.m.CombatMusic;
		this.m.Footprints = _faction.m.Footprints;
		this.m.Traits =  clone _faction.m.Traits;
		this.m.Banner = _faction.m.Banner;
		this.m.Name = _faction.m.Name;
	}

	function getBannerSmall()
	{
		return "banner_noble_" + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner);
	}

	function isAlliedWithPlayer()
	{
		return false;
	}

	function addPlayerRelation( _r, _reason = "" )
	{
	}

	function addPlayerRelationEx( _r, _reason = "" )
	{
	}

	function spawnEntity( _tile, _name, _uniqueName, _template, _resources )
	{
		//same as vanilla
		local party = this.World.spawnEntity("scripts/entity/world/party", _tile.Coords);
		party.setFaction(this.getID());

		if (_uniqueName)
		{
			_name = this.getUniqueName(_name);
		}

		party.setName(_name);
		local t;

		if (_template != null)
		{
			//except for this line, allowing more than unit cap
			t = this.assignTroops(party, _template, _resources);
		}

		party.getSprite("base").setBrush(this.m.Base);

		if (t != null)
		{
			party.getSprite("body").setBrush(t.Body);
		}

		if (this.m.BannerPrefix != "")
		{
			party.getSprite("banner").setBrush(this.m.BannerPrefix + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner));
		}

		this.addUnit(party);
		return party;
	}

	function assignTroops ( _party, _partyList, _resources, _weightMode = 1)
	{
		//this function circumvents the max party sizes. initially had it used universally, now only during  specific calls
		local max_resources = _resources;
		local selected_party;
		while (_resources > 15)
		{
			selected_party = this.Const.World.Common.assignTroops( _party, _partyList, _resources, _weightMode = 1)
			foreach (t in _party.m.Troops)
			{
				_resources -= t.Cost;
			}
		}
		_party.updateStrength();
		return selected_party;
	}

	function onSerialize(_out)
	{
		this.faction.onSerialize(_out);
		_out.writeString(this.m.Base);
		_out.writeString(this.m.TacticalBase);
		_out.writeString(this.m.CombatMusic);
	}

	function onDeserialize(_in)
	{
		this.faction.onDeserialize(_in);
		this.m.Base = _in.readString();
		this.m.TacticalBase = _in.readString();
		this.m.CombatMusic = _in.readString();
	}
})
