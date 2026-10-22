local citizens = {'models/player/Group01/Female_01.mdl', 'models/player/Group01/Female_02.mdl', 'models/player/Group01/Female_03.mdl', 'models/player/Group01/Female_04.mdl', 'models/player/Group01/Female_06.mdl', 'models/player/group01/male_01.mdl', 'models/player/Group01/Male_02.mdl', 'models/player/Group01/male_03.mdl', 'models/player/Group01/Male_04.mdl', 'models/player/Group01/Male_05.mdl', 'models/player/Group01/Male_06.mdl', 'models/player/Group01/Male_07.mdl', 'models/player/Group01/Male_08.mdl', 'models/player/Group01/Male_09.mdl', 'models/player/Group02/male_02.mdl', 'models/player/Group02/male_04.mdl', 'models/player/Group02/male_06.mdl', 'models/player/Group02/male_08.mdl',}
local gangsters = {
    'models/tnrp/player/dripcitizen/male_01.mdl',
    'models/tnrp/player/dripcitizen/male_02.mdl',
    'models/tnrp/player/dripcitizen/male_03.mdl',
    'models/tnrp/player/dripcitizen/male_04.mdl',
    'models/tnrp/player/dripcitizen/male_05.mdl',
    'models/tnrp/player/dripcitizen/male_06.mdl',
    'models/tnrp/player/dripcitizen/male_07.mdl',
    'models/tnrp/player/dripcitizen/male_08.mdl',
    'models/tnrp/player/dripcitizen/male_09.mdl',
    'models/tnrp/player/dripcitizen/male_10.mdl',
    'models/tnrp/player/dripcitizen/male_11.mdl',
    'models/tnrp/player/dripcitizen/male_12.mdl',
}

local MedModels = {'models/player/kerry/medic/medic_01.mdl', 'models/player/kerry/medic/medic_02.mdl', 'models/player/kerry/medic/medic_03.mdl', 'models/player/kerry/medic/medic_04.mdl', 'models/player/kerry/medic/medic_05.mdl', 'models/player/kerry/medic/medic_06.mdl', 'models/player/kerry/medic/medic_07.mdl'}

TEAM_CITIZEN = rp.addTeam('Гражданин +', {
    color = Color(150, 170, 200),
    model = citizens,
    weapons = {},
    command = 'citizen',
    max = 0,
    salary = 5,
    hasLicense = false,
    description =
[[Обычный житель города, ищущий работу
и новые возможности.
Без оружия и особых привилегий.]],
    candemote = false
})

TEAM_BISNES = rp.addTeam("Бизнесмен +", {
    color = Color(255, 157, 0),
    model = citizens,
    weapons = {},
    command = "bisnes",
    max = 3,
    salary = 100,
    admin = 0,
    description =
[[Владельцы предприятий, зарабатывают
деньги легальным путем.
Умеют вести переговоры и развивать
экономику города.]],
    vote = false
})

TEAM_WHORE = rp.addTeam('Проститутка +', {
    color = Color(252, 0, 255),
    model = 'models/player/doa_honoka_bunny.mdl',
    description = [[
    Вы продаете свое тело за деньги.
    Доступные команды: /sex
    ]],
    GetRelationships = function() return {TEAM_WHORE} end,
    weapons = {},
    command = 'Prostitute',
    max = 3,
    salary = 50,
    candemote = false,
    description =
[[Зарабатывает на жизнь, оказывая
интимные услуги за деньги.
Доступны специальные команды
для работы.]],
    Hoe = true,
})

