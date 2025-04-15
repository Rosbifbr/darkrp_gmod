--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]

--[[
arccw_go_r8
arccw_go_p90
arccw_go_bizon
arccw_go_aug
arccw_go_g3
arccw_go_melee_knife
arccw_go_ssg08
arccw_go_fiveseven
arccw_go_ump
arccw_go_cz75
arccw_go_mp5
arccw_go_nade_knife
arccw_go_nade_smoke
arccw_go_p250
arccw_go_m9
arccw_go_sg556
arccw_go_nade_flash
arccw_go_usp
arccw_go_m1014
arccw_go_awp
arccw_go_tec9
arccw_go_negev
arccw_go_mac10
arccw_go_nade_frag
arccw_go_deagle
arccw_go_nova
arccw_go_m4
arccw_go_glock
arccw_go_taser
arccw_go_nade_molotov
arccw_go_ace
arccw_go_870
arccw_go_mag7
arccw_go_mp7
arccw_go_nade_incendiary
arccw_go_ak47
arccw_go_ar15
arccw_go_famas
arccw_go_p2000
arccw_go_scar
arccw_go_m249para
arccw_go_mp9
--]]

-- Define the shipments
local price_multiplier = 0.2

local rifleShipments = {
	{
		name = "AK-47",
		entity = "arccw_go_ak47",
		price = 20000,
		amount = 4,
		separate = true,
		pricesep = 7000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Rifles",
	},
	{
		name = "G3A3",
		entity = "arccw_go_g3",
		price = 23000,
		amount = 3,
		separate = true,
		pricesep = 8200,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Rifles",
	},
	{
		name = "SG 556",
		entity = "arccw_go_sg556",
		price = 21000,
		amount = 3,
		separate = true,
		pricesep = 7500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Rifles",
	},
	{
		name = "FAMAS",
		entity = "arccw_go_famas",
		price = 24000,
		amount = 3,
		separate = true,
		pricesep = 8500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Rifles",
	},
	{
		name = "Galil AR",
		entity = "arccw_go_galil",
		price = 25000,
		amount = 3,
		separate = true,
		pricesep = 9000,
		noship = false,
		allowed = { TEAM_GUN, TEAM_MOB },
		category = "Rifles",
	},
	{
		name = "AUG",
		entity = "arccw_go_aug",
		price = 20000,
		amount = 4,
		separate = true,
		pricesep = 7200,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Rifles",
	},
	{
		name = "M4A4",
		entity = "arccw_go_m4",
		price = 23000,
		amount = 3,
		separate = true,
		pricesep = 8200,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Rifles",
	},
	{
		name = "SCAR-20",
		entity = "arccw_go_scar",
		price = 26000,
		amount = 2,
		separate = true,
		pricesep = 9500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Rifles",
	},
	{
		name = "AR-15",
		entity = "arccw_go_ar15",
		price = 18000,
		amount = 4,
		separate = true,
		pricesep = 6500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Rifles",
	},
}

-- Create the shipments
for _, shipment in ipairs(rifleShipments) do
	DarkRP.createShipment(shipment.name, {
		model = "models/props/cs_office/cardboard_box03.mdl",
		entity = shipment.entity,
		price = shipment.price * price_multiplier,
		amount = shipment.amount,
		separate = shipment.separate,
		pricesep = shipment.pricesep * price_multiplier,
		noship = shipment.noship,
		allowed = shipment.allowed,
		category = shipment.category,
	})
end

-- Define the LMG shipments
local lmgShipments = {
	{
		name = "Negev",
		entity = "arccw_go_negev",
		price = 32000,
		amount = 2,
		separate = true,
		pricesep = 12000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "LMG",
	},
	{
		name = "M249",
		entity = "arccw_go_m249para",
		price = 35000,
		amount = 2,
		separate = true,
		pricesep = 13000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "LMG",
	},
}

-- Create the LMG shipments
for _, shipment in ipairs(lmgShipments) do
	DarkRP.createShipment(shipment.name, {
		model = "models/props/cs_office/cardboard_box03.mdl",
		entity = shipment.entity,
		price = shipment.price * price_multiplier,
		amount = shipment.amount,
		separate = shipment.separate,
		pricesep = shipment.pricesep * price_multiplier,
		noship = shipment.noship,
		allowed = shipment.allowed,
		category = shipment.category,
	})
end

