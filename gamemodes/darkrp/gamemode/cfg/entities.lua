rp.AddEntity('Радио', {
	catagory = 'DJ', 
	ent = 'media_radio',
	model = 'models/props_lab/citizenradio.mdl',
	price = 2500,
	max = 1, 
	cmd = '/buyradio',
	allowed = {TEAM_DJ},
	pocket = false,
})

rp.AddEntity('Прилавок', {
    catagory = 'DJ', 
    ent = 'prilavok',
    model = 'models/props_c17/display_cooler01a.mdl',
    price = 1,
    max = 1, 
    cmd = '/buyradio',
    allowed = {TEAM_GUN},
    pocket = false,
})

rp.AddEntity('Денежный принтер', {
	catagory = "Принтеры",
	ent = 'derma_printer',
	model = 'models/eclipse_custom/printer.mdl',
	price = 5000,
	max = 3,
	cmd = '/buymoneyprinter',
	allowed = {TEAM_BANK, TEAM_GANGSTER, TEAM_VIPGANG, TEAM_FREERUNNER, TEAM_CITIZEN},
	pocket = false,
	onSpawn = function(self, b, d)
		rp.achievements.AddProgress(b, ACHIEVEMENT_PRINTERS, 1)
	end
})

rp.AddEntity('Принтер', {
	catagory = "Принтеры",
	ent = 'money_printer',
	model = 'models/sup/printer/printer.mdl',
	price = 2500,
	max = 2,
	cmd = '/buyprinter',
	allowed = {TEAM_HOBOKING, TEAM_HOBO, TEAM_JUNKIE},
	pocket = false,
	onSpawn = function(self, b, d)
		rp.achievements.AddProgress(b, ACHIEVEMENT_PRINTERS, 1)
	end
})

rp.AddEntity('Стойка для принтера', {
	catagory = "Принтеры",
	ent = 'money_printer_rack_base',
	model = 'models/sup/printerrack/sup_printerrack_small.mdl',
	price = 2500,
	max = 2,
	cmd = '/buyrack',
	allowed = {TEAM_HOBOKING, TEAM_HOBO, TEAM_JUNKIE},
	pocket = false
})

rp.AddEntity('Корзина', {
	catagory = "Принтеры",
	ent = 'money_basket',
	model = 'models/props_junk/PlasticCrate01a.mdl',
	price = 500,
	max = 1,
	cmd = '/buybasket',
	allowed = {TEAM_HOBOKING, TEAM_HOBO, TEAM_JUNKIE},
	pocket = false
})

rp.AddEntity('Казино 50/50', {
	catagory = 'Машины', 
	ent = 'gambling_machine_fiftyfifty',
	model = 'models/sup/gamblingmachine/machine.mdl',
	price = 5000,
	max = 2, 
	cmd = '/buyfiftyfifty',
	allowed = {TEAM_CASINOOWNER},
	pocket = false,
})

rp.AddEntity('Казино Слоты', {
	catagory = 'Машины', 
	ent = 'gambling_machine_basicslots',
	model = 'models/sup/gamblingmachine/machine.mdl',
	price = 5000,
	max = 2, 
	cmd = '/buybasicslots',
	allowed = {TEAM_CASINOOWNER},
	pocket = false,
})

rp.AddEntity('Казино Колесо', {
	catagory = 'Машины',
	ent = 'gambling_machine_spinwheel',
	model = 'models/sup/gamblingmachine/machine.mdl',
	price = 5000,
	max = 2, 
	cmd = '/buyspinwheel',
	allowed = {TEAM_CASINOOWNER},
	pocket = false,
})

rp.AddEntity("Вейп", {
	ent = "weapon_vape",
	model = "models/swamponions/vape.mdl",
	price = 5000,
	max = 1,
	cmd = "/buyclassicvape",
	customCheck = function(ply) return ply:IsVIP() end,
	customCheckFailMsg = "Вы должны быть VIP!",
})

