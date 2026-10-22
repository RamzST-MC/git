-- Хочешь хороший интерфейс и самописные системы?
-- Обращайся в дискорд tgmain
-- Портфолио --> https://discord.gg/NFa42fEgxn
local a = CLIENT and Material or function() end
local c
if CLIENT then
    c = function(g, i)
        local j = g == LocalPlayer() and g:GetAngles() or g:GetAimVector():Angle()
        i.Forward = j:Forward()
        i.Up = j:Up()
        i.Right = j:Right()
        i.Ang = j
        i.AngFlip = Angle(j)
        i.Ang:RotateAroundAxis(i.Up, 90)
        i.Ang:RotateAroundAxis(i.Right, -90)
        i.AngFlip:RotateAroundAxis(i.Up, -90)
        i.AngFlip:RotateAroundAxis(i.Right, 90)
    end
end

rp.emotes.Register('orgflag', {
    Name = 'Флаг организации',
    Lifetime = 2.5,
    Burst = a('divergent/emotes/burst-radial.png', 'smooth nocull'),
    CanRun = function(self, g) return g:GetOrg() ~= nil end,
    OnStart = function(self, g, i)
        c(g, i)
        i.Pos = g:EyePos() + i.Forward * 25
        g:DoAnimationEvent(ACT_GMOD_TAUNT_CHEER)
    end,
    Draw = function(self, g, i)
        local o = g:GetOrg()
        if not o then return end
        local a = rp.orgs.GetBanner(o)
        if not a then return end
        local p = g:GetOrgColor()
        local k = SysTime() - i.StartTime
        local l = math.min(k / .5, 1) - math.Clamp((k - 2) / 0.5, 0, 1)
        l = math.sin(l * math.pi * 0.5)
        local m = math.max((k - .5) / 2, 0)
        m = math.cos(m)
        local n = 1 - math.max((k - 2) / .5, 0)
        i.Pos = i.Pos + i.Forward * 3 * m * FrameTime()
        cam.Start3D2D(i.Pos, i.Ang, l)
        surface.SetDrawColor(p.r, p.g, p.b, n * 255)
        surface.SetMaterial(self.Burst)
        surface.DrawTexturedRect(-18, -19, 36, 36)
        surface.SetDrawColor(255, 255, 255, n * 255)
        surface.SetMaterial(a)
        surface.DrawTexturedRect(-10, -10, 20, 20)
        cam.End3D2D()
        cam.Start3D2D(i.Pos, i.AngFlip, l)
        surface.SetDrawColor(255, 255, 255, n * 255)
        surface.SetMaterial(a)
        surface.DrawTexturedRect(-10, -10, 20, 20)
        cam.End3D2D()
    end
})

rp.emotes.Register('thumbsup', {
    Name = 'Палец вверх',
    Lifetime = 2.5,
    Thumb = a('divergent/emotes/thumbs-up.png', 'smooth nocull'),
    Burst = a('divergent/emotes/burst-radial.png', 'smooth nocull'),
    OnStart = function(self, g, i)
        c(g, i)
        i.Pos = g:EyePos() + i.Forward * 25
        g:DoAnimationEvent(ACT_GMOD_GESTURE_AGREE)
    end,
    Draw = function(self, g, i)
        local m = SysTime() - i.StartTime
        local n = math.min(m / .5, 1) - math.Clamp((m - 2) / 0.5, 0, 1)
        n = math.sin(n * math.pi * 0.5)
        local o = math.max((m - .5) / 2, 0)
        o = math.cos(o)
        local p = 1 - math.max((m - 2) / .5, 0)
        i.Pos = i.Pos + i.Forward * 3 * o * FrameTime()
        cam.Start3D2D(i.Pos, i.Ang, n)
        surface.SetDrawColor(255, 255, 255, p * 255)
        surface.SetMaterial(self.Thumb)
        surface.DrawTexturedRect(-12, -12, 24, 24)
        cam.End3D2D()
    end
})

