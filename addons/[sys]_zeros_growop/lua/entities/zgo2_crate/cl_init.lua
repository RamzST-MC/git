--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	//for k,v in pairs(zgo2.Crate.Spots) do debugoverlay.Sphere(self:LocalToWorld(v),1,0.05,Color( 0, 255, 0 ),true) end
end

function ENT:Initialize()
	zgo2.Crate.Initialize(self)
end

function ENT:OnRemove()
	zgo2.Crate.OnRemove(self)
end

function ENT:Think()
    zgo2.Crate.OnThink(self)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher