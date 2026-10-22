local ITEM = {}

ITEM.class = "sent_drug_bag"
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount or 1

	tb['Consumable'] = ent:GetNWInt("Consumable")
	tb['Quality'] = ent:GetNWInt("Quality")
	tb['Level'] = ent:GetLevel()

	tb['model'] = ent:GetModel()
	tb['name'] = 'Наркотики'

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent:SetModel(tb['model'])

	ent:SetLevel(tb['Level']) 
	ent:SetNWInt("Consumable", tb['Consumable'] )
	ent:SetNWInt("Quality", tb['Quality'] )
end

function ITEM.OnUse(ply, tb)
end

INV.Items[ITEM.class] = ITEM