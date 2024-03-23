this.stronghold_attackers_event <- this.inherit("scripts/events/event", {
	m = {
		Destination = "",
		Origin = "",
		Direction = "",
	},
	function create()
	{
		this.m.ID = "event.stronghold_attackers";
		this.m.Title = "Meanwhile...";
		this.m.IsSpecial = true;
		this.m.Cooldown = 1 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_45.png[/img]Your scouts have informed you that a troop of enemies is approaching %destination%, hailing from a place called '%origin%', towards the %direction%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prepare to march.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function isValid()
	{
		return this.World.Statistics.hasNews("stronghold_attackers");
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		::MSU.Log.printStackTrace()
		local news = this.World.Statistics.popNews("stronghold_attackers");
		this.m.Destination = news.get("destination");
		this.m.Origin = news.get("origin");
		this.m.Direction = news.get("direction");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"destination",
			this.m.Destination
		]);

		_vars.push([
			"origin",
			this.m.Origin
		]);

		_vars.push([
			"direction",
			this.m.Direction
		]);
	}

	function onClear()
	{
		this.m.Destination = "";
		this.m.Origin = "";
		this.m.Direction = "";
	}
});

