-------------------------------------------------
-- Логотип "Majester Project" + время (правый верхний угол)
--
-- Эмблема нарисована кодом (картинки не нужны). Под названием - время и дата.
-- Настройки в меню "Худ":
--   enable_logo  - логотип
--   enable_clock - время под логотипом (настройка уже была, но часы нигде не рисовались)
-------------------------------------------------

if cvar and cvar.Register then
	cvar.Register 'enable_logo'
		:SetDefault(true, true)
		:AddMetadata('Catagory', 'Худ')
		:AddMetadata('Menu', 'Отображение логотипа')
end

local function cvarOn(name)
	if not (cvar and cvar.GetValue) then return true end
	local v = cvar.GetValue(name)
	return (v == nil) or (v == true) or (v == 1)
end

-- Цвета
local COL_RED 		= Color(235, 45, 55)
local COL_WHITE 	= Color(255, 255, 255)
local COL_GRAY 		= Color(185, 185, 198, 230)
local COL_SHADOW 	= Color(0, 0, 0, 170)
local COL_DARK 		= Color(16, 16, 22, 245)

-- Положение: правый верхний угол. Отступ справа такой же, как у панели "Законы Города" (она ниже, с 97 px),
-- поэтому логотип стоит выше и с ней не пересекается.
local MARGIN_RIGHT 	= 10
local POS_Y 		= 10
local ICON_SIZE 	= 64

-- Размер всего логотипа: 1 = крупно (как раньше), 0.7 = компактно. Меняйте только это число.
local LOGO_SCALE 	= 0.68

-- ближайший существующий шрифт ui.NN / ui.NNb (в badmin созданы размеры 12-85)
local function uiFont(size, bold)
	size = math.Clamp(math.Round(size), 12, 85)
	return 'ui.' .. size .. (bold and 'b' or '')
end

-- многоугольники для surface.DrawPoly (вершины по часовой стрелке)
local function poly(points, col)
	surface.SetDrawColor(col)
	draw.NoTexture()
	surface.DrawPoly(points)
end

local function circle(cx, cy, r, steps)
	local pts = {}
	for i = 0, steps - 1 do
		local a = math.rad(i * 360 / steps)
		pts[#pts + 1] = {x = cx + math.cos(a) * r, y = cy + math.sin(a) * r}
	end
	return pts
end

local function shadowText(text, font, x, y, col, sh)
	draw.SimpleText(text, font, x + sh, y + sh, COL_SHADOW, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(text, font, x, y, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

-- Эмблема: красное кольцо и белая корона
local function drawEmblem(cx, cy, size)
	local k = size / 64

	poly(circle(cx, cy, 32 * k, 44), COL_RED)
	poly(circle(cx, cy, 28.5 * k, 44), COL_DARK)

	-- корона = основание + три зубца (каждый кусок выпуклый)
	local function P(px, py) return {x = cx + px * k, y = cy + (py + 1) * k} end

	poly({P(-18, 5), P(18, 5), P(18, 13), P(-18, 13)}, COL_WHITE) -- основание
	poly({P(-18, 5), P(-18, -9), P(-7, 5)}, COL_WHITE) 			-- левый зубец
	poly({P(-9, 5), P(0, -13), P(9, 5)}, COL_WHITE) 				-- средний зубец
	poly({P(7, 5), P(18, -9), P(18, 5)}, COL_WHITE) 				-- правый зубец

	-- красная полоса на основании и камни на вершинах
	poly({P(-18, 8), P(18, 8), P(18, 10.5), P(-18, 10.5)}, COL_RED)
	poly(circle(cx - 18 * k, cy + (-9 + 1) * k, 2.6 * k, 14), COL_RED)
	poly(circle(cx, cy + (-13 + 1) * k, 3.2 * k, 14), COL_RED)
	poly(circle(cx + 18 * k, cy + (-9 + 1) * k, 2.6 * k, 14), COL_RED)
end

hook.Add('HUDPaint', 'Majester.Logo', function()
	local lp = LocalPlayer()
	if not IsValid(lp) then return end
	if not cvarOn('enable_hud') or not cvarOn('enable_logo') then return end

	local showClock = cvarOn('enable_clock')
	local screenScale = math.max(1, ScrH() / 1080)
	local scale 	= screenScale * LOGO_SCALE
	local size 		= math.floor(ICON_SIZE * scale)
	local gap 		= math.floor(14 * scale)
	local sh 		= math.max(1, math.floor(2 * scale))

	local fTitle, fTime, fDate = uiFont(34 * scale, true), uiFont(23 * scale), uiFont(17 * scale)
	local time, date = os.date('%H:%M:%S'), os.date('%d.%m.%Y')

	-- размеры текста (нужны, чтобы прижать весь блок к правому краю)
	surface.SetFont(fTitle)
	local wMaj, hTitle 	= surface.GetTextSize('Majester')
	local wSpace 		= surface.GetTextSize(' ')
	local wProj 		= surface.GetTextSize('Project')

	surface.SetFont(fTime)
	local wTime, hTime 	= surface.GetTextSize(time)
	surface.SetFont(fDate)
	local wDate, hDate 	= surface.GetTextSize(date)

	local dateGap 	= math.floor(12 * scale)
	local textW 	= wMaj + wSpace + wProj
	if showClock then
		textW = math.max(textW, 2 + wTime + dateGap + wDate)
	end

	-- блок прижат к правому краю
	local x = ScrW() - MARGIN_RIGHT - (size + gap + textW)
	local y = math.floor(POS_Y * screenScale)

	-- эмблема
	drawEmblem(x + size / 2, y + size / 2, size)

	-- название: Majester (красным) + Project (белым)
	local tx = x + size + gap
	local ty = y + math.floor(size * 0.5 - hTitle * 0.5) - (showClock and math.floor(12 * scale) or 0)

	shadowText('Majester', fTitle, tx, ty, COL_RED, sh)
	shadowText('Project', fTitle, tx + wMaj + wSpace, ty, COL_WHITE, sh)

	-- время и дата под названием
	if showClock then
		local ly = ty + hTitle - math.floor(2 * scale)

		shadowText(time, fTime, tx + 2, ly, COL_WHITE, sh)
		shadowText(date, fDate, tx + 2 + wTime + dateGap, ly + math.floor((hTime - hDate) * 0.5), COL_GRAY, sh)
	end
end)