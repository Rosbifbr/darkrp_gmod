if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Equipment = zmlab2.Equipment or {}

net.Receive("zmlab2_Equipment_OpenInterface", function(len)
    zmlab2.Debug_Net("zmlab2_Equipment_OpenInterface",len)

    LocalPlayer().zmlab2_Equipment = net.ReadEntity()

    // If we currently removing / placing something then stop
    zmlab2.PointerSystem.Stop()

    zmlab2.Equipment.OpenInterface()
end)

function zmlab2.Equipment.OpenInterface()
    zmlab2.Interface.Create(600,365,zmlab2.language["Equipment"],function(pnl)
        function pnl:Think()
            if input.IsMouseDown(MOUSE_RIGHT) == true then
                LocalPlayer().zmlab2_Equipment = nil
                pnl:Close()
            end
        end

        zmlab2.Interface.AddModelList(pnl,zmlab2.config.Equipment.List,function(id)
            // IsLocked
            return false
        end,
        function(id)
            // IsSelected
            return false
        end,
        function(id)
            // OnClick
            zmlab2.Equipment.Place(LocalPlayer().zmlab2_Equipment,id)
            pnl:Close()
        end,
        function(raw_data)
            return {model = raw_data.model,render = {FOV = 35}} , raw_data.name , zmlab2.Money.Display(raw_data.price)
        end)
    end)
end