rp.AddEntity('Металлодетектор', {
	ent = 'metal_detector',
	model = 'models/props_wasteland/interior_fence002e.mdl',
	price = 7500,
	max = 1,
	cmd = '/buymetal',
	pocket = false
})

--Cook
rp.AddEntity('Кухонный набор', {
    ent = 'zmc_buildkit',
    model = 'models/zerochain/props_kitchen/zmc_buildkit.mdl',
    price = 5000,
    max = 1,
    cmd = '/buybuildkit',
    allowed = {TEAM_COOK},
    pocket = false
})

rp.AddEntity('Газовый балон', {
    ent = 'zmc_gastank',
    model = 'models/zerochain/props_kitchen/zmc_gastank.mdl',
    price = 1000,
    max = 1,
    cmd = '/buygastank',
    allowed = {TEAM_COOK},
    pocket = false
})

-- Hobo
rp.AddEntity('Коробка для пожертвования', {
	ent = 'donation_box', 
	model = 'models/props/CS_militia/footlocker01_open.mdl', 
	price = 500, 
	max = 1, 
	cmd = '/buybox',
	allowed = {TEAM_HOBO, TEAM_DJ},
	pocket = false
})
-- TEAM_DRUGMAKER
rp.AddEntity("Тент", {
	catagory = "Производство мета",
	ent = "zmlab2_tent",
	model = "models/zerochain/props_methlab/zmlab2_tentkit.mdl",
	price = 1000,
	max = 1,
	cmd = "/buyzmtent",
	pocket = false,
	allowed = {TEAM_METOVAR},
})

rp.AddEntity("Контейнер", {
	catagory = "Производство мета",
	ent = "zmlab2_item_crate",
	model = "models/zerochain/props_methlab/zmlab2_crate.mdl",
	price = 250,
	max = 8,
	cmd = "/buyzmitemcrate",
	pocket = false,
	allowed = {TEAM_METOVAR},
})

rp.AddEntity("Поддон", {
	catagory = "Производство мета",
	ent = "zmlab2_item_palette",
	model = "models/zerochain/props_methlab/zmlab2_palette.mdl",
	price = 1500,
	max = 1,
	cmd = "/buyzmpalette",
	pocket = false,
	allowed = {TEAM_METOVAR},
})

