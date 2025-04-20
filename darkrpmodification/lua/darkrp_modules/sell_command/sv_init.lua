local owner_table = {}

--Global entity store
hook.Add("playerBoughtCustomEntity", "IdentifyBuyerOfEntity", function(ply, entTable, ent, price)
    owner_table[ent] = {
	    owner = ply,
	    price = price
    }
end)

hook.Add('LVS.CanPlayerDrive', 'Whitelist', function(ply, vehicle)
    if (owner_table[vehicle].owner == ply) then
        return true
    else
        --Alert player he cant drive this
        ply:ChatPrint("You do not own this vehicle!")
        return false
    end
end)


local function SellEntity(ply)
    local ent = ply:GetEyeTrace().Entity
    if (ent == nil or owner_table[ent] == nil) then
        ply:ChatPrint("You can't sell this!") 
	return
    elseif (owner_table[ent].owner != ply) then
        ply:ChatPrint("You do not own this!") 
	return 
    end  
    s_price = owner_table[ent].price * 0.7
    ply:ChatPrint("Sell: You sold " .. tostring(ent) .. " for " .. tostring(s_price))
    ply:addMoney(owner_table[ent].price * 0.7)
    ent:Remove()
end

DarkRP.defineChatCommand("sell", SellEntity)
