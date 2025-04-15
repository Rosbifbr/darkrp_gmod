AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	local ent = ents.Create(self.ClassName)
	if not IsValid(ent) then return end
	ent:SetPos(tr.HitPos + tr.HitNormal * 1)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 180)
	ent:SetAngles(angle)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	zmlab2.NPC.Initialize(self)
end

function ENT:AcceptInput(inputName, activator, caller, data)
	if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
		zmlab2.NPC.OnUse(self, activator)
	end
end

function ENT:OnTakeDamage(dmg)
	return 0
end
