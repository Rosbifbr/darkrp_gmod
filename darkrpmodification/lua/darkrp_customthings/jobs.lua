--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]



--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MOB)
--NORMAL
TEAM_CITIZEN = DarkRP.createJob("Civilian", {
    color = Color(0, 255, 0, 255),
    model = {
        'models/smalls_civilians/pack1/hoodie_male_09_pm.mdl', 
        'models/smalls_civilians/pack1/hoodie_male_01_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_02_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_03_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_04_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_05_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_07_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_09_pm.mdl',
        'models/smalls_civilians/pack1/puffer_male_01_pm.mdl',
        'models/smalls_civilians/pack1/puffer_male_02_pm.mdl',
        'models/smalls_civilians/pack1/puffer_male_03_pm.mdl',
        'models/smalls_civilians/pack1/puffer_male_04_pm.mdl',
        'models/smalls_civilians/pack1/puffer_male_05_pm.mdl',
        'models/smalls_civilians/pack1/puffer_male_07_pm.mdl',
        'models/smalls_civilians/pack1/puffer_male_09_pm.mdl',
        'models/smalls_civilians/pack1/zipper_female_01_pm.mdl',
        'models/smalls_civilians/pack1/zipper_female_02_pm.mdl',
        'models/smalls_civilians/pack1/zipper_female_03_pm.mdl',
        'models/smalls_civilians/pack1/zipper_female_04_pm.mdl',
        'models/smalls_civilians/pack1/zipper_female_06_pm.mdl',
        'models/smalls_civilians/pack1/zipper_female_07_pm.mdl',
     },
    description = [[You are simply a regular nigga]],
    weapons = {},
    command = "citizen",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
})

TEAM_POLICE = DarkRP.createJob("Police", {
    color = Color(25, 25, 170, 255),
    model = {
        'models/sentry/hkpd/sentryhkpdmale5pm.mdl',
        'models/sentry/hkpd/sentryhkpdmale7pm.mdl',
        --'models/sentry/hkpd/sentryhkpdptumale5pm.mdl',
        --'models/sentry/hkpd/sentryhkpdptumale7pm.mdl',
    },
    description = [[The protector of every citizen that lives in the city.
        You have the power to arrest criminals and protect innocents.
        Hit a player with your arrest baton to put them in jail.
        Bash a player with a stunstick and they may learn to obey the law.
        The Battering Ram can break down the door of a criminal, with a warrant for their arrest.
        The Battering Ram can also unfreeze frozen props (if enabled).
        Type /wanted <name> to alert the public to the presence of a criminal.]],
    weapons = {"arrest_stick", "unarrest_stick", "mg_p320", "mg_sierra552", "stunstick", "door_ram", "weaponchecker", "keypad_cracker"},
    command = "cp",
    max = 4,
    salary = GAMEMODE.Config.normalsalary * 1.45,
    admin = 0,
    vote = true,
    hasLicense = true,
    ammo = {
        ["pistol"] = 60,
        ["smg1"] = 80,
    },
    category = "Civil Protection",
})

TEAM_CHIEF = DarkRP.createJob("Sheriff", {
    color = Color(20, 20, 255, 255),
    model = {
        'models/sentry/hkpd/hkpdptupm.mdl',
    },
    description = [[The Chief is the leader of the Civil Protection unit.
        Coordinate the police force to enforce law in the city.
        Hit a player with arrest baton to put them in jail.
        Bash a player with a stunstick and they may learn to obey the law.
        The Battering Ram can break down the door of a criminal, with a warrant for their arrest.
        Type /wanted <name> to alert the public to the presence of a criminal.
        Type /jailpos to set the Jail Position]],
    weapons = {"arrest_stick", "unarrest_stick", "mg_p320", "mg_sierra552", "stunstick", "door_ram", "weaponchecker", "keypad_cracker"}, --TODO:
    command = "chief",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 1.67,
    admin = 0,
    vote = false,
    hasLicense = true,
    chief = true,
    NeedToChangeFrom = TEAM_POLICE,
    ammo = {
        ["pistol"] = 60,
        ["ar2"] = 90,
    },
    category = "Civil Protection",
})

--CRIME

-- TEAM_DRUG = DarkRP.createJob("Drug Dealer", {
-- 	color = Color(80, 45, 0, 255),
-- 	model = {
--         'models/smalls_civilians/pack1/hoodie_male_01_pm.mdl',
--         'models/smalls_civilians/pack1/hoodie_male_02_pm.mdl',
--         'models/smalls_civilians/pack1/hoodie_male_03_pm.mdl',
--         'models/smalls_civilians/pack1/hoodie_male_04_pm.mdl',
--         'models/smalls_civilians/pack1/hoodie_male_05_pm.mdl',
--         'models/smalls_civilians/pack1/hoodie_male_07_pm.mdl',
--         'models/smalls_civilians/pack1/hoodie_male_09_pm.mdl',
--     },
-- 	description = [[You're a drug dealer]],
-- 	weapons = {},
-- 	command = "drug",
-- 	max = 3,
-- 	salary = 15,
-- 	admin = 0,
-- 	vote = false,
-- 	hasLicense = false
-- })

TEAM_TERROR = DarkRP.createJob("Terrorist", {
    color = Color(75, 75, 75, 255),
    model = {
        'models/smalls_civilians/pack1/hoodie_male_01_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_02_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_03_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_04_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_05_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_07_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_09_pm.mdl',
    },
    description = [[You are a muslim terrorist. Do whatever possible to cause mayhem and havoc to fuck your 72 virgins. RDM is allowed in this role, but do not overdo.]],
--    weapons = {"mg_m1911"},
--    ammo = {
--         ["pistol"] = 60,
--    },
    command = "terrorist",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Gangsters",
})

TEAM_GANG = DarkRP.createJob("Gangster", {
    color = Color(75, 75, 75, 255),
    model = {
        'models/smalls_civilians/pack1/hoodie_male_01_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_02_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_03_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_04_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_05_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_07_pm.mdl',
        'models/smalls_civilians/pack1/hoodie_male_09_pm.mdl',
    },
    description = [[The lowest person of crime.
        A gangster generally works for the Mobboss who runs the crime family.
        The Mob boss sets your agenda and you follow it or you might be punished.]],
    -- weapons = {"mg_m1911"},
    -- ammo = {
    --     ["pistol"] = 60,
    -- },
    command = "gangster",
    max = 3,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Gangsters",
})

TEAM_MOB = DarkRP.createJob("Mob boss", {
    color = Color(25, 25, 25, 255),
    model = "models/player/gman_high.mdl",
    description = [[The Mob boss is the boss of the criminals in the city.
        With their power they coordinate the gangsters and form an efficient crime organization.
        They have the ability to break into houses by using a lockpick.
        The Mob boss posesses the ability to unarrest you.]],
    weapons = {"lockpick", "unarrest_stick", "mg_357"},
    ammo = {
        ["357"] = 24,
    },
    command = "mobboss",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 1.34,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Gangsters",
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN

