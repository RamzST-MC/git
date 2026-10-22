include('shared.lua')
local function SafeGetTeamPlayers(teamID)
	if team.GetPlayers and team.Iterator then
		return team.GetPlayers(teamID)
	end
	local result = {}
	for _, ply in ipairs(player.GetAll()) do
		if ply:Team() == teamID then result[#result + 1] = ply end
	end
	return result
end


--[[ basic 3d2d interaction shit ]]
local origin
local scale
local angle
local normal

local ang0 = Angle(0, 0, 0)
local function getCursorPos()
	if (!origin) then return end

	local p = util.IntersectRayWithPlane(LocalPlayer():EyePos(), LocalPlayer():GetAimVector(), origin, normal)

	if (!p) then return -1, -1 end
	if (WorldToLocal(LocalPlayer():GetShootPos(), ang0, origin, angle).z < 0) then return -1, -1 end

	local pos = WorldToLocal(p, ang0, origin, angle)
	return pos.x / scale, -pos.y / scale
end

local offset = Vector(0, -10.88, 24.555)
local w, h = 1598, 1208

local buttons = {
	{ -- Laws
		x = 0,
		y = h * 0.25,
		w = w * 0.5,
		h = h * 0.25,
		text = "Изменить законы",
		func = 'laws'
	},
	{ -- Lottery
		x = w * 0.5,
		y = h * 0.25,
		w = w * 0.5,
		h = h * 0.25,
		text = "Лотерея",
		func = function()
			local recurse

			recurse = function(tried)
				ui.StringRequest("Лотерея", "На сколько она будет?" .. (tried and " Введите число." or ""), 1000, function(val)
					if (val and tonumber(val) and tostring(tonumber(val)) == val) then
						cmd.Run('lotto', tonumber(val))
					else
						recurse(true)
					end
				end)
			end

			recurse()
		end,
		cooldown = function()
			local cd = (nw.GetGlobal('nextLotto') or 0) - CurTime()
			if (cd > 0) then
				return cd / rp.cfg.LottoCooldown
			end
		end
	},
	{ -- Toggle Lockdown
		x = 0,
		y = h * 0.5,
		w = w * 0.5,
		h = h * 0.25,
		func = function()
			if nw.GetGlobal('lockdown') then
				cmd.Run('unlockdown')
				return
			end
			ui.StringRequest("Комендантский час", "Введите причину", '', function(val)
				cmd.Run('lockdown', val)
			end)
		end,
		getText = function()
			if nw.GetGlobal('lockdown') then
				return "Выключить КЧ"
			else
				return "Включить КЧ"
			end
		end
	},
	{ -- Release Prisoner
		x = w * 0.5,
		y = h * 0.5,
		w = w * 0.5,
		h = h * 0.25,
		text = "Освободить заключенного",
		func = function()
			net.Start('rp.OpenBailMer')
			net.SendToServer()
		end
	},
	{ -- Give license
		x = 0,
		y = h * 0.75,
		w = w,
		h = h * 0.25,
		text = "Выдать лицензию",
		func = function()
			cmd.Run('givelicense')
		end
	}
}

local hackerButtons = {
	{ -- Laws
		x = 0,
		y = h * 0.25,
		w = w,
		h = h * 0.25,
		text = "Clear Laws",
		func = function()
			cmd.Run 'resetlaws'
		end
	},
	{ -- Toggle Lockdown
		x = 0,
		y = h * 0.5,
		w = w,
		h = h * 0.25,
		func = function()
			if nw.GetGlobal('lockdown') then
				cmd.Run('unlockdown')
			end
		end,
		getText = function()
			return "Disable Lockdown"
		end
	},
	{ -- Release Prisoner
		x = 0,
		y = h * 0.75,
		w = w,
		h = h * 0.25,
		text = "Release Prisoner",
		func = 'bail'
	},
}


function ENT:Draw()
	self:DrawModel()

	if (not self:InDistance(125000)) then return end

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	origin = self:LocalToWorld(offset) - (self:GetForward() * -0.3)
	scale = 0.013
	angle = ang
	normal = ang:Up()

	cam.Start3D2D(origin, ang, scale)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, w, h)

		local mayor = SafeGetTeamPlayers(TEAM_MAYOR)[1]
		if IsValid(mayor) then
			draw.SimpleText(mayor:Name(), '3d2d', w * 0.5, 10, mayor:GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local chief = SafeGetTeamPlayers(TEAM_CHIEF)[1]
		if IsValid(chief) then
			draw.SimpleText(chief:Name(), '3d2d', w * 0.5, h * 0.1225, chief:GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local mx, my = getCursorPos()
		local txt

		local isHacker = self:GetHacker() == LocalPlayer()

		for k, v in ipairs(isHacker and hackerButtons or buttons) do
			local cd = v.cooldown and v.cooldown()
			if (cd) then
				surface.SetDrawColor(255, 50, 50, 15)
				surface.DrawRect(v.x, v.y, v.w * cd, v.h)
			end

			if (mx and mx > v.x and mx < v.x + v.w and my > v.y and my < v.y + v.h) then
				surface.SetDrawColor(200, 200, 200, 15)
				surface.DrawRect(v.x, v.y, v.w, v.h)
			end

			surface.SetDrawColor(rp.col.Outline)
			surface.DrawOutlinedRect(v.x, v.y, v.w, v.h)
			surface.DrawOutlinedRect(v.x + 1, v.y + 1, v.w - 2, v.h - 2)
			surface.DrawOutlinedRect(v.x + 2, v.y + 2, v.w - 4, v.h - 4)

			txt = v.getText and v.getText(self) or v.text

			local lines = string.Wrap('3d2d', txt, v.w)
			local w, h = 0, v.y + (v.h * (0.75 - (#lines * 0.25))) // only works for 2 lines
			for lineI, line in ipairs(lines) do
				local lineW, lineH = draw.SimpleText(line, '3d2d', v.x + (v.w * 0.5), h, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				h = h + lineH
			end

		end

		if ((not LocalPlayer():IsMayor()) and (not isHacker)) then
			surface.SetDrawColor(0, 0, 0, 252)
			surface.DrawRect(0, 0, w, h)
			draw.SimpleText('Доступ отклонен!', '3d2d', 800, 604, ui.col.Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(rp.col.White)
		else
			surface.SetDrawColor(rp.col.Red)
		end

		if (mx > 0 and mx < w and my > 0 and my < h) then
			surface.DrawLine(mx - 10, my, mx + 10, my)
			surface.DrawLine(mx, my - 10, mx, my + 10)
		end
	cam.End3D2D()
end

function ENT:PlayerUse()
	local isHacker = self:GetHacker() == LocalPlayer()

	if (LocalPlayer():IsMayor()) or (isHacker) then
		local mx, my = getCursorPos()

		for k, v in ipairs(isHacker and hackerButtons or buttons) do
			if (mx and mx > v.x and mx < v.x + v.w and my > v.y and my < v.y + v.h) then
				if (v.func) then
					if (isstring(v.func)) then
						cmd.Run(v.func)
					else
						v.func()
					end
				end

				break
			end
		end
	end
end

local mat_911 = Material 'sup/hud/911.png'

local mayor
local function removeEsp()
	hook.Remove('HUDPaint', 'rp.mayoresp.HUDPaint')
end

local function mayorEsp()
	if (not IsValid(mayor)) or (not mayor:IsMayor()) or (not LocalPlayer():Alive()) then
		removeEsp()
		return
	end

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(mat_911)

	local pos = mayor:EyePos()
	pos = pos:ToScreen()
	pos.y = pos.y + 100
	surface.DrawTexturedRect(pos.x- 15, pos.y - 40, 32, 32)
	draw.SimpleTextOutlined('Mayor', 'HudFont', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	draw.SimpleTextOutlined(mayor:Name(), 'HudFont', pos.x, pos.y + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
end


net('rp.HackMayorMachine', function()
	mayor = net.ReadPlayer()

	hook('HUDPaint', 'rp.mayoresp.HUDPaint', mayorEsp)

	timer.Simple(60, removeEsp)
end)