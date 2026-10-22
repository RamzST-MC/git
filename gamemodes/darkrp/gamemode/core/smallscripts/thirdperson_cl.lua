cvar.Register'enable_thirdperson':SetDefault(false, true):AddMetadata('Menu', 'Включить третье лицо'):AddMetadata('Category', 'Третье лицо'):ConCommand(function(self, a, b)
    if not b[1] then
        self:SetValue(not self:GetValue())
    else
        self:SetValue(b[1] == "1")
    end
end)

cvar.Register'invert_thirdp_mouse':SetDefault(false, true):AddMetadata('Menu', 'Инверсия'):AddMetadata('Category', 'Третье лицо')
local c, d = 120, 50
cvar.Register'thirdp_fov':SetDefault(90, true).Validate = function(self, e) return isnumber(e) and e >= d and e <= c end
rp.thirdPerson = {
    Allow = function(f) rp.thirdPerson.Allowed = f end,
    Allowed = true
}

local g = false
local h = CreateClientConVar('sup_thirdperson_x', '120')
local i = CreateClientConVar('sup_thirdperson_y', '0')
local j = CreateClientConVar('sup_thirdperson_z', '15')
local k, l = 40, 120
local m, n = -40, 40
local o, p = -15, 15
local q = 0
local function isenabled(a)
    if not rp.thirdPerson.Allowed then return false end
    a = a or LocalPlayer()
    if IsValid(a:GetViewEntity()) and a:GetViewEntity():GetClass() == "gmod_cameraprop" then return false end
    local s = a:GetActiveWeapon()
    if IsValid(s) then
        if s.ThirdPerson == false then
            return false
        elseif s.ThirdPerson then
            return true
        end
    end
    return cvar.GetValue('enable_thirdperson') and not a:InVehicle() and a:GetObserverMode() == OBS_MODE_NONE and a:Alive()
end

rp.thirdPerson.isEnabled = isenabled
local t = {}
local u
local v = nil
local w = function(x)
    if x:GetNetVar("IsGravGunned") then return false end
    return not (x:GetParent() == LocalPlayer() or x:IsPlayer()) and x:GetCollisionGroup() ~= COLLISION_GROUP_WORLD
end

local y = function(x) return not (x:GetParent() == LocalPlayer() or x:IsPlayer()) and x:GetCollisionGroup() ~= COLLISION_GROUP_WORLD end
hook('CalcView', 'ThirdPerson.CalcView', function(a, z, A)
    local B = isenabled(a)
    if (B or q > 0) and a.camera_ang then
        if B then
            q = math.min(q + (1 - q) * FrameTime() * 9, 1)
            if q > .99 then q = 1 end
        elseif not rp.thirdPerson.Allowed then
            q = math.max(q - q * FrameTime() * 18, 0)
            if q < .2 then q = 0 end
        else
            q = math.max(q - q * FrameTime() * 9, 0)
            if q < .01 then q = 0 end
        end

        local g = g
        if a:KeyDown(IN_WALK) then g = not g end
        if u and not g then
            a.camera_ang = Angle(u.p, u.y, u.r)
            u = nil
        elseif not u and g then
            u = Angle(a.camera_ang.p, a.camera_ang.y, a.camera_ang.r)
        end

        z = z + a.camera_ang:Forward() * q * -math.Clamp(h:GetInt(), k, l) + a.camera_ang:Right() * q * math.Clamp(i:GetInt(), m, n) + a.camera_ang:Up() * q * math.Clamp(j:GetInt(), o, p)
        local C = util.TraceHull({
            start = a:GetShootPos(),
            endpos = z,
            filter = w,
            mask = MASK_SOLID,
            mins = Vector(-10, -10, -10),
            maxs = Vector(10, 10, 10)
        })

        if C.Hit then z = C.HitPos + (a:GetShootPos() - C.HitPos):GetNormal() * 10 end
        local D = util.TraceLine({
            start = a:EyePos(),
            endpos = z + a.camera_ang:Forward() * 100000,
            filter = y
        })

        t.origin = z
        t.fov = cvar.GetValue('thirdp_fov')
        t.angles = a.camera_ang
        t.drawviewer = true
        if B and a:GetMoveType() == MOVETYPE_NOCLIP then
            a:SetEyeAngles(u or a.camera_ang)
        elseif B and not g then
            local E = (D.HitPos - a:EyePos()):Angle()
            sp = D.HitPos
            a:SetEyeAngles(E)
        end
        return t
    else
        if t and t.drawviewer then
            t.drawviewer = false
            return t
        end
    end
end)

