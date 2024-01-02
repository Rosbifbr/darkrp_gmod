if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Damage = zmlab2.Damage or {}

function zmlab2.Damage.OnTake(entity, dmginfo)
	if (not entity.m_bApplyingDamage) then
		entity.m_bApplyingDamage = true

		entity:TakeDamageInfo(dmginfo)

		zmlab2.Damage.Inflict(entity,dmginfo)

		entity.m_bApplyingDamage = false
	end
end

local MethClass = {
	["zmlab2_item_meth"] = true,
	["zmlab2_item_crate"] = true,
	["zmlab2_item_palette"] = true
}

// Creates a util.Effect
function zmlab2.Damage.Effect(ent,effect)
	local vPoint = ent:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect(effect, effectdata)
end

function zmlab2.Damage.Inflict(entity,dmg)

	if zmlab2.config.Damageable[entity:GetClass()] and zmlab2.config.Damageable[entity:GetClass()] <= -1 then return end

	entity:SetHealth(entity:Health() - dmg:GetDamage())

	if dmg:GetDamageType() == DMG_BURN then
		local val = (255 / entity:GetMaxHealth()) * entity:Health()
		entity:SetColor(Color(val, val, val, 255))
	end

    if entity:Health() <= 0 then

        // If the entity was a meth object and the attacker was police then give him some cash
		if MethClass[entity:GetClass()] then
			hook.Run("zmlab2_OnMethObjectDestroyed", entity, dmg)
		else
			if entity:GetClass() == "zmlab2_item_acid" then
				zmlab2.Damage.Explosion(entity, entity:GetPos(), 50, DMG_ACID, 15,true)
				zmlab2.NetEvent.Create("acid_explo", entity:GetPos())
			elseif entity:GetClass() == "zmlab2_item_lox" then
				zmlab2.NetEvent.Create("lox_explo", entity:GetPos())
			elseif entity:GetClass() == "zmlab2_item_aluminium" then
				zmlab2.NetEvent.Create("alu_explo", entity:GetPos())
			elseif entity:GetClass() == "zmlab2_item_methylamine" then
				zmlab2.Damage.Explosion(entity, entity:GetPos(), 50, DMG_ACID, 15,true)
				zmlab2.NetEvent.Create("methylamin_explo", entity:GetPos())
			else
				zmlab2.Damage.Effect(entity, "HelicopterMegaBomb")
				zmlab2.Sound.EmitFromPosition(entity:GetPos(), "machine_explode")
			end
		end

        // Stop moving if you have physics
        if entity.PhysicsDestroy then entity:PhysicsDestroy() end

        // Hide entity
        if entity.SetNoDraw then entity:SetNoDraw(true) end

        // This got taken from a Physcollide function but maybe its needed to prevent a crash
        local deltime = FrameTime() * 2
        if not game.SinglePlayer() then deltime = FrameTime() * 6 end
        SafeRemoveEntityDelayed(entity, deltime)
    end
end

function zmlab2.Damage.InflictBurn(entity, dmg)
	local d = DamageInfo()
	d:SetDamage(dmg)
	d:SetAttacker(entity)
	d:SetDamageType(DMG_BURN)
	zmlab2.Damage.Inflict(entity, d)
end

function zmlab2.Damage.Repair(entity)
	entity:SetHealth(entity:GetMaxHealth())
	zmlab2.Sound.EmitFromEntity("zapp", entity)
	local effectdata = EffectData()
	effectdata:SetOrigin(entity:LocalToWorld(vector_origin))
	effectdata:SetMagnitude(2)
	effectdata:SetScale(1)
	effectdata:SetRadius(3)
	util.Effect("cball_bounce", effectdata)
	entity:SetColor(Color(255, 255, 255, 255))
end

// Causes damage to any player in distance
function zmlab2.Damage.Explosion(attacker, pos, radius, dmg_type, dmg_amount,player_only)
	for k, v in pairs(ents.FindInSphere(pos, radius)) do
		if IsValid(v) then
			if player_only and v:IsPlayer() == false then continue end
			local d = DamageInfo()
			d:SetDamage(dmg_amount)
			d:SetAttacker(attacker)
			d:SetDamageType(dmg_type)
			v:TakeDamageInfo(d)
		end
	end
end
