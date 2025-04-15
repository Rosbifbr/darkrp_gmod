if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Police = zmlab2.Police or {}

// Returns the first valid police player it can find
function zmlab2.Police.Get()
    local police

    for k, v in pairs(zmlab2.Player.List) do
        if IsValid(v) and v:IsPlayer() and v:Alive() and zmlab2.config.Police.Jobs[zmlab2.Player.GetJob(v)] then
            police = v
            break
        end
    end
    return police
end

function zmlab2.Police.MakeWanted(ply,reason,time)

    local police = zmlab2.Police.Get()

    if IsValid(police) then
        hook.Run("zmlab2_OnWanted", ply,reason)
        ply:wanted(police, reason, time)
    end
end
