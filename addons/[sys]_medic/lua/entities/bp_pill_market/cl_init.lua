include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetRagdollBones( b )
	self.m_bRagdollSetup = b
end

local mat = Material("divergent/entities/gulag.png")

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) < 600 then
		cam.Start3D2D(self:LocalToWorld(Vector(0, 0, 73)), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.03)
			draw.SimpleTextOutlined("Продажа таблеток", '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)

			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(-64, -230, 128, 128)
		cam.End3D2D()
	end
end