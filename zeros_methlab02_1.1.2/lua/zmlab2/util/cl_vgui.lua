if SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.vgui = zmlab2.vgui or {}
zmlab2.vgui.Elements = zmlab2.vgui.Elements or {}

zmlab2.hM = ScrH() / 1080
zmlab2.wM = zmlab2.hM

// Lets update the WindowSize Multiplicator if teh ScreenSize got changed
zmlab2.Hook.Add("OnScreenSizeChanged", "VGUIScaleReset", function(oldWidth, oldHeight)
	zmlab2.hM = ScrH() / 1080
	zmlab2.wM = zmlab2.hM

	zmlab2.Print("ScreenSize changed, Recalculating ScreenSize values.")
end)

// Plays a interface sound
function zmlab2.vgui.PlaySound(sound)
	// If the player is using the BuilderView then lets get the ViewPos of the builder cam
	if zmlab2.FiringSystem and zmlab2.FiringSystem.RenderBuilderView == true then
		EmitSound(Sound(sound), zmlab2_ViewPos, -2, CHAN_AUTO, 1, 128, 0, 100,0)
	else
		surface.PlaySound(sound)
	end
end

// Creates a notify + sound according to what view the player currntly has
function zmlab2.vgui.Notify(msg,msgType)
	local s_sound = nil

	if msgType == NOTIFY_GENERIC then
		s_sound = "common/bugreporter_succeeded.wav"
	elseif msgType == NOTIFY_ERROR then
		s_sound = "common/warning.wav"
	elseif msgType == NOTIFY_HINT then
		s_sound = "buttons/button15.wav"
	end

	zmlab2.vgui.PlaySound(s_sound)

	if msg and string.len(msg) > 0 then
		local dur = 0.2 * string.len(msg)
		notification.AddLegacy(msg, msgType, dur)
	end
end

function zmlab2.vgui.TextButton(_x,_y,_w,_h,parent,data,action,IsLocked)
	/*
		data = {
			Text01 = "Off"
			color
			txt_color
			locked
		}
	*/
	local button_pnl = vgui.Create("DButton", parent)
	button_pnl:SetPos(_x * zmlab2.wM, _y * zmlab2.hM)
	button_pnl:SetSize(_w * zmlab2.wM, _h * zmlab2.hM)
	button_pnl:SetAutoDelete(true)
	button_pnl:SetText("")

	button_pnl.Text01 = data.Text01
	button_pnl.color = data.color
	button_pnl.txt_color = data.txt_color
	button_pnl.locked = false

	button_pnl.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, s.color)

		if s.Text01 then
			draw.SimpleText(s.Text01, zmlab2.GetFont("zmlab2_vgui_font01"), w / 2, h / 2, s.txt_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if s.locked == true then
			draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["black02"])
		else
			local _, varg = xpcall(IsLocked, function() end, nil)
			if varg then
				draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["black02"])
			else
				if s:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["white02"])
				end
			end
		end
	end

	button_pnl.DoClick = function(s)
		if s.locked == true then return end
		local _, varg = xpcall(IsLocked, function() end, nil)
		if varg == true then return end
		zmlab2.vgui.PlaySound("UI/buttonclick.wav")
		pcall(action,button_pnl)
	end
	return button_pnl
end

function zmlab2.vgui.Slider(parent,text,start_val,onChange)

	local p = vgui.Create("DButton", parent)
	p:SetSize(200 * zmlab2.wM,50 * zmlab2.hM )
	p.locked = false
	p.slideValue = start_val
	p:SetAutoDelete(true)
	p:SetText("")
	p.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zmlab2.colors["black02"])

		draw.SimpleText(text, zmlab2.GetFont("zmlab2_vgui_font03"),5 * zmlab2.wM, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		draw.SimpleText(math.Round(s.slideValue * 100), zmlab2.GetFont("zmlab2_vgui_font03"),w - 5 * zmlab2.wM, h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

		local AreaW = w * 0.5
		local AreaX = w * 0.35
		draw.RoundedBox(4, AreaX, h * 0.5, AreaW, 2 * zmlab2.hM, zmlab2.colors["black01"])


		local boxHeight = h * 0.5
		local boxPosX = AreaW * s.slideValue
		draw.RoundedBox(4, (AreaX - (boxHeight / 2)) + boxPosX, boxHeight / 2, boxHeight, boxHeight, zmlab2.colors["grey02"])

		if p.locked == true then
			draw.RoundedBox(4, 0, 0, w, h, zmlab2.colors["black02"])
		end

		if s:IsDown() then
			local x,_ = s:CursorPos()
			local min = AreaX
			local max = min + AreaW

			x = math.Clamp(x, min, max)

			local val = (1 / AreaW) * (x - min)

			s.slideValue = math.Round(val,2)

			if s.slideValue ~= s.LastValue then
				s.LastValue = s.slideValue

				if s.locked == true then return end
				pcall(onChange,s.slideValue)
			end
			// 60 = 0
			// 230 = 1
		end
	end
	return p
end

function zmlab2.vgui.CheckBox(parent,text,state,onclick)

	local p = vgui.Create("DButton", parent)
	p:SetSize(200 * zmlab2.wM,50 * zmlab2.hM )
	p.locked = false
	p.state = state
	p.slideValue = 0
	p:SetAutoDelete(true)
	p:SetText("")
	p.Paint = function(s, w, h)
		//draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["black02"])

		local BoxWidth = w * 0.8
		local BoxHeight = h / 3
		local BoxPosY = BoxHeight * 1.5
		local BoxPosX = w * 0.1

		draw.SimpleText(text, zmlab2.GetFont("zmlab2_vgui_font03"),w / 2, BoxHeight * 0.8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.RoundedBox(4, BoxPosX, BoxPosY, BoxWidth, BoxHeight, zmlab2.colors["black02"])

		if s.state then
			s.slideValue = Lerp(5 * FrameTime(), s.slideValue, 1)
		else
			s.slideValue = Lerp(5 * FrameTime(), s.slideValue, 0)
		end

		local col = zmlab2.util.LerpColor(s.slideValue, zmlab2.colors["grey02"], zmlab2.colors["green03"])
		draw.RoundedBox(4, BoxPosX + (BoxWidth-BoxHeight) * s.slideValue, BoxPosY, BoxHeight, BoxHeight, col)

		if p.locked == true then
			draw.RoundedBox(4, BoxPosX, BoxPosY, BoxWidth, BoxHeight, zmlab2.colors["black02"])
		end
	end
	p.DoClick = function(s)
		if p.locked == true then return end
		zmlab2.vgui.PlaySound("UI/buttonclick.wav")
		s.state = not s.state
		pcall(onclick,s.state)
	end
	return p
end

function zmlab2.vgui.ImageButton(_x,_y,_w,_h,parent,image,OnClick,IsLocked)
	local Button = vgui.Create("DButton", parent)
	Button:SetPos(_x , _y )
	Button:SetSize(_w, _h)
	Button:SetText("")
	Button.IconColor = color_white
	Button.MainColor = zmlab2.colors["blue01"]
	Button.Paint = function(s, w, h)

		//draw.RoundedBox(0, 0, 0, w, h, s.MainColor)

		zmlab2.util.DrawOutlinedBox(0 * zmlab2.wM, 0 * zmlab2.hM, w, h, 2, color_white)

		surface.SetDrawColor(s.IconColor)
		surface.SetMaterial(image)
		surface.DrawTexturedRect(0, 0,w, h)

		local _, varg = xpcall(IsLocked, function() end, nil)
		if varg or s:IsEnabled() == false then
			draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["black02"])
		else
			if s:IsHovered() then
				draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["white02"])
			end
		end
	end
	Button.DoClick = function(s)

		local _, varg = xpcall(IsLocked, function() end, nil)
		if varg == true then return end

		zmlab2.vgui.PlaySound("UI/buttonclick.wav")

		s:SetEnabled(false)

		timer.Simple(0.25, function() if IsValid(s) then s:SetEnabled(true) end end)

		pcall(OnClick,s)
	end
	return Button
end

local tcol = Color(255, 152, 154)
function zmlab2.vgui.TextEntry(parent, emptytext,onchange,hasrefreshbutton,onRefresh)
	local p = vgui.Create("DTextEntry", parent)
	p:SetSize(200 * zmlab2.wM,50 * zmlab2.hM )
	p:SetPaintBackground(false)
	p:SetAutoDelete(true)
	p:SetUpdateOnType(true)
	p.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zmlab2.colors["grey01"])

		if s:GetText() == "" and not s:IsEditing() then
			draw.SimpleText(emptytext, zmlab2.GetFont("zmlab2_vgui_font02"), 5 * zmlab2.wM, h / 2, zmlab2.colors["white03"], 0, 1)
		end

		s:DrawTextEntryText(color_white, tcol, color_white)
	end

	p.OnValueChange = function(s,val)
		pcall(onchange,val)
	end

	function p:PerformLayout(width, height)
	end

	function p:PerformLayout(width, height)
		self:SetFontInternal(zmlab2.GetFont("zmlab2_vgui_font02"))
	end

	if hasrefreshbutton then
		local b = vgui.Create("DButton",p)
		b:SetText("")
		b:SetSize(50 * zmlab2.wM, 50 * zmlab2.hM )
		b.DoClick = function()
			onRefresh(p:GetText())
		end
		b.Paint = function(s, w, h)
			surface.SetDrawColor(zmlab2.colors["textentry"])
			surface.SetMaterial(zmlab2.materials["back"])
			surface.DrawTexturedRect(5 * zmlab2.wM, 5 * zmlab2.hM, 40 * zmlab2.wM, 40 * zmlab2.hM)
		end

		p.b = b

		timer.Simple(0,function()
			if IsValid(b) and IsValid(p) then
				b:SetPos(p:GetWide() - 50 * zmlab2.wM,0 * zmlab2.hM  )
			end
		end)
	end

	return p
end

function zmlab2.vgui.ModelPanel(data)
	local model_pnl = vgui.Create("DModelPanel")
	model_pnl:SetPos(0 * zmlab2.wM, 0 * zmlab2.hM)
	model_pnl:SetSize(50 * zmlab2.wM, 50 * zmlab2.hM)
	model_pnl:SetVisible(false)
	model_pnl:SetAutoDelete(true)
	model_pnl.LayoutEntity = function(self) end

	if data and data.model then

		model_pnl:SetModel(zmlab2.CacheModel(data.model))

		if not IsValid(model_pnl.Entity) then
			model_pnl:SetVisible(true)
			zmlab2.Print("Could not create DModel Panel, Clientmodel Limit reached?")
			return model_pnl
		end

		local min, max = model_pnl.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(min.x) + math.abs(max.x))
		size = math.max(size, math.abs(min.y) + math.abs(max.y))
		size = math.max(size, math.abs(min.z) + math.abs(max.z))


		local rData = data.render

		local FOV = 35
		local x = 0
		local y = 0
		local z = 0
		local ang = Angle(0, 25, 0)
		local pos = vector_origin

		if rData then
			FOV = rData.FOV or 35
			x = rData.X or 0
			y = rData.Y or 0
			z = rData.Z or 0
			ang = rData.Angles or angle_zero
			pos = rData.Pos or vector_origin
		end

		model_pnl:SetFOV(FOV)
		model_pnl:SetCamPos(Vector(size + x, size + 30 + y, size + 5 + z))
		model_pnl:SetLookAt((min + max) * 0.5)

		if ang then
			model_pnl.Entity:SetAngles(ang)
		end

		if pos then
			model_pnl.Entity:SetPos(pos)
		end

		if data.color then
			model_pnl:SetColor(data.color)
		end

		if data.skin then
			model_pnl.Entity:SetSkin(data.skin)
		end

		if data.material then
			model_pnl.Entity:SetMaterial(data.material)
		end

		if data.anim then
			model_pnl:SetAnimated(true)
			model_pnl.Entity:SetSequence(data.anim)
			model_pnl:SetPlaybackRate(data.speed)
			model_pnl:RunAnimation()
		end

		if data.bodygroup then
			for k,v in pairs(data.bodygroup) do
				model_pnl.Entity:SetBodygroup(k,v)
			end
		end

		model_pnl:SetVisible(true)
	end

	return model_pnl
end
