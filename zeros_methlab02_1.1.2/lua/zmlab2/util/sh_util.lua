zmlab2 = zmlab2 or {}
zmlab2.util = zmlab2.util or {}



////////////////////////////////////////////
//////////////// DEFAULT ///////////////////
////////////////////////////////////////////
function zmlab2.Print(msg)
	print("[Zero´s Methlab 2] " .. msg)
end

if SERVER then

	// Basic notify function
	function zmlab2.Notify(ply, msg, ntfType)
		if not IsValid(ply) then return end

		if DarkRP and DarkRP.notify then
			DarkRP.notify(ply, ntfType, 8, msg)
		else
			ply:ChatPrint(msg)
		end
	end
else
	function zmlab2.util.LoopedSound(ent, soundfile, shouldplay)
		if shouldplay and zmlab2.util.InDistance(LocalPlayer():GetPos(), ent:GetPos(), 500) then
			if ent.Sounds == nil then
				ent.Sounds = {}
			end

			if ent.Sounds[soundfile] == nil then
				ent.Sounds[soundfile] = CreateSound(ent, soundfile)
			end

			if ent.Sounds[soundfile]:IsPlaying() == false then
				ent.Sounds[soundfile]:Play()
				ent.Sounds[soundfile]:ChangeVolume(zmlab2.Convar.Get("zmlab2_cl_sfx_volume"), 0)
				ent.LastVolume = zmlab2.Convar.Get("zmlab2_cl_sfx_volume")
			else
				if ent.LastVolume ~= zmlab2.Convar.Get("zmlab2_cl_sfx_volume") then
					ent.LastVolume = zmlab2.Convar.Get("zmlab2_cl_sfx_volume")
					ent.Sounds[soundfile]:ChangeVolume(ent.LastVolume, 0)
				end
			end
		else
			if ent.Sounds == nil then
				ent.Sounds = {}
			end

			if ent.Sounds[soundfile] ~= nil and ent.Sounds[soundfile]:IsPlaying() == true then
				ent.Sounds[soundfile]:ChangeVolume(0, 0)
				ent.Sounds[soundfile]:Stop()
				ent.Sounds[soundfile] = nil
			end
		end
	end

	function zmlab2.util.GetTextSize(txt,font)
		surface.SetFont(font)
		return surface.GetTextSize(txt)
	end

	function zmlab2.util.DrawOutlinedBox(x, y, w, h, thickness, clr)
		surface.SetDrawColor(clr)

		for i = 0, thickness - 1 do
			surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
		end
	end

	function zmlab2.util.DrawBlur(p, a, d)
		local x, y = p:LocalToScreen(0, 0)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(zmlab2.materials["blur"])

		for i = 1, d do
			zmlab2.materials["blur"]:SetFloat("$blur", (i / d) * a)
			zmlab2.materials["blur"]:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end
	end

	function zmlab2.util.ColorToVector(col)
		return Vector((1 / 255) * col.r, (1 / 255) * col.g, (1 / 255) * col.b)
	end

	function zmlab2.util.ScreenPointToRay(ViewPos,filter,mask)
		local x, y = input.GetCursorPos()
		local dir = gui.ScreenToVector( x,y )

		// Trace for valid Spawn Pos
		local c_trace = zmlab2.util.TraceLine({
			start = ViewPos,
			endpos = ViewPos + dir:Angle():Forward() * 10000,
			filter = filter,
			mask = mask,
		}, "ScreenPointToRay")
		return c_trace
	end

	function zmlab2.util.DrawCircle( x, y, radius, seg )
		local cir = {}

		table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		end

		local a = math.rad( 0 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

		surface.DrawPoly( cir )
	end
end

function zmlab2.util.FormatDate(date)
	local chars = string.Split( date, "/" )
	local CleanDate = chars[3] .. "/" .. chars[2] .. "/" .. chars[1] .. " - " .. chars[4]

	return CleanDate
end

function zmlab2.util.GetDate()
	return os.time()
end

function zmlab2.util.GenerateUniqueID(template)
    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)

        return tostring(string.format("%x", v))
    end)
