local color_white = Color(217, 217, 217)

surface.CreateFont('inv.ui.16', {
    font = 'Montserrat',
    size = 16,
    weight = 250,
    extended = true,
    antialias = true
})
surface.CreateFont('inv.ui.20', {
    font = 'Montserrat',
    size = 20,
    weight = 250,
    extended = true,
    antialias = true
})

function draw.ToolTip(parent, text, time)	
	if not parent then return end

	local NewToolTip = vgui.Create( "INV_HOVER" )
	NewToolTip:SetText( text or '' )
	NewToolTip:OpenForPanel( parent )
	NewToolTip:TimeAlpha( time )
end

local PANEL = {}

function PANEL:Init()

	self:SetDrawOnTop( true )
	self.DeleteContentsOnClose = false
	self:SetText( "" )
	self:SetFont( 'inv.ui.20' )
	self:SetTextColor( Color(0,0,0,0) )
end

function PANEL:TimeAlpha( time )
	self:SetAlpha(0)
	self:AlphaTo(255, 0.4, time)  
end

function PANEL:SetContents( panel, bDelete )
	panel:SetParent( self )

	self.Contents = panel
	self.DeleteContentsOnClose = bDelete or false
	self.Contents:SizeToContents()
	self:InvalidateLayout( true )

	self.Contents:SetVisible( false )
end

function PANEL:PerformLayout()
	if ( IsValid( self.Contents ) ) then
		self:SetWide( self.Contents:GetWide() + 8 )
		self:SetTall( self.Contents:GetTall() + 8 )
		self.Contents:SetPos( 4, 4 )
		self.Contents:SetVisible( true )
	else
		local w, h = self:GetContentSize()
		self:SetSize( w + 30, h + 6 )
		self:SetContentAlignment( 5 )
	end
end

local Mat = Material( "vgui/arrow" )

local LerpX = 0
local LerpY = 0

function PANEL:PositionTooltip()
	if ( !IsValid( self.TargetPanel ) ) then
		self:AlphaTo(0, 0.2, 0, function()
			self:Close()
		end) 
		
		return
	end

	if not ( self.TargetPanel:IsHovered() ) then
		self:AlphaTo(0, 0.2, 0, function()
			self:Close()
		end) 
		
		return
	end

	self:InvalidateLayout( true )

	local x, y = input.GetCursorPos()
	local w, h = self:GetSize()

	local lx, ly = self.TargetPanel:LocalToScreen( 0, 0 )

	y = y - 50

	y = math.min( y, ly - h + 10 )
	if ( y < 2 ) then y = 2 end

	LerpX = Lerp(FrameTime()*10, LerpX, x)
	LerpY = Lerp(FrameTime()*10, LerpY, y)

	-- Fixes being able to be drawn off screen
	self:SetPos( math.Clamp( LerpX, 0, ScrW() - self:GetWide() ), math.Clamp( LerpY, 0, ScrH() - self:GetTall() ) )
end

function PANEL:Paint( w, h )
	self:PositionTooltip()

	draw.RoundedBox(6, 0, 0, w, h, Color(40,40,40,250)) 

	draw.SimpleText( self:GetText(), 'inv.ui.20', w*.5, h*.5, color_white, 1, 1 )
end

function PANEL:OpenForPanel( panel )

	self.TargetPanel = panel
	self:PositionTooltip()

	if ( !IsValid( self ) ) then return end
	if ( !IsValid( panel ) ) then return end

	self:PositionTooltip()
	self:SetVisible( true )
end

function PANEL:Close()

	if ( !self.DeleteContentsOnClose && IsValid( self.Contents ) ) then

		self.Contents:SetVisible( false )
		self.Contents:SetParent( nil )

	end

	self:Remove()

end

derma.DefineControl( "INV_HOVER", "", PANEL, "DLabel" )

local LocalPlayer_Inventory = {}

local ScrollPos
local HoverCategory = {}

local int = ' / '
local num = ' шт.'
local Title = 'Инвентарь'
local InUse = 'Использовать'
local ToDrop = 'Бросить'
local InDelete = 'Удалить'
local CountItem = 'Занято '

local MatDelete = Material('divergent/ui/hud/icons/close_16.png')
local MatDrop = Material('sup/gui/generic/actions.png')
local MatUse = Material('sup/gui/generic/check-mark.png')
local MatInventory = Material('divergent/ui/hud/icons/pocket.png')