rp.emotes.Register('thumbsdown', {
    Name = 'Палец Вниз',
    Lifetime = 2.5,
    Thumb = a('divergent/emotes/thumbs-down.png', 'smooth nocull'),
    Burst = a('divergent/emotes/burst-radial.png', 'smooth nocull'),
    OnStart = function(self, g, i)
        c(g, i)
        i.Pos = g:EyePos() + i.Forward * 25
        g:DoAnimationEvent(ACT_GMOD_GESTURE_DISAGREE)
    end,
    Draw = function(self, g, i)
        local m = SysTime() - i.StartTime
        local n = math.min(m / .5, 1) - math.Clamp((m - 2) / 0.5, 0, 1)
        n = math.sin(n * math.pi * 0.5)
        local o = math.max((m - .5) / 2, 0)
        o = math.cos(o)
        local p = 1 - math.max((m - 2) / .5, 0)
        i.Pos = i.Pos + i.Forward * 3 * o * FrameTime()
        cam.Start3D2D(i.Pos, i.Ang, n)
        surface.SetDrawColor(255, 255, 255, p * 255)
        surface.SetMaterial(self.Thumb)
        surface.DrawTexturedRect(-12, -12, 24, 24)
        cam.End3D2D()
    end
})

rp.emotes.Register('bat', {
    Name = 'Мышь',
    Lifetime = 2.5,
    Thumb = a('divergent/emotes/bat.png', 'smooth nocull'),
    Burst = a('divergent/emotes/burst-radial.png', 'smooth nocull'),
    OnStart = function(self, g, i)
        c(g, i)
        i.Pos = g:EyePos() + i.Forward * 25
        g:DoAnimationEvent(ACT_GMOD_TAUNT_SALUTE)
    end,
    Draw = function(self, g, i)
        local m = SysTime() - i.StartTime
        local n = math.min(m / .5, 1) - math.Clamp((m - 2) / 0.5, 0, 1)
        n = math.sin(n * math.pi * 0.5)
        local o = math.max((m - .5) / 2, 0)
        o = math.cos(o)
        local p = 1 - math.max((m - 2) / .5, 0)
        i.Pos = i.Pos + i.Forward * 3 * o * FrameTime()
        cam.Start3D2D(i.Pos, i.Ang, n)
        surface.SetDrawColor(255, 255, 255, p * 255)
        surface.SetMaterial(self.Thumb)
        surface.DrawTexturedRect(-12, -12, 24, 24)
        cam.End3D2D()
    end
})

rp.emotes.Register('skull', {
    Name = 'Черепок',
    Lifetime = 2.5,
    Thumb = a('divergent/emotes/skull.png', 'smooth nocull'),
    Burst = a('divergent/emotes/burst-radial.png', 'smooth nocull'),
    OnStart = function(self, g, i)
        c(g, i)
        i.Pos = g:EyePos() + i.Forward * 25
        g:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
    end,
    Draw = function(self, g, i)
        local m = SysTime() - i.StartTime
        local n = math.min(m / .5, 1) - math.Clamp((m - 2) / 0.5, 0, 1)
        n = math.sin(n * math.pi * 0.5)
        local o = math.max((m - .5) / 2, 0)
        o = math.cos(o)
        local p = 1 - math.max((m - 2) / .5, 0)
        i.Pos = i.Pos + i.Forward * 3 * o * FrameTime()
        cam.Start3D2D(i.Pos, i.Ang, n)
        surface.SetDrawColor(255, 255, 255, p * 255)
        surface.SetMaterial(self.Thumb)
        surface.DrawTexturedRect(-12, -12, 24, 24)
        cam.End3D2D()
    end
})

rp.emotes.Register('blu', {
    Name = 'Звёздочки',
    Lifetime = 2.5,
    Thumb = a('sup/gui/generic/blu.png', 'smooth nocull'),
    Burst = a('divergent/emotes/burst-radial.png', 'smooth nocull'),
    OnStart = function(self, g, i)
        c(g, i)
        i.Pos = g:EyePos() + i.Forward * 25
        g:DoAnimationEvent(ACT_SIGNAL_FORWARD)
    end,
    Draw = function(self, g, i)
        local m = SysTime() - i.StartTime
        local n = math.min(m / .5, 1) - math.Clamp((m - 2) / 0.5, 0, 1)
        n = math.sin(n * math.pi * 0.5)
        local o = math.max((m - .5) / 2, 0)
        o = math.cos(o)
        local p = 1 - math.max((m - 2) / .5, 0)
        i.Pos = i.Pos + i.Forward * 3 * o * FrameTime()
        cam.Start3D2D(i.Pos, i.Ang, n)
        surface.SetDrawColor(255, 255, 255, p * 255)
        surface.SetMaterial(self.Thumb)
        surface.DrawTexturedRect(-12, -12, 24, 24)
        cam.End3D2D()
    end
})

