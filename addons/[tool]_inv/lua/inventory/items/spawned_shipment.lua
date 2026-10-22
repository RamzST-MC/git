local ITEM = {}

ITEM.class = "spawned_shipment"

ITEM.color = Color(120,170,250)

ITEM.CanUse = true

function ITEM.SaveItemData(ent)
	local tb = {}

	local content = ent:Getcontents() or ''
	local contents = rp.shipments[content]
	contents = contents.name

	tb['amount'] = ent.amount or 1
	
	tb['name'] = contents
	tb['model'] = ent:GetModel()

	tb['clip1'] = ent.clip1
	tb['clip2'] = ent.clip2
	local class = rp.shipments[ent:Getcontents()].entity
	tb['ammoadd'] = ent.ammoadd or (weapons.Get(class) and weapons.Get(class).Primary.DefaultClip)
	tb['content'] = ent:Getcontents() or ''
	tb['count'] = ent:Getcount() or 1

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent:Setcontents(tb['content'])
	ent:Setcount(tb['count'])
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(ply, tb)
	local wep = rp.shipments[tb['save_data']['content']]
	
	if not wep then return nil end

	if wep['entity'] == "ent_licence" then
		if ply:HasLicense() then 
			rp.Notify(ply, NOTIFY_HINT, "Вы уже имеете лицензию")
			return tb
		end

		if tb['save_data']['count'] > 0 then 
			if tb['save_data']['count'] <= 1 then
				rp.Notify(ply, 3, 4, "Вы активировали лицензию!")
				ply:SetNetVar("HasGunlicense", true)

				return nil
			elseif tb['save_data']['count'] > 1 then
				tb['save_data']['count'] = tb['save_data']['count'] - 1

				rp.Notify(ply, 3, 4, "Вы активировали лицензию!")
				ply:SetNetVar("HasGunlicense", true)
		
				return tb
			end
		end

		return tb
	end

	if wep['entity'] == "armor_piece_full" then
		if tb['save_data']['count'] > 0 then 
			if tb['save_data']['count'] <= 1 then
				
				local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
				local item = ents.Create( "armor_piece_full" )

				spawn_pos.z = spawn_pos.z + 10
				
				item.ItemOwner = ply
				item:SetPos( spawn_pos )
				item:Spawn()

				timer.Create('RemoveDropItem_'..item:EntIndex(), 120, 1, function()
					if IsValid(item) then
						item:Remove()
					end
				end)

				return nil
			elseif tb['save_data']['count'] > 1 then
				tb['save_data']['count'] = tb['save_data']['count'] - 1

				local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
				local item = ents.Create( "armor_piece_full" )

				spawn_pos.z = spawn_pos.z + 10

				item.ItemOwner = ply
				item:SetPos( spawn_pos )
				item:Spawn()

				timer.Create('RemoveDropItem_'..item:EntIndex(), 120, 1, function()
					if IsValid(item) then
						item:Remove()
					end
				end)
		
				return tb
			end
		end

		return tb
	end

	if wep['entity'] == "ent_disguise" then
		if tb['save_data']['count'] > 0 then 
			if tb['save_data']['count'] <= 1 then
				
				local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
				local item = ents.Create( "ent_disguise" )

				spawn_pos.z = spawn_pos.z + 10

				item.ItemOwner = ply
				item:SetPos( spawn_pos )
				item:Spawn()

				timer.Create('RemoveDropItem_'..item:EntIndex(), 120, 1, function()
					if IsValid(item) then
						item:Remove()
					end
				end)

				return nil
			elseif tb['save_data']['count'] > 1 then
				tb['save_data']['count'] = tb['save_data']['count'] - 1

				local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
				local item = ents.Create( "ent_disguise" )

				spawn_pos.z = spawn_pos.z + 10

				item.ItemOwner = ply
				item:SetPos( spawn_pos )
				item:Spawn()

				timer.Create('RemoveDropItem_'..item:EntIndex(), 120, 1, function()
					if IsValid(item) then
						item:Remove()
					end
				end)
		
				return tb
			end
		end

		return tb
	end

	if tb['save_data']['count'] > 0 then 
		if tb['save_data']['count'] <= 1 then
			
			local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
			local Weapons = ply:Give(wep['entity'], false)

			spawn_pos.z = spawn_pos.z + 10

			if IsEntity( Weapons ) and Weapons != NULL then
				Weapons.ItemOwner = ply
				Weapons:SetPos( spawn_pos )

				if IsValid(Weapons.ItemOwner) then
					Weapons:CPPISetOwner(Weapons.ItemOwner)
				end

				timer.Create('RemoveDropItem_'..Weapons:EntIndex(), 120, 1, function()
					if IsValid(Weapons) and not ply:HasWeapon( wep['entity'] ) then
						Weapons:Remove()
					end
				end)
			end

			return nil
		elseif tb['save_data']['count'] > 1 then
			tb['save_data']['count'] = tb['save_data']['count'] - 1

			local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
			local Weapons = ply:Give(wep['entity'], false)

			spawn_pos.z = spawn_pos.z + 10

			if IsEntity( Weapons ) and Weapons != NULL then
				Weapons.ItemOwner = ply
				Weapons:SetPos( spawn_pos )

				if IsValid(Weapons.ItemOwner) then
					Weapons:CPPISetOwner(Weapons.ItemOwner)
				end

				timer.Create('RemoveDropItem_'..Weapons:EntIndex(), 120, 1, function()
					if IsValid(Weapons) and not ply:HasWeapon( wep['entity'] ) then
						Weapons:Remove()
					end
				end)
			end
	
			return tb
		end
	end

	return tb
end

INV.Items[ITEM.class] = ITEM