local Col121 = Color(121,121,121)
local Col125 = Color(125,125,125)
local Col44 = Color(44,44,44)
local eclipsecolor = Color(177, 45, 87)
local Col57 = Color(57,57,57)
local Col87 = Color(87,87,87)
local Col50 = Color(50,50,50)
local Col40 = Color(40,40,40, 240)

local DropSound = {
	[1] = 'physics/wood/wood_crate_impact_soft2.wav',
	[2] = 'physics/wood/wood_box_impact_soft3.wav',
	[3] = 'physics/wood/wood_crate_impact_soft1.wav',
}

local UseSound = {
	[1] = 'physics/plaster/ceiling_tile_impact_hard1.wav',
	[2] = 'physics/plaster/ceiling_tile_step1.wav',
	[3] = 'physics/flesh/flesh_impact_hard1.wav',
}

local DeleteSound = {
	[1] = 'physics/cardboard/cardboard_box_impact_hard5.wav',
	[2] = 'physics/cardboard/cardboard_box_impact_hard1.wav',
	[3] = 'physics/cardboard/cardboard_box_break1.wav',
}


function draw.UIMaterial( x, y, w, h, ColorMat, Mat )
	draw.NoTexture()
	surface.SetDrawColor(ColorMat)
	surface.SetMaterial( Mat )
	surface.DrawTexturedRect( x, y, w, h ) 
end

local function BuildMateralString(Part, UniqueID, IsEditor, IsDried)
	local str = "zgo2_plant_" .. Part

	if IsDried then
		str = str .. "_dried"
	end

	if IsEditor then
		str = str .. "_editor"
	else
		str = str .. "_" .. UniqueID
	end

	return str
end

local function FindMaterialIDByName(ent,name)
	local id
	for k,v in pairs(ent:GetMaterials()) do
		local _,ePos = string.find(v,name)
		if ePos and ePos >= string.len(v) then
			id = k - 1
			break
		end
	end
	return id
end

local function DropItems(k, tb, ent, from)
	local itm_count = 1

	if IsValid(DROP_PANEL) then
		DROP_PANEL:Remove()
	end
	
	local DropPanel = vgui.Create('DFrame')
	DROP_PANEL = DropPanel
	DROP_PANEL:SetSize(200, 100)
	DROP_PANEL:Center()
	DROP_PANEL:ShowCloseButton(true)
	DROP_PANEL:SetAlpha(0)
    DROP_PANEL:AlphaTo(255, 0.3, 0.1)  
	DROP_PANEL:SetTitle('')
	DROP_PANEL.Paint = function(self,w,h) 
		draw.RoundedBox(6, 0, 0, w, h, Color(44,44,44,240))
		draw.RoundedBoxEx(6, 0, 0, w, 32, Color(47,47,47), true, true, false, false)

		draw.SimpleText( itm_count .. num, 'inv.ui.16', w*.5, h/2-17, WHITE, 1, 0 )
		draw.SimpleText( tb.save_data['name'], 'inv.ui.16', w*.5, 5, WHITE, 1, 0 )

		if not IsValid(rp.PanelPlyInv) then
			self:Remove()
		end
	end

	local Count = vgui.Create('DSlider', DROP_PANEL)
	Count:SetPos( 10, DROP_PANEL:GetTall()*.5 )
	Count:SetSize( DROP_PANEL:GetWide()-20, 16)
	Count:SetSlideX(0)

	Count.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, h/2-4, w, 8, Color(35,35,35))
		draw.RoundedBox(8, 0, h/2-4, w*Count:GetSlideX(), 8, Color(87,87,87))
	end

	Count.Knob.Paint = function(knob, w, h)
		draw.RoundedBox(8, 0, 0, 16, 16, Color(255,122,44))
	end
	
	Count.OnValueChanged = function()
		itm_count = math.Clamp(math.Round(Count:GetSlideX() * tb.save_data['amount']), 1, tb.save_data['amount'])
	end

	local EnterBtn = vgui.Create('DButton', DROP_PANEL)
	EnterBtn:SetPos( DROP_PANEL:GetWide()/2 - 69, DROP_PANEL:GetTall() - 25 - 5 )
	EnterBtn:SetSize( 64, 25 )
	EnterBtn:SetText('')
	EnterBtn.Paint = function(self,w,h)
		if (self.Hovered) then
			draw.RoundedBox(8, 0, 0, w, h, Color(121,121,121))
		else
			draw.RoundedBox(8, 0, 0, w, h, Color(56,56,56))
		end

		draw.SimpleText( 'Ок', 'inv.ui.16', w*.5, h/2, WHITE, 1, 1 )
	end
	
	EnterBtn.DoClick = function()
		if ent then
			if from then
				net.Start("INV.MoreFromBank")
					net.WriteEntity(ent)
					net.WriteInt(k, 14)
					net.WriteInt(itm_count, 14)
					net.WriteTable(tb)
				net.SendToServer()
			else
				net.Start("INV.MoreToBank")
					net.WriteEntity(ent)
					net.WriteInt(k, 14)
					net.WriteInt(itm_count, 14)
					net.WriteTable(tb)
				net.SendToServer()
			end
		else
			net.Start("INV.MoreDrop")
				net.WriteInt(k, 14)
				net.WriteInt(itm_count, 14)
			net.SendToServer()
		end

		DROP_PANEL:Remove()
	end

	local CloseBtn = vgui.Create('DButton', DROP_PANEL)
	CloseBtn:SetPos( DROP_PANEL:GetWide()/2 + 5, DROP_PANEL:GetTall() - 25 - 5 )
	CloseBtn:SetSize( 72, 25 )
	CloseBtn:SetText('')
	CloseBtn.Paint = function(self,w,h)
		if (self.Hovered) then
			draw.RoundedBox(8, 0, 0, w, h, Color(121,121,121))
		else
			draw.RoundedBox(8, 0, 0, w, h, Color(56,56,56))
		end

		draw.SimpleText( 'Отмена', 'inv.ui.16', w*.5, h/2, WHITE, 1, 1 )
	end
	
	CloseBtn.DoClick = function()
		DROP_PANEL:Remove()
	end
