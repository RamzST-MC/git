-- ItsNoctarius

VPNShield = VPNShield or {}
VPNShield.Config = VPNShield.Config or {}

local C = VPNShield.Config

C.KickInstantly = true
C.AllowedWarnings = 2
C.PersistenceFile = "vpn_shield/violations.json"
C.WarningDisplayTime = 10

-- LOL

C.Notify = {
	Enabled = true,
	Width = 460,
	Height = 74,
	BottomMargin = 52,
	Gap = 10,
	LifeTime = 9.5
}

C.Messages = {
	TitleWarning = "VPN/Proxy warning",
	TitleBlocked = "VPN/Proxy blocked",
	WarningTemplate = "Detected VPN/Proxy. Warning %d/%d. Next detections will block access.",
	BlockedText = "VPN/Proxy detected. Access denied.",
	KickTemplate = "VPN/Proxy blocked: %s"
}
