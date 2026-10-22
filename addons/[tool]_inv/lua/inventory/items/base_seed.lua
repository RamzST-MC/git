local ITEM = {}

ITEM.class = "base_seed"

ITEM.color = Color(250,200,25)

ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount or 1
	tb['SeedTabel'] = ent:GetSeedBaseTabel()
	tb['model'] = ent:GetModel()
	tb['name'] = ent:GetSeedBaseTabel()[1]

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent:SetSeedBaseTabel( tb['SeedTabel'] )
	ent.amount = tb['amount'] or 1
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(ply, tb)
end

INV.Items[ITEM.class] = ITEM