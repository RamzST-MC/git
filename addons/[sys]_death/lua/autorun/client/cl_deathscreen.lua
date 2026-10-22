local function s(y)
    local scrW, scrH = ScrW(), ScrH()
    return math.Round(y * math.min(scrW, scrH) / 1080)
end

function draw.Image(x, y, w, h, mat, col )
    surface.SetDrawColor( col )
    surface.SetMaterial( mat )
    surface.DrawTexturedRect( x, y, w, h )
end

local col_white = Color(255,255,255)
local col_back = Color(0,0,0)
local col_red = Color(200, 50, 50)

surface.CreateFont('dsFont', {
    size = s(64),
    weight = 350,
    antialias = true,
    extended = true,
    font = 'Montserrat Regular'
})

surface.CreateFont('dsFont2', {
    size = s(96),
    weight = 350,
    antialias = true,
    extended = true,
    font = 'Montserrat Bold'
})

local mat1 = Material( 'sup/hud/death_frame-1.png', 'smooth mips')
local mat2 = Material( 'sup/hud/death_frame-2.png', 'smooth mips')
local mat3 = Material( 'sup/hud/death_frame-3.png', 'smooth mips')
local mat4 = Material( 'sup/hud/death_frame-4.png', 'smooth mips')
local mat5 = Material( 'sup/hud/death_screen.png', 'smooth mips')
local GetTimeDeath = 5

net.Receive('RespawnTimer', function()
    local wepname = net.ReadString()
    local killer = net.ReadEntity()

    local dead = RealTime()
    local p = LocalPlayer()

    local scrw, scrh = ScrW(), ScrH()

    local size = s(512)
    local x, y = scrw * 0.5 - size * 0.5, scrh * 0.5 - size * 0.5

    hook.Add('HUDPaint', 'DeathScreen', function()
        local time = math.Round( GetTimeDeath - RealTime() + dead )

        draw.RoundedBox( 0, 0, 0, scrw, scrh, col_back )

        draw.Image( x, y, size, size, mat5, col_white )

        if time < GetTimeDeath * 3/4 then
            draw.Image( x, y, size, size, mat1, col_white )
        end

        if time <= GetTimeDeath * 2/4 then
            draw.Image( x, y, size, size, mat2, col_white )
        end
        
        if time <= GetTimeDeath * 1/4 then
            draw.Image( x, y, size, size, mat3, col_white )
        end

        if time <= GetTimeDeath * 0 then
            draw.Image( x, y, size, size, mat4, col_white )
        end

        draw.SimpleText( time <= 0 and 'Вы можете возродиться' or 'До возрождения '.. time.. ' секунд', 'dsFont', scrw * 0.5, scrh - s(120), col_white, 1, 4 )

        draw.SimpleText( 'Вы мертвы!', 'dsFont2', scrw * 0.5, s(80), col_red, 1, 3 )
    end)

    system.FlashWindow()
end)

net.Receive('RespawnTimerHUD', function()
    dead = nil
    hook.Remove('HUDPaint', 'DeathScreen')
end)

hook.Add( 'Think', 'fdsf221f', function()
    local p = LocalPlayer()
    if p:Health() <= 1 then
        p:SetNWBool( 'dsh', true)
    else
        p:SetNWBool( 'dsh', false)
    end
end)

hook.Add( 'HUDShouldDraw', 'RemoveThatShit', function( name ) 
    if ( name == 'CHudDamageIndicator' ) then 
       return false 
    end
end )

hook.Add( 'OnContextMenuOpen', 'dflkjsgbdf4', function()
    local p = LocalPlayer()
    if not p:Alive() then
        return false
    end
end)

hook.Add( 'OnSpawnMenuOpen', 'd468flkj8sg54', function()
    local p = LocalPlayer()
    if not p:Alive() then
        return false
    end
end)

hook.Add( 'ScoreboardShow', 'd4fl5kjs58g54', function()
    local p = LocalPlayer()
    if not p:Alive() then
        return false
    end
end)

hook.Add( 'PlayerStartVoice', 'df6l52k90jsg4154', function()
    local p = LocalPlayer()
    if not p:Alive() then
        return false
    end
end)