local ITEM = {}

ITEM.class = "drugz_milk"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Молоко'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_mushroom"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Гриб'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_meth"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Мет'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_aspirin"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Аспирин'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_bathsalts"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Соль'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_beer"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Пиво'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "drugz_bleach"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Отбеливатель'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_cigarette"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Сигареты'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_cocaine"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Кокаин'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "drugz_coffee"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Кофе'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_heroine"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Героин'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_lsd"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'ЛСД'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "drugz_soda"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Газировка'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_water"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Вода'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEM = {}

ITEM.class = "durgz_weed"
ITEM.color = Color(137,80,250)
ITEM.CanUse = false

function ITEM.SaveItemData(ent)
	local tb = {}

	tb['amount'] = ent.amount and ent.amount or 1
	tb['name'] = 'Травка'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEM.LoadItemData(ent, tb)
	ent.amount = tb['amount'] or 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEM.OnUse(pl, tb)
end

INV.Items[ITEM.class] = ITEM

local ITEMplate = {}

ITEMplate.class = "money_printer_plate"
ITEMplate.color = Color(80,250,210)
ITEMplate.CanUse = false

function ITEMplate.SaveItemData(ent)
	local tb = {}

	tb['amount'] = 1
	tb['name'] = 'Денежная Плита'
	tb['model'] = ent:GetModel()

	return tb
end

function ITEMplate.LoadItemData(ent, tb)
	ent.amount = 1
	ent.name = tb['name']
	ent:SetModel(tb['model'])
end

function ITEMplate.OnUse(pl, tb)
end

INV.Items[ITEMplate.class] = ITEMplate