hook('SuppressCrosshairFade', 'Thirdperson.SuppressCrosshairFade', function() if isenabled(LocalPlayer()) then return true end end)
hook("CreateMove", "ThirdPerson.CreateMove", function(F)
    local a = LocalPlayer()
    if isenabled(a) and a.camera_ang and a:GetMoveType() ~= MOVETYPE_NOCLIP then
        local G = u or a.camera_ang
        local H = a:GetAimVector():Angle()
        local I = Vector(F:GetForwardMove(), F:GetSideMove(), F:GetUpMove())
        I:Rotate(H - G)
        F:SetForwardMove(I.x)
        F:SetSideMove(I.y)
        F:SetUpMove(I.z)
        return false
    end
end)

hook("InputMouseApply", "ThirdPerson.InputMouseApply", function(F, h, i, J)
    local a = LocalPlayer()
    if isenabled(a) then
        if not a.camera_ang then a.camera_ang = a:EyeAngles() end
        if cvar.GetValue("invert_thirdp_mouse") then i = -i end
        a.camera_ang.p = math.Clamp(math.NormalizeAngle(a.camera_ang.p + i / 50), -90, 90)
        a.camera_ang.y = math.NormalizeAngle(a.camera_ang.y - h / 50)
        return true
    else
        a.camera_ang = a:EyeAngles()
    end
end)

local K
hook("PlayerBindPress", "ThirdPerson.PlayerBindPress", function(a, L, M)
    if M and L:lower() == "+walk" then
        local N = SysTime()
        if K and K > N - 0.75 then g = not g end
        K = N
    end
end)

