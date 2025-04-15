if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Mixer = zmlab2.Mixer or {}

/*

    The Mixer combines Acid, Methylamin and Aluminium
        [Move entity] Add black barrel
        [Connect pipe] Add warm acid
        [Press E] Start mixer
        [Move entity] Add aluminium
        [Press E] Start mixer
        [Press E] Add exaustpipe sucking pipe (Pipe bodygroup)
        [Wait] LOADING

        Press Connection Button and select Pump Target to move the acid to the next machine

        Mixer:GetProcessState()
            0 = Needs Barrel
            1 = Needs Acid
            2 = Press the Start Mix Button
            3 = Mixing Methylamine & Acid
            4 = Add Aluminium
            5 = Press the Start Mix Button
            6 = Mixing Aluminum
            7 = Add Exhaust pipe
            8 = Venting (Wait)
            9 = Move Liquid
            10 = Moving Liquid (Loading)
            11 = Needs to be cleaned
*/


function zmlab2.Mixer.Initialize(Mixer)
    zmlab2.EntityTracker.Add(Mixer)

    if zmlab2.config.Equipment.PlayerCollide == false then
        Mixer:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end

    Mixer:SetTrigger(true)

    Mixer:SetMaxHealth( zmlab2.config.Damageable[Mixer:GetClass()] )
    Mixer:SetHealth(Mixer:GetMaxHealth())

    zmlab2.Mixer.Reset(Mixer)

    //zmlab2.Mixer.ChangeState(Mixer,7)
end

function zmlab2.Mixer.OnRemove(Mixer)
    zmlab2.Timer.Remove("zmlab2_Mixer_mixingcycle_" .. Mixer:EntIndex())
end

function zmlab2.Mixer.SetBusy(Mixer,time)
    Mixer.IsBusy = true
    timer.Simple(time,function()
        if IsValid(Mixer) then
            Mixer.IsBusy = false
        end
    end)
end

function zmlab2.Mixer.OnStartTouch(Mixer,other)
    if not IsValid(Mixer) then return end
    if not IsValid(other) then return end
    if zmlab2.util.CollisionCooldown(other) then return end
    if Mixer.IsBusy == true then return end
    if other:GetClass() ~= "zmlab2_item_methylamine" and other:GetClass() ~= "zmlab2_item_aluminium" then return end

    zmlab2.Mixer.AddIngredient(Mixer,other)
end

function zmlab2.Mixer.AddIngredient(Mixer,Ingredient)

    local _state = zmlab2.Mixer.GetState(Mixer)
    local _class = Ingredient:GetClass()

    // Do we even need methylamine right now?
    if _class == "zmlab2_item_methylamine" and _state ~= 0 then
        return
    end

    // Do we even need Aluminium right now?
    if _class == "zmlab2_item_aluminium" and _state ~= 4 then
        return
    end

    if _class == "zmlab2_item_methylamine" then

        zmlab2.NetEvent.Create("methylamin_fill", Mixer)
        zmlab2.Sound.EmitFromEntity("liquid_fill", Mixer)
        Ingredient:SetBodygroup(0,1)
        Ingredient:SetPos(Mixer:LocalToWorld(Vector(-11,0,70)))
        Ingredient:SetAngles(Mixer:LocalToWorldAngles(Angle(115,0,0)))
    elseif _class == "zmlab2_item_aluminium" then

        zmlab2.NetEvent.Create("aluminium_fill", Mixer)
        zmlab2.Sound.EmitFromEntity("aluminium_fill", Mixer)
        Ingredient:SetPos(Mixer:LocalToWorld(Vector(-2,0,65)))
        Ingredient:SetAngles(Mixer:LocalToWorldAngles(Angle(115,0,0)))
    end

    zmlab2.Mixer.SetBusy(Mixer,2.5)

    timer.Simple(2.4,function()
        if IsValid(Mixer) then

            // Add liquid bodygroup
            Mixer:SetBodygroup(4,1)

            if _class == "zmlab2_item_methylamine" then

                Mixer:SetNeedAmount(math.Clamp(Mixer:GetNeedAmount() - 1,0,99))
                if Mixer:GetNeedAmount() <= 0 then zmlab2.Mixer.ChangeState(Mixer,1) end
            elseif  _class == "zmlab2_item_aluminium" then

                Mixer:SetNeedAmount(math.Clamp(Mixer:GetNeedAmount() - 1,0,99))
                if Mixer:GetNeedAmount() <= 0 then zmlab2.Mixer.ChangeState(Mixer,5) end
            end
        end
    end)

    // Stop moving if you have physics
    if Ingredient.PhysicsDestroy then Ingredient:PhysicsDestroy() end

    // This got taken from a Physcollide function but maybe its needed to prevent a crash
    SafeRemoveEntityDelayed(Ingredient, 2.5)
