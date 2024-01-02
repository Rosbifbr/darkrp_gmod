if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Furnace = zmlab2.Furnace or {}

/*

    The Furnance prepares the Acid
        Add the Acid container from the storage
        Press the start heating button
        Adjust the Temperatur if needed
        After 3 heating cycles Acid is ready

        Press Connection Button and select Pump Target to move the acid to the next machine

        Furnace:GetProcessState()
            0 = Needs more Acid
            1 = Press the Start Button
            2 = Is Heating Acid
            3 = Requieres heat change
            4 = Acid is ready and needs to be pumped to next machine
            5 = Moving Acid (Loading)
            6 = Needs to be cleaned
*/


function zmlab2.Furnace.Initialize(Furnace)

    if zmlab2.config.Equipment.PlayerCollide == false then
        Furnace:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end

    Furnace:SetTrigger(true)

    Furnace:SetMaxHealth( zmlab2.config.Damageable[Furnace:GetClass()] )
    Furnace:SetHealth(Furnace:GetMaxHealth())

    zmlab2.EntityTracker.Add(Furnace)
end

function zmlab2.Furnace.OnRemove(Furnace)
    zmlab2.Timer.Remove("zmlab2_furnace_tempcycle_" .. Furnace:EntIndex())
    zmlab2.Timer.Remove("zmlab2_furnace_heatingcycle_" .. Furnace:EntIndex())
end

function zmlab2.Furnace.OnStartTouch(Furnace,other)
    if not IsValid(Furnace) then return end
    if not IsValid(other) then return end
    if zmlab2.util.CollisionCooldown(other) then return end
    if other:GetClass() ~= "zmlab2_item_acid" then return end

    // Do we even need acid right now?
    if zmlab2.Furnace.GetState(Furnace) ~= 0 then return end

    zmlab2.Furnace.AddAcid(Furnace,other)
end

function zmlab2.Furnace.OnUse(Furnace, ply)

    if zmlab2.Player.CanInteract(ply, Furnace) == false then return end

    local _state = zmlab2.Furnace.GetState(Furnace)

    // Start process
    if _state == 1 and Furnace:OnStart(ply) and Furnace:GetAcidAmount() >= zmlab2.config.Furnace.Capacity then

        Furnace:SetHeater(1)

        zmlab2.Furnace.StartHeatingCycle(Furnace)
    end

    // Change temperatur
    if _state == 2 then
        if Furnace:OnIncrease(ply) then
            Furnace:SetHeater(math.Clamp(Furnace:GetHeater() + 1, 0, 2))
            zmlab2.Sound.EmitFromEntity("button_change", Furnace)
        elseif Furnace:OnDecrease(ply) then
            Furnace:SetHeater(math.Clamp(Furnace:GetHeater() - 1, 0, 2))
            zmlab2.Sound.EmitFromEntity("button_change", Furnace)
        end
    end

    // Move accid to next machine
    if _state == 4 and Furnace:OnStart(ply) then
        zmlab2.PumpSystem.EnablePointer(Furnace,ply)
    end

    // Cleaning action
    if _state == 6 then

        zmlab2.Cleaning.Inflict(Furnace,ply,function()
            Furnace:SetBodygroup(1,0)
            zmlab2.Furnace.Reset(Furnace)
        end)
    end
end

function zmlab2.Furnace.Reset(Furnace)
    Furnace:SetAcidAmount(0)
    Furnace:SetProcessState(0)
    Furnace:SetAcidAmount(0)
    Furnace:SetTemperatur(0)
    Furnace:SetHeater(0)
end

function zmlab2.Furnace.GetState(Furnace)
    return Furnace:GetProcessState()
end

function zmlab2.Furnace.AddAcid(Furnace,Acid)
    // Are we currently filling acid in the machine?
    if Furnace:GetBodygroup(0) == 1 then return end

    // Add the acid
    Furnace:SetAcidAmount(math.Clamp(Furnace:GetAcidAmount() + 1,0,zmlab2.config.Furnace.Capacity))

    zmlab2.Sound.EmitFromEntity("liquid_fill", Furnace)
    zmlab2.NetEvent.Create("acid_fill", Furnace)

    // Enable fill bodygroup
    Furnace:SetBodygroup(0,1)
    timer.Simple(3,function()
        if IsValid(Furnace) then
            Furnace:SetBodygroup(0,0)

            // Next stage
            if Furnace:GetAcidAmount() >= zmlab2.config.Furnace.Capacity then
                Furnace:SetProcessState(1)
            end
        end
    end)


    // Stop moving if you have physics
    if Acid.PhysicsDestroy then Acid:PhysicsDestroy() end

    // Hide entity
    if Acid.SetNoDraw then Acid:SetNoDraw(true) end

    // This got taken from a Physcollide function but maybe its needed to prevent a crash
    local deltime = FrameTime() * 2
    if not game.SinglePlayer() then deltime = FrameTime() * 6 end
    SafeRemoveEntityDelayed(Acid, deltime)
