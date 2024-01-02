if not CLIENT then return end

net.Receive("zmlab2_Tent_OpenInterface", function(len)
    zmlab2.Debug_Net("zmlab2_Tent_OpenInterface", len)
    LocalPlayer().zmlab2_Tent = net.ReadEntity()
    LocalPlayer().zmlab2_TentID = net.ReadInt(16)
    LocalPlayer().zmlab2_TentFold = net.ReadBool()

    if LocalPlayer().zmlab2_TentFold == true then
        zmlab2.Interface.Create(600,365,zmlab2.language["Deconstruct"],function(pnl)

            local function AddLabel(txt,font)
                local Textbox01 = vgui.Create("DLabel", pnl)
                Textbox01:SetAutoDelete(true)
                Textbox01:SetSize(200 * zmlab2.wM, 30 * zmlab2.hM)
                Textbox01:Dock(TOP)
                Textbox01:SetText(txt)
                Textbox01:SetTextColor(color_white)
                Textbox01:SetFont(zmlab2.GetFont(font))
                Textbox01:SetContentAlignment(5)
                Textbox01:SizeToContentsX(15 * zmlab2.wM)
                Textbox01:DockMargin(0,0,0,0)
                return Textbox01
            end

            local Textbox01 = AddLabel(zmlab2.language["TentFoldInfo01"],"zmlab2_vgui_font03")
            Textbox01:DockMargin(0,60,0,0)
            AddLabel(zmlab2.language["TentFoldInfo02"],"zmlab2_vgui_font02")

            local FoldButton = vgui.Create("DButton", pnl)
            FoldButton:SetSize(300 * zmlab2.wM, 70 * zmlab2.hM)
            FoldButton:Dock(BOTTOM)
            FoldButton:SetPos((pnl:GetWide() / 2) - 150 * zmlab2.wM,(pnl:GetTall() / 2) + 50 * zmlab2.hM)
            FoldButton:SetText("")
            FoldButton.Paint = function(s, w, h)

                zmlab2.util.DrawOutlinedBox(0 * zmlab2.wM, 0 * zmlab2.hM, w, h, 2, color_white)

                draw.SimpleText(zmlab2.language["TentFoldAction"], zmlab2.GetFont("zmlab2_vgui_font03"), w / 2 , h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                if s:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["white02"])
                end
            end
            FoldButton.DoClick = function(s)
                zmlab2.vgui.PlaySound("UI/buttonclick.wav")

                net.Start("zmlab2_Tent_Fold")
                net.WriteEntity(LocalPlayer().zmlab2_Tent)
                net.SendToServer()

                pnl:Close()
            end
        end)
        return
    end

    if LocalPlayer().zmlab2_Tent:GetBuildState() < 1 then
        zmlab2.Interface.Create(700,470,zmlab2.language["SelectTentType"],function(pnl)

            zmlab2.Interface.AddModelList(pnl,zmlab2.config.Tent,function(id)
                // IsLocked
                return zmlab2.config.Tent[id].customcheck and zmlab2.config.Tent[id].customcheck(LocalPlayer()) == false or false
            end,
            function(id)
                // IsSelected
                return LocalPlayer().zmlab2_TentID == id
            end,
            function(id)
                net.Start("zmlab2_Tent_ChangeType")
                net.WriteEntity(LocalPlayer().zmlab2_Tent)
                net.WriteInt(id,16)
                net.SendToServer()

                LocalPlayer().zmlab2_TentID = id
            end,
            function(raw_data)
                return {model = raw_data.model,render = {FOV = 40},color = raw_data.color,bodygroup = {[0] = 5}} , raw_data.name , zmlab2.Money.Display(raw_data.price)
            end,
            function(MainContainer,item_size)
                local NoneButton = MainContainer:Add("DButton")
                NoneButton:SetSize(item_size,item_size)
                NoneButton:SetText("")
                NoneButton.Paint = function(s, w, h)
                    surface.SetDrawColor(zmlab2.colors["blue02"])
                    surface.SetMaterial(zmlab2.materials["item_bg"])
                    surface.DrawTexturedRect(0 * zmlab2.wM, 0 * zmlab2.hM, w,h)

                    draw.SimpleText(zmlab2.language["TentType_None"], zmlab2.GetFont("zmlab2_vgui_font02"), w / 2 , h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                    if LocalPlayer().zmlab2_TentID == -1 then
                        zmlab2.util.DrawOutlinedBox(0 * zmlab2.wM, 0 * zmlab2.hM, w, h, 2, zmlab2.colors["orange01"])
                    else
                        zmlab2.util.DrawOutlinedBox(0 * zmlab2.wM, 0 * zmlab2.hM, w, h, 2, color_white)
                    end

                    if s:IsHovered() then
                        draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["white02"])
                    end
                end
                NoneButton.DoClick = function(s)
                    zmlab2.vgui.PlaySound("UI/buttonclick.wav")

                    LocalPlayer().zmlab2_TentID = -1

                    net.Start("zmlab2_Tent_ChangeType")
                    net.WriteEntity(LocalPlayer().zmlab2_Tent)
                    net.WriteInt(-1,16)
                    net.SendToServer()
                end
            end)

            local BuildButton = vgui.Create("DButton", pnl)
            BuildButton:SetSize(pnl:GetWide(),50 * zmlab2.hM)
            BuildButton:Dock(BOTTOM)
            BuildButton:SetText("")
            BuildButton.Paint = function(s, w, h)
                zmlab2.util.DrawOutlinedBox(0 * zmlab2.wM, 0 * zmlab2.hM, w, h, 2, color_white)

                draw.SimpleText(zmlab2.language["TentAction_Build"], zmlab2.GetFont("zmlab2_vgui_font03"), w / 2 , h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                if s:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["white02"])
                end
            end
            BuildButton.DoClick = function(s)
                zmlab2.vgui.PlaySound("UI/buttonclick.wav")

                net.Start("zmlab2_Tent_Build")
                net.WriteEntity(LocalPlayer().zmlab2_Tent)
                net.SendToServer()

                pnl:Close()
            end

            local ox,oy = pnl:GetPos()
            pnl:SetPos(ox,oy + 80 * zmlab2.hM)
        end)
    else
        zmlab2.Interface.Create(500,460,zmlab2.language["LightColor"],function(pnl)
            zmlab2.Interface.AddColorList(pnl,zmlab2.Tent_LightColors,function(id)
                // IsLocked
                return false
            end,
            function(id)
                // IsSelected
                return IsValid(LocalPlayer().zmlab2_Tent) and LocalPlayer().zmlab2_Tent:GetColorID() == id
            end,
            function(id)
                // OnClick
                net.Start("zmlab2_Tent_UpdateLightColorID")
                net.WriteEntity(LocalPlayer().zmlab2_Tent)
                net.WriteUInt(id,16)
                net.SendToServer()
            end,
            function() end)
        end)
    end
end)
