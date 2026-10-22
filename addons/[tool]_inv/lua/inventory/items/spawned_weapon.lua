local ITEM = {}

ITEM.class = "spawned_weapon"

ITEM.color = Color(250, 110, 105)

ITEM.CanUse = true

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount or 1
	tb['model'] = ent:GetModel()
	tb['name'] = 'Оружие'
	
	if ent.weaponclass ~= nil then
		for i=1, #rp.shipments do
			local v = rp.shipments[i]

			if v and v.entity == ent.weaponclass then
				tb['name'] = v.name

				break 
			end
		end
	end

	tb['weaponclass'] = ent.weaponclass
	tb['clip1'] = ent.clip1
	tb['clip2'] = ent.clip2
	tb['ammoadd'] = ent.ammoadd

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent:SetModel(tb['model'])

	ent.weaponclass = tb['weaponclass']
	ent.clip1 = tb['clip1']
	ent.clip2 = tb['clip2']
	ent.ammoadd = tb['ammoadd']
end

function ITEM.OnUse(ply, tb)
	if tb['save_data']['weaponclass'] == "ent_licence" then
		if ply:HasLicense() then 
			rp.Notify(ply, NOTIFY_HINT, "Вы уже имеете лицензию")
			return tb
		end

		rp.Notify(ply, 3, 4, "Вы активировали лицензию!")
		ply:SetNetVar("HasGunlicense", true)

		if tb['save_data']['amount'] <= 1 then
			return nil
		elseif tb['save_data']['amount'] > 1 then
			tb['save_data']['amount'] = tb['save_data']['amount'] - 1

			return tb
		end
	end

	if tb['save_data']['weaponclass'] == "ent_disguise" then
		local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
		local item = ents.Create( "ent_disguise" )
		item.ItemOwner = ply
		item:SetPos( spawn_pos )
		item:Spawn()

		timer.Create('RemoveDropItem_'..item:EntIndex(), 120, 1, function()
			if IsValid(item) then
				item:Remove()
			end
		end)

		if tb['save_data']['amount'] <= 1 then
			return nil
		elseif tb['save_data']['amount'] > 1 then
			tb['save_data']['amount'] = tb['save_data']['amount'] - 1

			return tb
		end
	end

	if tb['save_data']['weaponclass'] == "armor_piece_full" then
		local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
		local item = ents.Create( "armor_piece_full" )
		item.ItemOwner = ply
		item:SetPos( spawn_pos )
		item:Spawn()

		timer.Create('RemoveDropItem_'..item:EntIndex(), 120, 1, function()
			if IsValid(item) then
				item:Remove()
			end
		end)

		if tb['save_data']['amount'] <= 1 then
			return nil
		elseif tb['save_data']['amount'] > 1 then
			tb['save_data']['amount'] = tb['save_data']['amount'] - 1

			return tb
		end
	end

	if tb['save_data']['amount'] <= 1 then
		local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
		local Weapons = ply:Give(tb['save_data']['weaponclass'], false)

		spawn_pos.z = spawn_pos.z + 10

		if IsEntity( Weapons ) and Weapons != NULL then
			Weapons.ItemOwner = ply
			Weapons:SetPos( spawn_pos )

			if IsValid(Weapons.ItemOwner) then
				Weapons:CPPISetOwner(Weapons.ItemOwner)
			end

			timer.Create('RemoveDropItem_'..Weapons:EntIndex(), 120, 1, function()
				if IsValid(Weapons) and not ply:HasWeapon( tb['save_data']['weaponclass'] ) then
					Weapons:Remove()
				end
			end)
		end

		return nil
	elseif tb['save_data']['amount'] > 1 then
		tb['save_data']['amount'] = tb['save_data']['amount'] - 1

		local spawn_pos = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 100, ply ).HitPos
		local Weapons = ply:Give(tb['save_data']['weaponclass'], false)

		spawn_pos.z = spawn_pos.z + 10

		if IsEntity( Weapons ) and Weapons != NULL then
			Weapons.ItemOwner = ply
			Weapons:SetPos( spawn_pos )

			if IsValid(Weapons.ItemOwner) then
				Weapons:CPPISetOwner(Weapons.ItemOwner)
			end

			timer.Create('RemoveDropItem_'..Weapons:EntIndex(), 120, 1, function()
				if IsValid(Weapons) and not ply:HasWeapon( tb['save_data']['weaponclass'] ) then
					Weapons:Remove()
				end
			end)
		end

		return tb
	end
end

INV.Items[ITEM.class] = ITEM
