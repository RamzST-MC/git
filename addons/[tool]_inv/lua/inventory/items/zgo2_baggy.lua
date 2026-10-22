local ITEM = {}

ITEM.class = "zgo2_baggy"

ITEM.color = Color(250,150,80)

ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount or 1
	tb['model'] = ent:GetModel()
	
	tb['WeedID'] = zgo2.Plant.GetID(ent:GetWeedID())
	tb['WeedAmount'] = math.Round(ent:GetWeedAmount())
	tb['WeedTHC'] = math.Round(ent:GetWeedTHC())

	tb['name'] = zgo2.Plant.GetName(zgo2.Plant.GetID(ent:GetWeedID())) .. " [" .. math.Round(ent:GetWeedAmount()) .. zgo2.config.UoM .. " - THC: ".. (math.Round(ent:GetWeedTHC()) or 50) .. "%]"

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent:SetModel(tb['model'])

	ent:SetWeedID(zgo2.Plant.GetListID(tb['WeedID']))
	ent:SetWeedAmount(tb['WeedAmount'])
	ent:SetWeedTHC(tb['WeedTHC'] or 50)
end

function ITEM.OnUse(ply, tb)
end

INV.Items[ITEM.class] = ITEM