if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Equipment = zmlab2.Equipment or {}

function zmlab2.Equipment.Initialize(Equipment) end
function zmlab2.Equipment.OnRemove(Equipment) end

function zmlab2.Equipment.DrawButton(Equipment,txt,y,IsHovered)

    local font = zmlab2.GetFont("zmlab2_font02")
    local txtSize = zmlab2.util.GetTextSize(txt,font)
    if txtSize > 220 then font = zmlab2.GetFont("zmlab2_font04") end


    draw.RoundedBox(0, -110, y-30, 220, 60, zmlab2.colors["black02"])

    if IsHovered then
        zmlab2.util.DrawOutlinedBox(-110, y-30, 220, 60, 4, zmlab2.colors["blue02"])
    else
        zmlab2.util.DrawOutlinedBox( -110, y-30, 220, 60, 4, color_white)
    end

    draw.SimpleText(txt,font,0,y,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function zmlab2.Equipment.DrawUI(Equipment)

    if zmlab2.util.InDistance(Equipment:GetPos(), LocalPlayer():GetPos(), 500) and zmlab2.Convar.Get("zmlab2_cl_drawui") == 1 then
        cam.Start3D2D(Equipment:LocalToWorld(Vector(0,13.5,40)), Equipment:LocalToWorldAngles(Angle(0,180,90)), 0.1)
            if zmlab2.config.Equipment.RepairOnly == false then
                zmlab2.Equipment.DrawButton(Equipment,zmlab2.language["Equipment_Build"],-70,Equipment:OnBuild(LocalPlayer()))
                zmlab2.Equipment.DrawButton(Equipment,zmlab2.language["Equipment_Move"],0,Equipment:OnMove(LocalPlayer()))
                zmlab2.Equipment.DrawButton(Equipment,zmlab2.language["Equipment_Remove"],140,Equipment:OnRemoveButton(LocalPlayer()))
            end
            zmlab2.Equipment.DrawButton(Equipment,zmlab2.language["Equipment_Repair"],70,Equipment:OnRepair(LocalPlayer()))
        cam.End3D2D()
    end
end

// Takes in the HitEntity of the trace and returns the Tent entity and a valid and free build attachment point
local function GetPlacementPos(HitEntity)
    local Tent,AttachID
    if IsValid(HitEntity) and HitEntity:GetClass() == "zmlab2_tent" then

        Tent = HitEntity

        local EquipmentData = zmlab2.config.Equipment.List[zmlab2.PointerSystem.Data.EquipmentID]

        for k,v in pairs(Tent:GetAttachments()) do

            //debugoverlay.Sphere(Tent:GetAttachment(v.id).Pos,5, 0.1, Color( 255, 255, 255 ), false )

            // If the attachment point not for building, not a nowall build attach and not set to some class then stop
            local attach_name = v.name
            if (string.sub(attach_name,1,6) ~= "build_" and string.sub(attach_name,1,6) ~= "nowall") and string.sub(attach_name,1,#EquipmentData.class) ~= EquipmentData.class then continue end

            if EquipmentData.class == "zmlab2_machine_ventilation" and string.sub(attach_name,1,6) == "nowall" then continue end

            local attach = Tent:GetAttachment(v.id)
            if attach == nil then continue end

            local pos = attach.Pos

            local InDistance = pos:DistToSqr(zmlab2.PointerSystem.Data.Pos) < (25 * 25)

            if InDistance == false then
                continue
            end

            if zmlab2.Equipment.AreaOccupied(pos) == false then
                AttachID = v.id
                zmlab2.PointerSystem.Data.Pos = pos
                zmlab2.PointerSystem.Data.Ang = attach.Ang
                break
            end
        end
    end
    return Tent,AttachID
end

local function CanPlace(Tent,AttachID)
    if zmlab2.config.Equipment.RestrictToTent == true then
        if not IsValid(Tent) or AttachID == nil then
            return false
        end
    else
        if zmlab2.PointerSystem.Data.Pos == nil or zmlab2.PointerSystem.Data.Ang == nil then
            return false
        end
    end

    if zmlab2.Equipment.AreaOccupied(zmlab2.PointerSystem.Data.Pos,zmlab2.PointerSystem.Data.Target) then
        return false
    end

    if not IsValid(Tent) and zmlab2.PointerSystem.Data.Pos and zmlab2.config.Equipment.RestrictToTent == false then
        zmlab2.PointerSystem.Data.Ang = (LocalPlayer():GetPos() - zmlab2.PointerSystem.Data.Pos):Angle()
        zmlab2.PointerSystem.Data.Ang:RotateAroundAxis(zmlab2.PointerSystem.Data.Ang:Up(),-90)
    end

    local aUp = zmlab2.PointerSystem.Data.Ang:Up()
    if not IsValid(zmlab2.PointerSystem.Data.HitEntity) then
        if (math.abs(aUp.x) > 0.2 or math.abs(aUp.y) > 0.2 or aUp.z < 0.7) then return false end
    else
        if zmlab2.PointerSystem.Data.HitEntity:GetClass() ~= "zmlab2_tent" then
            if (math.abs(aUp.x) > 0.2 or math.abs(aUp.y) > 0.2 or aUp.z < 0.7) then return false end
        end
    end


    return true
end

function zmlab2.Equipment.Place(Equipment,EquipmentID)
    zmlab2.Debug("zmlab2.Equipment.Place")

    zmlab2.PointerSystem.Start(Equipment,function()

        // OnInit
        zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["green01"]

        zmlab2.PointerSystem.Data.ActionName = zmlab2.language["Construct"]

        zmlab2.PointerSystem.Data.EquipmentID = EquipmentID

        // Overwride model if we got a EquipmentID
        local EquipmentData = zmlab2.config.Equipment.List[EquipmentID]
        zmlab2.PointerSystem.Data.ModelOverwrite = EquipmentData.model
    end,function()

        // OnLeftClick
        if not zmlab2.PointerSystem.Data.Target then return end

        // Can we build here?
        if CanPlace(zmlab2.PointerSystem.Data.Target.Tent,zmlab2.PointerSystem.Data.Target.AttachID) == false then return end

        //if not IsValid(zmlab2.PointerSystem.Data.Target.Tent) then return end
        //if zmlab2.PointerSystem.Data.Target.AttachID == nil then return end

        // Position detection done, send info to server and wait for further instructions
        net.Start("zmlab2_Equipment_Place")
        net.WriteEntity(zmlab2.PointerSystem.Data.From)
        net.WriteEntity(zmlab2.PointerSystem.Data.Target.Tent)
        net.WriteInt(zmlab2.PointerSystem.Data.Target.AttachID or -1,16)
        net.WriteVector(zmlab2.PointerSystem.Data.Pos)
        net.WriteAngle(zmlab2.PointerSystem.Data.Ang)
        net.WriteUInt(zmlab2.PointerSystem.Data.EquipmentID,16)
        net.SendToServer()

        zmlab2.PointerSystem.Stop()

        // Reopens the interface after we finished, if we wanna build something again
        zmlab2.Equipment.OpenInterface()
    end,function()

        // MainLogic

        // Catch the Target Data
        // Lets search for the closest tent and AttachID
        local Tent , AttachID = GetPlacementPos(zmlab2.PointerSystem.Data.HitEntity)
        zmlab2.PointerSystem.Data.Target = {
            Tent = Tent,
            AttachID = AttachID,
        }

        // Change the main color depening if we found a valid building pos
        if CanPlace(Tent,AttachID) then
            zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["green01"]
        else
            zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["red01"]
        end

        // Update PreviewModel
        if IsValid(zmlab2.PointerSystem.Data.PreviewModel) then
            zmlab2.PointerSystem.Data.PreviewModel:SetModel(zmlab2.PointerSystem.Data.ModelOverwrite)
            zmlab2.PointerSystem.Data.PreviewModel:SetPos(zmlab2.PointerSystem.Data.Pos)
            zmlab2.PointerSystem.Data.PreviewModel:SetAngles(zmlab2.PointerSystem.Data.Ang)
            zmlab2.PointerSystem.Data.PreviewModel:SetColor(zmlab2.PointerSystem.Data.MainColor)
        end
    end)
end

net.Receive("zmlab2_Equipment_Deconstruct", function(len,ply)
    zmlab2.Debug_Net("zmlab2_Equipment_Deconstruct",len)
    local Equipment = net.ReadEntity()
    if not IsValid(Equipment) then return end
    zmlab2.Equipment.Deconstruct(Equipment)
end)
function zmlab2.Equipment.Deconstruct(Equipment)
    zmlab2.PointerSystem.Start(Equipment,function()

        // OnInit
        zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["red01"]

        zmlab2.PointerSystem.Data.ActionName = zmlab2.language["Deconstruct"]

    end,function()

        // OnLeftClick

        if not zmlab2.PointerSystem.Data.Target then return end

        net.Start("zmlab2_Equipment_Deconstruct")
        net.WriteEntity(zmlab2.PointerSystem.Data.Target)
        net.SendToServer()
    end,function()

        // MainLogic

        // Catch the Target Data
        if IsValid(zmlab2.PointerSystem.Data.HitEntity) and zmlab2.Equipment_Classes[zmlab2.PointerSystem.Data.HitEntity:GetClass()] then
            zmlab2.PointerSystem.Data.Target = zmlab2.PointerSystem.Data.HitEntity
        else
            zmlab2.PointerSystem.Data.Target = nil
        end

        // Update PreviewModel
        if IsValid(zmlab2.PointerSystem.Data.PreviewModel) then
            if IsValid(zmlab2.PointerSystem.Data.Target) then
                zmlab2.PointerSystem.Data.PreviewModel:SetModel(zmlab2.PointerSystem.Data.Target:GetModel())
                zmlab2.PointerSystem.Data.PreviewModel:SetPos(zmlab2.PointerSystem.Data.Target:GetPos())
                zmlab2.PointerSystem.Data.PreviewModel:SetAngles(zmlab2.PointerSystem.Data.Target:GetAngles())
            else
                zmlab2.PointerSystem.Data.PreviewModel:SetModel("models/hunter/misc/sphere025x025.mdl")
                zmlab2.PointerSystem.Data.PreviewModel:SetPos(zmlab2.PointerSystem.Data.Pos)
                zmlab2.PointerSystem.Data.PreviewModel:SetAngles(zmlab2.PointerSystem.Data.Ang)
            end
            zmlab2.PointerSystem.Data.PreviewModel:SetColor(zmlab2.PointerSystem.Data.MainColor)
        end
    end)
end

net.Receive("zmlab2_Equipment_Move", function(len,ply)
    zmlab2.Debug_Net("zmlab2_Equipment_Move", len)
    local Equipment = net.ReadEntity()
    if not IsValid(Equipment) then return end
    zmlab2.Equipment.Move(Equipment)
end)
function zmlab2.Equipment.Move(Equipment)
    zmlab2.PointerSystem.Start(Equipment,function()

        // OnInit
        zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["blue01"]
    end,function()

        // OnLeftClick

        if IsValid(zmlab2.PointerSystem.Data.Target) then

            // Lets search for the closest tent and AttachID
            local Tent , AttachID = GetPlacementPos(zmlab2.PointerSystem.Data.HitEntity)

            // Can we build here?
            if CanPlace(Tent,AttachID) == false then return end

            net.Start("zmlab2_Equipment_Move")
            net.WriteEntity(zmlab2.PointerSystem.Data.Target)
            net.WriteEntity(Tent)
            net.WriteInt(AttachID or -1,16)
            net.WriteVector(zmlab2.PointerSystem.Data.Pos)
            net.WriteAngle(zmlab2.PointerSystem.Data.Ang)
            net.SendToServer()

            zmlab2.PointerSystem.Data.Target = nil
        else

            // Select the machine to move
            if not IsValid(zmlab2.PointerSystem.Data.HitEntity) then return end
            if zmlab2.Equipment_Classes[zmlab2.PointerSystem.Data.HitEntity:GetClass()] == nil then return end

            zmlab2.PointerSystem.Data.Target = zmlab2.PointerSystem.Data.HitEntity

            zmlab2.PointerSystem.Data.EquipmentID = zmlab2.Equipment_Classes[zmlab2.PointerSystem.Data.Target:GetClass()]

            zmlab2.Sound.EmitFromEntity("tray_drop", zmlab2.PointerSystem.Data.HitEntity)
        end
    end,function()

        // MainLogic

        // Update PreviewModel
        if IsValid(zmlab2.PointerSystem.Data.PreviewModel) then

            zmlab2.PointerSystem.Data.Ignore = zmlab2.PointerSystem.Data.Target

            if IsValid(zmlab2.PointerSystem.Data.Target) then
                zmlab2.PointerSystem.Data.PreviewModel:SetModel(zmlab2.PointerSystem.Data.Target:GetModel())

                // We just call this function so it sets the Pos/Ang of the preview model
                local Tent,AttachID = GetPlacementPos(zmlab2.PointerSystem.Data.HitEntity)

                // Change the main color depening if we found a valid building pos
                if CanPlace(Tent,AttachID) then
                    zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["blue01"]
                else
                    zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["red01"]
                end

                zmlab2.PointerSystem.Data.ActionName = zmlab2.language["Choosepostion"]
            else
                zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["blue01"]
                zmlab2.PointerSystem.Data.ActionName = zmlab2.language["ChooseMachine"]

                // If we found a entity that we can move then get its pos and ang
                if IsValid(zmlab2.PointerSystem.Data.HitEntity) and zmlab2.Equipment_Classes[zmlab2.PointerSystem.Data.HitEntity:GetClass()] then
                    zmlab2.PointerSystem.Data.Pos = zmlab2.PointerSystem.Data.HitEntity:GetPos()
                    zmlab2.PointerSystem.Data.Ang = zmlab2.PointerSystem.Data.HitEntity:GetAngles()
                    zmlab2.PointerSystem.Data.PreviewModel:SetModel(zmlab2.PointerSystem.Data.HitEntity:GetModel())
                else
                    zmlab2.PointerSystem.Data.PreviewModel:SetModel("models/hunter/misc/sphere025x025.mdl")
                end
            end

            zmlab2.PointerSystem.Data.PreviewModel:SetPos(zmlab2.PointerSystem.Data.Pos)
            zmlab2.PointerSystem.Data.PreviewModel:SetAngles(zmlab2.PointerSystem.Data.Ang)
            zmlab2.PointerSystem.Data.PreviewModel:SetColor(zmlab2.PointerSystem.Data.MainColor)
        end
    end)
end

net.Receive("zmlab2_Equipment_Repair", function(len,ply)
    zmlab2.Debug_Net("zmlab2_Equipment_Repair", len)
    local Equipment = net.ReadEntity()
    if not IsValid(Equipment) then return end
    zmlab2.Equipment.Repair(Equipment)
end)
function zmlab2.Equipment.Repair(Equipment)
    zmlab2.PointerSystem.Start(Equipment,function()

        // OnInit
        zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["green01"]

        zmlab2.PointerSystem.Data.ActionName = zmlab2.language["Equipment_Repair"]
    end,function()

        // OnLeftClick

        if not zmlab2.PointerSystem.Data.Target then return end

        net.Start("zmlab2_Equipment_Repair")
        net.WriteEntity(zmlab2.PointerSystem.Data.Target)
        net.SendToServer()
    end,function()

        // MainLogic

        // Catch the Target Data
        if IsValid(zmlab2.PointerSystem.Data.HitEntity) and zmlab2.Equipment_Classes[zmlab2.PointerSystem.Data.HitEntity:GetClass()] then
            zmlab2.PointerSystem.Data.Target = zmlab2.PointerSystem.Data.HitEntity
        else
            zmlab2.PointerSystem.Data.Target = nil
        end

        // Update PreviewModel
        if IsValid(zmlab2.PointerSystem.Data.PreviewModel) then
            if IsValid(zmlab2.PointerSystem.Data.Target) then
                zmlab2.PointerSystem.Data.PreviewModel:SetModel(zmlab2.PointerSystem.Data.Target:GetModel())
                zmlab2.PointerSystem.Data.PreviewModel:SetPos(zmlab2.PointerSystem.Data.Target:GetPos())
                zmlab2.PointerSystem.Data.PreviewModel:SetAngles(zmlab2.PointerSystem.Data.Target:GetAngles())
            else
                zmlab2.PointerSystem.Data.PreviewModel:SetModel("models/hunter/misc/sphere025x025.mdl")
                zmlab2.PointerSystem.Data.PreviewModel:SetPos(zmlab2.PointerSystem.Data.Pos)
                zmlab2.PointerSystem.Data.PreviewModel:SetAngles(zmlab2.PointerSystem.Data.Ang)
            end

            if IsValid(zmlab2.PointerSystem.Data.Target) then
                local t = (1 / zmlab2.config.Damageable[zmlab2.PointerSystem.Data.Target:GetClass()]) * zmlab2.PointerSystem.Data.Target:Health()
                zmlab2.PointerSystem.Data.MainColor = zmlab2.util.LerpColor(t, zmlab2.colors["red02"], zmlab2.colors["green03"])
            else
                zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["green01"]
            end
            zmlab2.PointerSystem.Data.PreviewModel:SetColor(zmlab2.PointerSystem.Data.MainColor)
        end
    end,function()

        if IsValid(zmlab2.PointerSystem.Data.Target) then
            local pos = zmlab2.PointerSystem.Data.Target:GetPos() + Vector(0,0,50)
            local data2D = pos:ToScreen()
            local val = zmlab2.PointerSystem.Data.Target:Health()
            local max = zmlab2.config.Damageable[zmlab2.PointerSystem.Data.Target:GetClass()]
            draw.RoundedBox(0, data2D.x - 100, data2D.y - 25, 200, 50, zmlab2.colors["black03"])
            draw.SimpleText("[" .. val .. "/" .. max .. "]", zmlab2.GetFont("zmlab2_vgui_font01"), data2D.x, data2D.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            zmlab2.util.DrawOutlinedBox(data2D.x - 100, data2D.y - 25, 200, 50, 4, color_white)
        end
    end)
end
