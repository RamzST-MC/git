-- leak by lordee
if not CLIENT then return end


zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Player_Initialize()
	zyb.f.Debug("zyb.f.Player_Initialize")

	net.Start("zyb_Player_Initialize")
	net.SendToServer()
end

// Sends a net msg to the server that the player has fully initialized and removes itself
hook.Add("HUDPaint", "zyb_PlayerInit_HUDPaint", function()
	zyb.f.Debug("zyb_PlayerInit_HUDPaint")

	zyb.f.Player_Initialize()

	hook.Remove("HUDPaint", "zyb_PlayerInit_HUDPaint")
end)
-- leak by lordee