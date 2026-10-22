if not SERVER then return end

local PLAYER = debug.getregistry().Player
local ENTITY = debug.getregistry().Entity

local AddShop = {
    ['zgo2_edible'] = true,
    ['base_food'] = true,
}


function PLAYER:PickUpItem(item)
	if not IsValid(item) then return end
	if not item:FCanPickUp(self) then return end
	if not self.inventory then self.inventory = self.inventory or {} end
	if item:GetClass() == 'base_seed' and item:GetModel() != 'models/props_lab/box01a.mdl' then return end
	if self:IsBanned() or self:IsArrested() or self:IsFrozen() or self:IsCuffed() or self:IsZiptied() then return end

	-- if item.StopDrop then return end
	-- print('dddddddddddddddd')

	if table.Count( self.inventory ) <= 0 then
		table.insert(self.inventory, {
			class = item:GetClass(), 
			canuse = INV.Items[item:GetClass()].CanUse or false, 
			color = INV.Items[item:GetClass()].color or nil, 
			save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
		})
	else
		for k, v in pairs(self.inventory) do
			if item:GetClass() == 'spawned_shipment' then
				if not self:CheckInventory() then return end

				table.insert(self.inventory, {
					class = item:GetClass(), 
					canuse = INV.Items[item:GetClass()].CanUse or false, 
					color = INV.Items[item:GetClass()].color or nil, 
					save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
				})

				break
				-- or item:GetClass() == 'zgo2_weedblock' 
			elseif item:GetClass() == 'zgo2_baggy' or item:GetClass() == 'zgo2_jar' then
				local WeedID = zgo2.Plant.GetID(item:GetWeedID())
				local WeedAmount = math.Round(item:GetWeedAmount())
				local WeedTHC = math.Round(item:GetWeedTHC())
				
				if self:HasItem(self.inventory, item) and v.save_data['model'] == item:GetModel() and v.save_data['WeedID'] == WeedID and v.save_data['WeedAmount'] == WeedAmount and v.save_data['WeedTHC'] == WeedTHC and v.save_data['amount'] + 1 < 11 then
					v.save_data['amount'] = v.save_data['amount'] + 1
					
					break
				elseif not self:HasItem(self.inventory, item) then
					if not self:CheckInventory() then return end

					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = INV.Items[item:GetClass()].CanUse or false, 
						color = INV.Items[item:GetClass()].color or nil, 
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
					})
			
					break
				end
			elseif item:GetClass() == 'zgo2_weedblock' then
				local WeedID = zgo2.Plant.GetID(item:GetWeedID())
				
				if self:HasItem(self.inventory, item) and v.save_data['model'] == item:GetModel() and v.save_data['WeedID'] == WeedID and v.save_data['amount'] + 1 < 11 then
					v.save_data['amount'] = v.save_data['amount'] + 1
					
					break
				elseif not self:HasItem(self.inventory, item) then
					if not self:CheckInventory() then return end
					-- print(save_data)
					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = INV.Items[item:GetClass()].CanUse or false, 
						color = INV.Items[item:GetClass()].color or nil, 
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
					})
			
					break
				end
			elseif item:GetClass() == 'zmlab2_item_meth' or item:GetClass() == 'zmlab2_item_crate' then
				local MethType = item:GetMethType()
				local MethAmount = item:GetMethAmount()
				local MethQuality = item:GetMethQuality()

				if self:HasItem(self.inventory, item) and v.save_data['model'] == item:GetModel() and v.save_data['MethType'] == MethType and v.save_data['MethAmount'] == MethAmount and v.save_data['MethQuality'] == MethQuality and v.save_data['amount'] + 1 < 11 then
					v.save_data['amount'] = v.save_data['amount'] + 1
				
					break
				elseif not self:HasItem(self.inventory, item) then
					if not self:CheckInventory() then return end

					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = INV.Items[item:GetClass()].CanUse or false, 
						color = INV.Items[item:GetClass()].color or nil, 
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
					})
			
					break
				end
			elseif item:GetClass() == 'zgo2_edible' then
				local WeedID = zgo2.Plant.GetID(item:GetWeedID())
				local WeedAmount = math.Round(item:GetWeedAmount())
				local WeedTHC = math.Round(item:GetWeedTHC())
				local EdibleID = item:GetEdibleID()

				if self:HasItem(self.inventory, item) and v.save_data['model'] == item:GetModel() and v.save_data['WeedID'] == WeedID and v.save_data['WeedAmount'] == WeedAmount and v.save_data['WeedTHC'] == WeedTHC and v.save_data['EdibleID'] == EdibleID and v.save_data['amount'] + 1 < 11 then
					v.save_data['amount'] = v.save_data['amount'] + 1
				
					break
				elseif not self:HasItem(self.inventory, item) then
					if not self:CheckInventory() then return end

					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = INV.Items[item:GetClass()].CanUse or false, 
						color = INV.Items[item:GetClass()].color or nil, 
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
					})
			
					break
				end
			elseif item:GetClass() == 'spawned_weapon' then
				if self:HasItem(self.inventory, item) and v.save_data['weaponclass'] == item.weaponclass and v.save_data['amount'] + 1 < 11 then
					v.save_data['amount'] = v.save_data['amount'] + 1
				
					break
				elseif not self:HasItem(self.inventory, item) then
					if not self:CheckInventory() then return end

					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = INV.Items[item:GetClass()].CanUse or false, 
						color = INV.Items[item:GetClass()].color or nil, 
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
					})
			
					break
				end
			elseif item:GetClass() == 'base_food' then
				if self:HasItem(self.inventory, item) and v.save_data['UniqueName'] == item.UniqueName and v.save_data['amount'] + 1 < 11 then
					v.save_data['amount'] = v.save_data['amount'] + 1
				
					break
				elseif not self:HasItem(self.inventory, item) then
					if not self:CheckInventory() then return end

					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = INV.Items[item:GetClass()].CanUse or false, 
						color = INV.Items[item:GetClass()].color or nil, 
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
					})
			
					break
				end
			elseif item:GetClass() == 'durgz_aspirin' or item:GetClass() == 'durgz_bathsalts' or item:GetClass() == 'durgz_beer'  or item:GetClass() == 'drugz_bleach'  or item:GetClass() == 'durgz_cigarette' or item:GetClass() == 'durgz_cocaine' or item:GetClass() == 'drugz_coffee' or item:GetClass() == 'durgz_heroine' or item:GetClass() == 'durgz_lsd' or item:GetClass() == 'durgz_meth' or item:GetClass() == 'drugz_milk' or item:GetClass() == 'durgz_mushroom' or item:GetClass() == 'drugz_soda' or item:GetClass() == 'durgz_water' or item:GetClass() == 'durgz_weed' then
				if self:HasItem(self.inventory, item) and v.save_data['amount'] + 1 < 11 then
					v.save_data['amount'] = v.save_data['amount'] + 1
					break
				elseif not self:HasItem(self.inventory, item) then
					if not self:CheckInventory() then return end
			
					table.insert(self.inventory, {
						class = item:GetClass(),
						canuse = INV.Items[item:GetClass()].CanUse or false,
						color = INV.Items[item:GetClass()].color or nil,
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {}
					})
			
					break
				end
			elseif item:GetClass() == 'bp_pill_bottle' then
				if not self:CheckInventory() then return end

				table.insert(self.inventory, {
					class = item:GetClass(), 
					canuse = INV.Items[item:GetClass()].CanUse or false, 
					color = INV.Items[item:GetClass()].color or nil, 
					save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
				})
		
				break
			elseif item:GetClass() == 'base_seed' then
				if self:HasItem(self.inventory, item) and v.save_data['SeedTabel'] == item:GetSeedBaseTabel() and v.save_data['amount'] + 1 < 11 then
					v.save_data['amount'] = v.save_data['amount'] + 1
					if self:GetNWInt('seeds') >= 1 then
						self:SetNWInt('seeds', self:GetNWInt('seeds')-1)
					end
					break
				elseif not self:HasItem(self.inventory, item) then
					if not self:CheckInventory() then return end

					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = INV.Items[item:GetClass()].CanUse or false, 
						color = INV.Items[item:GetClass()].color or nil, 
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {} 
					})
			
					break
				end
			else
				if self:HasItem(self.inventory, item) and v.class == item:GetClass() and v.save_data['amount'] + 1 < 11 then
					v.save_data['amount'] = v.save_data['amount'] + 1
				
					break
				elseif not self:HasItem(self.inventory, item) then
					if not self:CheckInventory() then return end

					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = false, 
						color = Color(225, 107, 0), 
						save_data = {
							['amount'] = 1,
							['model'] = item:GetModel(),
						}
					})
			
					break
				end
			end
		end
	end

	self:UpdateMysqlData()
	self:RefreshPlyInv()
	item:Remove()
end

function ENTITY:PickUpItem(item, price)
	if not IsValid(item) then return end
	if not self.inventory then self.inventory = self.inventory or {} end
	if not AddShop[item:GetClass()] then return end

	if table.Count( self.inventory ) <= 0 then
		table.insert(self.inventory, {
			class = item:GetClass(), 
			canuse = INV.Items[item:GetClass()].CanUse or false, 
			color = INV.Items[item:GetClass()].color or nil, 
			save_data = INV.Items[item:GetClass()].SaveItemData(item) or {},
			price = price or nil
		})
	else
		for k, v in pairs(self.inventory) do
			if item:GetClass() == 'zgo2_edible' then
				local WeedID = zgo2.Plant.GetID(item:GetWeedID())
				local WeedAmount = math.Round(item:GetWeedAmount())
				local WeedTHC = math.Round(item:GetWeedTHC())
				local EdibleID = item:GetEdibleID()

				if self:HasItem(self.inventory, item) and v.save_data['model'] == item:GetModel() and v.save_data['WeedID'] == WeedID and v.save_data['WeedAmount'] == WeedAmount and v.save_data['WeedTHC'] == WeedTHC and v.save_data['EdibleID'] == EdibleID then
					v.save_data['amount'] = v.save_data['amount'] + 1
				
					break
				elseif not self:HasItem(self.inventory, item) then
					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = INV.Items[item:GetClass()].CanUse or false, 
						color = INV.Items[item:GetClass()].color or nil, 
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {},
						price = price or nil
					})
			
					break
				end
			elseif item:GetClass() == 'base_food' then
				if self:HasItem(self.inventory, item) and v.save_data['UniqueName'] == item.UniqueName then
					v.save_data['amount'] = v.save_data['amount'] + 1
				
					break
				elseif not self:HasItem(self.inventory, item) then
					table.insert(self.inventory, {
						class = item:GetClass(), 
						canuse = INV.Items[item:GetClass()].CanUse or false, 
						color = INV.Items[item:GetClass()].color or nil, 
						save_data = INV.Items[item:GetClass()].SaveItemData(item) or {}, 
						price = price or nil
					})
			
					break
				end
			else
				return
			end
		end
	end

	item:Remove()
end

function ENTITY:HasItem(inventory, item)
	local amount = amount or 0
	local has = false
    
	for k, v in pairs(inventory) do
		if v.class != item:GetClass() then continue end

		if item:GetClass() == 'base_food' then 
			if v.save_data['UniqueName'] == item.UniqueName then
				has =  true
	
				break
			end
		elseif item:GetClass() == 'zgo2_edible' then 
			local WeedID = zgo2.Plant.GetID(item:GetWeedID())
			local WeedAmount = math.Round(item:GetWeedAmount())
			local WeedTHC = math.Round(item:GetWeedTHC())
			local EdibleID = item:GetEdibleID()

			if v.class == item:GetClass() and v.save_data['WeedID'] == WeedID and v.save_data['WeedAmount'] == WeedAmount and v.save_data['WeedTHC'] == WeedTHC and v.save_data['EdibleID'] == EdibleID then
				has =  true
	
				break
			end
		end
	end

	return has
end

function PLAYER:HasItem(inventory, item)
	local amount = amount or 0
	local has = false
    
	for k, v in pairs(inventory) do
		if v.class != item:GetClass() then continue end
		if v.save_data['amount'] + 1 > 10 then continue end 
		if v.save_data['amount'] >= 10 then continue end 

		if item:GetClass() == 'base_food' then 
			if v.save_data['UniqueName'] == item.UniqueName then
				has =  true
	
				break
			end
		elseif item:GetClass() == 'base_seed' then 
			if v.save_data['SeedTabel'] == item:GetSeedBaseTabel() then
				has =  true
	
				break
			end
		elseif item:GetClass() == 'durgz_aspirin' or item:GetClass() == 'durgz_bathsalts' or item:GetClass() == 'durgz_beer'  or item:GetClass() == 'drugz_bleach'  or item:GetClass() == 'durgz_cigarette' or item:GetClass() == 'durgz_cocaine' or item:GetClass() == 'drugz_coffee' or item:GetClass() == 'durgz_heroine' or item:GetClass() == 'durgz_lsd' or item:GetClass() == 'durgz_meth' or item:GetClass() == 'drugz_milk' or item:GetClass() == 'durgz_mushroom' or item:GetClass() == 'drugz_soda' or item:GetClass() == 'durgz_water' or item:GetClass() == 'durgz_weed' then
			if v.class == item:GetClass() then
				has = true
				break
			end
		elseif item:GetClass() == 'spawned_weapon' then 
			if v.save_data['weaponclass'] == item.weaponclass then
				has =  true
	
				break
			end
		elseif item:GetClass() == 'zgo2_edible' then 
			local WeedID = zgo2.Plant.GetID(item:GetWeedID())
			local WeedAmount = math.Round(item:GetWeedAmount())
			local WeedTHC = math.Round(item:GetWeedTHC())
			local EdibleID = item:GetEdibleID()

			if v.class == item:GetClass() and v.save_data['WeedID'] == WeedID and v.save_data['WeedAmount'] == WeedAmount and v.save_data['WeedTHC'] == WeedTHC and v.save_data['EdibleID'] == EdibleID then
				has =  true
	
				break
			end
		elseif item:GetClass() == 'zgo2_baggy' or item:GetClass() == 'zgo2_jar' then
			local WeedID = zgo2.Plant.GetID(item:GetWeedID())
			local WeedAmount = math.Round(item:GetWeedAmount())
			local WeedTHC = math.Round(item:GetWeedTHC())

			if v.class == item:GetClass() and v.save_data['WeedID'] == WeedID and v.save_data['WeedAmount'] == WeedAmount and v.save_data['WeedTHC'] == WeedTHC then
				has =  true
	
				break
			end
		elseif item:GetClass() == 'zgo2_weedblock' then
			local WeedID = zgo2.Plant.GetID(item:GetWeedID())

			if v.class == item:GetClass() and v.save_data['WeedID'] == WeedID then
				has =  true
	
				break
			end
		elseif item:GetClass() == 'zmlab2_item_meth' or item:GetClass() == 'zmlab2_item_crate' then
			local MethType = item:GetMethType()
			local MethAmount = item:GetMethAmount()
			local MethQuality = item:GetMethQuality()

			if v.class == item:GetClass() and v.save_data['MethType'] == MethType and v.save_data['MethAmount'] == MethAmount and v.save_data['MethQuality'] == MethQuality then
				has =  true
	
				break
			end
		else
			if v.class == item:GetClass() then
				has =  true

				break
			end
		end
	end

	return has
end

function PLAYER:CheckInventory()
	if table.Count(self.inventory) + 1 > self:GetMaxInv() then
		rp.Notify(self, NOTIFY_ERROR, "Инвентарь заполнен!")

		return false
	else
		return true
	end
end

function PLAYER:UpdateMysqlData()
	if not self.inventory then return end
	rp._Stats:Query('UPDATE player_inventory SET inventory=? WHERE SteamID=' .. self:SteamID64() .. ';', util.TableToJSON(self.inventory), function(e) end)
end

function PLAYER:RefreshPlyInv()
	if not IsValid(self) then return end
	if not self:Alive() then return end

	net.Start("INV.RefreshPlyInv")
		net.WriteTable(self.inventory or {})
	net.Send(self)
end

function ENTITY:RefreshEntInv(ply)
	if not IsValid(self) then return end
	if not ply:Alive() then return end

	net.Start("INV.RefreshEntInv")
		net.WriteTable(self.inventory or {})
		net.WriteTable(ply.inventory or {})
	net.Send(ply)
end

function ENTITY:OpenEntity(ply)
	if not IsValid(self) then return end
	if not ply:Alive() then return end

	net.Start("INV.OpenEntity")
		net.WriteTable(self.inventory or {})
		net.WriteTable(ply.inventory or {})
		net.WriteEntity(self)
	net.Send(ply)
end

function ENTITY:FCanPickUp(ply)
	if not INV.Items[self:GetClass()] then return false end

	return true
end

net.Receive("INV.AddItemItem",function(len,ply)	
	if ply.DealyInventory > CurTime() then return end

	if not ply:Alive() then return end

	local ent = net.ReadEntity()
	local id = net.ReadInt(14)
	local price = net.ReadInt(18)
	
	if not IsValid(ent) then return end
	if not ply.inventory[id] then return end 
	if not ent:CPPIGetOwner() or ent:CPPIGetOwner() != ply then return end
	
	local item_tb = ply.inventory[id]
	local oldAmount = ply.inventory[id].save_data['amount']

	ply.inventory[id].save_data['amount'] = 1

	local item = ents.Create( item_tb.class )
	INV.Items[item_tb.class].LoadItemData(item, item_tb.save_data)

	ent:PickUpItem(item, price)

	if oldAmount - 1 <= 0 then
		ply.inventory[id] = nil
	else
		ply.inventory[id].save_data['amount'] = oldAmount - 1
	end

	ent:RefreshEntInv(ply)

	ply.DealyInventory = CurTime() + INV.pickup_time
end)

net.Receive("INV.BuyItem",function(len,ply)	
	if ply.DealyInventory > CurTime() then return end
	if not ply:Alive() then return end

	local ent = net.ReadEntity()
	local id = net.ReadInt(14)
	local price = net.ReadInt(18)

	//print(ent, id, price, '<<====')
	
	if not IsValid(ent) then return end
	if not ent.inventory[id] then return end 
	if ent:CPPIGetOwner() and ent:CPPIGetOwner() != ply then 
		if price > ply:GetMoney() then 
			rp.Notify(ply, NOTIFY_ERROR, "Не хватает денег!")

			return 
		end
	end
	
	local item_tb = ent.inventory[id]
	local oldAmount = ent.inventory[id].save_data['amount']

	ent.inventory[id].save_data['amount'] = 1

	local item = ents.Create( item_tb.class )
	INV.Items[item_tb.class].LoadItemData(item, item_tb.save_data)

	ply:PickUpItem(item)

	if ent:CPPIGetOwner() != ply then
		ply:TakeMoney(price)
		ent:CPPIGetOwner():AddMoney(price)
		
		rp.Notify(ent:CPPIGetOwner(), NOTIFY_ERROR, ply:GetName().."купил: "..item_tb.save_data['name'] or ''..' за '..rp.FormatMoney(price))
		rp.Notify(ply, NOTIFY_ERROR, "Вы купили: "..item_tb.save_data['name'] or ''..' за '..rp.FormatMoney(price))
	else
		rp.Notify(ply, NOTIFY_ERROR, "Вы вернули: "..item_tb.save_data['name'] or ''..' в инвентарь')
	end

	if oldAmount - 1 <= 0 then
		ent.inventory[id] = nil
	else
		ent.inventory[id].save_data['amount'] = oldAmount - 1
	end

	ent:RefreshEntInv(ply)
	
	ply.DealyInventory = CurTime() + INV.pickup_time
end)

net.Receive("INV.MoreDrop",function(len,ply)
	if ply.DealyInventory > CurTime() then return end
	if not ply:Alive() then return end
	if ply:IsBanned() or ply:IsArrested() or ply:IsFrozen() or ply:GetNWBool('isHandcuffed') or ply:IsZiptied() then return end

	local id = net.ReadInt(14)
	local val = net.ReadInt(14)
	if not ply.inventory[id] then return end

	local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 50, ply ).HitPos

	local item_tb = ply.inventory[id]
	local oldAmount = ply.inventory[id].save_data['amount']

	if ply:GetCount(item_tb.class) >= 8 then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('ItemLimit'), INV.Languge[item_tb.class] or item_tb.class)
		return
	end

	ply.inventory[id].save_data['amount'] = val

	local item = ents.Create( item_tb.class )
	INV.Items[item_tb.class].LoadItemData(item, item_tb.save_data)

	item.ItemOwner = ply

	if item:GetClass() == 'zgo2_edible' then
		local EdibleData = zgo2.Edible.GetData(item:GetEdibleID())
		
		if EdibleData then
			item:SetModel(EdibleData.edible_model)
		end
	end

	if item:GetClass() == 'base_seed' then
		if ply:GetNWInt('seeds') >= 15 then return end
		ply:SetNWInt('seeds', ply:GetNWInt('seeds')+1 or 1)
		rp.Notify(ply, NOTIFY_GENERIC, 'Выброшено '..ply:GetNWInt('seeds')..' из 15 коробок семян.')
	end

	if zclib then
		zclib.Player.SetOwner(item, ply)
	end

	if oldAmount - val <= 0 then
		ply.inventory[id] = nil
	else
		ply.inventory[id].save_data['amount'] = oldAmount - val
	end

	item:SetPos( spawn_pos )
	item:Spawn()

	ply:_AddCount(item_tb.class, item)

	ply:UpdateMysqlData()
	ply:RefreshPlyInv()

	ply.DealyInventory = CurTime() + INV.pickup_time
end)

net.Receive("INV.Delete",function(len,ply)
	if ply.DealyInventory > CurTime() then return end

	if not ply:Alive() then return end
	local id = net.ReadInt(14)
	if not ply.inventory[id] then return end
	
	local item_tb = ply.inventory[id]

	if item_tb.save_data['amount'] <= 1 then
		ply.inventory[id] = nil
	elseif item_tb.save_data['amount'] > 1 then
		ply.inventory[id].save_data['amount'] = ply.inventory[id].save_data['amount'] - 1
	end

	ply:UpdateMysqlData()
	ply:RefreshPlyInv()

	ply.DealyInventory = CurTime() + INV.pickup_time
end)

net.Receive("INV.Use",function(len,ply)
	if ply.DealyInventory > CurTime() then return end

	if not ply:Alive() then return end
	local id = net.ReadInt(14)
	if not ply.inventory[id] then return end
	if not INV.Items[ply.inventory[id].class].CanUse then return end
	if ply:IsBanned() or ply:IsArrested() or ply:IsFrozen() or ply:GetNWBool('isHandcuffed') or ply:IsZiptied() then return end

	ply.inventory[id] = INV.Items[ply.inventory[id].class].OnUse(ply, ply.inventory[id])

	ply:UpdateMysqlData()
	ply:RefreshPlyInv()

	ply.DealyInventory = CurTime() + INV.pickup_time
end)

local DealyPickUP = 0
hook.Add( "PlayerButtonDown", "PickupItem", function( ply, key )
	if not ply.DealyPickUP then ply.DealyPickUP = 0 end

	if key == KEY_LALT then
		DealyPickUP = CurTime() + 1
	elseif key == KEY_E and DealyPickUP and DealyPickUP > CurTime() then
		local ent = ply:GetEyeTrace().Entity

		if not INV.Items[ent:GetClass()] then return end
		if ply:GetPos():Distance(ent:GetPos()) > INV.pickup_distance then return end
		if ply.DealyInventory and ply.DealyInventory > CurTime() then return end

		if not ent:FCanPickUp(ply) then
			ply:Notify(NOTIFY_ERROR, "Вы не можете положить это в инвентарь")
			return
		end

		ply:PickUpItem(ent)

		ply.DealyInventory = CurTime() + INV.pickup_time
	end
end )

concommand.Add( "RefreshInventory", function( ply, cmd, args )
end )

util.AddNetworkString('INV:DAUNOPEN')

net.Receive('INV:DAUNOPEN', function(len, ply)
	ply:UpdateMysqlData()
	ply:RefreshPlyInv()
end)

hook.Add('PlayerAuthed', 'inv::refresh', function(ply)
	timer.Simple(1, function()
		if IsValid(ply) then
			ply:UpdateMysqlData()
			ply:RefreshPlyInv()
		end
	end)
end)

concommand.Add('pizdec', function(pl)
	rp._Stats:Query('UPDATE player_inventory SET inventory="[]" WHERE SteamID=' .. pl:SteamID64() .. ';')
	pl.inventory = {}
end)