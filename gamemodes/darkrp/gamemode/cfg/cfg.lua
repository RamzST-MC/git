-- Хочешь хороший интерфейс и самописные системы?
-- Обращайся в дискорд tgmain
-- Портфолио --> https://discord.gg/NFa42fEgxn
rp.cfg.StartMoney       = 25000

rp.cfg.DisguiseTime     = 300
rp.cfg.RagdollDelete    = 60

rp.cfg.OrgCost 				= 50000
rp.cfg.OrgBasicBankMax		= 100000
rp.cfg.OrgBankTax			= 0.01
rp.cfg.OrgRenameCost		= 50000
rp.cfg.OrgInviteCost		= 1000
rp.cfg.OrgMaxMembers		= 50
rp.cfg.OrgMaxMembersPremium	= 250
rp.cfg.OrgMaxRanks			= 5
rp.cfg.OrgMaxRanksPremium	= 30

rp.cfg.CreditSale 		= ''
rp.cfg.CreditsURL 		= ''

rp.cfg.AdvertCost       = 100

rp.cfg.HungerRate       = 4000 --1800

rp.cfg.RespawnTime      = 30

rp.cfg.PocketSpace      = 10 -- 80

rp.cfg.DoorTaxMin       = 10
rp.cfg.DoorTaxMax       = 500
rp.cfg.DoorCostMin      = 100
rp.cfg.DoorCostMax      = 2000

rp.cfg.ZiptieTime = 4
rp.cfg.ZiptieCutTime = 4
rp.cfg.ZiptieStruggleTime = 120
rp.cfg.ZiptieStruggleDifficultyFalloff = 180

rp.cfg.PropLimit        = 10000
rp.cfg.PropLimits = {
	["user"] = 50,
	["vip"] = 80,
	["dvip"] = 100,
	["dmoder"] = 120,
	["dadmin"] = 150,
	["dsuperadmin"] = 180,
	["downer"] = 200,
	["probation"] = 220,
	["helper"] = 240,
	["naboradmin"] = 245,
	["moder"] = 250,
	["admin"] = 260,
	["superadmin"] = 270,
	["owner"] = 570,
	["subcurator"] = 670,
	["curator"] = 570,
	["root"] = 10000,
}

rp.cfg.ChangeJobTime    = 5

-- Speed
rp.cfg.WalkSpeed        = 180
rp.cfg.RunSpeed         = 280

-- Printers
rp.cfg.PrintDelay       = 180
rp.cfg.PrintAmount      = 2500
rp.cfg.PrinterHPCost 	= 7
rp.cfg.InkCost          = 250

-- Hits
rp.cfg.HitExpire        = 600
rp.cfg.HitCoolDown      = 300
rp.cfg.HitMinCost       = 1000
rp.cfg.HitMaxCost       = 50000

-- Afk
rp.cfg.AfkDemote        = (60*60)*1
rp.cfg.AfkPropRemove    = (60*60)*3
rp.cfg.AfkDoorSell      = (60*60)*3

-- Lotto
rp.cfg.MinLotto         = 1000
rp.cfg.MaxLotto         = 50000

rp.cfg.DiscordURL		= 'https://discord.gg/wSTAZaxkNc'
rp.cfg.VKURL			= ''
rp.cfg.SteamURL			= 'https://steamcommunity.com/groups/MajesterRP'
rp.cfg.RulesURL			= 'https://docs.google.com/document/d/1QfS-w6wHjBwPsIHJUXfP8RrqMYG7yZEdKa-eieESscU/edit?usp=sharing'

rp.cfg.LockdownTime     = 300

rp.cfg.DefaultLaws 		= [[
Денежные Принтеры: Тюрьма
Нелегал: Тюрьма
Убийство, Взлом: Тюрьма
Оружие: Тюрьма
]]

rp.cfg.LockdownSounds = 'npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav'

-- Kazna
rp.cfg.CD = 60 * 60
rp.cfg.RobTime = 60 * 5
rp.cfg.KaznaStartMoney = 250000

