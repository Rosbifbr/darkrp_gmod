zmlab2 = zmlab2 or {}
zmlab2.Hook = zmlab2.Hook or {}

////////////////////////////////////////////
///////////////// Hooks ////////////////////
////////////////////////////////////////////
zmlab2.Hook.List = zmlab2.Hook.List or {}

function zmlab2.Hook.PrintAll()
	PrintTable(zmlab2.Hook.List)
end

function zmlab2.Hook.GetUniqueIdentifier(eventName, identifier)
	local _identifier = "a.zmlab2." .. eventName .. "." .. identifier
	if SERVER then
		_identifier = _identifier .. ".sv"
	else
		_identifier = _identifier .. ".cl"
	end
	return _identifier
end

function zmlab2.Hook.Exist(eventName, identifier)
	local reg_hooks = hook.GetTable()
	local _identifier = zmlab2.Hook.GetUniqueIdentifier(eventName, identifier)
	local exists = false
	if reg_hooks[eventName] and reg_hooks[eventName][_identifier] then
		exists = true
	end
	//print(eventName.." "..identifier.. "Exists: "..tostring(exists))
	return exists
end

function zmlab2.Hook.Add(eventName, identifier, func)
	//if zmlab2.Hook.Exist(eventName, identifier) then return end
	// Lets make sure we remove the hook if its allready exist
	zmlab2.Hook.Remove(eventName, identifier)
	//print("Hook.Add: [" .. eventName .. "] (" .. identifier .. ")")
	local _identifier = zmlab2.Hook.GetUniqueIdentifier(eventName, identifier)


	if zmlab2.util.FunctionValidater(func) then

		hook.Add(eventName, _identifier, func)

		if zmlab2.Hook.List[eventName] == nil then
			zmlab2.Hook.List[eventName] = {}
		end

		table.insert(zmlab2.Hook.List[eventName], identifier)
	end
end

function zmlab2.Hook.Remove(eventName, identifier)
	//print("Hook.Remove: [" .. eventName .. "] (" .. identifier .. ")")
	local _identifier = zmlab2.Hook.GetUniqueIdentifier(eventName, identifier)

	hook.Remove(eventName, _identifier)

	if zmlab2.Hook.List[eventName] then
		table.RemoveByValue(zmlab2.Hook.List[eventName], identifier)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////
