local ITEM = {}

ITEM.class = "zgo2_jar"

ITEM.color = Color(250,150,80)

ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount or 1
	tb['model'] = ent:GetModel()
	
	tb['WeedID'] = zgo2.Plant.GetID(ent:GetWeedID())
	tb['WeedAmount'] = math.Round(ent:GetWeedAmount())
	tb['WeedTHC'] = math.Round(ent:GetWeedTHC())

	if math.Round(ent:GetWeedAmount()) > 0 then
		tb['name'] = zgo2.Plant.GetName(zgo2.Plant.GetID(ent:GetWeedID())) .. " [" .. math.Round(ent:GetWeedAmount()) .. zgo2.config.UoM .. " - THC: ".. (math.Round(ent:GetWeedTHC()) or 50) .. "%]"
	else
		tb['name'] = 'Пустая банка'
	end

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent:SetModel(tb['model'])
	
	ent:SetWeedID(zgo2.Plant.GetListID(tb['WeedID']))
	ent:SetWeedAmount(tb['WeedAmount'])
	ent:SetWeedTHC(tb['WeedTHC'] or 50)

	zgo2.Jar.UpdateBodygroups(ent)
end

function ITEM.OnUse(ply, tb)
end

INV.Items[ITEM.class] = ITEM