TEAM_ADMIN = rp.addTeam('Администратор', {
    color = Color(30, 144, 255),
    category = '[0] Без категории',
    model = 'models/player/combine_super_soldier.mdl',
    weapons = {'weapon_keypadchecker', 'handcuffs', 'moneychecker', 'itemstore_checker'},
    command = 'staff',
    max = 0,
    salary = 0,
    nelzamask = 1,
    candemote = false,
    nonrp = true,
    hasLicense = true,
    CannotOwnDoors = true,
   --Paytime = 60 * 60 * 12,
    description = [[Следит за порядком на сервере,
обладает особыми инструментами для
проверки игроков и соблюдения
правил.]],
    PlayerSpawn = function(pl)
        pl:GodEnable()
        pl:SetHealth(500)
    end,
    customCheck = function(pl) return (pl:IsAdmin() or pl:GetUserGroup() == "moder")end,
    CustomCheckFailMsg = 'JobNeedsAdmin'
})
/*
TEAM_DUI = rp.addTeam('заебал', {
    color = Color(71, 255, 30),
    category = '[0] Без категории',
    model = 'models/an0nymous56/duo_the_owl/duo.mdl',
    weapons = {},
    command = 'duolingo',
    max = 0,
    salary = 0,
    nelzamask = 1,
    candemote = false,
    nonrp = true,
    hasLicense = true,
    CannotOwnDoors = true,
    description = [[даун ненавижу]],
    PlayerSpawn = function(pl)
        pl:SetHealth(500)
    end,
    customCheck = function(pl) return (pl:IsRoot()) end,
    CustomCheckFailMsg = 'JobNeedsAdmin'
})
*/
--
-- Hobos
--
local spawnHobo = function(pl) pl:SetHunger(25) end
TEAM_HOBO = rp.addTeam('Бездомный +', {
    color = Color(80, 45, 0),
    category = '[5] Бездомные',
    model = 'models/player/corpse1.mdl',
    GetRelationships = function() return {TEAM_HOBOKING, TEAM_HOBO} end,
    weapons = {'weapon_bugbait'},
    command = 'hobo',
    max = 0,
    salary = 0,
    hasLicense = false,
    candemote = false,
    hobo = true,
    CannotOwnDoors = true,
    description = [[Живет на улице, может просить
милостыню и кидаться мусором.
Не может владеть дверьми.]],
    PlayerSpawn = spawnHobo
})

TEAM_HOBOKING = rp.addTeam('Король Бездомных +', {
    color = Color(80, 45, 0),
    category = '[5] Бездомные',
    model = 'models/player/corpse1.mdl',
    GetRelationships = function() return {TEAM_HOBOKING, TEAM_HOBO} end,
    weapons = {'weapon_bugbait'},
    command = 'hoboking',
    max = 1,
    salary = 0,
    hasLicense = false,
    candemote = false,
    hobo = true,
    vip = true,
    CannotOwnDoors = true,
    description = [[Повелитель бездомных.
Устраивайте шествия против правительства
Зарабатывайте на мусоре.]],
    PlayerSpawn = spawnHobo
})
/*
TEAM_JUNKIE = rp.addTeam('Торчок', {
	color = Color(50, 35, 0),
    category = '[5] Бездомные',
    model = 'models/player/charple.mdl',
    GetRelationships = function() return {TEAM_HOBOKING, TEAM_HOBO} end,
    weapons = {"weapon_vape"},
    command = 'junkie',
    max = 5,
    salary = 0,
    hasLicense = false,
    candemote = false,
    hobo = true,
    vip = true,
    CannotOwnDoors = true,
    description = [[Подсев на вещества, вы потеряли всё.
Вы быстрый. Мало здоровья.]],
    PlayerSpawn = function(ply)
        timer.Simple(1, function()
            if !IsValid(ply) then return end

            ply:SetMaxHealth(50)
            ply:SetHealth(50)
            ply:SetWalkSpeed(240)
            ply:SetRunSpeed(320)
        end)
    end,
})*/

TEAM_MAYOR = rp.addTeam('Глава Города +', {
    category = '[3] Правопорядок',
    color = Color(240, 0, 0, 255),
    model = 'models/player/breen.mdl',
    weapons = {},
    command = 'mayor',
    max = 1,
    salary = 500,
    nelzamask = 1,
    vote = true,
    candemote = false,
    hasLicense = true,
    mayor = true,
    PoliceChief = true,
    CannotOwnDoors = false,
    spawns = {
        rp_downtown_cat = {
            Vector(5168.0698242188, 1376.7249755859, -11.96875)
        }
    },
    description = [[Главный управляющий,
контролирует законы, финансы и
безопасность города.]],
})

