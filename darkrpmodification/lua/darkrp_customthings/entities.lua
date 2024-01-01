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


[[--
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

--CARS
DarkRP.createEntity("Montreal", {
    ent = "lvs_wheeldrive_montreal",
    model = "models/props_c17/consolebox01a.mdl", --Leave default
    price = 15000,
    max = 2,
    cmd = "buymontreal",
})

DarkRP.createEntity("Audi Quattro", {
    ent = "lvs_wheeldrive_audiurquattro",
    model = "models/props_c17/consolebox01a.mdl",
    price = 20000,
    max = 2,
    cmd = "buyaudiquattro",
})

DarkRP.createEntity("BMW E34", {
    ent = "lvs_wheeldrive_e34",
    model = "models/props_c17/consolebox01a.mdl",
    price = 18000,
    max = 2,
    cmd = "buybmwe34",
})

DarkRP.createEntity("BMW E9", {
    ent = "lvs_wheeldrive_e9",
    model = "models/props_c17/consolebox01a.mdl",
    price = 22000,
    max = 2,
    cmd = "buybmwe9",
})

DarkRP.createEntity("Highwayman", {
    ent = "lvs_wheeldrive_highwayman",
    model = "models/props_c17/consolebox01a.mdl",
    price = 16000,
    max = 2,
    cmd = "buyhighwayman",
})

DarkRP.createEntity("Charger", {
    ent = "lvs_wheeldrive_charger",
    model = "models/props_c17/consolebox01a.mdl",
    price = 24000,
    max = 2,
    cmd = "buycharger",
})

DarkRP.createEntity("Ferrari 365", {
    ent = "lvs_wheeldrive_ferrari365",
    model = "models/props_c17/consolebox01a.mdl",
    price = 35000,
    max = 2,
    cmd = "buyferrari365",
})

DarkRP.createEntity("Honda City", {
    ent = "lvs_wheeldrive_city",
    model = "models/props_c17/consolebox01a.mdl",
    price = 10000,
    max = 2,
    cmd = "buycitycar",
})

DarkRP.createEntity("Acura Integra DC2", {
    ent = "lvs_wheeldrive_dc2",
    model = "models/props_c17/consolebox01a.mdl",
    price = 15000,
    max = 2,
    cmd = "buyintegradc2",
})

DarkRP.createEntity("Lada 2108", {
    ent = "lvs_wheeldrive_2108",
    model = "models/props_c17/consolebox01a.mdl",
    price = 8000,
    max = 2,
    cmd = "buylada2108",
})

DarkRP.createEntity("Mazda Miata", {
    ent = "lvs_wheeldrive_miata",
    model = "models/props_c17/consolebox01a.mdl",
    price = 14000,
    max = 2,
    cmd = "buymiata",
})

DarkRP.createEntity("Mazda RX7", {
    ent = "lvs_wheeldrive_rx7",
    model = "models/props_c17/consolebox01a.mdl",
    price = 20000,
    max = 2,
    cmd = "buyrx7",
})

DarkRP.createEntity("Mercedes W123", {
    ent = "lvs_wheeldrive_w123",
    model = "models/props_c17/consolebox01a.mdl",
    price = 12000,
    max = 2,
    cmd = "buyw123",
})

DarkRP.createEntity("MGB GT", {
    ent = "lvs_wheeldrive_mgb_gt",
    model = "models/props_c17/consolebox01a.mdl",
    price = 15000,
    max = 2,
    cmd = "buymgbgt",
})

DarkRP.createEntity("Nissan Bluebird", {
    ent = "lvs_wheeldrive_bluebird",
    model = "models/props_c17/consolebox01a.mdl",
    price = 10000,
    max = 2,
    cmd = "buynissanbluebird",
})

DarkRP.createEntity("Nissan GTR R34", {
    ent = "lvs_wheeldrive_gtr34",
    model = "models/props_c17/consolebox01a.mdl",
    price = 30000,
    max = 2,
    cmd = "buynissangtrr34",
})

DarkRP.createEntity("Peugeot 106", {
    ent = "lvs_wheeldrive_pugo106",
    model = "models/props_c17/consolebox01a.mdl",
    price = 9000,
    max = 2,
    cmd = "buypeugeot106",
})

DarkRP.createEntity("Peugeot 106 S16", {
    ent = "lvs_wheeldrive_pugo106s16",
    model = "models/props_c17/consolebox01a.mdl",
    price = 11000,
    max = 2,
    cmd = "buypeugeot106s16",
})

DarkRP.createEntity("Porsche 930 Cabriolet", {
    ent = "lvs_wheeldrive_porsche930cab",
    model = "models/props_c17/consolebox01a.mdl",
    price = 45000,
    max = 2,
    cmd = "buyporsche930cab",
})

DarkRP.createEntity("Porsche 930 Coupe", {
    ent = "lvs_wheeldrive_porsche930coup",
    model = "models/props_c17/consolebox01a.mdl",
    price = 47000,
    max = 2,
    cmd = "buyporsche930coup",
})

DarkRP.createEntity("Porsche 930 Targa", {
    ent = "lvs_wheeldrive_porsche930targa",
    model = "models/props_c17/consolebox01a.mdl",
    price = 46000,
    max = 2,
    cmd = "buyporsche930targa",
})

DarkRP.createEntity("Buick Regal", {
    ent = "lvs_wheeldrive_regal",
    model = "models/props_c17/consolebox01a.mdl",
    price = 13000,
    max = 2,
    cmd = "buybuickregal",
})

DarkRP.createEntity("Supervan", {
    ent = "lvs_wheeldrive_supervan",
    model = "models/props_c17/consolebox01a.mdl",
    price = 10000,
    max = 2,
    cmd = "buysupervan",
})

DarkRP.createEntity("Toyota Supra", {
    ent = "lvs_wheeldrive_supra",
    model = "models/props_c17/consolebox01a.mdl",
    price = 40000,
    max = 2,
    cmd = "buytoyotasupra",
})
