ui.SpacerHeight = 35
ui.ButtonHeight = 30

local SKIN 	= {
	PrintName 	= 'SUP',
	Author 	 	= 'aStonedPenguin'
}

local color_sup 			= ui.col.SUP:Copy()
local color_gradient 		= ui.col.Gradient:Copy()
local color_header 			= ui.col.Header:Copy()
local color_background 		= ui.col.Background:Copy()
local color_outline 		= ui.col.Outline:Copy()
local color_hover 			= ui.col.Hover:Copy()
local color_button 			= ui.col.Button:Copy()
local color_button_hover	= ui.col.ButtonHover:Copy()
local color_close 			= ui.col.Close:Copy()
local color_close_bg 		= ui.col.CloseBackground:Copy()
local color_close_hover 	= ui.col.CloseHovered:Copy()

local color_offwhite 		= ui.col.OffWhite:Copy()
local color_flat_black 		= ui.col.FlatBlack:Copy()
local color_black 			= ui.col.Black:Copy()
local color_white 			= ui.col.White:Copy()
local color_red 			= ui.col.Red:Copy()
local color_green 			= ui.col.Green:Copy()

local mat_grad = Material 'gui/gradient_down'
local mat_cecked = Material 'sup/ui/check.png'
local mat_uncecked = Material 'sup/ui/x.png'

-- Frames
function SKIN:PaintFrame(self, w, h)
	local x, y = self:LocalToScreen(0, 0)

	self.text = self.text or ''
    
	draw.DrawBlur(5, x, y, w, h, nil, color_background)
	draw.DrawBlur(4, x, y, w, 55, nil, color_header)

	draw.SimpleText(self.text, 'ui.20', 12, 30, Color(255, 255, 255), 0, 1)
end

function SKIN:PaintPanel(self, w, h)
	draw.RoundedBox(5, 0, 0, w, h, color_background)
end

function SKIN:PaintShadow() end


-- Buttons
function SKIN:PaintButton(self, w, h)
	if (not self.m_bBackground) then return end

	if self:GetDisabled() then
		if (self.Corners) then
			draw.RoundedBoxEx(6, 0, 0, w, h, ui.col.SUP:Copy(), unpack(self.Corners))
			draw.RoundedBoxEx(6, 1, 1, w - 2, h - 2, self.BackgroundColor or ui.col.Button, unpack(self.Corners))
		else
			draw.RoundedBox(6, 0, 0, w, h, ui.col.SUP:Copy())
			draw.RoundedBox(6, 1, 1, w - 2, h - 2, self.BackgroundColor or ui.col.Button)
		end
	else
		if (self.Corners) then
			draw.RoundedBoxEx(4, 0, 0, w, h, self.BackgroundColor or ui.col.Button, unpack(self.Corners))
		else
			draw.RoundedBox(4, 0, 0, w, h, self.BackgroundColor or ui.col.Button)
		end

		if self:IsHovered() or self.Active then
			if (self.Corners) then
				draw.RoundedBoxEx(4, 0, 0, w, h, ui.col.Hover, unpack(self.Corners))
			else
				draw.RoundedBox(4, 0, 0, w, h, ui.col.Hover)
			end
		end
	end
end

local function createPoly( _r, _x, _y, _w, _h )
	local _u = ( _x + _r * 1 ) - _x
	local _v = ( _y + _r * 1 ) - _y

	local points = 64
	local slices = ( 2 * math.pi ) / points
	local poly = {  }

	X, Y = _w-_r, _h-_r

	for i = 0, points-1 do
		local angle = ( slices * i ) % points
		local x = X + _r * math.cos( angle )
		local y = Y + _r * math.sin( angle )

		if i == points/4-1 then
			X, Y = _x+_r, _h-_r
			table.insert( poly, { x = X, y = Y, u = _u, v = _v } )
		elseif i == points/2-1 then
			X, Y = _x, _r
			table.insert( poly, { x = X, y = Y, u = _u, v = _v } )
			X = _x+_r
		elseif i == 3*points/4-1 then
			X, Y = _w-_r, 0
			table.insert( poly, { x = X, y = Y, u = _u, v = _v } )
			Y = _r
		end

		table.insert( poly, { x = x, y = y, u = _u, v = _v } )
	end

	return poly
end

local _material = Material( "effects/flashlight001" );
function SKIN:PaintImageButton(self, w, h)
	if (not self.Poly) or ((self.LastW ~= w) or (self.LastH ~= h)) then
		self.Poly = createPoly(5, 0, 0, w, h)

		self.LastW = w
		self.LastH = h
	end

	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )

	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )

	draw.NoTexture()
	surface.SetMaterial( _material )
	surface.SetDrawColor( color_black )
	surface.DrawPoly( self.Poly )

	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )

	if self.Material then
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(self.Material)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	if IsValid(self.AvatarImage) then
		self.AvatarImage:SetPaintedManually(false)
		self.AvatarImage:PaintManual()
		self.AvatarImage:SetPaintedManually(true)
	end

	render.SetStencilEnable(false)
	render.ClearStencil()

	if self.Hovered then
		draw.RoundedBox(5, 0, 0, w, h, color_hover)
	end