rp.cfg.AllowedTeams = {
    TEAM_VIPGANG,
    TEAM_GANG,
}

rp.cfg.MayorRoom = {
	Vector(432.16607666016, 2671.96875, 271.95904541016),
    Vector(1854.0639648438, 1919.95703125, 72.03125)
}

rp.cfg.DisallowDrop = {
	arrest_stick 	= true,
	door_ram 		= true,
	gmod_camera 	= true,
	gmod_tool 		= true,
	keys 			= true,
	med_kit 		= true,
	itemstore_pickup    = true,
	stunstick 		= false,
	unarrest_stick 	= false,
	weapon_keypadchecker = true,
	weapon_physcannon = true,
	weapon_physgun 	= true,
	weaponchecker 	= true,
	weapon_fists 	= true,
	m9k_dbarrel     = true,
	m9k_barret_m82  = true,
	weapon_c4       = true,
	bb_css_c4_alt   = true,
	weapon_rpg      = true,
	weapon_slam     = true,
	weapon_crossbow = true,
	weapon_frag     = true
}

rp.cfg.DefaultWeapons = {
    'weapon_physcannon',
    'weapon_physgun',
    'gmod_tool',
    'keys',
    'weapon_fists',
    'inventory',
    'phone'
}

rp.cfg.TextSrceenFonts = {
    'Tahoma'
}

-- Automated announcements
if (CLIENT) then
    rp.cfg.AnnouncementDelay = 300
    rp.cfg.Announcements = {
        {ui.col.SUP, 'Есть жалоба или вопрос? Напишите в чате @ и причину вашей жалобы или подайте тикет в дискорд!'},
        {ui.col.SUP, 'Ждем тебя в нашем Discord Сервере > https://discord.gg/CGH6ax4n'},
        {ui.col.SUP, 'Быстрое меню команд вызывается клавишой "C"'},
        {ui.col.SUP, 'Отыграйте 1 час и получите vip на 30 дней Промокод: /promo vip в чат'},
        {ui.col.SUP, 'Ознакомиться с правилами сервера можно в F4 > Правила'},
        {ui.col.SUP, 'Чтобы открыть донат меню, используйте кнопку "F6"'},
        {ui.col.SUP, 'Добавь наш сервер во вкладку "Избранное"'}
    }
end

-- Cop shops
rp.cfg.CopShops = {
    rp_downtown_cat = {
		Pos =  Vector(4128.843750, -653.906250, 115.937500),
		Ang = Angle(0, 0, 0),
	}
}

rp.cfg.Dumpsters = {
    rp_downtown_cat = {
		big = {
			{Vector(3763.9714355469, 810.40130615234, -195), Angle(0, -90, 0)},
		},

		small = {
			{Vector(1850, 1102, 92), Angle(0, 90, 0)},
		}
	}
}

rp.cfg.ScrapTypes = {
    Metal = {
        Price = 250,
        Entity = 'crafting_scrap_metal'
    },
    Composite = {
        Price = 500,
        Entity = 'crafting_scrap_composite'
    },
    Pharmaceutical = {
        Price = 100,
        Entity = 'crafting_scrap_pharmaceutical'
    },
    Organic = {
        Price = 100,
        Entity = 'crafting_scrap_organic'
    }
}

rp.cfg.SpawnDisallow = {
    prop_physics        = true,
    ent_textscreen      = true,
    metal_detector      = true,
    gmod_light          = true,
    gmod_lamp           = true,
    keypad              = true,
    gmod_button         = true,
    gmod_cameraprop     = true
}

rp.cfg.Spawns = { 
	rp_downtown_cat = {
		Vector(-1941.3321533203, -1271.4119873047, -215.96875),
		Vector(-1023.968750, -4519.958008, 50),
	},
}

rp.cfg.TeamSpawns = rp.cfg.TeamSpawns or {
    [game.GetMap()]= {}
}

