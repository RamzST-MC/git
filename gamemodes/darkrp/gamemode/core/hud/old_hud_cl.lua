local CurTime = CurTime
local IsValid = IsValid
local ipairs = ipairs
local Color = Color
local cvar_Get = cvar.GetValue
local hook_Call = hook.Call
local rp_FormatMoney = rp.FormatMoney
local draw_SimpleText = draw.SimpleText
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_GetTextSize = surface.GetTextSize
local surface_SetFont = surface.SetFont
local surface_SetMaterial = surface.SetMaterial
local surface_SetTextPos = surface.SetTextPos
local surface_SetTextColor = surface.SetTextColor
local surface_DrawText = surface.DrawText
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local color_white = rp.col.White
local color_black = rp.col.Black
local color_red = ui.col.Red
local color_orange = ui.col.Orange
local color_blue = rp.col.SUP

local function mat(texture)
	return Material(texture, 'smooth')
end

function TextSize(str, font)
    if not font then font = 'Default' end
    surface.SetFont(font)
    local x, y = surface.GetTextSize(str)
    return x, y or 0, 0
end

local material_wanted = mat'sup/gui/generic/search.png'
-- player
local material_licence = eclipse.material.License
local material_mic = mat'sup/hud/istalking'
local material_typing = mat'sup/hud/istyping'
local material_voice_muted = mat'sup/hud/voice_muted.png'
local material_chat_muted = mat'sup/hud/chat_muted.png'
local material_presse = eclipse.material.BlankButton
local sw, sh = ScrW(), ScrH()
local players = {}
cvar.Register'enable_localplayerinfotag':SetDefault(false, true):AddMetadata('Catagory', 'Худ'):AddMetadata('Menu', 'Включить отображение никнейма при третьем лице (у себя)')

surface.CreateFont('PlayerInfo', {
	font = 'Montserrat',
	extended = true,
	outline = true,
	shadow = true,
	size = 128,
	weight = 250
})

local talkingplayers = {}
hook('PlayerStartVoice', 'rp.hud.PlayerStartVoice', function(pl) talkingplayers[pl] = true end)
hook('PlayerEndVoice', 'rp.hud.PlayerEndVoice', function(pl) talkingplayers[pl] = nil end)
timer.Simple(1, function()
	Material('voice/icntlk_pl'):SetFloat('$alpha', 0) -- hacky voice bubble fix
end)

-- utils
function GM:DrawBannedHUD()
	local time = LocalPlayer():GetBanTime()

	draw.RoundedBox(0, 0, 0, sw, sh, Color(0, 0, 0, 120))
	draw.SimpleText('Вас забанил: ' .. LocalPlayer():GetNetVar('AdminBan'), 'ui.24', sw / 2, sh / 2 - 20, color_white, 1, 1)
	draw.SimpleText('По причине: ' .. LocalPlayer():GetNetVar('ReasonBan'), 'ui.24', sw / 2, sh / 2, color_white, 1, 1)
	draw.SimpleText('Разбан в: ' .. time, 'ui.24', sw / 2, sh / 2 + 20, color_white, 1, 1)
end

local ztcStart
local ztcEnd
function GM:DrawZiptieCutting()
	--[[local pl = LocalPlayer()
	local endTime = pl:GetNetVar('ZiptieCutting')

	if endTime then
		ztcStart = ztcStart or RealTime()
		ztcEnd = ztcEnd or RealTime() + (endTime - CurTime())

		local perc = math.min((RealTime() - ztcStart) / (ztcEnd - ztcStart), 1)

		rp.ui.DrawCenteredProgress(pl:IsZiptied() and "Идет освобождение.." or "Освобождение..", perc)
	else
		if (ztcStart) then ztcStart = nil ztcEnd = nil end
	end]]
end

local n = eclipse.material.BlankButton
local o = n
function DrawKey(p, d, e)
    surface.SetFont'ui.22'
    p = p:upper()
    local q, r = surface.GetTextSize(p)
    local f, g = math.max(32, q + 10), 32
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(f > 34 and o or n)
    surface.DrawTexturedRect(d, e, f, g)
    surface.SetTextColor(255, 255, 255)
    surface.SetTextPos(d + f * 0.5 - q * 0.5, e + g * 0.5 - r * 0.5)
    surface.DrawText(p)
    return f, g