end

function zmlab2.Mixer.UpdateLiquidColor(Mixer)
    zmlab2.Debug("zmlab2.Mixer.UpdateLiquidColor")
    Mixer:SetColor(zmlab2.Mixer.GetLiquidColor(Mixer))
end

function zmlab2.Mixer.OnUse(Mixer, ply)
    if Mixer.IsBusy == true then return end

    if zmlab2.Player.CanInteract(ply, Mixer) == false then return end
    local _state = zmlab2.Mixer.GetState(Mixer)

    // Open error mini game interface
    if Mixer:GetErrorStart() > 0 and Mixer:OnErrorButton(ply) then
        zmlab2.Sound.EmitFromEntity("button_change", Mixer)
        zmlab2.MiniGame.Respond(Mixer,ply)
    end

    // Open the meth type selection
    if _state == -1 and Mixer:OnMethType(ply) then
        zmlab2.Sound.EmitFromEntity("button_change", Mixer)
        zmlab2.Mixer.OpenInterface(Mixer,ply)
    end

    // Start the cooking process
    if _state == -1 and Mixer:OnStart(ply) then
        zmlab2.Sound.EmitFromEntity("button_change", Mixer)
        local MethData = zmlab2.config.MethTypes[Mixer:GetMethType()]
        Mixer:SetNeedAmount(MethData.recipe_barrel)

        zmlab2.Mixer.ChangeState(Mixer,0)
    end

    // Mix acid
    if _state == 2 and Mixer:OnCenterButton(ply) then
        zmlab2.Sound.EmitFromEntity("button_change", Mixer)
        zmlab2.Mixer.ChangeState(Mixer,3)

        zmlab2.Mixer.MixingCycle_Started(Mixer,zmlab2.Meth.GetMixTime(Mixer:GetMethType()),function()

            zmlab2.Mixer.ChangeState(Mixer,4)

            local MethData = zmlab2.config.MethTypes[Mixer:GetMethType()]
            Mixer:SetNeedAmount(MethData.recipe_alu)
        end)
    end

    // Mix aluminium
    if _state == 5 and Mixer:OnCenterButton(ply) then
        zmlab2.Sound.EmitFromEntity("button_change", Mixer)
        zmlab2.Mixer.ChangeState(Mixer,6)

        zmlab2.Mixer.MixingCycle_Started(Mixer,zmlab2.Meth.GetMixTime(Mixer:GetMethType()),function()

            zmlab2.Mixer.ChangeState(Mixer,7)

            // Remove cap and tell player to add Exhaust pipe
            Mixer:SetBodygroup(0,2)
        end)
    end

    // Add Exhaust pipe
    if _state == 7 and Mixer:OnCenterButton(ply) then
        net.Start("zmlab2_Mixer_MiniGame")
        net.WriteEntity(Mixer)
        net.Send(ply)
    end

    // Move liquid to next machine
    if _state == 9 and Mixer:OnCenterButton(ply) then
        zmlab2.PumpSystem.EnablePointer(Mixer,ply)
    end

    // Cleaning action
    if _state == 11 then
        zmlab2.Cleaning.Inflict(Mixer,ply,function()
            Mixer:SetBodygroup(1,0)
            zmlab2.Mixer.Reset(Mixer)
        end)
    end
end

