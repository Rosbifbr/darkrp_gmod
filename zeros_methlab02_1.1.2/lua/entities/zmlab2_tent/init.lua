AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 25
	local ent = ents.Create(self.ClassName)
	if not IsValid(ent) then return end
	ent:SetPos(SpawnPos)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(),180)
	ent:SetAngles(angle)
	ent:Spawn()
	ent:Activate()
	zmlab2.Player.SetOwner(ent, ply)
	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	zmlab2.Tent.Initialize(self)
end

function ENT:AcceptInput(inputName, activator, caller, data)
	if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
		zmlab2.Tent.OnUse(self, activator)
	end
end

function ENT:OnRemove()
	zmlab2.Tent.OnRemove(self)
end