rp.AddEntity("Оборудование", {
	catagory = "Производство мета",
	ent = "zmlab2_equipment",
	model = "models/zerochain/props_methlab/zmlab2_chest.mdl",
	price = 2000,
	max = 1,
	cmd = "/buyzmequipment",
	pocket = false,
	allowed = {TEAM_METOVAR},
})
-- YeastBeast
rp.AddEntity("Перегонная машина", {
	ent = "zyb_distillery",
	model = "models/zerochain/props_yeastbeast/yb_distillery_heater.mdl",
	price = 5000,
	max = 1,
	cmd = "/buydistillery",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Конденсатор", {
	ent = "zyb_constructionkit_condenser",
	model = "models/zerochain/props_yeastbeast/yb_distillery_condenser.mdl",
	price = 1000,
	max = 1,
	cmd = "/buycondenser",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Кулер", {
	ent = "zyb_constructionkit_cooler",
	model = "models/zerochain/props_yeastbeast/yb_distillery_cooler.mdl",
	price = 1000,
	max = 1,
	cmd = "/buycooler",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Бочка", {
	ent = "zyb_fermbarrel",
	model = "models/zerochain/props_yeastbeast/yb_barrel.mdl",
	price = 1000,
	max = 1,
	cmd = "/buybarrel",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Топливо", {
	ent = "zyb_fuel",
	model = "models/zerochain/props_yeastbeast/yb_wood.mdl",
	price = 1000,
	max = 3,
	cmd = "/buywood",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Банки (6 шт.)", {
	ent = "zyb_jarpack",
	model = "models/zerochain/props_yeastbeast/yb_jarpack.mdl",
	price = 1000,
	max = 3,
	cmd = "/buyjar",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Ящик", {
	ent = "zyb_jarcrate",
	model = "models/zerochain/props_yeastbeast/yb_jarcrate.mdl",
	price = 1000,
	max = 3,
	cmd = "/buycrate",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Мясорубка", {
	ent = "zyb_yeastgrinder",
	model = "models/zerochain/props_yeastbeast/yb_grinder.mdl",
	price = 1000,
	max = 1,
	cmd = "/buygrinder",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Мотор для мясорубки", {
	ent = "zyb_motor",
	model = "models/zerochain/props_yeastbeast/yb_motor.mdl",
	price = 1000,
	max = 1,
	cmd = "/buymotor",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Пакет", {
	ent = "zyb_paperbag",
	model = "models/zerochain/props_yeastbeast/yb_paperbag.mdl",
	price = 50,
	max = 4,
	cmd = "/buypacket",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Сахар", {
	ent = "zyb_sugar",
	model = "models/zerochain/props_yeastbeast/yb_sugar.mdl",
	price = 100,
	max = 4,
	cmd = "/buysugar",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Вода", {
	ent = "zyb_water",
	model = "models/zerochain/props_yeastbeast/yb_water.mdl",
	price = 250,
	max = 2,
	cmd = "/buywater",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

rp.AddEntity("Дрожжи", {
	ent = "zyb_yeast",
	model = "models/zerochain/props_yeastbeast/yb_yeast.mdl",
	price = 250,
	max = 2,
	cmd = "/buyyeast",
	allowed = {TEAM_DISTILLER},
	pocket = false,
	catagory = "Самогон"
})

-- Notes
rp.AddEntity('Записка', {
	ent = 'ent_note',
	model = 'models/props_c17/paper01.mdl',
	price = 500,
	max = 1,
	cmd = '/note',
	pocket = false,
	onSpawn = function(ent, pl)
		if (IsValid(pl.LastNote)) then
			pl.LastNote:Remove()
		end	
		pl.LastNote = ent
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('USENote'))
	end
})

rp.AddEntity("Кабель", {
    ent = "ch_bitminer_power_cable",
    model = "models/craphead_scripts/bitminers/utility/plug.mdl",
    price = 500,
    max = 6,
	catagory = "Битмайнер",
    cmd = "/buypowercable1",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("Генератор", {
    ent = "ch_bitminer_power_generator",
    model = "models/craphead_scripts/bitminers/power/generator.mdl",
    price = 2500,
    max = 4,
	catagory = "Битмайнер",
    cmd = "/buypowergenerator",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("Объединитель мощности", {
    ent = "ch_bitminer_power_combiner",
    model = "models/craphead_scripts/bitminers/power/power_combiner.mdl",
    price = 5000,
    max = 1,
	catagory = "Битмайнер",
    cmd = "/buypowercombiner",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("Радиоизотопный термоэлектрический генератор", {
    ent = "ch_bitminer_power_rtg",
    model = "models/craphead_scripts/bitminers/power/rtg.mdl",
    price = 30000,
    max = 1,
	catagory = "Битмайнер",
    cmd = "/buynucleargenerator",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("Полка для битмайнинга", {
    ent = "ch_bitminer_shelf",
    model = "models/craphead_scripts/bitminers/rack/rack.mdl",
    price = 7500,
    max = 1,
	catagory = "Битмайнер",
    cmd = "/buyminingshelf",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("Кулер 1 уровня", {
    ent = "ch_bitminer_upgrade_cooling1",
    model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_1.mdl",
    price = 7500,
    max = 1,
	catagory = "Битмайнер",
    cmd = "/buycooling1",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

 rp.AddEntity("Кулер 2 уровня", {
    ent = "ch_bitminer_upgrade_cooling2",
    model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_2.mdl",
    price = 15000,
    max = 1,
	catagory = "Битмайнер",
    cmd = "/buycooling2",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("Кулер 3 уровня", {
    ent = "ch_bitminer_upgrade_cooling3",
    model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_3.mdl",
    price = 25000,
    max = 1,
	catagory = "Битмайнер",
    cmd = "/buycooling3",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("Майнер", {
    ent = "ch_bitminer_upgrade_miner",
    model = "models/craphead_scripts/bitminers/utility/miner_solo.mdl",
    price = 7500,
    max = 8,
	catagory = "Битмайнер",
    cmd = "/buysingleminer",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("RGB подсветка", {
    ent = "ch_bitminer_upgrade_rgb",
    model = "models/craphead_scripts/bitminers/utility/rgb_kit.mdl",
    price = 2500,
    max = 1,
	catagory = "Битмайнер",
    cmd = "/buyrgbkit",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("Блок питания", {
    ent = "ch_bitminer_upgrade_ups",
    model = "models/craphead_scripts/bitminers/utility/ups_solo.mdl",
    price = 7500,
    max = 4,
	catagory = "Битмайнер",
    cmd = "/buyupsupgrade",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

rp.AddEntity("Топливо", {
    ent = "ch_bitminer_power_generator_fuel",
    model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
    price = 500,
    max = 4,
	catagory = "Битмайнер",
    cmd = "/buygeneratorfuel",
	pocket = false,
    allowed = {TEAM_BITMINER}
})

-- Gun Dealer
rp.AddWeapon("Пистолет Colt Python", "models/weapons/w_colt_python.mdl", "m9k_coltpython", 12000, {TEAM_GUN})
rp.AddWeapon("Пистолет Beretta", "models/weapons/w_beretta_m92.mdl", "m9k_m92beretta", 9000, {TEAM_GUN})
rp.AddWeapon("Пистолет Colt 1911", "models/weapons/s_dmgf_co1911.mdl", "m9k_colt1911", 9000, {TEAM_GUN})
rp.AddWeapon("ПП UMP45", "models/weapons/w_hk_ump45.mdl", "m9k_ump45", 20000, {TEAM_GUN})
rp.AddWeapon("ПП Bizon", "models/weapons/w_pp19_bizon.mdl", "m9k_bizonp19", 22500, {TEAM_GUN})
rp.AddWeapon("ПП P90", "models/weapons/w_fn_p90.mdl", "m9k_smgp90", 25000, {TEAM_GUN})
rp.AddWeapon("Автомат AK-47", "models/weapons/w_ak47_m9k.mdl", "m9k_ak47", 30000, {TEAM_GUN})
rp.AddWeapon("Автомат G36", "models/weapons/w_hk_g36c.mdl", "m9k_g36", 35000, {TEAM_GUN})
rp.AddWeapon("Автомат FG42", "models/weapons/w_fg42.mdl", "m9k_fg42", 120000, {TEAM_GUN})
rp.AddWeapon("Автомат AK74", "models/weapons/w_tct_ak47.mdl", "m9k_ak74", 75000, {TEAM_GUN})
rp.AddWeapon("Пулемет M249", "models/weapons/w_m249_machine_gun.mdl", "m9k_m249lmg", 120000, {TEAM_GUN})
rp.AddWeapon("Винтовка M14", "models/weapons/w_snip_m14sp.mdl", "m9k_m14sp", 80000, {TEAM_GUN})
rp.AddWeapon("Автомат Вихрь", "models/weapons/w_dmg_vikhr.mdl", "m9k_vikhr", 100000, {TEAM_GUN})
rp.AddWeapon("ПП KAC PDW", "models/weapons/w_kac_pdw.mdl", "m9k_kac_pdw", 70000, {TEAM_GUN})
rp.AddWeapon("Дробовик Browningauto", "models/weapons/w_browning_auto.mdl", "m9k_browningauto5", 75000, {TEAM_GUN})
rp.AddWeapon("Дробовик SPAS12", "models/weapons/w_spas_12.mdl", "m9k_spas12", 240000, {TEAM_GUN})
rp.AddWeapon("Дробовик Benelli M3", "models/weapons/w_benelli_m3.mdl", "m9k_m3", 65000, {TEAM_GUN})
rp.AddWeapon("Винтовка PSG1", "models/weapons/w_hk_psg1.mdl", "m9k_psg1", 100000, {TEAM_GUN})
rp.AddWeapon("Винтовка SL8", "models/weapons/w_hk_sl8.mdl", "m9k_sl8", 120000, {TEAM_GUN})
rp.AddWeapon("Автомат M4A1", "models/weapons/3_rif_m4a1.mdl", "bb_m4a1_alt", 55000, {TEAM_GUN})
rp.AddWeapon("Дробовик XM1014", "models/weapons/3_shot_xm1014.mdl", "bb_xm1014_alt", 75000, {TEAM_GUN})
rp.AddWeapon("Автомат Steyr AUG", "models/weapons/3_rif_aug.mdl", "bb_aug_alt", 35000, {TEAM_GUN})
rp.AddWeapon("Автомат Galil", "models/weapons/3_rif_galil.mdl", "bb_galil_alt", 35000, {TEAM_GUN})
rp.AddWeapon("ПП MP5", "models/weapons/3_smg_mp5.mdl", "bb_mp5_alt", 22000, {TEAM_GUN})
rp.AddWeapon("ПП MAC10", "models/weapons/3_smg_mac10.mdl", "bb_mac10_alt", 15000, {TEAM_GUN})
rp.AddWeapon("Дробовик M3 Super 90", "models/weapons/3_shot_m3super90.mdl", "bb_m3_alt", 15000, {TEAM_GUN})
rp.AddWeapon("Винтовка SG550", "models/weapons/3_snip_sg550.mdl", "bb_sg550_alt", 20000, {TEAM_GUN})
rp.AddWeapon("ПП SG552", "models/weapons/3_rif_sg552.mdl", "bb_sg552_alt", 50000, {TEAM_GUN})
rp.AddWeapon("Винтовка AWP", "models/weapons/3_snip_awp.mdl", "bb_awp_alt", 60000, {TEAM_GUN})

-- Black Market Dealer
rp.AddShipment('Динамит','models/weapons/w_tnt.mdl', 'weapon_incendiary', 1250000, 10, false, 40000, false, {TEAM_BMIDEALER})
rp.AddShipment('Взломщики Кейпадов','models/weapons/w_c4.mdl', 'keypad_cracker', 40000, 10, false, 1050, false, {TEAM_BMIDEALER})
rp.AddShipment('Отмычки','models/sup/weapons/lockpick/lockpick.mdl', 'lockpick', 30000, 10, false, 950, false, {TEAM_BMIDEALER})
rp.AddShipment('Броня','models/props_junk/cardboard_box004a.mdl', 'armor_piece_full', 15000, 10, false, 900, false, {TEAM_BMIDEALER})
rp.AddShipment('Лом','models/weapons/w_crowbar.mdl', 'weapon_crowbar', 12500, 10, false, 700, false, {TEAM_BMIDEALER})
rp.AddShipment('Дубинка','models/weapons/w_stunbaton.mdl', 'weapon_stunstick', 10000, 10, false, 650, false, {TEAM_BMIDEALER})
rp.AddShipment('Освобождающая Дубинка','models/weapons/w_stunbaton.mdl', 'unarrest_baton', 30000, 10, false, 800, false, {TEAM_BMIDEALER})
rp.AddShipment('Фальшивая Лицензия','models/props_lab/clipboard.mdl', 'ent_licence', 10000, 10, false, 1250, false, {TEAM_BMIDEALER})
rp.AddShipment('Маскировка','models/props_c17/SuitCase_Passenger_Physics.mdl', 'ent_disguise', 50000, 10, false, 1250, false, {TEAM_BMIDEALER})
rp.AddShipment('Тазер','models/weapons/w_pistol.mdl', 'weapon_taser', 75000, 10, false, 1000, false, {TEAM_BMIDEALER})
rp.AddShipment('C4','models/weapons/2_c4_planted.mdl', 'weapon_c4', 2000000, 10, false, 35000, false, {TEAM_BMIDEALER})

rp.AddFoodItem('Чизбургер', 'models/food/burger.mdl', 25, 50)
rp.AddFoodItem('Хот-дог', 'models/food/hotdog.mdl', 35, 75)
rp.AddFoodItem('Арбуз', 'models/props_junk/watermelon01.mdl', 10, 20)
rp.AddFoodItem('Апельсин', 'models/props/cs_italy/orange.mdl', 35, 35)
rp.AddFoodItem('Фастфуд', 'models/props_junk/garbage_bag001a.mdl', 50, 60)

rp.AddEntity("Книга гайдов", {
	ent = "bp_guide_book",
	model = "models/blues_pharm/book.mdl",
	price = 5000,
	max = 1,
	cmd = "/bpbuyguide",
	allowed = {TEAM_DOCTOR},
	pocket = false,
	catagory = "Медицина",
}) 

rp.AddEntity("Мензурка", {
	ent = "bp_beaker",
	model = "models/blues_pharm/beaker.mdl",
	price = 1500,
	max = 3,
	cmd = "/bpbuybeaker",
	pocket = false,
	allowed = {TEAM_DOCTOR},
	catagory = "Медицина",
}) 

rp.AddEntity("Бунзеновская горелка", {
	ent = "bp_bunsen_burner",
	model = "models/blues_pharm/bunsen_burner.mdl",
	price = 5000,
	max = 2,
	catagory = "Медицина",
	cmd = "/bpbuybunsenburner",
	pocket = false,
	allowed = {TEAM_DOCTOR},
}) 

rp.AddEntity("Морозилка", {
	ent = "bp_freezer",
	model = "models/blues_pharm/freezer.mdl",
	price = 20000,
	max = 1,
	catagory = "Медицина",
	cmd = "/bpbuyfreezer",
	pocket = false,
	allowed = {TEAM_DOCTOR},
}) 

rp.AddEntity("Таблеточный пресс", {
	ent = "bp_pill_press",
	model = "models/blues_pharm/pill_presser.mdl",
	price = 8000,
	catagory = "Медицина",
	max = 1,
	cmd = "/bpbuypillpress",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

--Chemicals below
rp.AddEntity("Кето кислота", {
	ent = "bp_chemical_keto_acid",
	model = "models/blues_pharm/jar_1.mdl",
	price = 1750,
	max = 2,
	catagory = "Медицина",
	cmd = "/bpbuyketoacid",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})
rp.AddEntity("Пропионовая кислота", {
	ent = "bp_chemical_prop_acid",
	model = "models/blues_pharm/jar_2.mdl",
	price = 1750,
	max = 2,
	catagory = "Медицина",
	cmd = "/bpbuypropacid",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

rp.AddEntity("Салициловая кислота", {
	ent = "bp_chemical_sali_acid",
	model = "models/blues_pharm/jar_2.mdl",
	price = 1500,
	catagory = "Медицина",
	max = 2,
	cmd = "/bpbuysaliacid",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

rp.AddEntity("Метилтестостерон", {
	ent = "bp_chemical_17alph",
	model = "models/blues_pharm/jar_3.mdl",
	price = 3000,
	catagory = "Медицина",
	max = 2,
	cmd = "/bpbuymeth",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

rp.AddEntity("2-Нафтол", {
	ent = "bp_chemical_2nap",
	model = "models/blues_pharm/jar_3.mdl",
	price = 1250,
	catagory = "Медицина",
	max = 2,
	cmd = "/bpbuynapth",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

rp.AddEntity("Прогестерон", {
	ent = "bp_chemical_prog",
	model = "models/blues_pharm/jar_3.mdl",
	price = 3000,
	catagory = "Медицина",
	max = 2,
	cmd = "/bpbuyprog",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

rp.AddEntity("Ацетон", {
	ent = "bp_chemical_acet2",
	model = "models/blues_pharm/jar_3.mdl",
	price = 1750,
	max = 2,
	catagory = "Медицина",
	cmd = "/bpbuyacet",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

rp.AddEntity("Уксусный ангидрид", {
	ent = "bp_chemical_acet",
	model = "models/blues_pharm/jar_4.mdl",
	price = 1000,
	max = 2,
	catagory = "Медицина",
	cmd = "/bpbuyacet2",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

rp.AddEntity("Диоксид селена", {
	ent = "bp_chemical_sele",
	model = "models/blues_pharm/jar_4.mdl",
	price = 2000,
	catagory = "Медицина",
	max = 2,
	cmd = "/bpbuysele",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

rp.AddEntity("Деионизированная вода", {
	ent = "bp_chemical_deio",
	model = "models/blues_pharm/jar_5.mdl",
	price = 1500,
	catagory = "Медицина",
	max = 2,
	cmd = "/bpbuywater",
	pocket = false,
	allowed = {TEAM_DOCTOR},
})

rp.AddEntity("Наручники",{
	ent = "ent_taser_hook",
	model = "models/props/cs_office/Snowman_arm.mdl",
	price = 200,
	max = 1,
	cmd = "/buyziptie",
    allowed = {TEAM_RABOTORGOVKA},
    pocket = false,
    onSpawn = function(self, pl)
    	self:Remove()
    	pl:Give('weapon_ziptie')
	end
})

-- Drug Dealer
rp.AddDrug('Трава', 'durgz_weed', 'models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl', 1250, TEAM_DRUGDEALER)
rp.AddDrug('Сигареты', 'durgz_cigarette', 'models/boxopencigshib.mdl', 500, TEAM_DRUGDEALER)
rp.AddDrug('ЛСД', 'durgz_lsd', 'models/smile/smile.mdl', 750, TEAM_DRUGDEALER)
rp.AddDrug('Грибы', 'durgz_mushroom', 'models/jellik/shroom.mdl', 1000, TEAM_DRUGDEALER)
rp.AddDrug('Кокаин', 'durgz_cocaine', 'models/cocn.mdl', 1500, TEAM_DRUGDEALER)
rp.AddDrug('Мет', 'durgz_meth', 'models/cocn.mdl', 1250, TEAM_DRUGDEALER)
rp.AddDrug('Соль', 'durgz_bathsalts', 'models/props_lab/jar01a.mdl', 2000, TEAM_DRUGDEALER)
rp.AddDrug('Отбеливатель', 'drugz_bleach', 'models/props_junk/garbage_plasticbottle001a.mdl', 500, TEAM_DRUGDEALER)
rp.AddDrug('Героин', 'durgz_heroine', 'models/katharsmodels/syringe_out/syringe_out.mdl', 1250, TEAM_DRUGDEALER)

rp.AddDrug('Пиво', 'durgz_beer', 'models/drug_mod/alcohol_can.mdl', 200, TEAM_BARTENDER)
rp.AddDrug('Содовая', 'drugz_soda', 'models/props_junk/PopCan01a.mdl', 400, TEAM_BARTENDER)
rp.AddDrug('Кофе', 'drugz_coffee', 'models/props_junk/garbage_coffeemug001a.mdl', 500, TEAM_BARTENDER)
rp.AddDrug('Вода', 'durgz_water', 'models/drug_mod/the_bottle_of_water.mdl', 350, TEAM_BARTENDER)
rp.AddDrug('Молоко', 'drugz_milk', 'models/props_junk/garbage_milkcarton001a.mdl', 2500, TEAM_BARTENDER)
rp.AddDrug('Аспирин', 'durgz_aspirin', 'models/jaanus/aspbtl.mdl', 500, TEAM_DOCTOR)

hook.Call('rp.AddEntities', GAMEMODE)

-- Ammo
rp.AddAmmoType("pistol", "Пистолетные патроны", "models/Items/BoxSRounds.mdl", 50, 50)
rp.AddAmmoType("357", "357 Патроны", "models/Items/BoxSRounds.mdl", 50, 50)
rp.AddAmmoType("buckshot", "Картечь для дробовика", "models/Items/BoxBuckshot.mdl", 50, 25)
rp.AddAmmoType("smg1", "СМГ Патроны", "models/Items/BoxSRounds.mdl", 100, 100)
rp.AddAmmoType("rifle", "Крупнокалиберные патроны", "models/Items/BoxSRounds.mdl", 100, 50)

-- Copshop
rp.AddCopItem('Коробка патронов', {
	Price = 150,
	Model = 'models/Items/BoxSRounds.mdl',
	Callback = function(pl)
		for k, v in ipairs(rp.ammoTypes) do
			pl:GiveAmmo(120, v.ammoType, true)
		end
	end
})

rp.AddCopItem('Здоровье', {
	Price = 50,
	Model = 'models/Items/HealthKit.mdl',
	Callback = function(pl)
		pl:SetHealth(100)
	end
})

rp.AddCopItem('Броня', {
	Price = 100,
	Model = 'models/props_junk/cardboard_box004a.mdl',
	Callback = function(pl)
		pl:SetArmor(100)
	end
})

rp.AddCopItem('M249 LMG', {
	Price = 30000,
	Model = 'models/weapons/w_m249_machine_gun.mdl',
	Callback = function(pl)
		pl:Give( "m9k_m249lmg" ).DisableDrop = true
	end
})
 
rp.AddCopItem('AI AW50', {
	Price = 100000,
	Model = 'models/weapons/w_acc_int_aw50.mdl',
	Callback = function(pl)
		pl:Give( "m9k_aw50" ).DisableDrop = true
	end
})

rp.AddCopItem('SPAS 12', {
	Price = 75000,
	Model = 'models/weapons/w_spas_12.mdl',
	Callback = function(pl)
		pl:Give( "m9k_spas12" ).DisableDrop = true
	end
})

rp.AddCopItem('AN-94', {
	Price = 15000,
	Model = 'models/weapons/w_rif_an_94.mdl',
	Callback = function(pl)
		pl:Give( "m9k_an94" ).DisableDrop = true
	end
})

rp.AddCopItem('Bizon PP19', {
	Price = 5000,
	Model = 'models/weapons/w_pp19_bizon.mdl',
	Callback = function(pl)
		pl:Give( "m9k_bizonp19" ).DisableDrop = true
	end
})

rp.AddCopItem('AK-47', {
	Price = 12000,
	Model = 'models/weapons/w_ak47_m9k.mdl',
	Callback = function(pl)
		pl:Give( "m9k_ak47" ).DisableDrop = true
	end
})

rp.AddCopItem('TEC-9', {
	Price = 5000,
	Model = 'models/weapons/w_intratec_tec9.mdl',
	Callback = function(pl)
		pl:Give( "m9k_tec9" ).DisableDrop = true
	end
})

rp.AddCopItem('HK G3A3', {
	Price = 25000,
	Model = 'models/weapons/w_hk_g3.mdl',
	Callback = function(pl)
		pl:Give( "m9k_g3a3" ).DisableDrop = true
	end
})

rp.AddCopItem('Паркур', {
	Price = 10000,
	Model = 'models/weapons/w_Pistol.mdl',
	Callback = function(pl)
		pl:Give( "climb_swep" ).DisableDrop = true
	end
})

rp.AddCopItem('C4', {
	Price = 150000,
	Model = 'models/weapons/2_c4_planted.mdl',
	Callback = function(pl)
		pl:Give("weapon_c4")
	end
})

if SERVER then
	hook.Add("CanDropWeapon", "DisallowCOPWeaponDrop", function(ply, wep)
		if wep.DisableDrop then
			return false
		end
	end)
end