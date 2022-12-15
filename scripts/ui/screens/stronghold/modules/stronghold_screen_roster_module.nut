this.stronghold_screen_roster_module <-  this.inherit("scripts/ui/screens/stronghold/modules/stronghold_screen_module" , {
	m = {
		RosterOwner =
		{
		    Stronghold = "roster.stronghold",
		    Player = "roster.player"
		},
		ItemTypes = {
			All = 		0,
	    	Weapon = 	1,
	    	Armor = 	2,
	    	Bag = 		3
		}
	},

	function isUsingSimplifiedRosterTooltip()
	{
		return this.World.Flags.get("SimplifiedRosterTooltip");
	}

	function getRosterWithTag( _tag )
	{
		if (_tag == "roster.player")
		{
			return this.World.getPlayerRoster();
		}
		else
		{
			return this.getTown().getLocalRoster();
		}
	}

	function getBroWithTagAndID( _id, _tag )
	{
		local bro = this.Tactical.getEntityByID(_id);

		if (bro == null)
		{
			foreach ( b in this.getRosterWithTag(_tag).getAll() )
			{
				if (b.getID() == _id)
				{
					bro = b;
					break;
				}
			}

			if (bro == null)
			{
				this.logError("Can\'t find the brother in the given roster");
				return null;
			}
		}

		return bro;
	}

	function loadRosterWithTag( _tag )
	{
		local result = {};
		result.Assets <- {};
		result.Assets.No <- true;

		if (_tag == "roster.player")
		{
			this.queryPlayerRosterInformation(result);
		}
		else
		{
			this.queryTownRosterInformation(result);
		}

		this.m.JSHandle.asyncCall("loadFromData", result);
	}

	function queryTownRosterInformation()
	{
		local num = 16;
		local roster = [];
		local brothers = this.getTown().getLocalRoster().getAll();

		foreach (i, b in brothers)
		{
			b.setPlaceInFormation(i);
			local brotherUIData = this.UIDataHelper.convertEntityToUIData(b, null);
			brotherUIData.perkuidata <- this.getPerkUIData(brotherUIData.perks);
			roster.push(brotherUIData);
		}

		while (roster.len() < num)
		{
			roster.push(null);
		}
		return roster;
	}

	function queryPlayerRosterInformation()
	{
		this.World.Assets.updateFormation();
		local roster = this.World.Assets.getFormation();

		for( local i = 0; i != roster.len(); i = ++i )
		{
			if (roster[i] != null)
			{
				local brotherUIData = this.UIDataHelper.convertEntityToUIData(roster[i], null);
				brotherUIData.perkuidata <- this.getPerkUIData(brotherUIData.perks);
				roster[i] = brotherUIData;
			}
		}
		return roster;
	}

	function getPerkUIData(_perks)
	{
		local ret = [];
		foreach (perkID in _perks)
		{
			ret.push(this.UIDataHelper.convertPerkToUIData(perkID));
		}
		return ret;
	}

	function getUIData( _ret )
	{
		_ret.SimpleTooltip <- this.isUsingSimplifiedRosterTooltip();
		_ret.PlayerRoster <- this.queryPlayerRosterInformation();
		_ret.TownRoster <- this.queryTownRosterInformation();
		return _ret
	}

	function onCheckCanTransferItems(_data)
	{
		local bro = this.getBroWithTagAndID(_data.ID, _data.RosterTag);
		local itemLen = bro.getItems().getAllItems().len();
		local emptyStashSlots = this.World.Assets.getStash().getNumberOfEmptySlots();
		return {
			NumEmptySlots = emptyStashSlots
			NumItems = itemLen
		}
	}

	function onTransferItems(_data)
	{
		local toTransfer = [];
		local stash = this.World.Assets.getStash();
		local bro = this.getBroWithTagAndID(_data.ID, _data.RosterTag);
		local items = bro.getItems().getAllItems();
		foreach( item in items)
		{
			if (item.isEquipped())
			{
				bro.getItems().unequip(item);
			}
			else
			{
				bro.getItems().removeFromBag(item);
			}

			toTransfer.push(item);
		}

		foreach( item in toTransfer )
		{
			if (stash.add(item) == null)
			{
				break;
			}
		}

		if (typeof bro == "instance")
		{
			bro = bro.get();
		}

		this.m.JSHandle.asyncCall("updateSelectedBrother", this.UIDataHelper.convertEntityToUIData(bro, null));
	}

	function onUpdateNameAndTitle( _data )
	{
		local bro = this.getBroWithTagAndID(_data[0], _data[3]);

		if (bro == null)
		{
			this.logError("Can\'t find the brother to chance Name and Title");
			return null;
		}

		if (_data[1].len() >= 1)
		{
			bro.setName(_data[1]);
		}

		bro.setTitle(_data[2]);
		return this.UIDataHelper.convertEntityToUIData(bro, null);
	}

	function MoveAtoB(_data)
	{
		local bro = this.getBroWithTagAndID(_data.ID, _data.OriginTag);
		::logInfo(bro.getName())
		local originRoster = this.getRosterWithTag(_data.OriginTag);
		local destinationRoster = this.getRosterWithTag(_data.DestinationTag);
		destinationRoster.add(bro);
		originRoster.remove(bro);
	}

	function onBrothersButtonPressed()
	{
		::MSU.Utils.getState("world_state").toggleCharacterScreen()
	}

	function onDismissCharacter( _data )
	{
		this.World.State.m.CharacterScreen.onDismissCharacter([_data.ID, _data.Compensation])
		if(_data.RosterTag != "roster.player")
			this.getTown().getLocalRoster().remove(this.getBroWithTagAndID(_data.ID, _data.RosterTag))
		this.updateData(["StashModule", "RosterModule", "TownAssets", "Assets"])
	}
})
