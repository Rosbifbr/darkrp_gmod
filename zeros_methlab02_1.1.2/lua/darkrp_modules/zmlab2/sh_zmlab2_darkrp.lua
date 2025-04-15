DarkRP.createCategory{
	name = "Méth",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 125, 255, 255),
	canSee = function(ply) return true end,
	sortOrder = 103
}

DarkRP.createEntity("Tent Kit", {
	ent = "zmlab2_tent",
	model = "models/zerochain/props_methlab/zmlab2_tentkit.mdl",
	price = 1000,
	max = 1,
	cmd = "buytent",
	allowTools = true,
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Equipment Crate", {
	ent = "zmlab2_equipment",
	model = "models/zerochain/props_methlab/zmlab2_chest.mdl",
	price = 1000,
	max = 1,
	cmd = "buyequipment",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

// Below is all the other stuff that usally gets bought via the Equipment / Storage Entity

/*
DarkRP.createEntity("Palette", {
	ent = "zmlab2_item_palette",
	model = "models/zerochain/props_methlab/zmlab2_palette.mdl",
	price = 1000,
	max = 1,
	cmd = "buyPalette",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Automatic Icebreaker", {
	ent = "zmlab2_item_autobreaker",
	description = "Upgrades the packing table to automaticly cracks and packs ice.",
	model = "models/zerochain/props_methlab/zmlab2_autobreaker.mdl",
	price = 5000,
	max = 1,
	cmd = "buyautobreaker",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Acid", {
	ent = "zmlab2_item_acid",
	model = "models/zerochain/props_methlab/zmlab2_acid.mdl",
	price = 1000,
	max = 6,
	cmd = "buyAcid",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Aluminum", {
	ent = "zmlab2_item_aluminium",
	model = "models/zerochain/props_methlab/zmlab2_aluminium.mdl",
	price = 1000,
	max = 6,
	cmd = "buyAluminium",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Liquid Oxygen", {
	ent = "zmlab2_item_lox",
	model = "models/zerochain/props_methlab/zmlab2_lox.mdl",
	price = 1000,
	max = 6,
	cmd = "buylox",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Methylamine", {
	ent = "zmlab2_item_methylamine",
	model = "models/zerochain/props_methlab/zmlab2_methylamine.mdl",
	price = 1000,
	max = 6,
	cmd = "buyMethylamine",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Filler", {
	ent = "zmlab2_machine_filler",
	model = "models/zerochain/props_methlab/zmlab2_filler.mdl",
	price = 1000,
	max = 1,
	cmd = "buyfiller",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Filter", {
	ent = "zmlab2_machine_filter",
	model = "models/zerochain/props_methlab/zmlab2_filter.mdl",
	price = 1000,
	max = 1,
	cmd = "buyFilter",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Frezzer", {
	ent = "zmlab2_machine_frezzer",
	model = "models/zerochain/props_methlab/zmlab2_frezzer.mdl",
	price = 1000,
	max = 1,
	cmd = "buyFrezzer",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Furnace", {
	ent = "zmlab2_machine_furnace",
	model = "models/zerochain/props_methlab/zmlab2_furnance.mdl",
	price = 1000,
	max = 1,
	cmd = "buyFurnace",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Mixer", {
	ent = "zmlab2_machine_mixer",
	model = "models/zerochain/props_methlab/zmlab2_mixer.mdl",
	price = 1000,
	max = 1,
	cmd = "buyMixer",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Ventilation", {
	ent = "zmlab2_machine_ventilation",
	model = "models/zerochain/props_methlab/zmlab2_ventilation.mdl",
	price = 1000,
	max = 1,
	cmd = "buyVentilation",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Storage", {
	ent = "zmlab2_storage",
	model = "models/zerochain/props_methlab/zmlab2_storage.mdl",
	price = 1000,
	max = 1,
	cmd = "buyStorage",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})

DarkRP.createEntity("Packing Table", {
	ent = "zmlab2_table",
	model = "models/zerochain/props_methlab/zmlab2_table.mdl",
	price = 1000,
	max = 1,
	cmd = "buyTable",
	allowed = TEAM_CITOYEN,
	category = "Méth"
})
*/
