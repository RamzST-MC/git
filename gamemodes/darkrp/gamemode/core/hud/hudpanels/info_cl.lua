local PANEL = {}



function PANEL:Init()

	self.Name = ui.Create('DLabel', self)

	self.Name:Dock(FILL)

	self.Name:DockMargin(5, 5, 5, 5)

	self.Name:SetFont('ui.18')

	self.Name:SetTextColor(ui.col.White)

	--self.Name.PaintOver = function(s, w, h) draw.Box(0, 0, w, h, ui.col.Red) end





	self.Info = ui.Create('DLabel', self)

	self.Info:Dock(RIGHT)

	self.Info:DockMargin(5, 5, 5, 5)

	self.Info:SetFont('ui.18')

	self.Info:SetTextColor(ui.col.White)

	self.Info:SetText('')

	--self.Info.PaintOver = function(s, w, h) draw.Box(0, 0, w, h, ui.col.Red) end



	self:SetTall(34)

end



function PANEL:SetName(name)

	self.Name:SetText(name)

end



function PANEL:SetInfo(info)

	self.Info:SetText(info)

end



function PANEL:GetContentSize()

	local nameW, nameH = self.Name:GetContentSize()

	local infoW, infoH = self.Info:GetContentSize()

	return 34 + nameW + infoW + 20, self:GetTall()

end



function PANEL:PerformLayout(w, h)

	self.Info:SizeToContents()

	self.Info:SizeToContents()

end





function PANEL:Update()



end



function PANEL:Paint(w, h)

	draw.RoundedBox(5, 0, 0, w, h, self.ColorSecondary)

end



vgui.Register('rp_hud_info', PANEL, 'rp_hud_base')