end

local CMenu = false
local function OpenInventory()
	net.Start('INV:DAUNOPEN')
	net.SendToServer()

	local scrw,scrh = ScrW(), ScrH() 

	if IsValid(rp.PanelPlyInv) then
        rp.PanelPlyInv:Remove()
    end

	rp.PanelPlyInv = vgui.Create("InventoryFrame")
	rp.PanelPlyInv:SetSize(460, 250)
	rp.PanelPlyInv:SetPos(scrw/2-230, scrh)
	rp.PanelPlyInv:MoveTo(scrw/2-rp.PanelPlyInv:GetWide()/2,scrh-rp.PanelPlyInv:GetTall() - 10, 0.2, 0, 0.1)
	rp.PanelPlyInv:SetDraggable(false) 
	rp.PanelPlyInv:MakePopup()

	rp.PanelPlyInv:RefreshIInv()
end

local DL = 0

net.Receive("INV.RefreshPlyInv",function()
	local items = net.ReadTable() or {}
	LocalPlayer_Inventory = items

	if IsValid(rp.PanelPlyInv) then
		--rp.PanelPlyInv:RefreshIInv()
	end
end)

hook.Add("OnContextMenuOpen", "OpenInventory", function()
	CMenu = true

	OpenInventory()
end)

hook.Add("OnContextMenuClose", "CloseInventory", function()
	local scrw,scrh = ScrW(), ScrH()

	CMenu = false

    if rp.PanelPlyInv then
		rp.PanelPlyInv:Remove()
    end
end)

local PANEL = {}
local HasDown = false
local HasDownDouble = 0

AccessorFunc( PANEL, "m_bDraggable",		"Draggable",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable",			"Sizable",			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock",		"ScreenLock",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose",	"DeleteOnClose",	FORCE_BOOL )

AccessorFunc( PANEL, "m_iMinWidth",			"MinWidth",			FORCE_NUMBER )
AccessorFunc( PANEL, "m_iMinHeight",		"MinHeight",		FORCE_NUMBER )

function PANEL:Init()
	HasDown = false

	self:SetFocusTopLevel( true )

	self:SetDraggable( true )
	self:SetSizable( false )
	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )

	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	self:DockPadding( 5, 24 + 5, 5, 5 )
end

function PANEL:Close()

	self:SetVisible( false )

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end
end

function PANEL:OnClose()
end

function PANEL:Center()

	self:InvalidateLayout( true )
	self:CenterVertical()
	self:CenterHorizontal()

end

function PANEL:IsActive()

	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false

end

function PANEL:Think()
	local ply = LocalPlayer() 
    local scrw,scrh = ScrW(), ScrH() 

	local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:SetPos( x, y )

	end

	if ( self.Sizing ) then

		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px && self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py && self:GetScreenLock() ) then y = ScrH() - py end

		self:SetSize( x, y )
		self:SetCursor( "sizenwse" )
		return

	end

	local screenX, screenY = self:LocalToScreen( 0, 0 )

	if ( self.Hovered && self.m_bSizable && mousex > ( screenX + self:GetWide() - 20 ) && mousey > ( screenY + self:GetTall() - 20 ) ) then

		self:SetCursor( "sizenwse" )
		return

	end

	if ( self.Hovered && self:GetDraggable() && mousey < ( screenY + 24 ) ) then
		self:SetCursor( "sizeall" )
		return
	end

	self:SetCursor( "arrow" )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end

	if not ply:Alive() then        
		self:MoveTo(scrw/2-self:GetWide()/2, scrh, 0.2, 0, 0.2)
		self:AlphaTo(0, 0.25, 0, function()						
			self:Remove()
		end)

		return
	end

end

function PANEL:Paint( w, h )
	local ply = LocalPlayer() 
    local scrw,scrh = ScrW(), ScrH() 

	local X, Y = self:LocalCursorPos( 0, 0 )

	if not CMenu and input.IsMouseDown( MOUSE_LEFT ) then
		if X < 0 or X > w or Y < 0 or Y > h then 
			self:MoveTo(scrw/2-230, scrh, 0.2, 0, 0.2)
			self:AlphaTo(0, 0.25, 0, function()						
				self:Remove()
			end)

			return
		end
	end

	

	--if not self.CloseScreen and not input.IsKeyDown( KEY_C ) then
	--	self:Remove()
	--end

	if input.IsKeyDown( KEY_LCONTROL ) then
		HasDown = true 
	else
		HasDown = false
	end

	if not ply:Alive() then self:Remove() end

	draw.RoundedBox(6, 0, 0, w, h, Col40) 
	
	draw.RoundedBoxEx(6, 0, 0, w, 32, Col44, true, true, false, false) 

	draw.UIMaterial( 8, 8, 17, 17, color_white, MatInventory )

	draw.SimpleText( CountItem..table.Count(LocalPlayer_Inventory)..int..ply:GetMaxInv(), 'inv.ui.20', w-10, 6, color_white, 2, 0 )  
	draw.SimpleText( Title, 'inv.ui.20', 33, 6, color_white, 0, 0 )
end

function PANEL:OnMousePressed()

	local screenX, screenY = self:LocalToScreen( 0, 0 )

	if ( self.m_bSizable && gui.MouseX() > ( screenX + self:GetWide() - 20 ) && gui.MouseY() > ( screenY + self:GetTall() - 20 ) ) then
		self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
		self:MouseCapture( true )
		return
	end

	if ( self:GetDraggable() && gui.MouseY() < ( screenY + 24 ) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		return
	end

end

function PANEL:OnMouseReleased()

	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )

end

function PANEL:PerformLayout()
end

