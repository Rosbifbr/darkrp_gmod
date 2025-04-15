if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Filter = zmlab2.Filter or {}

/*

    The Filter combines Acid, Methylamin and Aluminium
        Filter Gameplay: https://i.imgur.com/GcXASku.png
            Small game which needs to be solved in a short amount of time

        Gameplay fail time depends on meth type

        Can change MethType:
            Normal meth
            Blue meth
            Kalaxian Crystal
            Glitter Meth (Cyberpunk 2077) https://cyberpunk.fandom.com/wiki/Glitter

        Press Connection Button and select Pump Target to move the acid to the next machine

        Filter:GetProcessState()
            0 = Need Mixer Liquid
            1 = Press the Start Button
            2 = Filtering
            //3 = HasError <- This state doesent exist anymore
            4 = Move liquid to filler machine
            5 = Moving liquid
            6 = Needs to be cleaned
*/


function zmlab2.Filter.Initialize(Filter)
    zmlab2.EntityTracker.Add(Filter)

    if zmlab2.config.Equipment.PlayerCollide == false then
        Filter:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end

    Filter:SetMaxHealth( zmlab2.config.Damageable[Filter:GetClass()] )
    Filter:SetHealth(Filter:GetMaxHealth())
end

function zmlab2.Filter.OnRemove(Filter)
    zmlab2.Timer.Remove("zmlab2_Filter_cycle_" .. Filter:EntIndex())
end

function zmlab2.Filter.SetBusy(Filter,time)
    Filter.IsBusy = true
    timer.Simple(time,function()
        if IsValid(Filter) then
            Filter.IsBusy = false
        end
    end)
end

function zmlab2.Filter.OnUse(Filter, ply)
    if Filter.IsBusy == true then return end

    if zmlab2.Player.CanInteract(ply, Filter) == false then return end

    local _state = zmlab2.Filter.GetState(Filter)

    // Filter Solution
    if _state == 1 and Filter:OnStart(ply) then
        zmlab2.Sound.EmitFromEntity("button_change", Filter)
        Filter:SetProgress(0)
        zmlab2.Filter.Cycle_Started(Filter)
    end

    // Open error mini game interface
    if Filter:GetErrorStart() > 0 and Filter:OnErrorButton(ply) then
        zmlab2.Sound.EmitFromEntity("button_change", Filter)

        // Check which minigame there is currently
        if Filter.MiniGameType == 1 then
            zmlab2.MiniGame.Respond(Filter,ply)
        else
            zmlab2.Filter.MiniGame_Respond(Filter,ply)
        end
    end

    // Move liquid to next machine
    if _state == 4 and Filter:OnStart(ply) then
        zmlab2.PumpSystem.EnablePointer(Filter,ply)
    end

    // Cleaning action
    if _state == 6 then

        zmlab2.Cleaning.Inflict(Filter,ply,function()
            Filter:SetProcessState(0)
            Filter:SetBodygroup(0,0)
        end)
    end
end


////////////////////////////////////////////////////////////
util.AddNetworkString("zmlab2_Filter_MiniGame")
function zmlab2.Filter.MiniGame_Start(Filter)
    zmlab2.Sound.EmitFromEntity("error", Filter)
    Filter:SetErrorStart(CurTime())
end
function zmlab2.Filter.MiniGame_Respond(Filter,ply)
    net.Start("zmlab2_Filter_MiniGame")
    net.WriteEntity(Filter)
    net.Send(ply)
