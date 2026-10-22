local ITEM = {}

ITEM.class = "base_food"
ITEM.color = Color(250,150,80)
ITEM.CanUse = true

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount or 1
	tb['model'] = ent:GetFoodBaseTabel()[1][4]
	
	tb['FoodBaseTabel'] = ent:GetFoodBaseTabel()
	tb['UniqueName'] = ent.UniqueName

	tb['name'] = ent:GetFoodBaseTabel()[1][1] or ''

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent:SetModel(tb['model'])
	
	ent:SetFoodBaseTabel( tb['FoodBaseTabel'] )
	ent.UniqueName = tb['UniqueName']
	ent.wake = true
end

function ITEM.OnUse(ply, tb)
	local tabel = tb['save_data']['FoodBaseTabel'][2]
	
	ply:HFM_AddHunger(tabel[1],tabel[2])
	
	--zclib.Sound.EmitFromPosition(ply:GetPos(),"zgo2_muffin_eat")
	
	if tb['save_data']['amount'] <= 1 then
		return nil
	elseif tb['save_data']['amount'] > 1 then
		tb['save_data']['amount'] = tb['save_data']['amount'] - 1

		return tb
	end
end

INV.Items[ITEM.class] = ITEM