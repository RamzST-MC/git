--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
include("shared.lua")
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

function SWEP:Initialize()
	zgo2.Joint.Initialize(self)
end

function SWEP:DrawHUD()
	zgo2.Joint.DrawHUD(self)
end

function SWEP:Think()
	zgo2.Joint.Think(self)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:Holster()
	zgo2.Joint.Holster(self)
end

function SWEP:OnRemove()
	zgo2.Joint.OnRemove(self)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher