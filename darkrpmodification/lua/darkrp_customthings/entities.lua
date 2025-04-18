--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]

--[[
    TODO: Cars
    lvs_wheeldrive_montreal
    lvs_wheeldrive_audiurquattro
    lvs_wheeldrive_e34
    lvs_wheeldrive_e9
    lvs_wheeldrive_highwayman
    lvs_wheeldrive_charger
    lvs_wheeldrive_ferrari365
    lvs_wheeldrive_city
    lvs_wheeldrive_dc2
    lvs_wheeldrive_2108
    lvs_wheeldrive_miata
    lvs_wheeldrive_rx7
    lvs_wheeldrive_w123
    lvs_wheeldrive_mgb_gt
    lvs_wheeldrive_bluebird
    lvs_wheeldrive_gtr34
    lvs_wheeldrive_pugo106
    lvs_wheeldrive_pugo106s16
    lvs_wheeldrive_porsche930cab
    lvs_wheeldrive_porsche930coup
    lvs_wheeldrive_porsche930targa
    lvs_wheeldrive_regal
    lvs_wheeldrive_supervan
    lvs_wheeldrive_supra
--]]

--Config
local price_multiplier = 0.2

--CARS
DarkRP.createEntity("Mercedes E230 - Police Issue", {
	ent = "lvs_wheeldrive_w123_polizei",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 0,
	max = 1,
	allowed = { TEAM_POLICE, TEAM_CHIEF, TEAM_MAYOR },
	cmd = "buypolice",
	category = "Cars",
})

DarkRP.createEntity("Golf GTI", {
	ent = "lvs_wheeldrive_dcgolfmk1",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 12000,
	max = 2,
	cmd = "buygolfgti",
	category = "Cars",
})

DarkRP.createEntity("Nissan Silvia", {
	ent = "lvs_wheeldrive_dc2",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 15000,
	max = 2,
	cmd = "buysilvia",
	category = "Cars",
})

DarkRP.createEntity("Toyota Corolla", {
	ent = "lvs_wheeldrive_dc_corollasr5",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 16500,
	max = 2,
	cmd = "buycorolla",
	category = "Cars",
})

DarkRP.createEntity("Nissan Skyline", {
	ent = "lvs_wheeldrive_gtr34",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 23000,
	max = 2,
	cmd = "buyskyline",
	category = "Cars",
})

DarkRP.createEntity("Honda Prelude", {
	ent = "lvs_wheeldrive_dc_prelude4",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 28000,
	max = 2,
	cmd = "buyprelude",
	category = "Cars",
})

DarkRP.createEntity("Ferrari 360", {
	ent = "lvs_wheeldrive_ferrari360",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 80000,
	max = 2,
	cmd = "buyferrari",
	category = "Cars",
})

DarkRP.createEntity("Montreal", {
	ent = "lvs_wheeldrive_montreal",
	model = "models/props_c17/consolebox01a.mdl", --Leave default
	price = price_multiplier * 15000,
	max = 2,
	cmd = "buymontreal",
	category = "Cars",
})

DarkRP.createEntity("Audi Quattro", {
	ent = "lvs_wheeldrive_audiurquattro",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 20000,
	max = 2,
	cmd = "buyaudiquattro",
	category = "Cars",
})

DarkRP.createEntity("BMW E34", {
	ent = "lvs_wheeldrive_e34",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 18000,
	max = 2,
	cmd = "buybmwe34",
	category = "Cars",
})

DarkRP.createEntity("BMW E9", {
	ent = "lvs_wheeldrive_e9",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 22000,
	max = 2,
	cmd = "buybmwe9",
	category = "Cars",
})

DarkRP.createEntity("Highwayman", {
	ent = "lvs_wheeldrive_highwayman",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 16000,
	max = 2,
	cmd = "buyhighwayman",
	category = "Cars",
})

DarkRP.createEntity("Charger", {
	ent = "lvs_wheeldrive_charger",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 24000,
	max = 2,
	cmd = "buycharger",
	category = "Cars",
})

DarkRP.createEntity("Ferrari 365", {
	ent = "lvs_wheeldrive_ferrari365",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 35000,
	max = 2,
	cmd = "buyferrari365",
	category = "Cars",
})

DarkRP.createEntity("Honda City", {
	ent = "lvs_wheeldrive_city",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 10000,
	max = 2,
	cmd = "buycitycar",
	category = "Cars",
})

DarkRP.createEntity("Acura Integra DC2", {
	ent = "lvs_wheeldrive_dc2",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 15000,
	max = 2,
	cmd = "buyintegradc2",
	category = "Cars",
})

DarkRP.createEntity("Lada 2108", {
	ent = "lvs_wheeldrive_2108",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 8000,
	max = 2,
	cmd = "buylada2108",
	category = "Cars",
})

DarkRP.createEntity("Mazda Miata", {
	ent = "lvs_wheeldrive_miata",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 14000,
	max = 2,
	cmd = "buymiata",
	category = "Cars",
})

DarkRP.createEntity("Mazda RX7", {
	ent = "lvs_wheeldrive_rx7",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 20000,
	max = 2,
	cmd = "buyrx7",
	category = "Cars",
})

DarkRP.createEntity("Mercedes W123", {
	ent = "lvs_wheeldrive_w123",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 12000,
	max = 2,
	cmd = "buyw123",
	category = "Cars",
})

DarkRP.createEntity("MGB GT", {
	ent = "lvs_wheeldrive_mgb_gt",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 15000,
	max = 2,
	cmd = "buymgbgt",
	category = "Cars",
})

DarkRP.createEntity("Nissan Bluebird", {
	ent = "lvs_wheeldrive_bluebird",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 10000,
	max = 2,
	cmd = "buynissanbluebird",
	category = "Cars",
})

DarkRP.createEntity("Nissan GTR R34", {
	ent = "lvs_wheeldrive_gtr34",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 30000,
	max = 2,
	cmd = "buynissangtrr34",
	category = "Cars",
})

DarkRP.createEntity("Peugeot 106", {
	ent = "lvs_wheeldrive_pugo106",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 9000,
	max = 2,
	cmd = "buypeugeot106",
	category = "Cars",
})

DarkRP.createEntity("Peugeot 106 S16", {
	ent = "lvs_wheeldrive_pugo106s16",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 11000,
	max = 2,
	cmd = "buypeugeot106s16",
	category = "Cars",
})

DarkRP.createEntity("Porsche 930 Cabriolet", {
	ent = "lvs_wheeldrive_porsche930cab",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 45000,
	max = 2,
	cmd = "buyporsche930cab",
	category = "Cars",
})

DarkRP.createEntity("Porsche 930 Coupe", {
	ent = "lvs_wheeldrive_porsche930coup",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 47000,
	max = 2,
	cmd = "buyporsche930coup",
	category = "Cars",
})

DarkRP.createEntity("Porsche 930 Targa", {
	ent = "lvs_wheeldrive_porsche930targa",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 46000,
	max = 2,
	cmd = "buyporsche930targa",
	category = "Cars",
})

DarkRP.createEntity("Buick Regal", {
	ent = "lvs_wheeldrive_regal",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 13000,
	max = 2,
	cmd = "buybuickregal",
	category = "Cars",
})

DarkRP.createEntity("Reliant Supervan", {
	ent = "lvs_wheeldrive_supervan",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 10000,
	max = 2,
	cmd = "buysupervan",
	category = "Cars",
})

DarkRP.createEntity("Toyota Supra", {
	ent = "lvs_wheeldrive_supra",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 40000,
	max = 2,
	cmd = "buytoyotasupra",
	category = "Cars",
})

--Cars - Repair
--[[lvs_item_turbo
gmod_item_vehicle_fphysics_wheel
lvs_item_compressor
lvs_item_jerrycan
lvs_item_jerrycan_diesel
lvs_vehicle_repair]]

DarkRP.createEntity("Turbo", {
	ent = "lvs_item_turbo",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 10000,
	max = 2,
	cmd = "buyturbo",
	category = "Cars",
})

DarkRP.createEntity("Wheel", {
	ent = "gmod_item_vehicle_fphysics_wheel",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 1000,
	max = 2,
	cmd = "buywheel",
	category = "Cars",
})

DarkRP.createEntity("Compressor", {
	ent = "lvs_item_compressor",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 10000,
	max = 2,
	cmd = "buycompressor",
	category = "Cars",
})