rp.cfg.SpawnPos = rp.cfg.SpawnPos or {
    rp_downtown_cat = {
		Vector(-1941.3321533203, -1271.4119873047, -215.96875),
	}
}

-- Jail
rp.cfg.WantedTime       = 300
rp.cfg.WarrantTime      = 300
rp.cfg.ArrestTime       = 300

rp.cfg.Jails = {
    rp_downtown_cat = {
		Vector(5096, -356, 477),
		Vector(4043, -1459, -429),
    },
}

rp.cfg.JailPos = {
	rp_downtown_cat = {
		Vector(4815, -613, -298),
		Vector(4810, -850, -298),
		Vector(4825, -1080, -298),
		Vector(4846, -1038, -298),
		Vector(4815, -613, -151),
		Vector(4810, -850, -151),
		Vector(4825, -1080, -151),
		Vector(4846, -1038, -151),
    },
}

local hour = (60 * 60)
rp.cfg.PlayTimeRanks = {
    {'Новичок', 0},
    {'Опытный Новичок', (hour * 5)},
    {'Попрошайка', (hour * 10)},
    {'Ученик', (hour * 15)},
    {'Студент', (hour * 20)},
    {'Работяга', (hour * 25)},
    {'Задира', (hour * 30)},
    {'Уличный Хулиган', (hour * 35)},
    {'Ворюга', (hour * 40)},
    {'Кто-то', (hour * 45)},
    {'Опытный Игрок', (hour * 50)},
    {'Пистолетный Хулиган', (hour * 55)},
    {'Трудоголик', (hour * 60)},
    {'Солдат', (hour * 65)},
    {'Главарь', (hour * 70)},
    {'Заместитель Босса', (hour * 75)},
    {'Советник Босса', (hour * 80)},
    {'Уволенный', (hour * 85)},
    {'Да да я!', (hour * 90)},
    {'Скоро что-то будет', (hour * 95)},
    {'Босс', (hour * 100)},
    {'Я знаю все', (hour * 150)},
    {'Профессиональный Гражданин', (hour * 200)},
    {'Организатор', (hour * 250)},
    {'Токсичный', (hour * 300)},
    {'Оружейный Барон', (hour * 350)},
    {'Плакса', (hour * 400)},
    {'Рейдер', (hour * 420)},
    {'Плохой Рейдер', (hour * 450)},
    {'Миллиардер Больших денег', (hour * 500)},
    {'Юридически Отсталый', (hour * 550)},
    {'Незаконно Интеллектуальный', (hour * 600)},
    {'Анимешник', (hour * 650)},
    {'Хентайщик', (hour * 700)},
    {'БДСМ', (hour * 750)},
    {'Строитель', (hour * 800)},
    {'Опытный Строитель', (hour * 850)},
    {'Ниггер', (hour * 900)},
    {'Жопо-Горящий', (hour * 950)},
    {'400 IQ', (hour * 1000)},
    {'Да? и что?', (hour * 1100)},
    {'Чо?', (hour * 1200)},
    {'Дерьмо на Дерьме', (hour * 1300)},
    {'ЛоЛялист', (hour * 1400)},
    {'Вкусное Занятие', (hour * 1500)},
    {'Ламповый', (hour * 1600)},
    {'Детектив', (hour * 1700)},
    {'Святой', (hour * 1800)},
    {'Божественный', (hour * 1900)},
    {'2k', (hour * 2000)},
    {'Привет, я маленькая девочка ', (hour * 2500)},
    {'Что? Где я?', (hour * 3000)},
    {'Ебанутый тип', (hour * 50000)},
}

