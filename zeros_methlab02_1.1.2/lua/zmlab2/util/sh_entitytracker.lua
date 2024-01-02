zmlab2 = zmlab2 or {}
zmlab2.EntityTracker = zmlab2.EntityTracker or {}
zmlab2.EntityTracker.List = zmlab2.EntityTracker.List or {}

function zmlab2.EntityTracker.Add(ent)
	table.insert(zmlab2.EntityTracker.List, ent)
end

function zmlab2.EntityTracker.Remove(ent)
	table.RemoveByValue(zmlab2.EntityTracker.List, ent)
end

function zmlab2.EntityTracker.GetList()
	return zmlab2.EntityTracker.List
end
