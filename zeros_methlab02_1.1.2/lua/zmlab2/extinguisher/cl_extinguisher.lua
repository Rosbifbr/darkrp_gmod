if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Extinguisher = zmlab2.Extinguisher or {}

net.Receive("zmlab2_Extinguisher_Use", function(len, ply)
    zmlab2.Debug_Net("zmlab2_Extinguisher_Use", len)
    local Tent = net.ReadEntity()
    if not IsValid(Tent) then return end
    //zmlab2.Extinguisher.EnablePointer(Machine)

    zmlab2.PointerSystem.Start(Tent,function()

        // OnInit
        zmlab2.PointerSystem.Data.MainColor = zmlab2.colors["blue01"]

        zmlab2.PointerSystem.Data.ActionName = zmlab2.language["Extinguish"]

    end,function()

        // OnLeftClick

        //if not IsValid(zmlab2.PointerSystem.Data.Target) then return end
        /*
        if zmlab2.PointerSystem.Data.Target:IsOnFire() == false then
            zmlab2.vgui.Notify( zmlab2.language["ExtinguisherFail"],NOTIFY_ERROR)
            return
        end
        */

        // Send the target to the SERVER
        net.Start("zmlab2_Extinguisher_Use")
        net.WriteEntity(zmlab2.PointerSystem.Data.Target)
        net.WriteEntity(Tent)
        net.SendToServer()

        zmlab2.PointerSystem.Stop()
    end,function()

        // MainLogic

        // Catch the Target
        if IsValid(zmlab2.PointerSystem.Data.HitEntity) and zmlab2.PointerSystem.Data.HitEntity:GetClass() ~= "zmlab2_tent" then
            zmlab2.PointerSystem.Data.Target = zmlab2.PointerSystem.Data.HitEntity
        else
            zmlab2.PointerSystem.Data.Target = nil
        end

        // Update PreviewModel
        if IsValid(zmlab2.PointerSystem.Data.PreviewModel) then
            if IsValid(zmlab2.PointerSystem.Data.Target) then
                zmlab2.PointerSystem.Data.PreviewModel:SetColor(zmlab2.PointerSystem.Data.MainColor)
                zmlab2.PointerSystem.Data.PreviewModel:SetPos(zmlab2.PointerSystem.Data.Target:GetPos())
                zmlab2.PointerSystem.Data.PreviewModel:SetAngles(zmlab2.PointerSystem.Data.Target:GetAngles())
                zmlab2.PointerSystem.Data.PreviewModel:SetModel(zmlab2.PointerSystem.Data.Target:GetModel())
                zmlab2.PointerSystem.Data.PreviewModel:SetNoDraw(false)
            else
                zmlab2.PointerSystem.Data.PreviewModel:SetNoDraw(true)
            end
        end
    end)
end)
