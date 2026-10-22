local a = Vector(0, 0, 0)
local b = Angle(0, 0, 0)
local c = Vector(0, 0, 0)
local d = 0
local e = 0
local function f()
    local g = vgui.CursorVisible() and gui.ScreenToVector(gui.MousePos()) or LocalPlayer():GetAimVector()
    local h = util.IntersectRayWithPlane(LocalPlayer():EyePos(), g, a, c)
    if not h then return end
    if WorldToLocal(LocalPlayer():GetShootPos(), Angle(0, 0, 0), a, b).z < 0 then return end
    if e > 0 then if h:Distance(LocalPlayer():EyePos()) > e then return end end
    local i = WorldToLocal(h, Angle(0, 0, 0), a, b)
    return i.x, -i.y
end

local function j(k)
    local l = {}
    local m = k:GetParent()
    while m do
        table.insert(l, m)
        m = m:GetParent()
    end
    return l
end

local function n(k)
    local o, p = k:GetPos()
    local l = j(k)
    for q, m in ipairs(l) do
        local r, s = m:GetPos()
        o = o + r
        p = p + s
    end
    return o, p
end

local function t(k, o, p)
    local r, s = n(k)
    local u, v = k:GetSize()
    if not o or not p then return end
    o = o / d
    p = p / d
    return k:IsVisible() and o >= r and p >= s and o <= r + u and p <= s + v
end

local w = {}
local x = {}
local function y(k)
    return t(k, f())
end

local function z(k, A, ...)
    if not IsValid(k) or not k:IsVisible() or not t(k, f()) then return false end
    if not k:IsMouseInputEnabled() then return false end
    local B = false
    for C, D in pairs(table.Reverse(k:GetChildren())) do
        if z(D, A, ...) then
            B = true
            break
        end
    end

    if not B and k[A] then
        k[A](k, ...)
        x[k] = {...}
        return true
    else
        return false
    end
end

local function E(k, o, p)
end

local F = 0
local function G(q, H)
    local I = H == IN_USE and MOUSE_LEFT or H == IN_ATTACK and MOUSE_LEFT or H == IN_ATTACK2 and MOUSE_RIGHT or H == MOUSE_LEFT and MOUSE_LEFT or (H == MOUSE_RIGHT or MOUSE_RIGHT) or nil
    if not I then return end
    if F > CurTime() then return end
    F = CurTime() + 0.05
    for k in pairs(w) do
        if IsValid(k) then
            a = k.Origin
            d = k.Scale
            b = k.Angle
            c = k.Normal
            z(k, 'OnMousePressed', I)
        end
    end
end

hook.Add('VGUIMousePressed', 'VGUI3D2DMousePress', G)
hook.Add('KeyPress', 'VGUI3D2DMousePress', G)
hook.Add('KeyRelease', 'VGUI3D2DMouseRelease', function(q, H)
    for k, H in pairs(x) do
        if IsValid(k) then
            a = k.Origin
            d = k.Scale
            b = k.Angle
            c = k.Normal
            if k['OnMouseReleased'] then k['OnMouseReleased'](k, H[1]) end
            x[k] = nil
        end
    end
end)

function vgui.Start3D2D(i, J, K)
    a = i
    d = K
    b = J
    c = J:Up()
    e = 0
    cam.Start3D2D(i, J, K)
end

function vgui.MaxRange3D2D(L)
    e = isnumber(L) and L or 0
end

function vgui.IsPointingPanel(k)
    a = k.Origin
    d = k.Scale
    b = k.Angle
    c = k.Normal
    return t(k, f())
end

local M = FindMetaTable('Panel')
function M:GetMouseX()
    local N, q = f()
    return pw * (N or 0) / (pw * d)
end

function M:GetMouseY()
    local q, O = f()
    return ph * (O or 0) / (ph * d)
end

function M:GetMousePos()
    local N, O = f()
    local o = pw * (N or 0) / (pw * d)
    local p = ph * (O or 0) / (ph * d)
    return o, p
end

function M:Paint3D2D()
    if not self:IsValid() then return end
    w[self] = true
    local P = gui.MouseX
    local Q = gui.MouseY
    local N, O = f()
    local pw = self:GetWide()
    local ph = self:GetTall()
    function gui.MouseX()
        return pw * (N or 0) / (pw * d)
    end

    function gui.MouseY()
        return ph * (O or 0) / (ph * d)
    end

    if self.Think then
        if not self.OThink then
            self.OThink = self.Think
            self.Think = function()
                a = self.Origin
                d = self.Scale
                b = self.Angle
                c = self.Normal
                self:OThink()
            end
        end
    end

    E(self, gui.MouseX(), gui.MouseY())
    self.Origin = a
    self.Scale = d
    self.Angle = b
    self.Normal = c
    self:SetPaintedManually(false)
    self:PaintManual()
    self:SetPaintedManually(true)
    if self:IsMouseInputEnabled() then
        local R = math.Clamp(gui.MouseX(), 0, pw or 0)
        local S = math.Clamp(gui.MouseY(), 0, ph or 0)
        draw.RoundedBox(12, R - 4, S - 4, 8, 8, color_white)
    end

    gui.MouseX = P
    gui.MouseY = Q
end

function vgui.End3D2D()
    cam.End3D2D()
end