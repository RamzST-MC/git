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
	zgo2.Joint.Initialize(self)
end

function SWEP:Holster(swep)
	return zgo2.Joint.Holster(self)
end

function SWEP:Deploy()
	return zgo2.Joint.Deploy(self)
end

function SWEP:PrimaryAttack()
	zgo2.Joint.PrimaryAttack(self)
end

function SWEP:Think()
	zgo2.Joint.Think(self)
end

function SWEP:SecondaryAttack()
	zgo2.Joint.SecondaryAttack(self)
end

function SWEP:Reload()
	zgo2.Joint.Reload(self)
end

function SWEP:ShouldDropOnDie()
	return false
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher