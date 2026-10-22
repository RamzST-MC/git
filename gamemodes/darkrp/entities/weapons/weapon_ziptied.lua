AddCSLuaFile()

SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ''

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

function SWEP:Initialize()
	self:SetHoldType('duel')
	self.CreatedTime = CurTime()
	self.LastPerc = 0
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:DrawHUD()
	if self.Owner:GetNetVar('ZiptieCutting') then
		rp.ui.DrawCenteredProgress("Освобождение")
	elseif self.Owner:IsZiptied() then
		rp.ui.DrawCenteredProgress("Связан!")
	end
end