rp.cfg.weapontablez = {
	['Пистолеты'] = {
		"swb_357",
		"swb_deagle",
		"swb_fiveseven",
		"swb_glock18",
		"swb_p228",
		"swb_usp",
		"m9k_colt1911",
		"m9k_coltpython",
		"m9k_deagle",
		"m9k_glock",
		"m9k_usp",
		"m9k_usp",
		"m9k_m29satan",
		"m9k_m92beretta",
		"m9k_luger",
		"m9k_ragingbull",
		"m9k_scoped_taurus",
		"m9k_remington1858",
		"m9k_model3russian",
		"m9k_model500",
		"m9k_model627",
		"m9k_sig_p229r",
		"m9k_sdbarrel",
		"m9k_tec9",
		"unclen8_m9a1",
		"unclen8_rhino",
		"unclen8_anaconda",
		"unclen8_python",
		"unclen8_deagle",
		"unclen8_57",
		"unclen8_fnp",
		"unclen8_deagold",
		"unclen8_usp",
		"unclen8_casull",
		"bb_usp_alt",
		"unclen8_mr96",
		"unclen8_mateba",
		"unclen8_tac1911",
		"unclen8_rex",
		"unclen8_m500",
		"unclen8_judge",
		"unclen8_p99",
	},

	['ПП'] = {
		"swb_p90",
		"swb_mp5",
		"swb_ump",
		"swb_mac10",
		"swb_tmp",
		"m9k_honeybadger",
		"m9k_bizonp19",
		"m9k_smgp90",
		"m9k_mp5",
		"m9k_mp7",
		"m9k_ump45",
		"m9k_usc",
		"m9k_kac_pdw",
		"m9k_vector",
		"m9k_magpulpdr",
		"m9k_mp40",
		"m9k_mp5sd",
		"m9k_mp9",
		"m9k_sten",
		"m9k_thompson",
		"m9k_uzi",
	},

	['Дробовики'] = {
		"swb_m3super90",
		"swb_xm1014",
		"m9k_m3",
		"m9k_browningauto5",
		"m9k_dbarrel",
		"m9k_ithacam37",
		"m9k_ksg12",
		"m9k_mossberg590",
		"m9k_jackhammer",
		"m9k_remington870",
		"m9k_spas12",
		"m9k_striker12",
		"m9k_usas",
		"m9k_1897winchester",
		"m9k_1887winchester",
		"unclen8_benelli",
		"unclen8_bulldog",
		"unclen8_spas",
		"unclen8_icarus",
		"unclen8_ithaca",
		"unclen8_ksg",
		"unclen8_870",
		"unclen8_saiga12",
		"unclen8_stevens",
		"unclen8_1887",
		"unclen8_1897",
	},

	['Тяжелое оружие'] = {
		"m9k_ares_shrike",
		"m9k_fg42",
		"m9k_m1918bar",
		"m9k_minigun",
		"m9k_m249lmg",
		"m9k_m60",
		"m9k_pkm",
		"m9k_p416",
		"m9k_p416_acog",
		"m9k_p416_silenced",
		"m9k_p416_acog_silenced",
		"m9k_winchester73",
		"m9k_acr",
		"m9k_ak47",
		"m9k_ak74",
		"m9k_amd65",
		"m9k_an94",
		"m9k_val",
		"m9k_f2000",
		"m9k_famas",
		"m9k_fal",
		"m9k_g36",
		"m9k_m416",
		"m9k_g3a3",
		"m9k_l85",
		"m9k_m14sp",
		"m9k_m16a4_acog",
		"m9k_m4a1",
		"m9k_scar",
		"m9k_vikhr",
		"m9k_auga3",
		"m9k_tar21",
		"m9k_aw50",
		"m9k_barret_m82",
		"m9k_m98b",
		"m9k_svu",
		"m9k_sl8",
		"m9k_intervention",
		"m9k_m24",
		"m9k_psg1",
		"m9k_remington7615p",
		"m9k_dragunov",
		"m9k_svt40",
		"m9k_contender",
		"m9k_vss",
		"unclen8_mg3",
		"unclen8_m60",
		"unclen8_m249",
		"unclen8_chainsaw",
		"unclen8_hk23",
		"unclen8_as50",
		"unclen8_awm",
		"unclen8_l115",
		"unclen8_altbarrett",
		"unclen8_barrett",
		"unclen8_m95",
		"unclen8_m98b",
		"unclen8_amr",
		"unclen8_msr",
		"unclen8_usr",
		"bb_scout_alt",
		"bb_xm1014_alt",
		"bb_m3_alt",
	},

	['Взрывчатка'] = {
		"weapon_c4",
		"weapon_incendiary"
	},

	['test'] = {
		"m9k_contender",
		"m9k_m24",
	},

	['all'] = {},
}

