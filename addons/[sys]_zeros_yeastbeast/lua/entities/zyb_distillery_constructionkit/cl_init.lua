-- leak by lordee
include("shared.lua")

function ENT:Initialize()

end

function ENT:Draw()
	self:DrawModel()

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:DrawInfo()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetRight(),180)
	ang:RotateAroundAxis(self:GetForward(),90)

	cam.Start3D2D(self:LocalToWorld(Vector(0, 18, 34)), ang, 0.05)

		-- Title
		draw.RoundedBox(25, -500, 0, 1000, 90, zyb.default_colors["black01"])
		draw.SimpleText(self.PrintName, "zyb_barrel_font01", 0, 10, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	cam.End3D2D()
end
-- leak by lordee