end

function SKIN:PaintImageRow(self, w, h)
	if self.Active then
		draw.RoundedBox(5, 0, 0, w, h, color_flat_black)
		return
	else
		draw.RoundedBox(5, 0, 0, w, h, self.BackgroundColor or color_background)
	end

	if self:IsHovered() then
		draw.RoundedBox(5, 0, 0, w, h, color_hover)
	end
end


-- Close Button
function SKIN:PaintWindowCloseButton(panel, w, h)
	local col = ui.col.SUP:Copy()
    if panel.Hovered then
        panel.Hov = Lerp(FrameTime() * 5, panel.Hov or 0, 255)
    else
        panel.Hov = Lerp(FrameTime() * 5, panel.Hov or 0, 125)
    end

    col.a = panel.Hov

    draw.RoundedBox(5, 0, 0, w, h, col)
    draw.SimpleText(utf8.char(0xf00d), 'ForkAwesome', w / 2, h / 2, ui.col.White, 1, 1)
end

function SKIN:PaintTransparentWindowCloseButton(panel, w, h)
	if (not panel.m_bBackground) then return end

	surface.SetDrawColor(panel.Hovered and color_close_hover or color_close)

	local xX = math.floor((w / 2) - 5)
	local xY = math.floor((h / 2) - 5)

	render.PushFilterMin(3)
		render.PushFilterMag(3)
			surface.DrawLine(xX, xY, xX + 10, xY + 10)
			surface.DrawLine(xX, xY + 10, xX + 10, xY)
		render.PopFilterMag()
	render.PopFilterMin()
end


-- Scrollbar
function SKIN:PaintVScrollBar(self, w, h) end
function SKIN:PaintButtonUp(self, w, h) end
function SKIN:PaintButtonDown(self, w, h) end
function SKIN:PaintButtonLeft(self, w, h) end
function SKIN:PaintButtonRight(self, w, h) end

local color_scrollbar = ui.col.SUP:Copy()
color_scrollbar.a = 180
function SKIN:PaintScrollBarGrip(self, w, h)
	draw.RoundedBox(5, 0, 0, w, h, color_scrollbar)
end

function SKIN:PaintScrollPanel(self, w, h)
	draw.RoundedBox(5, 0, 0, w, h, color_background)
end

function SKIN:PaintUIScrollBar(self, w, h)
	local x = self.scrollButton.x

	draw.RoundedBox(5, x, 0, w - x - x, h, ui.col.FlatBlack)
	draw.RoundedBox(5, x, self.scrollButton.y, w - x - x, self.height, color_scrollbar)
end


-- Slider
function SKIN:PaintUISlider(self, w, h)
	SKIN:PaintPanel(self, w, h)

	draw.RoundedBox(5, 1, 1, w -2, h - 2, color_flat_black)

	if self.Vertical then
	draw.RoundedBox(5, 1, self:GetValue() * h, w - 2, h - (self:GetValue() * h), color_sup)
	else
		draw.RoundedBox(5, 41, 1, self:GetValue() * (w - 40) - self:GetValue() * 16, h - 2, color_sup)

		draw.SimpleText(math.ceil(self:GetValue() * 100) .. '%', 'ui.18', 20, h * 0.5 , color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function SKIN:PaintSliderButton(self, w, h)
	draw.RoundedBox(5, 0, 0, w, h, self:IsHovered() and color_button_hover or color_offwhite)
end

-- Text Entry
function SKIN:PaintTextEntry(self, w, h)
	draw.RoundedBox(5, 0, 0, w, h, color_offwhite)

	-- Hack on a hack, but this produces the most close appearance to what it will actually look if text was actually there
	if ( self.GetPlaceholderText && self.GetPlaceholderColor && self:GetPlaceholderText() && self:GetPlaceholderText():Trim() != "" && self:GetPlaceholderColor() && ( !self:GetText() || self:GetText() == "" ) ) then

		local oldText = self:GetText()

		local str = self:GetPlaceholderText()
		if ( str:StartWith( "#" ) ) then str = str:sub( 2 ) end
		str = language.GetPhrase( str )

		self:SetText( str )
		self:DrawTextEntryText( self:GetPlaceholderColor(), self:GetHighlightColor(), self:GetCursorColor() )
		self:SetText( oldText )

		return
	end

	self:DrawTextEntryText(color_black, color_sup, color_black)
end


-- List View
function SKIN:PaintUIListView(self, w, h)
	draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)
