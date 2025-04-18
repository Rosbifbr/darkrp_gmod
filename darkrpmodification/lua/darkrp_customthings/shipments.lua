--[[---------------------------------------------------------------------------
DarkRP Custom Shipments: COD 2019
Replaced all ARC CW shipments with COD 2019 counterparts
Removed ARC CW guns
---------------------------------------------------------------------------]]

local price_multiplier = 0.2

local shipments = {
	Rifles = {
		{ name = "AK-47", entity = "arc9_cod2019_ar_ak47", price = 20000, amount = 4, pricesep = 7000 },
		{ name = "AN-94", entity = "arc9_cod2019_ar_an94", price = 21000, amount = 3, pricesep = 7500 },
		{ name = "RAM-7", entity = "arc9_cod2019_ar_ram7", price = 23000, amount = 3, pricesep = 8200 },
		{ name = "FAL", entity = "arc9_cod2019_ar_fal", price = 24000, amount = 3, pricesep = 8500 },
		{ name = "Grau 5.56", entity = "arc9_cod2019_ar_grau556", price = 25000, amount = 3, pricesep = 9000 },
		{ name = "FAMAS", entity = "arc9_cod2019_ar_famas", price = 24000, amount = 3, pricesep = 8500 },
		{ name = "AS VAL", entity = "arc9_cod2019_ar_asval", price = 26000, amount = 2, pricesep = 9500 },
		{ name = "SCAR-20", entity = "arc9_cod2019_ar_scar", price = 26000, amount = 2, pricesep = 9500 },
		{ name = "M13", entity = "arc9_cod2019_ar_m13", price = 20000, amount = 4, pricesep = 7200 },
		{ name = "M4A1", entity = "arc9_cod2019_ar_m4", price = 23000, amount = 3, pricesep = 8200 },
		{ name = "CR-56 AMAX", entity = "arc9_cod2019_ar_cr56amax", price = 24000, amount = 3, pricesep = 8500 },
		{ name = "Kilo 141", entity = "arc9_cod2019_ar_kilo141", price = 25000, amount = 3, pricesep = 9000 },
	},

	LMG = {
		{ name = "Minigun", entity = "arc9_cod2019_lm_minigun", price = 32000, amount = 2, pricesep = 12000 },
		{ name = "MG34", entity = "arc9_cod2019_lm_mg34", price = 30000, amount = 2, pricesep = 11000 },
		{ name = "PKM", entity = "arc9_cod2019_lm_pkm", price = 31000, amount = 2, pricesep = 11500 },
		{ name = "Bruen MK9", entity = "arc9_cod2019_lm_bruenmk9", price = 33000, amount = 2, pricesep = 12500 },
		{ name = "Holger", entity = "arc9_cod2019_lm_holger", price = 34000, amount = 2, pricesep = 13000 },
		{ name = "SA86", entity = "arc9_cod2019_lm_sa86", price = 30000, amount = 2, pricesep = 11000 },
	},

	Marksman = {
		{ name = "M14", entity = "arc9_cod2019_mm_m14", price = 22000, amount = 3, pricesep = 8200 },
		{ name = "Kar98k", entity = "arc9_cod2019_mm_kar98k", price = 24000, amount = 2, pricesep = 9000 },
		{ name = "SPR-208", entity = "arc9_cod2019_mm_spr208", price = 23000, amount = 3, pricesep = 8500 },
		{ name = "SKS", entity = "arc9_cod2019_mm_sks", price = 21000, amount = 3, pricesep = 7500 },
		{ name = "MK2 Carbine", entity = "arc9_cod2019_mm_mk2", price = 25000, amount = 2, pricesep = 9000 },
		{ name = "Crossbow", entity = "arc9_cod2019_mm_crossbow", price = 20000, amount = 2, pricesep = 8000 },
		{ name = "SVD", entity = "arc9_cod2019_sn_svd", price = 26000, amount = 2, pricesep = 9500 },
		{ name = "Rytec AMR", entity = "arc9_cod2019_sn_rytec", price = 28000, amount = 2, pricesep = 10000 },
		{ name = "HDR", entity = "arc9_cod2019_sn_hdr", price = 30000, amount = 2, pricesep = 11000 },
		{ name = "AX-50", entity = "arc9_cod2019_sn_ax50", price = 32000, amount = 1, pricesep = 12000 },
	},

	Handguns = {
		allowedTeams = { TEAM_GUN, TEAM_MOB },
		{ name = ".50 GS", entity = "arc9_cod2019_pi_50gs", price = 10000, amount = 3, pricesep = 4000 },
		{ name = "Sykov", entity = "arc9_cod2019_pi_sykov", price = 9000, amount = 4, pricesep = 3500 },
		{ name = ".357", entity = "arc9_cod2019_pi_357", price = 9500, amount = 3, pricesep = 3800 },
		{ name = ".357 Akimbo", entity = "arc9_cod2019_pi_357_akimbo", price = 19000, amount = 2, pricesep = 7500 },
		{ name = "M1911", entity = "arc9_cod2019_pi_m1911", price = 9000, amount = 4, pricesep = 3500 },
		{ name = "M1911 Akimbo", entity = "arc9_cod2019_pi_m1911_akimbo", price = 18000, amount = 2, pricesep = 7000 },
		{ name = "X16", entity = "arc9_cod2019_pi_x16", price = 9000, amount = 4, pricesep = 3500 },
		{ name = "X16 Akimbo", entity = "arc9_cod2019_pi_x16_akimbo", price = 18000, amount = 2, pricesep = 7000 },
		{ name = "Renetti", entity = "arc9_cod2019_pi_renetti", price = 10000, amount = 3, pricesep = 4000 },
		{ name = "Renetti Akimbo", entity = "arc9_cod2019_pi_renetti_akimbo", price = 20000, amount = 2, pricesep = 8000 },
		{ name = "M19", entity = "arc9_cod2019_pi_m19", price = 9500, amount = 3, pricesep = 3800 },
		{ name = "M19 Akimbo", entity = "arc9_cod2019_pi_m19_akimbo", price = 19000, amount = 2, pricesep = 7600 },
		{ name = "50 GS Akimbo", entity = "arc9_cod2019_pi_50gs_akimbo", price = 20000, amount = 2, pricesep = 8000 },
		{ name = "Sykov Akimbo", entity = "arc9_cod2019_pi_sykov_akimbo", price = 18000, amount = 2, pricesep = 7200 },
	},

	Shotguns = {
		{ name = "Origin 12", entity = "arc9_cod2019_sh_origin12", price = 20000, amount = 2, pricesep = 7500 },
		{ name = "Origin 12 (VLK)", entity = "arc9_cod2019_sh_vlk", price = 21000, amount = 3, pricesep = 8000 },
		{ name = "Model 680", entity = "arc9_cod2019_sh_model680", price = 18000, amount = 3, pricesep = 6500 },
		{ name = "R90", entity = "arc9_cod2019_sh_r90", price = 16000, amount = 4, pricesep = 6000 },
		{ name = "Jak-12", entity = "arc9_cod2019_sh_jak12", price = 17000, amount = 3, pricesep = 6800 },
		{ name = "725", entity = "arc9_cod2019_sh_725", price = 19000, amount = 2, pricesep = 7200 },
	},

	SMGs = {
		allowedTeams = { TEAM_GUN, TEAM_MOB },
		{ name = "MP5", entity = "arc9_cod2019_sm_mp5", price = 19000, amount = 2, pricesep = 7000 },
		{ name = "MP7", entity = "arc9_cod2019_sm_mp7", price = 22000, amount = 2, pricesep = 8000 },
		{ name = "MP9", entity = "arc9_cod2019_sm_cx9", price = 20000, amount = 2, pricesep = 7500 },
		{ name = "UMP-45", entity = "arc9_cod2019_sm_iso", price = 21000, amount = 3, pricesep = 7500 },
		{ name = "Striker45", entity = "arc9_cod2019_sm_striker45", price = 20000, amount = 3, pricesep = 7200 },
		{ name = "Vector", entity = "arc9_cod2019_sm_vector", price = 21000, amount = 2, pricesep = 7500 },
		{ name = "Uzi", entity = "arc9_cod2019_sm_uzi", price = 18000, amount = 3, pricesep = 6500 },
		{ name = "Bizon", entity = "arc9_cod2019_sm_bizon", price = 21000, amount = 2, pricesep = 7500 },
		{ name = "P90", entity = "arc9_cod2019_sm_p90", price = 18000, amount = 3, pricesep = 6500 },
	},

	Misc = {
		{
			name = "Strela Launcher",
			entity = "arc9_cod2019_la_strela",
			price = 30000,
			amount = 2,
			pricesep = 10000,
			allowed = { TEAM_MAYOR, TEAM_CHIEF },
		},
		{
			name = "40mm M32",
			entity = "arc9_cod2019_la_m32",
			price = 28000,
			amount = 3,
			pricesep = 9000,
			allowed = { TEAM_MAYOR, TEAM_CHIEF },
		},
		{
			name = "RPG",
			entity = "arc9_cod2019_la_rpg",
			price = 32000,
			amount = 2,
			pricesep = 12000,
			allowed = { TEAM_MAYOR, TEAM_CHIEF },
		},
		{
			name = "PILA",
			entity = "arc9_cod2019_la_pila",
			price = 31000,
			amount = 2,
			pricesep = 11500,
			allowed = { TEAM_MAYOR, TEAM_CHIEF },
		},
		{
			name = "Frag Grenade",
			entity = "arc9_cod2019_nade_frag",
			price = 500,
			amount = 1,
			pricesep = 500,
			noship = true,
			allowed = { TEAM_GUN, TEAM_MOB },
		},
		{
			name = "Claymore",
			entity = "arc9_cod2019_nade_claymores",
			price = 1000,
			amount = 1,
			pricesep = 1000,
			noship = true,
			allowed = { TEAM_GUN, TEAM_MOB },
		},
		{
			name = "Semtex",
			entity = "arc9_cod2019_nade_semtex",
			price = 1200,
			amount = 1,
			pricesep = 1200,
			noship = true,
			allowed = { TEAM_GUN, TEAM_MOB },
		},
		{
			name = "Molotov",
			entity = "arc9_cod2019_nade_molotov",
			price = 800,
			amount = 1,
			pricesep = 800,
			noship = true,
			allowed = { TEAM_GUN, TEAM_MOB },
		},
		{
			name = "Smoke Grenade",
			entity = "arc9_cod2019_nade_smoke",
			price = 600,
			amount = 1,
			pricesep = 600,
			noship = true,
			allowed = { TEAM_GUN, TEAM_MOB },
		},
		{
			name = "Flashbang",
			entity = "arc9_cod2019_nade_flash",
			price = 700,
			amount = 1,
			pricesep = 700,
			noship = true,
			allowed = { TEAM_GUN, TEAM_MOB },
		},
	},
}

-- Create categories and shipments
for category, list in pairs(shipments) do
	DarkRP.createCategory({
		name = category,
		categorises = "shipments",
		startExpanded = true,
		color = Color(255, 0, 0, 255),
		canSee = function()
			return true
		end,
		sortOrder = ({ Rifles = 1, LMG = 2, Marksman = 3, Handguns = 4, Shotguns = 5, SMGs = 6, Misc = 7 })[category],
	})
	for _, s in ipairs(list) do
		DarkRP.createShipment(s.name, {
			model = "models/props/cs_office/cardboard_box03.mdl",
			entity = s.entity,
			price = s.price * price_multiplier,
			amount = s.amount,
			separate = true,
			pricesep = s.pricesep * price_multiplier,
			noship = s.noship or false,
			allowed = s.allowed or list.allowedTeams or { TEAM_GUN },
			category = category,
		})
	end
end
