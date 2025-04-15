if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Equipment = zmlab2.Equipment or {}

function zmlab2.Equipment.Initialize(Equipment)
    zmlab2.EntityTracker.Add(Equipment)
end

function zmlab2.Equipment.OnRemove(Equipment)

end

function zmlab2.Equipment.OnUse(Equipment, ply)

    if zmlab2.Player.CanInteract(ply, Equipment) == false then return end

    if Equipment:OnRepair(ply) then
        net.Start("zmlab2_Equipment_Repair")
        net.WriteEntity(Equipment)
        net.Send(ply)
    end

    if zmlab2.config.Equipment.RepairOnly == true then return end

    if Equipment:OnBuild(ply) then
        zmlab2.Equipment.OpenInterface(Equipment, ply)
    elseif Equipment:OnMove(ply) then
        net.Start("zmlab2_Equipment_Move")
        net.WriteEntity(Equipment)
        net.Send(ply)
    elseif Equipment:OnRemoveButton(ply) then
        net.Start("zmlab2_Equipment_Deconstruct")
        net.WriteEntity(Equipment)
        net.Send(ply)
    end
end

util.AddNetworkString("zmlab2_Equipment_OpenInterface")
function zmlab2.Equipment.OpenInterface(Equipment,ply)
    net.Start("zmlab2_Equipment_OpenInterface")
    net.WriteEntity(Equipment)
    net.Send(ply)
end

