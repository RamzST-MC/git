local PLAYER = debug.getregistry().Player

INV.pickup_time = 0.3
INV.pickup_distance = 50

INV.BaseColor = Color(41, 38, 66)
INV.BackgroundColor = Color(41, 38, 66, 220)
INV.ItemColor = Color(75, 63, 109)
INV.ItemColorHover = Color(109, 92, 156)
INV.ButtonColor = Color(56, 46, 73)
INV.ScrollColor = Color(75, 63, 109)
INV.ScrollBarColor = Color(56, 46, 73)

INV.Languge = {
	['spawned_shipment'] = 'Ящики',
	['base_food'] = 'Еда',
	['spawned_weapon'] = 'Оружие',
	['spawned_ammo'] = 'Патроны',
	['zmlab2_item_crate'] = 'Контейнеры для мета',
	['zmlab2_item_meth'] = 'Мет',
	['base_seed'] = 'Растения',
	['bp_pill_bottle'] = 'Лекарства',
	['sent_drug_bag'] = 'Наркотики',
	['zgo2_baggy'] = 'Пакетики травы',
	['zgo2_edible'] = 'Выпечка',
	['zgo2_jar'] = 'Банки с травой',
	['zgo2_weedblock'] = 'Блок',
}

INV.ModelPos = {
	['spawned_shipment'] = {pos = Vector(0,0,30), ang = Angle(0,45,0), fov = 35},
	['zmlab2_item_crate'] = {pos = Vector(0,0,35), ang = Angle(0,45,0), fov = 20},
	['zmlab2_item_meth'] = {pos = Vector(0,0,40), ang = Angle(0,-45,90), fov = 10},
	['base_seed'] = {pos = Vector(0,0,40), ang = Angle(0,45,0), fov = 10},
	['bp_pill_bottle'] = {pos = Vector(0,0,38), ang = Angle(0,0,0), fov = 10},
	['sent_drug_bag'] = {pos = Vector(0,0,0), ang = Angle(0,0,0), fov = 20},
	['zgo2_baggy'] = {pos = Vector(0,0,40), ang = Angle(0,45,0), fov = 12},
	['zgo2_edible'] = {pos = Vector(0,0,38), ang = Angle(0,0,-35), fov = 10},
	['zgo2_jar'] = {pos = Vector(0,0,30), ang = Angle(0,45,0), fov = 20},
	['zgo2_weedblock'] = {pos = Vector(0,0,30), ang = Angle(0,45,0), fov = 20},
}

INV.Name = {
	['models/props/de_inferno/crate_fruit_break_gib2.mdl'] = 'Яблоко',
	['models/props/cs_italy/bananna.mdl'] = 'Банан',
	['models/foods/cabbage1.mdl'] = 'Капуста',
	['models/foods/cabbage2.mdl'] = 'Цветная Капуста',
	['models/foods/lemon.mdl'] = 'Лимон',
	['models/props/cs_italy/orange.mdl'] = 'Апельсин',
	['models/props_phx/misc/potato.mdl'] = 'Картофель',
	['models/props/cs_italy/orange.mdl'] = 'Помидор',
	['models/props_junk/watermelon01.mdl'] = 'Арбуз',
	['models/props/cs_office/water_bottle.mdl'] = 'Вода',
	['models/props_phx/misc/egg.mdl'] = 'Яйцо',
	['models/props_junk/glassbottle01a.mdl'] = 'Масло',
	['models/foods/toast1.mdl'] = 'Тост',
	['models/foods/backbacon.mdl'] = 'Сырое мясо',
	['models/foods/lemoncleaner.mdl'] = 'Соус',
	['models/foods/picklejar.mdl'] = 'Огурцы',
	['models/foods/sausage.mdl'] = 'Сырая сосиска',
	['models/foods/twinkie.mdl'] = 'Тесто',
	['models/foods/applejacks.mdl'] = 'Хлопья',
	['models/props_junk/garbage_milkcarton001a.mdl'] = 'Молоко',
	['models/foods/pancakesingle.mdl'] = 'Основа для пицы',
	['models/foods/mcdfriedchickenleg.mdl'] = 'Куриная ножка сырая',
	['models/foods/egg.mdl'] = 'Яичница',
	['models/foods/backbacon.mdl'] = 'Жареное мясо',
	['models/foods/bigsandwich.mdl'] = 'Сэндвич',
	['models/foods/chipbunch.mdl'] = 'Картофель фри',
	['models/foods/sprunk1.mdl'] = 'Спрайт',
	['models/foods/juicesmall.mdl'] = 'Яблочный сок',
	['models/foods/burgergtasa.mdl'] = 'Гамбургер',
	['models/foods/hotdog.mdl'] = 'Сосиска в тесте',
	['models/foods/cerealbowl.mdl'] = 'Хлопья с молоком',
	['models/foods/toast.mdl'] = 'Жаренный тост',
	['models/foods/pepperonipizza.mdl'] = 'Пицца',
	['models/foods/mcdfriedchickenlegs.mdl'] = 'Куриные ножки жареные',
	['models/foods/cola.mdl'] = 'Кола',
}

INV.MaxWeight = {
	['root'] = 999,
	['superadmin'] = 200,
	['operator'] = 100,
	['stadmin'] = 90,
	['admin'] = 80,
	['moderator'] = 70,
	['helper'] = 60,
	['sponsor'] = 60,
	['user'] = 40,
}

function PLAYER:GetMaxInv()
	return INV.MaxWeight[self:GetUserGroup()] or 50
end