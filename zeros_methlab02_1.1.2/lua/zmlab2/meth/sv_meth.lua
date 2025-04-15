if CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Meth = zmlab2.Meth or {}

function zmlab2.Meth.Initialize(Meth)
    Meth:SetMaxHealth(zmlab2.config.Damageable[Meth:GetClass()])
    Meth:SetHealth(Meth:GetMaxHealth())
end

function zmlab2.Meth.OnRemove(Meth)

end

function zmlab2.Meth.OnUse(Meth,ply)
    zmlab2.Meth.Consum(Meth,ply)
end

util.AddNetworkString("zmlab2_Meth_Consum")
function zmlab2.Meth.Consum(Meth,ply)

    // If we dont allow consum mixing and the methtype of the ent doesent match with our current higheffect meth type thens stop
    if zmlab2.config.Meth.ConsumMixing == false and ply.zmlab2_MethType ~= Meth:GetMethType() then return end

    // Reduce meth amount
    Meth:SetMethAmount(Meth:GetMethAmount() - zmlab2.config.Meth.Amount)

    // Call custom hook
    hook.Run("zmlab2_OnMethConsum",ply,Meth:GetMethType(),Meth:GetMethQuality())

    if ply.zmlab2_LastSniff == nil or ply.zmlab2_LastSniff < CurTime() then
        ply:EmitSound("zmlab2_sniff")
        ply.zmlab2_LastSniff = CurTime() + 1
    end

    // If we had used some other drug before lets stop its effects
    if ply.zmlab2_MethType and zmlab2.config.MethTypes[ply.zmlab2_MethType] and zmlab2.config.MethTypes[ply.zmlab2_MethType].OnEffectEnd then
        zmlab2.config.MethTypes[ply.zmlab2_MethType].OnEffectEnd(ply)
    end

    // Is the last duration we had already over?
    if ply.zmlab2_MethStart and ply.zmlab2_MethDuration and CurTime() > (ply.zmlab2_MethStart + ply.zmlab2_MethDuration) then
        ply.zmlab2_MethStart = nil
        ply.zmlab2_MethDuration = nil
    end

    // If we already are on meth then check how much time has passed since we started using it and substract it from the duration
    if ply.zmlab2_MethDuration then
        local time_passed = math.Clamp(CurTime() - ply.zmlab2_MethStart,0,99999999999999999)
        ply.zmlab2_MethDuration = math.Clamp(ply.zmlab2_MethDuration - time_passed,0,zmlab2.config.Meth.MaxDuration)
    end

    // Start or increase the meth duration
    if ply.zmlab2_MethStart == nil then
        ply.zmlab2_MethDuration = zmlab2.config.Meth.Duration
    else
        // Here we clamp to make sure the effect cant be longer then zmlab2.config.Meth.MaxDuration seconds
        ply.zmlab2_MethDuration = math.Clamp(ply.zmlab2_MethDuration + zmlab2.config.Meth.Duration,0,zmlab2.config.Meth.MaxDuration)
    end

    ply.zmlab2_MethStart = CurTime()

    // Lets store the methType and quality
    ply.zmlab2_MethType = Meth:GetMethType()
    ply.zmlab2_MethQuality = Meth:GetMethQuality()

    // Start / Increase ScreenEffect
    net.Start("zmlab2_Meth_Consum")
    net.WriteUInt(math.abs(Meth:GetMethType()),16)
    net.WriteUInt(math.abs(Meth:GetMethQuality()),16)
    net.WriteUInt(math.abs(math.Round(ply.zmlab2_MethDuration)),16)
    net.Send(ply)

    // Call custom code
    local methData = zmlab2.config.MethTypes[Meth:GetMethType()]
    if methData and methData.OnConsumption then methData.OnConsumption(ply,Meth,Meth:GetMethQuality()) end

    // Remove entity if meth is used up
    if Meth:GetMethAmount() <= 0 then SafeRemoveEntity(Meth) end

    // Start effect end timer
    local timerid = "zmlab2_hightime_" .. ply:SteamID64()
    zmlab2.Timer.Remove(timerid)
    zmlab2.Timer.Create(timerid,ply.zmlab2_MethDuration,1,function()
        zmlab2.Meth.EffectEnd(ply)
        zmlab2.Timer.Remove(timerid)
    end)
end

function zmlab2.Meth.EffectEnd(ply)
    if not IsValid(ply) then return end

    // Remove timer
    zmlab2.Timer.Remove("zmlab2_hightime_" .. ply:SteamID64())

    // Call some custom code
    local methData = zmlab2.config.MethTypes[ply.zmlab2_MethType]
    if methData and methData.OnEffectEnd then methData.OnEffectEnd(ply) end

    // Reset any modificators
    ply.zmlab2_Effect_Speed = nil
    ply.zmlab2_Effect_DMG = nil

    // Clear vars
    ply.zmlab2_MethStart = nil
    ply.zmlab2_MethDuration = nil
    ply.zmlab2_MethType = nil
    ply.zmlab2_MethQuality = nil
