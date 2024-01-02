zmlab2 = zmlab2 or {}
zmlab2.Animation = zmlab2.Animation or {}

function zmlab2.Animation.Play(ent,anim, speed)
	if not IsValid(ent) then return end
	local sequence = ent:LookupSequence(anim)
	ent:SetCycle(0)
	ent:ResetSequence(sequence)
	ent:SetPlaybackRate(speed)
	ent:SetCycle(0)
end

function zmlab2.Animation.PlayTransition(ent,anim01, speed01,anim02,speed02)

	zmlab2.Animation.Play(ent,anim01, speed01)

	local time = ent:SequenceDuration()
	local timerid =  "zmlab2_anim_transition_" .. ent:EntIndex()
	zmlab2.Timer.Remove(timerid)

	zmlab2.Timer.Create(timerid, time, 1, function()
		zmlab2.Timer.Remove(timerid)
		zmlab2.Animation.Play(ent, anim02, speed02)
	end)
end