util.AddNetworkString("zmlab2_Equipment_Place")
net.Receive("zmlab2_Equipment_Place", function(len,ply)
    zmlab2.Debug_Net("zmlab2_Equipment_Place",len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Equipment = net.ReadEntity()
    local Tent = net.ReadEntity()
    local AttachID = net.ReadInt(16)
    local BuildPos = net.ReadVector()
    local BuildAng = net.ReadAngle()
    local EquipmentID = net.ReadUInt(16)

    if zmlab2.config.Equipment.RepairOnly == true then return end

    if not IsValid(Equipment) then return end

    if zmlab2.config.Equipment.RestrictToTent == true and not IsValid(Tent) then return end

    // Run a distance check on EquipmentBox and BuildPos
    if zmlab2.util.InDistance(ply:GetPos(), Equipment:GetPos(), 1000) == false then return end
    if BuildPos and zmlab2.util.InDistance(ply:GetPos(), BuildPos, 1000) == false then return end

    if zmlab2.Player.CanInteract(ply, Equipment) == false then return end
    if IsValid(Tent) and zmlab2.Player.CanInteract(ply, Tent) == false then return end

    zmlab2.Equipment.Place(Equipment,Tent,ply,AttachID,EquipmentID,BuildPos,BuildAng)
end)
function zmlab2.Equipment.LimitCheck(ply,ItemID)
    local EquipmentData = zmlab2.config.Equipment.List[ItemID]
    local class = EquipmentData.class
    local limit = hook.Run("zmlab2_Equipment_GetItemLimit",ply,ItemID) or EquipmentData.limit

    local count = 0
    for k, v in pairs(zmlab2.EntityTracker.GetList()) do
        if IsValid(v) and v:GetClass() == class and zmlab2.Player.IsOwner(ply, v) then
            count = count + 1
        end
    end

    if count >= limit then
        return false
    else
        return true
    end
end
function zmlab2.Equipment.Place(Equipment,Tent,ply,AttachID,EquipmentID,BuildPos,BuildAng)
    if AttachID == nil then return end
    if BuildPos == nil then return end
    if BuildAng == nil then return end

    // First attach is for UI so ignore that
    if AttachID == 1 then return end

    local EquipmentData = zmlab2.config.Equipment.List[EquipmentID]
    if EquipmentData == nil then return end

    // Can the player build any more of this machine?
    if zmlab2.Equipment.LimitCheck(ply,EquipmentID) == false then
        local str = zmlab2.language["ItemLimit"]
        str = string.Replace(str,"$ItemName",EquipmentData.name)
        zmlab2.Notify(ply, str, 1)
        return
    end

    // Where are we bulding?
    local pos,ang
    if zmlab2.config.Equipment.RestrictToTent == true then
        local Attach = Tent:GetAttachment(AttachID)
        if Attach == nil then return end
        pos = Attach.Pos
        ang = Attach.Ang
    else
        pos = BuildPos
        ang = BuildAng
    end
    if pos == nil or ang == nil then return end

    // Is some player in the way?
    if zmlab2.Equipment.AreaOccupied(pos) then return end

    if zmlab2.Money.Has(ply, EquipmentData.price) == false then
        zmlab2.Notify(ply, zmlab2.language["NotEnoughMoney"], 1)

        return
    end

    local ent = ents.Create(EquipmentData.class)
    if not IsValid(ent) then return end
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:Spawn()
    ent:Activate()

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
    end

    //debugoverlay.Sphere(ent:GetPos(),15,5,Color( 255, 125, 0 ),true)

    // Here we create a connection between those two entities so they know each other
    if ent.Tent then ent.Tent.ConnectedEnts[ent] = nil end
    if IsValid(Tent) then
        ent.Tent = Tent
        Tent.ConnectedEnts[ent] = true
    end

    ent.PhysgunDisabled = zmlab2.config.Equipment.PhysgunDisabled

    zmlab2.Hook.SimulateBuy(ply,ent,EquipmentData.name,EquipmentData.price)

    zmlab2.Money.Take(ply, EquipmentData.price)
    zmlab2.Notify(ply, "-" .. zmlab2.Money.Display(math.Round(EquipmentData.price)), 0)

    zmlab2.Player.SetOwner(ent, ply)
    zmlab2.Sound.EmitFromEntity("cash", ent)
end


util.AddNetworkString("zmlab2_Equipment_Deconstruct")
net.Receive("zmlab2_Equipment_Deconstruct", function(len,ply)
    zmlab2.Debug_Net("zmlab2_Equipment_Deconstruct",len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()

    if zmlab2.config.Equipment.RepairOnly == true then return end

    if not IsValid(Machine) then return end
    if zmlab2.Equipment_Classes[Machine:GetClass()] == nil then return end

    if zmlab2.Player.CanInteract(ply, Machine) == false then return end

    if zmlab2.Player.IsAdmin(ply) == false and zmlab2.Player.CanInteract(ply, Machine) == false then return end

    if zmlab2.config.Equipment.Refund > 0 then
        local refund_money = zmlab2.config.Equipment.List[zmlab2.Equipment_Classes[Machine:GetClass()]].price * zmlab2.config.Equipment.Refund
        if refund_money > 0 then

            zmlab2.Sound.EmitFromPosition(Machine:GetPos(),"cash")

            // Give the player the Cash
            zmlab2.Money.Give(ply, refund_money)

            // Notify the player
            zmlab2.Notify(ply, "+" .. zmlab2.Money.Display(math.Round(refund_money)), 0)
        end
    end

    SafeRemoveEntity(Machine)
end)


util.AddNetworkString("zmlab2_Equipment_Move")
net.Receive("zmlab2_Equipment_Move", function(len,ply)
    zmlab2.Debug_Net("zmlab2_Equipment_Move",len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    local Tent = net.ReadEntity()
    local AttachID = net.ReadInt(16)
    local BuildPos = net.ReadVector()
    local BuildAng = net.ReadAngle()

    if zmlab2.config.Equipment.RepairOnly == true then return end

    if not IsValid(Machine) then return end
    if zmlab2.config.Equipment.RestrictToTent == true and not IsValid(Tent) then return end

    // Run a distance check on EquipmentBox and BuildPos
    if zmlab2.util.InDistance(ply:GetPos(), Machine:GetPos(), 1000) == false then return end
    if BuildPos and zmlab2.util.InDistance(ply:GetPos(), BuildPos, 1000) == false then return end

    if zmlab2.Player.CanInteract(ply, Machine) == false then return end
    if IsValid(Tent) and zmlab2.Player.CanInteract(ply, Tent) == false then return end

    zmlab2.Equipment.Move(Machine,Tent,ply,AttachID,BuildPos,BuildAng)
end)
function zmlab2.Equipment.Move(Machine,Tent,ply,AttachID,BuildPos,BuildAng)
    if AttachID == nil then return end
    if BuildPos == nil then return end
    if BuildAng == nil then return end

    // First attach is for UI so ignore that
    if AttachID == 1 then return end

    // Where are we bulding?
    local pos,ang
    if zmlab2.config.Equipment.RestrictToTent == true then
        local Attach = Tent:GetAttachment(AttachID)
        if Attach == nil then return end
        pos = Attach.Pos
        ang = Attach.Ang
    else
        pos = BuildPos
        ang = BuildAng
    end
    if pos == nil or ang == nil then return end

    // Is some player in the way?
    if zmlab2.Equipment.AreaOccupied(pos,Machine) then return end

    if zmlab2.Equipment_Classes[Machine:GetClass()] == nil then return end

    if zmlab2.Player.IsAdmin(ply) == false and zmlab2.Player.CanInteract(ply, Machine) == false then return end

    Machine:SetPos(pos)
    Machine:SetAngles(ang)

    Machine.PhysgunDisabled = zmlab2.config.Equipment.PhysgunDisabled

    // Here we create a connection between those two entities so they know each other
    if Machine.Tent then Machine.Tent.ConnectedEnts[Machine] = nil end
    if IsValid(Tent) then
        Machine.Tent = Tent
        Tent.ConnectedEnts[Machine] = true
    end

    zmlab2.Sound.EmitFromEntity("tray_drop", Machine)
end


util.AddNetworkString("zmlab2_Equipment_Repair")
net.Receive("zmlab2_Equipment_Repair", function(len,ply)
    zmlab2.Debug_Net("zmlab2_Equipment_Repair",len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    if not IsValid(Machine) then return end

    if zmlab2.Player.IsAdmin(ply) == false and zmlab2.Player.CanInteract(ply, Machine) == false then return end

    zmlab2.Sound.EmitFromEntity("cash", Machine)

    zmlab2.Damage.Repair(Machine)
end)