TEAM_SECMAYOR = rp.addTeam('Охранник Главы Города +', {
    category = '[3] Правопорядок',
    color = Color(240, 0, 0, 255),
    model = 'models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl',
    weapons = {'handcuffs', 'm9k_m249lmg', 'arrest_baton'},
    command = 'mayorsecurity',
    max = 1,
    playtime = 60 * 60 * 12,
    salary = 350,
    nelzamask = 1,
    vip = true,
    candemote = false,
    hasLicense = true,
    police = true,
    CannotOwnDoors = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(250)
        ply:SetHealth(250)
        ply:SetArmor(250)
        ply:SetMaxArmor(250)
        ply:SetWalkSpeed(240)
        ply:SetRunSpeed(320)
    end,
    spawns = police_spawns,
    description = [[Личная охрана мэра, обладает оружием
и улучшенными характеристиками.
Следит за его безопасностью.]],
spawns = {
        rp_downtown_cat = {
            Vector(5118.6909179688, 118.96940612793, -11.96875)
        }
    },
})

TEAM_FBI = rp.addTeam('Агент FBI +', {
    color = Color(83,83,242),
    model = {'models/player/police_agent/male_01_agent.mdl', 'models/player/police_agent/male_02_agent.mdl', 'models/player/police_agent/male_03_agent.mdl', 'models/player/police_agent/male_04_agent.mdl', 'models/player/police_agent/male_05_agent.mdl', 'models/player/police_agent/male_06_agent.mdl', 'models/player/police_agent/male_07_agent.mdl', 'models/player/police_agent/male_08_agent.mdl', 'models/player/police_agent/male_09_agent.mdl'},
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'arrest_baton', 'stun_baton', 'door_ram', 'handcuffs', 'weapon_radio', 'bb_glock_alt', 'maskirovka'},
    command = 'fbi',
    max = 5,
    salary = 35,
    admin = 0,
    candemote = true,
    category = "[3] Правопорядок",
    hasLicense = true,
    CannotOwnDoors = true,
    candisguise = true,
    selldoors = true,
    police = true,
    description = [[Специалист по расследованиям и
арестам, имеет право на обыски
и участие в рейдах.
Работает под прикрытием.]],
spawns = {
        rp_downtown_cat = {
            Vector(4268.9755859375, 846.55743408203, -195.96875)
        }
    },
})

TEAM_COMFBI = rp.addTeam('Директор FBI  +', {
    color = Color(62,62,195),
    model = 'models/fbi/player/mehdi/fbi04.mdl',
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'arrest_baton', 'stun_baton', 'door_ram', 'handcuffs', 'weapon_radio', 'bb_mp5_alt', 'maskirovka'},
    command = 'comfbi',
    max = 1,
    salary = 80,
    admin = 0,
    candemote = true,
    category = "[3] Правопорядок",
    hasLicense = true,
    CannotOwnDoors = true,
    candisguise = true,
    PoliceChief = true,
    vip = true,
    police = true,
    description = [[Руководитель агентов FBI,
управляет операциями и
координирует борьбу с преступностью.]],
spawns = {
        rp_downtown_cat = {
            Vector(4088.1652832031, 670.82379150391, -195.96875)
        }
    },
    PlayerSpawn = function(pl) pl:SetArmor(150) pl:SetMaxArmor(150) pl:SetMaxHealth(120) pl:SetHealth(120) pl:GiveAmmos(200) end
})

TEAM_CHIEF = rp.addTeam('Начальник Полиции +', {
    color = Color(60, 80, 255),
    model = 'models/gta5/player/deputypm.mdl',
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'arrest_baton', 'm9k_usp', 'm9k_mp5', 'stun_baton', 'door_ram', 'handcuffs', 'weapon_radio'},
    spawns = police_spawns,
    command = 'chief',
    max = 1,
    salary = 45,
    admin = 0,
    category = "[3] Правопорядок",
    candemote = true,
    CannotOwnDoors = true,
    hasLicense = true,
    PoliceChief = true,
    police = true,
    description = [[Главный офицер полиции, отвечает за
подчиненных, организует операции
и следит за порядком.]],
spawns = {
        rp_downtown_cat = {
            Vector(4208.4106445312, 659.57641601562, -195.96875)
        }
    },
    PlayerSpawn = function(pl) pl:SetArmor(70) pl:GiveAmmos(200) end
})