rp.cfg.allowedW = {
    ['TEAM_CITIZEN']     = {'Пистолеты'},
    ['TEAM_BISNES']     = {'Пистолеты', 'ПП'},
    ['TEAM_WHORE']     = {'Пистолеты'},
    ['TEAM_HOBO']     = {'Пистолеты'},
    ['TEAM_HOBOKING']     = {'Пистолеты'},
    ['TEAM_JUNKIE']     = {'Пистолеты'},
    ['TEAM_MAYOR']     = {'Пистолеты'},
    ['TEAM_SECMAYOR']     = {'all'},
    ['TEAM_FBI']     = {'all'},
    ['TEAM_COMFBI']     = {'all'},
    ['TEAM_CHIEF']     = {'all'},
    ['TEAM_POLICE']     = {'all'},
    ['TEAM_GANGSTER']     = {'all'},
    ['TEAM_KARMAN']     = {'Пистолеты', 'ПП'},
    ['TEAM_VIPGANG']     = {'all'},
    ['TEAM_THIEF']     = {'all'},
    ['TEAM_THIEFPRO']     = {'all'},
    ['TEAM_GUN']     = {'all'},
	['TEAM_DUI']	= {'all'},
    ['TEAM_BMIDEALER']     = {'Пистолеты', 'ПП', 'Дробовики'},
    ['TEAM_DRUGDEALER']     = {'Пистолеты', 'ПП', 'Дробовики'},
    ['TEAM_METOVAR']     = {'Пистолеты', 'ПП'},
    ['TEAM_DRUGMAKER']     = {'Пистолеты', 'ПП'},
    ['TEAM_DISTILLER']     = {'Пистолеты', 'ПП'},
    ['TEAM_BARTENDER']     = {'Пистолеты'},
    ['TEAM_COOK']     = {'Пистолеты'},
    ['TEAM_HITMAN']     = {'all'},
    ['TEAM_SECURITY']     = {'all'},
    ['TEAM_RABOTORGOVKA']     = {'all'},
    ['TEAM_DJ']     = {'Пистолеты'},
    ['TEAM_BANK']     = {'Пистолеты'},
    ['TEAM_DOCTOR']     = {'Пистолеты', 'ПП'},
    ['TEAM_FREERUNNER']     = {'Пистолеты'},
    ['TEAM_CASINOOWNER']     = {'Пистолеты'},
	['TEAM_BITMINER'] = {'Пистолеты'},
	['TEAM_VIPHITMAN'] = {'test'}
}

