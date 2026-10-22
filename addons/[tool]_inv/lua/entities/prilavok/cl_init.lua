include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	local x = math.sin(CurTime() * math.pi) * 30
	local material = Material 'materials/hud/prilavok.png'

	local inView, dist = self:InDistance(150000)

	//if (not inView) then return end

	local alpha = 255 - (dist/590)


	//color_white.a = alpha
//
	//color_black.a = alpha


	if self:GetPos():Distance(LocalPlayer():GetPos()) < 600 then
		if (not inView) then return end
		cam.Start3D2D(self:LocalToWorld(Vector(2, -5, 25)), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.04)
		surface.SetDrawColor(255, 255, 255, alpha)

		surface.SetMaterial(material)

		surface.DrawTexturedRect(15, x-1200, 128, 128)
			draw.SimpleTextOutlined('Прилавок', '3d2d', 80, x-950, ColorAlpha(color_white,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		cam.End3D2D()
	end
end

local LocalPlayer_Inventory = {}
local LocalEntity_Inventory = {}
local FoodClass = {
	['base_food'] = true,
	['zgo2_edible'] = true,
}

local ScrollPos, ScrollPos2

local int = ' из '
local num = 'x'
local Title = 'Инвентарь'
local TitleEnt = 'Прилавок'
local InUse = 'Использовать'
local ToDrop = 'Бросить'
local InDelete = 'Удалить'
local NotItem = 'Пустой'
local CountItem = 'Всего предметов: '

local MatDelete = Material('ui/delete.png')
local MatDrop = Material('ui/drop.png')
local MatUse = Material('ui/use.png')
local MatInventory = Material('ui/inventory.png')

local Col121 = Color(121,121,121)
local Col125 = Color(125,125,125)
local Col44 = Color(44,44,44)
local ColOrange = Color(255,122,0)
local Col57 = Color(57,57,57)
local Col87 = Color(87,87,87)
local Col50 = Color(50,50,50)
local Col40 = Color(40,40,40, 240)

local DropSound = {
	[1] = 'physics/wood/wood_crate_impact_soft2.wav',
	[2] = 'physics/wood/wood_box_impact_soft3.wav',
	[3] = 'physics/wood/wood_crate_impact_soft1.wav',
}

function draw.UIMaterial( x, y, w, h, ColorMat, Mat )
	draw.NoTexture()
	surface.SetDrawColor(ColorMat)
	surface.SetMaterial( Mat )
	surface.DrawTexturedRect( x, y, w, h ) 
end

function draw.UIText(Text, Font, w, h, ColorText, xAlign, yAlign)
	draw.Text( {
		text = Text,
		font = Font,
		pos = { w, h },
		color = ColorText,
		xalign = xAlign,
		yalign = yAlign
	} )
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

local function HasItem(inventory, item)
	local amount = amount or 0
	local has = false
    
	for k, v in pairs(inventory) do
		if v.class != item.class then continue end

		if item.class == 'base_food' then 
			if v.save_data['UniqueName'] == item.save_data['UniqueName'] then
				has =  true
	
				break
			end
		elseif item.class == 'zgo2_edible' then 
			local WeedID = item.save_data['WeedID']
			local WeedAmount = item.save_data['WeedAmount']
			local WeedTHC = item.save_data['WeedTHC']
			local EdibleID = item.save_data['EdibleID']

			if v.class == item.class and v.save_data['WeedID'] == WeedID and v.save_data['WeedAmount'] == WeedAmount and v.save_data['WeedTHC'] == WeedTHC and v.save_data['EdibleID'] == EdibleID then
				has =  true
	
				break
			end
		end
	end

	return has
end

local function OpenEntity(class)
	local ply = LocalPlayer()
	local scrw,scrh = ScrW(), ScrH()
	local CountEnt, CountPly = 0,0 

	if IsValid(rp.PanelEntShop) then
        rp.PanelEntShop:Remove()
    end

	rp.PanelEntShop = vgui.Create("EditablePanel")
	rp.PanelEntShop:SetPos(scrw/2-300, scrh/2-300 )
	rp.PanelEntShop:SetSize(600, 600)
	rp.PanelEntShop:SetAlpha(0)
    rp.PanelEntShop:AlphaTo(255, 0.4, 0) 
	rp.PanelEntShop:MakePopup()

	function rp.PanelEntShop:Paint( w, h )
		if not ply:Alive() then self:Remove() end

		local X, Y = self:LocalCursorPos( 0, 0 )

		if input.IsMouseDown( MOUSE_LEFT ) then
			if X < 0 or X > w or Y < 0 or Y > h then 
				self:MoveTo(scrw/2-300, scrh/2, 0.3, 0, 0.2)
				self:AlphaTo(0, 0.15, 0, function()						
					self:Remove()
				end)

				return
			end
		end

		if input.IsKeyDown( KEY_LCONTROL ) then
			HasDown = true 
		else
			HasDown = false
		end
	end

	local EntInv = vgui.Create("Panel", rp.PanelEntShop)
	EntInv:SetPos(0, rp.PanelEntShop:GetTall()/2)
	EntInv:MoveTo(0,0, 0.3, 0, 0.2)
	EntInv:SetSize(600, 290)
	EntInv.Paint = function(self,w,h)
		draw.RoundedBox(8, 0, 0, w, h, INV.BackgroundColor) 
		draw.RoundedBox(8, 0, 0, w, 50, INV.BaseColor) 

		if CountEnt <= 0 then
			draw.UIText( NotItem, 'ui.20', w-20, 12, color_white, 2, 0 )  
		else
			draw.UIText( CountItem..CountEnt, 'ui.20', w-20, 12, color_white, 2, 0 )  
		end
		
		draw.UIText( TitleEnt, 'ui.20', 15, 12, color_white, 0, 0 )  
	end

	local PlyInv = vgui.Create("Panel", rp.PanelEntShop)
	PlyInv:SetPos(0, rp.PanelEntShop:GetTall()/2)
	PlyInv:MoveTo(0,rp.PanelEntShop:GetTall()/2+5, 0.3, 0, 0.2)
	PlyInv:SetSize(600, 290)
	PlyInv.Paint = function(self,w,h)
		local items = CountItem..CountPly..'('..table.Count(LocalPlayer_Inventory)-CountPly..')'..int..ply:GetMaxInv()

		draw.RoundedBox(8, 0, 0, w, h, INV.BackgroundColor) 
		draw.RoundedBox(8, 0, 0, w, 50, INV.BaseColor) 

		draw.UIText( items, 'ui.20', w-20, 12, color_white, 2, 0 )  
		draw.UIText( Title, 'ui.20', 15, 12, color_white, 0, 0 )  
	end

	function RefreshShopPly()
		local Key = 0

		CountPly = 0
		
		if IsValid(PlyInv.Scroll) then
			PlyInv.Scroll:Remove()
			PlyInv.Scroll = nil
		end

		PlyInv.Scroll = vgui.Create("DScrollPanel", PlyInv)
		PlyInv.Scroll:SetSize(PlyInv:GetWide() - 20, PlyInv:GetTall()-70)
		PlyInv.Scroll:SetPos(10, 60)
		PlyInv.Scroll.Paint = function(self,w,h)
			if CountPly >= 6 then
				draw.RoundedBox(8, 0, 0, w-20, h, INV.BaseColor)  
			else
				draw.RoundedBox(8, 0, 0, w, h, INV.BaseColor)  
			end
		end

		PlyInv.Scroll.VBar:SetHideButtons( true )
		PlyInv.Scroll.VBar:SetWide(8)
		function PlyInv.Scroll.VBar.btnGrip.Paint(w, h)
			draw.RoundedBox(8, 0, 0, 8, PlyInv.Scroll.VBar.btnGrip:GetTall(), INV.ScrollColor) 
		end

		PlyInv.Scroll.VBar.Paint = function(self, w, h) 
			draw.RoundedBox(8, 0, 0, 8, h, INV.ScrollBarColor) 
		end

		function PlyInv.Scroll:OnRemove()
			ScrollPos = self.VBar:GetOffset() or 0
		end

		PlyInv.Grid = vgui.Create( 'DIconLayout', PlyInv.Scroll )
		PlyInv.Grid:Dock(TOP)
		PlyInv.Grid:DockMargin(10, 10, 0, 0)
		PlyInv.Grid:DockPadding(0,0,0,10)
		PlyInv.Grid:SetSpaceY( 10 )
		PlyInv.Grid:SetSpaceX( 10 )

		for k, v in pairs(LocalPlayer_Inventory) do	
			if not FoodClass[v.class] then continue end

			local posx, posy, fov, x, y, count, child

			CountPly = CountPly + 1

			if INV.ModelPos[v.class] then
				posx, posy, fov = INV.ModelPos[v.class].pos, INV.ModelPos[v.class].ang, INV.ModelPos[v.class].fov
			else
				posx, posy, fov = Vector(0,0,35), Angle(0,45,0), 20
			end
			
			PlyInv.Grid.Item = vgui.Create("Panel", PlyInv.Grid)
			PlyInv.Grid.Item:SetSize(100, 100)
			PlyInv.Grid.Item.Hover = 0
			PlyInv.Grid.Item.Paint = function(self,w,h)
				if IsValid(child) and child:IsHovered() then
					self.Hover = Lerp(FrameTime()*12, self.Hover, 255)
				else
					self.Hover = Lerp(FrameTime()*12, self.Hover, 0)
				end

				draw.RoundedBox(8, 0, 0, w, h, INV.ItemColor)  
				draw.RoundedBox(8, 0, 0, w, h, ColorAlpha(INV.ItemColorHover,self.Hover))
			end

			if v.save_data['model'] ~= nil then
				if v.class == 'spawned_weapon' or v.class == 'base_food' or v.class == 'spawned_shipment' then
					local ModelItem = vgui.Create( "SpawnIcon", PlyInv.Grid.Item )
					ModelItem:Dock(FILL)
					ModelItem:DockMargin(5, 5, 5, 5)
					ModelItem:SetAlpha(100)

					if v.class == 'spawned_shipment' then
						local contents = v.save_data['content']

						ModelItem:SetModel( rp.shipments[contents].model )
					else
						ModelItem:SetModel( v.save_data['model'] )
					end
				else
					local ModelItem = vgui.Create( "DModelPanel", PlyInv.Grid.Item )
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
					ModelItem:SetAlpha(100)

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

			if v.save_data['name'] then
				local NameItem = vgui.Create('DLabel', PlyInv.Grid.Item)
				NameItem:SetPos(10,5)
				NameItem:SetSize(80,90)
				NameItem:SetFont('ui.16')
				NameItem:SetText(v.save_data['name'])
				NameItem:SetWrap(true)
				NameItem:SetAutoStretchVertical(true )
				NameItem:SetTextColor(color_white)
			end

			count = v.save_data['amount']..num

			if v.save_data['count'] and v.save_data['amount'] > 0 then
				count = v.save_data['count']..num
			elseif v.save_data['UsesLeft'] and v.save_data['amount'] > 0 then
				count = v.save_data['UsesLeft']..num
			end

			surface.SetFont('Inv | Item')
			x, y = surface.GetTextSize(count)

			x = x + 10

			local ItemInfo = vgui.Create("Panel", PlyInv.Grid.Item)
			ItemInfo:Dock(FILL)
			ItemInfo:SetText('')
			ItemInfo.Hover = 0
			ItemInfo.Paint = function(self,w,h)
				draw.UIText( count, 'Inv | Item', w-10, h-25, color_white, 2, 0 )
			end

			local DealyUse = CurTime() + 0.5

			function ItemInfo:OnMousePressed(key)
				if CurTime() < DealyUse then return end

				if key == MOUSE_LEFT then
					if class:GetNWEntity('PropOwner') and class:GetNWEntity('PropOwner') == ply then
						if HasItem(LocalEntity_Inventory, v) then
							net.Start("INV.AddItemItem")
								net.WriteEntity(class)
								net.WriteInt(k, 14)
								net.WriteInt(0, 18)
							net.SendToServer()
						else
							ui.NumberRequest('Продажа товара', 'Укажите стоимость от 0 до 100.000$', 0, 0, 100000, function(a)
								net.Start("INV.AddItemItem")
									net.WriteEntity(class)
									net.WriteInt(k, 14)
									net.WriteInt(a, 18)
								net.SendToServer()
							end)
						end
					end

					DealyUse = CurTime() + 0.5
				end
			end

			for i=1, #PlyInv.Grid.Item:GetChildren() do
				child = PlyInv.Grid.Item:GetChildren()[i]
			end
		end

		PlyInv.Scroll:AddItem(PlyInv.Grid)

		if IsValid(PlyInv.Scroll) and ScrollPos then
			PlyInv.Scroll.VBar = PlyInv.Scroll.VBar

			PlyInv.Scroll.VBar:AnimateTo( -ScrollPos or 0 , 0, 0, 0 )
		end
	end

	function RefreshShopEnt()
		local Key = 0
		CountEnt = 0
		
		if IsValid(EntInv.Scroll) then
			EntInv.Scroll:Remove()
			EntInv.Scroll = nil
		end

		EntInv.Scroll = vgui.Create("DScrollPanel", EntInv)
		EntInv.Scroll:SetSize(EntInv:GetWide() - 20, EntInv:GetTall()-70)
		EntInv.Scroll:SetPos(10, 60)
		EntInv.Scroll.Paint = function(self,w,h)
			if CountEnt >= 6 then
				draw.RoundedBox(8, 0, 0, w-20, h, INV.BaseColor)  
			else
				draw.RoundedBox(8, 0, 0, w, h, INV.BaseColor)  
			end
		end

		EntInv.Scroll.VBar:SetHideButtons( true )
		EntInv.Scroll.VBar:SetWide(8)
		function EntInv.Scroll.VBar.btnGrip.Paint(w, h)
			draw.RoundedBox(8, 0, 0, 8, EntInv.Scroll.VBar.btnGrip:GetTall(), INV.ScrollColor) 
		end

		EntInv.Scroll.VBar.Paint = function(self, w, h) 
			draw.RoundedBox(8, 0, 0, 8, h, INV.ScrollBarColor) 
		end

		function EntInv.Scroll:OnRemove()
			ScrollPos2 = self.VBar:GetOffset() or 0
		end

		EntInv.Grid = vgui.Create( 'DIconLayout', EntInv.Scroll )
		EntInv.Grid:Dock(TOP)
		EntInv.Grid:DockMargin(10, 10, 0, 0)
		EntInv.Grid:DockPadding(0,0,0,10)
		EntInv.Grid:SetSpaceY( 10 )
		EntInv.Grid:SetSpaceX( 10 )

		for k, v in pairs(LocalEntity_Inventory) do	
			if not FoodClass[v.class] then continue end

			CountEnt = CountEnt + 1

			local posx, posy, fov, x, y, count, child

			if INV.ModelPos[v.class] then
				posx, posy, fov = INV.ModelPos[v.class].pos, INV.ModelPos[v.class].ang, INV.ModelPos[v.class].fov
			else
				posx, posy, fov = Vector(0,0,35), Angle(0,45,0), 20
			end
			
			EntInv.Grid.Item = vgui.Create("Panel", EntInv.Grid)
			EntInv.Grid.Item:SetSize(100, 100)
			EntInv.Grid.Item.Hover = 0
			EntInv.Grid.Item.Paint = function(self,w,h)
				if IsValid(child) and child:IsHovered() then
					self.Hover = Lerp(FrameTime()*12, self.Hover, 255)
				else
					self.Hover = Lerp(FrameTime()*12, self.Hover, 0)
				end

				draw.RoundedBox(8, 0, 0, w, h, INV.ItemColor)  
				draw.RoundedBox(8, 0, 0, w, h, ColorAlpha(INV.ItemColorHover,self.Hover))
			end

			if v.save_data['model'] ~= nil then
				if v.class == 'spawned_weapon' or v.class == 'base_food' or v.class == 'spawned_shipment' then
					local ModelItem = vgui.Create( "SpawnIcon", EntInv.Grid.Item )
					ModelItem:Dock(FILL)
					ModelItem:DockMargin(5, 5, 5, 5)
					ModelItem:SetAlpha(100)

					if v.class == 'spawned_shipment' then
						local contents = v.save_data['content']

						ModelItem:SetModel( rp.shipments[contents].model )
					else
						ModelItem:SetModel( v.save_data['model'] )
					end
				else
					local ModelItem = vgui.Create( "DModelPanel", EntInv.Grid.Item )
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
					ModelItem:SetAlpha(100)

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

			if v.save_data['name'] then
				if v.price then
					v.save_data['name'] = v.save_data['name'] ..' - '.. rp.FormatMoney(v.price)
				end

				local NameItem = vgui.Create('DLabel', EntInv.Grid.Item)
				NameItem:SetPos(10,5)
				NameItem:SetSize(80,90)
				NameItem:SetFont('ui.16')
				NameItem:SetText(v.save_data['name'])
				NameItem:SetWrap(true)
				NameItem:SetAutoStretchVertical(true )
				NameItem:SetTextColor(color_white)
			end

			count = v.save_data['amount']..num

			if v.save_data['count'] and v.save_data['amount'] > 0 then
				count = v.save_data['count']..num
			elseif v.save_data['UsesLeft'] and v.save_data['amount'] > 0 then
				count = v.save_data['UsesLeft']..num
			end

			surface.SetFont('Inv | Item')
			x, y = surface.GetTextSize(count)

			x = x + 10

			local ItemInfo = vgui.Create("Panel", EntInv.Grid.Item)
			ItemInfo:Dock(FILL)
			ItemInfo:SetText('')
			ItemInfo.Hover = 0
			ItemInfo.Paint = function(self,w,h)
				draw.UIText( count, 'Inv | Item', w-10, h-25, color_white, 2, 0 )
			end

			local DealyUse = CurTime() + 0.5

			function ItemInfo:OnMousePressed(key)
				if CurTime() < DealyUse then return end

				if key == MOUSE_LEFT then
					if v.price and v.price <= ply:GetMoney() then
						net.Start("INV.BuyItem")
							net.WriteEntity(class)
							net.WriteInt(k, 14)
							net.WriteInt(v.price, 18)
						net.SendToServer()
					end

					DealyUse = CurTime() + 0.5
				end
			end

			for i=1, #EntInv.Grid.Item:GetChildren() do
				child = EntInv.Grid.Item:GetChildren()[i]
			end
		end

		EntInv.Scroll:AddItem(EntInv.Grid)

		if IsValid(EntInv.Scroll) and ScrollPos2 then
			EntInv.Scroll.VBar = EntInv.Scroll.VBar

			EntInv.Scroll.VBar:AnimateTo( -ScrollPos2 or 0 , 0, 0, 0 )
		end
	end

	RefreshShopPly()
	RefreshShopEnt()
end

net.Receive("INV.OpenEntity",function()
	local ent = net.ReadTable() or {}
	local ply = net.ReadTable() or {}
	local class = net.ReadEntity()

	LocalPlayer_Inventory = ply
	LocalEntity_Inventory = ent

	OpenEntity(class)
end)

net.Receive("INV.RefreshEntInv",function()
	local ent = net.ReadTable() or {}
	local ply = net.ReadTable() or {}

	LocalPlayer_Inventory = ply
	LocalEntity_Inventory = ent
	
	if IsValid(rp.PanelEntShop) then
		RefreshShopPly()
		RefreshShopEnt()
	end
end)
