if CLIENT then return end

zmlab2 = zmlab2 or {}
zmlab2.Player = zmlab2.Player or {}

// How often are clients allowed to send net messages to the server
zmlab2_NW_TIMEOUT = 0.1

function zmlab2.Player.Timeout(id,ply)
    if not IsValid(ply) then
        zmlab2.Print("[ DEBUG ] TimeoutID: " .. tostring(id))
        zmlab2.Print("[ DEBUG ] Player not valid Timeout: " .. tostring(ply))
        return true
    end

    local Timeout = false

    if ply.zmlab2_NWTimeout == nil then
        ply.zmlab2_NWTimeout = {}
    end

    if id == nil then
        id = "default"
    end

    if ply.zmlab2_NWTimeout[id] and ply.zmlab2_NWTimeout[id] > CurTime() then
        Timeout = true
        zmlab2.Print("[ DEBUG ] TimeoutID: " .. tostring(id))
        zmlab2.Print("[ DEBUG ] Player Timeout: " .. tostring(ply))
    end

    ply.zmlab2_NWTimeout[id] = CurTime() + zmlab2_NW_TIMEOUT

    return Timeout
end

zmlab2.Player.List = zmlab2.Player.List or {}

// Returns a list of all the players who are close enough to the provided distance
function zmlab2.Player.GetInSphere(pos,radius)
    local tbl = {}
    for k,v in pairs(zmlab2.Player.List) do
        if IsValid(v) and zmlab2.util.InDistance(v:GetPos(), pos, radius) then
            tbl[v] = true
        end
    end
    return tbl
end

function zmlab2.Player.Add(ply)
    zmlab2.Player.List[zmlab2.Player.GetID(ply)] = ply
end

util.AddNetworkString("zmlab2_Player_Initialize")
net.Receive("zmlab2_Player_Initialize", function(len, ply)

    if ply.zmlab2_HasInitialized then
        return
    else
        ply.zmlab2_HasInitialized = true
    end

    zmlab2.Debug_Net("zmlab2_Player_Initialize",len)

    if IsValid(ply) then
        zmlab2.Player.Add(ply)
    end
end)

////////////////////////////////////////////
//////////// Player Status Changed /////////
////////////////////////////////////////////
local zmlab2_DeleteEnts = {
	["zmlab2_equipment"] = true,
	["zmlab2_storage"] = true,
	["zmlab2_table"] = true,
	["zmlab2_tent"] = true,

	["zmlab2_item_acid"] = true,
	["zmlab2_item_aluminium"] = true,
	["zmlab2_item_crate"] = true,
	["zmlab2_item_frezzertray"] = true,
	["zmlab2_item_lox"] = true,
	["zmlab2_item_methylamine"] = true,
	["zmlab2_item_palette"] = true,
    ["zmlab2_item_autobreaker"] = true,

	["zmlab2_machine_mixer"] = true,
	["zmlab2_machine_filler"] = true,
	["zmlab2_machine_filter"] = true,
	["zmlab2_machine_frezzer"] = true,
	["zmlab2_machine_furnace"] = true,
	["zmlab2_machine_ventilation"] = true,
}
function zmlab2.Player.CleanUp(steamID)
    for k, v in pairs(zmlab2.EntityTracker.GetList()) do
        if IsValid(v) and zmlab2_DeleteEnts[v:GetClass()] and zmlab2.Player.GetOwnerID(v) == steamID then
            SafeRemoveEntity(v)
        end
    end
end

function zmlab2.Player.Disconnect(steamid)
    zmlab2.Player.CleanUp(steamid)
end
gameevent.Listen("player_disconnect")
zmlab2.Hook.Add("player_disconnect", "player_disconnect", function(data)
    local steamid

    if data.bot == 1 then
        steamid = data.userid
    else
        steamid = data.networkid
    end

    zmlab2.Player.List[steamid] = nil

    zmlab2.Player.Disconnect(steamid)
end)

zmlab2.Hook.Add("PlayerChangedTeam", "PlayerChangedTeam", function(ply, before, after)
    zmlab2.Player.CleanUp(zmlab2.Player.GetID(ply))
end)
////////////////////////////////////////////
////////////////////////////////////////////



function zmlab2.Player.DropMeth(ply)

    if ply.zmlab2_MethList == nil or table.Count(ply.zmlab2_MethList) <= 0 then
        zmlab2.Notify(ply, zmlab2.language["NPC_InteractionFail02"], 1)
        return
    end

    local x,y,z = 0,0,0
    for k,v in pairs(ply.zmlab2_MethList) do

        if x >= 60 then
            y = y + 25
            x = 0
        end

        if y >= 60 then
            z = z + 25
            y = 0
        end

        x = x + 30

        local ent = ents.Create("zmlab2_item_crate")
        if not IsValid(ent) then continue end
        ent:SetPos(ply:GetPos() + Vector(40 - x,40 - y,z))
        ent:Spawn()
        ent:Activate()

        zmlab2.Crate.AddMeth(ent,v.t,v.a,v.q,false)

        zmlab2.Player.SetOwner(ent, ply)
    end
    ply.zmlab2_MethList = {}
end

zmlab2.Hook.Add("PlayerSay", "ChatCommands", function(ply, text)

    if string.sub(string.lower(text), 1, 12) == "!zmlab2_save" and zmlab2.Player.IsAdmin(ply) then
        zmlab2.SellSetup.Save(ply)
    end

    // Drop all the collected meth of the player you are looking
    if zmlab2.config.Police.Jobs[zmlab2.Player.GetJob(ply)] and string.sub(string.lower(text), 1, string.len(zmlab2.config.Police.cmd_strip)) == zmlab2.config.Police.cmd_strip then
        local tr = ply:GetEyeTrace()
        if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:Alive() then
            zmlab2.Player.DropMeth(tr.Entity)
        end
    end

    // Drop all the collected meth
    if string.sub(string.lower(text), 1, string.len(zmlab2.config.DropMeth)) == zmlab2.config.DropMeth then
        zmlab2.Player.DropMeth(ply)
    end

    // Extract meth out of a crate
    if string.sub(string.lower(text), 1, string.len(zmlab2.config.BagMeth)) == zmlab2.config.BagMeth then
        local tr = ply:GetEyeTrace()
        if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmlab2_item_crate" then
            local crate = tr.Entity
            local m_amount = crate:GetMethAmount()
            if m_amount <= 0 then return end

            local function SpawnMeth(id,amount,quality,position)
                local ent = ents.Create("zmlab2_item_meth")
                if not IsValid(ent) then return end
                ent:SetPos(position)
                ent:Spawn()
                ent:Activate()

                ent:SetMethType(id)
                ent:SetMethAmount(amount)
                ent:SetMethQuality(quality)

                zmlab2.Player.SetOwner(ent, ply)
            end

            local i_amount,i_type,i_quality = 100,1,1

            i_type = crate:GetMethType()
            i_quality = crate:GetMethQuality()

            local i_pos = tr.Entity:GetPos() + Vector(35,0,5)

            if m_amount > 100 then
                crate:SetMethAmount(crate:GetMethAmount() - 100)
            else
                i_amount = crate:GetMethAmount()

                SafeRemoveEntity(crate)
            end

            SpawnMeth(i_type,i_amount,i_quality,i_pos)
        end
    end
end)
