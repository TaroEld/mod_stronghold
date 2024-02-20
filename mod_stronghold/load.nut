::include(::Stronghold.ID + "/stronghold_settings.nut");
local folders = 
[
	"/const",
	"/hooks",
]
foreach (folder in folders)
{
	foreach (file in ::IO.enumerateFiles(::Stronghold.ID + folder))
	{
		::include(file);
	}
}
::include(::Stronghold.ID + "/tooltips.nut");
