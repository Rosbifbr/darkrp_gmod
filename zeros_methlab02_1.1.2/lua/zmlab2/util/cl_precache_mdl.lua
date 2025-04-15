if SERVER then return end

zmlab2 = zmlab2 or {}

timer.Simple(2,function()
    for k,v in pairs(zmlab2.config.Equipment.List) do zmlab2.CacheModel(v.model) end
    for k,v in pairs(zmlab2.config.Tent) do zmlab2.CacheModel(v.model) end
    zmlab2.CacheModel("models/zerochain/props_methlab/zmlab2_pipe_vent.mdl")
    zmlab2.CacheModel("models/zerochain/props_methlab/zmlab2_crate.mdl")
    zmlab2.CacheModel("models/hunter/misc/sphere025x025.mdl")
end)



////////////////////////////////////////////
/////////// PRECACHE - MODELS //////////////
////////////////////////////////////////////
// Precaches the Model before it gets used, isntead of precaching all models at once
zmlab2.CachedModels = {}
function zmlab2.CacheModel(path)
    if zmlab2.CachedModels[path] then
        return path
    else
        util.PrecacheModel(path)
        zmlab2.CachedModels[path] = true

        zmlab2.Print("Model " .. path .. " cached!")

        return path
    end
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
///////////// ClientModels /////////////////
////////////////////////////////////////////
/*

	This system Creates / Removes and keeps track on ClientModels

*/

zmlab2.ClientModel = zmlab2.ClientModel or {}
if zmlab2_ClientModelList == nil then
    zmlab2_ClientModelList = {}
end

function zmlab2.ClientModel.PrintAll()
    for k, v in pairs(zmlab2_ClientModelList) do
        if not IsValid(v) then
            zmlab2_ClientModelList[k] = nil
        end
    end

    PrintTable(zmlab2_ClientModelList)
end

function zmlab2.ClientModel.Add(mdl_path, rendermode)
    zmlab2.CacheModel(mdl_path)
    local ent = ClientsideModel(mdl_path or "error.mdl", rendermode)
    table.insert(zmlab2_ClientModelList, ent)

    return ent
end

function zmlab2.ClientModel.AddProp(mdl_path)
    local ent = nil

    if mdl_path then
        zmlab2.CacheModel(mdl_path)
        ent = ents.CreateClientProp(mdl_path)
    else
        ent = ents.CreateClientProp()
    end

    table.insert(zmlab2_ClientModelList, ent)

    return ent
end

function zmlab2.ClientModel.Remove(ent)
    if not IsValid(ent) then return end
    table.RemoveByValue(zmlab2_ClientModelList, ent)

    // Stop moving if you have physics
    if ent.PhysicsDestroy then ent:PhysicsDestroy() end

    // Hide entity
    if ent.SetNoDraw then ent:SetNoDraw(true) end

    // This got taken from a Physcollide function but maybe its needed to prevent a crash
    local deltime = FrameTime() * 2
    if not game.SinglePlayer() then deltime = FrameTime() * 6 end
    SafeRemoveEntityDelayed(ent, deltime)
end
////////////////////////////////////////////
////////////////////////////////////////////
