zmlab2 = zmlab2 or {}
zmlab2.f = zmlab2.f or {}

function zmlab2.Debug(mgs)
	if zmlab2.config.Debug then
		if istable(mgs) then
			print("[    DEBUG    ] Table Start >")
			PrintTable(mgs)
			print("[    DEBUG    ] Table End <")
		else
			print("[    DEBUG    ] " .. mgs)
		end
	end
end

function zmlab2.Debug_Net(NetworkString,Len)
	zmlab2.Debug("[" .. NetworkString .. "][" .. (Len / 8) .. " Bytes]")
end
