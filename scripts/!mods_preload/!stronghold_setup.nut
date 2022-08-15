::Stronghold <- {
	ID = "mod_stronghold",
	Name = "Stronghold",
	Version = "1.3.0"
};
::mods_registerMod(::Stronghold.ID, ::Stronghold.Version, ::Stronghold.Name);
::mods_queue(::Stronghold.ID, "mod_msu", function()
{	
	::mods_registerJS("stronghold_screen_module_template.js");
	foreach(file in this.IO.enumerateFiles("ui/mods/stronghold_ui_modules"))
	{
		local path = split(file, "/")
		::mods_registerJS("stronghold_ui_modules/" + path[path.len()-1] + ".js")
		::mods_registerCSS("stronghold_ui_modules/" + path[path.len()-1] + ".css")
	}
	::mods_registerJS("mod_stronghold.js");
	::mods_registerJS("stronghold_screen.js");
	::mods_registerCSS("mod_stronghold.css");
	::mods_registerCSS("stronghold_screen.css");
	::Stronghold.StrongholdScreen <- this.new("scripts/ui/screens/stronghold/stronghold_screen");
	::MSU.UI.registerConnection(::Stronghold.StrongholdScreen);
	this.include(::Stronghold.ID + "/load.nut")
});