end

// Returns a multiplicator depending on provided quality
local function GetQualityMul(quality)
    return (1 / 100) * quality
end

// Fades out the value if we are at the last 10 seconds of the effect
local function EffectFadeOut(ply,val)
    local time = math.Clamp((ply.zmlab2_MethDuration + ply.zmlab2_MethStart) - CurTime(),0,10)
    return math.Clamp((val / 10) * time,1,val)
end

zmlab2.Hook.Add("PlayerDeath", "Meth", function(victim, inflictor, attacker )
    if IsValid(victim) then zmlab2.Meth.EffectEnd(victim) end
end)

zmlab2.Hook.Add("PlayerSilentDeath", "Meth", function(ply)
    if IsValid(ply) then zmlab2.Meth.EffectEnd(ply) end
end)

zmlab2.Hook.Add( "EntityTakeDamage", "Meth", function(target, dmginf)
    if IsValid(target) and target:IsPlayer() and target:Alive() and zmlab2.Player.OnMeth(target) and target.zmlab2_Effect_DMG then
        if istable(target.zmlab2_Effect_DMG) then
            if target.zmlab2_Effect_DMG[dmginf:GetDamageType()] then

                local dmg_mul = target.zmlab2_Effect_DMG[dmginf:GetDamageType()]

                // Scale speed depending on meth quality
                dmg_mul = Lerp(GetQualityMul(target.zmlab2_MethQuality),1,dmg_mul)
                dmginf:ScaleDamage(dmg_mul)
            end
        else
            local dmg_mul = target.zmlab2_Effect_DMG

            // Scale speed depending on meth quality
            dmg_mul = Lerp(GetQualityMul(target.zmlab2_MethQuality),1,dmg_mul)
            dmginf:ScaleDamage(dmg_mul)
        end
    end
end )

zmlab2.Hook.Add( "Move", "Meth", function( ply, mv, usrcmd )
    if zmlab2.Player.OnMeth(ply) and ply.zmlab2_Effect_Speed then

        local speed_mul = ply.zmlab2_Effect_Speed

        // Scale speed depending on meth quality
        speed_mul = Lerp(GetQualityMul(ply.zmlab2_MethQuality),1,speed_mul)

        // Scale speed down if last 10 seconds occur
        speed_mul = EffectFadeOut(ply,speed_mul)

        local speed = mv:GetMaxSpeed() * speed_mul
        mv:SetMaxSpeed( speed )
        mv:SetMaxClientSpeed( speed )
    end
end )

concommand.Add("zmlab2_debug_Meth_Test", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then
        local tr = ply:GetEyeTrace()

        if tr.Hit and tr.HitPos then
            local ent = ents.Create("zmlab2_item_meth")
            if not IsValid(ent) then return end
            ent:SetPos(tr.HitPos + Vector(0, 15, 15))
            ent:SetAngles(angle_zero)
            ent:Spawn()
            ent:Activate()
            ent:SetMethType(math.random(#zmlab2.config.MethTypes))
            //ent:SetMethType(5)
            ent:SetMethAmount(zmlab2.config.Frezzer.Tray_Capacity)
            ent:SetMethQuality(100)
            //ent:SetMethQuality(math.random(1, 100))

            zmlab2.Player.SetOwner(ent, ply)
        end
    end
end)

concommand.Add("zmlab2_debug_Meth_All", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then
        local tr = ply:GetEyeTrace()

        if tr.Hit and tr.HitPos then
            local function SpawnMeth(m_type,pos,m_class,m_amount,pos_x)
                local ent = ents.Create(m_class)
                if not IsValid(ent) then return end
                ent:SetPos(tr.HitPos + Vector(pos_x, pos, 15))
                ent:SetAngles(angle_zero)
                ent:Spawn()
                ent:Activate()
                ent:SetMethType(m_type)
                ent:SetMethAmount(m_amount)
                ent:SetMethQuality(100)
                zmlab2.Player.SetOwner(ent, ply)
            end

            for k,v in pairs(zmlab2.config.MethTypes) do
                SpawnMeth(k,k * 15,"zmlab2_item_meth",zmlab2.config.Frezzer.Tray_Capacity,0)
            end

            for k,v in pairs(zmlab2.config.MethTypes) do
                SpawnMeth(k,k * 20,"zmlab2_item_crate",zmlab2.config.Crate.Capacity,100)
            end
        end
    end
end)
