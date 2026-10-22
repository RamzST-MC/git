local PANEL = {}

function PANEL:Init()
	self.Collapsed = false

	self.Header = ui.Create('ui_button', self)
	self.Header:SetDisabled(true)
	self.Header.Paint = function(s, w, h)
		derma.SkinHook("Paint", "Button", s, w, h)

		if s:IsHovered() or self.CollapseBtn:IsHovered() then
			draw.RoundedBox(5, 0, 0, w, h, ui.col.Hover)
		end
	end
	self.Header.OnMousePressed = function(s, key)
		if (key == MOUSE_LEFT) then
			self:Collapse(not self:IsCollapsed())
		end
	end

	self.CollapseBtn = ui.Create('ui_button', self)
	self.CollapseBtn:SetText(utf8.char(0xf0aa))
	self.CollapseBtn:SetToolTip('Collapse')
	self.CollapseBtn:SetFont('ForkAwesome')
	self.CollapseBtn:SetTextColor(ui.col.Green)
	self.CollapseBtn.Paint = function() end
	self.CollapseBtn.DoClick = function()
		self:Collapse(not self:IsCollapsed())
	end

	self.Container = ui.Create('DPanel', self)
end

function PANEL:SetTall(h)
	self.OriginalTall = h + ui.SpacerHeight
	self.BaseClass.SetTall(self, self.OriginalTall)
end

function PANEL:SetText(text)
	self.Header:SetText(text)
end

function PANEL:AddItem(item)
	item:SetParent(self.Container)
end

function PANEL:Collapse(collapsed, noAnim)
	self.Collapsed = collapsed

	local targetH = collapsed and ui.SpacerHeight or self.OriginalTall
	if noAnim then
		self.BaseClass.SetTall(self, targetH)
	else
		self.TargetHeight = targetH
	end

	self.CollapseBtn:SetTextColor(collapsed and ui.col.White or ui.col.Green)
	self.CollapseBtn:SetToolTip(collapsed and 'Развернуть' or 'Свернуть')
	self.CollapseBtn:SetText(collapsed and utf8.char(0xf0ab) or utf8.char(0xf0aa))
	self.CollapseBtn:SetFont('ForkAwesome')
end

function PANEL:IsCollapsed()
	return self.Collapsed
end

function PANEL:OnCollapsing()

end

function PANEL:Think()
	if self.TargetHeight and (self:GetTall() ~= self.TargetHeight) then
		local tall = self:GetTall()
		local mul = tall > self.TargetHeight and -1 or 1

		tall = tall + FrameTime() * (tall - self.TargetHeight * -mul) * 8 * mul
		if (math.abs(tall - self.TargetHeight) < 1) then
			tall = self.TargetHeight

			self.TargetHeight = nil
		end

		self.BaseClass.SetTall(self, tall)
		self.OnCollapsing(self)
	end
end

function PANEL:PerformLayout(w, h)
	self.Header:SetPos(0, 0)
	self.Header:SetSize(w, ui.SpacerHeight)

	self.Container:SetPos(0, ui.SpacerHeight)
	self.Container:SetSize(w, h - ui.SpacerHeight)

	self.CollapseBtn:SetPos(w - ui.SpacerHeight, 0)
	self.CollapseBtn:SetSize(ui.SpacerHeight, ui.SpacerHeight)
end

vgui.Register('ui_collapsible_section', PANEL, 'DPanel')
