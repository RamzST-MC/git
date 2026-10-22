-- leak by lordee-- leak by lordee
include("shared.lua")


function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:OnRemove()
	self:StopParticlesNamed("yb_sugar")
end
-- leak by lordee