--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
SWEP.Weight = 5

function SWEP:Initialize()
	zgo2.Bong.Initialize(self)
end

function SWEP:Holster(swep)
	return zgo2.Bong.Holster(self)
end

function SWEP:Deploy()
	return zgo2.Bong.Deploy(self)
end

function SWEP:PrimaryAttack()
	zgo2.Bong.PrimaryAttack(self)
end

function SWEP:Think()
	zgo2.Bong.Think(self)
end

function SWEP:SecondaryAttack()
	zgo2.Bong.SecondaryAttack(self)
end

function SWEP:Reload()
	zgo2.Bong.Reload(self)
end

function SWEP:ShouldDropOnDie()
	return false
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher