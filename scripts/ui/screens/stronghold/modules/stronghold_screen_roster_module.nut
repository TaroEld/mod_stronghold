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
			roster.push(this.UIDataHelper.convertEntityToUIData(b, null));
		}

		while (roster.len() < num)
		{
			roster.push(null);
		}
		return roster;
	}

	function queryPlayerRosterInformation()
	{
		local roster = this.World.Assets.getFormation();

		for( local i = 0; i != roster.len(); i = ++i )
		{
			if (roster[i] != null)
			{
				roster[i] = this.UIDataHelper.convertEntityToUIData(roster[i], null);
			}
		}
		return roster;
	}

	function getUIData( _ret )
	{
		_ret.SimpleTooltip <- this.isUsingSimplifiedRosterTooltip();
		_ret.PlayerRoster <- this.queryPlayerRosterInformation();
		_ret.TownRoster <- this.queryTownRosterInformation()
		return _ret
	}

	function onCheckCanTransferItems(_data)
	{
		local bro = this.getBroWithTagAndID(_data.ID, _data.RosterTag);
		local itemLen = bro.getItems().getAllItems().len();
		local emptyStashSlots = this.World.Assets.getStash().getNumberOfEmptySlots();
		return emptyStashSlots >= itemLen;
	}

	function onTransferItems()
	{
		local toTransfer = [];
		local stash = this.World.Assets.getStash();
		local bro = this.m.ItemsContainerToTransfer.getActor();

		foreach( item in this.m.ItemsToTransfer)
		{
			if (item.isEquipped())
			{
				this.m.ItemsContainerToTransfer.unequip(item);
			}
			else
			{
				this.m.ItemsContainerToTransfer.removeFromBag(item);
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

		this.m.ItemsToTransfer = [];
		this.m.ItemsContainerToTransfer = null;
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
})
