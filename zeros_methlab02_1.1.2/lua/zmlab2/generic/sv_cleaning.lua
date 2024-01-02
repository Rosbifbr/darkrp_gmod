if not SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.Cleaning = zmlab2.Cleaning or {}

function zmlab2.Cleaning.Setup(ent)
	ent.Cleaning_Goal = math.random(3,10)
end

function zmlab2.Cleaning.Inflict(ent,ply,OnFinished)

	if ent.Cleaning_Goal == nil then zmlab2.Cleaning.Setup(ent) end
	ent.Cleaning_Goal = math.Clamp(ent.Cleaning_Goal - 1,0,10)

	if ent.Cleaning_Goal <= 0 then
		ent.Cleaning_Goal = nil
		ent:RemoveAllDecals()
		pcall(OnFinished)
	end

	local tr = ply:GetEyeTrace()
	if tr and tr.Hit and tr.HitPos then
		zmlab2.NetEvent.Create("clean", tr.HitPos)
	end
end
