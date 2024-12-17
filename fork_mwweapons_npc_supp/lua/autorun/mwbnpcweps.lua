-- Include files:
include("mwbnpcweps/add_compatibility.lua")
include("mwbnpcweps/random_attachments.lua")
include("mwbnpcweps/replace_weapons.lua")



-- Add modern warfare weapons to npc weapons list:
local function PreRegisterSWEP( SWEP, Class )
    if string.StartWith(Class, "mg_") then
        list.Add( "NPCUsableWeapons", { class = Class, title = "MW "..SWEP.PrintName } )
    end
end


-- Set mgbase_precacheatts to 1 to reduce stuttering:
local function PrecacheAttsCvar()
    if ConVarExists("mgbase_precacheatts") && !GetConVar("mgbase_precacheatts"):GetBool() then
        RunConsoleCommand("mgbase_precacheatts", "1")
    end
end


-- VJ Base compatibility:
local function GetVJSWEPMethods()
    if SERVER then
        local VJSWEP = ents.Create("weapon_vj_base")
        VJSWEP:Spawn()
        MWBNPC_VJ_ABLETOSHOOT = VJSWEP.NPCAbleToShoot
        VJSWEP:Remove()
    end
end


local function InitPostEntity()
    PrecacheAttsCvar()
    MWBNPC_VJ_INSTALLED = file.Exists("autorun/vj_base_autorun.lua","LUA")
    if MWBNPC_VJ_INSTALLED then GetVJSWEPMethods() end
end


hook.Add("InitPostEntity", "InitPostEntity_MWBNPCWeapons", InitPostEntity)
hook.Add("PreRegisterSWEP", "PreRegisterSWEP_MWBNPCWeapons", PreRegisterSWEP)