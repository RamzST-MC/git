include('shared.lua')

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

function ENT:Draw()
	self:DrawModel()
	if self:GetPos():Distance( LocalPlayer():GetPos() ) > 250 then return end
	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -180)

	cam.Start3D2D(pos, ang, 0.05)
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(Material('sup/entities/bail.png'))
		surface.DrawTexturedRect(-64, -600, 128, 128)

		draw.SimpleTextOutlined('Выкуп', '3d2d', 0, -350, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
end

net.Receive('rp.OpenBail', function()
	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(500, 400)
		self:SetTitle('')
		self:Center()
		self:MakePopup()

		self.PaintOver = function(self, w, h)
			draw.SimpleText('Внести залог', 'ui.20', w / 2, 12.5, color_white, 1, 1)
		end
	end)

	local list = ui.Create('ui_listview', function(self, p)
		local x, y = p:GetDockPos()
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - y - 35)
	end, fr)

	local tbl 	= {}
	local count = net.ReadUInt(8)

	for i=1, count do 
		local pl 	= net.ReadEntity()
		local price = net.ReadUInt(17)
		if IsValid(pl) then
			list:AddPlayer(pl).Info = {Name = pl:Name(), Price = (LocalPlayer():IsMayor() and 0 or price), SteamID = pl:SteamID()}
		end
	end

	if (count == 0) then
		list:AddSpacer('Нет заключенных!')
	end

	local btn = ui.Create('ui_button', function(self, p)
		self:SetText('Список Заключенных')
		self:SetPos(5, p:GetTall() - 30)
		self:SetSize(p:GetWide() - 10, 25)

		function self:Think()
			if (list:GetSelected() ~= nil) then
				local name 	= list:GetSelected().Info.Name
				local price = list:GetSelected().Info.Price

				if LocalPlayer():IsMayor() or (LocalPlayer():GetMoney() >= price) then
					self:SetText('Заплатить залог за ' .. name .. ' (' .. rp.FormatMoney(price) .. ')')
					self:SetDisabled(false)
				else
					self:SetText('Недостаточно средств!')
					self:SetDisabled(true)
				end
			else
				self:SetText('Заключенный не выбран')
				self:SetDisabled(true)
			end
		end

		function self:DoClick()
			cmd.Run('bail', list:GetSelected().Info.Name)
			fr:Close()
		end
	end, fr)
end)
