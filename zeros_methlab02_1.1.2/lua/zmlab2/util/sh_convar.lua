zmlab2 = zmlab2 or {}
zmlab2.Convar = zmlab2.Convar or {}
zmlab2.Convars = zmlab2.Convars or {}

function zmlab2.Convar.Get(convar)
    return tonumber(zmlab2.Convars[convar] or 0, 10)
end

function zmlab2.Convar.Set(convar, val)
    zmlab2.Convars[convar] = val
end

function zmlab2.Convar.Create(convar, val, data)
    CreateConVar(convar, val, data)
    zmlab2.Convars[convar] = GetConVar(convar):GetString()

    local identifier = "convar_" .. convar
    cvars.RemoveChangeCallback(convar, identifier)
    cvars.AddChangeCallback(convar, function(convar_name, value_old, value_new)
        zmlab2.Convar.Set(convar, value_new)
    end, identifier)
end

if CLIENT then
    zmlab2.Convar.Create("zmlab2_cl_vfx_dynamiclight", "1", {FCVAR_ARCHIVE})
    zmlab2.Convar.Create("zmlab2_cl_sfx_volume", "1", {FCVAR_ARCHIVE})
    zmlab2.Convar.Create("zmlab2_cl_drawui", "1", {FCVAR_ARCHIVE})
    zmlab2.Convar.Create("zmlab2_cl_particleeffects", "1", {FCVAR_ARCHIVE})
end
