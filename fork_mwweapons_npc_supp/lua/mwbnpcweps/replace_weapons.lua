AddCSLuaFile()

CreateConVar("mwbnpcweapons_replace_weapons", "0", bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))

if !SERVER then return end



if !MWBNPC_REPLACE_TABLE then
    -- Gets populated eventually
    MWBNPC_REPLACE_TABLE = {
        ["weapon_pistol"] = {},
        ["weapon_357"] = {},
        ["weapon_ar2"] = {},
        ["weapon_crossbow"] = {},
        ["weapon_shotgun"] = {},
        ["weapon_smg1"] = {},
    }
end

-- Replace these HL2 weapons with MW weapons using the respective ammotype
local MWBAmmoToHL2WepClass = {
    ["Ar2"] = "weapon_ar2",
    ["357"] = "weapon_ar2", -- Marksman rifles use 357, therefore replace weapon_ar2 with MW weapons that use 357 ammo. The revolver and the deagle won't be included since they are reserved for the "weapon_pistol" and "weapon_357" category.
    ["Pistol"] = "weapon_pistol",
    ["SMG1"] = "weapon_smg1",
    ["Buckshot"] = "weapon_shotgun",
}



local function GiveNPCReplacementGun( NPC )
    local wep = NPC:GetActiveWeapon()
    if IsValid(wep) then
        local myReplacements = MWBNPC_REPLACE_TABLE[wep:GetClass()]
        if myReplacements then
            local _, replacement = table.Random(myReplacements)
            if replacement then
                NPC:Give( replacement )
            end
        end
    end
end


local function ReplaceHL2Gun( hl2Gun )
    local myReplacements = MWBNPC_REPLACE_TABLE[hl2Gun:GetClass()]
    local _, newWepClass = table.Random(myReplacements)

    local newWep = ents.Create(newWepClass)
    newWep:SetPos(hl2Gun:GetPos())
    newWep:SetAngles(hl2Gun:GetAngles())
    newWep:Spawn()
    undo.ReplaceEntity(hl2Gun, newWep)
    cleanup.ReplaceEntity(hl2Gun, newWep)

    hl2Gun:Remove()
end


local function ReservedReplacement( Class )
    if Class == "mg_crossbow" then
        MWBNPC_REPLACE_TABLE["weapon_ar2"][Class] = true
        MWBNPC_REPLACE_TABLE["weapon_crossbow"][Class] = true
        return true
    end

    if Class == "mg_357" or Class == "mg_deagle" then
        MWBNPC_REPLACE_TABLE["weapon_pistol"][Class] = true
        MWBNPC_REPLACE_TABLE["weapon_357"][Class] = true
        return true
    end
end


local function PreRegisterSWEP( SWEP, Class )
    if string.StartWith(Class, "mg_") &&
    Class != "mg_dblmg" then -- No minigun, it doesn't really work anyway
        if SWEP.Primary.Ammo then
            if ReservedReplacement( Class ) then return end

            local hl2WepClass = MWBAmmoToHL2WepClass[SWEP.Primary.Ammo]
            MWBNPC_REPLACE_TABLE[hl2WepClass][Class] = true
        end
    end
end


local function OnEntityCreated( ent )
    if !GetConVar("mwbnpcweapons_replace_weapons"):GetBool() then return end

    -- Replace NPC HL2 guns:
    if ent:IsNPC() then
        timer.Simple(0, function()
            if !IsValid(ent) then return end
            GiveNPCReplacementGun( ent )
        end)
    end

    -- Replace HL2 gun if it doesn't have an owner:
    -- if ent:IsWeapon() && replaceWeapons[ent:GetClass()] then
    --     timer.Simple(0, function()
    --         if !IsValid(ent) or IsValid(ent:GetOwner()) then return end
    --         ReplaceHL2Gun( ent )
    --     end)
    -- end
end


hook.Add("OnEntityCreated", "OnEntityCreated_MWBNPCWeapons_ReplaceWeapons", OnEntityCreated)
hook.Add("PreRegisterSWEP", "PreRegisterSWEP_MWBNPCWeapons_ReplaceWeapons", PreRegisterSWEP)