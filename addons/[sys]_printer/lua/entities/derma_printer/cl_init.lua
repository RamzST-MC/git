include("shared.lua")
include("autorun/client/cl_settings.lua")
local config = DermaConfig
surface.CreateFont("MainText", {
	font = "Montserrat Medium",
	size = 30,
	antialias = true,
	extended = true,
})

surface.CreateFont("SmallText", {
	font = "Montserrat Medium",
	size = 20,
	antialias = true,
	extended = true,
})

surface.CreateFont("printer.3d.Update", {
	font = "Montserrat Medium",
	size = 32,
	antialias = true,
	extended = true,
})

surface.CreateFont("printer.3d.Freeze", {
	font = "Montserrat Medium",
	size = 28,
	antialias = true,
	extended = true,
})

surface.CreateFont("printer.3d.Temp", {
	font = "Montserrat Medium",
	size = 50,
	antialias = true,
	extended = true,
})

surface.CreateFont("printer.3d.Owner", {
	font = "Montserrat Medium",
	size = 45,
	antialias = true,
	extended = true,
})

function ENT:Initialize()
	self.sound = CreateSound(self, Sound("ambient/tones/industrial1_loop.wav"))
	self.sound:SetSoundLevel(52)
	self.sound:PlayEx(1, 100)
	self.TempColor = Color(255, 255, 255)
	self.spin = 0
	self.spin2 = 0
end

function ENT:Think()
	local owner = self:Getowning_ent()
	self.owner = (IsValid(owner) and owner:Nick()) or "unknown"
	if self:Gettoggle() == true then
		if self:GetCharge() > 0 then self.sound:PlayEx(1, 100) end
	else
		if self.sound then self.sound:Stop() end
	end

	self.Angle = self:GetAngles()
	self.Pos = self:GetPos()
	--size matrix--
	local mat = Matrix()
	mat:Scale(Vector(0.1, 0.1, 0.1))
	local matC = Matrix()
	matC:Scale(Vector(0.18, 0.18, 0.18))
end

function ENT:OnRemove()
	if self.sound then self.sound:Stop() end
end