function zmlab2.Mixer.Reset(Mixer)
    zmlab2.Debug("zmlab2.Mixer.Reset")

    zmlab2.Mixer.ChangeState(Mixer,-1)
end


util.AddNetworkString("zmlab2_Mixer_OpenInterface")
function zmlab2.Mixer.OpenInterface(Mixer,ply)
    net.Start("zmlab2_Mixer_OpenInterface")
    net.WriteEntity(Mixer)
    net.Send(ply)
end

util.AddNetworkString("zmlab2_Mixer_SetMethType")
net.Receive("zmlab2_Mixer_SetMethType", function(len, ply)
    zmlab2.Debug_Net("zmlab2_Mixer_SetMethType", len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Mixer = net.ReadEntity()
    local MethTypeID = net.ReadUInt(16)
    if not IsValid(Mixer) then return end
    if Mixer:GetClass() ~= "zmlab2_machine_mixer" then return end
    if MethTypeID == nil then return end
    if zmlab2.Player.CanInteract(ply, Mixer) == false then return end
    if Mixer:GetProcessState() ~= -1 then return end
    if zmlab2.util.InDistance(ply:GetPos(), Mixer:GetPos(), 1000) == false then return end

    // Is the player allowed to create this meth type?
    if zmlab2.Mixer.MethTypeCheck(ply,MethTypeID) == false then

        zmlab2.Notify(ply, zmlab2.language["MethTypeRestricted"], 1)
        return
    end

    Mixer:SetMethType(MethTypeID)
end)

// Handels the venting minigame
util.AddNetworkString("zmlab2_Mixer_MiniGame")
net.Receive("zmlab2_Mixer_MiniGame", function(len, ply)
    zmlab2.Debug_Net("zmlab2_Mixer_MiniGame", len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Mixer = net.ReadEntity()
    local Won = net.ReadBool()
    if not IsValid(Mixer) then return end
    if Mixer:GetClass() ~= "zmlab2_machine_mixer" then return end
    if zmlab2.Player.CanInteract(ply, Mixer) == false then return end
    if Mixer:GetProcessState() ~= 7 then return end
    if zmlab2.util.InDistance(ply:GetPos(), Mixer:GetPos(), 1000) == false then return end


    if Won == false then
        zmlab2.MiniGame.Punishment(Mixer,Mixer:GetMethType())
        return
    end

    zmlab2.Mixer.VentGame_Completed(Mixer)
end)
function zmlab2.Mixer.VentGame_Completed(Mixer)
    Mixer:SetBodygroup(0,1)

    zmlab2.Mixer.ChangeState(Mixer,8)

    // Start venting
    zmlab2.Mixer.MixingCycle_Started(Mixer,zmlab2.Meth.GetVentTime(Mixer:GetMethType()),function()

        zmlab2.Mixer.ChangeState(Mixer,9)

        // Reset bodygroups
        Mixer:SetBodygroup(0,0)
    end)
end

// Called once the mini game got completed or run out
function zmlab2.Mixer.MiniGame_Completed(Mixer,Result)

    // Problem stopped, unpause main timer
    timer.UnPause( "zmlab2_Mixer_mixingcycle_" .. Mixer:EntIndex() )
    zmlab2.Debug("zmlab2.Mixer.MixingCycle_Info: Mixing CONTINUES!")
end

function zmlab2.Mixer.MixingCycle_Started(Mixer,Time,OnComplete)
    zmlab2.Debug("zmlab2.Mixer.MixingCycle_Started")

    // Creates a pollution timer for the time being
    zmlab2.PollutionSystem.AddProducer(Mixer,zmlab2.config.PollutionSystem.AmountPerMachine["Mixer_Cycle"],Time)

    Mixer:SetProcessStart(CurTime())

    // Will there be a error?
    local ErrorChance = math.random(100)
    local ErrorThreshold = 15 + (80 / 10) * zmlab2.Meth.GetDifficulty(Mixer:GetMethType())
    if ErrorChance <= ErrorThreshold then

        // Lets calculate at which point a error should occur
        local ErrorTime = Time * math.Rand(0.3,0.8)

        zmlab2.Debug("zmlab2.Mixer.MixingCycle_Info: ERROR will occur in " .. ErrorTime .. " seconds!")

        // Start the timer till the error occurs
        local timerid = "zmlab2_Mixer_error_" .. Mixer:EntIndex()
        zmlab2.Timer.Create(timerid,ErrorTime,1,function()
            if IsValid(Mixer) then
                zmlab2.Debug("zmlab2.Mixer.MixingCycle_Info: Mixing got PAUSED!")
                timer.Pause( "zmlab2_Mixer_mixingcycle_" .. Mixer:EntIndex() )
                zmlab2.MiniGame.Start(Mixer)
            end
            zmlab2.Timer.Remove(timerid)
        end)
    end

    // MainTimer
    local timerid = "zmlab2_Mixer_mixingcycle_" .. Mixer:EntIndex()
    zmlab2.Timer.Create(timerid,Time,1,function()
        if IsValid(Mixer) then
            zmlab2.Debug("zmlab2.Mixer.MixingCycle_Finished")
            zmlab2.Sound.EmitFromEntity("progress_done", Mixer)
            pcall(OnComplete)
            Mixer:SetProcessStart(-1)
        end
        zmlab2.Timer.Remove(timerid)
    end)
end

function zmlab2.Mixer.GetState(Mixer)
    return Mixer:GetProcessState()
end

function zmlab2.Mixer.ChangeState(Mixer,newState)
    zmlab2.Debug("zmlab2.Mixer.ChangeState")
    Mixer:SetProcessState(newState)
    zmlab2.Mixer.UpdateLiquidColor(Mixer)
end


// Get called when the Pumping System started unloading this Machine
function zmlab2.Mixer.Unloading_Started(Mixer)
    zmlab2.Debug("zmlab2.Mixer.Unloading_Started")
    zmlab2.Mixer.ChangeState(Mixer,10)
end

// Get called when the Pumping System finished unloading this Machine
function zmlab2.Mixer.Unloading_Finished(Mixer)
    zmlab2.Debug("zmlab2.Mixer.Unloading_Finished")
    zmlab2.Mixer.ChangeState(Mixer,11)

    // Remove liquid bodygroup
    Mixer:SetBodygroup(4,0)

    // Enable dirt
    Mixer:SetBodygroup(1,1)
end

// Get called when the Pumping System started loading this Machine
function zmlab2.Mixer.Loading_Started(Mixer)
    zmlab2.Debug("zmlab2.Mixer.Loading_Started")
    // NOT USED
end

// Get called when the Pumping System finished loading this Machine
function zmlab2.Mixer.Loading_Finished(Mixer,Furnace)
    zmlab2.Debug("zmlab2.Mixer.Loading_Finished")

    /*
        Quality 1 - 100 %
    */

    // Lets check what the grade of the Acid is we just got, since this impacts the final quality
    local acid_grade = (100 / zmlab2.config.Furnace.HeatingCylce_Duration) * Furnace.PerfectTime
    Mixer:SetMethQuality(acid_grade)
    zmlab2.Mixer.ChangeState(Mixer,2)
end

concommand.Add("zmlab2_debug_Mixer_Test", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmlab2_machine_mixer" then

            tr.Entity:SetMethType(1)
            tr.Entity:SetMethQuality(80)
            tr.Entity:SetNeedAmount(1)
            zmlab2.Mixer.ChangeState(tr.Entity,4)

            // Remove cap and tell player to add Exhaust pipe
            //tr.Entity:SetBodygroup(0,2)
        end
    end
end)

concommand.Add("zmlab2_debug_Mixer_Reset", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmlab2_machine_mixer" then
            zmlab2.Mixer.Reset(tr.Entity)
        end
    end
end)

concommand.Add("zmlab2_debug_Mixer_Minigame", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmlab2_machine_mixer" then
            local id = math.random(#zmlab2.config.MethTypes)
            print(zmlab2.config.MethTypes[id].difficulty)
            tr.Entity:SetMethType(id)
            zmlab2.Mixer.ChangeState(tr.Entity,7)
        end
    end
end)