TEAM_POLICE = rp.addTeam('Полицейский +', {
    color = Color(60, 80, 255),
    model = {'models/player/nypd/male_02.mdl', 'models/player/nypd/male_04.mdl', 'models/player/nypd/male_05.mdl', 'models/player/nypd/male_06.mdl', 'models/player/nypd/male_07.mdl', 'models/player/nypd/male_08.mdl', 'models/player/nypd/male_09.mdl'},
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'arrest_baton', 'm9k_usp', 'stun_baton', 'door_ram', 'handcuffs'},
    spawns = police_spawns,
    command = 'police',
    max = 10,
    salary = 20,
    admin = 0,
    category = "[3] Правопорядок",
    CannotOwnDoors = true,
    hasLicense = true,
    selldoors = true,
    police = true,
    description = [[Обычный сотрудник полиции,
патрулирует улицы, ловит преступников
и следит за соблюдением законов.]],
spawns = {
        rp_downtown_cat = {
            Vector(4263.5771484375, 725.36968994141, -195.96875)
        }
    },
    PlayerSpawn = function(pl) pl:SetArmor(35) pl:GiveAmmos(200) end
})

/*
TEAM_WARDEN = rp.addTeam('Начальник Тюрьмы +', {
    color = Color(60, 80, 255),
    model = {'models/TinyDevs/ArmedForcesofKazakhstan/office/pm/military_suit_general.mdl'},
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'arrest_baton', 'm9k_usp', 'stun_baton', 'door_ram', 'handcuffs'},
    spawns = police_spawns,
    command = 'warden',
    max = 10,
    salary = 20,
    admin = 0,
    category = "[3] Правопорядок",
    CannotOwnDoors = true,
    hasLicense = true,
    selldoors = true,
    police = true,
    vote = true,
    description = [[Обычный сотрудник полиции,
патрулирует улицы, ловит преступников
и следит за соблюдением законов.]],
    PlayerSpawn = function(pl) pl:SetArmor(35) pl:GiveAmmos(200) end
})
**/

/*
TEAM_PRISONGUARD = rp.addTeam('Охранник Тюрьмы +', {
    color = Color(60, 80, 255),
    model = {'models/TinyDevs/ArmedForcesofKazakhstan/summer/pm/specnaz_sunkar_black.mdl'},
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'arrest_baton', 'm9k_usp', 'stun_baton', 'door_ram', 'handcuffs'},
    spawns = police_spawns,
    command = 'prisonguard',
    max = 10,
    salary = 20,
    admin = 0,
    category = "[3] Правопорядок",
    CannotOwnDoors = true,
    hasLicense = true,
    selldoors = true,
    police = true,
    description = [[Обычный сотрудник полиции,
патрулирует улицы, ловит преступников
и следит за соблюдением законов.]],
    PlayerSpawn = function(pl) pl:SetArmor(35) pl:GiveAmmos(200) end
})
*/

TEAM_GANGSTER = rp.addTeam('Мафия +', {
    category = '[2] Криминал',
    color = Color(70, 70, 70),
    model = gangsters,
    CanRaid = true,
    CanMug = true,
    CanHostage = true,
    GetRelationships = function() return {TEAM_MOBBOSS, TEAM_VIPGANGSTER, TEAM_GANGSTER, TEAM_GRAB} end,
    weapons = {'moneychecker'},
    command = 'nmobboss',
    canrobbank = true,
    candisguise = true,
    max = 10,
    nelzamask = 1,
    salary = 300,
    description = [[Член преступной группировки,
занимается грабежами,
похищениями и другими нелегальными
делами.]],
    candemote = true,
    canrobbery = true
})

