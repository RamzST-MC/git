local PANEL = {}



function PANEL:Init()

	self.BaseClass.Init(self)



	self.Progress = 1



	self.Title = ui.Create('DLabel', self)

	self.Title:SetFont('ui.18')

	self.Title:SetTextColor(ui.col.White)

	self.Title:Dock(FILL)

	self.Title:DockMargin(39, 0, 0, 0)



	self:SetSize(34, 34)

end



function PANEL:GetProgress()

	return 1

end



function PANEL:Update()

	self.BaseClass.Update(self)



	if (not self.GetString) then // GetText, GetValue were taken. fuck you garry

		return

	end



	local value = self:GetString()



	if (self.Value == value) then

		return

	end



	self.Title:SetText(value)

	self.Title:SizeToContents()



	self:SetWide(self.Title:GetWide() + 44)



	self.Value = value

	self.Progress = self:GetProgress()

end



function PANEL:Paint(w, h)

	draw.Blur(self)



	if self.Value then

		draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)

		draw.RoundedBoxEx(5, h, 0, (w - h) * self.Progress, h, self.ColorSecondary, false, true, false, true)



		draw.RoundedBoxEx(5, 0, 0, h, h, self.ColorPrimary, true, false, true, false)



		surface.SetDrawColor(255, 255, 255)

		surface.SetMaterial(self.Material)

		surface.DrawTexturedRect(5, 5, 24, 24)

	else

		draw.RoundedBox(5, 0, 0, h, h, self.ColorPrimary)



		surface.SetDrawColor(255, 255, 255)

		surface.SetMaterial(self.Material)

		surface.DrawTexturedRect(5, 5, 24, 24)

	end

end



vgui.Register('rp_hud_iconbox', PANEL, 'rp_hud_base')