local O
hook('CreateThirdPersonContextMenu', 'rp.ThirdPerson.CreateThirdPersonContextMenu', function(Q, R)
    local a = LocalPlayer()
    O = ui.Create('ui_frame', function(self, S)
        self:SetPos(Q, R)
        self:SetTitle("Третье лицо")
        self:SetSize(125, 85)
        self:ShowCloseButton(false)
    end, g_ContextMenu)

    O.btnReset = ui.Create('ui_button', function(self, S)
        local T = 25
        self:SetFont'ForkAwesome'
        self:SetContentAlignment(4)
        self:SetTextInset(7, 2)
        self:SetText(utf8.char(0xf0e2))
        self:SetTooltip'Сбросить настройки Третьего лица'
        self.Think = function()
            self:SetSize(T, T)
            self:SetPos(S:GetWide() - T - 2.5, 12.5)
        end

        self.DoClick = function()
            cvar.SetValue('invert_thirdp_mouse', false)
            O.chkInvert:SetChecked(false)
            h:SetInt(120)
            O.distSlider:SetValue(1 - (h:GetInt() - k) / (l - k))
            i:SetInt(0)
            j:SetInt(15)
            O.btnGrid:Layout()
            cvar.SetValue('thirdp_fov', 90)
            O.fovSlider:SetValue(1 - (cvar.GetValue('thirdp_fov') - d) / (c - d))
        end

        self.Paint = function(s, w, h)
            if s.Hovered then
                s.alp = Lerp(FrameTime() * 5, s.alp or 0, 1)
            else
                s.alp = Lerp(FrameTime() * 5, s.alp or 0, 0)
            end
            local col = Color(0, 0, 0)
            local col1 = Color(105, 122, 248)
            local col2 = Color(150, 162, 255)

            col:Lerp(s.alp, col1, col2)

            draw.RoundedBox(4, 0, 0, w, h, col)
        end
    end, O)

    O.chkEnable = ui.Create('ui_checkbox', function(self, S)
        self:SetPos(5, 60)
        self:SetText('Включить')
        self:SizeToContents()
        self:SetConVar('enable_thirdperson')
        self:SetMouseInputEnabled(true)
        self.OnChange = function(self, U)
            O.btnReset:SetVisible(U)
            if U then
                O:SetSize(179, 243)
            else
                O:SetSize(125, 85)
            end
        end
    end, O)

    O.chkEnable:OnChange(O.chkEnable:GetChecked())
    O.chkInvert = ui.Create('ui_checkbox', function(self, S)
        self:SetPos(5, 85)
        self:SetText('Инверсия')
        self:SizeToContents()
        self:SetConVar('invert_thirdp_mouse')
        self:SetMouseInputEnabled(true)
    end, O)

    local V = ui.Create('Panel', function(self, S)
        self:SetSize(128, 128)
        self:SetPos(5, 110)
        self.Paint = function(T, W, X)
            surface.SetDrawColor(ui.col.OffWhite)
            surface.DrawOutlinedRect(0, 0, W, X)
            surface.DrawLine(O.btnGrid.x + 8, 0, O.btnGrid.x + 8, X)
            surface.DrawLine(0, O.btnGrid.y + 8, W, O.btnGrid.y + 8)
            
            for i = 1, 15 do
                surface.SetDrawColor(ui.col.Hover)
                surface.DrawLine(0, i * 8, W, i * 8)
                surface.DrawLine(i * 8, 0, i * 8, X)
            end
        end
    end, O)

    O.btnGrid = ui.Create('ui_button', function(self, S)
        self:SetText('')
        self:SetSize(16, 16)
        self.OnMousePressed = function(T) T.Dragging = true end
        self:SetDisabled(true)
        self:SetColor(ui.col.ButtonHover)
        self.Think = function(T)
            if T.Dragging then
                if not input.IsMouseDown(MOUSE_LEFT) then
                    T.Dragging = false
                    return
                end

                local Y, Z = V:CursorPos()
                local _, a0 = self.x, self.y
                self:SetPos(math.Clamp(Y - 8, 0, V:GetWide() - 16), math.Clamp(Z - 8, 0, V:GetTall() - 16))
                if self.x ~= _ or self.y ~= a0 then
                    local a1 = self.x / (V:GetWide() - 16)
                    local a2 = 1 - self.y / (V:GetTall() - 16)
                    i:SetInt(m + a1 * (n - m))
                    j:SetInt(o + a2 * (p - o))
                end
            end
        end
    end, V)

    function O.btnGrid:Layout()
        local a3 = (i:GetInt() - m) / (n - m) * (V:GetWide() - 16)
        local a4 = (1 - (j:GetInt() - o) / (p - o)) * (V:GetTall() - 16)
        O.btnGrid:SetPos(a3, a4)
    end

    O.btnGrid:Layout()
    O.distSlider = ui.Create('ui_slider_vertical', function(self, S)
        local a5, i = V:GetPos()
        self:SetPos(138, i)
        self:SetTall(128)
        self:SetTooltip'Distance'
        self.OnChange = function(self, a6)
            a6 = 1 - a6
            h:SetInt(k + a6 * (l - k))
            self:SetTooltip('Distance (' .. math.Round(100 * a6, 0) .. ')')
        end
    end, O)

    O.distSlider:SetValue(1 - (h:GetInt() - k) / (l - k))
    O.distSlider:SetTooltip('Distance (' .. math.Round(100 * O.distSlider:GetValue(), 0) .. ')')
    O.fovSlider = ui.Create('ui_slider_vertical', function(self, S)
        local a5, i = V:GetPos()
        self:SetPos(158, i)
        self:SetTall(128)
        self:SetTooltip'FOV'
        self.OnChange = function(self, a6)
            a6 = 1 - a6
            cvar.SetValue('thirdp_fov', d + a6 * (c - d))
            self:SetTooltip('FOV (' .. math.Round(100 * a6, 0) .. ')')
        end
    end, O)

    O.fovSlider:SetValue(1 - (cvar.GetValue('thirdp_fov') - d) / (c - d))
    O.fovSlider:SetTooltip('FOV (' .. math.Round(100 * O.fovSlider:GetValue(), 0) .. ')')
end)

CreateContextMenu()
local function a7()
    if not IsValid(O) then return end
    O.chkEnable:SetChecked(cvar.GetValue('enable_thirdperson') == true)
    O.chkInvert:SetChecked(cvar.GetValue('invert_thirdp_mouse') == true)
    O.chkEnable:OnChange(O.chkEnable:GetChecked())
end

hook('OnContextMenuOpen', 'rp.ThirdPerson.OnContextMenuOpen', function() a7() end)
hook('PlayerBindPress', 'rp.ThirdPerson.PlayerBindPress', function(a, L, M, a8) timer.Simple(0, function() a7() end) end)
