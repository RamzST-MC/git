local a = {}
local b = Color()
local function c(d)
    local e = string.Explode(' ', GetConVarString(d))
    b.r = math.Clamp(e[1] * 255, 0, 255)
    b.g = math.Clamp(e[2] * 255, 0, 255)
    b.b = math.Clamp(e[3] * 255, 0, 255)
    return b
end

local f, g = utf8.char(0xf074), utf8.char(0xf0c0)
function a:Init()
    self.ContTop = ui.Create('Panel', self)
    self.ContTop:Dock(TOP)
    self.PlayerColorLabel = ui.Create('ui_button', self.ContTop)
    self.PlayerColorLabel:SetText'Цвет Модели'
    self.PlayerColorLabel:SetEnabled(false)
    self.PlayerColorLabel:Dock(TOP)
    self.PlayerColorLabel.PaintOver = function(h, i, j) draw.RoundedBox(4, 2.5, 2.5, j - 5, j - 5, c('cl_playercolor')) end
    self.PlayerColor = ui.Create('DColorMixer', self.ContTop)
    self.PlayerColor:DockMargin(0, 5, 0, 0)
    self.PlayerColor:Dock(FILL)
    self.PlayerColor:SetAlphaBar(false)
    self.PlayerColor:SetVector(Vector(GetConVarString('cl_playercolor')))
    self.PlayerColor.ValueChanged = function()
        local vec = self.PlayerColor:GetVector()
        local vecstr = tostring(vec)
        timer.Create('rp.PlayerColor', 0.25, 1, function()
            RunConsoleCommand('cl_playercolor', vecstr)
            cmd.Run('playercolor', vec.x, vec.y, vec.z)
        end)
    end

    self.ContMiddle = ui.Create('Panel', self)
    self.ContMiddle:Dock(TOP)

    self.PhysgunColorLabel = ui.Create('ui_button', self.ContMiddle)
    self.PhysgunColorLabel:SetText'Цвет Физ-Гана'
    self.PhysgunColorLabel:SetEnabled(false)
    self.PhysgunColorLabel:DockMargin(0, 5, 0, 0)
    self.PhysgunColorLabel:Dock(TOP)
    self.PhysgunColorLabel.PaintOver = function(h, i, j) draw.RoundedBox(4, 2.5, 2.5, j - 5, j - 5, c('cl_weaponcolor')) end
    self.PhysgunColorCrazy = ui.Create('ui_button', self.PhysgunColorLabel)
    self.PhysgunColorCrazy:SetFont'ForkAwesome'
    self.PhysgunColorCrazy:SetContentAlignment(4)
    self.PhysgunColorCrazy:SetTextInset(9, 2)
    self.PhysgunColorCrazy:SetText(f)
    self.PhysgunColorCrazy:SetTooltip'Выбери сумасшедший цвет для Физгана'
    self.PhysgunColorCrazy:DockMargin(2.5, 2.5, 2.5, 2.5)
    self.PhysgunColorCrazy:Dock(RIGHT)
    self.PhysgunColorCrazy.DoClick = function()
        local min = math.Rand(10,100000000)
        local max = math.Rand(10,100000000)
        local a = math.Rand(-min, max)
        min = math.Rand(10,100000000)
        max = math.Rand(10,100000000)
        local b = math.Rand(-min, max)
        min = math.Rand(10,100000000)
        max = math.Rand(10,100000000)
        local c = math.Rand(-min, max)

        local vec = Vector(a, b, c)
        RunConsoleCommand('cl_weaponcolor', tostring(vec))
        cmd.Run('physcolor', vec.x, vec.y, vec.z)
    end

    self.PhysgunColor = ui.Create('DColorMixer', self.ContMiddle)
    self.PhysgunColor:DockMargin(0, 5, 0, 0)
    self.PhysgunColor:Dock(FILL)
    self.PhysgunColor:SetAlphaBar(false)
    self.PhysgunColor:SetVector(Vector(GetConVarString('cl_weaponcolor')))
    self.PhysgunColor.ValueChanged = function(h, k)
    end
end

function a:PerformLayout(i, j)
    self.ContTop:SetTall(j * 0.33)
    self.ContMiddle:SetTall(j * 0.33)
    self.PlayerColorLabel:SetTall(ui.SpacerHeight)
    self.PhysgunColorLabel:SetTall(ui.SpacerHeight)
    self.PhysgunColorCrazy:SetWide(ui.ButtonHeight)
end

vgui.Register('rp_settings_color', a, 'Panel')