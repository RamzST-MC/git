AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = true
	SWEP.PrintName = "Ковбойка"
	SWEP.CSMuzzleFlashes = true

	SWEP.AimPos = Vector(-4.691, -3.958, 0.66)
	SWEP.AimAng = Vector(0, -0.216, 0)

	SWEP.SprintPos = Vector(1.185, -15.796, -14.254)
	SWEP.SprintAng = Vector(64.567, 0, 0)

	SWEP.ZoomAmount = 5
	SWEP.ViewModelMovementScale = 0.85
	SWEP.Shell = "smallshell"

	SWEP.IconLetter = "f"
	killicon.AddFont("swb_357", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))

	SWEP.MuzzleEffect = "swb_pistol_large"
	SWEP.MuzzlePosMod = {x = 6.5, y =	30, z = -2}
	--SWEP.PosBasedMuz = true
end

SWEP.SpeedDec = 12
SWEP.BulletDiameter = 9.1
SWEP.CaseLength = 33

SWEP.PlayBackRate = 2
SWEP.PlayBackRateSV = 2

SWEP.Kind = WEAPON_PISTOL
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "Pistol"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"double"}
SWEP.Base = "swb_base"
SWEP.Category = "Донатные пухи"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 75
SWEP.ViewModelFlip	= false
SWEP.ViewModel = Model("models/weapons/c_357.mdl")
SWEP.WorldModel = Model("models/weapons/w_357.mdl")

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize			= 10000		-- Size of a clip
SWEP.Primary.DefaultClip		= 450000		-- Bullets you start with
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"

SWEP.FireDelay = 0.20
SWEP.FireSound = Sound("vo/Citadel/br_youfool.wav")
SWEP.Recoil = 0
SWEP.Chamberable = false

SWEP.HipSpread = 0

SWEP.AimSpread = 0

SWEP.VelocitySensitivity = 1.85

SWEP.MaxSpreadInc = 0

SWEP.SpreadPerShot = 0

SWEP.SpreadCooldown = 0
SWEP.Shots = 1
SWEP.Damage = 1337
SWEP.DeployTime = 1