local GreenColor = Color(146, 255, 36)
local GreenColor2 = Color(209, 255, 79)
local YellowColor = Color(252, 255, 85)
local RedColor = Color(255, 85, 85)
local ColorBackground = Color(95, 95, 95)
local ColorTemp = GreenColor
local MaxTemp = 180
local UpText = 'Улучшения - '
local FreezeText = 'Охлаждение - '
local OnText = 'Включен'
local OffText = 'Выключен'
local MetUnpdate = Material("money_printer/update.png", "noclamp smooth")
local MetFreeze = Material("money_printer/freeze.png", "noclamp smooth")
local MetTemp = Material("money_printer/temp_pinter.png", "noclamp smooth")
local mat3 = Material("PhoenixPrinters/PrinterOn.png", "noclamp smooth")
local TitleBackgroundColor = Color(39,39,39)
function ENT:Draw()
	--color vars tanslated into local vars--
	local MR = self:GetMainColorR()
	local MG = self:GetMainColorG()
	local MB = self:GetMainColorB()
	local BR = self:GetBgColorR()
	local BG = self:GetBgColorG()
	local BB = self:GetBgColorB()
	--temperature color change--
	if self:GetPTemp() > config.YellowGauge then self.TempColor = YellowColor end
	if self:GetPTemp() > config.RedGauge then self.TempColor = RedColor end
	if self:GetPTemp() < config.WhiteGauge then self.TempColor = color_white end
	--charge value--
	local Charge = self:GetCharge()
	Charge = Charge * 2
	if Charge < MaxTemp * 0.25 then
		ColorTemp = RedColor
	elseif Charge < MaxTemp * 0.5 then
		ColorTemp = YellowColor
	elseif Charge < MaxTemp * 0.75 then
		ColorTemp = GreenColor2
	else
		ColorTemp = GreenColor
	end

	self.Angle = self:GetAngles()
	self.Pos = self:GetPos()
	--Cam3D2D Panal top and display--
	self.Angle:RotateAroundAxis(self.Angle:Up(), 90)
	if EyePos():Distance(self.Entity:GetPos()) < 1000 then
		self.Entity:DrawModel()
		cam.Start3D2D(self.Pos + self.Angle:Up() * 10.4, self.Angle, 0.05)
		if !self:GetIsProtected() then
			--draw.RoundedBox(16, -216, -214, 432, 432, CurTime() % 2 < 1 and ui.col.DarkRed:Copy() or ui.col.FlatBlack:Copy())
			draw.SimpleText('Защита выключена', 'printer.3d.Update', 0, 0, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(16, -216, -214, 432, 432, Color(BR, BG, BB))
			draw.RoundedBox(24, -200, -196, 400, 305, Color(MR, MG, MB))
			draw.RoundedBox(24, -200, 119, 400, 82, Color(MR, MG, MB))
			draw.RoundedBoxEx(24, -200, -196, Charge, 60, ColorTemp, true, true, false, false)
			draw.RoundedBox(24, -190, -126, 275, 60, ColorBackground)
			draw.RoundedBox(24, -190, -56, 275, 60, ColorBackground)
			draw.RoundedBox(24, 95, -126, 95, 100, ColorBackground)
			draw.DrawText(UpText .. self:GetUpgradelvl(), "printer.3d.Update", -125, -112, color_white, 0)
			draw.DrawText(FreezeText .. self:GetCoolinglvl(), "printer.3d.Freeze", -125, -40, color_white, 0)
			draw.DrawText(math.floor(self:GetPTemp()), "printer.3d.Temp", 142, -77, self.TempColor, 1)
			draw.DrawText(self.owner:sub(1, 21), "printer.3d.Owner", 0, 32, color_white, 1)
			if self:Gettoggle() then
				draw.DrawText(OnText, "printer.3d.Owner", 0, 135, color_white, 1)
			else
				draw.DrawText(OffText, "printer.3d.Owner", 0, 135, color_white, 1)
			end

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(MetUnpdate)
			surface.DrawTexturedRect(-180, -116, 40, 40)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(MetFreeze)
			surface.DrawTexturedRect(-180, -46, 40, 40)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(MetTemp)
			surface.DrawTexturedRect(115, -120, 48, 48)
		end
		cam.End3D2D()
		self.Angle:RotateAroundAxis(self.Angle:Forward(), 90)
		cam.Start3D2D(self.Pos + self.Angle:Up() * 12.2, self.Angle, 0.05)
			draw.DrawText(rp.FormatMoney(self:GetMoney()), "printer.3d.Update", 0, -115, Color(255, 255, 255), 1)
		cam.End3D2D()
	end
end

local RetryText = 'Перезарядка'
local AddUpText = 'Улучшить'
local AddFreezeText = 'Охлаждение'
local TakeMoneyText = 'Снять'
local destruct = 'Защита от поломки'
local sw, sh = ScrW(), ScrH()

local txt1 = 'Derma'
local txt2 = 'Printers'

net.Receive("ActiveP",function()
	local ent = net.ReadEntity()
	local sw, sh = ScrW(), ScrH()

	fr = ui.Create('ui_frame', function(self)
		self:SetSize(405, 540)
		self:Center()
		self:MakePopup()
		self:SetTitle('')

		self.PaintOver = function(s, w, h)
			draw.SimpleText(txt1, 'ui.20', 12, 30, Color(255, 255, 255), 0, 1)
			draw.RoundedBox(4, 12 + surface.TextSize(txt1, 'ui.20') + 1.5, 20, surface.TextSize(txt2, 'ui.20') + 3, 20, ui.col.SUP:Copy())
			draw.SimpleText(txt2, 'ui.20', 12 + surface.TextSize(txt1, 'ui.20') + 2.5, 30, Color(255, 255, 255), 0, 1)
			-- print(sh / 2)
			if !IsValid(ent) then return end
			local Charge = ent:GetCharge()

			Charge = (Charge / 200) * 290
			-- print(Charge)

			draw.RoundedBox(8, 85, fr:GetTall() - 80, 300, 65, Color(39,39,39))
			draw.RoundedBox(8, 90, fr:GetTall() - 75, Charge, 55, ui.col.SUP:Copy())
			draw.SimpleText(IsValid(ent:Getowning_ent()) and ent:Getowning_ent():Name() or "Unknown", 'ui.20', 225, fr:GetTall()-45, color_white, 1, 1)
			draw.SimpleText(math.Round(ent:GetPTemp()).."°C", 'ui.20', 95, fr:GetTall()-45, color_white, 0, 1)
		end
	end)

	local govno = Material("PhoenixPrinters/PrinterOn.png", "noclamp smooth")
	local col = Color(0, 0, 0)

	fr.ToggleOnOff = ui.Create('ui_button', function(self)
		self:SetSize(65, 65)
		self:SetPos(15, fr:GetTall() - self:GetTall() - 15)
		self:SetText('')

		self.DoClick = function()
			net.Start("Togglep")
			net.WriteEntity(ent)
			net.SendToServer()
		end

		self.PaintOver = function(s, w, h)
			if ent:Gettoggle() then
				self.tog = Lerp(FrameTime() * 3, self.tog or 0, 1)
			else
				self.tog = Lerp(FrameTime() * 3, self.tog or 0, 0)
			end

			col:Lerp(self.tog, Color(255, 0, 0), color_white)

			draw.Material(7.5, 7.5, 50, 50, govno, col)
		end
	end, fr)

	fr.Recharge = ui.Create('ui_button', function(self)
		self:SetSize(375, 65)
		self:SetPos(15, 70)
		self:SetText('')

		self.Hover = 0
		self.PaintOver = function(self, w, h)
			if !IsValid(ent) then return end
			if self:IsHovered() == true then
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
			end

			draw.SimpleText( 'Перезарядить', "ui.20", w / 2, h / 2 - self.Hover / 5, color_white, 1, 1)
			draw.SimpleText( rp.FormatMoney(ent:GetRechargeprice()), "ui.20", w / 2, h / 2 - (self.Hover-255) / 5, color_white, 1, 1)
		end

		self.DoClick = function()
			net.Start("RechargeP")
				net.WriteEntity(ent)
			net.SendToServer()
		end
	end, fr)

	fr.Cooling = ui.Create('ui_button', function(self)
		self:SetSize(375, 65)
		self:SetPos(15, 145)
		self:SetText('')

		self.Hover = 0
		self.PaintOver = function(self, w, h)
			if !IsValid(ent) then return end
			if self:IsHovered() == true then
				self.Hover = Lerp(FrameTime()*5, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime()*5, self.Hover, 0)
			end

			--cooling display price ajustment--
			if ent:GetCoolinglvl() == 4 then
				Coolingprice = 'N/A'
			end
			if ent:GetCoolinglvl() == 3 then
				Coolingprice  = ent:GetCooling3price()
			end
			if ent:GetCoolinglvl() == 2 then
				Coolingprice  = ent:GetCooling2price()
			end
			if ent:GetCoolinglvl() == 1 then
				Coolingprice = ent:GetCooling1price()
			end

			draw.SimpleText( 'Охлаждение', "ui.20", w/2, h/2-self.Hover/5, color_white, 1, 1)
			draw.SimpleText( rp.FormatMoney(Coolingprice), "ui.20", w/2, h/2-(self.Hover-255)/5, color_white, 1, 1)
		end

		self.DoClick = function()
			net.Start("CoolingP")
				net.WriteEntity(ent)
			net.SendToServer()
		end
	end, fr)

	fr.Upg = ui.Create('ui_button', function(self)
		self:SetSize(375, 65)
		self:SetPos(15, 225)
		self:SetText('')

		self.Hover = 0
		self.PaintOver = function(self, w, h)
			if !IsValid(ent) then return end
			if self:IsHovered() == true then
				self.Hover = Lerp(FrameTime()*5, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime()*5, self.Hover, 0)
			end

			if ent:GetUpgradelvl() == 4 then
				lvlprice = 'N/A'
			end
			if ent:GetUpgradelvl() == 3 then
				lvlprice = ent:Getlvl4price()
			end
			if ent:GetUpgradelvl() == 2 then
				lvlprice = ent:Getlvl3price()
			end
			if ent:GetUpgradelvl() == 1 then
				lvlprice = ent:Getlvl2price()
			end

			draw.SimpleText( 'Улучшение', "ui.20", w/2, h/2-self.Hover/5, color_white, 1, 1)
			draw.SimpleText( rp.FormatMoney(lvlprice), "ui.20", w/2, h/2-(self.Hover-255)/5, color_white, 1, 1)
		end

		self.DoClick = function()
			net.Start("UpgradeP")
				net.WriteEntity(ent)
			net.SendToServer()
		end
	end, fr)

	fr.Take = ui.Create('ui_button', function(self)
		self:SetSize(375, 65)
		self:SetPos(15, 305)
		self:SetText('')

		self.Hover = 0
		self.PaintOver = function(self, w, h)
			if !IsValid(ent) then return end
			if self:IsHovered() == true then
				self.Hover = Lerp(FrameTime()*5, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime()*5, self.Hover, 0)
			end

			draw.SimpleText( 'Снять', "ui.20", w/2, h/2-self.Hover/5, color_white, 1, 1)
			draw.SimpleText( rp.FormatMoney(ent:GetMoney()), "ui.20", w/2, h/2-(self.Hover-255)/5, color_white, 1, 1)
		end

		self.DoClick = function()
			net.Start("withdrawp")
				net.WriteEntity(ent)
			net.SendToServer()
		end
	end, fr)

	fr.Protect = ui.Create('ui_button', function(self)
		self:SetSize(375, 65)
		self:SetPos(15, 385)
		self:SetText('')

		self.Hover = 0
		self.PaintOver = function(self, w, h)
			if !IsValid(ent) then return end
			if self:IsHovered() == true then
				self.Hover = Lerp(FrameTime()*5, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime()*5, self.Hover, 0)
			end

			draw.SimpleText('Защита', "ui.20", w/2, h/2-self.Hover/5, color_white, 1, 1)
			draw.SimpleText(ent:GetIsProtected() and 'Включена' or 'Выключена', "ui.20", w/2, h/2-(self.Hover-255)/5, color_white, 1, 1)
		end

		self.DoClick = function()
			net.Start("rp.Destruct")
				net.WriteEntity(ent)
			net.SendToServer()
		end
	end, fr)
end)