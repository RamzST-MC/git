local PANEL = {}



function PANEL:Init()

	self.Model = ui.Create('rp_modelicon', self)

	self.Model:Dock(LEFT)

	self.Model:DockMargin(2, 2, 0, 2)

	function self.Model:Paint(w, h)

		draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)

	end



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



function PANEL:SetPlayer(pl)

	self.Player = pl

	self.Model:SetModel(pl:GetModel(), pl:GetSkin())

	self.Name:SetText(pl:Name())

	self:SetColor(pl:GetJobColor())

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

	self.Model:SetSize(h - 4, h - 4)

	self.Info:SizeToContents()

	self.Info:SizeToContents()

end



function PANEL:ShouldDraw()

	if (not IsValid(self.Player)) then

		self:Remove()

		return false

	end



	return self.Player:Alive()

end



function PANEL:Update()

	if (not IsValid(self.Player)) then

		self:Remove()

		return

	end



	self.Info:SetVisible(self.Info:GetText() ~= '')



	self:SetPlayer(self.Player)

end



function PANEL:Paint(w, h)

	draw.RoundedBox(5, 0, 0, w, h, self.ColorSecondary)

end



vgui.Register('rp_hud_player', PANEL, 'rp_hud_base')