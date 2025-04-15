if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Extinguisher = zmlab2.Extinguisher or {}

function zmlab2.Extinguisher.OnUse(Tent,ply)

    if (Tent:GetLastExtinguish() + zmlab2.config.Extinguisher.Interval) > CurTime() then return end

    net.Start("zmlab2_Extinguisher_Use")
    net.WriteEntity(Tent)
    net.Send(ply)
end

function zmlab2.Extinguisher.ExtinguishArea(pos)
    zmlab2.NetEvent.Create("extinguish",pos)

    for k,v in pairs(ents.FindInSphere(pos,200)) do
        if IsValid(v) then
            v:Extinguish()
        end
    end
end


util.AddNetworkString("zmlab2_Extinguisher_Use")
net.Receive("zmlab2_Extinguisher_Use", function(len,ply)
    zmlab2.Debug_Net("zmlab2_Extinguisher_Use",len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    local Tent = net.ReadEntity()

    if not IsValid(Tent) then return end

    if (Tent:GetLastExtinguish() + zmlab2.config.Extinguisher.Interval) > CurTime() then return end


    if not IsValid(Machine) then
        local tr = ply:GetEyeTrace()
        if tr.Hit and tr.HitPos and zmlab2.util.InDistance(ply:GetPos(), tr.HitPos, 500) then
            zmlab2.Extinguisher.ExtinguishArea(tr.HitPos)

            Tent:SetLastExtinguish(CurTime())
        end

        return
    end


    //if Machine:IsOnFire() == false then return end
    if zmlab2.util.InDistance(ply:GetPos(), Machine:GetPos(), 1000) == false then return end

    Machine:Extinguish()
    Tent:SetLastExtinguish(CurTime())

    zmlab2.Extinguisher.ExtinguishArea(Machine:GetPos())
end)
