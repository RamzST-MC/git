--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
include("shared.lua")

function ENT:Initialize()
	zgo2.DoobyTable.Initialize(self)
end

function ENT:Draw()
	zgo2.DoobyTable.Draw(self)
end

function ENT:Think()
	zgo2.DoobyTable.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher