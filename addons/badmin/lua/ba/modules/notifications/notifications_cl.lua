cvar.Register 'notification_sound'
	:SetDefault(true, true)
	:AddMetadata('Menu', 'Звук Оповещения')

notification = {}

local function a(a)
    return Material(a, 'smooth')
end

local b = {
    [NOTIFY_GENERIC] = {
        Color = Color(14, 59, 131),
        Icon = eclipse.material.NotifyGeneric
    },
    [NOTIFY_ERROR] = {
        Color = Color(181, 0, 0),
        Icon = eclipse.material.NotifyError
    },
    [NOTIFY_UNDO] = {
        Color = Color(186, 130, 60),
        Icon = eclipse.material.NotifyError
    },
    [NOTIFY_SUCCESS] = {
        Color = Color(0, 143, 40),
        Icon = eclipse.material.NotifySuccess
    },
    [NOTIFY_HINT] = {
        Color = Color(4, 61, 154),
        Icon = eclipse.material.NotifyHint
    }
}

for c, d in pairs(b) do
    d.BarColor = d.Color:Copy()
    d.BarColor.a = 50
end

local e = {}

function notification.AddProgress(f, g)
end

function notification.Kill(f)
    if IsValid(e[f]) then
        e[f].StartTime = SysTime()
        e[f].Length = 0.8
    end
end

function notification.AddLegacy(g, h, i)
    h = math.Clamp(h or 0, 0, 4)
    g = tostring(g):Trim()

    if g:sub(1, 1) == '#' then
        g = language.GetPhrase(g)
    end

    local j

    if GetOverlayPanel then
        j = GetOverlayPanel()
    end

    table.insert(e, ui.Create('NoticePanel', function(self, k)
        self.NotifyType = h
        self.StartTime = SysTime()
        self.Length = i
        self.VelX = 0
        self.VelY = 0
        self.fx = ScrW() + 200
        self.fy = ScrH()
        self:SetText(g)
        self:SetPos(self.fx, self.fy)
        self:SetMouseInputEnabled(false)
    end, j))

    MsgC(ui.col.White, '[', b[h].Color, 'Notification', ui.col.White, '] ', ui.col.White, g .. '\n')

    if cvar.GetValue("notification_sound") then
        surface.PlaySound('ambient/water/drip4.wav')
    end
end

local function l(m, n, o)
    local p = n.fx
    local q = n.fy
    local r = n:GetWide() + 16
    local s = n:GetTall() + 16
    local t = ScrH() - (o - m) * (s - 12) - 150
    local u = ScrW() - r - 20
    local v = n.StartTime - (SysTime() - n.Length)

    if v < 0.2 then
        u = u + r * 2
    end

    local w = FrameTime() * 15
    q = q + n.VelY * w
    p = p + n.VelX * w
    local x = t - q
    n.VelY = n.VelY + x * w * 1

    if math.abs(x) < 2 and math.abs(n.VelY) < 0.1 then
        n.VelY = 0
    end

    local x = u - p
    n.VelX = n.VelX + x * w * 1

    if math.abs(x) < 2 and math.abs(n.VelX) < 0.1 then
        n.VelX = 0
    end

    n.VelX = n.VelX * (0.9 - FrameTime() * 8)
    n.VelY = n.VelY * (0.9 - FrameTime() * 8)
    n.fx = p
    n.fy = q
    n:SetPos(n.fx, n.fy)
end

hook.Add('Think', 'NotificationThink', function()
    for c, d in ipairs(e) do
        l(c, d, #e)

        if IsValid(d) and d:KillSelf() then
            table.remove(e, c)
        end
    end
end)

local y = {}

function y:Init()
    self.NotifyType = NOTIFY_GENERIC
    self.Label = ui.Create('DLabel', self)
    self.Label:SetFont('ui.22')
    self.Label:SetTextColor(ui.col.White)
    self.Label:SetPos(34, 4)

    hook.Add('Think', self, function()
        self:SetVisible(hook.Call('HUDShouldDraw', GAMEMODE, 'Notifications') ~= false)
    end)
end

function y:SetText(z)
    self.Label:SetText(z)
    self:SizeToContents()
end

function y:SizeToContents()
    self.Label:SizeToContents()
    self:SetWidth(self.Label:GetWide() + 42)
    self:SetHeight(30)
    self:InvalidateLayout()
end

function y:KillSelf()
    if self.StartTime + self.Length < SysTime() then
        self:Remove()

        return true
    end

    return false
end

function y:Paint(r, s)
    local v = self.StartTime - (SysTime() - self.Length)
    local A = b[self.NotifyType]
    draw.Blur(self)
    draw.RoundedBox(5, 0, 0, r, s, ui.col.Background)
    draw.RoundedBox(5, 2.5, 2.5, 25, 25, A.Color)
    draw.RoundedBox(5, 0, 0, r * v / self.Length, s, A.BarColor)
    surface.SetMaterial(A.Icon)
    surface.SetDrawColor(255, 255, 255)
    surface.DrawTexturedRect(5, 5, 20, 20)
end

vgui.Register('NoticePanel', y, 'ui_panel')