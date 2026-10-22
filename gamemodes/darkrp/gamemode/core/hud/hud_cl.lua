rp.hud = rp.hud or {
    Panels = {}
}

local hit_icon = Material('sup/gui/hud/hitman.png')
local sw, sh = ScrW(), ScrH()
-- For lua refresh
include'hudpanels/base_cl.lua'
include'hudpanels/iconbox_cl.lua'
include'hudpanels/textbox_cl.lua'
include'hudpanels/box_cl.lua'
include'hudpanels/player_cl.lua'
include'hudpanels/info_cl.lua'
include'hudpanels/weapon_tooltips_cl.lua'
local function newPanel(name)
    local pnl = vgui.Create(name)
    table.insert(rp.hud.Panels, pnl)
    return pnl
end

-- VGUI HUD
local function createHud()
    for k, v in ipairs(rp.hud.Panels) do
        -- print('REMOVING HUD PANEL ' .. tostring(v))
        v:Remove()
        rp.hud.Panels[k] = nil
    end

    function Hits()
        if LocalPlayer():IsHitman() then
            local w = ScrW() * .175
            local x = 10
            local hits = table.Filter(player.GetAll(), function(pl) return pl:HasHit() and (pl ~= LocalPlayer()) end)
            if #hits >= 1 then
                draw.Box(5, 50, w, 27, Color(24, 24, 24, 255))
                local c = 1
                for k, v in ipairs(hits) do
                    if k == 6 then
                        draw.Box(5, 52 + (c * 25), w, 25, Color(35, 35, 35, 245))
                        draw.SimpleText('И еще ' .. #hits - 6 .. ' заказов!', 'ui.22', x, 63 + (c * 25), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        break
                    end

                    if IsValid(v) then
                        draw.Box(5, 52 + (c * 25), w, 25, v:GetJobColor(), Color(55, 55, 55))
                        draw.SimpleText(v:Name(), 'ui.22', x, 65 + (c * 25), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        local cost = rp.FormatMoney(v:GetHitPrice())
                        draw.SimpleText(cost, 'ui.22', w - 5 - surface.GetTextSize(cost), 65 + (c * 25), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        c = c + 1
                    end
                end
            else
                draw.Box(5, 50, w, 27, Color(24, 24, 24, 255))
                draw.Box(5, 67 + 10, w, (#hits * 18) + 23, Color(35, 35, 35, 245))
                draw.SimpleText('Нет заказов.', 'ui.22', x, 87, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            draw.SimpleText('Заказы: ', 'ui.22', x, 63, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    -- Cuffed
    rp.hud.Cuffed = newPanel'rp_hud_box'
    rp.hud.Cuffed:SetTitle('В наручниках!')
    rp.hud.Cuffed:SetMaterial('divergent/ui/hud/generic/handcuffs.png')
    rp.hud.Cuffed:SetColor(eclipse.col.Main)
    function rp.hud.Cuffed:FindPos()
        return ScrW() * 0.5 - self:GetWide() * 0.5, ScrH() - self:GetTall() - 50
    end

    function rp.hud.Cuffed:ShouldDraw()
        return LocalPlayer():IsCuffed() and LocalPlayer():Alive()
    end

    -- Arrested
    rp.hud.Arrested = newPanel'rp_hud_box'
    rp.hud.Arrested:SetTitle('Арест')
    rp.hud.Arrested:SetMaterial('divergent/ui/hud/generic/handcuffs.png')
    rp.hud.Arrested:SetColor(eclipse.col.Main)
    function rp.hud.Arrested:FindPos()
        return ScrW() * 0.5 - self:GetWide() * 0.5, ScrH() - self:GetTall() - 50
    end

    rp.hud.Arrested.Actor = ui.Create('rp_hud_info')
    rp.hud.Arrested.Actor:SetName('Арестовавший:')
    rp.hud.Arrested:AddItem(rp.hud.Arrested.Actor)
    rp.hud.Arrested.Time = ui.Create('rp_hud_info')
    rp.hud.Arrested.Time:SetName('Осталось:')
    rp.hud.Arrested:AddItem(rp.hud.Arrested.Time)
    function rp.hud.Arrested:ShouldDraw()
        return LocalPlayer():IsArrested() and LocalPlayer():Alive()
    end

    function rp.hud.Arrested:OnUpdate()
        local info = LocalPlayer():GetNetVar('ArrestedInfo')
        rp.hud.Arrested.Time:SetInfo(math.ceil(info.Release - CurTime()))
        rp.hud.Arrested.Actor:SetInfo(info.Actor)
    end

    -- Wanted
    rp.hud.Wanted = newPanel'rp_hud_box'
    rp.hud.Wanted:SetTitle('Розыск')
    rp.hud.Wanted:SetMaterial('divergent/ui/hud/generic/magnifying-glass.png')
    rp.hud.Wanted:SetColor(eclipse.col.Main)
    function rp.hud.Wanted:FindPos()
        return ScrW() * 0.5 - self:GetWide() * 0.5, ScrH() - self:GetTall() - 50
    end

    rp.hud.Wanted.Reason = ui.Create('rp_hud_info')
    rp.hud.Wanted.Reason:SetName('Причина:')
    rp.hud.Wanted:AddItem(rp.hud.Wanted.Reason)
    function rp.hud.Wanted:ShouldDraw()
        return LocalPlayer():IsWanted() and LocalPlayer():Alive()
    end

    function rp.hud.Wanted:OnUpdate()
        local info = LocalPlayer():GetWantedReason()
        rp.hud.Wanted.Reason:SetInfo(info)
    end

    rp.hud.Casino = newPanel'rp_hud_box'
    rp.hud.Casino:SetTitle('Казино')
    rp.hud.Casino:SetMaterial('divergent/ui/hud/generic/money.png')
    rp.hud.Casino:SetColor(eclipse.col.Main)
    function rp.hud.Casino:FindPos()
        return 5, ScrH() / 2 - self:GetTall() / 2
    end

    function rp.hud.Casino:ShouldDraw()
        return LocalPlayer():Team() == TEAM_CASINOOWNER and LocalPlayer():Alive()
    end

    rp.hud.Casino.Profit = ui.Create('rp_hud_info')
    rp.hud.Casino.Profit:SetName('Профит:')
    rp.hud.Casino:AddItem(rp.hud.Casino.Profit)
    rp.hud.Casino.Zarabotok = ui.Create('rp_hud_info')
    rp.hud.Casino.Zarabotok:SetName('Заработок:')
    rp.hud.Casino:AddItem(rp.hud.Casino.Zarabotok)
    rp.hud.Casino.Ubitok = ui.Create('rp_hud_info')
    rp.hud.Casino.Ubitok:SetName('Убыток:')
    rp.hud.Casino:AddItem(rp.hud.Casino.Ubitok)
    function rp.hud.Casino:OnUpdate()
        local profit = LocalPlayer():GetProfit()
        local zarabotok = LocalPlayer():GetZarobotok()
        local ubitok = LocalPlayer():GetUbitok()
        rp.hud.Casino.Profit:SetInfo(rp.FormatMoney(profit))
        rp.hud.Casino.Zarabotok:SetInfo(rp.FormatMoney(zarabotok))
        rp.hud.Casino.Ubitok:SetInfo(rp.FormatMoney(ubitok))
    end

    rp.hud.WeaponTooltips = newPanel'rp_hud_weapon_tooltips'
    hook('PlayerSwitchWeapon', rp.hud.WeaponTooltips, function(self, f, g, h)
        if IsFirstTimePredicted() and f == LocalPlayer() then
            self:Clear()
            if h.Tooltips then self:SetWeapon(h) end
        end
    end)
end

if IsValid(LocalPlayer()) then createHud() end
hook('ScreenSizeChanged', 'rp.hud.ScreenSizeChanged', createHud)
hook('InitPostEntity', 'rp.hud.InitPostEntity', createHud)
-- Main Draw
function GM:HUDPaint()
    draw.BlurResample()
    DrawWepSwitch()
    Hits()
end

-- Should Draw
local noDraw = {
    CHudHealth = true,
    CHudBattery = true,
    CHudSuitPower = true,
    CHudAmmo = true,
    CHudSecondaryAmmo = true,
    CHudWeaponSelection = true,
    CHudCrosshair = true
}

function GM:HUDShouldDraw(name)
    if noDraw[name] or ((name == 'CHudDamageIndicator') and (not LocalPlayer():Alive())) then return false end
    -- TODO Make this more elegant
    local wep = IsValid(LocalPlayer()) and LocalPlayer():GetActiveWeapon()
    if IsValid(wep) and wep:GetClass() == 'gmod_camera' then return name == 'CHudGMod' end
    return true
end

-- Color Modify
local modify = {
    ['$pp_colour_addr'] = 0,
    ['$pp_colour_addg'] = 0,
    ['$pp_colour_addb'] = 0,
    ['$pp_colour_brightness'] = 0,
    ['$pp_colour_contrast'] = 1,
    ['$pp_colour_colour'] = 0,
    ['$pp_colour_mulr'] = 0.05,
    ['$pp_colour_mulg'] = 0.05,
    ['$pp_colour_mulb'] = 0.05
}

function GM:RenderScreenspaceEffects()
    if (LocalPlayer():Health() <= 15) and LocalPlayer():GetNetVar('HasInitSpawn') then DrawColorModify(modify) end
end

-- TODO: Move this somewhere else
local scrW, scrH = ScrW(), ScrH()
hook('Think', 'rp.hud.Think', function()
    if (ScrW() ~= scrW) or (ScrH() ~= scrH) then
        hook.Call('ScreenSizeChanged', GAMEMODE, scrW, scrH)
        scrW, scrH = ScrW(), ScrH()
    end
end)