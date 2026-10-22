-- leak by lordee
include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	self.IsRunning = false
end

function ENT:Think()
	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		local running = self:GetRunning()

		if self.IsRunning ~= running then
			self.IsRunning = running

			if self.IsRunning then
				zyb.f.PlayClientAnimation(self, "run", 1)
			else
				zyb.f.PlayClientAnimation(self, "idle", 1)
			end
		end
	else
		self.IsRunning = false
	end
	self:SetNextClientThink(CurTime())
	return true
end
-- leak by lordee