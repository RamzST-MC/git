dash.IncludeSH 'shared.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

local mat = Material("divergent/ui/hud/icons/leaderboard.png")

local ang = Angle(0, 90, 90)
function ENT:Draw()
	self:DrawModel()

	local bone = self:LookupBone('ValveBiped.Bip01_Head1')
	pos = self:GetBonePosition(bone) + complex_off

	ang.y = (LocalPlayer():EyeAngles().y - 90)

	local inView, dist = self:InDistance(150000)

	if (not inView) then return end

	local alpha = 255 - (dist/590)
	color_white.a = alpha
	color_black.a = alpha

	local x = math.sin(CurTime() * math.pi) * 30

	cam.Start3D2D(pos, ang, 0.03)
		draw.SimpleTextOutlined('Таблица лидеров', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-64, -230, 128, 128)
	cam.End3D2D()
end

net.Receive('rp.LeaderBoard', function()
	local tbl = net.ReadTable()

	local fr = vgui.Create('ui_frame')
	fr:SetSize(math.min(ScrW(), 400), math.min(ScrH(), 400))
	fr:MakePopup()
	fr:Center()
	fr:SetTitle('')

	local panelmani = vgui.Create('Panel', fr)
	panelmani:Dock(FILL)

	panelmani.Paint = function(_, w, h)
		draw.RoundedBox(6, 0, 0, w, h, Color(43, 43, 43))
	end

	local btn1 = vgui.Create('ui_button', panelmani)
	btn1:Dock(TOP)
	btn1:SetTall(30)
	btn1:SetText('')
	btn1.Paint = function(_, w, h)
		---draw.RoundedBox(8, 0, 0, w, h, Color(255, 215, 0))
		draw.SimpleTextOutlined('Таблица лидеров', 'ui.20', w / 2, h / 2, color_white, 1, 1, .1, color_black)
		draw.Material(5, 2.5, 25, 25, mat)
	end

	for k, v in ipairs(tbl) do
		if v.Money > 25000 then
			local btn = vgui.Create('ui_button', panelmani)
			btn:Dock(TOP)
			btn:DockMargin(0, .5, 0, 0)
			btn:SetTall(30)
			btn:SetText('')

			btn.Paint = function(self, w, h)
				if k == 1 then draw.RoundedBoxEx(5, 0, 0, w, h, Color(238, 202, 0), true, true, false, false) end
				if k == 2 then draw.RoundedBox(0, 0, 0, w, h, Color(169, 169, 169)) end
				if k == 3 then draw.RoundedBoxEx(5, 0, 0, w, h, Color(182, 62, 32), false, false, true, true) end
				draw.SimpleTextOutlined(v.Name .. ' - ' .. DarkRP.formatMoney(tonumber(v.Money)), 'ui.20', w / 2, h / 2, color_white, 1, 1, 1, color_black)
			end
		end
	end
end)