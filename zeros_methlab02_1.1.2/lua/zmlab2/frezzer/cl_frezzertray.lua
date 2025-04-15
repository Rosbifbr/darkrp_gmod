if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.FrezzerTray = zmlab2.FrezzerTray or {}

/*
    ProcessState
    0 = Empty
    1 = Liquid
    2 = Frozen
*/


function zmlab2.FrezzerTray.Initialize(FrezzerTray)
    // Fixes the tray follwing the frezzer attachments correctly
	//FrezzerTray:SetPredictable(true) BUG Causes the entity while being moved to look like its lagging
end

function zmlab2.FrezzerTray.Draw(FrezzerTray)
    if zmlab2.config.Frezzer.Tray_DisplayState and zmlab2.util.InDistance(LocalPlayer():GetPos(),FrezzerTray:GetPos(), 1000) and zmlab2.Convar.Get("zmlab2_cl_drawui") == 1 then

        cam.Start3D2D(FrezzerTray:LocalToWorld(Vector(0, 0, 0.5)), FrezzerTray:LocalToWorldAngles(Angle(0, 180, 0)), 0.5)
            local state = FrezzerTray:GetProcessState()

            if state == 1 then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(zmlab2.materials["icon_box01"])
                surface.DrawTexturedRectRotated(0, 0, 20, 20, 0)

                surface.SetDrawColor(color_white)
                surface.SetMaterial(zmlab2.materials["icon_cold"])
                surface.DrawTexturedRectRotated(0, 0, 15, 15, 0)
            elseif state == 2 then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(zmlab2.materials["icon_box01"])
                surface.DrawTexturedRectRotated(0, 0, 20, 20, 0)

                surface.SetDrawColor(color_white)
                surface.SetMaterial(zmlab2.materials["icon_breaking"])
                surface.DrawTexturedRectRotated(0, 0, 15, 15, 0)
            end
        cam.End3D2D()
    end
end