rp.cfg.WeaponsLimit = {
    [1] = {"csgo_bayonet_tiger", "weapon_physcannon", "m9k_ak47", "m9k_an94", "m9k_famas", "m9k_g36", "m9k_g3a3", "m9k_l85", "m9k_m14sp", "m9k_ares_shrike", "m9k_fg42", "m9k_m249lmg", "m9k_colt1911", "m9k_coltpython", "m9k_usp", "m9k_m92beretta", "m9k_m3", "m9k_browningauto5", "m9k_spas12", "m9k_aw50", "m9k_sl8", "m9k_m24", "m9k_bizonp19", "m9k_smgp90", "m9k_ump45", "m9k_tec9", "weapon_vape", "swb_357", "swb_ak47", "swb_awp", "swb_deagle", "swb_famas", "swb_fiveseven", "swb_p90", "swb_g3sg1", "swb_glock18", "swb_mp5", "swb_galil", "swb_knife", "swb_m249", "swb_m3super90", "swb_m4a1", "swb_mac10", "swb_p228", "swb_sg550", "swb_sg552", "swb_aug", "swb_scout", "swb_tmp", "swb_usp", "swb_xm1014"},
	[2] = {"m9k_m3","m9k_browningauto5","m9k_spas12","csgo_bayonet_tiger","weapon_bugbait","weapon_physcannon","csgo_butterfly_crimsonwebs","csgo_butterfly_damascus","csgo_butterfly_tiger","csgo_huntsman_damascus","csgo_huntsman_slaughter","csgo_huntsman_tiger","csgo_karambit_crimsonwebs","csgo_karambit_fade","csgo_karambit_tiger","csgo_m9","csgo_m9_crimsonwebs","csgo_m9_damascus","csgo_m9_fade","m9k_1887winchester","m9k_1897winchester","m9k_acr","m9k_ak74","m9k_amd65","m9k_val","m9k_f2000","m9k_fal","m9k_m416","m9k_m16a4_acog","m9k_m4a1","m9k_scar","m9k_vikhr","m9k_tar21","m9k_auga3","m9k_m24","m9k_sl8","m9k_m1918bar","m9k_m60","m9k_pkm","m9k_ithacam37","m9k_mossberg590","m9k_jackhammer","m9k_remington870","m9k_striker12","m9k_winchester73","m9k_psg1","m9k_ares_shrike","m9k_fg42","m9k_m249lmg","m9k_aw50","m9k_m98b","m9k_svu","m9k_intervention","m9k_remington7615p","m9k_dragunov","m9k_svt40","m9k_contender","m9k_honeybadger","m9k_mp5","m9k_mp7","m9k_usc","m9k_kac_pdw","m9k_vector","m9k_magpulpdr","m9k_mp40","m9k_mp5sd","m9k_mp9","m9k_sten","m9k_thompson","m9k_uzi","weapon_medkit","itemstore_checker","itemstore_pickup","m9k_deagle","m9k_glock","m9k_hk45","m9k_m29satan","m9k_luger","m9k_ragingbull","m9k_scoped_taurus","m9k_model3russian","m9k_model500","m9k_model627","m9k_sig_p229r", "weapon_vape", "swb_357", "swb_ak47", "swb_awp", "swb_deagle", "swb_famas", "swb_fiveseven", "swb_p90", "swb_g3sg1", "swb_glock18", "swb_mp5", "swb_galil", "swb_knife", "swb_m249", "swb_m3super90", "swb_m4a1", "swb_mac10", "swb_p228", "swb_sg550", "swb_sg552", "swb_aug", "swb_scout", "swb_tmp", "swb_usp", "swb_xm1014"},
	[3] = {'weapon_cigarette_camel', 'weapon_ciga', 'weapon_cigarette_newport', 'deployable_shield', 'heavy_shield', 'riot_shield', 'bb_ak47_alt', 'bb_awp_alt', 'bb_deagle_alt', 'bb_dualelites_alt', 'bb_famas_alt', 'bb_fiveseven_alt', 'bb_p90_alt', 'bb_g3sg1_alt', 'bb_galil_alt', 'bb_glock_alt', 'bb_ump45_alt', 'bb_usp_alt', 'bb_m249_alt', 'bb_m3_alt', 'bb_m4a1_alt', 'bb_mac10_alt', 'bb_mp5_alt', 'bb_p228_alt', 'bb_scout_alt', 'bb_sg550_alt', 'bb_sg552_alt', 'bb_aug_alt', 'bb_tmp_alt', 'bb_xm1014_alt', 'weapon_357', 'weapon_pistol', 'weapon_bugbait', 'weapon_crossbow', 'weapon_crowbar', 'weapon_ar2', 'weapon_rpg', 'weapon_shotgun', 'weapon_smg1', 'weapon_stunstick', 'm9k_winchester73', 'm9k_acr', 'm9k_ak47', 'm9k_ak74', 'm9k_amd65', 'm9k_an94', 'm9k_val', 'm9k_f2000', 'm9k_famas', 'm9k_fal', 'm9k_g36', 'm9k_m416', 'm9k_g3a3', 'm9k_l85', 'm9k_m14sp', 'm9k_m16a4_acog', 'm9k_m4a1', 'm9k_scar', 'm9k_vikhr', 'm9k_auga3', 'm9k_tar21', 'm9k_ares_shrike', 'm9k_fg42', 'm9k_m249lmg', 'm9k_m60', 'm9k_pkm', 'm9k_colt1911', 'm9k_coltpython', 'm9k_deagle', 'm9k_glock', 'm9k_usp', 'm9k_hk45', 'm9k_m29satan', 'm9k_m92beretta', 'm9k_luger', 'm9k_ragingbull', 'm9k_scoped_taurus', 'm9k_remington1858', 'm9k_model3russian', 'm9k_model500', 'm9k_model627', 'm9k_sig_p229r', 'm9k_m3', 'm9k_browningauto5', 'm9k_dbarrel', 'm9k_sdbarrel', 'm9k_ithacam37', 'm9k_ksg12', 'm9k_mossberg590', 'm9k_jackhammer', 'm9k_remington870', 'm9k_spas12', 'm9k_striker12', 'm9k_usas', 'm9k_1897winchester', 'm9k_1887winchester', 'm9k_aw50', 'm9k_barret_m82', 'm9k_m98b', 'm9k_svu', 'm9k_sl8', 'm9k_intervention', 'm9k_m24', 'm9k_psg1', 'm9k_remington7615p', 'm9k_dragunov', 'm9k_svt40', 'm9k_contender', 'm9k_vss', 'm9k_honeybadger', 'm9k_bizonp19', 'm9k_smgp90', 'm9k_mp5', 'm9k_mp7', 'm9k_ump45', 'm9k_usc', 'm9k_kac_pdw', 'm9k_vector', 'm9k_magpulpdr', 'm9k_mp40', 'm9k_mp5sd', 'm9k_mp9', 'm9k_sten', 'm9k_tec9', 'm9k_thompson', 'm9k_uzi', 'weapon_medkit', 'gmod_camera', 'weapon_fidget', 'climb_swep', 'lockpick', 'keypad_cracker', 'climb_swep', 'knife_bayonet_fade', 'knife_bayonet_night', 'knife_bayonet_slaughter', 'knife_m9_ultraviolet', 'knife_bowie', 'knife_bowie_ddpat', 'knife_bowie_rust_coat', 'knife_butterfly_crimsonweb', 'knife_butterfly_damascus', 'knife_butterfly_night', 'knife_butterfly_slaughter', 'knife_default_t_golden', 'knife_falchion_crimsonwebs', 'knife_falchion_freehand', 'knife_falchion_tiger', 'knife_flip_autotronic', 'knife_flip_crimsonwebs', 'knife_flip_fade', 'knife_gut', 'knife_gut_laminate', 'knife_gut_case', 'knife_gut_lore_vladdy', 'knife_huntsman_boreal', 'knife_huntsman_marble_fade', 'knife_huntsman_tiger', 'knife_karambit_fade', 'knife_karambit_lore', 'knife_m9_bayonet_lore', 'knife_daggers_damascus', 'knife_shadow_default', 'knife_daggers_fade', 'knife_shadow_freehand', 'weapon_vape'}
}

rp.cfg.RankWeapons = {
	['curator'] = rp.cfg.WeaponsLimit[3],
	['owner'] = rp.cfg.WeaponsLimit[3],
	['superadmin'] = rp.cfg.WeaponsLimit[3],
	['moder'] = rp.cfg.WeaponsLimit[2],
	['admin'] = rp.cfg.WeaponsLimit[2],
	['helper'] = rp.cfg.WeaponsLimit[2],
	['naboradmin'] = rp.cfg.WeaponsLimit[2],
	['downer'] = rp.cfg.WeaponsLimit[1],
}