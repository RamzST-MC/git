local a = {}
function a:Init()
    self:SetText('')

    self.hover_status_mdl = 0
    self.vibor = 0
    self.bool_hover = true
    self.font = 'ui.18'
    self.radius = 6
    self.icon = ''
    self.icon_size = 16
    self.text = ''
    self.col = ui.col.Button
    self.col_hov = ui.col.SUP
    self.bool_gradient = true
end

function a:SetTopText(b)
    self.TopText = b
end

function a:SetBottomText(b)
    self.BottomText = b
end

function a:SetHoverText(b)
    self.HoverText = b
end

function a:SetColor(c)
    self.Color = c:Copy()
    self.Color.a = 175
end

function a:SetTextColor(c)
    self.TextColor = c
end

function a:SetActive(d)
    self.Active = d
end

function a:SetModel(e, f, g)
    if not self.Model then
        self.Model = ui.Create('rp_modelicon', self)
        self.Model.DoClick = function(...) if self.DoClick then self.DoClick(self, ...) end end
        self.Model.DoRightClick = function(...) if self.DoRightClick then self.DoRightClick(self, ...) end end
        self.Model.OnDepressed = function(...) if self.OnDepressed then self.OnDepressed(self, ...) end end
        self.Model.OnReleased = function(...) if self.OnReleased then self.OnReleased(self, ...) end end
        self.Model.Paint = function() end
    end

    self.Model:SetModel(e, f, g)
end

function a:SetMaterial(h)
    self.Material = h
end

function a:Paint(w, h)
    if not self.m_bBackground then return end

    if self:IsHovered() or (IsValid(self.Model) and self.Model:IsHovered()) then
        self.hover_status_mdl = math.Clamp(self.hover_status_mdl + 4 * FrameTime(), 0, 255)
    else
        self.hover_status_mdl = math.Clamp(self.hover_status_mdl - 8 * FrameTime(), 0, 255)
    end

    draw.RoundedBox(self.radius, 0, 0, w, h, self.Color or self.col)

    if self.bool_hover and !self:GetDisabled() then
        draw.RoundedBox(self.radius, 0, 0, w, h, Color(self.col_hov.r, self.col_hov.g, self.col_hov.b, self.hover_status_mdl * 255))
    end

    if self.bool_gradient then
        draw.Gradient(0, 0, w, h, 1, Color(57, 55, 69, 150))
    end

    draw.SimpleText(self.TopText, 'ui.17', w * 0.5, 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.BottomText, 'ui.17', w * 0.5, h - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if self.icon != '' then
        surface.SetFont(self.font)
        
        local posX = (w - surface.GetTextSize(self.text) - self.icon_size) * 0.5 - 2
        local posY = (h - self.icon_size) * 0.5

        surface.SetDrawColor(color_white)
        surface.SetMaterial(self.icon)
        surface.DrawTexturedRect(posX, posY, self.icon_size, self.icon_size)
    end
end

function a:DrawHoverText(b, j, k, alpha)
    surface.SetFont('ui.18')
    local n, o = surface.GetTextSize(b)
    n, o = n + 10, o + 10
    local s = self.Color or ui.col.Button:Copy()
    local w = ui.col.White:Copy()
    s.a = alpha or 255
    w.a = alpha or 255
    draw.RoundedBox(5, j * 0.5 - n * 0.5, k * 0.5 - o * 0.5, n, o, s or ui.col.Button)
    draw.SimpleText(b, 'ui.18', j * 0.5, k * 0.5, w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function a:PaintOver(j, k)
    if self:IsHovered() or IsValid(self.Model) and self.Model:IsHovered() then
        self.vibor = Lerp(FrameTime() * 4, self.vibor or 0, 255)
    else
        self.vibor = Lerp(FrameTime() * 8, self.vibor or 0, 0)
    end

    if (self:IsHovered() or IsValid(self.Model) and self.Model:IsHovered()) and self.HoverText then self:DrawHoverText(self.HoverText, j, k, self.vibor) end
end

function a:PerformLayout(j, k)
    if self.Model then
        local m = k - 44
        self.Model:SetSize(m, m)
        local p = j * 0.5 - m * 0.5
        self.Model:SetPos(p, 22)
    end
end

function a:DoClick()
end

vgui.Register('rp_modelbutton', a, 'DButton')