dash.IncludeSH'shared.lua'

surface.CreateFont('Kazna::3d2d', {
    font = 'Montserrat Medium',
    size = 75,
    extended = true
})

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local function KaznaText(txt, x, y)
    draw.SimpleText(txt, 'Kazna::3d2d', x, y, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    draw.SimpleText(txt, 'Kazna::3d2d', x - 2, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
end

local mat = Material("divergent/entities/treasury.png")
-- local ok = (table.HasValue(rp.cfg.AllowedTeams, LocalPlayer():Team()) or LocalPlayer():IsGov())

local ang = Angle(0, 90, 90)
function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()

	ang.y = (LocalPlayer():EyeAngles().y - 90)

	local inView, dist = self:InDistance(150000)

	if (not inView) then return end

	local alpha = 255 - (dist/590)
	color_white.a = alpha
	color_black.a = alpha

	local x = math.sin(CurTime() * math.pi) * 30
	local y = -560

	cam.Start3D2D(pos, ang, .1)
		KaznaText(nw.GetGlobal('Kazna::EstTime') > 0 and 'Осталось: ' .. string.ToMinutesSeconds(nw.GetGlobal('Kazna::EstTime')) or nw.GetGlobal('Kazna::CoolDown') >= 1 and 'КД: ' .. string.ToMinutesSeconds(nw.GetGlobal('Kazna::CoolDown')) or 'Казна Города', 0, y)
		KaznaText(rp.FormatMoney(self:GetKaznaMoney()), 0, y + 75)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-64, y - 180, 96, 96)
	cam.End3D2D()
end

function ENT:Think()
	self.PressKeyText = table.HasValue(rp.cfg.AllowedTeams, LocalPlayer():Team()) and 'Чтобы ограбить'
end
