if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Table = zmlab2.Table or {}

/*
        Table:GetProcessState()
            0 = Need Crate
            1 = Need Tray
            2 = Need Pack Input
*/

function zmlab2.Table.Initialize(Table)
    zmlab2.EntityTracker.Add(Table)

    if zmlab2.config.Equipment.PlayerCollide == false then
        Table:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end

    Table:SetTrigger(true)

    Table:SetMaxHealth( zmlab2.config.Damageable[Table:GetClass()] )
    Table:SetHealth(Table:GetMaxHealth())

    Table.HasAutoBreaker = false

    Table.TrayQueue = {}
end

function zmlab2.Table.OnRemove(Table)
    zmlab2.Timer.Remove("zmlab2_table_autobreaker_startdelay_" .. Table:EntIndex())
    zmlab2.Timer.Remove("zmlab2_table_autobreaker_main_" .. Table:EntIndex())
end

function zmlab2.Table.OnStartTouch(Table,other)
    if not IsValid(Table) then return end
    if not IsValid(other) then return end
    if zmlab2.util.CollisionCooldown(other) then return end
    if Table.IsBusy == true then return end

    if other:GetClass() == "zmlab2_item_crate" and not IsValid(Table:GetCrate()) and other:GetMethAmount() < zmlab2.config.Crate.Capacity then

        if other.LastDrop and other.LastDrop > CurTime() then return end
        zmlab2.Table.AddCrate(Table,other)
    end

    if other:GetClass() == "zmlab2_item_frezzertray" and other:GetProcessState() == 2 then

        local cur_tray = Table:GetTray()
        if not IsValid(cur_tray) then
            zmlab2.Table.AddTray(Table,other)
        else

            if cur_tray:GetProcessState() == 0 then
                zmlab2.Table.DropTray(Table)
                zmlab2.Table.AddTrayToQueue(Table, cur_tray)
                zmlab2.Table.AddTray(Table,other)
            else
                zmlab2.Table.AddTrayToQueue(Table, other)
            end
        end

        zmlab2.Table.AutoBreaker_Check(Table)
    end

    if other:GetClass() == "zmlab2_item_autobreaker" and Table.HasAutoBreaker == false then
        zmlab2.Table.InstallAutoBreaker(Table,other)
    end
end

///////////////////////////////////////////////////

function zmlab2.Table.InstallAutoBreaker(Table,kit)
    zmlab2.Debug("zmlab2.Table.InstallAutoBreaker")
    Table.HasAutoBreaker = true

    DropEntityIfHeld(kit)

    // Enable autocracker
    Table:SetBodygroup(0,1)
    Table:SetBodygroup(1,1)
    Table:SetBodygroup(2,1)

    // Stop moving if you have physics
    if kit.PhysicsDestroy then kit:PhysicsDestroy() end

    // Hide entity
    if kit.SetNoDraw then kit:SetNoDraw(true) end

    // This got taken from a Physcollide function but maybe its needed to prevent a crash
    local deltime = FrameTime() * 2
    if not game.SinglePlayer() then deltime = FrameTime() * 6 end
    SafeRemoveEntityDelayed(kit, deltime)

    zmlab2.Sound.EmitFromEntity("crate_place", Table)

    zmlab2.Table.AutoBreaker_Check(Table)
end

// Checks if we can start breaking ice, delayed
function zmlab2.Table.AutoBreaker_Check(Table)
    zmlab2.Debug("zmlab2.Table.AutoBreaker_Check")
    // We are currently autobreaking
    if Table:GetIsAutobreaking() == true then return end

    Table:SetIsAutobreaking(false)

    if Table.HasAutoBreaker == false then return end
    if zmlab2.Table.CanTransfer(Table) == false then return end

    zmlab2.Timer.Remove("zmlab2_table_autobreaker_main_" .. Table:EntIndex())

    local timerid = "zmlab2_table_autobreaker_startdelay_" .. Table:EntIndex()
    zmlab2.Timer.Remove(timerid)

    zmlab2.Timer.Create(timerid,3,1,function()
        if IsValid(Table) then
            zmlab2.Table.AutoBreaker_Start(Table)
        end
        zmlab2.Timer.Remove(timerid)
    end)
end

function zmlab2.Table.AutoBreaker_Start(Table)
    zmlab2.Debug("zmlab2.Table.AutoBreaker_Start")
    Table:SetIsAutobreaking(true)

    local timerid = "zmlab2_table_autobreaker_main_" .. Table:EntIndex()
    zmlab2.Timer.Remove(timerid)
    zmlab2.Timer.Create(timerid,zmlab2.config.Packing.Auto_IceBreak_Interval,0,function()
        if IsValid(Table) then

            local tray = Table:GetTray()

            if not IsValid(tray) then
                zmlab2.Timer.Remove(timerid)
                Table:SetIsAutobreaking(false)
                return
            end

            local _state = zmlab2.FrezzerTray.GetState(tray)

            if _state == 2 or _state == 3 then
                zmlab2.FrezzerTray.BreakIce(tray,nil)
            else
                zmlab2.Timer.Remove(timerid)
                Table:SetIsAutobreaking(false)
            end
        else
            zmlab2.Timer.Remove(timerid)
        end
    end)
