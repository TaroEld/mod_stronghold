::Stronghold <- {
	ID = "mod_stronghold",
	Name = "Stronghold",
	Version = "1.3.0"
};
::mods_registerMod(::Stronghold.ID, ::Stronghold.Version, ::Stronghold.Name);
::mods_queue(::Stronghold.ID, "mod_msu", function()
{	
	
	::mods_registerJS("mod_stronghold.js");
	::mods_registerCSS("mod_stronghold.css");
	
	this.include(::Stronghold.ID + "/load.nut")
});