TEAM_KARMAN = rp.addTeam('Карманник +', {
    category = '[2] Криминал',
    color = Color(70, 70, 70),
    model = gangsters,
    CanRaid = false,
    CanMug = false,
    CanHostage = false,
    weapons = {"grabej", 'moneychecker'},
    command = 'karman',
    max = 4,
    salary = 75,
    description = [[Опытный вор, специализируется
на карманных кражах,
не участвует в рейдах и нападениях.]],
    candemote = true,
    vip = true
})

TEAM_VIPGANG = rp.addTeam('Мафия VIP +', {
    category = '[2] Криминал',
    color = Color(70, 70, 70),
    model = gangsters,
    CanRaid = true,
    CanMug = true,
    CanHostage = true,
    weapons = {'lockpick', 'moneychecker', 'm9k_mp5'},
    command = 'vipgangster',
    canrobbank = true,
    candisguise = true,
    max = 10,
    vip = true,
    salary = 250,
    description = [[Опытный преступник.
Имеет доступ к инструментам для
взломов и ограблений банков.

Увеличенная количество брони]],
    candemote = true,
    canrobbery = true,
    PlayerSpawn = function(pl)
        pl:SetMaxArmor(120)
        pl:SetArmor(120)
    end
})

TEAM_RABOTORGOVKA = rp.addTeam("Работорговка +", {
	color = Color(255, 140, 0),
	model = "models/player/alyx.mdl", 
	description = [[Продавайте рабов бандитам.
Станьте главой работорговли]],
	weapons = {"weapon_ziptie"}, 
	command = "rabot",
	max = 6,
	salary = 80,
	admin = 0, 
	candemote = false,
    category = '[2] Криминал',
	CanHostage = true
})

TEAM_GUN = rp.addTeam('Продавец оружия +', {
    category = '[4] Торговцы',
    color = Color(255, 140, 0),
    model = {'models/player/monk.mdl', 'models/player/alyx.mdl'},
    weapons = {},
    command = 'gundealer',
    max = 4,
    salary = 90,
    candemote = true,
    description = [[Торговец легальным оружием, снабжает
горожан и защитников порядка.]],
    hasLicense = true
})

TEAM_BMIDEALER = rp.addTeam('Контрабандист +', {
	category = '[4] Торговцы',
	color = Color(0, 71, 71, 255),
	model = 'models/player/leet.mdl',
	salary = 500,
	weapons = {},
	command = 'blackmarketdealer',
	max = 3,
	bmidealer = true,
	candemote = true,
	description = [[Вы — контрабандист. Торгуете
оружием и другими запрещёнными
товарами на черном рынке.]]
})

TEAM_DRUGDEALER = rp.addTeam('Наркобарон +', {
    category = '[4] Торговцы',
    color = Color(153, 51, 255),
    model = {'models/player/group01/Male_03.mdl', 'models/player/Group01/Male_04.mdl'},
    weapons = {},
    command = 'drugdealer',
    max = 4,
    salary = 200,
    description = [[Контролирует производство и
продажу наркотиков, ведет подпольный
бизнес.]],
    admin = 0,
    candemote = true
})

TEAM_METOVAR = rp.addTeam('Метоварщик +', {
    category = '[2] Криминал',
    color = Color(112, 35, 142),
    model = {'models/agent_47.mdl'},
    weapons = {},
    command = 'drugmaker',
    max = 4,
    salary = 150,
    description = [[Готовит запрещенные вещества, 
работает в тени [2] Криминального мира.]],
    admin = 0,
    candemote = true
})

TEAM_DRUGMAKER = rp.addTeam('Гровер +', {
    category = '[2] Криминал',
    color = Color(107, 142, 35),
    model = {'models/player/jessev2.mdl'},
    weapons = {'zgo2_multitool'},
    command = 'grower',
    max = 6,
    salary = 150,
    vip = true,
    admin = 0,
    description = [[Выращивает и распространяет
наркотические вещества, использует
специальное оборудование.]],
    candemote = true
})