DarkRP.createEntity("Jerrycan", {
	ent = "lvs_item_jerrycan",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 1000,
	max = 4,
	cmd = "buyjerrycan",
	category = "Cars",
})

DarkRP.createEntity("Jerrycan Diesel", {
	ent = "lvs_item_jerrycan_diesel",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 1000,
	max = 4,
	cmd = "buyjerrycandiesel",
	category = "Cars",
})

-- AIRCRAFT
--[[
    wac_hc_uh1d
    wac_hc_mi17
    wac_hc_206b
    wac_hc_206b_amphib
    wac_pl_ultralight
    wac_pl_t45
    wac_hc_r22
    wac_pl_bd5j
    wac_hc_blackhawk_uh60
    wac_pl_c172
    wac_hc_littlebird_mh6
    wac_hc_littlebird_h500
]]

DarkRP.createEntity("UH-1D", {
	ent = "wac_hc_uh1d",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 100000,
	max = 2,
	cmd = "buyuh1d",
	category = "Aircraft",
})

DarkRP.createEntity("Mi-17", {
	ent = "wac_hc_mi17",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 150000,
	max = 2,
	cmd = "buymi17",
	category = "Aircraft",
})

DarkRP.createEntity("Bell 206B", {
	ent = "wac_hc_206b",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 100000,
	max = 2,
	cmd = "buybell206b",
	category = "Aircraft",
})

DarkRP.createEntity("Bell 206B Amphibious", {
	ent = "wac_hc_206b_amphib",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 120000,
	max = 2,
	cmd = "buybell206bamphib",
	category = "Aircraft",
})

DarkRP.createEntity("Ultra Light", {
	ent = "wac_pl_ultralight",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 20000,
	max = 2,
	cmd = "buyultralight",
	category = "Aircraft",
})

DarkRP.createEntity("T-45 Goshawk", {
	ent = "wac_pl_t45",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 100000,
	max = 2,
	cmd = "buyt45",
	category = "Aircraft",
})

DarkRP.createEntity("Robinson R22", {
	ent = "wac_hc_r22",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 50000,
	max = 2,
	cmd = "buyr22",
	category = "Aircraft",
})

DarkRP.createEntity("BD-5J", {
	ent = "wac_pl_bd5j",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 50000,
	max = 2,
	cmd = "buybd5j",
	category = "Aircraft",
})

DarkRP.createEntity("UH-60 Blackhawk", {
	ent = "wac_hc_blackhawk_uh60",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 200000,
	max = 2,
	cmd = "buyuh60",
	category = "Aircraft",
})

DarkRP.createEntity("MH-6 Littlebird", {
	ent = "wac_hc_littlebird_mh6",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 100000,
	max = 2,
	cmd = "buymh6",
	category = "Aircraft",
})

DarkRP.createEntity("H-500 Littlebird", {
	ent = "wac_hc_littlebird_h500",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 100000,
	max = 2,
	cmd = "buyh500",
	category = "Aircraft",
})

DarkRP.createEntity("Cessna 172", {
	ent = "wac_pl_c172",
	model = "models/props_c17/consolebox01a.mdl",
	price = price_multiplier * 50000,
	max = 2,
	cmd = "buycessna172",
	category = "Aircraft",
})

-- Misc

DarkRP.createEntity("Vault Security Hacker", {
	ent = "svault_hacker",
	cmd = "buyvaulthacker",
	model = "models/ogl/ogl_securitysystem.mdl",
	price = 5500,
	max = 1,
	allowed = {
		TEAM_MOB,
	},
	category = "Other",
	customCheck = function(ply)
		return table.HasValue({ TEAM_MOB }, ply:Team())
	end,
	CustomCheckFailMsg = "Only the Mob Boss can buy this item",
})

-- DarkRP.createEntity("Drug Lab", {
--     ent = "drug_lab",
--     model = "models/props_c17/consolebox01a.mdl",
--     price = price_multiplier * 5000,
--     allowed = {TEAM_DRUG},
--     max = 3,
--     cmd = "buydruglab",
-- })

--Categories
DarkRP.createCategory({
	name = "Cars",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 100,
})

DarkRP.createCategory({
	name = "Aircraft",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 101,
})
