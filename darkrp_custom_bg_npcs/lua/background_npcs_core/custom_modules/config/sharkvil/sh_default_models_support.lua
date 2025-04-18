-- NPCS JOBS
local function IsValidConfig(npc_type)
	return bgNPC.cfg.npcs_template[npc_type] ~= nil
end

if IsValidConfig("citizen") then
	local citizen = bgNPC.cfg.npcs_template["citizen"]
	citizen.random_skin = true
	citizen.random_bodygroups = true
	citizen.default_models = true
	citizen.weapons = {
		-- Handguns
		"arc9_cod2019_pi_50gs",
		"arc9_cod2019_pi_sykov",
		"arc9_cod2019_pi_357",
		"arc9_cod2019_pi_m1911",
		"arc9_cod2019_pi_x16",
		"arc9_cod2019_pi_renetti",
		"arc9_cod2019_pi_m19",
		"arc9_cod2019_pi_sykov_akimbo",
	}
	citizen.models = {
		-- (unchanged)
		"models/smalls_civilians/pack1/hoodie_male_01_f_npc.mdl",
		-- etc…
	}
	citizen.at_random = {
		walk = 90,
		idle = 10,
	}
end

if IsValidConfig("gangster") then
	local gangster = bgNPC.cfg.npcs_template["gangster"]
	gangster.random_skin = true
	gangster.random_bodygroups = true
	gangster.default_models = false
	gangster.weapon_skill = WEAPON_PROFICIENCY_POOR
	gangster.weapons = {
		-- same handguns as citizens
		"arc9_cod2019_pi_50gs",
		"arc9_cod2019_pi_sykov",
		"arc9_cod2019_pi_357",
		"arc9_cod2019_pi_m1911",
		"arc9_cod2019_pi_x16",
		"arc9_cod2019_pi_renetti",
		"arc9_cod2019_pi_m19",
	}
	gangster.models = {
		-- (unchanged)
		"models/humans/group02/tale_01.mdl",
		-- etc…
	}
end

if IsValidConfig("police") then
	local police = bgNPC.cfg.npcs_template["police"]
	police.random_skin = true
	police.random_bodygroups = true
	police.default_models = false
	police.weapon_skill = WEAPON_PROFICIENCY_GOOD
	police.class = "npc_citizen"
	police.weapons = {
		-- SMGs
		"arc9_cod2019_sm_uzi",
	}
	police.models = {
		-- (unchanged)
		"models/sentry/hkpd/sentryhkpdmale5h.mdl",
		"models/sentry/hkpd/sentryhkpdmale7h.mdl",
	}
end

if IsValidConfig("special_forces") then
	local sf = bgNPC.cfg.npcs_template["special_forces"]
	sf.random_skin = true
	sf.random_bodygroups = true
	sf.default_models = false
	sf.weapons = {
		-- Assault rifles
		"arc9_cod2019_ar_grau556",
	}
	sf.models = {
		-- (unchanged)
		"models/sentry/hkpd/hkpdptuh.mdl",
	}
end

if IsValidConfig("special_forces_2") then
	local sf2 = bgNPC.cfg.npcs_template["special_forces_2"]
	sf2.random_skin = true
	sf2.random_bodygroups = true
	sf2.default_models = false
	sf2.weapons = {
		-- LMGs
		"arc9_cod2019_lm_sa86",
	}
	sf2.models = {
		-- (unchanged)
		"models/sentry/hkpd/hkpdptuh.mdl",
	}
end