end
///////////////////////////////////////////////////

function zmlab2.Table.AddCrate(Table,crate)
    zmlab2.Debug("zmlab2.Table.AddCrate")

    zmlab2.Timer.Remove("zmlab2_crate_open_" .. crate:EntIndex())

    Table:SetCrate(crate)
    DropEntityIfHeld(crate)

    crate.PhysgunDisabled = true

    crate:SetMoveType(MOVETYPE_NONE)

    crate:SetParent(Table)

    crate:SetPos(Table:LocalToWorld(Vector(13,0,36.3)))
    crate:SetAngles(Table:LocalToWorldAngles(angle_zero))

    crate:SetBodygroup(1,1)

    zmlab2.Sound.EmitFromEntity("crate_place", crate)

    zmlab2.Table.AutoBreaker_Check(Table)
end

function zmlab2.Table.DropCrate(Table)
    zmlab2.Debug("zmlab2.Table.DropCrate")

    local crate = Table:GetCrate()
    crate:SetParent(nil)
    crate:SetPos(Table:LocalToWorld(Vector(13,35,36.3)))
    crate:SetAngles(Table:LocalToWorldAngles(angle_zero))

    crate:PhysicsInit(SOLID_VPHYSICS)
    crate:SetSolid(SOLID_VPHYSICS)
    crate:SetMoveType(MOVETYPE_VPHYSICS)
    crate:SetUseType(SIMPLE_USE)
    crate:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    crate:SetBodygroup(1,0)

    local phys = crate:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(true)
    end

    crate.PhysgunDisabled = false

    crate.LastDrop = CurTime() + 1


    Table:SetCrate(NULL)

    zmlab2.Sound.EmitFromEntity("crate_place", crate)

    zmlab2.Table.AutoBreaker_Check(Table)
end

///////////////////////////////////////////////////

// Add Tray to the Queu first and then give it to NetVar if space is free
function zmlab2.Table.AddTrayToQueue(Table, tray)
    zmlab2.Debug("zmlab2.Table.AddTrayToQueue")

    local Result, TrayPos = false

    for i = 1, 12 do
        if not IsValid(Table.TrayQueue[i]) then

            DropEntityIfHeld(tray)

            Table.TrayQueue[i] = tray

            tray:SetMoveType(MOVETYPE_NONE)

            local attach = Table:GetAttachment(i)
            tray:SetPos(attach.Pos)
            tray:SetAngles(attach.Ang)
            tray:SetParent(Table, i)
            tray.PhysgunDisabled = true
            zmlab2.Player.SetOwner(tray, zmlab2.Player.GetOwner(Table))

            zmlab2.Sound.EmitFromEntity("tray_addqueue", Table)

            Result = true
            TrayPos = i
            break
        end
    end

    return Result, TrayPos
end

function zmlab2.Table.CatchTrayFromQueue(Table)
    zmlab2.Debug("zmlab2.Table.CatchTrayFromQueue")
    local tray , trayID

    // Search for a tray that needs to get broken, if you cant find one then return a empty one
    for i = 1, 12 do

        // Did we find a valid tray?
        if IsValid(Table.TrayQueue[i]) then

            trayID = i
            tray = Table.TrayQueue[i]

            // If the tray we just needs to get broken then stop, else just keep go through the rest
            if Table.TrayQueue[i]:GetProcessState() == 2 then
                break
            end
        end
    end

    if trayID then
        Table.TrayQueue[trayID] = nil
    end

    return tray
end

// Returns how many trays are in the table
function zmlab2.Table.GetTrayCount(Table)
    zmlab2.Debug("zmlab2.Table.GetTrayCount")
    local count = 0

    // Search for a tray that needs to get broken, if you cant find one then return a empty one
    for i = 1, 12 do

        // Did we find a valid tray?
        if IsValid(Table.TrayQueue[i]) then

            count = count + 1
        end
    end

    return count
end

function zmlab2.Table.AddTray(Table,tray)
    zmlab2.Debug("zmlab2.Table.AddTray")
    Table:SetTray(tray)
    DropEntityIfHeld(tray)

    tray:SetMoveType(MOVETYPE_NONE)

    tray:SetParent(Table)

    tray.PhysgunDisabled = true

    zmlab2.Sound.EmitFromEntity("tray_add", Table)

    tray:SetPos(Table:LocalToWorld(Vector(-12,1,36.3)))
    tray:SetAngles(Table:LocalToWorldAngles(angle_zero))
end

function zmlab2.Table.DropTray(Table)
    zmlab2.Debug("zmlab2.Table.DropTray")
    local tray = Table:GetTray()

    tray:SetParent(nil)
    tray:SetPos(Table:LocalToWorld(Vector(-13,30,36.3)))
    tray:SetAngles(Table:LocalToWorldAngles(angle_zero))

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

    zmlab2.Sound.EmitFromEntity("tray_drop", Table)

    tray.PhysgunDisabled = false

    Table:SetTray(NULL)

    zmlab2.Table.AutoBreaker_Check(Table)
end

///////////////////////////////////////////////////

function zmlab2.Table.CanTransfer(Table)
    zmlab2.Debug("zmlab2.Table.CanTransfer")
    local tray = Table:GetTray()
    if not IsValid(tray) then
        zmlab2.Debug("No Tray found")
        return false
    end
    local t_Type = tray:GetMethType()

    local crate = Table:GetCrate()
    if not IsValid(crate) then
        zmlab2.Debug("No Crate found")
        return false
    end
    local c_Type = crate:GetMethType()

    // If the methtype doesent match the one thats allready in the crate then stop
    if c_Type ~= -1 and c_Type ~= t_Type then
        zmlab2.Debug("MethType mismatch")
        return false
    end

    return true
end

// Moves the meth from the tray to the crate
function zmlab2.Table.TransferMeth(Table)
    zmlab2.Debug("zmlab2.Table.TransferMeth")
    local tray = Table:GetTray()
    local t_Type,t_Amount,t_Quality = tray:GetMethType(),tray:GetMethAmount(),tray:GetMethQuality()

    local crate = Table:GetCrate()
    local c_Type = crate:GetMethType()

    // If the methtype doesent match the one thats allready in the crate then stop
    if c_Type ~= -1 and c_Type ~= t_Type then return end

    // Add the meth to the crate
    zmlab2.Crate.AddMeth(crate,t_Type,t_Amount,t_Quality,true)

    zmlab2.FrezzerTray.Reset(tray)

    // Catch the next tray from the queue that needs to get broken
    local NextTray = zmlab2.Table.CatchTrayFromQueue(Table)

    if IsValid(NextTray) then
        local Result = zmlab2.Table.AddTrayToQueue(Table, tray)
        if Result then
            // If we could add the tray to the queue then empty the net var
            Table:SetTray(NULL)
        else
            // Else just drop the tray
            zmlab2.Table.DropTray(Table)
        end

        zmlab2.Table.AddTray(Table,NextTray)
    end

    if crate:GetMethAmount() >= zmlab2.config.Crate.Capacity then
        timer.Simple(1,function() if IsValid(Table) then zmlab2.Table.DropCrate(Table) end end)
    end
end

function zmlab2.Table.SetBusy(Table,time)
    Table.IsBusy = true
    timer.Simple(time,function()
        if IsValid(Table) then
            Table.IsBusy = false
        end
    end)
end

function zmlab2.Table.OnUse(Table, ply)
    if Table.IsBusy == true then return end

    if zmlab2.Player.CanInteract(ply, Table) == false then return end

    if Table:GetIsAutobreaking() == true then return end

    local _state = zmlab2.Table.GetState(Table)

    if Table:OnDrop_Crate(ply) and IsValid(Table:GetCrate()) then
        zmlab2.Table.DropCrate(Table)
    end

    if Table:OnDrop_Tray(ply) and IsValid(Table:GetTray()) then

        zmlab2.Table.DropTray(Table)

        // Catch the next tray from the queue that needs to get broken
        local NextTray = zmlab2.Table.CatchTrayFromQueue(Table)
        if IsValid(NextTray) then
            zmlab2.Table.AddTray(Table,NextTray)
        end
    end
end

function zmlab2.Table.GetState(Table)
    return Table:GetProcessState()
end


concommand.Add("zmlab2_debug_Packing_SpawnTrays", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then
        local tr = ply:GetEyeTrace()

        if tr.Hit and tr.HitPos then
            undo.Create("zmlab2_debug_Packing_SpawnTrays")

            for i = 1, 5 do
                local ent = ents.Create("zmlab2_item_frezzertray")
                if not IsValid(ent) then return end
                ent:SetPos(tr.HitPos + Vector(30, 30 * i, 10))
                ent:SetAngles(angle_zero)
                ent:Spawn()
                ent:Activate()
                ent:SetColor(zmlab2.config.MethTypes[2].color)
                ent:SetBodygroup(0, 1)
                ent:SetMethAmount(100)
                ent:SetMethType(2)
                ent:SetMethQuality(100)
                zmlab2.FrezzerTray.FrezzeLiquid(ent)
                local phys = ent:GetPhysicsObject()

                if IsValid(phys) then
                    phys:Wake()
                    phys:EnableMotion(true)
                end

                undo.AddEntity(ent)
            end

            undo.SetPlayer(ply)
            undo.Finish()
        end
    end
end)
