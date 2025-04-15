if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.NPC = zmlab2.NPC or {}

function zmlab2.NPC.Initialize(NPC)
    NPC:SetModel(zmlab2.config.NPC.Model)
    NPC:SetSolid(SOLID_BBOX)
    NPC:SetHullSizeNormal()
    NPC:SetNPCState(NPC_STATE_SCRIPT)
    NPC:SetHullType(HULL_HUMAN)
    NPC:SetUseType(SIMPLE_USE)

    NPC:CapabilitiesAdd(CAP_ANIMATEDFACE)
    NPC:CapabilitiesAdd(CAP_TURN_HEAD)

    zmlab2.EntityTracker.Add(NPC)
end

function zmlab2.NPC.OnRemove(NPC)

end

function zmlab2.NPC.OnUse(NPC,ply)

    if zmlab2.Player.IsMethCook(ply) == false then
        zmlab2.Notify(ply, zmlab2.language["NPC_InteractionFail01"], 1)
        NPC:EmitSound("zmlab2_npc_wrongjob")
        return
    end

    // Fixes the Xenin Pickup and Sell Exploit
	timer.Simple(0.2,function()
		if IsValid(NPC) and IsValid(ply) then
			zmlab2.NPC.SellSystem(NPC, ply)
		end
	end)
end

// Returns the sellmode the player has
function zmlab2.NPC.GetSellMode(ply)
    local custom_sellmode = hook.Run("zmlab2_GetSellMode", ply)

    if custom_sellmode == nil then
        custom_sellmode = zmlab2.config.NPC.SellMode
    end

    return custom_sellmode
end

// This performs the Core Logic of the Meth Selling
function zmlab2.NPC.SellSystem(NPC, ply)

    if zmlab2.Player.IsMethCook(ply) == false then
        return
    end

    local sellmode = zmlab2.NPC.GetSellMode(ply)

    //1 = Methcrates can be absorbed by Players and sold by the MethBuyer on use
    if (sellmode == 1) then
        if zmlab2.Player.HasMeth(ply) then
            zmlab2.NetEvent.Create("sell", ply:GetPos())
            zmlab2.NPC.SellMeth(ply,ply.zmlab2_MethList)
            ply.zmlab2_MethList = {}
            NPC:EmitSound("zmlab2_npc_sell")
        else
            zmlab2.Notify(ply, zmlab2.language["NPC_InteractionFail02"], 1)
        end

    // 2 = Methcrates cant be absorbed and the MethBuyer tells you a dropoff point instead
    elseif sellmode == 2 then

        // Remind him of his current dropoff point
        if IsValid(zmlab2.Player.GetDropoff(ply)) then
            return
        end

        if zmlab2.Dropoff.Request(ply) == false then return end

        local Dropoff = zmlab2.Dropoff.FindUnused()
        if IsValid(Dropoff) then
            NPC:EmitSound("zmlab2_npc_sell")
            ply.zmlab2_NextDropoffRequest = CurTime() + zmlab2.config.DropOffPoint.DeliverRequest_CoolDown
            zmlab2.Dropoff.Assign(Dropoff,ply)
        else
            zmlab2.Notify(ply, zmlab2.language["NPC_InteractionFail03"], 1)
        end

    // 3 = Methcrates can be absorbed and the MethBuyer tells you a dropoff point
    elseif sellmode == 3 then

        // Remind him of his current dropoff point
        if IsValid(zmlab2.Player.GetDropoff(ply)) then
            zmlab2.Notify(ply, "You already have a DropOff point assigned", 1)
            return
        end

        if zmlab2.Dropoff.Request(ply) == false then return end
        if zmlab2.Player.HasMeth(ply) == false then
            zmlab2.Notify(ply, zmlab2.language["NPC_InteractionFail02"], 1)
            return
        end

        local Dropoff = zmlab2.Dropoff.FindUnused()
        if IsValid(Dropoff) then
            NPC:EmitSound("zmlab2_npc_sell")
            ply.zmlab2_NextDropoffRequest = CurTime() + zmlab2.config.DropOffPoint.DeliverRequest_CoolDown
            zmlab2.Dropoff.Assign(Dropoff,ply)
        end

    // 4 = Methcrates need to be moved to the MethBuyer and sold directly by him
    elseif sellmode == 4 then

        local MethList = {}
        for k, v in pairs(zmlab2.EntityTracker.GetList()) do
            if not IsValid(v) then continue end
            if zmlab2.util.InDistance(ply:GetPos(), v:GetPos(), 250) == false then continue end

            if v:GetClass() == "zmlab2_item_crate" and v:GetMethAmount() > 0 then

                local data = {
                    t = v:GetMethType(),
                    a = v:GetMethAmount(),
                    q = v:GetMethQuality()
                }

                table.insert(MethList,data)
                zmlab2.NetEvent.Create("sell", v:GetPos())
                SafeRemoveEntity(v)

            elseif v:GetClass() == "zmlab2_item_palette" and v.MethList and table.Count(v.MethList) > 0 then

                table.Add(MethList,v.MethList)
                zmlab2.NetEvent.Create("sell", v:GetPos())
                SafeRemoveEntity(v)

            end
        end

        if table.Count(MethList) <= 0 then
            zmlab2.Notify(ply, zmlab2.language["NPC_InteractionFail02"], 1)
            return
        end

        NPC:EmitSound("zmlab2_npc_sell")

        zmlab2.NPC.SellMeth(ply,MethList)
    end
end

// This handles the main sell action
function zmlab2.NPC.SellMeth(ply,MethList)

    // Calculate meth price
    local Earning = 0
    for k,v in pairs(MethList) do
        Earning = Earning + zmlab2.Meth.GetValue(v.t,v.a,v.q)
    end

    // Add Rank multiplicator
    Earning = Earning * ( zmlab2.config.NPC.SellRanks[zmlab2.Player.GetRank(ply)] or zmlab2.config.NPC.SellRanks["default"])

    // Run custom hook
    Earning = hook.Run("zmlab2_PreMethSell", ply, Earning)

    // Give the player the Cash
    zmlab2.Money.Give(ply, Earning)

    // Notify the player
    zmlab2.Notify(ply, "+" .. zmlab2.Money.Display(math.Round(Earning)), 0)

    // Informs the police
    zmlab2.NPC.AlarmPolice(ply)
end

// Informs the police that the player just sold meth
function zmlab2.NPC.AlarmPolice(ply)
    if zmlab2.config.Police.WantedOnMethSell == false then return end

    zmlab2.Police.MakeWanted(ply,zmlab2.language["PoliceWanted"],120)
end
