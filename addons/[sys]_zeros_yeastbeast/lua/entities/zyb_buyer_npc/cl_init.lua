-- leak by lordee
include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 500) then
		self:DrawInfo()
	end
end

function ENT:DrawInfo()
	local Pos = self:GetPos() + self:GetUp() * 80
	Pos = Pos + self:GetUp() * math.abs(math.sin(CurTime()) * 1)
	local Ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
	cam.Start3D2D(Pos, Ang, 0.1)
		draw.RoundedBox(25, -200, 25, 400, 50, zyb.default_colors["black01"])

		draw.SimpleTextOutlined(self:GetPrice() .. zyb.config.Currency .. " / " .. zyb.language.NPC["Jar"], "zyb_npc_font02", 0, 53, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, zyb.default_colors["black02"])

		draw.SimpleTextOutlined(zyb.language.NPC["MoonshineBuyer"], "zyb_npc_font01", 0, 0, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, zyb.default_colors["black02"])
	cam.End3D2D()
end
-- leak by lordee