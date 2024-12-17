AddCSLuaFile()

CreateConVar("mwbnpcweapons_damage_scale", "1", bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))

local NPC_SpreadMax = 1.5
local NPC_SpreadMin = 0.25

local ENT = FindMetaTable("Entity")
local DefaultEyeAngleFunc = ENT.EyeAngles



-- Extension to EyeAngles method that corrects NPCs aim with MWB weapons:
function ENT:EyeAngles()
    if self && self:IsNPC() then
        local wep = self:GetActiveWeapon()
        if IsValid(wep) && string.StartWith(wep:GetClass(), "mg_") then
            local enemy = self:GetEnemy()
            if IsValid(enemy) then
                return ( enemy:WorldSpaceCenter() - self:GetShootPos() ):Angle()
            end
        end
    end

    return DefaultEyeAngleFunc(self)
end


-- We want NPCs to do the same damage as players
local function ScaleNPCWeaponDamage( _, dmginfo )
    local attckr = dmginfo:GetAttacker()
    local infl = attckr.GetActiveWeapon && attckr:GetActiveWeapon()
    
    if IsValid(attckr) && IsValid(infl) then
        if string.StartWith(infl:GetClass(), "mg_") && attckr:IsNPC() then
            -- "Unscale" damage so that the pvp multiplier doesn't have an effect on the NPCs
            local pvpDamageScale = GetConVar("mgbase_sv_pvpdamage"):GetFloat()
            local unscaledDamage = pvpDamageScale == 0 && 0 or 1/pvpDamageScale
            dmginfo:ScaleDamage(unscaledDamage)
            dmginfo:ScaleDamage(GetConVar("mwbnpcweapons_damage_scale"):GetFloat()) -- New damage scale
        end
    end
end


local function OnNPCKilled( NPC )
    if !NPC:IsNPC() then return end
    -- Fix weapons mwb weapons dropped by npcs not giving ammo:
    local SWEP = NPC:GetActiveWeapon()
    if IsValid(SWEP) && string.StartWith(SWEP:GetClass(), "mg_") then
        function SWEP:EquipAmmo( ply )
            ply:GiveAmmo(self:GetMaxClip1(), self.Primary.Ammo)
        end
    end
end


local function MWB_Add_VJSNPCCompatability( SWEP )
    SWEP.IsVJBaseWeapon = true

    if SERVER then
        SWEP.NPC_BeforeFireSound = false
        SWEP.NPC_BeforeFireSoundLevel = 0
        SWEP.NPC_BeforeFireSoundPitch = {a=0, b=0}
        SWEP.NPC_NextPrimaryFire = false -- Disable default vj shooting code
        SWEP.NPC_Reload = function() end
        SWEP.NPCAbleToShoot = MWBNPC_VJ_ABLETOSHOOT
        
        SWEP.MWB_VJSNPC_NextFire = CurTime()

        function SWEP:MWB_VJSNPC_Think()
            if self:GetOwner().IsVJBaseSNPC then
                if self:NPCAbleToShoot() && self.MWB_VJSNPC_NextFire < CurTime() then
                    local _, _, nextFire = self:GetNPCBurstSettings()
                    self:PrimaryAttack()
                    self.MWB_VJSNPC_NextFire = CurTime() + nextFire
                end
            end
        end

        hook.Add("Think", SWEP, SWEP.MWB_VJSNPC_Think)
    end
end


