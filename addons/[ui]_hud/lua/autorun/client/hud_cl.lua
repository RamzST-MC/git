cvar.Register'enable_hud':SetDefault(true, true):AddMetadata('Catagory', 'Худ'):AddMetadata('Menu', 'Отображение худа')
cvar.Register'enable_clock':SetDefault(true, true):AddMetadata('Catagory', 'Худ'):AddMetadata('Menu', 'Отображение времени')
cvar.Register'enable_cross':SetDefault(false, true):AddMetadata('Catagory', 'Худ'):AddMetadata('Menu', 'Включить прицел')
cvar.Register 'disable_laws'
:SetDefault(true, true)
:AddMetadata('Catagory', 'Худ')
:AddMetadata('Menu', 'Отображение законов')
local cvar_Get = cvar.GetValue
local sw, sh = ScrW(), ScrH()
local mat_laws				= Material('vgui_2/laws.png')
local mat_scroll			= Material('vgui/gradient-d')
local TableWeapon = {
['weapon_bugbait'] = true,
['weapon_physcannon'] = true,
['weapon_keypadchecker'] = true,
['weapon_vape_hallucinogenic'] = true,
['weapon_vape'] = true,
}
function surface.TextSize(str, font)
if not font then font = 'Default' end
surface.SetFont(font)
local x, y = surface.GetTextSize(str)
return x, y or 0, 0
end
local color_white = Color(255, 255, 255)
local eclipse_color = eclipse.col.Eclipse:Copy()
eclipse_color.a = 195
hook.Add("HUDPaint", "EclipseHud::Otrisovka", function()
local ftspeed = FrameTime() * 4
local x, y = 20, sh - 55
local lp = LocalPlayer()
local function Health()
     local hp = lp:Health()
     local maxhealth = lp:GetMaxHealth()
     draw.DrawBlur(6, x, y, 140, 35, nil, eclipse_color)
     draw.Box(x + 38, y + 29, 100, 4, eclipse.col.hp_bg)
     draw.Box(x + 38, y + 29, math.Clamp(hp / maxhealth, 0, 1) * 100, 4, eclipse.col.hp)
     draw.SimpleText(hp .. '%', 'ui.20', x + 88, y + 17, color_white, 1, 1)
     draw.Material(x + 2.5, y + 2.5, 30, 30, eclipse.mat.Heart)
     x = x + 150
 end
 local function Armor()
     local arm = lp:Armor()
     local maxarm = lp:GetMaxArmor()
     draw.DrawBlur(6, x, y, 140, 35, nil, eclipse_color)
     draw.Box(x + 38, y + 29, 100, 4, eclipse.col.arm_bg)
     draw.Box(x + 38, y + 29, math.Clamp(arm / maxarm, 0, 1) * 100, 4, eclipse.col.arm)
     draw.SimpleText(arm .. '%', 'ui.20', x + 88, y + 17, color_white, 1, 1)
     draw.Material(x + 5, y + 5, 25, 25, eclipse.mat.Shield)
     x = x + 150
 end
 local function Hunger()
     local hr = lp:GetHunger()
     local maxhr = 100
     draw.DrawBlur(6, x, y, 140, 35, nil, eclipse_color)
     draw.Box(x + 38, y + 29, 100, 4, eclipse.col.food_bg)
     draw.Box(x + 38, y + 29, math.Clamp(hr / maxhr, 0, 1) * 100, 4, eclipse.col.food)
     draw.SimpleText(hr .. '%', 'ui.20', x + 88, y + 17, color_white, 1, 1)
     draw.Material(x + 5, y + 5, 25, 25, eclipse.mat.Food)
     x = x + 150
 end
 local function Money()
     local value = rp.FormatMoney(lp:GetMoney())
     local w = surface.TextSize(value, 'ui.20') + 65
     draw.DrawBlur(6, x, y, w, 35, nil, eclipse_color)
     draw.SimpleText(value, 'ui.20', x + 45, y + 17, color_white, 0, 1)
     draw.Material(x + 5, y + 5, 25, 25, eclipse.mat.Money)
     x = x + w + 5
 end
 local function Salary()
     local sal = rp.FormatMoney(lp:GetSalary())
     local w = surface.TextSize(sal, 'ui.20') + 65
     draw.DrawBlur(6, x, y, w, 35, nil, eclipse_color)
     draw.SimpleText(sal, 'ui.20', x + 45, y + 17, Color(100, 255, 100), 0, 1)
     draw.Material(x + 5, y + 5, 25, 25, eclipse.mat.Money)
     x = x + w + 5
 end
 -- ДОБАВЛЕНА ФУНКЦИЯ License()
 local function License()
     local license = lp:GetNWString('LicenseType', 'Лицензия')
     local w = surface.TextSize(license, 'ui.20') + 65
     draw.DrawBlur(6, x, y, w, 35, nil, eclipse_color)
     draw.SimpleText(license, 'ui.20', x + 45, y + 17, Color(255, 200, 100), 0, 1)
     draw.Material(x + 5, y + 5, 25, 25, eclipse.mat.License or eclipse.mat.Money)
     x = x + w + 5
 end
 local function PPOWn()
     x, y = 1, sh / 2
     local ent = lp:GetEyeTrace().Entity
     if IsValid(ent) and not ent:IsPlayer() and IsValid(ent:GetNWEntity("PP_Owner")) then
         widthe = surface.TextSize(ent:GetNWEntity("PP_Owner"):Name(), 'ui.20')
         draw.RoundedBox(8, x, y, widthe + 10, 22, eclipse_color)
         draw.SimpleText(ent:GetNWEntity("PP_Owner"):Name() or '', 'ui.20', x + 5, y, colo_soso)
     end
 end
 local function AmmoWep()
     local wep = lp:GetActiveWeapon()
     if not IsValid(wep) then return end
     local clip1 = wep:Clip1()
     local ammocount = lp:GetAmmoCount(wep:GetPrimaryAmmoType())
     local text
     if clip1 > -1 then
         text = clip1 .. '/' .. ammocount
     elseif ammocount > 0 then
         text = ammocount
     end
     if text and not TableWeapon[wep:GetClass()] then
         surface.SetFont('ui.20')
         local sx = surface.GetTextSize(text)
         LerpAmmo = Lerp(FrameTime() * 5, LerpAmmo or 0, sx or 0)
         draw.RoundedBox(5, sw - 78 - LerpAmmo, sh - 52, LerpAmmo + 55, 31, eclipse_color)
         draw.SimpleText(text, 'ui.20', sw - 30, sh - 47, eclipse.col.White, 2, 0)
         draw.Material(sw - 74 - LerpAmmo, sh - 49, 25, 25, eclipse.mat.Ammo)
     end
     if wep:GetClass() == 'weapon_physgun' or wep:GetClass() == 'gmod_tool' then
         surface.SetFont('ui.20')
         local text = (lp:GetNetVar('PropsCount') or 0) .. ' / ' .. (lp:GetNetVar('MaxProps') or 0)
         local sx = surface.GetTextSize(text)
         LerpAmmo = Lerp(FrameTime() * 5, LerpAmmo or 0, sx or 0)
         draw.RoundedBox(5, sw - 48 - LerpAmmo, sh - 52, LerpAmmo + 25, 31, eclipse_color)
         draw.SimpleText(text, 'ui.20', sw - 30, sh - 47, eclipse.col.White, 2, 0)
     end
 end
 local function MayorGrace()
     local str = 'Неприкосновенность Главы Города: ' .. string.FormattedTime(math.ceil(nw.GetGlobal('mayorGrace') - CurTime()), '%02i:%02i')
     local width = surface.TextSize(str, 'ui.20')
     draw.RoundedBox(8, sw / 2 - width / 2 - 35, sh * 0.9, width + 40, 22, Color(255, 132, 0, 120))
     draw.SimpleText(str, 'ui.20', sw / 2, sh * 0.9, color_white, TEXT_ALIGN_CENTER)
     draw.Material(sw / 2 - width / 2 - 30, sh * 0.9 - 5, 25, 25, eclipse.material.Radio)
 end
 local function Lockdown()
     if nw.GetGlobal('lockdown_reason') ~= nil then
         textcom = 'Объявлен комендантский час по причине: ' .. nw.GetGlobal('lockdown_reason')
     else
         textcom = 'Объявлен комендантский час по причине: Массовые беспорядки'
     end
     local width = surface.TextSize(textcom, 'ui.20')
     local vremya = string.FormattedTime(nw.GetGlobal('lockdown_time') - CurTime(), '%02i:%02i')
     local w = surface.TextSize(vremya, 'ui.20')
     draw.RoundedBox(8, sw / 2 - width / 2 - 5, 5, width + 10, 25, eclipse_color)
     draw.SimpleText(textcom, 'ui.20', sw / 2, 5, color_white, TEXT_ALIGN_CENTER)
     draw.RoundedBox(8, sw / 2 - w / 2 - 5, 30, w + 40, 25, eclipse_color)
     draw.Material(sw / 2 - w + 20, 33, 20, 20, eclipse.material.Search)
     draw.SimpleText(vremya, 'ui.20', sw / 2 + 30, 30, color_white, TEXT_ALIGN_CENTER)
 end
 local crosshair_data = {
     crosshair = GetConVar("eclipsecross"):GetString(),
     size = GetConVar("eclipsecross_size"):GetInt(),
     color = Color(GetConVar("eclipsecross_r"):GetInt(), GetConVar("eclipsecross_g"):GetInt(), GetConVar("eclipsecross_b"):GetInt())
 }
 do
     local types = {
         ["eclipsecross"] = "crosshair",
         ["eclipsecross_size"] = "size"
     }
     for cvar, lvar in pairs(types) do
         cvars.AddChangeCallback(cvar, function(_, _, new)
             crosshair_data[lvar] = new
         end)
     end
     local colors = {"r", "g", "b"}
     for _, t in ipairs(colors) do
         cvars.AddChangeCallback("eclipsecross_" .. t, function(_, _, new)
             crosshair_data.color[t] = tonumber(new)
         end)
     end
 end
 local crosshair, size, color
 local function DrawCrosshair()
     local ply = lp
     local wep = ply:GetActiveWeapon()
     if wep and IsValid(wep) then
         crosshair = crosshair_data.crosshair
         size = crosshair_data.size
         color = crosshair_data.color
         surface.SetDrawColor(color)
         if crosshair == "circle" then
             draw.RoundedBox(100, sw / 2 - (size / 2), sh / 2 - (size / 2), size, size, color)
         elseif crosshair == "circle_empty" then
             surface.DrawCircle(sw / 2, sh / 2, size, color)
             surface.DrawCircle(sw / 2, sh / 2, size + 1, color)
         elseif crosshair == "circle_empty_cross" then
             surface.DrawCircle(sw / 2, sh / 2, size, color)
             surface.DrawCircle(sw / 2, sh / 2, size + 1, color)
             surface.DrawRect(sw / 2 - 1, sh / 2 - size, 2, size * 2)
             surface.DrawRect(sw / 2 - size, sh / 2 - 1, size * 2, 2)
         elseif crosshair == "rect_empty" then
             surface.DrawOutlinedRect((sw / 2) - (size / 2), (sh / 2) - (size / 2), size, size, 2)
         elseif crosshair == "rect" then
             surface.DrawRect((sw / 2) - (size / 2), (sh / 2) - (size / 2), size, size)
         elseif crosshair == "cross" then
             surface.DrawRect(sw / 2 - 1, sh / 2 - size, 2, size * 2)
             surface.DrawRect(sw / 2 - size, sh / 2 - 1, size * 2, 2)
         end
     end
 end
 local function FD()
     local ent = lp:GetEyeTrace().Entity
     if IsValid(ent) and ent:GetNWBool('FadingDoorBool') then draw.Material(ScrW() / 2 - 16, ScrH() - 120, 32, 32, eclipse.material.Locked) end
 end
 function HudEclipse()
     if not lp:IsBanned() and lp:Alive() then
         if cvar_Get('enable_hud') then
             Health()
             if lp:Armor() > 0 then Armor() end
             Hunger()
             Money()
             Salary()
             x = x + 15
             if lp:HasLicense() then License() end
             local trent = lp:GetEyeTrace().Entity
             if IsValid(trent) then if lp:GetPos():Distance(trent:GetPos()) < 500 and trent:GetNWEntity("PP_Owner") then PPOWn() end end
             AmmoWep()
             FD()
             if cvar_Get('enable_cross') then DrawCrosshair() end
             if nw.GetGlobal('mayorGrace') and nw.GetGlobal('mayorGrace') > CurTime() then MayorGrace() end
             if nw.GetGlobal('lockdown') then Lockdown() end
         end
     end
 end
 HudEclipse()
end)
local function LawsInterface()
local scrw, scrh = ScrW(), ScrH()
local ply = LocalPlayer()
local GetLaws = rp.cfg.DefaultLaws and nw.GetGlobal('TheLaws') or rp.cfg.DefaultLaws
if not cvar.GetValue('disable_laws') or not cvar.GetValue('enable_hud') or not ply:Alive() then 
     if IsValid(LAWS_PANEL) then
         LAWS_PANEL:Remove()
         LAWS_PANEL = nil
     end
     return
 end
 if not IsValid(LAWS_PANEL) then
     local LawsPanel = vgui.Create('EditablePanel')
     LAWS_PANEL = LawsPanel
     LAWS_PANEL:SetPos(scrw-236, 97)
     LAWS_PANEL:SetWide(226)
     LAWS_PANEL:SetTall(300)
     function LAWS_PANEL:Paint(w,h)
         draw.RoundedBox(8, 0, 4, w, h-4, Color(35, 35, 35, 100))
         draw.RoundedBoxEx(8, 0, 4, w, 31, Color(35, 35, 35, 100), true, true, false, false)
         draw.Material(5, 6, 26, 26, eclipse.mat.Laws)
         draw.SimpleText('Законы Города', 'ui.20', 40, 8, color_white, 0, 0)
     end
     local LawsList = ui.Create('DPanel', LAWS_PANEL)
     LawsList:SetPos(5, 31)
     LawsList:SetSize(LAWS_PANEL:GetWide() - 10, LAWS_PANEL:GetTall()-36)
     LawsList.Paint = function()end
     local LawsScroll = ui.Create('ui_scrollpanel', LawsList)
     LawsScroll:Dock(FILL)
     LawsScroll:DockMargin(0,5,0,0)
     local LawText = vgui.Create('DLabel', LawsList)
     LAWS_PANEL.LawText = LawText
     LawText:SetFont('ui.20')
     LawText:SetWrap(true)
     LawText:Dock(TOP)
     LawText:SetAutoStretchVertical(true)
     LawText:SetContentAlignment(4)
     LawText:SetTextColor(color_white)
     LawsScroll:AddItem(LawText)
 end
 if IsValid(LAWS_PANEL) and IsValid(LAWS_PANEL.LawText) then
     local newLaws = rp.cfg.DefaultLaws and nw.GetGlobal('TheLaws') or rp.cfg.DefaultLaws
     if LAWS_PANEL.LawText:GetText() ~= newLaws then
         LAWS_PANEL.LawText:SetText(newLaws)
     end
 end
end
hook.Add('Think', 'UI_DRAW_PANEL', function()
if IsValid(LocalPlayer()) then
LawsInterface()
end
end)
hook.Add('ScreenSizeChanged', 'Eclipse.ScreenSizeChanged', function()
sw, sh = ScrW(), ScrH()
end)
hook.Add('InitPostEntity', 'Eclipse.InitPostEntity', function()
sw, sh = ScrW(), ScrH()
end)
hook.Add('Think', 'Eclipse.Think', function()
if (ScrW() ~= sw) or (ScrH() ~= sh) then
sw, sh = ScrW(), ScrH()
end
end)