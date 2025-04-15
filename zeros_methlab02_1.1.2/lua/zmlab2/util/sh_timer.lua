zmlab2 = zmlab2 or {}
zmlab2.Timer = zmlab2.Timer or {}

////////////////////////////////////////////
///////////////// Timer ////////////////////
////////////////////////////////////////////
zmlab2.Timer.List = zmlab2.Timer.List or {}

function zmlab2.Timer.PrintAll()
	PrintTable(zmlab2.Timer.List)
end

function zmlab2.Timer.Create(timerid,time,rep,func)

	if zmlab2.util.FunctionValidater(func) then
		timer.Create(timerid, time, rep,func)
		table.insert(zmlab2.Timer.List, timerid)
	end
end

function zmlab2.Timer.Remove(timerid)
	if timer.Exists(timerid) then
		timer.Remove(timerid)
		table.RemoveByValue(zmlab2.Timer.List, timerid)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////
