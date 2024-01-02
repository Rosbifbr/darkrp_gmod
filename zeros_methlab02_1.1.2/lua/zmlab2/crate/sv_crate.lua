if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Crate = zmlab2.Crate or {}

function zmlab2.Crate.Initialize(Crate)

    Crate.IsMerging = false

    Crate:SetMaxHealth( zmlab2.config.Damageable[Crate:GetClass()] )
    Crate:SetHealth(Crate:GetMaxHealth())

    zmlab2.EntityTracker.Add(Crate)

    timer.Simple(0.1,function()
		if IsValid(Crate) then
			zmlab2.Crate.Update(Crate)
		end
	end)
end

function zmlab2.Crate.OnRemove(Crate)
    zmlab2.EntityTracker.Remove(Crate)
    zmlab2.Timer.Remove("zmlab2_crate_open_" .. Crate:EntIndex())
end

function zmlab2.Crate.OnUse(Crate,ply)

    // Fixes the Xenin Pickup Exploit
	timer.Simple(0.1,function()
		if IsValid(Crate) and IsValid(ply) then
			zmlab2.Crate.Pickup(Crate,ply)
		end
	end)
end

function zmlab2.Crate.Pickup(Crate,ply)
    // If the crate got made invisible (because it collided with a palette) then stop
    if Crate:GetNoDraw() == true then return end

    local sellmode = zmlab2.NPC.GetSellMode(ply)
    if sellmode == 1 or sellmode == 3 then

        if zmlab2.Player.CanInteract(ply, Crate) == false then
            return
        end

        if Crate:GetMethAmount() <= 0 then
            zmlab2.Notify(ply, zmlab2.language["CratePickupFail"], 1)
            return
        end

        if ply.zmlab2_MethList == nil then
            ply.zmlab2_MethList = {}
        end

        local data = {
            t = Crate:GetMethType(),
            a = Crate:GetMethAmount(),
            q = Crate:GetMethQuality()
        }

        table.insert(ply.zmlab2_MethList,data)

        local str = string.Replace(zmlab2.language["CratePickupSuccess"], "$MethAmount", math.Round(Crate:GetMethAmount()) .. zmlab2.config.UoM)
        str = string.Replace(str, "$MethName", zmlab2.config.MethTypes[Crate:GetMethType()].name)
        str = string.Replace(str, "$MethQuality", Crate:GetMethQuality())
        zmlab2.Notify(ply, str, 0)

        Crate:Remove()
    end
end

function zmlab2.Crate.OnStartTouch(Crate,other)
    if not IsValid(Crate) then return end
    if not IsValid(other) then return end
    if zmlab2.util.CollisionCooldown(other) then return end

    if other:GetClass() == "zmlab2_item_meth" then

        if zmlab2.Crate.AddMeth(Crate,other:GetMethType(),other:GetMethAmount(),other:GetMethQuality(),true) then

            Crate:SetBodygroup(1,1)
            local timerid = "zmlab2_crate_open_" .. Crate:EntIndex()
            zmlab2.Timer.Remove(timerid)
            zmlab2.Timer.Create(timerid,1,1,function()
                if IsValid(Crate) then Crate:SetBodygroup(1,0) end
                zmlab2.Timer.Remove(timerid)
            end)

            // Stop moving if you have physics
            if other.PhysicsDestroy then other:PhysicsDestroy() end

            // Hide entity
            if other.SetNoDraw then other:SetNoDraw(true) end

            // This got taken from a Physcollide function but maybe its needed to prevent a crash
            local deltime = FrameTime() * 2
            if not game.SinglePlayer() then deltime = FrameTime() * 6 end
            SafeRemoveEntityDelayed(other, deltime)
        end
    elseif other:GetClass() == "zmlab2_item_crate" then

        if other.IsMerging == true then return end
        if Crate.IsMerging == true then return end
        Crate.IsMerging = true
		timer.Simple(1,function() if IsValid(Crate) then Crate.IsMerging = false end end)

        zmlab2.Crate.Merge(Crate,other)
    end
end

function zmlab2.Crate.Update(Crate)
    local cur_amount = Crate:GetMethAmount()
    if cur_amount <= 0 then
        Crate:SetBodygroup(0,5)
    else
        local bg = math.Clamp(5 - math.Round((5 / zmlab2.config.Crate.Capacity) * cur_amount),1,5)

        Crate:SetBodygroup(0,bg)
    end
    return true
end

function zmlab2.Crate.AddMeth(Crate,MethType,MethAmount,MethQuality,PlayEffects)
    zmlab2.Debug("zmlab2.Crate.AddMeth")

    // If the methtype doesent match the one thats allready in the crate then stop
    if Crate:GetMethType() ~= -1 and Crate:GetMethType() ~= MethType then return false end

    // Is there still room in the crate?
    if Crate:GetMethAmount() >= zmlab2.config.Crate.Capacity then return false end

    if PlayEffects == true then zmlab2.NetEvent.Create("meth_fill", Crate:LocalToWorld(Vector(0,0,5)),MethType) end

    if Crate:GetMethAmount() <= 0 then
        Crate:SetMethType(MethType)
        Crate:SetMethAmount(Crate:GetMethAmount() + MethAmount)
        Crate:SetMethQuality(MethQuality)
    else
        // Calculate the average of the 2 qualitys according to the added amount

        local quality01 = Crate:GetMethQuality()
        local quality02 = MethQuality

        /*
        TODO You somehow got to Calculate a impact % so 1g 1% meth doesent impact 499g 99% meth that hard
        local amount01 = Crate:GetMethAmount()
        local amount02 = MethAmount

        local perc_amount = (1 / amount01) * amount02
        */

        local newQuality = math.Round((quality01 + quality02) / 2)
        Crate:SetMethAmount(Crate:GetMethAmount() + MethAmount)
        Crate:SetMethQuality(newQuality)
    end

    zmlab2.Crate.Update(Crate)
    return true
end

function zmlab2.Crate.Merge(CrateA,CrateB)
    zmlab2.Debug("zmlab2.Crate.Merge")
    // If the methtype doesent match the one thats allready in the crate then stop
    if CrateA:GetMethType() ~= -1 and CrateA:GetMethType() ~= CrateB:GetMethType() then return false end
    //if CrateB:GetMethType() ~= -1 and CrateB:GetMethType() ~= CrateA:GetMethType() then return false end


    local amountA = CrateA:GetMethAmount()
    local amountB = CrateB:GetMethAmount()

    if amountB <= 0 then return end

    if amountA >= zmlab2.config.Crate.Capacity then return end

    // The amount of space we have in CrateA
    local sAmount = zmlab2.config.Crate.Capacity - amountA

    // The Amount we can transfer
    local tAmount

    if sAmount >= amountB then
        tAmount = amountB
    else
        tAmount = sAmount
    end

    // If the transfer amount is more then the meth amount from CrateB then we remove CrateB
    if tAmount >= amountB then
        // Stop moving if you have physics
        if CrateB.PhysicsDestroy then CrateB:PhysicsDestroy() end

        // Hide entity
        if CrateB.SetNoDraw then CrateB:SetNoDraw(true) end

        // This got taken from a Physcollide function but maybe its needed to prevent a crash
        local deltime = FrameTime() * 2
        if not game.SinglePlayer() then deltime = FrameTime() * 6 end
        SafeRemoveEntityDelayed(CrateB, deltime)
    else

        // Here we average out the quality level of both crates
        local avg_qual = CrateA:GetMethQuality() + CrateB:GetMethQuality()
        avg_qual = math.floor(avg_qual / 2)
        CrateA:SetMethQuality(avg_qual)
        CrateB:SetMethQuality(avg_qual)

        CrateB:SetMethType(CrateA:GetMethType())
        CrateB:SetMethAmount(amountB - tAmount)
        CrateB:SetMethQuality(avg_qual)
        zmlab2.Crate.Update(CrateB)
    end

    zmlab2.Crate.AddMeth(CrateA,CrateB:GetMethType(),tAmount,CrateB:GetMethQuality(),true)
end

zmlab2.Hook.Add("GravGunOnDropped", "Crate", function(ply, ent)
    if IsValid(ent) and ent:GetClass() == "zmlab2_item_crate" then
        local ang = ply:GetAngles()
        ent:SetAngles(Angle(0, ang.y, 0))
    end
end)

concommand.Add("zmlab2_debug_Crate_Test", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr.Hit then

            local ent = ents.Create("zmlab2_item_crate")
            if not IsValid(ent) then return end
            ent:SetPos(tr.HitPos)
            ent:Spawn()
            ent:Activate()

            zmlab2.Crate.AddMeth(ent,math.random(#zmlab2.config.MethTypes),zmlab2.config.Crate.Capacity,100,false)
            //zmlab2.Crate.AddMeth(ent,1,math.random(zmlab2.config.Crate.Capacity),100,false)

            zmlab2.Player.SetOwner(ent, ply)
        end
    end
end)
