zmlab2 = zmlab2 or {}
zmlab2.NetEvent = zmlab2.NetEvent or {}
zmlab2.Effect = zmlab2.Effect or {}

local function CreateRandomDecals(pos,decal,radius)
	for i = 1, 15 do
		local decal_pos = pos + Vector(1,0,0) * math.random(-radius, radius) + Vector(0,1,0) * math.random(-radius, radius)
		util.Decal(decal, decal_pos + Vector(0,0,5), decal_pos - Vector(0,0,50))
	end
end

// Here we define diffrent effect groups which later make it pretty optimized to create Sound/Particle effects over the network
// The key will be used as the NetworkString
zmlab2.NetEvent.Definitions = {
	["sell"] = {
		action = function(pos)
			zmlab2.Effect.ParticleEffect("zmlab2_purchase", pos, angle_zero, Entity(1))
			zmlab2.Sound.EmitFromPosition(pos, "cash")
		end
	},
	["clean"] = {
		action = function(pos)
			zmlab2.Effect.ParticleEffect("zmlab2_cleaning", pos, angle_zero, Entity(1))
			zmlab2.Sound.EmitFromPosition(pos, "cleaning_shrub")
			zmlab2.Sound.EmitFromPosition(pos, "cleaning_splash")
		end
	},
	["extinguish"] = {
		action = function(pos)
			zmlab2.Effect.ParticleEffect("zmlab2_extinguish", pos, angle_zero, Entity(1))
			zmlab2.Sound.EmitFromPosition(pos, "Extinguish")
			//zmlab2.Sound.EmitFromEntity("Extinguish", Machine)
		end
	},

	["methylamin_fill"] = {
		_type = "entity",
		action = function(ent)
			zmlab2.Effect.ParticleEffect("zmlab2_methylamin_fill", ent:LocalToWorld(Vector(11,0,53)), angle_zero, ent)
		end
	},
	["aluminium_fill"] = {
		_type = "entity",
		action = function(ent)
			zmlab2.Effect.ParticleEffect("zmlab2_aluminium_fill", ent:LocalToWorld(Vector(11,0,60)), angle_zero, ent)
		end
	},
	["acid_fill"] = {
		_type = "entity",
		action = function(ent)
			zmlab2.Effect.ParticleEffect("zmlab2_acid_fill", ent:LocalToWorld(Vector(-5,0,62)), ent:LocalToWorldAngles(angle_zero), ent)
		end
	},

	["acid_explo"] = {
		action = function(pos)
			zmlab2.Effect.ParticleEffect("zmlab2_acid_explo", pos, angle_zero, Entity(1))
			zmlab2.Sound.EmitFromPosition(pos, "acid_explo")

			CreateRandomDecals(pos,"BeerSplash",50)
		end
	},
	["alu_explo"] = {
		action = function(pos)
			zmlab2.Effect.ParticleEffect("zmlab2_aluminium_explo", pos + Vector(0,0,10), angle_zero, Entity(1))
			zmlab2.Sound.EmitFromPosition(pos, "aluminium_explo")
		end
	},
	["methylamin_explo"] = {
		action = function(pos)
			zmlab2.Effect.ParticleEffect("zmlab2_methylamine_explo", pos, angle_zero, Entity(1))
			zmlab2.Sound.EmitFromPosition(pos, "cleaning_splash")
			CreateRandomDecals(pos,"BeerSplash",75)
		end
	},
	["meth_break"] = {
		_type = "meth",
		action = function(pos,id)
			local m_data = zmlab2.config.MethTypes[id]
			if m_data == nil or m_data.visuals == nil or m_data.visuals.effect_breaking == nil then return end
			zmlab2.Effect.ParticleEffect(m_data.visuals.effect_breaking, pos, angle_zero, Entity(1))
		end
	},
	["lox_explo"] = {
		action = function(pos)
			zmlab2.Effect.ParticleEffect("zmlab2_lox_explo", pos + Vector(0,0,10), angle_zero, Entity(1))
			zmlab2.Sound.EmitFromPosition(pos, "lox_explo")
		end
	},
	["meth_explo"] = {
		_type = "meth",
		action = function(pos,id)
			local m_data = zmlab2.config.MethTypes[id]
			if m_data == nil or m_data.visuals == nil or m_data.visuals.effect_exploding == nil then return end
			zmlab2.Effect.ParticleEffect(m_data.visuals.effect_exploding, pos + Vector(0,0,10), angle_zero, Entity(1))
			zmlab2.Sound.EmitFromPosition(pos, "progress_fillingcrate")
		end
	},
	["meth_fill"] = {
		_type = "meth",
		action = function(pos,id)
			local m_data = zmlab2.config.MethTypes[id]
			if m_data == nil or m_data.visuals == nil or m_data.visuals.effect_filling == nil then return end
			zmlab2.Effect.ParticleEffect(m_data.visuals.effect_filling, pos + Vector(0,0,10), angle_zero, Entity(1))
			zmlab2.Sound.EmitFromPosition(pos, "crate_fill")
		end
	},
}

if SERVER then
	// Creates a network string for all the effect groups
	for k, v in pairs(zmlab2.NetEvent.Definitions) do
		util.AddNetworkString("zmlab2_fx_" .. k)
	end

	// Sends a Net Effect Msg to all clients
	function zmlab2.NetEvent.Create(id, data01,data02)
		// Data can be a entity or position
		local EffectGroup = zmlab2.NetEvent.Definitions[id]

		// Some events should be called on server to
		if EffectGroup._server then
			EffectGroup.action(data01)
		end

		net.Start("zmlab2_fx_" .. id)

		if EffectGroup._type == "entity" then
			net.WriteEntity(data01)
		elseif EffectGroup._type == "meth" then
			net.WriteVector(data01)
			net.WriteUInt(data02,16)
		else
			net.WriteVector(data01)
		end

		net.Broadcast()
	end
end

if CLIENT then
	for k, v in pairs(zmlab2.NetEvent.Definitions) do
		net.Receive("zmlab2_fx_" .. k, function(len)
			if IsValid(LocalPlayer()) then
				if v._type == "entity" then
					local ent = net.ReadEntity()

					if IsValid(ent) then
						zmlab2.NetEvent.Definitions[k].action(ent)
					end
				elseif v._type == "meth" then
					local pos = net.ReadVector()
					local id = net.ReadUInt(16)
					if pos and id then
						zmlab2.NetEvent.Definitions[k].action(pos,id)
					end
				else
					local pos = net.ReadVector()

					if pos then
						zmlab2.NetEvent.Definitions[k].action(pos)
					end
				end
			end
		end)
	end

	function zmlab2.Effect.ParticleEffect(effect, pos, ang, ent)
		if zmlab2.Convar.Get("zmlab2_cl_particleeffects") == 0 then return end
		ParticleEffect(effect, pos, ang, ent)
	end

	function zmlab2.Effect.ParticleEffectAttach(effect, attachType,ent, attachid)
		if zmlab2.Convar.Get("zmlab2_cl_particleeffects") == 0 then return end
		ParticleEffectAttach(effect, attachType, ent, attachid)
	end
end
