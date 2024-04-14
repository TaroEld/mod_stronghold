::mods_hookNewObject("ui/screens/world/world_campfire_screen", function ( o )
{
	o.onStrongholdClicked <- function()
	{
		this.World.State.getMenuStack().popAll(true)
		local event = this.new("scripts/events/mod_stronghold/stronghold_intro_event")
		this.World.Events.m.Events.push(event)
		this.World.Events.fire(event.getID())
	};
})