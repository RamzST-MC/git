dash.IncludeSH'shared.lua'
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Draw = ENTITY.DrawModel
local a = ui.col.White:Copy()
local b = ui.col.Black:Copy()

function ENT:DrawTranslucent()
    local c = self:GetPos()
    local d = self:GetAngles()
    local e, f = self:InDistance(125000)
    if not e then return end
    a.a = 255 - f / 500
    b.a = a.a
    d:RotateAroundAxis(d:Forward(), 90)
    d:RotateAroundAxis(d:Right(), -90)
    cam.Start3D2D(c + self:GetForward() * (self:OBBMaxs().y - 4.25), d, 0.020)
        draw.RoundedBox(20, -550, -325, 1100, 650, b)
        draw.SimpleText(IsValid(self:Getowning_ent()) and self:Getowning_ent():Name() or 'нет владельца', '3d2d', 0, 0, a, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(string.FormatUSD(self:Getmoney()), '3d2d', 0, 0, a, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    cam.End3D2D()
end