if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Storage = zmlab2.Storage or {}

function zmlab2.Storage.Initialize(Storage)
    zmlab2.EntityTracker.Add(Storage)

    if zmlab2.config.Equipment.PlayerCollide == false then
        Storage:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end

    Storage:SetMaxHealth( zmlab2.config.Damageable[Storage:GetClass()] )
    Storage:SetHealth(Storage:GetMaxHealth())
end

function zmlab2.Storage.OnRemove(Storage)

end

function zmlab2.Storage.OnUse(Storage, ply)
    if zmlab2.Player.CanInteract(ply, Storage) == false then return end

    zmlab2.Storage.OpenInterface(Storage, ply)
end

util.AddNetworkString("zmlab2_Storage_OpenInterface")
function zmlab2.Storage.OpenInterface(Storage,ply)
    net.Start("zmlab2_Storage_OpenInterface")
    net.WriteEntity(Storage)
    net.Send(ply)
end

function zmlab2.Storage.LimitCheck(ply,ItemID)
    local StorageData = zmlab2.config.Storage.Shop[ItemID]
    local class = StorageData.class
    local limit = hook.Run("zmlab2_Storage_GetItemLimit",ply,ItemID) or StorageData.limit

    local count = 0
    for k, v in pairs(zmlab2.EntityTracker.GetList()) do
        if IsValid(v) and v:GetClass() == class and zmlab2.Player.IsOwner(ply, v) then
            count = count + 1
        end
    end

    if count >= limit then
        return false
    else
        return true
    end
end

util.AddNetworkString("zmlab2_Storage_Buy")
net.Receive("zmlab2_Storage_Buy", function(len, ply)
    zmlab2.Debug_Net("zmlab2_Storage_Buy", len)
    if zmlab2.Player.Timeout(nil,ply) == true then return end

    local Storage = net.ReadEntity()
    local ItemID = net.ReadUInt(16)
    if not IsValid(Storage) then return end

    if zmlab2.Player.CanInteract(ply, Storage) == false then return end
    if zmlab2.util.InDistance(ply:GetPos(), Storage:GetPos(), 1000) == false then return end


    if ItemID == nil then return end

    local StorageData = zmlab2.config.Storage.Shop[ItemID]
    if StorageData == nil then return end

    if zmlab2.Storage.BuyCheck(ply,ItemID) == false then return end

    if zmlab2.Money.Has(ply, StorageData.price) == false then return end

    // Check if the player hit some limit
    if zmlab2.Storage.LimitCheck(ply,ItemID) == false then
        local str = zmlab2.language["ItemLimit"]
        str = string.Replace(str,"$ItemName",StorageData.name)
        zmlab2.Notify(ply, str, 1)
        return
    end

    if Storage:GetNextPurchase() > CurTime() then return end
    Storage:SetNextPurchase(CurTime() + zmlab2.config.Storage.BuyInterval)

    zmlab2.Money.Take(ply, StorageData.price)
    zmlab2.Notify(ply, "-" .. zmlab2.Money.Display(math.Round(StorageData.price)), 0)

    local ent = ents.Create(StorageData.class)
    if not IsValid(ent) then return end
    ent:SetPos(Storage:LocalToWorld(Vector(0, 50, 20)))
    ent:SetAngles(angle_zero)
    ent:Spawn()
    ent:Activate()

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(true)
    end

    zmlab2.Hook.SimulateBuy(ply,ent,StorageData.name,StorageData.price)

    zmlab2.Player.SetOwner(ent, ply)
    zmlab2.Sound.EmitFromEntity("cash", ent)
end)