-- Define the Marksman shipments
local marksmanShipments = {
	{
		name = "SSG 08",
		entity = "arccw_go_ssg08",
		price = 21000,
		amount = 3,
		separate = true,
		pricesep = 7500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Marksman",
	},
	{
		name = "AWP",
		entity = "arccw_go_awp",
		price = 30000,
		amount = 2,
		separate = true,
		pricesep = 11000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Marksman",
	},
}

-- Create the Marksman shipments
for _, shipment in ipairs(marksmanShipments) do
	DarkRP.createShipment(shipment.name, {
		model = "models/props/cs_office/cardboard_box03.mdl",
		entity = shipment.entity,
		price = shipment.price * price_multiplier,
		amount = shipment.amount,
		separate = shipment.separate,
		pricesep = shipment.pricesep * price_multiplier,
		noship = shipment.noship,
		allowed = shipment.allowed,
		category = shipment.category,
	})
end

-- Define the Handguns shipments
local handgunsShipments = {
	{
		name = "Desert Eagle",
		entity = "arccw_go_deagle",
		price = 10000,
		amount = 3,
		separate = true,
		pricesep = 4000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Handguns",
	},
	{
		name = "Glock",
		entity = "arccw_go_glock",
		price = 9500,
		amount = 3,
		separate = true,
		pricesep = 3800,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Handguns",
	},
	{
		name = "P250",
		entity = "arccw_go_p250",
		price = 9000,
		amount = 4,
		separate = true,
		pricesep = 3500,
		noship = false,
		allowed = { TEAM_GUN, TEAM_MOB },
		category = "Handguns",
	},
	{
		name = "CZ75",
		entity = "arccw_go_cz75",
		price = 11000,
		amount = 3,
		separate = true,
		pricesep = 4500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Handguns",
	},
	{
		name = "Five-SeveN",
		entity = "arccw_go_fiveseven",
		price = 12000,
		amount = 3,
		separate = true,
		pricesep = 5000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Handguns",
	},
	{
		name = "Tec-9",
		entity = "arccw_go_tec9",
		price = 11000,
		amount = 3,
		separate = true,
		pricesep = 4500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Handguns",
	},
	{
		name = "USP-S",
		entity = "arccw_go_usp",
		price = 9500,
		amount = 3,
		separate = true,
		pricesep = 3800,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Handguns",
	},
	{
		name = "P2000",
		entity = "arccw_go_p2000",
		price = 9000,
		amount = 4,
		separate = true,
		pricesep = 3500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Handguns",
	},
}

-- Create the Handguns shipments
for _, shipment in ipairs(handgunsShipments) do
	DarkRP.createShipment(shipment.name, {
		model = "models/props/cs_office/cardboard_box03.mdl",
		entity = shipment.entity,
		price = shipment.price * price_multiplier,
		amount = shipment.amount,
		separate = shipment.separate,
		pricesep = shipment.pricesep * price_multiplier,
		noship = shipment.noship,
		allowed = shipment.allowed,
		category = shipment.category,
	})
end

-- Define the Shotguns shipments
local shotgunsShipments = {
	{
		name = "Nova",
		entity = "arccw_go_nova",
		price = 15000,
		amount = 3,
		separate = true,
		pricesep = 5500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Shotguns",
	},
	{
		name = "MAG-7",
		entity = "arccw_go_mag7",
		price = 18000,
		amount = 3,
		separate = true,
		pricesep = 6500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Shotguns",
	},
	{
		name = "M1014",
		entity = "arccw_go_m1014",
		price = 20000,
		amount = 2,
		separate = true,
		pricesep = 7500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Shotguns",
	},
	{
		name = "870",
		entity = "arccw_go_870",
		price = 16000,
		amount = 3,
		separate = true,
		pricesep = 6000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "Shotguns",
	},
}

-- Create the Shotguns shipments
for _, shipment in ipairs(shotgunsShipments) do
	DarkRP.createShipment(shipment.name, {
		model = "models/props/cs_office/cardboard_box03.mdl",
		entity = shipment.entity,
		price = shipment.price * price_multiplier,
		amount = shipment.amount,
		separate = shipment.separate,
		pricesep = shipment.pricesep * price_multiplier,
		noship = shipment.noship,
		allowed = shipment.allowed,
		category = shipment.category,
	})
end