end
net.Receive("zmlab2_Filter_MiniGame", function(len, ply)
    zmlab2.Debug_Net("zmlab2_Filter_MiniGame", len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Filter = net.ReadEntity()
    local Won = net.ReadBool()
    if not IsValid(Filter) then return end
    if Filter:GetClass() ~= "zmlab2_machine_filter" then return end
    if zmlab2.Player.CanInteract(ply, Filter) == false then return end
    if Filter:GetProcessState() ~= 2 then return end
    if zmlab2.util.InDistance(ply:GetPos(), Filter:GetPos(), 1000) == false then return end

    Filter:SetErrorStart(-1)
    if Won then
        zmlab2.MiniGame.Reward(Filter)
    else
        zmlab2.MiniGame.Punishment(Filter,Filter:GetMethType())
    end
end)
////////////////////////////////////////////////////////////



function zmlab2.Filter.GetState(Filter)
    return Filter:GetProcessState()
end

function zmlab2.Filter.Cycle_Started(Filter)
    zmlab2.Debug("zmlab2.Filter.Cycle_Started")

    Filter:SetProcessState(2)

    local filter_time = zmlab2.Meth.GetFilterTime(Filter:GetMethType())

    // Start the filtering process
    local timerid = "zmlab2_Filter_cycle_" .. Filter:EntIndex()
    zmlab2.Timer.Create(timerid,1,0,function()

        if not IsValid(Filter) then
            zmlab2.Timer.Remove(timerid)
            return
        end

        // Every second it will filter

        // Instant pollution check instead of pollution producer timer
        zmlab2.Ventilation.Check(Filter:GetPos(),zmlab2.config.PollutionSystem.AmountPerMachine["Filter_Cycle"])

        // If we are currently having a error then stop
        if Filter:GetErrorStart() > 0 then
            return
        end

        // Increase progress
        Filter:SetProgress(Filter:GetProgress() + 1)

        // Are we finished?
        if Filter:GetProgress() >= filter_time then
            zmlab2.Filter.Finished(Filter)
            zmlab2.Timer.Remove(timerid)
            return
        end

        if Filter.NextError then
            if CurTime() > Filter.NextError then

                // Start the mini game
                if math.random(100) > 50 then
                    Filter.MiniGameType = 1

                    // Start error minigame
                    zmlab2.MiniGame.Start(Filter)
                else
                    Filter.MiniGameType = 2

                    // Start simon says minigame
                    zmlab2.Filter.MiniGame_Start(Filter)
                end

                Filter.NextError = nil
            end
        else

            local ErrorChance = math.random(100)
            local ErrorThreshold = 15 + (80 / 10) * zmlab2.Meth.GetDifficulty(Filter:GetMethType())
            if ErrorChance <= ErrorThreshold then
                local NextTime = (filter_time / 3) / (zmlab2.config.MiniGame.OccurrenceMultiplier or 1)
                NextTime = NextTime * math.Rand(0.8,1)
                Filter.NextError = CurTime() + NextTime
            end
        end
    end)
end

function zmlab2.Filter.Finished(Filter)
    zmlab2.Debug("zmlab2.Filter.Cycle_Finished")
    Filter:SetProcessState(4)
end

function zmlab2.Filter.Reset(Filter)
    Filter:SetProgress(0)
    Filter:SetMethQuality(1)
    zmlab2.Timer.Remove("zmlab2_Filter_cycle_" .. Filter:EntIndex())
end



// Get called when the Pumping System started unloading this Machine
function zmlab2.Filter.Unloading_Started(Filter)
    zmlab2.Debug("zmlab2.Filter.Unloading_Started")
    Filter:SetProcessState(5)
end

// Get called when the Pumping System finished unloading this Machine
function zmlab2.Filter.Unloading_Finished(Filter)
    zmlab2.Debug("zmlab2.Filter.Unloading_Finished")
    Filter:SetProcessState(6)
    Filter:SetBodygroup(0,1)
    zmlab2.Filter.Reset(Filter)
end

// Get called when the Pumping System started loading this Machine
function zmlab2.Filter.Loading_Started(Filter)
    zmlab2.Debug("zmlab2.Filter.Loading_Started")
    // NOT USED
end

// Get called when the Pumping System finished loading this Machine
function zmlab2.Filter.Loading_Finished(Filter,Mixer)
    zmlab2.Debug("zmlab2.Filter.Loading_Finished")

    Filter:SetMethType(Mixer:GetMethType())
    Filter:SetMethQuality(Mixer:GetMethQuality())

    Mixer:SetMethQuality(1)

    // Now we got the mixer liquid
    Filter:SetProcessState(1)
end

concommand.Add("zmlab2_debug_Filter_Test", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmlab2_machine_filter" then
            tr.Entity:SetProgress(0)
            tr.Entity:SetMethType(1)
            tr.Entity:SetMethQuality(80)
            tr.Entity:SetProcessState(1)
            tr.Entity.ErrorTime = math.random(4,8)
        end
    end
end)

concommand.Add("zmlab2_debug_Filter_Reset", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmlab2_machine_filter" then
            zmlab2.Filter.Reset(tr.Entity)
            tr.Entity:SetProcessState(0)
        end
    end
end)
