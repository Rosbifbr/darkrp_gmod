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
Shipments to create:
--Rifles
mg_akilo47
mg_anovember94
mg_valpha
mg_galima
mg_falima
mg_scharlie
mg_falpha
mg_g3a3
mg_sierra552
mg_kilo433
mg_mcharlie
mg_mike4
mg_asierra12
mg_tango21

--LMG
mg_mkilo3
mg_sierrax
mg_mgolf36
mg_kilo121
mg_mgolf34
mg_pkilo
mg_slima
mg_lima86

--Marksman
mg_crossbow
mg_mike14
mg_kilo98
mg_sbeta
mg_sksierra
mg_romeo700

--Handguns
mg_357
mg_deagle
mg_p320
mg_m1911
mg_m9
mg_makarov
mg_glock

--Shotguns
mg_charlie725
mg_aalpha12
mg_romeo870
mg_oscar12
mg_dpapa12
mg_mike26

--Snipers
mg_alpha50
mg_delta
mg_hdromeo
mg_xmike109

--SMGs
mg_augolf
mg_secho
mg_victor
mg_charlie9
mg_mpapa5
mg_mpapa7
mg_papa90
mg_beta
mg_smgolf45
mg_uzulu

--]]

-- Define the shipments
local price_multiplier = 0.2

