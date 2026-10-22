
local ITEM = {}

-- Короче, внутри файла Энтити есть вот такая фигня
--[[

local ITEM = {}

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "WeedID")
	self:NetworkVar("Int", 1, "Progress")

	if SERVER then
		self:SetWeedID(1)
		self:SetProgress(0)
	end
end

Это сетевые значения, приклепленные к энтити, их надо парсить, если хочешь сохранять. ЛЮБЫЕ СЕРВЕРНЫЕ значения можно сохранять.
]]
ITEM.class = "zgo2_weedblock"

ITEM.color = Color(250,150,80)

ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	-- Эти параметры, как оказалось - обязательны
	tb['amount'] = ent.amount and ent.amount or 1
	tb['model'] = ent:GetModel()
	tb['WeedID'] = zgo2.Plant.GetID(ent:GetWeedID())
	
	tb['name'] = zgo2.Plant.GetName(zgo2.Plant.GetID(ent:GetWeedID()))

	return tb
end

function ITEM.LoadItemData(ent, tb)

	-- Эти параметры, как оказалось - обязательны
	ent.amount = tb['amount'] or 1
	ent:SetModel(tb['model'])
	ent:SetWeedID(zgo2.Plant.GetListID(tb['WeedID']))
	
end

function ITEM.OnUse(ply, tb)
end

INV.Items[ITEM.class] = ITEM