TEAM_DISTILLER = rp.addTeam("Самогонщик +", {
    category = '[2] Криминал',
    color = Color(225, 75, 75, 255),
    model = {"models/player/zelpa/fisherman.mdl"},
    weapons = {},
    command = "moonshine",
    max = 6,
    salary = 40,
    vote = false,
    description = [[Занимается незаконным производством
алкоголя. Варит самогон и
продаёт его желающим.]],
    hasLicense = false
})

TEAM_BARTENDER = rp.addTeam('Бармен +', {
    category = '[4] Торговцы',
    color = Color(153, 102, 51),
    model = 'models/player/eli.mdl',
    weapons = {},
    GetRelationships = function() return 'Бар, продавайте алкоголь жителям' end,
    command = 'bartender',
    max = 3,
    salary = 100,
    description = [[Владелец бара, торгует напитками и
алкоголем. Собирает компанию у
стойки и создаёт атмосферу веселья.]],
    candemote = true
})

TEAM_COOK = rp.addTeam('Повар +', {
    category = '[4] Торговцы',
    color = Color(238, 99, 99),
    model = 'models/kuhnya/barinov.mdl',
    weapons = {},
    GetRelationships = function() return 'Кафе, кормите людей с помощью микролновки' end,
    command = 'cook',
    max = 4,
    salary = 70,
    description = [[Занимается приготовлением еды в
кафе. Может готовить блюда для игроков
и обеспечивать их пропитанием.]],
    candemote = true,
    cook = true
})

TEAM_HITMAN = rp.addTeam('Наемный убийца +', {
    category = '[2] Криминал',
    color = Color(150, 80, 80),
    model = {'models/player/leet.mdl'},
    CanRaid = 'Только для завершения заказа',
    GetRelationships = function() return {TEAM_VIPHITMAN, TEAM_HITMAN} end,
    weapons = {'maskirovka'},
    command = 'hitman',
    max = 4,
    candisguise = true,
    description = [[Выполняет заказы на устранение целей.
Работает в тени, соблюдает
осторожность и не оставляет следов.
Может нападать только для выполнения
заказов.]],
    salary = 170,
    candemote = true,
    hitman = true
})

TEAM_VIPHITMAN = rp.addTeam('Наемный убийца (VIP) +', {
    category = '[2] Криминал',
    color = Color(150, 80, 80),
    model = {'models/player/leet.mdl'},
    CanRaid = 'Только для завершения заказа',
    GetRelationships = function() return {TEAM_VIPHITMAN, TEAM_HITMAN} end,
    weapons = {'maskirovka','m9k_contender'},
    command = 'viphitman',
    max = 8,
    candisguise = true,
    vip = true,
    description = [[Выполняет заказы на устранение целей.
Работает в тени, соблюдает
осторожность и не оставляет следов.
Может нападать только для выполнения
заказов.]],
    salary = 170,
    candemote = true,
    hitman = true
})

TEAM_SECURITY = rp.addTeam('Охранник +', {
    color = Color(0, 140, 255),
    model = {'models/player/odessa.mdl'},
    weapons = {'stun_baton'},
    CanRaid = 'Только врагов босса',
    GetRelationships = function() return {TEAM_SECURITY, TEAM_SECURITYVIP, TEAM_BANK} end,
    command = 'security',
    max = 6,
    salary = 60,
    hirable = true,
    description = [[Обеспечивает безопасность клиентов.
Может быть нанят для защиты
имущества или важных персон.
Имеет право атаковать врагов своего
босса.]],
    hirePrice = 2000,
    candemote = true
})

TEAM_DJ = rp.addTeam('DJ +', {
    color = Color(25, 207, 134),
    model = 'models/player/alyx.mdl',
    weapons = {},
    command = 'dj',
    max = 3,
    description = [[Включает музыку и развлекает публику.
Отвечает за атмосферу вечеринок и
клубов.]],
    salary = 60,
    candemote = true
})

TEAM_BANK = rp.addTeam('Банкир +', {
    color = Color(79, 121, 66),
    model = {'models/player/hostage/hostage_02.mdl', 'models/player/hostage/hostage_03.mdl'},
    weapons = {},
    GetRelationships = function() return {TEAM_SECURITY, TEAM_SECURITYVIP, TEAM_BANK} end,
    command = 'banker',
    max = 2,
    salary = 160,
    description = [[Работает в банке, занимается
хранением и обработкой финансов.
Часто привлекает внимание грабителей,
поэтому нуждается в охране.]],
    candemote = true
})

