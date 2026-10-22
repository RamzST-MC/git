local ITEM = {}

ITEM.class = "zmlab2_item_meth"

ITEM.color = Color(250,150,80)

ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount or 1
	tb['model'] = ent:GetModel()
	tb['MethType'] = ent:GetMethType()
	tb['MethAmount'] = ent:GetMethAmount()
	tb['MethQuality'] = ent:GetMethQuality()

	local m_type = ent:GetMethType()
	local m_qual = ent:GetMethQuality()
	local m_amount = ent:GetMethAmount()
	local MethData = zmlab2.config.MethTypes[m_type]

	tb['name'] = 'Пустой пакетик'
	
	if MethData then
		tb['name'] = MethData.name .. " [" .. (m_amount or 0) .. zmlab2.config.UoM .. " - " .. (m_qual or 0) .. "%]"
	end

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent:SetModel(tb['model'])
	ent:SetMethType(tb['MethType'])
	ent:SetMethAmount(tb['MethAmount'])
	ent:SetMethQuality(tb['MethQuality'])
end

function ITEM.OnUse(ply, tb)
end

INV.Items[ITEM.class] = ITEM