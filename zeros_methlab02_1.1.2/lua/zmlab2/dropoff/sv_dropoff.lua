if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Dropoff = zmlab2.Dropoff or {}

zmlab2.Dropoff.List = zmlab2.Dropoff.List or {}

function zmlab2.Dropoff.Initialize(Dropoff)
    zmlab2.EntityTracker.Add(Dropoff)
    table.insert(zmlab2.Dropoff.List,Dropoff)
end

function zmlab2.Dropoff.OnRemove(Dropoff)
    if Dropoff.timerid then zmlab2.Timer.Remove(Dropoff.timerid) end
end

function zmlab2.Dropoff.OnUse(Dropoff,ply)
    zmlab2.Debug("zmlab2.Dropoff.OnUse")

    if zmlab2.Player.IsMethCook(ply) == false then
        zmlab2.Notify(ply, zmlab2.language["Interaction_Fail_Job"], 1)
        return
    end

    if ply ~= Dropoff.Deliver_Player then
        zmlab2.Notify(ply, zmlab2.language["Interaction_Fail_Dropoff"], 1)
        return
    end

    if zmlab2.NPC.GetSellMode(ply) ~= 3 then return end
    if zmlab2.Player.HasMeth(ply) == false then return end

    zmlab2.Dropoff.SellMeth(Dropoff, ply)
end

// Called when meth gets sold via use
function zmlab2.Dropoff.SellMeth(Dropoff,ply)
    if not IsValid(Dropoff) then return end

    zmlab2.NetEvent.Create("sell", ply:GetPos())
    zmlab2.NPC.SellMeth(ply,ply.zmlab2_MethList)
    ply.zmlab2_MethList = {}

    zmlab2.Timer.Remove(Dropoff.timerid)
    zmlab2.Dropoff.Close(Dropoff)
end

function zmlab2.Dropoff.OnStartTouch(Dropoff, other)
    if not IsValid(Dropoff) then return end
    if not IsValid(other) then return end
    if zmlab2.util.CollisionCooldown(other) then return end

    if Dropoff:GetIsClosed() == true then return end
    if not IsValid(Dropoff.Deliver_Player) then return end


    if other:GetClass() == "zmlab2_item_palette" and table.Count(other.MethList) > 0 then
        zmlab2.Dropoff.Sell(Dropoff, other, other.MethList)
    elseif other:GetClass() == "zmlab2_item_crate" and other:GetMethAmount() > 0 then
        zmlab2.Dropoff.Sell(Dropoff, other, {
            [1] = {t = other:GetMethType(),
            a = other:GetMethAmount(),
            q = other:GetMethQuality()}
        })
    end
end

function zmlab2.Dropoff.Sell(Dropoff,MethEnt,MethList)
    DropEntityIfHeld(MethEnt)

    zmlab2.NetEvent.Create("sell", MethEnt:GetPos())

    // Stop moving if you have physics
    if MethEnt.PhysicsDestroy then MethEnt:PhysicsDestroy() end

    // Hide entity
    if MethEnt.SetNoDraw then MethEnt:SetNoDraw(true) end

    // This got taken from a Physcollide function but maybe its needed to prevent a crash
    local deltime = FrameTime() * 2
    if not game.SinglePlayer() then deltime = FrameTime() * 6 end
    SafeRemoveEntityDelayed(MethEnt, deltime)

    local ply = zmlab2.Player.GetOwner(MethEnt)
    if IsValid(ply) then zmlab2.NPC.SellMeth(ply,MethList) end

    if Dropoff.timerid then zmlab2.Timer.Remove(Dropoff.timerid) end
    zmlab2.Dropoff.Close(Dropoff)
end

// Returns a dropoff point thats currently not used by anyone
function zmlab2.Dropoff.FindUnused()
    zmlab2.Debug("zmlab2.Dropoff.FindUnused")

    local UnUsedDropOffs = {}

    for k, v in pairs(zmlab2.Dropoff.List) do
        if IsValid(v) and not IsValid(v.Deliver_Player) then
            table.insert(UnUsedDropOffs, v)
        end
    end

    if (table.Count(UnUsedDropOffs) > 0) then
        return UnUsedDropOffs[math.random(#UnUsedDropOffs)]
    end
end

// Is the player allowed do get another droppoff point or is there still a cooldown to wait
function zmlab2.Dropoff.Request(ply)
    zmlab2.Debug("zmlab2.Dropoff.Request")
    if (ply.zmlab2_NextDropoffRequest == nil or ply.zmlab2_NextDropoffRequest < CurTime()) then
        return true
    else
        zmlab2.Notify(ply, zmlab2.language["Dropoff_cooldown"] .. " " .. zmlab2.util.FormatTime(math.Round(ply.zmlab2_NextDropoffRequest - CurTime())), 1)
        return false
    end
end

// Assigns a dropoff point to a player
function zmlab2.Dropoff.Assign(Dropoff,ply)
    zmlab2.Debug("zmlab2.Dropoff.Assign")

    zmlab2.Dropoff.Open(Dropoff, ply)

    zmlab2.Notify(ply, zmlab2.language["Dropoff_assinged"], 0)

    hook.Run("zmlab2_OnDropOffPoint_Assigned", dropoffpoint,ply)
end


util.AddNetworkString("zmlab2_DropOff_AddHint")
util.AddNetworkString("zmlab2_DropOff_RemoveHint")
function zmlab2.Dropoff.Open(Dropoff, ply)
    zmlab2.Debug("zmlab2.Dropoff.Assign")

    net.Start("zmlab2_DropOff_AddHint")
    net.WriteVector(Dropoff:GetPos())
    net.Send(ply)

    Dropoff.Deliver_Player = ply
    ply.zmlab2_Dropoff = Dropoff

    Dropoff:SetIsClosed(false)

    local timerid = Dropoff:EntIndex() .. "_Dropoff_AutoCloseTimer_" .. ply:SteamID64()
    Dropoff.timerid = timerid
    zmlab2.Timer.Create(timerid,zmlab2.config.DropOffPoint.DeliverTime,1,function()
        if IsValid(Dropoff) then
            zmlab2.Dropoff.Close(Dropoff)
        end
        zmlab2.Timer.Remove(timerid)
    end)
end

function zmlab2.Dropoff.Close(Dropoff)
    zmlab2.Debug("zmlab2.Dropoff.Close")

    if IsValid(Dropoff.Deliver_Player) then
        net.Start("zmlab2_DropOff_RemoveHint")
        net.Send(Dropoff.Deliver_Player)

        Dropoff.Deliver_Player.zmlab2_Dropoff = nil
    end

    Dropoff.Deliver_Player = nil

    Dropoff:SetIsClosed(true)
end


concommand.Add("zmlab2_debug_Dropoff_Test", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmlab2_dropoff" then
            tr.Entity:SetIsClosed(false)
        end
    end
end)
