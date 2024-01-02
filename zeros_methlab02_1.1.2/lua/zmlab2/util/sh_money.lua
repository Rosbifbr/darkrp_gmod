zmlab2 = zmlab2 or {}
zmlab2.Money = zmlab2.Money or {}

if SERVER then
	function zmlab2.Money.Give(ply, money)
		if (DarkRP) then
			ply:addMoney(money)
		elseif (nut) then
			ply:getChar():giveMoney(money)
		elseif (BaseWars) then
			ply:GiveMoney(money)
		end
	end

	function zmlab2.Money.Take(ply, money)
		if (DarkRP) then
			ply:addMoney(-money)
		elseif (nut) then
			ply:getChar():takeMoney(money)
		elseif (BaseWars) then
			ply:GiveMoney(-money)
		end
	end
end

function zmlab2.Money.Has(ply, money)
	if (DarkRP) then
		if ((ply:getDarkRPVar("money") or 0) >= money) then
			return true
		else
			return false
		end
	elseif (nut) then
		if (ply:getChar():hasMoney(money)) then
			return true
		else
			return false
		end
	elseif (BaseWars) then
		if ((ply:GetMoney() or 0) >= money) then
			return true
		else
			return false
		end
	elseif (engine.ActiveGamemode() == "sandbox") then
		return true
	end
end

// Returns the formated money as string
function zmlab2.Money.Format(money)
	if not money then return "0" end
	money = tostring(math.abs(money))
	local sep = ","
	local dp = string.find(money, "%.") or #money + 1

	for i = dp - 4, 1, -3 do
		money = money:sub(1, i) .. sep .. money:sub(i + 1)
	end

	return money
end

function zmlab2.Money.Display(money)
	if not zmlab2.config.CurrencyInvert then
		return zmlab2.config.Currency .. zmlab2.Money.Format(money)
	else
		return zmlab2.Money.Format(money) .. zmlab2.config.Currency
	end
end