end

function zmlab2.util.UnitToMeter(unit)
	return math.Round(unit * 0.01953125) .. "m"
end

// Takes in a savefile name and makes it clean and nice
function zmlab2.util.FormatSavefile(id)
	// Make it lower case
	id = string.lower(id)

	// Lets removed any problematic symbols
	local pattern = '[\\/:%*%?"<>!|]' // a set of all restricted characters
	id = string.gsub(id,pattern,"",99)

	// Replace empty space with underline
	id = string.Replace(id," ","_")

	return id
end

function zmlab2.util.FormatTime(time)
	local divid = time / 60
	local minutes = math.floor(time / 60)
	local seconds = math.Round(60 * (divid - minutes))

	local lang_m = zmlab2.language["Minutes"]
	local lang_s = zmlab2.language["Seconds"]

	//string.FormattedTime( 90, "%02i:%02i:%02i" )

	if seconds > 0 and minutes > 0 then
		return minutes .. " " .. lang_m .. " | " .. seconds .. " " .. lang_s
	elseif seconds <= 0 and minutes > 0 then
		return minutes .. " " .. lang_m
	elseif seconds >= 0 and minutes <= 0 then
		return seconds .. " " .. lang_s
	end
end

function zmlab2.util.LerpColor(t, c1, c2)
	local c3 = Color(0, 0, 0)
	c3.r = Lerp(t, c1.r, c2.r)
	c3.g = Lerp(t, c1.g, c2.g)
	c3.b = Lerp(t, c1.b, c2.b)
	c3.a = Lerp(t, c1.a, c2.a)

	return c3
end

// Checks if the distance between pos01 and pos02 is smaller then dist
function zmlab2.util.InDistance(pos01, pos02, dist)
	return  pos01:DistToSqr(pos02) < (dist * dist)
end

//Used to fix the Duplication Glitch
function zmlab2.util.CollisionCooldown(ent)
	if ent.zmlab2_CollisionCooldown == nil then
		ent.zmlab2_CollisionCooldown = CurTime() + 0.1

		return false
	else
		if CurTime() < ent.zmlab2_CollisionCooldown then
			return true
		else
			ent.zmlab2_CollisionCooldown = CurTime() + 0.1

			return false
		end
	end
end

function zmlab2.util.SnapValue(snapval,val)
	val = val / snapval
	val = math.Round(val)
	val = val * snapval
	return val
end

// Tells us if the functions is valid
function zmlab2.util.FunctionValidater(func)
	if (type(func) == "function") then return true end
	// 949137607
	return false
end

// Creates a new randomized table from the input table
function zmlab2.util.table_randomize( t )
	local out = { }

	while #t > 0 do
		table.insert( out, table.remove( t, math.random( #t ) ) )
	end

	return out
end

function zmlab2.util.RankTblToString(tbl)
	local str = ""

	for k, v in pairs(tbl) do
		str = str .. k .. ", "
	end

	return str
end

// Performs a TraceLine
function zmlab2.util.TraceLine(tracedata,identifier)
	return util.TraceLine(tracedata)
end

// Calculates how much of the AddAmount will remain and how much can be added
function zmlab2.util.GetRemain(HaveAmount, CapAmount, AddAmount)
	local diff = CapAmount - HaveAmount
	local add = math.Clamp(AddAmount, 0, diff)
	local remain = AddAmount - add
	return remain, add
end

// Thank you Stromic for that function :)
function zmlab2.util.sortAlphabeticallyByKeyValues(tbl, ascending)
	local normaltable = {}
	local cleantable = {}

	for k, v in pairs(tbl) do
		table.insert(normaltable, k)
	end

	if ascending then
		table.sort(normaltable, function(a, b)
			a, b = differenciate(a, b)

			return a < b
		end)
	else
		table.sort(normaltable, function(a, b)
			a, b = differenciate(a, b)

			return a > b
		end)
	end

	for k, v in pairs(normaltable) do
		cleantable[v] = k
	end

	return cleantable
end
////////////////////////////////////////////
////////////////////////////////////////////