function PANEL:RefreshIInv()
	local PlyINV = LocalPlayer_Inventory
	local categories = {}
	local Key = 0
	
	if IsValid(self.Scroll) then
		self.Scroll:Remove()
	end

	for i, data in pairs(PlyINV) do
		local category_name = INV.Languge[data.class] or 'Разное'

		categories[category_name] = categories[category_name] or {}
		categories[category_name][i] = data
	end

	self.Scroll = vgui.Create("ui_scrollpanel", self)
	self.Scroll:SetSize(self:GetWide() - 10, self:GetTall()-47)
	self.Scroll:SetPos(5, 37)
	self.Scroll:SetAlpha(0)
	self.Scroll:AlphaTo(255, 0.1, 0) 

	function self.Scroll:OnRemove()
		ScrollPos = self.yOffset or 0
	end

	for id, itm in SortedPairs(categories) do
		self.Category = vgui.Create('DCollapsibleCategory', self.Scroll)
		self.Category:Dock(TOP)
		self.Category.Header:SetTall(32)
		self.Category:SetExpanded(HoverCategory[id] or 1)
		self.Category:SetLabel('')
		self.Category.Paint = function(self, w, h)
			draw.RoundedBox(16, 0, 0, w, h-3, Col50) 
			draw.RoundedBox(16, 6, 6, 16, 16, Col87) 
			draw.RoundedBox(16, 10, 10, 8, 8, Col121) 

			draw.SimpleText( id, 'inv.ui.20', 32, 4, color_white, 0, 0 )  
		end

		function self.Category:OnToggle(bool)
			HoverCategory[id] = bool and 1 or 0
		end

		function self.Category:Toggle()
		end

		self.Grid = vgui.Create( 'DIconLayout', self.Category )
		self.Grid:Dock(TOP)
		self.Grid:DockMargin(5, 5, 5, 0)
		self.Grid:DockPadding(0,0,0,10)
		self.Grid:SetSpaceY( 5 )
		self.Grid:SetSpaceX( 6 )

		for k, v in SortedPairs(itm) do	
			local posx, posy, fov, x, y, count, child

			if INV.ModelPos[v.class] then
				posx, posy, fov = INV.ModelPos[v.class].pos, INV.ModelPos[v.class].ang, INV.ModelPos[v.class].fov
			else
				posx, posy, fov = Vector(0,0,35), Angle(0,45,0), 20
			end
			
			self.Grid.Item = vgui.Create("Panel", self.Grid)
			self.Grid.Item:SetSize(57, 57)
			self.Grid.Item.Hover = 255
			self.Grid.Item.Paint = function(self,w,h)
				if IsValid(child) and child:IsHovered() then
					self.Hover = Lerp(FrameTime()*12, self.Hover, 255)
				else
					self.Hover = Lerp(FrameTime()*12, self.Hover, 0)
				end

				draw.RoundedBox(8, 0, 0, w, h, Col57)  
				draw.RoundedBox(8, 0, 0, w, h, Color(87,87,87,self.Hover))
			end

			if v.save_data['model'] ~= nil then
				if v.class == 'spawned_weapon' or v.class == 'base_food' or v.class == 'spawned_shipment' then
					local ModelItem = vgui.Create( "SpawnIcon", self.Grid.Item )
					ModelItem:Dock(FILL)
					ModelItem:DockMargin(5, 5, 5, 5)

					if v.class == 'spawned_shipment' then
						local contents = v.save_data['content']
						ModelItem:SetModel( rp.shipments[contents].model or 'models/props_junk/plasticbucket001a.mdl' )
					else
						ModelItem:SetModel( v.save_data['model'] )
					end
				else
					local ModelItem = vgui.Create( "DModelPanel", self.Grid.Item )
					ModelItem:Dock(FILL)
					ModelItem:SetModel( v.save_data['model'] )
					ModelItem:SetCamPos(Vector(0, 100, 50))
					ModelItem:SetDirectionalLight(BOX_RIGHT, color_white)
					ModelItem:SetDirectionalLight(BOX_BACK, color_black)
					ModelItem:SetDirectionalLight(BOX_FRONT, color_white)
					ModelItem:GetEntity():SetPos(posx)
					ModelItem:GetEntity():SetAngles(posy)
					ModelItem.Angles = Angle(0,75,0)
					ModelItem:SetFOV(fov)
	
					function ModelItem:LayoutEntity( ent )
						if ( self.bAnimated ) then self:RunAnimation() end
					end

					if v.save_data['WeedID'] then
						local WeedData = zgo2.Plant.GetData(v.save_data['WeedID'])

						if WeedData then
							local stem_id = FindMaterialIDByName(ModelItem.Entity,"plant/zgo2_stem")
							if stem_id then ModelItem:GetEntity():SetSubMaterial(stem_id, "!" .. BuildMateralString("stem", WeedData.uniqueid)) end

							local leaf01_id = FindMaterialIDByName(ModelItem.Entity,"plant/zgo2_leaf")
							if leaf01_id then ModelItem:GetEntity():SetSubMaterial(leaf01_id, "!" .. BuildMateralString("leaf01", WeedData.uniqueid)) end

							local leaf02_id = FindMaterialIDByName(ModelItem.Entity,"plant/zgo2_leaf02")
							if leaf02_id then ModelItem:GetEntity():SetSubMaterial(leaf02_id, "!" .. BuildMateralString("leaf02", WeedData.uniqueid)) end

							local bud_id = FindMaterialIDByName(ModelItem.Entity,"plant/zgo2_bud")

							if bud_id then ModelItem:GetEntity():SetSubMaterial(bud_id, "!" .. BuildMateralString("bud", WeedData.uniqueid)) end

							local hair_id = FindMaterialIDByName(ModelItem.Entity,"plant/zgo2_hair")
							if hair_id then ModelItem:GetEntity():SetSubMaterial(hair_id, "!" .. BuildMateralString("hair", WeedData.uniqueid)) end
						end
					end

					if v.save_data['WeedAmount'] and v.save_data['WeedAmount'] > 0 then
						ModelItem:GetEntity():SetBodygroup(0, 0)
						ModelItem:GetEntity():SetBodygroup(1, 0)
						ModelItem:GetEntity():SetBodygroup(2, 0)
						ModelItem:GetEntity():SetBodygroup(3, 0)
						ModelItem:GetEntity():SetBodygroup(4, 0)

						local bg = math.Clamp(math.Round((5 / zgo2.config.Jar.Capacity) * v.save_data['WeedAmount']),1,5)
						for i = 0, bg-1 do ModelItem:GetEntity():SetBodygroup(i, 1) end
					end
	
					if v.save_data['MethType'] and v.save_data['MethQuality'] then
						local MethMat = zmlab2.Meth.GetMaterial(v.save_data['MethType'], v.save_data['MethQuality'])
						if MethMat then
							ModelItem:GetEntity():SetSubMaterial(0, "!" .. MethMat)
						end
					end
	
					if v.save_data['MethAmount'] then
						local cur_amount = v.save_data['MethAmount']
						
						if cur_amount <= 0 then
							ModelItem:GetEntity():SetBodygroup(0, 5)
						else
							local bg = math.Clamp(5 - math.Round((5 / zmlab2.config.Crate.Capacity) * cur_amount), 1, 5)
							ModelItem:GetEntity():SetBodygroup(0, bg)
						end 
					end
				end
			end

			count = v.save_data['amount']..num

			if v.save_data['count'] and v.save_data['amount'] > 0 then
				count = v.save_data['count']..num
			elseif v.save_data['UsesLeft'] and v.save_data['amount'] > 0 then
				count = v.save_data['UsesLeft']..num
			end

			surface.SetFont('inv.ui.16')
			x, y = surface.GetTextSize(count)

			x = x + 10

			local ItemInfo = vgui.Create("Panel", self.Grid.Item)
			ItemInfo:Dock(FILL)
			ItemInfo:SetText('')
			ItemInfo.Hover = 0
			ItemInfo.Paint = function(self,w,h)
				draw.RoundedBox(16, w / 2 - x / 2, h-16, x, 16, eclipsecolor)

				draw.SimpleText( count, 'inv.ui.16', w / 2, h-16, color_white, 1, 0 )
			end

			ItemInfo.OnCursorEntered = function(self)
				draw.ToolTip(self, v.save_data['name'], 0.1)
			end

			local DealyTime = 0.5
			local DealyUse = CurTime() + DealyTime

			function ItemInfo:OnMousePressed(key)
				if CurTime() < DealyUse then return end
				
				if key == MOUSE_LEFT and HasDownDouble >= CurTime() then
					if v.canuse then
						net.Start("INV.Use")
							net.WriteInt(k, 14)
						net.SendToServer()

						surface.PlaySound(UseSound[math.random(1,3)])

						DealyUse = CurTime() + DealyTime
					end

					return
				end

				if key == MOUSE_LEFT then
					HasDownDouble = CurTime() + 0.2

					return
				end

				if HasDown and key == MOUSE_RIGHT then
					net.Start("INV.MoreDrop")
						net.WriteInt(k, 14)
						net.WriteInt(1, 14)
					net.SendToServer()

					surface.PlaySound(DropSound[math.random(1,3)])

					DealyUse = CurTime() + DealyTime
				elseif key == MOUSE_RIGHT then
					if v.canuse and HasDown then
						net.Start("INV.Use")
							net.WriteInt(k, 14)
						net.SendToServer()

						surface.PlaySound(UseSound[math.random(1,3)])

						DealyUse = CurTime() + DealyTime
					elseif not HasDown then
						if IsValid(BTN_ITEM) then
							BTN_ITEM:AlphaTo(0, 0.2, 0, function()
								BTN_ITEM:Remove()
								BTN_ITEM = nil
							end)
		
							return 
						end
		
						local ColorBtn = color_white
						local InfoBtn = 'Нельзя использовать'
						local x, y = input.GetCursorPos()
		
						x = math.Clamp(x, 125, ScrW()-125)
						y = math.Clamp(y, 72, ScrH()-72)
		
						local BtnItem = vgui.Create("Panel")
						BTN_ITEM = BtnItem
						BTN_ITEM:SetPos(x + 15, y + 50)
						BTN_ITEM:MoveTo(x + 15, y, 0.4, 0, 0.3)
						BTN_ITEM:SetSize(125, 72)
						BTN_ITEM:SetAlpha(0)
						BTN_ITEM:AlphaTo(255, 0.2, 0)
						BTN_ITEM:SetDrawOnTop( true )
						BTN_ITEM:MakePopup()
						BTN_ITEM.Hover = 0
						BTN_ITEM.Paint = function(self,w,h)
							draw.RoundedBox(8, 0, 0, w, h, Col44)
		
							if not IsValid(self) or not IsValid(ItemInfo) then
								self:Remove()
							end
						end
		
						local UseItem = vgui.Create("DButton", BTN_ITEM)
						UseItem:SetPos(0,0)
						UseItem:SetSize(125, 24)
						UseItem:SetText('')
						UseItem.Hover = 0
						UseItem.Paint = function(self,w,h)
							if self:IsHovered() and v.canuse then
								draw.RoundedBoxEx(8, 0, 0, w, h, Col121, true, true, false, false)
							end
		
							if v.canuse then
								ColorBtn = color_white
							else
								ColorBtn = Col125
							end
		
							draw.UIMaterial( 5, h/2-7, 14, 14, Color(15, 215, 15), MatUse )
		
							draw.SimpleText( InUse, 'inv.ui.16', w/2 + 7, h/2, ColorBtn, 1, 1 )
						end
						
						function UseItem:DoClick()
							if v.canuse then
								if CurTime() < DealyUse then return end
		
								net.Start("INV.Use")
									net.WriteInt(k, 14)
								net.SendToServer()

								surface.PlaySound(UseSound[math.random(1,3)])
		
								DealyUse = CurTime() + 2
							end
						end
		
						local DropItem = vgui.Create("DButton", BTN_ITEM)
						DropItem:SetPos(0,24)
						DropItem:SetSize(125, 24)
						DropItem:SetText('')
						DropItem.Hover = 0
						DropItem.Paint = function(self,w,h)
							if self:IsHovered() then
								draw.RoundedBox(0, 0, 0, w, h, Col121)
							end
		
							draw.UIMaterial( 5, h/2-7, 14, 14, Color(215, 215, 15), MatDrop )
		
							draw.SimpleText( ToDrop, 'inv.ui.16', 26, h/2, color_white, 0, 1 )
						end
						
						function DropItem:DoClick()
							if CurTime() < DealyUse then return end
							
							net.Start("INV.MoreDrop")
								net.WriteInt(k, 14)
								net.WriteInt(1, 14)
							net.SendToServer()

							surface.PlaySound(DropSound[math.random(1,3)])
		
							DealyUse = CurTime() + 2
						end
		
						local DeleteItem = vgui.Create("DButton", BTN_ITEM)
						DeleteItem:SetPos(0, 48)
						DeleteItem:SetSize(125, 24)
						DeleteItem:SetText('')
						DeleteItem.Hover = 0
						DeleteItem.Paint = function(self,w,h)
							if self:IsHovered() then
								draw.RoundedBoxEx(8, 0, 0, w, h, Col121, false, false, true, true)
							end
								
							draw.UIMaterial( 5, h/2-7, 14, 14, Color(215, 15, 15), MatDelete)
							
							draw.SimpleText( InDelete, 'inv.ui.16', 26, h/2, color_white, 0, 1 )
						end
						
						function DeleteItem:DoClick()
							if CurTime() < DealyUse then return end
							
							net.Start("INV.Delete")
								net.WriteInt(k, 14)
							net.SendToServer()

							surface.PlaySound(DeleteSound[math.random(1,3)])
		
							DealyUse = CurTime() + DealyTime
						end
					end
				end
			end

			for i=1, #self.Grid.Item:GetChildren() do
				child = self.Grid.Item:GetChildren()[i]
			end
		end

		timer.Create('ToScroll', 0.05, 1, function()
			if IsValid(self.Scroll) then
				self.Scroll = self.Scroll

				self.Scroll:ScrollTo(ScrollPos or 0)
			end
		end)

		self.Scroll:AddItem(self.Category)
		self.Category:DockPadding(0, -5, 0, 0)
	end
end

derma.DefineControl( "InventoryFrame", "А патамушта так", PANEL, "EditablePanel" )

concommand.Add('openinv', function()
	OpenInventory()
end)