local function MWB_Add_NPCCompatability( SWEP )
    if MWBNPC_VJ_INSTALLED then MWB_Add_VJSNPCCompatability( SWEP ) end

    if SERVER then
        local SetShouldHoldType = SWEP.SetShouldHoldType
        local CanAttack = SWEP.CanAttack
        local GetCone = SWEP.GetCone
        local PrimaryAttack = SWEP.PrimaryAttack
        local PlayerGesture = SWEP.PlayerGesture -- Used in multiplayer
        --self:SetHoldType(self.HoldTypes[self.HoldType].Idle.Standing)

        -- NPCs can always attack:
        function SWEP:CanAttack( ... )
            if self:GetOwner():IsNPC() then return true end
            return CanAttack(self, ...)
        end

        -- Spread based on proficiency:
        function SWEP:GetCone( ... )
            local own = self:GetOwner()
            if own:IsNPC() then
                if own.IsVJBaseSNPC then
                    -- VJ weapon spread:
                    return own.WeaponSpread
                else
                    -- Spread based on proficiency:
                    return Lerp( (own:GetCurrentWeaponProficiency()+1)/5, NPC_SpreadMax, NPC_SpreadMin )
                end
            end
            return GetCone(self, ...)
        end

        -- Primary attack:
        function SWEP:PrimaryAttack( ... )
            local own = self:GetOwner()
            if own:IsNPC() then
                local defaultNetFunc = game.SinglePlayer() && net.Send or net.SendOmit

                -- Temporarily add these methods to the NPC:
                own.ViewPunch = function() end
                own.SendLua = function() end
                own.GetViewPunchAngles = function() return Angle(0,0,0) end
                own.GetEyeTraceNoCursor = function() -- This one is used by projectile weapons:
                    local trStart = own:GetShootPos()
                    local trEnd = trStart + own:GetAimVector()
                    return util.TraceLine({start=trStart, endpos=trEnd, mask=MASK_BLOCKLOS_AND_NPCS})
                end 

                -- net function has to be changed so that it doesn't try to send messages to NPCs:
                local newNetFunc = function( ent, ... ) 
                    if ent and ent.IsPlayer and ent:IsPlayer() then
                        return defaultNetFunc(ent, ...)
                    else
                        return NULL
                    end
                end
                if game.SinglePlayer() then
                    net.Send = newNetFunc
                else
                    net.SendOmit = newNetFunc
                end

                
                local triggerBefore = self.Trigger
                self.Trigger = nil

                PrimaryAttack(self, ...)
                
                self:SetCurrentTask(0)
                self.Trigger = triggerBefore


                -- Sound won't normally emit in singleplayer:
                if game.SinglePlayer() then self:EmitSound(self.Primary.Sound) end


                -- Remove methods that the NPC shouldn't have:
                own.ViewPunch = nil
                -- own.SendLua = nil
                own.GetViewPunchAngles = nil
                own.GetEyeTraceNoCursor = nil

                if game.SinglePlayer() then
                    net.Send = defaultNetFunc
                else
                    net.SendOmit = defaultNetFunc
                end
            else
                PrimaryAttack(self, ...)
            end
        end

        -- Error fix in multiplayer:
        function SWEP:PlayerGesture( ... )
            if self:GetOwner():IsNPC() then return end
            PlayerGesture(self, ...)
        end

        -- Burst settings:
        function SWEP:GetNPCBurstSettings()
            local firemode = self.Firemodes[self:GetFiremode()].Name
            if firemode == "Full Auto" or firemode == "Automatic" then
                return 1, 15, (60/self.Primary.RPM)
            elseif firemode == "Pump-Action" or firemode == "Bolt Action" or firemode == "Lever-Action" then
                return 1, 1, math.Rand(0.8, 1.2)
            else -- Most likely semi auto:
                return 1, 1, math.Rand(0.1, 0.4)
            end
        end

        -- Enable NPCs picking up MWB weapons:
        function SWEP:CanBePickedUpByNPCs()
            return true
        end
    end
end


local function AddNPCExtensions( NPC )
    -- GetAmmoCount for NPCs
    NPC.GetAmmoCount = function( self )
        local wep = self:GetActiveWeapon()
        return IsValid(wep) && wep:Clip1() or 0
    end

    -- Hopefully these don't break anything:
    NPC.SetAmmo = function() end
    NPC.Crouching = function() return false end
    NPC.KeyDown = function() return false end
    NPC.GetPlayerColor = function() return Color(255,255,255) end
    NPC.SetEyeAngles = function() end
    NPC.GetHands = function() return NULL end
end


local function OnEntityCreated( ent )
    -- MWB Weapon:
    if ent:IsWeapon() && string.StartWith(ent:GetClass(), "mg_") then
        timer.Simple(0, function()
            if !IsValid(ent) then return end
            MWB_Add_NPCCompatability(ent)
        end)
    end

    -- NPC:
    if ent:IsNPC() then
        AddNPCExtensions(ent)
    end
end


hook.Add("OnEntityCreated", "OnEntityCreated_MWBNPCWeapons_AddCompatibility", OnEntityCreated)
hook.Add("EntityTakeDamage", "EntityTakeDamage_MWBNPCWeapons_NPCDamageScale", ScaleNPCWeaponDamage)
hook.Add("OnNPCKilled", "OnNPCKilled_MWBNPCWeapons", OnNPCKilled)