-- Define the SMGs shipments
local smgsShipments = {
	{
		name = "MP5",
		entity = "arccw_go_mp5",
		price = 19000,
		amount = 2,
		separate = true,
		pricesep = 7000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "SMGs",
	},
	{
		name = "MP7",
		entity = "arccw_go_mp7",
		price = 22000,
		amount = 2,
		separate = true,
		pricesep = 8000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "SMGs",
	},
	{
		name = "MP9",
		entity = "arccw_go_mp9",
		price = 20000,
		amount = 2,
		separate = true,
		pricesep = 7500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "SMGs",
	},
	{
		name = "UMP-45",
		entity = "arccw_go_ump",
		price = 18000,
		amount = 3,
		separate = true,
		pricesep = 6500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "SMGs",
	},
	{
		name = "MAC-10",
		entity = "arccw_go_mac10",
		price = 16000,
		amount = 3,
		separate = true,
		pricesep = 6000,
		noship = false,
		allowed = { TEAM_GUN },
		category = "SMGs",
	},
	{
		name = "PP-Bizon",
		entity = "arccw_go_bizon",
		price = 21000,
		amount = 2,
		separate = true,
		pricesep = 7500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "SMGs",
	},
	{
		name = "P90",
		entity = "arccw_go_p90",
		price = 18000,
		amount = 3,
		separate = true,
		pricesep = 6500,
		noship = false,
		allowed = { TEAM_GUN },
		category = "SMGs",
	},
}
-- Create the SMGs shipments
for _, shipment in ipairs(smgsShipments) do
	DarkRP.createShipment(shipment.name, {
		model = "models/props/cs_office/cardboard_box03.mdl",
		entity = shipment.entity,
		price = shipment.price * price_multiplier,
		amount = shipment.amount,
		separate = shipment.separate,
		pricesep = shipment.pricesep * price_multiplier,
		noship = shipment.noship,
		allowed = shipment.allowed,
		category = shipment.category,
	})
end

--Add missing categories:
DarkRP.createCategory({
	name = "Rifles",
	categorises = "shipments",
	startExpanded = true,
	color = Color(255, 0, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 1,
})

DarkRP.createCategory({
	name = "LMG",
	categorises = "shipments",
	startExpanded = true,
	color = Color(255, 0, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 2,
})

DarkRP.createCategory({
	name = "Marksman",
	categorises = "shipments",
	startExpanded = true,
	color = Color(255, 0, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 3,
})

DarkRP.createCategory({
	name = "Handguns",
	categorises = "shipments",
	startExpanded = true,
	color = Color(255, 0, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 4,
})

DarkRP.createCategory({
	name = "Shotguns",
	categorises = "shipments",
	startExpanded = true,
	color = Color(255, 0, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 5,
})

DarkRP.createCategory({
	name = "Snipers",
	categorises = "shipments",
	startExpanded = true,
	color = Color(255, 0, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 6,
})

DarkRP.createCategory({
	name = "SMGs",
	categorises = "shipments",
	startExpanded = true,
	color = Color(255, 0, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 7,
})

DarkRP.createCategory({
	name = "Misc",
	categorises = "shipments",
	startExpanded = true,
	color = Color(255, 0, 0, 255),
	canSee = function(ply)
		return true
	end,
	sortOrder = 1,
})

--Other category
DarkRP.createShipment("Rocket Launcher", {
	model = "models/props/cs_office/cardboard_box03.mdl",
	entity = "weapon_rpg",
	price = 6000 * price_multiplier,
	amount = 10,
	category = "Misc",
	separate = true,
	pricesep = 6000 * price_multiplier,
	noship = true,
	allowed = { TEAM_MAYOR, TEAM_CHIEF },
})

DarkRP.createShipment("SLAM", {
	model = "models/weapons/w_slam.mdl",
	entity = "weapon_slam",
	price = 500 * price_multiplier,
	amount = 1,
	separate = true,
	pricesep = 500 * price_multiplier,
	noship = true,
	allowed = { TEAM_MAYOR, TEAM_CHIEF, TEAM_TERROR },
	category = "Misc",
	-- CustomCheck
})

DarkRP.createShipment("Frag Grenade", {
	model = "models/weapons/w_eq_fraggrenade.mdl",
	entity = "weapon_frag",
	price = 500 * price_multiplier,
	amount = 1,
	separate = true,
	pricesep = 500 * price_multiplier,
	noship = true,
	allowed = { TEAM_MAYOR, TEAM_CHIEF, TEAM_TERROR },
	category = "Misc",
	-- CustomCheck
})
