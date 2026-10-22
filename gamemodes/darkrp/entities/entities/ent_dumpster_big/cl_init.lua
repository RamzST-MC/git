dash.IncludeSH'shared.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local mat = Material 'divergent/entities/dumpster.png'

function ENT:Initialize()
	self.NextUse = 0
end

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	pos.z = pos.z + 35
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), (ang - LocalPlayer():EyeAngles()).y + 90)

	local inView, dist = self:InDistance(125000)

	if (not inView) then return end

	color_white.a = 255 - (dist/500)
	color_black.a = color_white.a

	local x = math.sin(CurTime() * math.pi) * 30

	cam.Start3D2D(pos, ang, .05)
		draw.SimpleTextOutlined('Мусорка', '3d2d', 0, x, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		if self.NextUse > CurTime() then
			draw.SimpleTextOutlined(string.FormattedTime(self.NextUse - CurTime(), '%01i:%02i'), '3d2d', 0, x + 150, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		end
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-64, -300 + x, 128, 128)
	cam.End3D2D()
end

function ENT:PlayerUse(d)
    self.NextUse = d
end

net.Receive('rp:dumpster:Scavenge', function()
    local ent = net.ReadEntity()
    local time = net.ReadUInt(32)

	ent:PlayerUse(time)
end)