if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Fire = zmlab2.Fire or {}

function zmlab2.Fire.Ignite(ent,time,radius)
    // Only way to detect vFire atm
    if CreateVFire then
        ent:Ignite(1,0)
    else
        ent:Ignite(time,radius)
    end
end
