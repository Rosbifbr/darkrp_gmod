if CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.MiniGame = zmlab2.MiniGame or {}


concommand.Add("zmlab2_debug_MiniGame", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit and IsValid(tr.Entity) then

            tr.Entity.MiniGame_Responder = nil

            zmlab2.MiniGame.Start(tr.Entity)

            zmlab2.MiniGame.Respond(tr.Entity,ply)
        end
    end
end)

function zmlab2.MiniGame.Start(Machine)
    zmlab2.Debug("zmlab2.MiniGame.Start")
    zmlab2.Sound.EmitFromEntity("error", Machine)

    Machine.MiniGame_InitialTime = CurTime()

    // Defines the position of the green save area on the bar
    Machine.MiniGame_ErrorTime = math.random(4,8)

    // Create fail timer
    zmlab2.MiniGame.FailTimer(Machine)
end

// Creates a timer after which the mini game is failed
function zmlab2.MiniGame.FailTimer(Machine)
    zmlab2.Debug("zmlab2.MiniGame.FailTimer")

    // If someone already responded to the mini game then stop
    if IsValid(Machine.MiniGame_Responder) then return end

    // If the error doesent get adressed till this time then the machine gonna start burning
    Machine:SetErrorStart(CurTime())

    local timerid = "zmlab2_MiniGame_" .. Machine:EntIndex()
    zmlab2.Timer.Remove(timerid)
    zmlab2.Timer.Create(timerid,zmlab2.config.MiniGame.RespondTime,1,function()
        if IsValid(Machine) then
            zmlab2.MiniGame.Result(Machine,false)
        end
        zmlab2.Timer.Remove(timerid)
    end)
end

util.AddNetworkString("zmlab2_MiniGame")
function zmlab2.MiniGame.Respond(Machine,ply)
    zmlab2.Debug("zmlab2.MiniGame.Respond")
    // If someone already responded to the mini game then stop
    if IsValid(Machine.MiniGame_Responder) then return end

    // Kill fail timer
    zmlab2.MiniGame.FailTimer(Machine)

    Machine.MiniGame_Responder = ply

    net.Start("zmlab2_MiniGame")
    net.WriteEntity(Machine)
    net.WriteUInt(Machine.MiniGame_ErrorTime,16)
    net.Send(ply)
end

net.Receive("zmlab2_MiniGame", function(len, ply)
    zmlab2.Debug_Net("zmlab2_MiniGame", len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    local Result = net.ReadBool()
    if not IsValid(Machine) then return end

    if zmlab2.Player.CanInteract(ply, Machine) == false then return end
    if zmlab2.util.InDistance(ply:GetPos(), Machine:GetPos(), 1000) == false then return end

    if ply ~= Machine.MiniGame_Responder then return end

    // Kill the automatic fail timer since we got a result
    zmlab2.Timer.Remove("zmlab2_MiniGame_" .. Machine:EntIndex())

    zmlab2.MiniGame.Result(Machine,Result)
end)

function zmlab2.MiniGame.Result(Machine,Result)
    zmlab2.Debug("zmlab2.MiniGame.Result: " .. tostring(Result))

    if Result == true then
        zmlab2.MiniGame.Reward(Machine)
    else
        zmlab2.MiniGame.Punishment(Machine,Machine:GetMethType())
    end

    // If the machine got a process start var then offset it by the time that passe
    if Machine.SetProcessStart and Machine.MiniGame_InitialTime then
        local passed = math.Clamp(CurTime() - Machine.MiniGame_InitialTime,0,1000)
        Machine:SetProcessStart(math.Round(Machine:GetProcessStart() + passed))
    end

    zmlab2.MiniGame.Reset(Machine)

    Machine:OnMiniGameComplete(Result)
end

function zmlab2.MiniGame.Reset(Machine)
    zmlab2.Debug("zmlab2.MiniGame.Reset")
    Machine.MiniGame_ErrorTime = 0
    Machine.MiniGame_Responder = nil
    Machine:SetErrorStart(-1)
end

function zmlab2.MiniGame.Reward(Machine)
    zmlab2.Sound.EmitFromEntity("lox_loaded", Machine)

    // Increase the quality
    local qual = math.Clamp(Machine:GetMethQuality() + zmlab2.MiniGame.GetReward(Machine),5,100)
    Machine:SetMethQuality(qual)
end

local function RollDice(chance)
    local pool = {}

    for i = 1, chance do
        table.insert(pool, true)
    end

    for i = 1, 100 - chance do
        table.insert(pool, false)
    end

    pool = zmlab2.util.table_randomize(pool)

    return table.Random(pool)
end

// Here we give the machine/player a diffrent punishment depending on Meth Difficulty
function zmlab2.MiniGame.Punishment(Machine,MethType)
    zmlab2.Sound.EmitFromEntity("minigame_fail", Machine)

    local Difficulty = zmlab2.Meth.GetDifficulty(MethType)

    // Reduce Quality
    local qual = math.Clamp(Machine:GetMethQuality() - zmlab2.MiniGame.GetPenalty(Machine),5,100)
    Machine:SetMethQuality(qual)
    zmlab2.Debug("QualityUpdate: " .. tostring(qual))

    // Pollute it!
    if Difficulty >= zmlab2.config.MiniGame.Punishment.Pollu_Difficulty and RollDice(zmlab2.config.MiniGame.Punishment.Pollu_Chance) then
        // Create big amount of pollution
        zmlab2.PollutionSystem.AddPollution(Machine:GetPos(),zmlab2.config.MiniGame.Punishment.Pollu_Amount)
        zmlab2.Sound.EmitFromPosition(Machine:GetPos(), "gas_buff")
        //print("Pollute!")
    end

    // Burn it!
    if Difficulty >= zmlab2.config.MiniGame.Punishment.Fire_Difficulty and RollDice(zmlab2.config.MiniGame.Punishment.Fire_Chance) then
        zmlab2.Fire.Ignite(Machine,zmlab2.config.MiniGame.Punishment.Fire_Duration,1)
        zmlab2.Damage.InflictBurn(Machine, 10)
        //print("Burn!")
    end

    // Explode it!
    if Difficulty >= zmlab2.config.MiniGame.Punishment.Explo_Difficulty and RollDice(zmlab2.config.MiniGame.Punishment.Explo_Chance) then
        zmlab2.Damage.InflictBurn(Machine, 25)

        zmlab2.Damage.Explosion(Machine,Machine:GetPos(), 150, DMG_BLAST, 15)

        local ed_explo = EffectData()
        ed_explo:SetOrigin( Machine:GetPos() )
        util.Effect( "HelicopterMegaBomb", ed_explo )

        zmlab2.Sound.EmitFromPosition(Machine:GetPos(),"machine_explode")

        Machine:SetNoDraw(true)
        SafeRemoveEntityDelayed(Machine,0.1)

        //print("Explode!")
    end
end