end


function SKIN:PaintListView(self, w, h)
	--draw.OutlinedBox(0, 0, w, h, color_offwhite, color_outline)
end

function SKIN:PaintListViewLine(self, w, h) -- todo, just make a new control and never use this
	if self.m_bAlt then
		draw.Box(0, 0, w, h, (self:IsSelected() or self:IsHovered()) and color_sup or color_hover)
	else
		draw.Box(0, 0, w, h, (self:IsSelected() or self:IsHovered()) and color_sup or color_background)
	end

	for k, v in ipairs(self.Columns) do
		if (self:IsSelected() or self:IsHovered()) then
			v:SetTextColor(color_black)
			v:SetFont('ui.20')
		else
			v:SetTextColor(color_white)
			v:SetFont('ui.15')
		end
	end
end


-- Checkbox
function SKIN:PaintCheckBox(self, w, h)
	local checked = self:GetChecked() -- check urself before u rek urself

	draw.RoundedBox(5, 0, 0, w, h, ui.col.FlatBlack)

	draw.RoundedBox(5, checked and (w * 0.5) or 1, 1, (w * 0.5) - 1, h - 2, checked and color_sup or ui.col.OffWhite)

	if self:IsHovered() then
		draw.RoundedBox(5, 0, 0, w, h, ui.col.Hover)
	end
end


-- Tabs
local color_tab = color_sup:Copy()
function SKIN:PaintTabButton(self, w, h)
	draw.RoundedBox(4, 0, 0, w, h, ui.col.ButtonBlack)

	if self:IsHovered() then
		draw.RoundedBox(4, 0, 0, w, h, ui.col.Hover)
	end

	if self.Active then
		draw.RoundedBox(4, 0, 0, w, h, color_tab)
	end
end

function SKIN:PaintTabListPanel(self, w, h)
	draw.RoundedBoxEx(5, 160, 0, w - 160, h, color_background, false, true, false, true)
end


-- ComboBox
function SKIN:PaintComboBox(self, w, h)
	if IsValid(self.Menu) and (not self.Menu.SkinSet) then
		self.Menu:SetSkin('SUP')
		self.Menu.SkinSet = true
	end

	if (not self.ColorSet) then
		self:SetTextColor(ui.col.White)
		self.ColorSet = true
	end

	draw.RoundedBox(5, 0, 0, w, h, self.BackgroundColor or ui.col.Button)

	if self:IsHovered() then
		draw.RoundedBox(5, 0, 0, w, h, ui.col.Hover)
	end
end

function SKIN:PaintComboDownArrow(self, w, h)
	surface.SetDrawColor(color_sup)
	draw.NoTexture()
	surface.DrawPoly({
		{x = 0, y = w * .5},
		{x = h, y = 0},
		{x = h, y = w}
	})
end


-- DMenu
function SKIN:PaintMenu(self, w, h)
	draw.RoundedBox(5, 0, 0, w, h, ui.col.FlatBlack)
end

function SKIN:PaintMenuOption(self, w, h)
	if (not self.FontSet) then
		self:SetFont('ui.18')
		self.FontSet = true
	end

	self:SetTextColor(color_white)

	draw.RoundedBox(5, 1, 1, w - 2, h - 2, ui.col.Button)

	if self.m_bBackground and (self.Hovered or self.Highlight) then
		draw.RoundedBox(5, 1, 1, w - 2, h - 2, ui.col.Hover)
	end
end


-- DPropertySheet
local propbackground = Color(200, 200, 200)
local prophovered = ui.col.ButtonHover
local propactive = Color(color_sup.r, color_sup.g, color_sup.b - 20)

function SKIN:PaintPropertySheet(self, w, h)
	local tab = self:GetActiveTab()

	if (IsValid(tab)) then
		if (!self.Dark) then
			draw.Box(0, tab:GetTall(), w, h - tab:GetTall(), propbackground)
		end
	end
end

function SKIN:PaintTab(self, w, h)
	local active = self:GetPropertySheet():GetActiveTab() == self

	if (active) then
		self:SetTextColor(propactive)
		if (!self:GetPropertySheet().Dark) then
			draw.Box(0, 0, w, h, propbackground)
		else
			draw.Box(0, 0, w, h, color_background)
			surface.SetDrawColor(color_outline)
			surface.DrawOutlinedRect(0, 0, w, h+1)
			//draw.Box(0, 0, w, h, color_background)
		end
	elseif (self:IsHovered()) then
		self:SetTextColor(prophovered)
	else
		self:SetTextColor(propbackground)
	end
end

derma.DefineSkin('SUP', 'SUP\'s derma skin', SKIN)