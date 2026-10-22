local ITEM = {}

ITEM.class = "zgo2_edible"

ITEM.color = Color(250,150,80)

ITEM.CanUse = true

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount or 1
	tb['model'] = ent:GetModel()
	
	tb['WeedID'] = zgo2.Plant.GetID(ent:GetWeedID())
	tb['WeedAmount'] = math.Round(ent:GetWeedAmount())
	tb['WeedTHC'] = math.Round(ent:GetWeedTHC())
	tb['EdibleID'] = ent:GetEdibleID()

	local item = isentity(ent)
	local EdibleID = item and ent:GetEdibleID() or ent.data.EdibleID
	local WeedID = item and ent:GetWeedID() or ent.data.WeedID
	local WeedTHC = item and ent:GetWeedTHC() or ( ent.data.WeedTHC or 50 )
	local name = zgo2.Edible.GetName(EdibleID)
	local WeedData = zgo2.Plant.GetData(WeedID)

	tb['name'] = name .. " | " .. zgo2.Plant.GetName(WeedID) .. " THC: " .. WeedTHC .. "%"

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1

	ent:SetWeedID(zgo2.Plant.GetListID(tb['WeedID']))
	ent:SetWeedAmount(tb['WeedAmount'])
	ent:SetWeedTHC(tb['WeedTHC'] or 50)

	local EdibleData = zgo2.Edible.GetData(tb['EdibleID'])
	
	if EdibleData then
		ent:SetModel(EdibleData.edible_model)
	end
	
	ent:SetEdibleID(tb['EdibleID'])

	zgo2.Jar.UpdateBodygroups(ent)
end

function ITEM.OnUse(ply, tb)
	ply:AddHunger(math.random(1, 5))

	if IsValid(tb['save_data']['WeedID']) and tonumber(tb['save_data']['WeedID']) > 0 then
		zgo2.HighEffect.Start(tb['save_data']['WeedID'], tb['save_data']['WeedTHC'], 30, ply)
	end
	
	zclib.Sound.EmitFromPosition(ply:GetPos(),"zgo2_muffin_eat")
	
	if tb['save_data']['amount'] <= 1 then
		return nil
	elseif tb['save_data']['amount'] > 1 then
		tb['save_data']['amount'] = tb['save_data']['amount'] - 1

		return tb
	end
end

INV.Items[ITEM.class] = ITEM