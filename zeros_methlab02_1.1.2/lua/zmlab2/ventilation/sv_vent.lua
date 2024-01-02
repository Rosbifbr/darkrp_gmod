if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Ventilation = zmlab2.Ventilation or {}
zmlab2.Ventilation.List = zmlab2.Ventilation.List or {}

/*

    The Ventilation system moves pollution arround the map

*/

function zmlab2.Ventilation.Initialize(Ventilation)
    zmlab2.EntityTracker.Add(Ventilation)

    if zmlab2.config.Equipment.PlayerCollide == false then
        Ventilation:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end

    local output = ents.Create("prop_physics")
    if not IsValid(output) then return end
    output:SetPos(Ventilation:LocalToWorld(Vector(0,-50,50)))
    output:SetModel("models/zerochain/props_methlab/zmlab2_ventilation_head.mdl")
    output:Spawn()
    output:Activate()
    output:PhysicsInit(SOLID_VPHYSICS)
    output:SetSolid(SOLID_VPHYSICS)
    output:SetMoveType(MOVETYPE_VPHYSICS)
    local phys = output:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(true)
    end
    //output:SetNoDraw(true)

    constraint.Rope( Ventilation,output, 0, 0, vector_origin, vector_origin, zmlab2.config.Ventilation.Hose_length, 0, 0, 0, nil, false )

    Ventilation:SetOutput(output)

    table.insert(zmlab2.Ventilation.List,Ventilation)


    Ventilation:SetMaxHealth( zmlab2.config.Damageable[Ventilation:GetClass()] )
    Ventilation:SetHealth(Ventilation:GetMaxHealth())
end

function zmlab2.Ventilation.OnRemove(Ventilation)
    if IsValid(Ventilation:GetOutput()) then SafeRemoveEntity(Ventilation:GetOutput()) end
end

function zmlab2.Ventilation.OnUse(Ventilation, ply)

    if zmlab2.Player.CanInteract(ply, Ventilation) == false then return end

    // Toggel Venting
    if Ventilation:OnStart(ply) then
        zmlab2.Sound.EmitFromEntity("button_change", Ventilation)
        zmlab2.Ventilation.Toggle(Ventilation, ply)
    end
end

function zmlab2.Ventilation.Toggle(Ventilation)

    if Ventilation:GetProcessState() == 0 then
        Ventilation:SetProcessState(1)
    else
        Ventilation:SetProcessState(0)
    end

    local timerid = "zmlab2_Ventilation_timer_" .. Ventilation:EntIndex()
    zmlab2.Timer.Remove(timerid)

    if Ventilation:GetIsVenting() == true then
        //Ventilation:EmitSound("zmlab2_vent_on")
        zmlab2.Timer.Create(timerid,1,0,function()
            if not IsValid(Ventilation) then
                zmlab2.Timer.Remove(timerid)
                return
            end

            if not IsValid(Ventilation:GetOutput()) then
                zmlab2.Timer.Remove(timerid)
                return
            end

            // Removes pollution from the nearest area
            local RemoveAmount = zmlab2.PollutionSystem.RemovePollution(Ventilation:GetPos(),zmlab2.config.Ventilation.AmountPerSecond)
            if RemoveAmount and RemoveAmount > 0 then

                Ventilation:SetLastPollutionMove(CurTime())

                // Moves the pollution to the output area
                zmlab2.PollutionSystem.AddPollution(Ventilation:GetOutput():GetPos(),RemoveAmount)
                zmlab2.Debug(tostring(Ventilation) .. " Pollution Moved! Amount: " .. RemoveAmount)
            else
                //zmlab2.Debug(tostring(Ventilation) .. " No pollution found!")
            end
        end)
    else
        Ventilation:EmitSound("zmlab2_ventilation_off")
    end
end

// Searches for the nearest Ventilation entity and gives it the pollution
function zmlab2.Ventilation.Check(pos,amount)
    if zmlab2.config.PollutionSystem.Enabled == false then return end

    amount = amount * zmlab2.config.PollutionSystem.Multiplier

    local Ventilation = zmlab2.Ventilation.FindNearest(pos)

    if IsValid(Ventilation) and IsValid(Ventilation:GetOutput()) and Ventilation:GetIsVenting() == true then

        Ventilation:SetLastPollutionMove(CurTime())

        zmlab2.PollutionSystem.AddPollution(Ventilation:GetOutput():GetPos(),amount)

        return true
    else

        // We didnt find a valid Ventilation entity so lets pollute the area the pollution came from
        zmlab2.PollutionSystem.AddPollution(pos,amount)
        return false
    end
end

function zmlab2.Ventilation.FindNearest(pos)
    local vent
    for k,v in pairs(zmlab2.Ventilation.List) do
        if not IsValid(v) then continue end
        if zmlab2.util.InDistance(pos, v:GetPos(), zmlab2.config.Ventilation.Radius) then
            vent = v
            break
        end
    end
    return vent
end
