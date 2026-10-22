local ITEM = {}

ITEM.class = "bp_pill_bottle"

ITEM.color = Color(250,25,250)

ITEM.CanUse = true

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount or 1
	tb['model'] = ent:GetModel()

	tb['UsesLeft'] = ent:GetUsesLeft()
	tb['RecipeID'] = ent:GetRecipeID()
	
	tb['name'] = BLUES_PHARMA.Medicines[ent:GetRecipeID()].name..' [Осталось: '..ent:GetUsesLeft()..']'

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent:SetModel(tb['model'])

	ent:SetUsesLeft(tb['UsesLeft'])
	ent:SetRecipeID(tb['RecipeID'])
end

function ITEM.OnUse(ply, tb)
	tb['save_data']['UsesLeft'] = tb['save_data']['UsesLeft'] - 1

	local useFunc = BLUES_PHARMA.Medicines[tb['save_data']['RecipeID']].onConsumed
	useFunc(BLUES_PHARMA.Medicines[tb['save_data']['RecipeID']], ply)

	ply:BPAddOverdose(BLUES_PHARMA.Medicines[tb['save_data']['RecipeID']].overdoseRate)

	if tb['save_data']['UsesLeft'] <= 0 then 
		if tb['save_data']['amount'] <= 1 then
			return nil
		elseif tb['save_data']['amount'] > 1 then
			tb['save_data']['amount'] = tb['save_data']['amount'] - 1
	
			return tb
		end 
	end

	return tb
end

INV.Items[ITEM.class] = ITEM