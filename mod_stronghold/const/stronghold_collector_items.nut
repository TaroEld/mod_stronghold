::Stronghold.CollectorItems <- {
	heart_of_the_forest_item = {
		Level = 4,
		Icon = 	"misc/inventory_schrat_heart.png"
	}
	lindwurm_scales_item = {
		Level = 4,
		Icon = 	"misc/inventory_lindwurm_scales.png"
	}
	ancient_wood_item = {
		Level = 4,
		Icon = 	"misc/inventory_schrat_wood.png"
	}
	glowing_resin_item = {
		Level = 4,
		Icon = 	"misc/inventory_schrat_resin.png"
	}
	potion_of_oblivion_item = {
		Level = 4,
		Icon = 	"consumables/potion_08.png"
	}
	lindwurm_bones_item = {
		Level = 4,
		Icon = 	"misc/inventory_lindwurm_bones.png"
	}
	lindwurm_blood_item = {
		Level = 4,
		Icon = 	"misc/inventory_lindwurm_blood.png"
	}
	sulfurous_rocks_item = {
		Level = 4,
		Icon = 	"loot/southern_11.png"
	}
	witch_hair_item = {
		Level = 4,
		Icon = 	"misc/inventory_hexe_hair.png"
	}
	mysterious_herbs_item = {
		Level = 3,
		Icon = 	"misc/inventory_hexe_herbs.png"
	}
	frost_unhold_fur_item = {
		Level = 3,
		Icon = 	"misc/inventory_unhold_frost_fur_01.png"
	}
	poisoned_apple_item = {
		Level = 3,
		Icon = 	"misc/inventory_hexe_apple.png"
	}
	unhold_bones_item = {
		Level = 3,
		Icon = 	"misc/inventory_unhold_bones.png"
	}
	unhold_heart_item = {
		Level = 3,
		Icon = 	"misc/inventory_unhold_01.png"
	}
	unhold_hide_item = {
		Level = 3,
		Icon = 	"misc/inventory_unhold_hide.png"
	}
	vampire_dust_item = {
		Level = 3,
		Icon = 	"misc/inventory_vampire_dust_01.png"
	}
	petrified_scream_item = {
		Level = 2,
		Icon = 	"misc/inventory_alp_scream.png"
	}
	potion_of_knowledge_item = {
		Level = 2,
		Icon = 	"consumables/potion_05.png"
	}
	third_eye_item = {
		Level = 2,
		Icon = 	"misc/inventory_alp_eye.png"
	}
	snake_oil_item = {
		Level = 2,
		Icon = 	"misc/inventory_snake_oil.png"
	}
	parched_skin_item = {
		Level = 2,
		Icon = 	"misc/inventory_alp_skin.png"
	}
	acidic_saliva_item = {
		Level = 2,
		Icon = 	"loot/southern_12.png"
	}
	hyena_fur_item = {
		Level = 2,
		Icon = 	"loot/southern_10.png"
	}
	werewolf_pelt_item = {
		Level = 2,
		Icon = 	"misc/inventory_wolfpelt_01.png"
	}
	glistening_scales_item = {
		Level = 1,
		Icon = 	"loot/southern_14.png"
	}
	miracle_drug_item = {
		Level = 1,
		Icon = 	"consumables/pills_01.png"
	}
	adrenaline_gland_item = {
		Level = 1,
		Icon = 	"misc/inventory_wolf_adrenaline.png"
	}
	happy_powder_item = {
		Level = 1,
		Icon = 	"consumables/powder_01.png"
	}
	wardog_heavy_armor_upgrade_item = {
		Level = 1,
		Icon = 	"armor_upgrades/upgrade_20.png"
	}
	ghoul_horn_item = {
		Level = 1,
		Icon = 	"misc/inventory_ghoul_horn.png"
	}
	serpent_skin_item = {
		Level = 1,
		Icon = 	"loot/southern_13.png"
	}
	spider_silk_item = {
		Level = 1,
		Icon = 	"misc/inventory_webknecht_silk.png"
	}
	poison_gland_item = {
		Level = 1,
		Icon = 	"misc/inventory_webknecht_poison.png"
	}
	ghoul_brain_item = {
		Level = 1,
		Icon = 	"misc/inventory_ghoul_brain.png"
	}
	ghoul_teeth_item = {
		Level = 1,
		Icon = 	"misc/inventory_ghoul_teeth_01.png"
	}
	wardog_armor_upgrade_item = {
		Level = 1,
		Icon = 	"armor_upgrades/upgrade_21.png"
	}
}
::Stronghold.CollectorItemsByLevel <- [[], [], [], []];
foreach (key, item in ::Stronghold.CollectorItems)
{
	item.Path <- key;
	::Stronghold.CollectorItemsByLevel[item.Level -1].push(item);
}
