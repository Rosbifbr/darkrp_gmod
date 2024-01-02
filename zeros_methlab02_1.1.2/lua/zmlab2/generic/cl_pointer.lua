if SERVER then return end

zmlab2 = zmlab2 or {}
zmlab2.PointerSystem = zmlab2.PointerSystem or {}

/*

    This system handles the Left / Right Mouse Click logic and displays a 2d colored rope from one Point to another
         Gets used by: Extinguisher(Extinguish Object), PointerSystem(MoveLiquid), Equipment(Build,Move,Remove,Repair)

*/

zmlab2.PointerSystem.Data = {
    // Stores what entity is the liquid comming from
    From = nil,

    // Will Later be filled with the DummyClientModel
    PreviewModel = nil,

    // The position we are currently aiming at
    HitPos = nil,

    // The entity we are currently aiming at
    HitEntity = nil,

    // A valid found target, can be a entity or a position
    Target = nil,

    // Displays on the screen what action is currently active
    ActionName = "Test"
}


local IsLeftClickDown = false
local IsRightClickDown = false

local function ClearDummy()
    if IsValid(zmlab2.PointerSystem.Data.PreviewModel) then
        zmlab2.ClientModel.Remove(zmlab2.PointerSystem.Data.PreviewModel)
        zmlab2.PointerSystem.Data.PreviewModel = nil
    end
end

local function CreateDummy(pos, model)
    ClearDummy()
    local ent = zmlab2.ClientModel.AddProp()
    if not IsValid(ent) then return end
    ent:SetPos(pos)
    ent:SetModel(model)
    ent:SetAngles(angle_zero)
    ent:Spawn()

    ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
    zmlab2.PointerSystem.Data.PreviewModel = ent
end

// Starts the pointer system
function zmlab2.PointerSystem.Start(Machine,OnInit,OnLeftClick,MainLogic,HUDLogic)
    zmlab2.Debug("zmlab2.PointerSystem.Start")

    ClearDummy()

    zmlab2.PointerSystem.Data.From = Machine

    // Can be used to add something on the hud
    zmlab2.PointerSystem.Data.HUDLogic = HUDLogic

    // Can be used to setup some main data like (Default Rope color)
    pcall(OnInit)

    // What should happen when the player left clicks (Confirms a action)
    zmlab2.PointerSystem.Data.OnLeftClick = OnLeftClick

    // This function will later run some core logic of what data should be stored etc
    zmlab2.PointerSystem.Data.MainLogic = MainLogic

    zmlab2.PointerSystem.StartHook()
end

// Stops the pointer system
function zmlab2.PointerSystem.Stop()
    zmlab2.Debug("zmlab2.PointerSystem.Stop")

    ClearDummy()

    zmlab2.PointerSystem.Data = {}

    zmlab2.PointerSystem.FinishHook()
end

function zmlab2.PointerSystem.StartHook()
    zmlab2.Hook.Remove("Think", "PointerSystem")
    zmlab2.Hook.Add("Think", "PointerSystem", function(depth, skybox)
        zmlab2.PointerSystem.MainLogic()
        IsLeftClickDown = input.IsMouseDown(MOUSE_LEFT)
        IsRightClickDown = input.IsMouseDown(MOUSE_RIGHT)
    end)

    zmlab2.Hook.Remove("HUDPaint", "PointerSystem")
    zmlab2.Hook.Add("HUDPaint", "PointerSystem", function()
        zmlab2.PointerSystem.Paint()
    end)

    zmlab2.Hook.Remove("PostDrawTranslucentRenderables", "PointerSystem")
    zmlab2.Hook.Add("PostDrawTranslucentRenderables", "PointerSystem", function(depth, skybox)
        if skybox == false then zmlab2.PointerSystem.PostDrawTranslucentRenderables() end
    end)
end

function zmlab2.PointerSystem.FinishHook()
    zmlab2.Hook.Remove("Think", "PointerSystem")
    zmlab2.Hook.Remove("HUDPaint", "PointerSystem")
    zmlab2.Hook.Remove("PostDrawTranslucentRenderables", "PointerSystem")
end



// Draws the indicator line for the pointer system and also handles the trace for detecting the entity the player is left click on to
local LinePoints = nil
local gravity = Vector(0, 0, -3)
local damping = 0.9
local Length = 10
function zmlab2.PointerSystem.Paint()
    if IsValid(zmlab2.PointerSystem.Data.From) then

        // Render the rope
        if zmlab2.PointerSystem.Data.Pos then
            local r_start = zmlab2.PointerSystem.Data.From:GetPos()

            // Create rope points
            if LinePoints == nil then
                LinePoints = zmlab2.Rope.Setup(Length, r_start)
            end

            // Updates the Rope points to move physicly
            if LinePoints and table.Count(LinePoints) > 0 then
                zmlab2.Rope.Update(LinePoints, r_start, zmlab2.PointerSystem.Data.Pos, Length, gravity, damping)
            end

            // Draw the rope
            zmlab2.Rope.Draw(LinePoints, r_start, zmlab2.PointerSystem.Data.Pos, Length, zmlab2.materials["beam01"], zmlab2.materials["glow01"], zmlab2.PointerSystem.Data.MainColor)
        else
            LinePoints = nil
        end
    else
        LinePoints = nil
    end

    // Draw Action Hud indicator
    draw.SimpleText(zmlab2.PointerSystem.Data.ActionName, zmlab2.GetFont("zmlab2_vgui_font01"), zmlab2.wM *  650, zmlab2.hM * 895, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(zmlab2.materials["icon_mouse_left"])
    surface.DrawTexturedRect(zmlab2.wM * 560, zmlab2.hM * 860,zmlab2.wM * 80, zmlab2.hM * 80)

    draw.SimpleText(zmlab2.language["Cancel"], zmlab2.GetFont("zmlab2_vgui_font01"), zmlab2.wM * 1350, zmlab2.hM * 895, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(zmlab2.materials["icon_mouse_right"])
    surface.DrawTexturedRect(zmlab2.wM * 1360, zmlab2.hM * 860,zmlab2.wM * 80, zmlab2.hM * 80)

    if zmlab2.PointerSystem.Data.HUDLogic then pcall(zmlab2.PointerSystem.Data.HUDLogic) end
end

function zmlab2.PointerSystem.PostDrawTranslucentRenderables()
    // Render Remove Material
    if zmlab2.PointerSystem.Data and IsValid(zmlab2.PointerSystem.Data.PreviewModel) and zmlab2.PointerSystem.Data.PreviewModel:GetNoDraw() == false then
        render.MaterialOverride(zmlab2.materials["highlight"])
        render.SetColorModulation((1 / 255) * zmlab2.PointerSystem.Data.MainColor.r, (1 / 255) * zmlab2.PointerSystem.Data.MainColor.g, (1 / 255) * zmlab2.PointerSystem.Data.MainColor.b)
        zmlab2.PointerSystem.Data.PreviewModel:DrawModel()
        render.MaterialOverride()
        render.SetColorModulation(1, 1, 1)
    end
end


local NextAction = CurTime()
function zmlab2.PointerSystem.Wait()
    NextAction = CurTime() + 0.25
end

local function LeftClick(func)
    if IsLeftClickDown == false and input.IsMouseDown(MOUSE_LEFT) == true then
        IsLeftClickDown = true

        pcall(func)

        zmlab2.PointerSystem.Wait()
    end
end

local function RightClick(func)
    if IsRightClickDown == false and input.IsMouseDown(MOUSE_RIGHT) == true then
        IsRightClickDown = true

        pcall(func)

        zmlab2.PointerSystem.Wait()
    end
end

function zmlab2.PointerSystem.MainLogic()

    // Stop if the player is dead
    if not IsValid(LocalPlayer()) or LocalPlayer():Alive() == false then
        zmlab2.PointerSystem.Stop()
        return
    end

    // Stop if the start entity got invalid
    if not IsValid(zmlab2.PointerSystem.Data.From) then
        zmlab2.PointerSystem.Stop()
        return
    end

    // Execute right click function, is mostlikely just cancel
    RightClick(function()

        zmlab2.PointerSystem.Stop()
        surface.PlaySound("UI/buttonclickrelease.wav")
        return
    end)

    // Trace for data
    local c_trace = zmlab2.util.TraceLine({
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 10000,
        filter = {LocalPlayer(),zmlab2.PointerSystem.Data.Ignore}
    }, "PointerSystemPointer")

    if c_trace.Hit then

        zmlab2.PointerSystem.Data.Pos = c_trace.HitPos
        zmlab2.PointerSystem.Data.HitEntity = c_trace.Entity
        zmlab2.PointerSystem.Data.HitNormal = c_trace.HitNormal

        if c_trace.HitNormal then
            zmlab2.PointerSystem.Data.Ang = c_trace.HitNormal:Angle()
            zmlab2.PointerSystem.Data.Ang:RotateAroundAxis(zmlab2.PointerSystem.Data.Ang:Right(),-90)
        end
    else
        zmlab2.PointerSystem.Data.Pos = nil
        zmlab2.PointerSystem.Data.HitEntity = nil
    end

    // If we have to wait then stop
    if NextAction > CurTime() then return end

    // Create Preview Model if none exist yet
    if not IsValid(zmlab2.PointerSystem.Data.PreviewModel) and zmlab2.PointerSystem.Data.Pos then
        CreateDummy(zmlab2.PointerSystem.Data.Pos, zmlab2.PointerSystem.Data.ModelOverwrite or "models/props_junk/PopCan01a.mdl")
        return
    end

    if zmlab2.PointerSystem.Data.Pos == nil then return end
    if zmlab2.PointerSystem.Data.Ang == nil then return end

    // Runs the main logic of the pointer system
    pcall(zmlab2.PointerSystem.Data.MainLogic)

    // Check if the user left clicked on a machine who wants the liquid
    LeftClick(function()
        pcall(zmlab2.PointerSystem.Data.OnLeftClick)
    end)
end