end

function zmlab2.Furnace.StartHeatingCycle(Furnace)

    Furnace:SetProcessState(2)
    Furnace:SetHeatingStart(CurTime())

    // Keeps track for how many seconds the temperatur was in a good area
    Furnace.PerfectTime = 0

    // Creates a pollution timer for the time being
    zmlab2.PollutionSystem.AddProducer(Furnace,zmlab2.config.PollutionSystem.AmountPerMachine["Furnace_Cycle"],zmlab2.config.Furnace.HeatingCylce_Duration)

    local timer_temp = "zmlab2_furnace_tempcycle_" .. Furnace:EntIndex()
    zmlab2.Timer.Create(timer_temp,1,0,function()

        if not IsValid(Furnace) then
            zmlab2.Timer.Remove(timer_temp)
            return
        end

        local heat = Furnace:GetHeater()
        if heat == 1 then
            Furnace:SetTemperatur(math.Clamp(Furnace:GetTemperatur() + 1,0,100))
        elseif heat == 2 then
            Furnace:SetTemperatur(math.Clamp(Furnace:GetTemperatur() + 10,0,100))
        else
            if math.random(0,10) < 6 then
                Furnace:SetTemperatur(math.Clamp(Furnace:GetTemperatur() - math.random(1,5),0,100))
            end
        end

        local temp = Furnace:GetTemperatur()
        if temp > 99 then
            //Explode
            zmlab2.Furnace.Explode(Furnace)
        elseif temp > 75 then
            // If not on fire already then ignite
            zmlab2.Furnace.Ignite(Furnace)
        elseif temp > 25 then

            Furnace.PerfectTime = Furnace.PerfectTime + 1
        end
    end)

    // Start the heating process
    local timer_heat = "zmlab2_furnace_heatingcycle_" .. Furnace:EntIndex()
    zmlab2.Timer.Create(timer_heat,zmlab2.config.Furnace.HeatingCylce_Duration,1,function()

        if not IsValid(Furnace) then
            zmlab2.Timer.Remove(timer_temp)
            zmlab2.Timer.Remove(timer_heat)
            return
        end

        local temp = Furnace:GetTemperatur()
        if temp > 99 then
            //Explode
            zmlab2.Furnace.Explode(Furnace)

        elseif temp > 75 then
            // If not on fire already then ignite
            zmlab2.Furnace.OnAcidFailed(Furnace)

        elseif temp < 25 then
            // Acid too could, batch ruined, dumb it!
            zmlab2.Furnace.OnAcidFailed(Furnace)
        else
            // Its perfect, well done!
            zmlab2.Furnace.OnAcidFinished(Furnace)
        end
        zmlab2.Timer.Remove(timer_temp)
        zmlab2.Timer.Remove(timer_heat)
    end)
end

function zmlab2.Furnace.Explode(Furnace)

    zmlab2.NetEvent.Create("acid_explo", Furnace:GetPos())
    zmlab2.Damage.Explosion(Furnace,Furnace:GetPos(), 100, DMG_ACID, 15)

    local effectdata = EffectData()
    effectdata:SetOrigin( Furnace:GetPos() )
    util.Effect( "HelicopterMegaBomb", effectdata )

    zmlab2.Sound.EmitFromPosition(Furnace:GetPos(),"machine_explode")

    Furnace:SetNoDraw(true)
    SafeRemoveEntityDelayed(Furnace,0.1)
end

function zmlab2.Furnace.Ignite(Furnace)
    zmlab2.Fire.Ignite(Furnace,15,1)
end

function zmlab2.Furnace.OnAcidFinished(Furnace)
    zmlab2.Sound.EmitFromEntity("progress_done", Furnace)
    Furnace:SetProcessState(4)
end

function zmlab2.Furnace.OnAcidFailed(Furnace)
    zmlab2.Sound.EmitFromEntity("progress_error", Furnace)
    Furnace:SetProcessState(6)
    Furnace:SetBodygroup(1,1)
end

// Get called when the Pumping System started unloading this Machine
function zmlab2.Furnace.Unloading_Started(Furnace)
    zmlab2.Debug("zmlab2.Furnace.Unloading_Started")
    Furnace:SetProcessState(5)
    Furnace:SetAcidAmount(0)
end

// Get called when the Pumping System finished unloading this Machine
function zmlab2.Furnace.Unloading_Finished(Furnace)
    zmlab2.Debug("zmlab2.Furnace.Unloading_Finished")
    Furnace:SetProcessState(6)
    Furnace:SetBodygroup(1,1)
end

concommand.Add("zmlab2_debug_Furnace_Test", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmlab2_machine_furnace" then

            tr.Entity:SetProcessState(1)
            tr.Entity.PerfectTime = zmlab2.config.Furnace.HeatingCylce_Duration
            tr.Entity:SetAcidAmount(zmlab2.config.Furnace.Capacity)
            zmlab2.Furnace.OnAcidFinished(tr.Entity)
        end
    end
end)
