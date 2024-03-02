local function IsValidConfig(npc_type)
   return bgNPC.cfg.npcs_template[npc_type] ~= nil
end

if IsValidConfig('citizen') then
   local citizen = bgNPC.cfg.npcs_template['citizen']
   citizen.random_skin = true
   citizen.random_bodygroups = true
   citizen.default_models = true
   citizen.weapons = { 
      'mg_357',
      'mg_deagle',
      'mg_p320',
      'mg_m1911',
      'mg_m9',
      'mg_makarov',
      'mg_glock',
      'mg_charlie725',
   }
   citizen.models = {
      'models/smalls_civilians/pack1/hoodie_male_01_f_npc.mdl',
      'models/smalls_civilians/pack1/hoodie_male_02_f_npc.mdl',
      'models/smalls_civilians/pack1/hoodie_male_03_f_npc.mdl',
      'models/smalls_civilians/pack1/hoodie_male_04_f_npc.mdl',
      'models/smalls_civilians/pack1/hoodie_male_05_f_npc.mdl',
      'models/smalls_civilians/pack1/hoodie_male_07_f_npc.mdl',
      'models/smalls_civilians/pack1/hoodie_male_09_f_npc.mdl',
      'models/smalls_civilians/pack1/puffer_male_01_f_npc.mdl',
      'models/smalls_civilians/pack1/puffer_male_02_f_npc.mdl',
      'models/smalls_civilians/pack1/puffer_male_03_f_npc.mdl',
      'models/smalls_civilians/pack1/puffer_male_04_f_npc.mdl',
      'models/smalls_civilians/pack1/puffer_male_05_f_npc.mdl',
      'models/smalls_civilians/pack1/puffer_male_07_f_npc.mdl',
      'models/smalls_civilians/pack1/puffer_male_09_f_npc.mdl',
      'models/smalls_civilians/pack1/zipper_female_01_f_npc.mdl',
      'models/smalls_civilians/pack1/zipper_female_02_f_npc.mdl',
      'models/smalls_civilians/pack1/zipper_female_03_f_npc.mdl',
      'models/smalls_civilians/pack1/zipper_female_04_f_npc.mdl',
      'models/smalls_civilians/pack1/zipper_female_06_f_npc.mdl',
      'models/smalls_civilians/pack1/zipper_female_07_f_npc.mdl',
      'models/humans/group02/tale_01.mdl',
      'models/humans/group02/tale_03.mdl',
      'models/humans/group02/tale_04.mdl',
      'models/humans/group02/tale_05.mdl',
      'models/humans/group02/tale_06.mdl',
      'models/humans/group02/tale_07.mdl',
      'models/humans/group02/tale_08.mdl',
      'models/humans/group02/tale_09.mdl',
      'models/humans/group02/temale_01.mdl',
      'models/humans/group02/temale_02.mdl',
      'models/humans/group02/temale_07.mdl',
   }
   citizen.at_random = {
        ['walk'] = 90,
        ['idle'] = 10,
    }
end

if IsValidConfig('gangster') then
   local gangster = bgNPC.cfg.npcs_template['gangster']
   gangster.random_skin = true
   gangster.random_bodygroups = true
   gangster.default_models = false
   gangster.weapon_skill = WEAPON_PROFICIENCY_POOR
   gangster.weapons = { 
      'mg_357',
      'mg_deagle',
      'mg_p320',
      'mg_m1911',
      'mg_m9',
      'mg_makarov',
      'mg_glock',
      'mg_charlie725',
   }
   gangster.models = {
      'models/humans/group02/tale_01.mdl',
      'models/humans/group02/tale_03.mdl',
      'models/humans/group02/tale_04.mdl',
      'models/humans/group02/tale_05.mdl',
      'models/humans/group02/tale_06.mdl',
      'models/humans/group02/tale_07.mdl',
      'models/humans/group02/tale_08.mdl',
      'models/humans/group02/tale_09.mdl',
      'models/humans/group02/temale_01.mdl',
      'models/humans/group02/temale_02.mdl',
      'models/humans/group02/temale_07.mdl',
      -- 'models/survivors/npc/amy.mdl',
      -- 'models/survivors/npc/candace.mdl',
      -- 'models/survivors/npc/carson.mdl',
      -- 'models/survivors/npc/chris.mdl',
      -- 'models/survivors/npc/damian.mdl',
      -- 'models/survivors/npc/gregory.mdl',
      -- 'models/survivors/npc/isa.mdl',
      -- 'models/survivors/npc/john.mdl',
      -- 'models/survivors/npc/lucus.mdl',
      -- 'models/survivors/npc/lyndsay.mdl',
      -- 'models/survivors/npc/margaret.mdl',
      -- 'models/survivors/npc/matt.mdl',
      -- 'models/survivors/npc/rachel.mdl',
      -- 'models/survivors/npc/rufus.mdl',
      -- 'models/survivors/npc/tyler.mdl',
      -- 'models/survivors/npc/wolfgang.mdl',
   }
end

if IsValidConfig('police') then
   local police = bgNPC.cfg.npcs_template['police']
   police.random_skin = true
   police.random_bodygroups = true
   police.default_models = false
   police.weapons = {'mg_mpapa5', 'mg_p320'}
   police.weapon_skill = WEAPON_PROFICIENCY_GOOD
   police.class = 'npc_citizen'
   police.models = {
      'models/sentry/hkpd/sentryhkpdmale5h.mdl',
      'models/sentry/hkpd/sentryhkpdmale7h.mdl',
   }
end

if IsValidConfig('special_forces') then
   local special_forces = bgNPC.cfg.npcs_template['special_forces']
   special_forces.random_skin = true
   special_forces.random_bodygroups = true
   special_forces.default_models = false
   special_forces.weapons = {'mg_sierra552'}
   special_forces.models = {
      'models/sentry/hkpd/hkpdptuh.mdl',
   }
end

if IsValidConfig('special_forces_2') then
   local special_forces_2 = bgNPC.cfg.npcs_template['special_forces_2']
   special_forces_2.random_skin = true
   special_forces_2.random_bodygroups = true
   special_forces_2.default_models = false
   special_forces_2.weapons = {'mg_g3a3'}
   special_forces_2.models = {
      'models/sentry/hkpd/hkpdptuh.mdl',
   }
end
