--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SWEP.Weight = 5

function SWEP:PrimaryAttack()
	zgo2.Sniffer.Primary(self:GetOwner())
	self:SetNextPrimaryFire(CurTime() + zgo2.config.Sniffer.interval)
	self:SetNextSecondaryFire(CurTime() + zgo2.config.Sniffer.interval)
end

function SWEP:SecondaryAttack()
	zgo2.Sniffer.Primary(self:GetOwner())
	self:SetNextPrimaryFire(CurTime() + zgo2.config.Sniffer.interval)
	self:SetNextSecondaryFire(CurTime() + zgo2.config.Sniffer.interval)
end

function SWEP:Reload()
end

function SWEP:Deploy()
	self:SetHoldType("normal")
	self:GetOwner():SetAnimation(PLAYER_IDLE)
	return true
end

function SWEP:ShouldDropOnDie()
	return false
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher