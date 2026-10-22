--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
include("shared.lua")

function ENT:Initialize()
	zgo2.Watertank.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Watertank.OnDraw(self)
end

function ENT:Think()
	zgo2.Watertank.OnThink(self)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher