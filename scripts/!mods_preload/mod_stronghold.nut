::Stronghold <- {
	ID = "mod_stronghold",
	Name = "Stronghold",
	Version = "2.0.6"
};
::mods_registerMod(::Stronghold.ID, ::Stronghold.Version, ::Stronghold.Name);
::mods_queue(::Stronghold.ID, "mod_msu", function()
{	
	::Stronghold.Mod <- ::MSU.Class.Mod(::Stronghold.ID, ::Stronghold.Version, ::Stronghold.Name);
	::include(::Stronghold.ID + "/stronghold_settings.nut");

	::mods_registerJS("dropdown.js");
	::mods_registerCSS("dropdown.css");
	::mods_registerJS("mod_stronghold.js");
	::mods_registerCSS("mod_stronghold.css");
	::mods_registerJS("const/stronghold_text.js");
	::mods_registerJS("stronghold_screen_module_template.js");
	local noCSSFiles = ["stronghold_screen_zbuildings_dialog_module", "stronghold_screen_zlocations_dialog_module"]
	foreach(file in this.IO.enumerateFiles("ui/mods/stronghold_ui_modules"))
	{
		local path = split(file, "/")
		local name = path[path.len()-1]
		::mods_registerJS(format("stronghold_ui_modules/%s.js", name));
		if (noCSSFiles.find(name) == null)
			::mods_registerCSS(format("stronghold_ui_modules/%s.css", name));
	}
	::mods_registerJS("stronghold_screen.js");
	::mods_registerCSS("stronghold_screen.css");
	::Stronghold.StrongholdScreen <- this.new("scripts/ui/screens/stronghold/stronghold_screen");
	::MSU.UI.registerConnection(::Stronghold.StrongholdScreen);
	this.include(::Stronghold.ID + "/load.nut")
});
