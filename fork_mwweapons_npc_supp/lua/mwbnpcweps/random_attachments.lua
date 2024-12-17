AddCSLuaFile()

CreateConVar("mwbnpcweapons_random_attachments", "1", bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))
local attachmentChance = 4

local _MWBAttachmentsNPC_Done = {}



local function MWBAttachmentsNPC_Done()
    _MWBAttachmentsNPC_Done[net.ReadInt(32)] = true
end


local function MWBAttachmentsNPC_Client()
    local SWEP = net.ReadEntity()
    local attachments = net.ReadTable()
    local timerName = "MWBGiveNPCClientAttachments"..SWEP:EntIndex()

    if !game.SinglePlayer() then
        if !IsValid(SWEP) then
            return
        else
            net.Start("MWBAttachmentsNPC_Done")
            net.WriteInt(net.ReadInt(32), 32)
            net.SendToServer()
        end
    end

    -- Wait until SWEP.Attach exists on client so that the attachments can be given:
    timer.Create(timerName, 0, 0, function()
        if !IsValid(SWEP) then
            timer.Remove(timerName)
            return
        end

        if SWEP.Attach then
            for k, v in pairs(attachments) do
                SWEP:Attach(k, v)
            end

            timer.Remove(timerName)
        end
    end)
end


local function RandomMWBAttachments( SWEP )
    local attachmentsAttached = {}

    for k, v in ipairs(SWEP.Customization) do
        if math.random(1, attachmentChance) == 1 then
            local att = math.random(2, #v)
            SWEP:Attach(k, att)
            attachmentsAttached[k] = att
        end
    end

    if !game.SinglePlayer() then
        local timerName = "MWBNPCAttachments_NetMsgTimer"..SWEP:EntIndex()

        _MWBAttachmentsNPC_Done[SWEP:EntIndex()] = false

        -- Send net message until SWEP is valid on client:
        timer.Create(timerName, 0, 0, function()
            if !IsValid(SWEP) or _MWBAttachmentsNPC_Done[SWEP:EntIndex()] then
                timer.Remove(timerName)
                _MWBAttachmentsNPC_Done[SWEP:EntIndex()] = nil
                return
            end

            net.Start("MWBAttachmentsNPC")
            net.WriteEntity(SWEP)
            net.WriteTable(attachmentsAttached)
            net.WriteInt(SWEP:EntIndex(), 32)
            net.Broadcast()
        end)
    else
        net.Start("MWBAttachmentsNPC")
        net.WriteEntity(SWEP)
        net.WriteTable(attachmentsAttached)
        net.Broadcast()
    end
end


local function AddMWBPostInit( SWEP )
    local DefaultInitFunc = SWEP.Initialize
    function SWEP:Initialize()
        -- Initialize as usual:
        DefaultInitFunc(self)

        -- Give random attachments to NPCs:
        if self:GetOwner():IsNPC() then
            RandomMWBAttachments(self)
        end
    end
end


local function OnEntityCreated( ent )
    if !GetConVar("mwbnpcweapons_random_attachments"):GetBool() then return end

    -- MWB Weapon:
    if ent:IsWeapon() && string.StartWith(ent:GetClass(), "mg_") then
        AddMWBPostInit(ent)
    end
end


if CLIENT then
    net.Receive("MWBAttachmentsNPC", MWBAttachmentsNPC_Client)
end

if SERVER then
    util.AddNetworkString("MWBAttachmentsNPC")
    util.AddNetworkString("MWBAttachmentsNPC_Done")
    net.Receive("MWBAttachmentsNPC_Done", MWBAttachmentsNPC_Done)
    hook.Add("OnEntityCreated", "OnEntityCreated_MWBNPCWeapons_RandomAttachments", OnEntityCreated)
end