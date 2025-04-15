if not CLIENT then return end

local Created = false

zmlab2 = zmlab2 or {}
zmlab2.f = zmlab2.f or {}

local function zmlab2_OptionPanel(name,desc, CPanel, cmds)
	local panel = vgui.Create("DPanel")
	panel:Dock(FILL)
	panel.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zmlab2.colors["grey01"])
		zmlab2.util.DrawOutlinedBox( 0, 0, w, h, 4, zmlab2.colors["black02"])
	end
	panel:DockPadding(10,10,10,10)

	local title = vgui.Create("DLabel", panel)
	title:Dock(TOP)
	title:SetText(name)
	title:SetFont(zmlab2.GetFont("zmlab2_vgui_font03"))
	title:DockPadding(5,5,5,5)
	title:SetTextColor(zmlab2.colors["blue02"])

	if desc then
		local desc_pnl = vgui.Create("DLabel", panel)
		desc_pnl:Dock(TOP)
		desc_pnl:SetText(desc)
		//desc_pnl:SetContentAlignment(4)
		desc_pnl:SetFont(zmlab2.GetFont("zmlab2_vgui_font06"))
		desc_pnl:DockPadding(5,2,5,2)
		desc_pnl:SetTextColor(color_white)
		//desc_pnl:SetWrap(true)
		desc_pnl:SetContentAlignment(4)
		desc_pnl:SizeToContentsY( 5 )
	end

	for k, v in ipairs(cmds) do
		if v.class == "DNumSlider" then

			local item = vgui.Create("DNumSlider", panel)
			item:Dock(TOP)
			item:DockPadding(5,5,5,5)
			item:DockMargin(5,5,5,5)

			item:SetText(v.name)
			item:SetMin(v.min)
			item:SetMax(v.max)

			item:SetDecimals(v.decimal)
			item:SetDefaultValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(),v.decimal),v.min,v.max))
			item:ResetToDefaultValue()
			item:SetConVar( v.cmd )
			item.OnValueChanged = function(self, val)

				if Created then
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end
		elseif v.class == "DCheckBoxLabel" then

			local item = vgui.Create("DCheckBoxLabel", panel)
			item:Dock(TOP)
			item:DockPadding(5,5,5,5)
			item:DockMargin(5,5,5,5)
			item:SetText( v.name )
			item:SetConVar( v.cmd )
			item.OnChange = function(self, val)
				if Created then
					if val then
						RunConsoleCommand(v.cmd, "1")
					else
						RunConsoleCommand(v.cmd, "0")
					end
				end
			end

			// 949137607
			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(GetConVar(v.cmd):GetInt())
				end
			end)
		elseif v.class == "DButton" then
			local item = vgui.Create("DButton", panel)
			item:Dock(TOP)
			item:DockMargin(0,10,0,0)
			item:SetText( v.name )
			item:SetFont(zmlab2.GetFont("zmlab2_vgui_font02"))
			item:SetTextColor(color_white)
			item.Paint = function(s, w, h)
				draw.RoundedBox(4, 0, 0, w, h, zmlab2.colors["blue02"])
				if s.Hovered then
					draw.RoundedBox(4, 0, 0, w, h, zmlab2.colors["white03"])
				end
			end
			item.DoClick = function()

				if zmlab2.Player.IsAdmin(LocalPlayer()) == false then return end

				LocalPlayer():EmitSound("zmlab2_ui_click")

				if v.notify then

					notification.AddLegacy(  v.notify, NOTIFY_GENERIC, 2 )
				end
				LocalPlayer():ConCommand( v.cmd )
			end
		elseif v.class == "DColorMixer" then

			local main = vgui.Create("DPanel", panel)
			main:SetSize(200 * zmlab2.wM, 300 * zmlab2.hM)
			main:Dock(TOP)
			main:DockPadding(5, 5, 5, 5)
			main:DockMargin(5, 5, 5, 5)
			main.Paint = function(s, w, h)
				draw.RoundedBox(4, 0, 0, w, 5 * zmlab2.hM, zmlab2.colors["black02"])

				draw.RoundedBox(4, 0, h - 5 * zmlab2.hM, w, 5 * zmlab2.hM, zmlab2.colors["black02"])
			end

			local a_title = vgui.Create("DLabel", main)
			a_title:Dock(TOP)
			a_title:SetFont(zmlab2.GetFont("zmlab2_vgui_font02"))
			a_title:SetText(v.name)
			a_title:SetTextColor(color_white)
			a_title:SetContentAlignment(4)
			a_title:SizeToContentsY( 10 )

			local Mixer = vgui.Create("DColorMixer", main)
			Mixer:SetSize(200 * zmlab2.wM, 200 * zmlab2.hM)
			Mixer:Dock(FILL)
			Mixer:DockMargin(0, 5, 0, 5)
			Mixer:SetPalette(false)
			Mixer:SetAlphaBar(true)
			Mixer:SetWangs(true)

			if v.cmd[1] then Mixer:SetConVarR(v.cmd[1]) end
			if v.cmd[2] then Mixer:SetConVarG(v.cmd[2]) end
			if v.cmd[3] then Mixer:SetConVarB(v.cmd[3]) end
			if v.cmd[4] then Mixer:SetConVarA(v.cmd[4]) end

			main:InvalidateParent(true)
			main:SizeToChildren(false,true)
		end

		if v.desc then
			local desc_pnl = vgui.Create("DLabel", panel)
			desc_pnl:Dock(TOP)
			desc_pnl:DockMargin(5,5,5,5)
			desc_pnl:SetFont(zmlab2.GetFont("zmlab2_vgui_font02"))
			desc_pnl:SetText(v.desc)
			desc_pnl:SetTextColor(color_white)
			desc_pnl:SetContentAlignment(4)
			desc_pnl:SizeToContentsY( 30 )
		end
	end


	panel:InvalidateLayout(true)
	panel:SizeToChildren(true, true)

	CPanel:AddPanel(panel)
end

local function Methlab2_settings(CPanel)
	CPanel:AddControl("Header", {
		Text = "Client Settings",
	})

	zmlab2_OptionPanel("VFX","",CPanel,{
		[1] = {name = "Dynamiclight",class = "DCheckBoxLabel", cmd = "zmlab2_cl_vfx_dynamiclight"},
		[2] = {name = "Effects",class = "DCheckBoxLabel", cmd = "zmlab2_cl_particleeffects"},
	})

	/*
	zmlab2_OptionPanel("SFX",CPanel,{
		[1] = {name = "Effects Volume",class = "DNumSlider", cmd = "zmlab2_cl_sfx_volume",min = 0,max = 1,decimal = 2},
	})
	*/
end

local function Methlab2_admin_settings(CPanel)

	CPanel:AddControl("Header", {
		Text = "Admin Commands",
	})

	zmlab2_OptionPanel("Meth Buyer","This includes the Meth Buyer NPC and the\nDropOff Points.",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zmlab2_sellsetup_save"},
		[2] = {name = "Delete",class = "DButton", cmd = "zmlab2_sellsetup_remove"},
	})

	zmlab2_OptionPanel("Public Setup","If the config is setup correctly such that owner\nchecks are disabled then you can build a\nwhole methlab as a public utility.",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zmlab2_publicsetup_save"},
		[2] = {name = "Delete",class = "DButton", cmd = "zmlab2_publicsetup_remove"},
	})

	zmlab2_OptionPanel("Commands","Some usefull debug commands.",CPanel,{
		[1] = {name = "Spawn Methbag",class = "DButton", cmd = "zmlab2_debug_Meth_Test"},
		[2] = {name = "Spawn Methcrate",class = "DButton", cmd = "zmlab2_debug_Crate_Test"},
	})
end

hook.Add("AddToolMenuCategories", "zmlab2_CreateCategories", function()
	spawnmenu.AddToolCategory("Options", "zmlab2_options", "Methlab 2")
end)

hook.Add("PopulateToolMenu", "zmlab2_PopulateMenus", function()
	spawnmenu.AddToolMenuOption("Options", "zmlab2_options", "zmlab2_Settings", "Client Settings", "", "", Methlab2_settings)
	spawnmenu.AddToolMenuOption("Options", "zmlab2_options", "zmlab2_Admin_Settings", "Admin Settings", "", "", Methlab2_admin_settings)

	timer.Simple(0.2, function()
		Created = true
	end)
end)