local rifleShipments = {
    {
        name = "AK-47",
        entity = "mg_akilo47",
        price = 20000,
        amount = 4,
        separate = true,
        pricesep = 7000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {   
        name = "AN-94",
        entity = "mg_anovember94",
        price = 18000,
        amount = 4,
        separate = true,
        pricesep = 6500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "Alpha",
        entity = "mg_valpha",
        price = 22000,
        amount = 3,
        separate = true,
        pricesep = 8000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "Galima",
        entity = "mg_galima",
        price = 25000,
        amount = 3,
        separate = true,
        pricesep = 9000,
        noship = false,
        allowed = {TEAM_GUN, TEAM_MOB},
        category = "Rifles",
    },
    {
        name = "FALima",
        entity = "mg_falima",
        price = 19000,
        amount = 4,
        separate = true,
        pricesep = 7000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "SCharlIe",
        entity = "mg_scharlie",
        price = 21000,
        amount = 3,
        separate = true,
        pricesep = 7500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "FAlpha",
        entity = "mg_falpha",
        price = 24000,
        amount = 3,
        separate = true,
        pricesep = 8500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "G3A3",
        entity = "mg_g3a3",
        price = 23000,
        amount = 3,
        separate = true,
        pricesep = 8200,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "Sierra 552",
        entity = "mg_sierra552",
        price = 20000,
        amount = 4,
        separate = true,
        pricesep = 7200,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "Kilo 433",
        entity = "mg_kilo433",
        price = 26000,
        amount = 2,
        separate = true,
        pricesep = 9500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "MCharlie",
        entity = "mg_mcharlie",
        price = 18000,
        amount = 4,
        separate = true,
        pricesep = 6500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "Mike 4",
        entity = "mg_mike4",
        price = 23000,
        amount = 3,
        separate = true,
        pricesep = 8200,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "ASierra 12",
        entity = "mg_asierra12",
        price = 25000,
        amount = 3,
        separate = true,
        pricesep = 9000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Rifles",
    },
    {
        name = "Tango 21",
        entity = "mg_tango21",
        price = 21000,
        amount = 4,
        separate = true,
        pricesep = 7500,
        noship = false,
        allowed = {TEAM_GUN},
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
        name = "Kilo 3",
        entity = "mg_mkilo3",
        price = 28000,
        amount = 2,
        separate = true,
        pricesep = 10000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "LMG",
    },
    {
        name = "Sierra X",
        entity = "mg_sierrax",
        price = 32000,
        amount = 2,
        separate = true,
        pricesep = 12000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "LMG",
    },
    {
        name = "Golf 36",
        entity = "mg_mgolf36",
        price = 30000,
        amount = 3,
        separate = true,
        pricesep = 11000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "LMG",
    },
    {
        name = "Kilo 121",
        entity = "mg_kilo121",
        price = 35000,
        amount = 2,
        separate = true,
        pricesep = 13000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "LMG",
    },
    {
        name = "Golf 34",
        entity = "mg_mgolf34",
        price = 33000,
        amount = 3,
        separate = true,
        pricesep = 12000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "LMG",
    },
    {
        name = "PKilo",
        entity = "mg_pkilo",
        price = 31000,
        amount = 3,
        separate = true,
        pricesep = 11000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "LMG",
    },
    {
        name = "Sierra Lima",
        entity = "mg_slima",
        price = 29000,
        amount = 4,
        separate = true,
        pricesep = 10000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "LMG",
    },
    {
        name = "Lima 86",
        entity = "mg_lima86",
        price = 34000,
        amount = 2,
        separate = true,
        pricesep = 12000,
        noship = false,
        allowed = {TEAM_GUN},
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
        name = "Crossbow",
        entity = "mg_crossbow",
        price = 18000,
        amount = 4,
        separate = true,
        pricesep = 6500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Marksman",
    },
    {
        name = "Mike 14",
        entity = "mg_mike14",
        price = 22000,
        amount = 3,
        separate = true,
        pricesep = 8000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Marksman",
    },
    {
        name = "Kilo 98",
        entity = "mg_kilo98",
        price = 25000,
        amount = 3,
        separate = true,
        pricesep = 9000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Marksman",
    },
    {
        name = "SBeta",
        entity = "mg_sbeta",
        price = 19000,
        amount = 4,
        separate = true,
        pricesep = 7000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Marksman",
    },
    {
        name = "SSierra",
        entity = "mg_sksierra",
        price = 21000,
        amount = 3,
        separate = true,
        pricesep = 7500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Marksman",
    },
    {
        name = "Romeo 700",
        entity = "mg_romeo700",
        price = 24000,
        amount = 3,
        separate = true,
        pricesep = 8500,
        noship = false,
        allowed = {TEAM_GUN},
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
        name = ".357 Magnum",
        entity = "mg_357",
        price = 8000,
        amount = 4,
        separate = true,
        pricesep = 3000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Handguns",
    },
    {
        name = "Desert Eagle",
        entity = "mg_deagle",
        price = 10000,
        amount = 3,
        separate = true,
        pricesep = 4000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Handguns",
    },
    {
        name = "P320",
        entity = "mg_p320",
        price = 12000,
        amount = 3,
        separate = true,
        pricesep = 5000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Handguns",
    },
    {
        name = "M1911",
        entity = "mg_m1911",
        price = 9000,
        amount = 4,
        separate = true,
        pricesep = 3500,
        noship = false,
        allowed = {TEAM_GUN, TEAM_MOB},
        category = "Handguns",
    },
    {
        name = "M9",
        entity = "mg_m9",
        price = 11000,
        amount = 3,
        separate = true,
        pricesep = 4500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Handguns",
    },
    {
        name = "Makarov",
        entity = "mg_makarov",
        price = 7000,
        amount = 4,
        separate = true,
        pricesep = 2500,
        noship = false,
        allowed = {TEAM_GUN, TEAM_MOB},
        category = "Handguns",
    },
    {
        name = "Glock",
        entity = "mg_glock",
        price = 9500,
        amount = 3,
        separate = true,
        pricesep = 3800,
        noship = false,
        allowed = {TEAM_GUN},
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
        name = "Charlie 725",
        entity = "mg_charlie725",
        price = 15000,
        amount = 3,
        separate = true,
        pricesep = 5500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Shotguns",
    },
    {
        name = "Alpha 12",
        entity = "mg_aalpha12",
        price = 18000,
        amount = 3,
        separate = true,
        pricesep = 6500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Shotguns",
    },
    {
        name = "Romeo 870",
        entity = "mg_romeo870",
        price = 20000,
        amount = 2,
        separate = true,
        pricesep = 7500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Shotguns",
    },
    {
        name = "Oscar 12",
        entity = "mg_oscar12",
        price = 16000,
        amount = 3,
        separate = true,
        pricesep = 6000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Shotguns",
    },
    {
        name = "Delta Papa 12",
        entity = "mg_dpapa12",
        price = 19000,
        amount = 2,
        separate = true,
        pricesep = 7000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Shotguns",
    },
    {
        name = "Mike 26",
        entity = "mg_mike26",
        price = 22000,
        amount = 2,
        separate = true,
        pricesep = 8000,
        noship = false,
        allowed = {TEAM_GUN},
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

-- Define the Snipers shipments
local snipersShipments = {
    {
        name = "Alpha 50",
        entity = "mg_alpha50",
        price = 30000,
        amount = 2,
        separate = true,
        pricesep = 11000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Snipers",
    },
    {
        name = "Delta",
        entity = "mg_delta",
        price = 33000,
        amount = 2,
        separate = true,
        pricesep = 12000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Snipers",
    },
    {
        name = "Hotel Delta Romeo",
        entity = "mg_hdromeo",
        price = 36000,
        amount = 1,
        separate = true,
        pricesep = 13000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Snipers",
    },
    {
        name = "Xray Mike 109",
        entity = "mg_xmike109",
        price = 32000,
        amount = 2,
        separate = true,
        pricesep = 11500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "Snipers",
    },
}

-- Create the Snipers shipments
for _, shipment in ipairs(snipersShipments) do
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
        name = "AUGolf",
        entity = "mg_augolf",
        price = 15000,
        amount = 3,
        separate = true,
        pricesep = 5500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "SMGs",
    },
    {
        name = "Echo",
        entity = "mg_secho",
        price = 18000,
        amount = 3,
        separate = true,
        pricesep = 6500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "SMGs",
    },
    {
        name = "Victor",
        entity = "mg_victor",
        price = 20000,
        amount = 2,
        separate = true,
        pricesep = 7500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "SMGs",
    },
    {
        name = "Charlie 9",
        entity = "mg_charlie9",
        price = 16000,
        amount = 3,
        separate = true,
        pricesep = 6000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "SMGs",
    },
    {
        name = "MPapa 5",
        entity = "mg_mpapa5",
        price = 19000,
        amount = 2,
        separate = true,
        pricesep = 7000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "SMGs",
    },
    {
        name = "MPapa 7",
        entity = "mg_mpapa7",
        price = 22000,
        amount = 2,
        separate = true,
        pricesep = 8000,
        noship = false,
        allowed = {TEAM_GUN},
        category = "SMGs",
    },
    {
        name = "Papa 90",
        entity = "mg_papa90",
        price = 18000,
        amount = 3,
        separate = true,
        pricesep = 6500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "SMGs",
    },
    {
        name = "Beta",
        entity = "mg_beta",
        price = 21000,
        amount = 2,
        separate = true,
        pricesep = 7500,
        noship = false,
        allowed = {TEAM_GUN},
        category = "SMGs",
    },
    {
        name = "SMGolf 45",
        entity = "mg_smgolf45",
        price = 17000,
        amount = 3,
        separate = true,
        pricesep = 6200,
        noship = false,
        allowed = {TEAM_GUN},
        category = "SMGs",
    },
    {
        name = "UZulu",
        entity = "mg_uzulu",
        price = 20000,
        amount = 2,
        separate = true,
        pricesep = 7300,
        noship = false,
        allowed = {TEAM_GUN, TEAM_MOB},
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
DarkRP.createCategory{
    name = "Rifles",
    categorises = "shipments",
    startExpanded = true,
    color = Color(255, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 1,
}

DarkRP.createCategory{
    name = "LMG",
    categorises = "shipments",
    startExpanded = true,
    color = Color(255, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 2,
}

DarkRP.createCategory{
    name = "Marksman",
    categorises = "shipments",
    startExpanded = true,
    color = Color(255, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 3,
}

DarkRP.createCategory{
    name = "Handguns",
    categorises = "shipments",
    startExpanded = true,
    color = Color(255, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 4,
}

DarkRP.createCategory{
    name = "Shotguns",
    categorises = "shipments",
    startExpanded = true,
    color = Color(255, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 5,
}

DarkRP.createCategory{
    name = "Snipers",
    categorises = "shipments",
    startExpanded = true,
    color = Color(255, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 6,
}

DarkRP.createCategory{
    name = "SMGs",
    categorises = "shipments",
    startExpanded = true,
    color = Color(255, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 7,
}

DarkRP.createCategory{
    name = "Misc",
    categorises = "shipments",
    startExpanded = true,
    color = Color(255, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 1,
}

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
    allowed = {TEAM_MAYOR, TEAM_CHIEF}
})

DarkRP.createShipment("SLAM", {
    model = "models/weapons/w_slam.mdl",
    entity = "weapon_slam",
    price = 500 * price_multiplier,
    amount = 1,
    separate = true,
    pricesep = 500 * price_multiplier,
    noship = true,
    allowed = {TEAM_MAYOR, TEAM_CHIEF, TEAM_TERROR},
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
    allowed = {TEAM_MAYOR, TEAM_CHIEF, TEAM_TERROR},
    category = "Misc",
    -- CustomCheck
})
