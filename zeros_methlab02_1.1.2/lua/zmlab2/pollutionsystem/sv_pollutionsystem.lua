if CLIENT then return end

zmlab2 = zmlab2 or {}
zmlab2.PollutionSystem = zmlab2.PollutionSystem or {}
zmlab2.PollutionSystem.PolutedAreas = zmlab2.PollutionSystem.PolutedAreas or {}

/*

    The PollutionSystem makes certain areas of the map dangurous
        Polluted Areas have damage the player if he goes closer
        On client it will display a poison cloud
        The size of the cloud and damage amount depends on the pollution amount
        Pollution disolves/reduces over time
*/

function zmlab2.PollutionSystem.AddProducer(ent,amount,rep)
    // Stop any pollution for now
    //if true then return end

    // Creates pollution while heating
    local timerid01 = "zmlab2_pollution_producer_" .. ent:EntIndex()
    zmlab2.Timer.Remove(timerid01)
    zmlab2.Timer.Create(timerid01,1,rep,function()

        if not IsValid(ent) then
            zmlab2.Timer.Remove(timerid01)
            return
        end

        zmlab2.Ventilation.Check(ent:GetPos(),amount)
    end)
end

util.AddNetworkString("zmlab2_PollutionSystem_AddPollution")
function zmlab2.PollutionSystem.AddPollution(pos,i_amount)

    local snapedPos = zmlab2.PollutionSystem.GetPosition(pos)
    local amount = i_amount

    // Search for the neareast position if available
    local id = zmlab2.PollutionSystem.FindNearest(snapedPos,50)
    if id then
        zmlab2.PollutionSystem.PolutedAreas[id].amount = zmlab2.PollutionSystem.PolutedAreas[id].amount + amount
    else
        id = table.insert(zmlab2.PollutionSystem.PolutedAreas, {
            pos = snapedPos,
            amount = amount
        })
    end

    //zmlab2.Debug("zmlab2.PollutionSystem.AddPollution[" .. tostring(id) .. "][" .. zmlab2.PollutionSystem.PolutedAreas[id].amount .. "]")

    net.Start("zmlab2_PollutionSystem_AddPollution")
    net.WriteVector(snapedPos)
    net.WriteUInt(amount,16)
    net.Broadcast()

    zmlab2.PollutionSystem.TimerCheck()
end

util.AddNetworkString("zmlab2_PollutionSystem_RemovePollution")
function zmlab2.PollutionSystem.RemovePollution(pos,amount)

    local RemoveAmount

    // Search for the neareast pollution that can be moved
    local id = zmlab2.PollutionSystem.FindNearest(pos,zmlab2.config.Ventilation.Radius)
    if id then
        RemoveAmount = math.Clamp(amount,0,zmlab2.PollutionSystem.PolutedAreas[id].amount)
        zmlab2.PollutionSystem.PolutedAreas[id].amount = math.Clamp(zmlab2.PollutionSystem.PolutedAreas[id].amount - RemoveAmount,0,99999999)

        zmlab2.Debug("zmlab2.PollutionSystem.RemovePollution[" .. tostring(id) .. "][" .. zmlab2.PollutionSystem.PolutedAreas[id].amount .. "]")

        if zmlab2.PollutionSystem.PolutedAreas[id].amount <= 0 then
            zmlab2.PollutionSystem.PolutedAreas[id] = nil
        end
    else
        // Could not find any pollution near this location
        return
    end

    net.Start("zmlab2_PollutionSystem_RemovePollution")
    net.WriteVector(pos)
    net.WriteUInt(RemoveAmount,16)
    net.Broadcast()

    return RemoveAmount
end

function zmlab2.PollutionSystem.TimerCheck()
    local timerid = "zmlab2_PollutionSystem_timer"
    if timer.Exists(timerid) == true then return end
    zmlab2.Timer.Remove(timerid)

    zmlab2.Timer.Create(timerid,1,0,function()
        for area_id,pollution_data in pairs(zmlab2.PollutionSystem.PolutedAreas) do

            if zmlab2.PollutionSystem.PolutedAreas == nil or #zmlab2.PollutionSystem.PolutedAreas <= 0 then
                zmlab2.Timer.Remove(timerid)
                break
            end

            local count = math.Clamp(math.Round(pollution_data.amount / 10),1,10)

            local rad = 30 * count
            local dist = zmlab2.PollutionSystem.GetSize() + rad
            //debugoverlay.Sphere(pollution_data.pos,dist,1,Color( 255, 125, 0 ,50),true)

            for k,v in pairs(zmlab2.Player.List) do
                if not IsValid(v) then continue end
                if not v:Alive() then continue end

                if zmlab2.util.InDistance(pollution_data.pos, v:GetPos(), dist) and zmlab2.config.PollutionSystem.ImmunityCheck(v) ~= true then

                    if zmlab2.config.PollutionSystem.UseTraces == true then
                        local c_trace = zmlab2.util.TraceLine({
                            start = pollution_data.pos + Vector(0,0,50),
                            endpos = v:GetPos() + Vector(0,0,10),
                            mask = MASK_SOLID_BRUSHONLY,
                        }, "PollutionSystem")

                        if c_trace and c_trace.Fraction >= 0.9 then
                            zmlab2.PollutionSystem.DamagePlayer(v,pollution_data)
                        end
                    else
                        zmlab2.PollutionSystem.DamagePlayer(v,pollution_data)
                    end
                end
            end

            pollution_data.amount = math.Clamp(pollution_data.amount - zmlab2.config.PollutionSystem.EvaporationAmount,0,9999999)

            if pollution_data.amount <= 0 then zmlab2.PollutionSystem.PolutedAreas[area_id] = nil end
        end
    end)
end

function zmlab2.PollutionSystem.DamagePlayer(ply,pollution_data)
    local dmg = math.Clamp(math.Round(pollution_data.amount / 10), zmlab2.config.PollutionSystem.Damage.min, zmlab2.config.PollutionSystem.Damage.max)

    local Attacker = Entity(0)

    // Damage player
    local d = DamageInfo()
    d:SetDamage(dmg)
    d:SetAttacker(Attacker)
    d:SetInflictor(Attacker)
    d:SetDamageType(DMG_NERVEGAS)
    ply:TakeDamageInfo(d)
end

concommand.Add("zmlab2_debug_PollutionSystem_AddPollution", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit and tr.HitPos then
            zmlab2.PollutionSystem.AddPollution(tr.HitPos,100)
        end
    end
end)
