if CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Hook = zmlab2.Hook or {}

// Lets call this so other scripts who use this hook can run their code on the bought entity
function zmlab2.Hook.SimulateBuy(ply,ent,name,price)
	if not IsValid(ent) then return end
	if not IsValid(ply) then return end

	local ActiveHooks = hook.GetTable()

	// Simulate Buy hook for DarkRP
	if ActiveHooks["playerBoughtCustomEntity"] then
		local tblEnt = {
			price = price,
			name = name or ""
		}
		hook.Run("playerBoughtCustomEntity", ply, tblEnt, ent, price)

	// Simulate Buy hook for Basewars
	elseif ActiveHooks["BaseWars_PlayerBuyEntity"] then
		hook.Run("BaseWars_PlayerBuyEntity", ply, ent)
	end
end

local entTable = {
	["zmlab2_equipment"] = true,
	["zmlab2_storage"] = true,
	["zmlab2_table"] = true,
	["zmlab2_tent"] = true,

	["zmlab2_item_acid"] = true,
	["zmlab2_item_aluminium"] = true,
	["zmlab2_item_crate"] = true,
	["zmlab2_item_meth"] = true,
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

zmlab2.Hook.Add("playerBoughtCustomEntity", "DarkRP_SetOwnerOnEntBuy", function(ply, enttbl, ent, price)
	if entTable[ent:GetClass()] then
		zmlab2.Player.SetOwner(ent, ply)
	end
end)

zmlab2.Hook.Add("BaseWars_PlayerBuyEntity", "Basewars_SetOwnerOnEntBuy", function(ply, ent)
	if entTable[ent:GetClass()] then
		zmlab2.Player.SetOwner(ent, ply)
	end
end)


// This automaticly blacklists the entities from the pocket swep
if GM and GM.Config and GM.Config.PocketBlacklist then
	for k,v in pairs(entTable) do
		GM.Config.PocketBlacklist[k] = true
	end
end
