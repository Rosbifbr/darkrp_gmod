if SERVER then return end

zmlab2 = zmlab2 or {}
zmlab2.VibrationSystem = zmlab2.VibrationSystem or {}

/*

    This system vibrates certain bones of machines

*/

local function RandomJiggle(Machine,boneID,intensity,Fade)
    local amount = 0.1 * intensity * Fade
    local vibrate = math.Rand(-amount, amount)
    Machine:ManipulateBonePosition(boneID, Vector(vibrate, vibrate, vibrate))
end

function zmlab2.VibrationSystem.Run(Machine,enabled,intensity)
    if zmlab2.util.InDistance(Machine:GetPos(), LocalPlayer():GetPos(), 150) == false then return end

    // Here we calculate the fade in multiplier
    local Fade = 1
    if Machine.LastState ~= enabled then
        Machine.LastState = enabled
        Machine.VibrationChange = CurTime()
    end
    Fade = math.Clamp((1 / 3) * (CurTime() - Machine.VibrationChange), 0, 1)

    // Here we jiggle the pickle
    for boneID = 1, Machine:GetBoneCount() do
        local boneName = Machine:GetBoneName(boneID)

        if boneName and string.sub(boneName, 1, 7) == "vibrate" then
            if enabled then
                RandomJiggle(Machine,boneID,intensity,Fade)
            else
                if Fade >= 1 then
                    Machine:ManipulateBonePosition(boneID, vector_origin)
                else
                    RandomJiggle(Machine,boneID,intensity,1-Fade)
                end
            end
        end
    end
end
