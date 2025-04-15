zmlab2 = zmlab2 or {}

zmlab2.Sound = zmlab2.Sound or {}
zmlab2.Sound.List = zmlab2.Sound.List or {}

// This packs the requested sound Data
function zmlab2.Sound.Catch(id)
	local soundData = {}
	local soundTable = zmlab2.Sound.List[id]
	soundData.sound = soundTable.paths[math.random(#soundTable.paths)]
	soundData.lvl = soundTable.lvl
	soundData.pitch = math.Rand(soundTable.pitchMin, soundTable.pitchMax)
	soundData.volume = soundTable.volume or 1 //zmlab2.Convar.Get("zmlab2_cl_sfx_volume") or 1

	return soundData
end

function zmlab2.Sound.EmitFromPosition(pos,id)
	local soundData = zmlab2.Sound.Catch(id)
	sound.Play(soundData.sound, pos, soundData.lvl, soundData.pitch, soundData.volume)
end

function zmlab2.Sound.EmitFromEntity(id, ent)

	local cur_time = math.Round(CurTime(),2)

	// Lets make sure we dont play the same sound at the same time more then a specified amount 5
	if ent.SoundTracker and ent.SoundTracker[id] and ent.SoundTracker[id][cur_time] and ent.SoundTracker[id][cur_time] >= 5 then
		return
	else
		if ent.SoundTracker == nil then
			ent.SoundTracker = {}
		end

		if ent.SoundTracker[id] == nil then
			ent.SoundTracker[id] = {}
		end

		ent.SoundTracker[id][cur_time] = (ent.SoundTracker[id][cur_time] or 0) + 1
	end

	local soundData = zmlab2.Sound.Catch(id)
	ent:EmitSound(soundData.sound, soundData.lvl, soundData.pitch, soundData.volume, CHAN_STATIC, 0, 0)
end

function zmlab2.Sound.StopFromEntity(id, ent)
	local soundData = zmlab2.Sound.Catch(id)
	ent:StopSound(soundData.sound)
end

sound.Add({
	name = "zmlab2_npc_sell",
	channel = CHAN_STATIC,
	volume = 1,
	level = 70,
	pitch = {100, 100},
	sound = {"vo/npc/male01/question05.wav", "vo/npc/male01/question06.wav", "vo/npc/male01/question09.wav", "vo/npc/male01/question10.wav", "vo/npc/male01/question13.wav", "vo/npc/male01/question18.wav", "vo/npc/male01/question19.wav", "vo/npc/male01/question23.wav", "vo/npc/male01/question25.wav", "vo/npc/male01/question27.wav", "vo/npc/male01/question28.wav"}
})

sound.Add({
	name = "zmlab2_dropoff_door",
	channel = CHAN_STATIC,
	volume = 1,
	level = 70,
	pitch = {70, 90},
	sound = {"doors/door_metal_thin_close2.wav",
	"doors/door_metal_thin_move1.wav", "doors/door_metal_thin_open1.wav"}
})

sound.Add({
	name = "zmlab2_ui_click",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"UI/buttonclick.wav"}
})

sound.Add({
	name = "zmlab2_sniff",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {95, 105},
	sound = {"zmlab2/sniff01.wav","zmlab2/sniff02.wav"}
})

sound.Add({
	name = "zmlab2_npc_wrongjob",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"vo/npc/male01/pardonme01.wav", "vo/npc/male01/pardonme02.wav"}
})


sound.Add({
	name = "zmlab2_minigame_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 75,
	pitch = {100, 100},
	sound = "zmlab2/minigame_loop.wav"
})

sound.Add({
	name = "zmlab2_errorgame_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 75,
	pitch = {100, 100},
	sound = "zmlab2/errorgame_loop.wav"
})

sound.Add( {
	name = "zmlab2_boil01_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 75,
	pitch = {100, 100},
	sound = "zmlab2/boil01_loop.wav"
} )
sound.Add( {
	name = "zmlab2_boil02_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 75,
	pitch = {100, 100},
	sound = "zmlab2/boil02_loop.wav"
} )

sound.Add( {
	name = "zmlab2_tent_construction_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 75,
	pitch = {100, 100},
	sound = "zmlab2/tent_construction_loop.wav"
} )

sound.Add( {
	name = "zmlab2_machine_icebreaker_loop",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 75,
	pitch = {100, 100},
	sound = "ambient/machines/engine1.wav"
} )


sound.Add({
	name = "zmlab2_meth_consum",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 75,
	pitch = {100, 100},
	sound = {"zmlab2/meth_consum02.wav", "zmlab2/meth_consum02.wav", "zmlab2/meth_consum02.wav"}
})

sound.Add({
	name = "zmlab2_crate_place",
	channel = CHAN_STATIC,
	volume = 1,
	level = 75,
	pitch = {100, 100},
	sound = {"physics/plastic/plastic_barrel_impact_soft1.wav", "physics/plastic/plastic_barrel_impact_soft2.wav", "physics/plastic/plastic_barrel_impact_soft3.wav"}
})


// Add all the meth musics
for k, v in pairs(zmlab2.config.MethTypes) do
	if v.visuals.music then
		sound.Add({
			name = "zmlab2_meth_music_" .. k,
			channel = CHAN_STATIC,
			volume = 1,
			level = 75,
			pitch = {100, 100},
			sound = v.visuals.music
		})
	end
end



zmlab2.Sound.List["minigame_fail"] = {
	paths = {
		"physics/metal/metal_box_impact_bullet1.wav",
		"physics/metal/metal_box_impact_bullet2.wav",
		"physics/metal/metal_box_impact_bullet3.wav",
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["machine_explode"] = {
	paths = {
		"weapons/explode3.wav",
		"weapons/explode4.wav",
		"weapons/explode5.wav",
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["meth_breaking"] = {
	paths = {
		"zmlab2/meth_breaking01.mp3",
		"zmlab2/meth_breaking02.mp3",
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["progress_fillingcrate"] = {
	paths = {
		"zmlab2/process_fillingcrate.wav",
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["lox_explo"] = {
	paths = {
		"zmlab2/lox_explo.wav",
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}



zmlab2.Sound.List["crate_place"] = {
	paths = {
		"physics/plastic/plastic_barrel_impact_soft4.wav",
		"physics/plastic/plastic_barrel_impact_soft5.wav",
		"physics/plastic/plastic_barrel_impact_soft6.wav"
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["gas_buff"] = {
	paths = {"zmlab2/gas_buff01.wav","zmlab2/gas_buff02.wav","zmlab2/gas_buff03.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["zapp"] = {
	paths = {
		"ambient/energy/spark1.wav",
		"ambient/energy/spark2.wav",
		"ambient/energy/spark3.wav",
		"ambient/energy/spark4.wav",
		"ambient/energy/spark5.wav",
		"ambient/energy/spark6.wav"
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}


zmlab2.Sound.List["Extinguish"] = {
	paths = {"player/sprayer.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}
zmlab2.Sound.List["cash"] = {
	paths = {"zmlab2/cash.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["liquid_fill"] = {
	paths = {"zmlab2/liquid_fill01.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100,
	volume = 0.5
}

zmlab2.Sound.List["crate_fill"] = {
	paths = {"zmlab2/methcrate_fill01.mp3","zmlab2/methcrate_fill02.mp3"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["lox_loaded"] = {
	paths = {"zmlab2/air_release01.wav","zmlab2/air_release02.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

sound.Add({
	name = "zmlab2_machine_compressing",
	channel = CHAN_STATIC,
	volume = 0.25,
	level = 60,
	pitch = {100, 100},
	sound = {"zmlab2/compressor_loop.wav"}
})



sound.Add({
	name = "progress_collecting",
	channel = CHAN_STATIC,
	volume = 1,
	level = 70,
	pitch = {50, 100},
	sound = {"physics/plastic/plastic_barrel_impact_soft1.wav",
	"physics/plastic/plastic_barrel_impact_soft2.wav", "physics/plastic/plastic_barrel_impact_soft3.wav", "physics/plastic/plastic_barrel_impact_soft4.wav", "physics/plastic/plastic_barrel_impact_soft5.wav"}
})

sound.Add({
	name = "zmlab2_machine_pumping",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"ambient/machines/city_ventpump_loop1.wav"}
})

sound.Add({
	name = "zmlab2_gas_indicator",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {
		"player/geiger1.wav",
		"player/geiger2.wav",
		"player/geiger3.wav"
	}
})




sound.Add({
	name = "zmlab2_machine_venting",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"zmlab2/fermenting.wav"}
})
sound.Add({
	name = "zmlab2_machine_mixing",
	channel = CHAN_STATIC,
	volume = 1,
	level = 55,
	pitch = {100, 100},
	sound = {"ambient/levels/labs/machine_moving_loop4.wav"}
})



sound.Add({
	name = "zmlab2_machine_ventilation",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"zmlab2/ventilation_on_loop.wav"}
})

sound.Add({
	name = "zmlab2_ventilation_off",
	channel = CHAN_STATIC,
	volume = 1,
	level = 70,
	pitch = {100, 100},
	sound = {"zmlab2/ventilation_off.wav"}
})


// 949137607
sound.Add({
	name = "zmlab2_machine_condensing",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"zmlab2/condensing.wav"}
})

sound.Add({
	name = "zmlab2_machine_cooling",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"zmlab2/cooling.wav"}
})

/*
sound.Add({
	name = "zmlab2_vent_off",
	channel = CHAN_STATIC,
	volume = 1,
	level = 70,
	pitch = {100, 100},
	sound = {"zmlab2/vent_off.wav"}
})

sound.Add({
	name = "zmlab2_vent_on",
	channel = CHAN_STATIC,
	volume = 1,
	level = 70,
	pitch = {100, 100},
	sound = {"zmlab2/vent_on.wav"}
})
*/

zmlab2.Sound.List["frezzing_crack"] = {
	paths = {
		"zmlab2/meth_frezzing01.mp3",
		"zmlab2/meth_frezzing02.mp3",
		"zmlab2/meth_frezzing03.mp3",
		"zmlab2/meth_frezzing04.mp3",
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["cleaning_splash"] = {
	paths = {"ambient/water/water_splash1.wav","ambient/water/water_splash2.wav","ambient/water/water_splash3.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100,
	volume = 0.30
}

zmlab2.Sound.List["cleaning_shrub"] = {
	paths = {
		"zmlab2/clean01.wav",
		"zmlab2/clean02.wav",
		"zmlab2/clean03.wav",
		"zmlab2/clean04.wav",
		"zmlab2/clean05.wav",
		"zmlab2/clean06.wav",
		"zmlab2/clean07.wav",
		"zmlab2/clean08.wav",
		"zmlab2/clean09.wav",
		"zmlab2/clean10.wav",
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["aluminium_fill"] = {
	paths = {"zmlab2/aluminfill01.mp3","zmlab2/aluminfill02.mp3"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["acid_explo"] = {
	paths = {"zmlab2/acid_explo.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["aluminium_explo"] = {
	paths = {"zmlab2/aluminiumshake01.mp3","zmlab2/aluminiumshake02.mp3","zmlab2/aluminiumshake03.mp3","zmlab2/aluminiumshake04.mp3","zmlab2/aluminiumshake05.mp3"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["tent_unfold"] = {
	paths = {"zmlab2/tent_unfold.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["tent_construction_complete"] = {
	paths = {"zmlab2/tent_construction_complete.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["progress_done"] = {
	paths = {"buttons/combine_button_locked.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["progress_error"] = {
	paths = {"common/warning.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["task_completed"] = {
	paths = {"buttons/button3.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}


zmlab2.Sound.List["button_change"] = {
	paths = {"buttons/blip1.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["pumpsystem_start"] = {
	paths = {"buttons/lever8.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["pumpsystem_connected"] = {
	paths = {"buttons/lever7.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100
}

zmlab2.Sound.List["tray_addqueue"] = {
	paths = {"physics/metal/metal_solid_impact_soft3.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100,
	volume = 0.25,
}

zmlab2.Sound.List["tray_drop"] = {
	paths = {
	"physics/metal/metal_sheet_impact_hard2.wav",
	"physics/metal/metal_sheet_impact_hard6.wav",
	"physics/metal/metal_sheet_impact_hard7.wav"
	},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100,
	volume = 0.25,
}

zmlab2.Sound.List["tray_add"] = {
	paths = {"physics/metal/metal_sheet_impact_soft2.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100,
	volume = 0.25,
}

zmlab2.Sound.List["error"] = {
	paths = {"zmlab2/error.wav"},
	lvl = 75,
	pitchMin = 100,
	pitchMax = 100,
	volume = 1,
}