rp.emotes.Register('blowkiss', {
    Name = 'Сердечко',
    Lifetime = 4,
    Heart = a('divergent/emotes/3d-heart.png', 'smooth nocull'),
    Burst = a('divergent/emotes/burst-radial.png', 'smooth nocull'),
    --  CanRun = function(self, g) return g:HasEmoteID(self.ID) end,
    OnStart = function(self, g, i)
        c(g, i)
        i.Pos = g:EyePos() + i.Forward * 25
        g:EmitSound("divergent/emotes/kiss.mp3")
        g:DoAnimationEvent(ACT_GMOD_GESTURE_BECON)
    end,
    Draw = function(self, g, i)
        local m = SysTime() - i.StartTime
        local n = math.min(m / .5, 1)
        n = math.sin(n * math.pi * 0.5)
        local o = math.max((m - .5) / 3.5, 0)
        o = math.cos(o)
        local p = 1 - math.max((m - 2) / 2, 0)
        i.Pos = i.Pos + i.Forward * 6 * o * FrameTime()
        cam.Start3D2D(i.Pos, i.Ang, n)
        surface.SetMaterial(self.Heart)
        surface.SetDrawColor(255, 255, 255, p * 255)
        surface.DrawTexturedRect(-12, -12, 24, 24)
        cam.End3D2D()
    end
})

rp.emotes.Register('eclipse', {
    Name = 'Затмение',
    Lifetime = 4,
    Eclipse = a('divergent/ui/hud/eclipse.png', 'smooth nocull'),
    Burst = a('divergent/emotes/burst-radial.png', 'smooth nocull'),
    --  CanRun = function(self, g) return g:HasEmoteID(self.ID) end,
    OnStart = function(self, g, i)
        c(g, i)
        i.Pos = g:EyePos() + i.Forward * 25
        g:DoAnimationEvent(ACT_GMOD_GESTURE_AGREE)
    end,
    Draw = function(self, g, i)
        local m = SysTime() - i.StartTime
        local n = math.min(m / .5, 1)
        n = math.sin(n * math.pi * 0.5)
        local o = math.max((m - .5) / 3.5, 0)
        o = math.cos(o)
        local p = 1 - math.max((m - 2) / 2, 0)
        i.Pos = i.Pos + i.Forward * 6 * o * FrameTime()
        cam.Start3D2D(i.Pos, i.Ang, n)
        surface.SetMaterial(self.Eclipse)
        surface.SetDrawColor(255, 255, 255, p * 255)
        surface.DrawTexturedRect(-12, -12, 24, 24)
        cam.End3D2D()
    end
})

rp.emotes.Register('supvelikm', {
    Name = 'САП ВЕЛИК СПС!111!!!',
    Lifetime = 4,
    Eclipse = a('sup/textless_logo.png', 'smooth nocull'),
    Burst = a('divergent/emotes/burst-radial.png', 'smooth nocull'),
    CanRun = function(self, g) return g:IsRoot() end,
    OnStart = function(self, g, i)
        c(g, i)
        i.Pos = g:EyePos() + i.Forward * 25
        g:DoAnimationEvent(ACT_GMOD_GESTURE_AGREE)
    end,
    Draw = function(self, g, i)
        local m = SysTime() - i.StartTime
        local n = math.min(m / .5, 1)
        n = math.sin(n * math.pi * 0.5)
        local o = math.max((m - .5) / 3.5, 0)
        o = math.cos(o)
        local p = 1 - math.max((m - 2) / 2, 0)
        i.Pos = i.Pos + i.Forward * 6 * o * FrameTime()
        cam.Start3D2D(i.Pos, i.Ang, n)
        surface.SetMaterial(self.Eclipse)
        surface.SetDrawColor(255, 255, 255, p * 255)
        surface.DrawTexturedRect(-12, -12, 24, 24)
        cam.End3D2D()
    end
})