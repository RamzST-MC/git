-- leak by lordee
include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:OnRemove()
	self:StopSound("zyb_fill_liquid")
	self:StopParticlesNamed("yb_water")
end

function ENT:Think()

	zyb.f.LoopedSound(self, "zyb_fill_liquid", self:GetFilling())

	self:SetNextClientThink(CurTime())
	return true
end
-- leak by lordee