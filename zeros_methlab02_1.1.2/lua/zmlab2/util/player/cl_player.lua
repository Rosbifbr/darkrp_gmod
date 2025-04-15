if SERVER then return end
// Sends a net msg to the server that the player has fully initialized and removes itself
zmlab2.Hook.Add("HUDPaint", "PlayerInit", function()
	net.Start("zmlab2_Player_Initialize")
	net.SendToServer()

	zmlab2.Hook.Remove("HUDPaint", "PlayerInit")

	LocalPlayer().zmlab2_HasInitialized = true
end)