TEAM_DOCTOR = rp.addTeam('Медик +', {
    category = '[4] Торговцы',
    color = Color(47, 79, 79),
    model = MedModels,
    weapons = {'med_kit'},
    GetRelationships = function() return 'Больница, лечите людей с помощью кровати' end,
    command = 'medic',
    max = 4,
    salary = 60,
    description = [[Работает в больнице, лечит раненых
и больных. Использует медкомплект и
специальное оборудование для оказания
помощи.]],
    candemote = false,
    hasLicense = true,
    medic = true
})

TEAM_FREERUNNER = rp.addTeam('Паркурист +', {
    color = Color(71, 204, 71),
    model = 'models/player/p2_chell.mdl',
    weapons = {'climb_swep'},
    command = 'freerunner',
    max = 6,
    salary = 50,
    description = [[Ловкий паркурщик, который может
легко передвигаться по городу
с помощью специального снаряжения.
Отличный выбор для быстрых побегов
и скрытых перемещений.]],
    candemote = true,
    PlayerSpawn = function(pl)
        pl:SetMaxHealth(75)
        pl:SetHealth(75)
    end
})

TEAM_CASINOOWNER = rp.addTeam('Владелец казино +', {
    color = Color(244, 131, 66),
    model = 'models/player/magnusson.mdl',
    weapons = {},
    command = 'casino',
    max = 2,
    description = [[Управляет игровым заведением,
привлекает клиентов азартными играми.
Может стать богатым, если удачно
ведёт бизнес.]],
    salary = 125,
    hasLicense = false,
    candemote = false,
    CanWep = true,
})

local banned_spawns = {
    rp_bangclaw_easy = {
        Vector(1147.5759277344, 2193.7653808594, -1204.3088378906)
    },
}

TEAM_BANNED = rp.addTeam('Забанен', {
    color = Color(255, 0, 0),
    model = 'models/player/soldier_stripped.mdl',
    description = [[Вас забанили!]],
    weapons = {},
    command = 'banned124',
    max = 0,
    salary = 0,
    admin = 0,
    hasLicense = false,
    candemote = false,
    customCheck = function(pl) return pl:IsBanned() end,
    CustomCheckFailMsg = 'JobNeedsBanned',
    spawns = banned_spawns
})

TEAM_MANYAK = rp.addTeam('Маньяк +', {
    color = Color(75,0,130),
    category = '[2] Криминал',
    model = citizens,
    description = [[Пудж из доты 2!111!!!!]],
    weapons = {'csgo_bayonet', 'maskirovka'},
    command = 'maniak',
    max = 2,
    candisguise = true,
    salary = 100,
    vip = true,
})

TEAM_BITMINER = rp.addTeam('Битмайнер +', {
	color = Color(255, 151, 24),
	model = {'models/player/hostage/hostage_02.mdl', 'models/player/hostage/hostage_03.mdl'},
	description = [[биткойн биткойн манй]],
	weapons = {},
	salary = 200,
	command = 'bitminer',
	max = 4,
    vip = true,
	hasLicense = false,
	candemote = false
})

rp.AddDoorGroup('Полицейский участок', TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF, TEAM_FBR)
rp.AddDoorGroup('Мэрия', TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF, TEAM_FBR)
rp.addGroupChat(TEAM_MOBBOSS, TEAM_GANGSTER, TEAM_VIPGANGSTER, TEAM_GRAB)
rp.addGroupChat(TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF, TEAM_FBR)
rp.addGroupChat(TEAM_HOBO, TEAM_HOBOKING)
rp.addGroupChat(TEAM_UMBRELLA1, TEAM_UMBRELLA2, TEAM_UMBRELLA3, TEAM_UMBRELLA4, TEAM_UMBRELLA5)
rp.DefaultTeam = TEAM_CITIZEN