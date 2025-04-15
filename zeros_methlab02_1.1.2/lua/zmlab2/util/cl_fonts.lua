if SERVER then return end

zmlab2 = zmlab2 or {}
zmlab2.LoadedFonts = {}
zmlab2.FontData = {}

function zmlab2.GetFont(id)
	if zmlab2.LoadedFonts[id] then
		// Font already exists
		return id
	else

		// Create Font
		surface.CreateFont(id, zmlab2.FontData[id])
		zmlab2.LoadedFonts[id] = true

		zmlab2.Print("Font " .. id .. " cached!")
		return id
	end
end

////////////////////////////////////////////
///////////////// DEFAULT //////////////////
////////////////////////////////////////////
zmlab2.FontData["zmlab2_font00"] = {
	font = "Nexa Bold",
	extended = true,
	size = 20,
	weight = 100,
	antialias = true
}

zmlab2.FontData["zmlab2_font01"] = {
	font = "Nexa Bold",
	extended = true,
	size = 20,
	weight = 1,
	antialias = true
}

zmlab2.FontData["zmlab2_font02"] = {
	font = "Nexa Bold",
	extended = true,
	size = 50,
	weight = 1,
	antialias = true
}

zmlab2.FontData["zmlab2_font03"] = {
	font = "Nexa Bold",
	extended = true,
	size = 80,
	weight = 1,
	antialias = true
}

zmlab2.FontData["zmlab2_font04"] = {
	font = "Nexa Bold",
	extended = true,
	size = 40,
	weight = 1,
	antialias = true
}


zmlab2.FontData["zmlab2_font05"] = {
	font = "Nexa Bold",
	extended = true,
	size = 30,
	weight = 1,
	antialias = true
}


////////////////////////////////////////////
///////////////// VGUI /////////////////////
////////////////////////////////////////////
zmlab2.FontData["zmlab2_vgui_font00"] = {
	font = "Nexa Bold",
	extended = true,
	size = ScreenScale(25),
	weight = ScreenScale(100),
	antialias = true
}

zmlab2.FontData["zmlab2_vgui_font01"] = {
	font = "Nexa Bold",
	extended = true,
	size = ScreenScale(15),
	weight = ScreenScale(100),
	antialias = true
}

zmlab2.FontData["zmlab2_vgui_font02"] = {
	font = "Nexa Bold",
	extended = true,
	size = ScreenScale(5.9),
	weight = ScreenScale(100),
	antialias = true
}

zmlab2.FontData["zmlab2_vgui_font03"] = {
	font = "Nexa Bold",
	extended = true,
	size = ScreenScale(10),
	weight = ScreenScale(100),
	antialias = true
}

zmlab2.FontData["zmlab2_vgui_font05"] = {
	font = "Nexa Bold",
	extended = true,
	size = ScreenScale(4.6),
	weight = ScreenScale(100),
	antialias = true
}

zmlab2.FontData["zmlab2_vgui_font06"] = {
	font = "Nexa Light",
	extended = true,
	size = ScreenScale(6),
	weight = ScreenScale(100),
	antialias = true
}
