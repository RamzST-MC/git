local fr
net('rp.CasinoOwner',function()
	local ent = net.ReadEntity()
	if (IsValid(fr)) then fr:Remove() end

	local w, h = 320, 160
	fr = ui.Create('ui_frame', function(self)
		self:SetTitle(ent.PrintName)
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
		self.Think = function()
			if (not IsValid(ent)) or (ent:GetPos():Distance(LocalPlayer():GetPos()) >= 80) then
				fr:Close()
			end
		end
	end)

	local x, y = fr:GetDockPos()

	ui.Create('rp_entity_priceset', function(self, p)
		self:SetEntity(ent)
		self:SetPos(p:GetDockPos())
		self:SetWide(w - 10)
	end, fr)

	local btnDisable = ui.Create('ui_button', function(self, p)
		self:SetPos(x, y + 89)
		self:SetSize(w - 10, 30)
		self.Think = function()
			if (not IsValid(ent)) then return end

			if (ent:GetInService()) then
				self:SetText('Выключить')
			else
				self:SetText('Включить')
			end
		end
		self.DoClick = function()
			RunConsoleCommand('say','/setmachineservice')
		end
	end, fr)
end)

local PANEL = {}

function PANEL:Init()
	self.Label = ui.Create('DLabel', function(self, p)
		self:SetFont('ui.18')
		self:SetColor(ui.col.ButtonText)
		self:SetText('Цена: ')
	end, self)
	self.PriceInput = ui.Create('DTextEntry', self)
	self.SetPrice = ui.Create('ui_button', self)
	self.SetPrice:SetText('Установить цену')
	self.SetPrice.Think = function(s)
		if (not IsValid(self.Entity)) then return end
		local value = tonumber(self.PriceInput:GetValue())
		if (value == nil) then
			s:SetDisabled(true)
			s:SetText('Неверная цена!')
		elseif (value < self.Entity.MinPrice) then
			s:SetDisabled(true)
			s:SetText('Слишком низкая цена')
		elseif (value > self.Entity.MaxPrice) then
			s:SetDisabled(true)
			s:SetText('Слишком высокая цена')
		elseif (self.Entity:Getprice() == value) then
			s:SetDisabled(true)
			s:SetText('Выберите новую цену')
		else
			s:SetDisabled(false)
			s:SetText('Установить цену')
		end
	end
	self.SetPrice.DoClick = function()
		RunConsoleCommand('say','/setprice ' .. self.PriceInput:GetValue())
	end

	self:SetTall(85)
end

function PANEL:PerformLayout(w, h)
	self.Label:SetPos(0, 0)
	self.Label:SizeToContents()

	self.PriceInput:SetPos(0, 20)
	self.PriceInput:SetSize(w, 30)

	self.SetPrice:SetPos(0, 55)
	self.SetPrice:SetSize(w, 30)
end

function PANEL:Paint()
end

function PANEL:SetEntity(ent)
	self.Entity = ent
	self.PriceInput:SetText(ent:Getprice())
end

vgui.Register('rp_entity_priceset', PANEL, 'Panel')