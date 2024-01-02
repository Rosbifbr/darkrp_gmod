if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.PublicSetup = zmlab2.PublicSetup or {}


local classes = {
    ["zmlab2_machine_furnace"] = true,
    ["zmlab2_machine_mixer"] = true,
    ["zmlab2_machine_filter"] = true,
    ["zmlab2_machine_filler"] = true,
    ["zmlab2_machine_frezzer"] = true,
    ["zmlab2_machine_ventilation"] = true,
    ["zmlab2_table"] = true,
    ["zmlab2_storage"] = true,
    ["zmlab2_tent"] = true,
}
local function CatchMethlabEnts()
    local data = {}
    for k, v in pairs(ents.GetAll()) do
        if not IsValid(v) then continue end
        local class = v:GetClass()
        if classes[class] == nil then continue end

        if class == "zmlab2_tent" and v:GetBuildState() ~= 2 then continue end

        local package = {
            class = v:GetClass(),
            pos = v:GetPos(),
            ang = v:GetAngles()
        }

        // Lets store the postion and angle of the exhaustpipe
        if class == "zmlab2_machine_ventilation" then
            local exhaust = v:GetOutput()
            if IsValid(exhaust) then
                package.ex_pos = exhaust:GetPos()
                package.ex_ang = exhaust:GetAngles()
            end
        end

        if class == "zmlab2_tent" then
            package.color = v:GetColor()
            package.lightcolor = v:GetColorID()
            package.tentid = v:GetTentID()
        end

        if class == "zmlab2_table" then
            package.HasAutoBreaker = v.HasAutoBreaker
        end

        table.insert(data, package)
    end
    return data
end

concommand.Add("zmlab2_publicsetup_save", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then
        zmlab2.PublicSetup.Save(ply)
    end
end)
function zmlab2.PublicSetup.Save(ply)
    local data = CatchMethlabEnts()

    // Save to file
    if not file.Exists("zmlab2/save", "DATA") then file.CreateDir("zmlab2/save") end
    if table.Count(data) > 0 then
        file.Write("zmlab2/save/" .. "public_ents_" .. string.lower(game.GetMap()) .. ".txt", util.TableToJSON(data))
        zmlab2.Notify(ply, "Public Methlab saved for " .. game.GetMap(), 0)
    end
end


function zmlab2.PublicSetup.Load()

    local path = "zmlab2/save/" .. "public_ents_" .. string.lower(game.GetMap()) .. ".txt"
    if file.Exists(path, "DATA") then
        local data = file.Read(path, "DATA")

        data = util.JSONToTable(data)

        if data and table.Count(data) > 0 then
            for k, v in pairs(data) do
                if v == nil then continue end
                local ent = ents.Create(v.class)
                if not IsValid(ent) then continue end
                ent:SetPos(v.pos)
                ent:SetAngles(v.ang)
                ent:Spawn()
                ent:Activate()

                ent.IsPublic = true

                local phys = ent:GetPhysicsObject()
                if IsValid(phys) then
                    phys:Wake()
                    phys:EnableMotion(false)
                end

                ent.PhysgunDisabled = true

                if v.class == "zmlab2_machine_ventilation" and v.ex_pos and v.ex_ang then
                    timer.Simple(1,function()
                        if IsValid(ent) and IsValid(ent:GetOutput()) then
                            ent:GetOutput():SetPos(v.ex_pos)
                            ent:GetOutput():SetAngles(v.ex_ang)
                        end
                    end)
                end

                if v.class == "zmlab2_tent" then

                    if v.tentid then ent:SetTentID(v.tentid) end

                    if v.color then
                        ent:SetColor(v.color)
                    end

                    local TentData = zmlab2.config.Tent[v.tentid]
                    if TentData == nil then return end

                    ent:SetModel(TentData.model)
                    ent:PhysicsInit(SOLID_VPHYSICS)
                    ent:SetSolid(SOLID_VPHYSICS)
                    ent:SetMoveType(MOVETYPE_VPHYSICS)

                    local aphys = ent:GetPhysicsObject()
                    if IsValid(aphys) then
                        aphys:Wake()
                        aphys:EnableMotion(false)
                        aphys:SetDamping(100, 100)
                    end

                    ent:SetBuildState(2)

                    ent.PhysgunDisabled = true

                    ent:SetIsPublic(true)

                    // Spawn door
                    local attach_door = ent:GetAttachment(2)
                    local door = ents.Create("zmlab2_tent_door")
                    if not IsValid(door) then return end
                    door:SetPos(attach_door.Pos)
                    door:SetAngles(attach_door.Ang)
                    door:Spawn()
                    door:Activate()
                    door:SetParent(ent)
                    ent.Door = door

                    door:SetIsPublic(true)

                    if v.lightcolor then
                        ent:SetColorID(v.lightcolor)
                    end
                end

                if v.class == "zmlab2_table" and v.HasAutoBreaker == true then
                    ent:SetBodygroup(0,1)
                    ent:SetBodygroup(1,1)
                    ent:SetBodygroup(2,1)
                    ent.HasAutoBreaker = true
                end
            end

            zmlab2.Print("Finished loading Public Methlab!")
        end
    end
end
timer.Simple(0.1,function() zmlab2.PublicSetup.Load() end)
zmlab2.Hook.Add("PostCleanupMap", "PublicSetup_Load", zmlab2.PublicSetup.Load)


concommand.Add("zmlab2_publicsetup_remove", function(ply, cmd, args)
    if zmlab2.Player.IsAdmin(ply) then
        zmlab2.PublicSetup.Remove(ply)
    end
end)
function zmlab2.PublicSetup.Remove(ply)
    zmlab2.Debug("zmlab2.PublicSetup.Remove")

    for k, v in pairs(ents.GetAll()) do
        if IsValid(v) and classes[v:GetClass()] then
            v:Remove()
        end
    end

    local path = "zmlab2/save/" .. "public_ents_" .. string.lower(game.GetMap()) .. ".txt"
    if file.Exists(path, "DATA") then
        file.Delete(path)
        zmlab2.Notify(ply, "Public Methlab removed for " .. game.GetMap(), 0)
    else
        zmlab2.Notify(ply,"No Public Methlab entities could be found!", 1)
    end
end
