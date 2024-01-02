if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Filler = zmlab2.Filler or {}

/*
        Filler:GetProcessState()
            0 = Need Filler Liquid
            1 = Need Tray
            2 = Filling
            3 = Needs Cleaning
*/

function zmlab2.Filler.Initialize(Filler)
    zmlab2.EntityTracker.Add(Filler)

    if zmlab2.config.Equipment.PlayerCollide == false then
        Filler:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end

    Filler:SetTrigger(true)

    Filler:SetMaxHealth( zmlab2.config.Damageable[Filler:GetClass()] )
    Filler:SetHealth(Filler:GetMaxHealth())
end

function zmlab2.Filler.OnRemove(Filler)
    zmlab2.Timer.Remove("zmlab2_Filler_cycle_" .. Filler:EntIndex())
end

function zmlab2.Filler.OnStartTouch(Filler,other)
    if not IsValid(Filler) then return end
    if not IsValid(other) then return end
    if zmlab2.util.CollisionCooldown(other) then return end
    if Filler.IsBusy == true then return end
    if IsValid(Filler:GetTray()) then return end

    if zmlab2.Filler.GetState(Filler) ~= 1 then return end

    if other:GetClass() == "zmlab2_item_frezzertray" then

        // Does the tray have the same type of meth we are using
        if Filler:GetMethAmount() > 0 and other:GetMethAmount() > 0 and other:GetMethType() ~= Filler:GetMethType() then return end

        // Does the tray have space?
        if other:GetMethAmount() >= zmlab2.config.Frezzer.Tray_Capacity then return end

        zmlab2.Filler.AddTray(Filler,other)
    end
end

function zmlab2.Filler.AddTray(Filler,tray)

    Filler:SetTray(tray)

    DropEntityIfHeld(tray)

    tray:SetPos(Filler:LocalToWorld(Vector(-26,0,16.3)))
    tray:SetAngles(Filler:LocalToWorldAngles(angle_zero))

    tray:SetParent(Filler)

    // Auto start the filling process
    if zmlab2.Filler.GetState(Filler) == 1 and Filler:GetMethAmount() > 0 and IsValid(Filler:GetTray()) then
        zmlab2.Filler.Cycle_Started(Filler)
    end
end

function zmlab2.Filler.DropTray(Filler)

    local tray = Filler:GetTray()

    tray:SetParent(nil)
    tray:SetPos(Filler:LocalToWorld(Vector(15,25,16.5)))
    tray:SetAngles(Filler:LocalToWorldAngles(angle_zero))

    tray:PhysicsInit(SOLID_VPHYSICS)
    tray:SetSolid(SOLID_VPHYSICS)
    tray:SetMoveType(MOVETYPE_VPHYSICS)
    tray:SetUseType(SIMPLE_USE)
    tray:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    local phys = tray:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(true)
    end

    Filler:SetTray(NULL)
end

function zmlab2.Filler.SetBusy(Filler,time)
    Filler.IsBusy = true
    timer.Simple(time,function()
        if IsValid(Filler) then
            Filler.IsBusy = false
        end
    end)
end

function zmlab2.Filler.OnUse(Filler, ply)
    if Filler.IsBusy == true then return end

    if zmlab2.Player.CanInteract(ply, Filler) == false then return end

    local _state = zmlab2.Filler.GetState(Filler)

    // Cleaning action
    if _state == 3 then

        zmlab2.Cleaning.Inflict(Filler,ply,function()
            Filler:SetProcessState(0)
            Filler:SetBodygroup(0,0)
        end)
    end
end

function zmlab2.Filler.Cycle_Started(Filler)
    zmlab2.Debug("zmlab2.Filler.Cycle_Started")

    Filler:SetProcessState(2)

    // Creates a pollution timer for the time being
    zmlab2.PollutionSystem.AddProducer(Filler,zmlab2.config.PollutionSystem.AmountPerMachine["Filler_Cycle"],zmlab2.config.Filler.Fill_Time)


    // Start the Fillering process
    local timerid = "zmlab2_Filler_cycle_" .. Filler:EntIndex()
    zmlab2.Timer.Create(timerid,zmlab2.config.Filler.Fill_Time,1,function()
        if IsValid(Filler) then
            zmlab2.Debug("zmlab2.Filler.Cycle_Finished")

            local tray = Filler:GetTray()

            local moveLoad = math.Clamp(Filler:GetMethAmount(),1,zmlab2.config.Frezzer.Tray_Capacity)

            // Adds the meth liquid to the tray
            zmlab2.FrezzerTray.AddLiquid(tray,Filler:GetMethType(),moveLoad,Filler:GetMethQuality())

            zmlab2.Filler.DropTray(Filler)

            Filler:SetMethAmount(math.Clamp(Filler:GetMethAmount() - moveLoad,0,999999999))

            if Filler:GetMethAmount() <= 0 then
                Filler:SetProcessState(3)
                Filler:SetBodygroup(0,1)
            else
                Filler:SetProcessState(1)
            end
        end
        zmlab2.Timer.Remove(timerid)
    end)
end

function zmlab2.Filler.GetState(Filler)
    return Filler:GetProcessState()
end

// Get called when the Pumping System started unloading this Machine
function zmlab2.Filler.Unloading_Started(Filler)
    zmlab2.Debug("zmlab2.Filler.Unloading_Started")
    // NOT USED
end

// Get called when the Pumping System finished unloading this Machine
function zmlab2.Filler.Unloading_Finished(Filler)
    zmlab2.Debug("zmlab2.Filler.Unloading_Finished")
    // NOT USED
end

// Get called when the Pumping System started loading this Machine
function zmlab2.Filler.Loading_Started(Filler)
    zmlab2.Debug("zmlab2.Filler.Loading_Started")

end

// Get called when the Pumping System finished loading this Machine
function zmlab2.Filler.Loading_Finished(Filler,Filter)
    zmlab2.Debug("zmlab2.Filler.Loading_Finished")
    // Now we got the filter liquid
    Filler:SetProcessState(1)

    local m_type, m_quality = Filter:GetMethType(), Filter:GetMethQuality()
    zmlab2.Debug("m_type: " .. m_type)
    zmlab2.Debug("m_quality: " .. m_quality)

    Filler:SetMethType(m_type)
    Filler:SetMethAmount(zmlab2.config.MethTypes[m_type].batch_size)
    Filler:SetMethQuality(m_quality)
end

concommand.Add("zmlab2_debug_Filler_Test", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()
        if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmlab2_machine_filler" then
            if tr.Entity:GetProcessState() == 0 then
                local batch_size = zmlab2.config.MethTypes[2].batch_size

                tr.Entity:SetMethType(2)
                tr.Entity:SetMethQuality(100)
                tr.Entity:SetMethAmount(batch_size)
                tr.Entity:SetProcessState(1)
            else
                tr.Entity:SetMethType(1)
                tr.Entity:SetMethQuality(0)
                tr.Entity:SetMethAmount(0)
                tr.Entity:SetProcessState(0)
            end
        end
    end
end)