end

local function ab(a8, a7, Z, _)
    local ac, ad = DrawKey(a8, Z, _)
    draw.SimpleText(a7, 'ui.22', Z + ac + 5, _ + ad * 0.5, ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    return ad
end

function GM:DrawEntityDisplay(O, P)
    local ae = LocalPlayer():GetEyeTrace().Entity
    local Z, _ = ScrW() * 0.5, ScrH() * 0.65
    if IsValid(ae) and LocalPlayer():GetPos():Distance(ae:GetPos()) < 115 then
        if ae.PressKeyText or ae.PressE then
			if ae:IsPlayer() and ae:GetNoDraw() == false then return end
			if istable(ae.PressKeyText) then
				for af, ag in pairs(ae.PressKeyText) do
					_ = _ + 5 + ab(af, ag, Z, _)
				end
			else
				_ = _ + 5 + ab(input.LookupBinding('+use') or 'E', ae.PressKeyText or 'Использовать', Z, _)
			end
        end

        for a9, ah in ipairs(rp.binds.EntityTooltipBinds) do
            if ah:ShouldDrawTooltip(ae) then _ = _ + 5 + ab(input.GetKeyName(ah:GetKey()), ah:GetTooltipText(ae), Z, _) end
        end
    end

    for a9, ah in ipairs(rp.binds.TooltipBinds) do
        if ah:ShouldDrawTooltip() then _ = _ + 5 + ab(input.GetKeyName(ah:GetKey()), ah:GetTooltipText(), Z, _) end
    end
end

local quickWantPlater
local quickwantTarget
local quickwantTargetTime
local stunstick = Material('sup/hud/stunstick_silhouette.png', 'smooth')
function GM:DrawQuickwantTarget()
	local diff = math.max(math.Round(quickwantTargetTime - SysTime(), 2), 0)
	if (diff == 0) or (not IsValid(quickWantPlater)) or quickWantPlater:IsArrested() then
		quickwantTarget = nil
		quickwantTargetTime = nil
		quickWantPlater = nil
		return
	end

	local diffstr = tostring(diff)
	if #diffstr == 3 then
		diffstr = diffstr .. '0'
	elseif #diffstr == 1 then
		diffstr = diffstr .. '.00'
	end

	local f1 = 'ui.60'
	local f2 = 'ui.35'
	local f3 = 'ui.24'
	local sub = 8
	local add = 3
	surface.SetFont(f1)
	local tw, th = surface.GetTextSize(diffstr)
	surface.SetFont(f2)
	local tw2, th2 = surface.GetTextSize(quickwantTarget)
	surface.SetFont(f3)
	local tw3, th3 = surface.GetTextSize("Right click your baton to catch this criminal!")
	local width = math.max(tw, tw2, tw3) + 16
	local y = height + 5
	local gbVal = 130 + math.sin(SysTime() * 10) * 125
	draw.BlurBox((ScrW() - width) * 0.5, y, width, th + th2 + th3 - sub + add)
	surface.SetDrawColor(ui.col.Background)
	surface.DrawRect((ScrW() - width) * 0.5, y, width, th + th2 + th3 - sub + add)
	surface.SetDrawColor(ui.col.Outline)
	surface.DrawOutlinedRect((ScrW() - width) * 0.5, y, width, th + th2 + th3 - sub + add)
	surface.SetMaterial(stunstick)
	surface.SetDrawColor(100, 100, 100)
	surface.DrawTexturedRect((ScrW() - width) * 0.5, y - 15, 102, 115)
	surface.DrawTexturedRectUV((ScrW() + width) * 0.5 - 102, y - 15, 102, 115, 1, 0, 0, 1)
	surface.SetFont(f1)
	surface.SetTextPos((ScrW() - tw) * 0.5, y)
	surface.SetTextColor(255, gbVal, gbVal)
	surface.DrawText(diffstr)
	y = y + th - sub
	surface.SetFont(f2)
	surface.SetTextPos((ScrW() - tw2) * 0.5, y)
	surface.SetTextColor(ui.col.White)
	surface.DrawText(quickwantTarget)
	y = y + th2
	surface.SetFont(f3)
	surface.SetTextPos((ScrW() - tw3) * 0.5, y)
	surface.DrawText("Right click your baton to catch this criminal!")
end

net.Receive('rp.QuickwantTarget', function(len)
	local pl = net.ReadPlayer()
	if not IsValid(pl) then return end
	quickWantPlater = pl
	quickwantTarget = "Attacked!" --pl:Name()
	quickwantTargetTime = (net.ReadFloat() - CurTime()) + SysTime()
end)

hook('HUDPaint', 'rp.hud.HUDPaint', function()
	sw, sh = ScrW(), ScrH()
	LP = LocalPlayer()
	if LocalPlayer():IsBanned() then
		GAMEMODE:DrawBannedHUD()
	else
		if hook.Call('HUDShouldDraw', GAMEMODE, 'SUPHUD') ~= false then
			GAMEMODE:DrawEntityDisplay(sw, sh)
			GAMEMODE:DrawPlayerInfo()
			GAMEMODE:DrawZiptieCutting()
		end
	end
end)

-- Player info
timer.Create('rp.hud.DrawCache', 0.5, 0, function()
	local LP = LocalPlayer()
	players = table.Filter(player.GetAll(), function(pl)
		if IsValid(pl) then
			local insight = pl:Alive() and (pl == LP) or (pl:InSight() and pl:InTrace())
			pl.IsCurrentlyVisible = insight
			return (pl ~= LP or (cvar_Get('enable_localplayerinfotag') and rp.thirdPerson.isEnabled())) and insight and (hook_Call('HUDShouldDraw', nil, 'PlayerDisplay', pl) ~= false)
		end
	end)
end)

local infoy = 0
local function drawinfo(text, color)
    local w, h = surface_GetTextSize(text)
    surface_SetTextColor(color.r, color.g, color.b, color.a)
    local x = -(w * 0.5)
    local y = infoy
    surface_SetTextPos(x, infoy)
    surface_DrawText(text)
    infoy = infoy - (h - 20)

    return x, y, w, h, infoy
end

local color_12h = Color(190, 214, 229)
local color_5k = Color(240, 191, 0)
local color_cache = {}
local c = 0
for i = 0, 720 do
	color_cache[i] = HSVToColor(c, 1, 0.9)
	c = (c == 360) and 1 or (c + 1)
end

local offset = 0
local lastFreq = 0
local function drawRainbowInfo(text)
	local w, h = surface_GetTextSize(text)
	local x = -(w * 0.5)
	local y = infoy
	local freq = math.floor(math.sin(RealTime()) * 35)
	if (freq == 34) and (lastFreq ~= freq) then offset = (offset == 360) and 0 or (offset + 1) end
	lastFreq = freq
	for c = 1, #text do
		local i = (freq < 0) and (#text - (c - 1)) or c
		local hue = (freq * c) % 360
		surface.SetTextColor(color_cache[hue + offset])
		local w = surface.GetTextSize(string.sub(text, 1, i - 1))
		surface.SetTextPos(x + w, infoy)
		surface.DrawText(string.sub(text, i, i))
	end

	infoy = infoy - (h - 20)
	return x, y, w, h, infoy
end

local pang = Angle(0, 90, 90)
function GM:DrawPlayerInfo(pl)
	if (not IsValid(pl)) or (not (cvar_Get('enable_localplayerinfotag') and rp.thirdPerson.isEnabled()) and (pl == LocalPlayer())) or (not pl:Alive()) or pl:GetNoDraw() then return end
	local bone = pl:LookupBone('ValveBiped.Bip01_Head1')
	local flash = HSVToColor(math.sin(RealTime() * 3) > 0 and 0 or 240, math.abs(math.sin(RealTime() * 3)), 1)
	if not bone then return end
	local pos, _ = pl:GetBonePosition(bone)
	if not pos then return end
	infoy = 0
	if pl.InfoOffset then
		pos.z = pos.z + pl.InfoOffset + 7.5
	else
		pos.z = pos.z + 12.5
	end

	pang.y = LocalPlayer():EyeAngles().y - 90
	cam_Start3D2D(pos, pang, 0.03)
	local x, y, w, h, y2
	local org = pl:GetOrg()
	if org ~= nil then x, y, w, h, y2 = drawinfo(org, pl:GetOrgColor()) end

	local name = pl:GetParty() and '['.. pl:GetParty() ..'] ' .. pl:Name() or pl:Name()

	if pl:HasAchievement(ACHIEVEMENT_TIME_15K) then
		x, y, w, h, y2 = drawRainbowInfo(name)
	else
		local color_name = color_white

		if pl:HasAchievement(ACHIEVEMENT_TIME_5K) then
			color_name = color_5k
		elseif pl:HasAchievement(ACHIEVEMENT_TIME_12HR) then
			color_name = color_12h
		end

		x, y, w, h, y2 = drawinfo(name, color_name)
	end

	if pl:HasLicense() then
		surface_SetMaterial(material_licence)
		surface_SetDrawColor(color_white)
		surface_DrawTexturedRect(x + w + 10, y2 + 128, 100, 100)
	end

	if pl:IsCuffed() then
		x, y, w, h, y2 = drawinfo('В наручниках', flash)
		surface_SetMaterial(eclipse.material.HandCuffs)
		surface_SetDrawColor(flash)
		surface_DrawTexturedRect(x + w + 10, y2 + 118, 128, 128)
		surface_DrawTexturedRect(x - 138, y2 + 118, 128, 128)
	end
	if pl:IsWanted() then
		x, y, w, h, y2 = drawinfo('В розыске', flash)
		surface_SetMaterial(eclipse.material.Search)
		surface_SetDrawColor(flash)
		surface_DrawTexturedRect(x + w + 10, y2 + 118, 128, 128)
		surface_DrawTexturedRect(x - 138, y2 + 118, 128, 128)
	elseif pl:IsArrested() then
		x, y, w, h, y2 = drawinfo('Заключенный', color_orange)
	else
		x, y, w, h, y2 = drawinfo(pl:GetJobName(), pl:GetJobColor())
	end

	local isadmin = LocalPlayer():Team() == TEAM_ADMIN
	if (LocalPlayer():IsHitman() or isadmin) and pl:HasHit() and (pl ~= LocalPlayer()) then x, y, w, h, y2 = drawinfo('Заказ ' .. rp_FormatMoney(pl:GetHitPrice()), color_red) end
	if pl:IsDisguised() and (isadmin or (LocalPlayer():IsGov() and pl:IsGov())) then x, y, w, h, y2 = drawinfo('Замаскирован ' .. pl:GetTeamName(), pl:GetTeamColor()) end
	local teamtbl = LocalPlayer():GetTeamTable()
	if teamtbl.medic or isadmin then x, y, w, h, y2 = drawinfo(pl:Health() .. ' ХП', color_red) end
	if (teamtbl.bmidealer or isadmin) and (pl:Armor() > 0) then x, y, w, h, y2 = drawinfo(pl:Armor() .. ' Броня', color_blue) end
	
	if (pl:GetNWBool("IsTalkingPhone")) then
		x, y, w, h, y2 = drawinfo('Разговаривает по телефону' .. string.rep( '.', CurTime()%4 ), Color(0,0,255))
	end
	
	if talkingplayers[pl] then
		if pl:IsMuted() then
			surface_SetMaterial(material_voice_muted)
			surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
			surface_DrawTexturedRect(-64, y2 - 32, 128, 128)
		else
			surface_SetMaterial(material_mic)
			surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
			surface_DrawTexturedRect(-128, y2 - 138, 256, 256)
		end
	elseif pl:IsTyping() then
		if pl:IsMuted() then
			surface_SetMaterial(material_chat_muted)
			surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
			surface_DrawTexturedRect(-64, y2 - 32, 128, 128)
		else
			surface_SetMaterial(material_typing)
			surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
			surface_DrawTexturedRect(-128, y2 - 64, 256, 256)
		end
	elseif org ~= nil then
		surface_SetMaterial(rp.orgs.GetBanner(pl))
		surface_SetDrawColor(255,255,255)
		surface_DrawTexturedRect(-128, y2 - 128, 256, 256)
	end
	cam_End3D2D()
end

function GM:PostDrawTranslucentRenderables()
	if not IsValid(LocalPlayer()) then return end
	local LP = LocalPlayer()
	surface_SetFont('ui.door')
	for k, v in ipairs(players) do
		if IsValid(v) then self:DrawPlayerInfo(v) end
	end
end