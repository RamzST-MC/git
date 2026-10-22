--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
include("shared.lua")

function ENT:Initialize()
    zgo2.Pot.Initialize(self)
end

function ENT:Draw()
	zgo2.Pot.OnDraw(self)
end

function ENT:Think()
    zgo2.Pot.Think(self)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher