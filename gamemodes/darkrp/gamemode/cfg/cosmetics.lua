-- Хочешь хороший интерфейс и самописные системы?
-- Обращайся в дискорд tgmain
-- Портфолио --> https://discord.gg/NFa42fEgxn
rp.hats.ModelGroups = {}

for a = 1, 9 do
    rp.hats.ModelGroups['models/player/group01/male_0' .. a .. '.mdl'] = 'MALE_CITIZEN'
    rp.hats.ModelGroups['models/player/group03/male_0' .. a .. '.mdl'] = 'MALE_CITIZEN'
    rp.hats.ModelGroups['models/player/group03m/male_0' .. a .. '.mdl'] = 'MALE_CITIZEN'
end

for a = 1, 4 do
    rp.hats.ModelGroups['models/player/hostage/hostage_0' .. a .. '.mdl'] = 'MALE_CITIZEN'
end

for a = 1, 9 do
    rp.hats.ModelGroups['models/player/group01/female_0' .. a .. '.mdl'] = 'FEMALE_CITIZEN'
    rp.hats.ModelGroups['models/player/group03/female_0' .. a .. '.mdl'] = 'FEMALE_CITIZEN'
    rp.hats.ModelGroups['models/player/group03m/female_0' .. a .. '.mdl'] = 'FEMALE_CITIZEN'
end

rp.hats.Categories = {
    ['Куплено'] = 1,
    ['Новогодние'] = 2,
    ['Грелки для головы'] = 3,
    ['Шляпы дальнобойщика'] = 4,
    ['Странности'] = 5,
    ['бейсболки'] = 6,
    ['Плащи'] = 7,
    ['Шарфы'] = 8,
    ['FNAF'] = 9,
    ['Brawl Stars'] = 10,
    ['Небольшой изгиб'] = 11,
    ['Я вижу вашу точку зрения!'] = 12,
    ['Airpods MAX'] = 13,
    ['Хипстерская фаза'] = 14,
    ['Пивные шляпы'] = 15,
    ['Уродливые решения'] = 16,
    ['Обертывания'] = 17,
    ['Череп и кости'] = 18,
    ['Маски'] = 19,
    ['$ Наряд богатых людей $'] = 20,
    ['Горячая линия'] = 21,
    ['Шляпы, которые вы не можете себе позволить'] = 22,
    ['Грелки для лица'] = 23,
    ['Halloween'] = 24,
    ['Кулдык-кулдык'] = 25,
    ['Не так одиноко'] = 26,
    ['Новые Аксессуары'] = 27,
    ['SUPREME'] = 28
}

APPAREL_HATS, APPAREL_MASKS, APPAREL_GLASSES, APPAREL_SCARVES, APPAREL_PETS = 1, 2, 3, 4, 5

local b = {
    [APPAREL_MASKS] = true,
    [APPAREL_GLASSES] = true
}

rp.hats.Add{
    name = 'Кепка Манн Ко',
    category = 'Грелки для головы',
    price = 250000,
    model = 'models/player/items/demo/demo_cap_online.mdl',
    offsets = {
        ['models/player/arctic.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 1.647446513176),
            scale = 1.0230642504119
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 3.2948930263519),
            scale = 1.0395387149918
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(0, 0, 3)
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0, 0, 1.2999999523163),
            offang = Angle(4.75, 0, 0)
        }
    },
    game = 'tf'
}

rp.hats.Add{
    name = 'Красный каскадерский шлем',
    category = 'Грелки для головы',
    price = 250000,
    model = 'models/player/items/demo/stunt_helmet.mdl',
    offpos = Vector(0, 0, 1),
    game = 'tf',
    variants = {'Синий каскадерский шлем'}
}

rp.hats.Add{
    name = 'Летняя шляпа',
    category = 'Грелки для головы',
    price = 250000,
    model = 'models/player/items/demo/summer_hat_demo.mdl',
    scale = 1.05,
    offpos = Vector(0, 0, 1),
    variants = {'Летняя шляпа №2'},
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(0, 0, 1),
            scale = 1.05
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(-0.65897858142853, 0, 1.647446513176),
            scale = 1.05
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 1.9769357442856),
            scale = 1.05
        },
        ['models/player/breen.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, 1),
            scale = 1.05
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 1),
            scale = 1.05
        },
        ['models/player/police.mdl'] = {
            offpos = Vector(0, 0, 1.647446513176),
            scale = 1.05
        },
        ['models/player/combine_soldier.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, 2.3064250946045),
            scale = 1.05
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(0, 0, 5.6013178825378),
            scale = 1.05
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(-2.6359143257141, 0, 3.9538714885712),
            scale = 1.05
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(0, 0, 4.9423394203186),
            scale = 1.05
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(0, 0, 4.612850189209),
            scale = 1.05
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, 2.6359143257141),
            scale = 1.05
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(0, 0, 5.2718286514282),
            scale = 1.05
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(-1.647446513176, 0, 1.9769357442856),
            scale = 1.05
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 1.9769357442856),
            scale = 1.05
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, 1.3179571628571),
            scale = 1.05
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, 3.9538714885712),
            scale = 1.05
        },
        ['models/player/eli.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, 1),
            scale = 1.05
        },
        ['models/player/mossman.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, 1),
            scale = 1.05
        },
        ['models/player/alyx.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, 1),
            scale = 1.05
        },
        ['models/player/magnusson.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, 1),
            scale = 1.05
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(0, 0, 4.2833609580994),
            scale = 1.05
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, 1),
            scale = 1.05
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, 4.2833609580994),
            scale = 1.05
        },
        ['models/player/guerilla.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 3.6243822574615),
            scale = 1.05
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 1.647446513176),
            scale = 1.05
        },
        ['models/player/odessa.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, 1),
            scale = 1.05
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, 2.9654035568237),
            scale = 1.05
        },
        ['models/player/corpse1.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 1),
            scale = 1.05
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-1.647446513176, 0, 1),
            scale = 1.05
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 2.3064250946045),
            scale = 1.05
        },
        ['models/player/soldier_stripped.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -0.32948929071426),
            scale = 1.05
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 1),
            scale = 1.05
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, 2.6359143257141),
            scale = 1.05
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-2.9654035568237, 0, 1.647446513176),
            scale = 1.05
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-1.647446513176, 0, 0.98846787214279),
            scale = 1.05
        },
        ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, 1.3179571628571),
            scale = 1.05
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(0, 0, 4.2833609580994),
            scale = 1.05
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0, -0.24067388474941, 0.48134776949883),
            offang = Angle(-6.4981951713562, 7.3646211624146, 4.7653431892395),
            scale = 1.2406738868833
        },
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, 1.647446513176),
            offang = Angle(0, 5, 0),
            scale = 0.97
        }
    },
    game = 'tf'
}

rp.hats.Add{
    name = 'Берет Художника красный',
    category = 'Грелки для головы',
    price = 250000,
    model = 'models/player/items/spy/spy_beret.mdl',
    scale = 1.1,
    offpos = Vector(-1, 0, 0),
    game = 'tf',
    variants = {'Берет Художника синий'},
    offsets = {
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, 0.32948929071426),
            scale = 1.1
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(-1.647446513176, 0.32948929071426, 0.98846787214279),
            scale = 1.1
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, 0),
            offang = Angle(0, 6.5238881111145, 0),
            scale = 1.1
        }
    }
}

rp.hats.Add{
    name = 'Ведро',
    category = 'Грелки для головы',
    price = 250000,
    model = 'models/player/items/soldier/bucket.mdl',
    offpos = Vector(-2, 0, 1),
    offang = Angle(0, 0, 180),
    offsets = {
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(-2, 0, 5.1612901687622),
            offang = Angle(0, 0, 180),
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(-6.7096772193909, 0, 1),
            offang = Angle(0, 0, 180),
            scale = 1.0929032258065
        },
    },
    game = 'tf'
}

rp.hats.Add{
    name = 'Кожаная шапка',
    category = 'Грелки для головы',
    price = 250000,
    model = 'models/player/items/all_class/pcg_hat_medic.mdl',
    scale = 1.05,
    offpos = Vector(0, 0, 1.5),
    game = 'tf',
    offsets = {
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(-0.25806450843811, -0.51612901687622, 4.645161151886),
            scale = 1.05
        }
    }
}

rp.hats.Add{
    name = 'Ковбойская шляпа',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/sniper/sniper_crocleather_slouch.mdl',
    scale = 1.05,
    offpos = Vector(1, 0, -1),
    offsets = {
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(-1.2135922908783, 0, -1),
            scale = 1.05
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(0.2427184432745, 0, -1),
            scale = 1.2402912621359
        }
    },
    game = 'tf'
}

rp.hats.Add{
    name = 'Оранжевая каска',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/demo/hardhat.mdl',
    scale = 1.1,
    game = 'tf',
    variants = {'Синия каска'}
}

rp.hats.Add{
    name = 'Каска синия',
    category = 'Странности',
    price = 1000000,
    model = 'models/props_2fort/hardhat001.mdl',
    scale = 0.65,
    offpos = Vector(-1, 0, 3.8),
    offang = Angle(0, 0, 180),
    game = 'tf'
}

rp.hats.Add{
    name = 'Дорожный конус',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/pyro/traffic_cone.mdl',
    scale = 1.1,
    offpos = Vector(-2, 0, 1),
    game = 'tf'
}

rp.hats.Add{
    name = 'Шлем медика красный',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/medic/fwk_medic_stahlhelm.mdl',
    scale = 1.1,
    offpos = Vector(-1, 0, 2),
    game = 'tf',
    variants = {'Шлем медика синий'}
}

rp.hats.Add{
    name = 'Шеф-повар',
    category = 'Странности',
    price = 1000000,
    model = 'models/chefhat.mdl',
    scale = 1.1,
    offpos = Vector(3.5, 0, 5),
    offang = Angle(0, 30, 0),
    game = 'tf',
    offsets = {
        ['models/player/arctic.mdl'] = {
            offpos = Vector(4.1262135505676, 0, 8.009708404541),
            offang = Angle(0, 28.398057937622, 0),
            scale = 1.3131067961165
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(5.4193549156189, -0.77419352531433, 9.0322580337524),
            offang = Angle(-5.5741934776306, 30, 0),
            scale = 1.0464516129032
        },
    }
}

rp.hats.Add{
    name = 'Вооруженная власть',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/soldier/armored_authority.mdl',
    scale = 0.93,
    offpos = Vector(2.5, 0, 1),
    offang = Angle(0, 90, 0),
    game = 'tf',
    offsets = {
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(1.3179571628571, -0.32948929071426, 0.98846787214279),
            offang = Angle(-2.9654035568237, 91.334434509277, 2.9654035568237),
            scale = 0.92751235584843
        }
    }
}

rp.hats.Add{
    name = 'Армейская шляпа',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/demo/veteran_hat.mdl',
    offpos = Vector(0, 0, 1),
    game = 'tf'
}

rp.hats.Add{
    name = 'Бумажная шляпа',
    category = 'Грелки для головы',
    price = 250000,
    model = 'models/player/items/spy/paper_hat.mdl',
    game = 'tf',
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(-0.65897858142853, 0, 0),
            scale = 1.0626029654036
        }
    }
}

rp.hats.Add{
    name = 'Колпачек красный',
    category = 'Грелки для головы',
    price = 250000,
    model = 'models/player/items/all_class/bdayhat_engineer.mdl',
    offpos = Vector(0, 0, 1),
    game = 'tf',
    variants = {'Колпачек синий'}
}

rp.hats.Add{
    name = 'Вантуз',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/pyro/pyro_plunger.mdl',
    scale = 1.43,
    offpos = Vector(0, 0, 5),
    offang = Angle(20, 0, 0),
    game = 'tf'
}

rp.hats.Add{
    name = 'Лыжная шапочка',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/soldier/soldier_skihat_s1.mdl',
    offpos = Vector(1, 0, 3.7),
    game = 'tf'
}

rp.hats.Add{
    name = 'Робин красный',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/sniper/larrikin_robin.mdl',
    offpos = Vector(0, 0, -0.5),
    game = 'tf',
    variants = {'Робин синий'}
}

rp.hats.Add{
    name = 'Кролик',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/soldier/soldier_ttg_max.mdl',
    offpos = Vector(0, 0, 1),
    game = 'tf',
    offsets = {
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(0, 0, 1),
            offang = Angle(0, 23, 0)
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(1, 0, -0.625),
            offang = Angle(0, 25, 0),
            scale = 1.2
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(0.48134776949883, -0.24099999666214, -0.48134776949883),
            offang = Angle(0, 22.093862533569, 0),
            scale = 0.53309265944645
        }
    }
}

rp.hats.Add{
    name = 'Фес красный',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/spy/fez.mdl',
    scale = 1.2,
    offpos = Vector(2, 0, -90),
    game = 'tf',
    variants = {'Фес синий'}
}

rp.hats.Add{
    name = 'Санта Красный',
    category = 'Новогодние',
    price = 250000,
    model = 'models/player/items/all_class/xms_santa_hat_demo.mdl',
    scale = 1.1,
    offpos = Vector(-1, 0, 1),
    game = 'tf',
    offsets = {
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(-1, 0, 4.1290321350098),
            scale = 1.1
        },

    },
    variants = {'Санта Синий'}
}

rp.hats.Add{
    name = 'Самурай красный',
    category = '$ Наряд богатых людей $',
    price = 12500000,
    model = 'models/player/items/soldier/soldier_samurai.mdl',
    scale = 0.85,
    offpos = Vector(0, 0, 8),
    infooffset = 15,
    game = 'tf',
    variants = {'Самурай синий'}
}

rp.hats.Add{
    name = 'Цветистая шляпа красная',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/pyro/fwk_pyro_flamenco.mdl',
    scale = 1.15,
    offpos = Vector(-1.5, 0, -1.4),
    offang = Angle(0, 22.5, 0),
    infooffset = 7.5,
    game = 'tf',
    variants = {'Цветистая шляпа синия'},
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(-1.5, 0, -3.6243822574615),
            offang = Angle(0, 22.5, 0),
            scale = 1.168039538715
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(-0.65897858142853, 0, -2.53359143257141),
            offang = Angle(0, 22.5, 0),
            scale = 1.1911037891269
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(0, 0, -1.3999999761581),
            offang = Angle(0, 22.5, 0),
            scale = 1.15
        },
        ['models/player/breen.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -2.6359143257141),
            offang = Angle(0, 22.5, 0),
            scale = 1.1878088962109
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -2.8654035568237),
            offang = Angle(0, 22.5, 0),
            scale = 1.1911037891269
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(-1.2999999523163, 0, -1.6399999856949),
            offang = Angle(0, 22.5, 0),
            scale = 1.33
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -0.98846787214279),
            offang = Angle(0, 22.5, 0),
            scale = 1.248
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, -0.9200000166893),
            offang = Angle(0, 22.5, 0),
            scale = 1.2504118616145
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(-0.40000000596046, 0, -1.3999999761581),
            offang = Angle(0, 22.5, 0),
            scale = 1.345
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -1.8999999761581),
            offang = Angle(0, 22.5, 0),
            scale = 1.26
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.3179571628571),
            offang = Angle(0, 22.5, 0),
            scale = 1.3196046128501
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, -2.3064250946045),
            offang = Angle(0, 22.5, 0),
            scale = 1.2108731466227
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.7769357442856),
            offang = Angle(0, 22.5, 0),
            scale = 1.1943986820428
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, -1.2000000476837),
            offang = Angle(0, 22.5, 0),
            scale = 1.2108731466227
        },
        ['models/player/mossman.mdl'] = {
            offpos = Vector(-1.7999999523163, 0, -1.9769357442856),
            offang = Angle(0, 22.5, 0),
            scale = 1.18
        },
        ['models/player/alyx.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, -2.6359143257141),
            offang = Angle(0, 22.5, 0),
            scale = 1.15
        },
        ['models/player/magnusson.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, -2.6359143257141),
            offang = Angle(0, 22.5, 0),
            scale = 1.15
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.3999999761581),
            offang = Angle(0, 22.5, 0),
            scale = 1.2537067545305
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(0.32948929071426, 0, 0.65897858142853),
            offang = Angle(0, 22.5, 0),
            scale = 1.15
        },
        ['models/player/guerilla.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -1.3999999761581),
            offang = Angle(0, 22.5, 0),
            scale = 1.1976935749588
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -1.3999999761581),
            offang = Angle(0, 22.5, 0),
            scale = 1.1976935749588
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-2.9654035568237, 0, -1.9769357442856),
            offang = Angle(0, 22.5, 0),
            scale = 1.0230642504119
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -1.3999999761581),
            offang = Angle(0, 22.5, 0),
            scale = 1.2075782537068
        },
        ['models/player/soldier_stripped.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -2.6359143257141),
            offang = Angle(0, 22.5, 0),
            scale = 1.0790774299835
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(-1.5, 0, -2.3064250946045),
            offang = Angle(0, 22.5, 0),
            scale = 1.15
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, -1.3999999761581),
            offang = Angle(0, 22.5, 0),
            scale = 1.2306425041186
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-3.2948930263519, 0, -1.9769357442856),
            offang = Angle(0, 22.5, 0),
            scale = 1.2207578253707
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-2.6359143257141, 0, -2.3064250946045),
            offang = Angle(0, 22.5, 0),
            scale = 1.2042833607908
        }
    }
}

rp.hats.Add{
    name = 'Пират',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/all_class/world_traveller_spy.mdl',
    scale = 1.1,
    offpos = Vector(-1, 0, 1),
    game = 'tf'
}

rp.hats.Add{
    name = 'Оттенки',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 500000,
    model = 'models/workshop/player/items/all_class/jul13_sweet_shades/jul13_sweet_shades_demo.mdl',
    scale = 1.15,
    offpos = Vector(-0.5, -0.5, 2),
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(0.69999998807907, -0.34999999403954, -0.10000000149012),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.93
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(1.2033693790436, -0.34999999403954, 1),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.93
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-0.72202163934708, -0.34999999403954, 0.24067388474941),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.93
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(0.24067388474941, -0.34999999403954, 2.1660649776459),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.93
        },
        ['models/player/breen.mdl'] = {
            offpos = Vector(0.5, -0.34999999403954, 0.30000001192093),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.93
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(0.89999997615814, -0.34999999403954, 0.40000000596046),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.93
        },
        ['models/player/police.mdl'] = {
            offpos = Vector(2.647412776947, -0.72202163934708, 0.72202163934708),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.93
        },
        ['models/player/combine_soldier.mdl'] = {
            offpos = Vector(0.48134776949883, -0.72202163934708, 1.4440432786942),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.985559566787
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(1.6000000238419, -0.72202163934708, 1.6847171783447),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.95908543922984
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(-0.72202163934708, -0.34999999403954, 2.1660649776459),
            offang = Angle(0, 10.830325126648, 0),
            scale = 1.15
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(1.6847171783447, -0.69999998807907, 2.1660649776459),
            offang = Angle(0, 10.830325126648, 0),
            scale = 1.1083032490975
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(2.1660649776459, -0.69999998807907, 1.8999999761581),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.87244283995187
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(0.72202163934708, -0.69999998807907, 1.8999999761581),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.99759326113117
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(1.6847171783447, -0.69999998807907, 1.8999999761581),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.93020457280385
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(0.24067388474941, -0.44999998807907, 0.24067388474941),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.83874849578821
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(0.72202163934708, -0.40000000596046, 1.6847171783447),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.90613718411552
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(0.69999998807907, -0.40000000596046, 1.4440432786942),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.90613718411552
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(1.6847171783447, -0.40000000596046, 2.647412776947),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.93501805054152
        },
        ['models/player/group01/male_03.mdl'] = {
            offpos = Vector(0.89999997615814, -0.80000001192093, 1.6000000238419),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.90132370637786
        },
        ['models/player/eli.mdl'] = {
            offpos = Vector(0.24067388474941, -0.40000000596046, 0.89999997615814),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.89169675090253
        },
        ['models/player/mossman.mdl'] = {
            offpos = Vector(0.72202163934708, -0.40000000596046, 0.24067388474941),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.89169675090253
        },
        ['models/player/alyx.mdl'] = {
            offpos = Vector(0.5, -0.5, 0.24067388474941),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.81468110709988
        },
        ['models/player/magnusson.mdl'] = {
            offpos = Vector(0.24067388474941, -0.5, 0.24067388474941),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.87244283995187
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(1.3999999761581, -0.80000001192093, 1.7999999523163),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.89651022864019
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(0.80000001192093, -0.5, 0.44999998807907),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.82430806257521
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(1.7000000476837, -0.69999998807907, 4.0914559364319),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.97833935018051
        },
        ['models/player/guerilla.mdl'] = {
            offpos = Vector(1.5, -0.5, 2.1660649776459),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.87725631768953
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(0.72202163934708, -0.5, 1.6847171783447),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.8676293622142
        },
        ['models/player/odessa.mdl'] = {
            offpos = Vector(1.6000000238419, -0.5, 0.60000002384186),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.86281588447653
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(1.8999999761581, -0.5, 2.1660649776459),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.92057761732852
        },
        ['models/player/corpse1.mdl'] = {
            offpos = Vector(1.2033693790436, -0.40000000596046, 1.2033693790436),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.8820697954272
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-0.72202163934708, -0.30000001192093, 0.30000001192093),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.77135980746089
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(1.3999999761581, -0.5, 2),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.91576413959085
        },
        ['models/player/soldier_stripped.mdl'] = {
            offpos = Vector(-0, -0.30000001192093, 0.20000000298023),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.80505415162455
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(1.2033693790436, -0.5, 1.2033693790436),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.81949458483755
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(0.72202163934708, -0.5, 1.2033693790436),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.81949458483755
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-0.72202163934708, -0.30000001192093, 1.2033693790436),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.80505415162455
        },
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(0.56999999284744, -0.40000000596046, 1),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.80505415162455
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-0.30000001192093, -0.30000001192093, 0.40000000596046),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.82912154031288
        },
        ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
            offpos = Vector(1, -0.40000000596046, 2.4000000953674),
            offang = Angle(0, 10.830325126648, 0),
            scale = 0.7424789410349
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0.89999997615814, -0.40000000596046, -0.24067388474941),
            offang = Angle(0, 10.830325126648, 0),
            scale = 1.1612515042118
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(1.6847171783447, -0.60000002384186, 0.72202163934708),
            offang = Angle(0, 10.830325126648, 0),
            scale = 1.1227436823105
        }
    },
    infooffset = 7.5,
    game = 'tf'
}

rp.hats.Add{
    name = 'Маскировка',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/workshop_partner/player/items/all_class/hm_disguisehat/hm_disguisehat_demo.mdl',
    scale = 1.15,
    offpos = Vector(-0.5, -0.5, 1),
    game = 'tf'
}

rp.hats.Add{
    name = 'Бандит коричневая',
    category = 'Небольшой изгиб',
    type = APPAREL_MASKS,
    price = 2500000,
    model = 'models/workshop/player/items/sniper/thief_sniper_hood/thief_sniper_hood.mdl',
    offpos = Vector(6.5, 0, -75),
    infooffset = 10,
    game = 'tf',
    variants = {'Бандит чёрная'},
    offsets = {
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(1.6900000572205, 0, -75)
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(4, -0.20000000298023, -74),
            scale = 1.0098846787479
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(3.7999999523163, -0.30000001192093, -75)
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(4.5999999046326, -0.20000000298023, -73),
            scale = 1.02
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(4.1999998092651, -0.20000000298023, -74.800003051758),
            scale = 1.01
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(3.5999999046326, 0.30000001192093, -76),
            offang = Angle(8.8000001907349, 3, 1),
            scale = 1.02
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(3, 0.20000000298023, -75),
            offang = Angle(8.8000001907349, 0, 0),
            scale = 1.02
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(3.3499999046326, -0.11999999731779, -66.5),
            offang = Angle(0, 4, 0),
            scale = 0.9
        }
    }
}

rp.hats.Add{
    name = 'Маскарад красный',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 1000000,
    model = 'models/player/items/spy/spy_party_phantom.mdl',
    scale = 1.05,
    offpos = Vector(0.1, -0.5, 1),
    game = 'tf',
    offsets = {
        ['models/player/monk.mdl'] = {
            offpos = Vector(-1.0443863868713, 2.6109659671783, -2.0887727737427),
            offang = Angle(-20.678852081299, -34.77806854248, -79.895561218262),
            scale = 1.266318537859
        },

    },
    variants = {'Маскарад синий'}
}

rp.hats.Add{
    name = 'Венец из перьев красный',
    category = '$ Наряд богатых людей $',
    price = 10000000,
    model = 'models/player/items/heavy/heavy_big_chief.mdl',
    infooffset = 15,
    game = 'tf',
    variants = {'Венец из перьев синий'},
    offsets = {
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(-2.6699028015137, 0, 0),
            scale = 1.0800970873786
        }
    }
}

rp.hats.Add{
    name = 'Волшебник красный',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/all_class/trn_wiz_hat_soldier.mdl',
    scale = 1.05,
    offpos = Vector(-1, 0, 2.5),
    game = 'tf',
    variants = {'Волшебник синий'}
}

rp.hats.Add{
    name = 'Сомбреро красный',
    category = '$ Наряд богатых людей $',
    price = 12500000,
    model = 'models/player/items/demo/demo_fiesta_sombrero.mdl',
    scale = 1.3,
    offpos = Vector(0, 0, -1.4),
    offang = Angle(0, 22.5, 0),
    variants = {'Сомбреро синий'},
    offsets = {
        ['models/player/combine_soldier.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -0.98846787214279),
            offang = Angle(0, 22.5, 0),
            scale = 1.326194398682
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(0.32948929071426, 0, -0.98846787214279),
            offang = Angle(0, 22.5, 0),
            scale = 1.4382207578254
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(0.32948929071426, 0, -0.32948929071426),
            offang = Angle(0, 22.5, 0),
            scale = 1.4382207578254
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -1.9769357442856),
            offang = Angle(0, 22.5, 0),
            scale = 1.4843492586491
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(0.69999998807907, 0, -1.9769357442856),
            offang = Angle(0, 22.5, 0),
            scale = 1.4546952224053
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(0.98846787214279, 0, -1.647446513176),
            offang = Angle(0, 22.5, 0),
            scale = 1.2438220757825
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(1.3179571628571, 0, -0.65897858142853),
            offang = Angle(0, 22.5, 0),
            scale = 1.33607907743
        },
        ['models/player/eli.mdl'] = {
            offpos = Vector(0, 0, -1.647446513176),
            offang = Angle(0, 22.5, 0),
            scale = 1.2602965403624
        },
        ['models/player/mossman.mdl'] = {
            offpos = Vector(0, 0, -2.9654035568237),
            offang = Angle(0, 22.5, 0),
            scale = 1.3
        },
        ['models/player/alyx.mdl'] = {
            offpos = Vector(0, 0, -2.6359143257141),
            offang = Angle(0, 22.5, 0),
            scale = 1.2339373970346
        },
        ['models/player/magnusson.mdl'] = {
            offpos = Vector(0, 0, -2.6359143257141),
            offang = Angle(0, 22.5, 0),
            scale = 1.2405271828666
        },
        ['models/player/hostage/hostage_03.mdl'] = {
            offpos = Vector(0.65897858142853, 0, -2.6359143257141),
            offang = Angle(0, 22.5, 0),
            scale = 1.2405271828666
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(1.647446513176, 0, -1.647446513176),
            offang = Angle(0, 22.5, 0),
            scale = 1.339373970346
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(0.65897858142853, 0, -1.9769357442856),
            offang = Angle(0, 22.5, 0),
            scale = 1.0856672158155
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(1.9769357442856, 0, 0.65897858142853),
            offang = Angle(0, 22.5, 0),
            scale = 1.3
        },
        ['models/player/guerilla.mdl'] = {
            offpos = Vector(0.98846787214279, 0, -1.3179571628571),
            offang = Angle(0, 22.5, 0),
            scale = 1.3
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(0.65897858142853, 0, -0.98846787214279),
            offang = Angle(0, 22.5, 0),
            scale = 1.2504118616145
        },
        ['models/player/hostage/hostage_01.mdl'] = {
            offpos = Vector(0.65897858142853, 0, -1.647446513176),
            offang = Angle(0, 22.5, 0),
            scale = 1.2438220757825
        },
        ['models/player/odessa.mdl'] = {
            offpos = Vector(0.98846787214279, 0, -2.3064250946045),
            offang = Angle(0, 22.5, 0),
            scale = 1.3
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(0.98846787214279, 0, -1.3999999761581),
            offang = Angle(0, 22.5, 0),
            scale = 1.3
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.9769357442856),
            offang = Angle(0, 22.5, 0),
            scale = 1.1054365733114
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(0.65897858142853, 0, -0.32948929071426),
            offang = Angle(0, 22.5, 0),
            scale = 1.3
        },
        ['models/player/soldier_stripped.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -2.9654035568237),
            offang = Angle(0, 22.5, 0),
            scale = 1.2141680395387
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.9769357442856),
            offang = Angle(0, 22.5, 0),
            scale = 1.3492586490939
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -1.647446513176),
            offang = Angle(0, 22.5, 0),
            scale = 1.2932454695222
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.3179571628571),
            offang = Angle(0, 17.199340820313, 0),
            scale = 1.3064250411862
        },
        ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
            offpos = Vector(0.98846787214279, 0, -0.65897858142853),
            offang = Angle(0, 22.5, 0),
            scale = 1.1482701812191
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0, 0, -1.3999999761581),
            offang = Angle(0, 14.233937263489, 0),
            scale = 1.3591433278418
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(0, 0, -0.98846787214279),
            offang = Angle(0, 13.640856742859, 0),
            scale = 1.4382207578254
        }
    },
    game = 'tf'
}

rp.hats.Add{
    name = 'Майкл джексон?!?!',
    category = 'Хипстерская фаза',
    price = 5000000,
    model = 'models/player/items/heavy/capones_capper.mdl',
    offpos = Vector(-1, 0, -0.5),
    game = 'tf'
}

rp.hats.Add{
    name = 'Оранжевая подарочная шляпа',
    category = 'Странности',
    price = 1000000,
    model = 'models/workshop/player/items/all_class/dec15_a_well_wrapped_hat/dec15_a_well_wrapped_hat_scout.mdl',
    scale = 1.05,
    offpos = Vector(2, 0, -74),
    offsets = {
        ['MALE_CITIZEN'] = {
            offpos = Vector(4.0914559364319, 0, -75.812271118164),
            offang = Angle(0, 30.758123397827, 0),
            scale = 1.05
        }
    },
    infooffset = 15,
    game = 'tf',
    variants = {'Жёлтая подарочная шляпа'}
}

rp.hats.Add{
    name = 'Чарли чаплин',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/workshop/player/items/all_class/short2014_tip_of_the_hats/short2014_tip_of_the_hats_scout.mdl',
    scale = 1.05,
    offpos = Vector(80.5, 0, -2.5),
    offang = Angle(0, 85, 0),
    game = 'tf'
}

rp.hats.Add{
    name = 'Поддельный сэр',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/spy/fwk_spy_disguisedhat.mdl',
    scale = 1.05,
    offpos = Vector(-0.5, 0, 1),
    game = 'tf'
}

rp.hats.Add{
    name = 'Шляпа "Коза Ностра" красная',
    category = 'Странности',
    price = 1000000,
    model = 'models/player/items/spy/spy_gang_cap.mdl',
    scale = 1.05,
    offpos = Vector(-0.5, 0, 1),
    game = 'tf',
    variants = {'Шляпа "Коза Ностра" синия'},
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(-0.64999997615814, 0, -0.25),
            scale = 1.05
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(-1, 0, 0.30000001192093),
            scale = 1.05
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(-1.4500000476837, 0, 1.5),
            scale = 1.05
        },
        ['models/player/breen.mdl'] = {
            offpos = Vector(-1.4500000476837, 0, 0),
            scale = 1.05
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(-1, 0, 0.40000000596046),
            scale = 1.125
        },
        ['models/player/police.mdl'] = {
            offpos = Vector(-0.32499998807907, 0, 0.40000000596046),
            offang = Angle(0, 3.5, 0),
            scale = 1.125
        },
        ['models/player/combine_soldier.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, 0.98846787214279),
            offang = Angle(0, 5, 0),
            scale = 1.125
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(-1.75, 0, 2.9654035568237),
            offang = Angle(0, -7.1169686317444, 0),
            scale = 1.175
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(-2.4500000476837, 0, 2.4500000476837),
            offang = Angle(0, 10.082372665405, 0),
            scale = 1.125
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, 2.9654035568237),
            scale = 1.125
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(-0.64999997615814, 0, 3.2999999523163),
            scale = 1.125
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(-2.5, 0, 1.6499999761581),
            offang = Angle(0, 5, 0),
            scale = 1.125
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 3.6243822574615),
            scale = 1.125
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(-0.64999997615814, 0, -0.32499998807907),
            offang = Angle(0, 17.5, 0),
            scale = 1.1
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(-1.3500000238419, 0, 0.67500001192093),
            scale = 1.05
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(-1.3999999761581, 0, 0.64999997615814),
            scale = 1.05
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 1.647446513176),
            offang = Angle(0, 2.5, 0),
            scale = 1.2
        },
        ['models/player/eli.mdl'] = {
            offpos = Vector(-1.6499999761581, 0, 0),
            scale = 1.05
        },
        ['models/player/mossman.mdl'] = {
            offpos = Vector(-1, 0, 0),
            scale = 1.075
        },
        ['models/player/alyx.mdl'] = {
            offpos = Vector(-2.25, 0, 0.30000001192093),
            scale = 1.05
        },
        ['models/player/magnusson.mdl'] = {
            offpos = Vector(-1.2999999523163, 0, -0.30000001192093),
            scale = 1.05
        },
        ['models/player/hostage/hostage_02.mdl'] = {
            offpos = Vector(-0.64999997615814, 0, 1.25),
            scale = 1.05
        },
        ['models/player/hostage/hostage_03.mdl'] = {
            offpos = Vector(-1.2999999523163, 0, 0.30000001192093),
            scale = 1.05
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 2.6359143257141),
            scale = 1.1
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(-1.2999999523163, 0, 0),
            scale = 1.05
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(-1, 0, 4),
            scale = 1.05
        },
        ['models/player/guerilla.mdl'] = {
            offpos = Vector(-1.4500000476837, 0, 1.9769357442856),
            scale = 1.075
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(-1.25, 0, 0.67500001192093),
            scale = 1.05
        },
        ['models/player/odessa.mdl'] = {
            offpos = Vector(-0.64999997615814, 0, 0.34999999403954),
            scale = 1.075
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(-1.2999999523163, 0, 1.9750000238419),
            scale = 1.125
        },
        ['models/player/corpse1.mdl'] = {
            offpos = Vector(-1.2999999523163, 0, 0),
            scale = 1.05
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-1.9750000238419, 0, -0.64999997615814),
            scale = 0.925
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(-1, 0, 2),
            scale = 1.075
        },
        ['models/player/soldier_stripped.mdl'] = {
            offpos = Vector(-1.6499999761581, 0, -1)
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, 0.32948929071426),
            offang = Angle(0, 4.5, 0),
            scale = 1.05
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(-2, 0, 0.64999997615814),
            offang = Angle(0, 4.5, 0),
            scale = 1.065
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-3.25, 0, 1),
            offang = Angle(0, 4.5, 0),
            scale = 1.065
        },
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(-1.6399999856949, 0, 0.30000001192093),
            scale = 1.05
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, 0),
            scale = 1.095
        },
        ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
            offpos = Vector(-1.2999999523163, 0, 2)
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0.30000001192093, 0, 1),
            offang = Angle(0, 20, 0),
            scale = 1.05
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(0.30000001192093, 0, 3),
            offang = Angle(0, 20, 0),
            scale = 1.05
        }
    }
}

rp.hats.Add{
    name = 'Авиатор-убийца',
    category = 'Странности',
    price = 1000000,
    model = 'models/workshop/player/items/spy/short2014_deadhead/short2014_deadhead.mdl',
    scale = 1.05,
    offpos = Vector(1.5, 0, -78.5),
    infooffset = 7.5,
    game = 'tf'
}

rp.hats.Add{
    name = 'Курица апельсин',
    category = '$ Наряд богатых людей $',
    type = APPAREL_MASKS,
    price = 10000000,
    model = 'models/workshop/player/items/heavy/hw2013_heavy_robin/hw2013_heavy_robin.mdl',
    scale = 1.05,
    offpos = Vector(2.2, 0, -83),
    infooffset = 7.5,
    game = 'tf',
    variants = {'Курица мандарин'}
}

rp.hats.Add{
    name = 'Фуражка инженера красная',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/engineer/engineer_train_hat.mdl',
    scale = 1.05,
    offpos = Vector(-1.8, 0, 1),
    game = 'tf',
    variants = {'Фуражка инженера синия'}
}

rp.hats.Add{
    name = 'Техасский оловянный галлон',
    category = 'Странности',
    price = 1000000,
    model = 'models/workshop/player/items/engineer/robo_engineer_texastingallon/robo_engineer_texastingallon.mdl',
    scale = 1.05,
    offpos = Vector(0, 0.4, 0),
    offang = Angle(0, -85, 0),
    infooffset = 7.5,
    game = 'tf'
}

rp.hats.Add{
    name = 'Уилсон Уив',
    category = 'Небольшой изгиб',
    price = 5000000,
    model = 'models/player/items/all_class/starve_scout.mdl',
    scale = 1.05,
    offpos = Vector(-0.5, 0, 1),
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(0.20000000298023, -0.18000000715256, -1.6847171783447),
            offang = Angle(0, 3, 0),
            scale = 1.1949458483755
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(0.20000000298023, -0.18000000715256, -0.72202163934708),
            offang = Angle(0, 3, 0),
            scale = 1.1949458483755
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(-1.2033693790436, -0.18000000715256, 0.24067388474941),
            offang = Angle(0, 3, 0),
            scale = 1.1949458483755
        },
        ['models/player/breen.mdl'] = {
            offpos = Vector(-0.72202163934708, -0.18000000715256, -1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.1949458483755
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(-0.27000001072884, -0.18000000715256, -0.89999997615814),
            offang = Angle(0, 3, 0),
            scale = 1.2190132370638
        },
        ['models/player/combine_soldier.mdl'] = {
            offpos = Vector(-2.647412776947, 0.20000000298023, -0.72202163934708),
            offang = Angle(0, 3, 0),
            scale = 1.2623345367028
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(0.72202163934708, -0.18000000715256, -0.72202163934708),
            offang = Angle(0, 3, 0),
            scale = 1.3730445246691
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(-2.647412776947, 0.20000000298023, 0.24067388474941),
            offang = Angle(0, 3, 0),
            scale = 1.2767749699158
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(0.24067388474941, -0.20000000298023, 0.72202163934708),
            offang = Angle(0, 3, 0),
            scale = 1.2767749699158
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(0.24067388474941, -0.20000000298023, 1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.277
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(-1.9253910779953, 0.050000000745058, -1.4440432786942),
            offang = Angle(0, 3, 0),
            scale = 1.3465703971119
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(0, -0.30000001192093, 0),
            offang = Angle(0, 3, 0),
            scale = 1.347
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(-1.1000000238419, -0.10000000149012, -1.4440432786942),
            offang = Angle(0, 3, 0),
            scale = 1.1540312876053
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(-0.48134776949883, -0.10000000149012, 0.48134776949883),
            offang = Angle(0, 3, 0),
            scale = 1.1636582430806
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(-1.2033693790436, -0.11999999731779, 0.24067388474941),
            offang = Angle(0, 3, 0),
            scale = 1.1371841155235
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(-0.24067388474941, -0.11999999731779, 2.2000000476837),
            offang = Angle(0, 3, 0),
            scale = 1.1949458483755
        },
        ['models/player/eli.mdl'] = {
            offpos = Vector(-1.2033693790436, -0, -0.24067388474941),
            offang = Angle(0, 3, 0),
            scale = 1.1083032490975
        },
        ['models/player/mossman.mdl'] = {
            offpos = Vector(-0.72202163934708, 0, -0.72202163934708),
            offang = Angle(0, 3, 0),
            scale = 1.1997593261131
        },
        ['models/player/alyx.mdl'] = {
            offpos = Vector(-0.72202163934708, -0.10000000149012, -1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.1468110709988
        },
        ['models/player/magnusson.mdl'] = {
            offpos = Vector(-1.2033693790436, -0.10000000149012, -1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.1949458483755
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(0.72202163934708, -0.10000000149012, 0.72202163934708),
            offang = Angle(0, 3, 0),
            scale = 1.171
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(-1.2033693790436, -0, -1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.2382671480144
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(-1.2033693790436, -0.25, 1.6847171783447),
            offang = Angle(0, 3, 0),
            scale = 1.2960288808664
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(-0.72202163934708, -0.10000000149012, -0.24067388474941),
            offang = Angle(0, 3, 0),
            scale = 1.1708784596871
        },
        ['models/player/hostage/hostage_01.mdl'] = {
            offpos = Vector(-1.2033693790436, -0.20000000298023, -1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.2527075812274
        },
        ['models/player/odessa.mdl'] = {
            offpos = Vector(-0.24067388474941, -0.079999998211861, -1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.2719614921781
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(-0.24067388474941, -0.079999998211861, 0.24067388474941),
            offang = Angle(0, 3, 0),
            scale = 1.2719614921781
        },
        ['models/player/corpse1.mdl'] = {
            offpos = Vector(-1.2033693790436, -0.079999998211861, 0.24067388474941),
            offang = Angle(0, 3, 0),
            scale = 1.1660649819495
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-1.6847171783447, -0.079999998211861, -1.6847171783447),
            offang = Angle(0, 3, 0),
            scale = 1.0264741275572
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(-0.24067388474941, -0.079999998211861, 1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.1708784596871
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(-1.2033693790436, -0.079999998211861, -0.72202163934708),
            offang = Angle(0, 3, 0),
            scale = 1.1708784596871
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(-2.1660649776459, -0.079999998211861, -0.24067388474941),
            offang = Angle(0, 3, 0),
            scale = 1.2575210589651
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-2.1660649776459, -0.079999998211861, -1.6847171783447),
            offang = Angle(0, 3, 0),
            scale = 1.2575210589651
        },
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(-1.2033693790436, -0.079999998211861, -0.72202163934708),
            offang = Angle(0, 3, 0),
            scale = 1.1612515042118
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-1.2033693790436, -0.079999998211861, -1.6847171783447),
            offang = Angle(0, 3, 0),
            scale = 1.2238267148014
        },
        ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
            offpos = Vector(-0.72202163934708, -0.079999998211861, 1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.0553549939832
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(-0.24067388474941, -0.079999998211861, -1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.2815884476534
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(0.24067388474941, -0.079999998211861, 1.2033693790436),
            offang = Angle(0, 3, 0),
            scale = 1.2527075812274
        },
        ['models/player/police.mdl'] = {
            offpos = Vector(-0.27000001072884, -0.18000000715256, -0.89999997615814),
            offang = Angle(0, 3, 0),
            scale = 1.2190132370638
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 5.9000000953674),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/police.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 5.9000000953674),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 6.4981951713562),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        }
    },
    game = 'tf'
}

rp.hats.Add{
    name = 'Майнкрафт?',
    category = '$ Наряд богатых людей $',
    type = APPAREL_MASKS,
    price = 10000000,
    model = 'models/player/items/all_class/notch_head_heavy.mdl',
    scale = 1.05,
    offpos = Vector(-0.8, 0, 0),
    offang = Angle(0, 25, 0),
    game = 'tf',
    offsets = {
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0.47999998927116, 0, 0),
            offang = Angle(0, 25, 0),
            scale = 1.2
        }
    }
}

rp.hats.Add{
    name = 'Пиздец',
    category = 'Halloween',
    type = APPAREL_MASKS,
    price = 25000000,
    model = 'models/player/items/all_class/haunted_eyeball_hat_scout.mdl',
    scale = 1.05,
    offpos = Vector(0, 0, 1),
    infooffset = 7.5,
    offsets = {
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(2.0645160675049, -0.25806450843811, 2.5806450843811),
            offang = Angle(1.85806453228, 0, 0),
            scale = 0.95612903225806
        },
    },
    game = 'tf'
}

rp.hats.Add{
    name = 'Самый отцовский улов',
    category = '$ Наряд богатых людей $',
    type = APPAREL_MASKS,
    price = 10000000,
    model = 'models/workshop/player/items/all_class/nobody_suspects_a_thing/nobody_suspects_a_thing_scout.mdl',
    scale = 1.35,
    offpos = Vector(0, 0, 0),
    infooffset = 7.5,
    game = 'tf',
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(-0.65897858142853, 0, -3.6243822574615),
            scale = 1.3953871499176
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(-1.3179571628571, 0, -2.6359143257141),
            scale = 1.4612850082372
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -1.9769357442856),
            scale = 1.35
        },
        ['models/player/breen.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -2.6359143257141),
            scale = 1.3887973640857
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -2.6359143257141),
            scale = 1.4810543657331
        },
        ['models/player/police.mdl'] = {
            offpos = Vector(-0.65897858142853, -0.32948929071426, -2.3064250946045),
            scale = 1.5733113673806
        },
        ['models/player/combine_soldier.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, -1.3179571628571),
            scale = 1.6457990115321
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, 0),
            scale = 1.5502471169687
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, 0),
            scale = 1.6194398682043
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, -0.98846787214279),
            scale = 1.6820428336079
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.9769357442856),
            scale = 1.662273476112
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -2.3064250946045),
            scale = 1.6523887973641
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -0.98846787214279),
            scale = 1.6128500823723
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -2.6359143257141),
            scale = 1.662273476112
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -2.3064250946045),
            scale = 1.507413509061
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, -2.3064250946045),
            scale = 1.4118616144975
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, 0),
            scale = 1.4481054365733
        },
        ['models/player/eli.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -2.6359143257141),
            scale = 1.3887973640857
        },
        ['models/player/mossman.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -3.2948930263519),
            scale = 1.4250411861614
        },
        ['models/player/alyx.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -2.9654035568237),
            scale = 1.3986820428336
        },
        ['models/player/magnusson.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -3.6243822574615),
            scale = 1.3953871499176
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(0, 0, -2.6359143257141),
            scale = 1.5963756177924
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -3.9538714885712),
            scale = 1.5172981878089
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, 0),
            scale = 1.5403624382208
        },
        ['models/player/guerilla.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -1.3179571628571),
            scale = 1.4514003294893
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(-1.9769357442856, 0, -2.6359143257141),
            scale = 1.4843492586491
        },
        ['models/player/odessa.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -2.6359143257141),
            scale = 1.504118616145
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -1.647446513176),
            scale = 1.5205930807249
        },
        ['models/player/corpse1.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -2.9654035568237),
            scale = 1.4777594728171
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -4.2833609580994),
            scale = 1.3887973640857
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -0.98846787214279),
            scale = 1.4217462932455
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -2.9654035568237),
            scale = 1.3920922570016
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(-2.9654035568237, 0, -1.9769357442856),
            scale = 1.6161449752883
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-2.9654035568237, 0, -0.98846787214279),
            scale = 1.504118616145
        },
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -2.9654035568237),
            scale = 1.4085667215815
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -3.2948930263519),
            scale = 1.5205930807249
        },
        ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -1.3179571628571),
            scale = 1.35
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.647446513176),
            scale = 1.500823723229
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -1.647446513176),
            scale = 1.665568369028
        }
    }
}

rp.hats.Add{
    name = 'Медимед',
    category = '$ Наряд богатых людей $',
    type = APPAREL_MASKS,
    price = 10000000,
    model = 'models/workshop/player/items/medic/hw2013_medicmedes/hw2013_medicmedes.mdl',
    scale = 1.30,
    offpos = Vector(-0.4, 0, -100),
    infooffset = 7.5,
    game = 'tf'
}

rp.hats.Add{
    name = 'Возвышающийся столб шляп',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/scout/hat_first_nr.mdl',
    scale = 1.05,
    offpos = Vector(-1.8, 0, 1),
    game = 'tf',
    offsets = {
        ['models/player/barney.mdl'] = {
            offpos = Vector(-0.48134776949883, 0, 0.96269553899765),
            offang = Angle(0, 3.0324909687042, 0),
            scale = 1.05
        }
    }
}

rp.hats.Add{
    name = 'Капитан Карузер красный',
    category = 'Странности',
    price = 1000000,
    model = 'models/workshop/player/items/demo/inquisitor/inquisitor.mdl',
    scale = 1.05,
    offpos = Vector(79, 0, 1),
    offang = Angle(0, -85, 0),
    game = 'tf',
    variants = {'Капитан Карузер синий'}
}

rp.hats.Add{
    name = 'Нежный боеприпас',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/all_class/sd_rocket_scout.mdl',
    scale = 1.35,
    offpos = Vector(0, 0, -1),
    game = 'tf'
}

rp.hats.Add{
    name = 'Купол Старухи',
    category = 'Halloween',
    price = 25000000,
    model = 'models/workshop/player/items/all_class/witchhat/witchhat_medic.mdl',
    scale = 1.35,
    offpos = Vector(0, 0, 8),
    offsets = {
        ['MALE_CITIZEN'] = {
            offpos = Vector(0.72202163934708, 0, 5.5354995727539),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(0.72202163934708, 0, 6.1999998092651),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.1999998092651),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 5.7761731147766),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.9422383308411),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/breen.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 5.9000000953674),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/combine_soldier.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.3000001907349),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.5),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 5.5354995727539),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 6.9795427322388),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 6.6999998092651),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 8.3000001907349),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 9.6499996185303),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/guerilla.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.6999998092651),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.0999999046326),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 7.6999998092651),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/corpse1.mdl'] = {
            offpos = Vector(0.72202163934708, 0, 6.5999999046326),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-1.6847171783447, 0, 5.4499998092651),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(0.72200000286102, 0, 7.6999998092651),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-1.2033693790436, 0, 6.4981951713562),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(0.72200000286102, 0, 6.4000000953674),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(0.72200000286102, 0, 6),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
            offpos = Vector(0.72200000286102, 0, 7.9422383308411),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0.72200000286102, 0, 7),
            offang = Angle(0, 8.2310466766357, 0),
            scale = 1.35
        }
    },
    game = 'tf'
}

rp.hats.Add{
    name = 'VR Шлем',
    category = '$ Наряд богатых людей $',
    slots = b,
    type = APPAREL_MASKS,
    price = 10000000,
    model = 'models/player/items/all_class/all_class_oculus_scout.mdl',
    offpos = Vector(0, 0, 0.5),
    game = 'tf',
    offsets = {
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(0.32948929071426, 0, 0.5),
            offang = Angle(0, 6.5238881111145, 0),
            scale = 0.86820428336079
        }
    }
}

rp.hats.Add{
    name = 'Шляпа шерифа №1',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/workshop/player/items/all_class/sbox2014_law/sbox2014_law_scout.mdl',
    offpos = Vector(1.5, 0, -75),
    scale = 1.05,
    game = 'tf',
    variants = {'Шляпа шерифа №2'}
}

rp.hats.Add{
    name = 'МК 50',
    category = '$ Наряд богатых людей $',
    type = APPAREL_MASKS,
    price = 10000000,
    model = 'models/workshop/player/items/all_class/ai_spacehelmet/ai_spacehelmet_scout.mdl',
    offpos = Vector(2.5, 0, -75),
    scale = 1.05,
    infooffset = 10,
    game = 'tf'
}

rp.hats.Add{
    name = 'Ушанка',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/all_class/xms_furcap_scout.mdl',
    offpos = Vector(1.5, 0, -75),
    scale = 1.05,
    offang = Angle(5, 0, 0),
    game = 'tf'
}

rp.hats.Add{
    name = 'Детектив Нуар коричневая',
    category = 'Хипстерская фаза',
    price = 7500000,
    model = 'models/player/items/spy/spy_detective_noir.mdl',
    offpos = Vector(-1.5, 0, -0.5),
    scale = 1.30,
    game = 'tf',
    variants = {'Детектив Нуар синий'}
}

rp.hats.Add{
    name = 'Красный шлем бригадира',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/pyro/fireman_helmet.mdl',
    offpos = Vector(-4.5, 0, -75.5),
    scale = 1.05,
    infooffset = 10,
    game = 'tf',
    variants = {'Синий шлем бригадира'}
}

rp.hats.Add{
    name = 'Хоккейная маска',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/workshop/player/items/pyro/hwn2015_face_of_mercy/hwn2015_face_of_mercy.mdl',
    offpos = Vector(-4.5, 0, -75.5),
    scale = 1.05,
    infooffset = 7.5,
    game = 'tf'
}

rp.hats.Add{
    name = 'Красные глаза',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 1500000,
    model = 'models/workshop/player/items/pyro/fall2013_popeyes/fall2013_popeyes.mdl',
    offpos = Vector(-4.5, 0, -75.5),
    scale = 1.05,
    infooffset = 7.5,
    game = 'tf',
    offsets = {
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-3.9538714885712, -0.32948929071426, -64.250411987305),
            scale = 0.88138385502471
        }
    },
    variants = {'Синие глаза'}
}

rp.hats.Add{
    name = 'Кепка с пропеллером красная',
    category = 'Небольшой изгиб',
    price = 2500000,
    model = 'models/player/items/pyro/pyro_hat.mdl',
    offpos = Vector(-4.5, 0, -95.5),
    scale = 1.30,
    game = 'tf',
    variants = {'Кепка с пропеллером синия'}
}

rp.hats.Add{
    name = 'Желтые волосы',
    category = 'Небольшой изгиб',
    price = 5000000,
    model = 'models/player/items/all_class/xcom_flattop_scout.mdl',
    offpos = Vector(1.5, 0, -88.5),
    scale = 1.20,
    game = 'tf',
    variants = {'Коричневые волосы'}
}

rp.hats.Add{
    name = 'Медвежьи нужды',
    category = '$ Наряд богатых людей $',
    type = APPAREL_MASKS,
    price = 15000000,
    model = 'models/workshop/player/items/heavy/jul13_bear_necessitys/jul13_bear_necessitys.mdl',
    offpos = Vector(3.5, 0, -36.5),
    scale = 0.90,
    infooffset = 10,
    game = 'tf'
}

rp.hats.Add{
    name = 'Геральт',
    category = '$ Наряд богатых людей $',
    price = 25000000,
    model = 'models/player/items/scout/scout_hair.mdl',
    offpos = Vector(0, 0, 0),
    scale = 1.12,
    game = 'tf'
}

rp.hats.Add{
    name = 'Медведь',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/bear.mdl',
    skin = 0,
    offpos = Vector(0, 0, 2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Китти Кэт',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/cat.mdl',
    skin = 0,
    offpos = Vector(0, 0, 2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10,
    offsets = {
        ['MALE_CITIZEN'] = {
            offpos = Vector(0.20000000298023, -0.30000001192093, 2.7000000476837),
            offang = Angle(2, 0, 0),
            scale = 1.0395387149918
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(0, 0, 3.6243822574615),
            offang = Angle(2, 0, 0),
            scale = 1.0593080724876
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(0.32948929071426, 0, 2.9654035568237),
            offang = Angle(2, 0, 0),
            scale = 1.0296540362438
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(0.98846787214279, -0.32948929071426, 2.6359143257141),
            offang = Angle(2, 0, 0),
            scale = 0.94728171334432
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(0, 0, 3.6243822574615),
            offang = Angle(2, 0, 0),
            scale = 1.0889621087315
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(0.32948929071426, 0, 5.6013178825378),
            offang = Angle(2, 0, 0),
            scale = 1.0494233937397
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(0.98846787214279, 0, 3.2948930263519),
            offang = Angle(2, 0, 0)
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(0.69999998807907, -0.30000001192093, 3.7000000476837),
            offang = Angle(2, 0, 0)
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(-0.69999998807907, -0.10000000149012, 1.3179571628571),
            offang = Angle(2, 0, 0),
            scale = 0.95
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(0, 0, 2.5999999046326),
            offang = Angle(2, 0, 0)
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(-0.46000000834465, -0.30000001192093, 2.2000000476837),
            offang = Angle(2, 0, 0),
            scale = 1.035
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(-0.33000001311302, 0, 2),
            offang = Angle(2, 0, 0)
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(0.66000002622604, 0, 3),
            offang = Angle(2, -6, 0)
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0.40000000596046, -0.10000000149012, 2),
            offang = Angle(2, 0, 0),
            scale = 0.8
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(-0.25, -0.25, 1.8064515590668),
            offang = Angle(2, 0, 0),
            scale = 1.03
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(-0.20000000298023, 0, 2),
            offang = Angle(2, 0, 0)
        }
    }
}

rp.hats.Add{
    name = 'Подлый лис',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/fox.mdl',
    skin = 0,
    offpos = Vector(0, 0, 2),
    offang = Angle(2, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Колобок',
    category = 'Шляпы, которые вы не можете себе позволить',
    slots = b,
    type = APPAREL_MASKS,
    price = 10000000,
    model = 'models/sal/gingerbread.mdl',
    skin = 0,
    offpos = Vector(0.5, 0, 2),
    offang = Angle(0, 6, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Америка, черт возьми!',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/hawk_1.mdl',
    skin = 0,
    offpos = Vector(1, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Америка, черт возьми!',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/hawk_2.mdl',
    skin = 0,
    offpos = Vector(1, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Мистер Сова',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/owl.mdl',
    skin = 0,
    offpos = Vector(0, 0, 0),
    offang = Angle(2, 3, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Свинья',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/pig.mdl',
    skin = 0,
    offpos = Vector(0, 0, 1),
    offang = Angle(4, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кровавая свинья',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/pig.mdl',
    skin = 1,
    offpos = Vector(0, 0, 1),
    offang = Angle(4, 0, 0),
    scale = 1.1,
    infooffset = 10,
    offsets = {
        ['models/player/leet.mdl'] = {
            offpos = Vector(0, 0, 2.5806450843811),
            offang = Angle(4, 0, 0),
            scale = 1.1
        },
    }
}

rp.hats.Add{
    name = 'Злой волк',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/wolf.mdl',
    skin = 0,
    offpos = Vector(0, 0, 1),
    offang = Angle(4, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №1!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 0,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №2!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 1,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №3!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 2,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №4!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 3,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №5!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 4,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №6!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 5,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска синия',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Медведь" №1',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Медведь" №2',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Медведь" №3',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Медведь" №4',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 4,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Король"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 5,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Зомби"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 6,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Зомби" №2',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 7,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Череп" №1',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 8,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Череп" №2',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 9,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Череп" №3',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 10,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Тень"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 11,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10,
    offsets = {
        ['models/player/arctic.mdl'] = {
            offpos = Vector(1, 0, 2.0133090019226),
            offang = Angle(5, 15, 0)
        }
    }
}

rp.hats.Add{
    name = 'Хоккейная маска "Кожа"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 12,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Кожа" №2',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 13,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Сиэтл Кракен"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 14,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

local c = {
    ['FEMALE_CITIZEN'] = {
        offpos = Vector(0.9, 0, -1.35),
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['MALE_CITIZEN'] = {
        offpos = Vector(1.3, 0, 0),
        offang = Angle(5, 15, 0),
        scale = 0.935
    },
    ['models/code_gs/player/cage.mdl'] = {
        offpos = Vector(1.5, 0, 2.9654035568237),
        offang = Angle(5, 15, 0),
        scale = 1.0230642504119
    },
    ['models/player/leet.mdl'] = {
        offpos = Vector(1.2999999523163, 0, 1.2999999523163),
        offang = Angle(5, 15, 0),
        scale = 1.05
    },
    ['models/player/arctic.mdl'] = {
        offpos = Vector(1, 0, 1.2999999523163),
        offang = Angle(5, 15, 0)
    },
    ['models/player/guerilla.mdl'] = {
        offpos = Vector(0.64999997615814, 0, 1.2999999523163),
        offang = Angle(5, 15, 0)
    },
    ['models/player/phoenix.mdl'] = {
        offpos = Vector(1, 0, 1.2999999523163),
        offang = Angle(5, 15, 0)
    },
    ['models/player/charple.mdl'] = {
        offpos = Vector(-0.33000001311302, 0, -0.33000001311302),
        offang = Angle(5, 15, 0),
        scale = 0.785
    },
    ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
        offpos = Vector(0.64999997615814, 0, 1.6499999761581),
        offang = Angle(5, 15, 0),
        scale = 0.92421746293245
    },
    ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
        offpos = Vector(1.647446513176, 0, -1.647446513176),
        offang = Angle(5, 15, 0),
        scale = 1.05
    },
    ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
        offpos = Vector(2.2999999523163, 0, 0),
        offang = Angle(5, 15, 0)
    },
    ['models/player/riot.mdl'] = {
        offpos = Vector(2, 0, 1.2999999523163),
        offang = Angle(5, 15, 0)
    },
    ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
        offpos = Vector(-0.65897858142853, 0, -0.65897858142853),
        offang = Angle(5, 15, 0)
    },
    ['models/player/skeleton.mdl'] = {
        offpos = Vector(0, 0, 1),
        offang = Angle(5, 4.75, 0),
        scale = 0.96
    },
    ['models/player/breen.mdl'] = {
        offpos = Vector(0.30000001192093, 0, -0.30000001192093),
        offang = Angle(5, 9, 0),
        scale = 0.96
    },
    ['models/player/barney.mdl'] = {
        offpos = Vector(0.325, 0, -0.325),
        offang = Angle(5, 10.675, 0),
        scale = 1.035
    },
    ['models/player/police.mdl'] = {
        offpos = Vector(2.6359143257141, 0, -2.3064250946045),
        offang = Angle(5, 26.095552444458, 0)
    },
    ['models/player/combine_soldier.mdl'] = {
        offpos = Vector(1, 0, -1.2999999523163),
        offang = Angle(5, 32, 0),
        scale = 1.075
    },
    ['models/player/riot.mdl'] = {
        offpos = Vector(1, 0, 1),
        offang = Angle(5, 15, 0)
    },
    ['models/player/combine_super_soldier.mdl'] = {
        offpos = Vector(1.2999999523163, 0, 0),
        offang = Angle(5, 31.5, 0),
        scale = 1.05
    },
    ['models/player/gasmask.mdl'] = {
        offpos = Vector(3.4000000953674, 0, -1.9769357442856),
        offang = Angle(5, 33.805603027344, 0)
    },
    ['models/player/swat.mdl'] = {
        offpos = Vector(3.625, 0, 0.32499998807907),
        offang = Angle(5, 22.5, 0),
        scale = 1.05
    },
    ['models/player/combine_soldier_prisonguard.mdl'] = {
        offpos = Vector(1.3179571628571, 0, -1.3179571628571),
        offang = Angle(5, 31.5, 0),
        scale = 1.05
    },
    ['models/player/urban.mdl'] = {
        offpos = Vector(1.6499999761581, 0, 0.64999997615814),
        offang = Angle(5, 15, 0)
    },
    ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
        offpos = Vector(0, 0, -0.64999997615814),
        offang = Angle(5, 15, 0),
        scale = 0.93
    },
    ['models/player/gman_high.mdl'] = {
        offpos = Vector(1.2999999523163, 0, 0.64999997615814),
        offang = Angle(5, 15, 0),
        scale = 0.95
    },
    ['models/player/monk.mdl'] = {
        offpos = Vector(0, 0, 1),
        offang = Angle(5, 7, 0),
        scale = 0.975
    },
    ['models/player/eli.mdl'] = {
        offpos = Vector(0.66000002622604, 0, -0.32499998807907),
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['models/player/mossman.mdl'] = {
        offpos = Vector(0.32499998807907, 0, -0.32499998807907),
        offang = Angle(5, 11.25, 0),
        scale = 0.95
    },
    ['models/player/alyx.mdl'] = {
        offpos = Vector(-0.32499998807907, 0, -0.64999997615814),
        offang = Angle(5, 15, 0)
    },
    ['models/player/magnusson.mdl'] = {
        offpos = Vector(0.32948929071426, 0, -0.65897858142853),
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['models/player/p2_chell.mdl'] = {
        offpos = Vector(0.64999997615814, 0, -0.33000001311302),
        offang = Angle(5, 15, 0),
        scale = 0.95
    },
    ['models/code_gs/player/robber.mdl'] = {
        offpos = Vector(1, 0, 0.65897858142853),
        offang = Angle(5, 15, 0),
        scale = 0.945
    },
    ['models/player/corpse1.mdl'] = {
        offpos = Vector(1, 0, 0.32499998807907),
        offang = Angle(5, 13.5, 0),
        scale = 0.945
    },
    ['models/player/soldier_stripped.mdl'] = {
        offpos = Vector(0, 0, -1),
        offang = Angle(5, 15, 0),
        scale = 0.885
    },
    ['models/player/kleiner.mdl'] = {
        offpos = Vector(0.32499998807907, 0, -0.32499998807907),
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
        offpos = Vector(-0.32499998807907, 0, 0),
        offang = Angle(5, 7, 0)
    },
    ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
        offpos = Vector(-0.32499998807907, 0, 0),
        offang = Angle(5, 11, 0),
        scale = 0.95
    },
    ['models/sup/player/custom/bones/bones2.mdl'] = {
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['models/auditor/com/honoka/honoka.mdl'] = {
        offpos = Vector(1, 0, -0.64999997615814),
        offang = Angle(5, 15, 0),
        scale = 0.925
    }
}

rp.hats.Add{
    name = 'DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Материнская плата DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Лава DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Фиолетовая лава DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Тёмный DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 4,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Коллекционная Цель DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 5,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10,
    unvisible = true
}

rp.hats.Add{
    name = 'Расцарапанный DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 6,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Электрический DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 7,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Деревянный DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 8,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

local d = {
    ['MALE_CITIZEN'] = {
        offpos = Vector(0, 0, -25),
        offang = Angle(5, 15, 0)
    },
    ['FEMALE_CITIZEN'] = {
        offpos = Vector(0, 0, -27),
        offang = Angle(5, 15, 0)
    },
    ['models/player/skeleton.mdl'] = {
        offpos = Vector(0, 0, -25.5),
        offang = Angle(5, 15, 0)
    },
    ['models/player/breen.mdl'] = {
        offpos = Vector(-0.25, 0, -26.5),
        offang = Angle(5, 15, 0)
    },
    ['models/player/barney.mdl'] = {
        offpos = Vector(0.20000000298023, 0, -29.5),
        offang = Angle(5, 15, 0),
        scale = 1.185
    },
    ['models/player/combine_soldier.mdl'] = {
        offpos = Vector(0.5, 0, -35.914333343506),
        offang = Angle(5, 15, 0),
        scale = 1.5
    },
    ['models/player/riot.mdl'] = {
        offpos = Vector(1.25, 0, -33),
        offang = Angle(5, 15, 0),
        scale = 1.4
    },
    ['models/player/combine_soldier_prisonguard.mdl'] = {
        offpos = Vector(0.69999998807907, 0, -35.5),
        offang = Angle(5, 15, 0),
        scale = 1.5
    },
    ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
        offpos = Vector(1, 0, -28),
        offang = Angle(5, 15, 0),
        scale = 1.1
    },
    ['models/player/gman_high.mdl'] = {
        offpos = Vector(0.60000002384186, 0, -25),
        offang = Angle(5, 15, 0)
    },
    ['models/player/monk.mdl'] = {
        offpos = Vector(0.40000000596046, 0, -29.5),
        offang = Angle(5, 15, 0),
        scale = 1.2
    },
    ['models/player/leet.mdl'] = {
        offpos = Vector(0.64999997615814, 0, -31),
        offang = Angle(5, 15, 0),
        scale = 1.3
    },
    ['models/player/eli.mdl'] = {
        offpos = Vector(0.80000001192093, 0, -30.313014984131),
        offang = Angle(5, 15, 0),
        scale = 1.2
    },
    ['models/player/mossman.mdl'] = {
        offpos = Vector(1, 0, -27),
        offang = Angle(5, 15, 0)
    },
    ['models/player/police.mdl'] = {
        offpos = Vector(0.20000000298023, 0, -29.5),
        offang = Angle(5, 15, 0),
        scale = 1.185
    },
    ['models/player/gasmask.mdl'] = {
        offpos = Vector(1.25, 0, -33),
        offang = Angle(5, 15, 0),
        scale = 1.4
    },
    ['models/player/swat.mdl'] = {
        offpos = Vector(1.25, 0, -33),
        offang = Angle(5, 15, 0),
        scale = 1.4
    },
    ['models/player/urban.mdl'] = {
        offpos = Vector(1.25, 0, -33),
        offang = Angle(5, 15, 0),
        scale = 1.4
    },
    ['models/player/combine_super_soldier.mdl'] = {
        offpos = Vector(0.69999998807907, 0, -35.5),
        offang = Angle(5, 15, 0),
        scale = 1.5
    },
    ['models/player/alyx.mdl'] = {
        offpos = Vector(1.2999999523163, 0, -26.5),
        offang = Angle(5, 15, 0)
    },
    ['models/player/magnusson.mdl'] = {
        offpos = Vector(1, 0, -30),
        offang = Angle(5, 15, 0),
        scale = 1.15
    },
    ['models/player/lulsec.mdl'] = {
        offpos = Vector(0.69999998807907, 0, -25.700164794922),
        offang = Angle(5, 17, 0),
        scale = 1.05
    },
    ['models/player/p2_chell.mdl'] = {
        offpos = Vector(0, 0, -26.5),
        offang = Angle(5, 18, 0)
    },
    ['models/code_gs/player/cage.mdl'] = {
        offpos = Vector(1.9769357442856, 0, -37.799999237061),
        offang = Angle(5, 10, 0),
        scale = 1.7
    },
    ['models/player/guerilla.mdl'] = {
        offpos = Vector(0.64999997615814, 0, -31),
        offang = Angle(5, 19, 0),
        scale = 1.325
    },
    ['models/code_gs/player/robber.mdl'] = {
        offpos = Vector(1.2999999523163, 0, -27),
        offang = Angle(5, 7.5, 0),
        scale = 1.1
    },
    ['models/player/odessa.mdl'] = {
        offpos = Vector(0, 0, -27.5),
        offang = Angle(5, 15, 0),
        scale = 1.1
    },
    ['models/player/phoenix.mdl'] = {
        offpos = Vector(0.32948929071426, 0, -30),
        offang = Angle(5, 19, 0),
        scale = 1.25
    },
    ['models/player/corpse1.mdl'] = {
        offpos = Vector(0, 0, -25),
        offang = Angle(5, 15, 0)
    },
    ['models/player/charple.mdl'] = {
        offpos = Vector(-0.5, 0, -26),
        offang = Angle(5, 10, 0),
        scale = 0.95
    },
    ['models/player/arctic.mdl'] = {
        offpos = Vector(0, 0, -28.5),
        offang = Angle(5, 16, 0),
        scale = 1.25
    },
    ['models/player/soldier_stripped.mdl'] = {
        offpos = Vector(0, 0, -27),
        offang = Angle(5, 15, 0)
    },
    ['models/player/kleiner.mdl'] = {
        offpos = Vector(0, 0, -28.75),
        offang = Angle(5, 15, 0),
        scale = 1.1
    },
    ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
        offpos = Vector(0.5, 0, -30),
        offang = Angle(5, 15, 0),
        scale = 1.2
    },
    ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
        offpos = Vector(-0.98846787214279, 0, -36.5),
        offang = Angle(5, 15, 0),
        scale = 1.5
    },
    ['models/sup/player/custom/bones/bones2.mdl'] = {
        offpos = Vector(1.2999999523163, 0, -28.25),
        offang = Angle(5, 18.978582382202, 0),
        scale = 1.085
    },
    ['models/auditor/com/honoka/honoka.mdl'] = {
        offpos = Vector(-0.32948929071426, 0, -27.5),
        offang = Angle(5, 22, 0),
        scale = 1.05
    },
    ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
        offpos = Vector(0.98846787214279, 0, -27.01812171936),
        offang = Angle(5, 22.5, 0),
        scale = 1.075
    },
    ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
        offpos = Vector(1, 0, -33),
        offang = Angle(5, 22, 0),
        scale = 1.3
    },
    ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
        offpos = Vector(1, 0, -31.5),
        offang = Angle(5, 19, 0),
        scale = 1.3
    }
}

rp.hats.Add{
    name = 'Рюкзак К&Б',
    category = 'SUPREME',
    type = APPAREL_SCARVES,
    price = 25000000,
    model = 'models/eclipse_custom/cebula/backpackkb.mdl',
    skin = 0,
    offpos = Vector(4.1290321350098, 0, -7.2258062362671),
    offang = Angle(0, 0, 180),
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(4.1290321350098, 0, -10.838709831238),
            offang = Angle(0, 0, 180),
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/doa_honoka_bunny.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -9.0322580337524),
            offang = Angle(0, 0, 180),
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -5.9354839324951),
            offang = Angle(0, 0, 180),
        },
        ['models/player/corpse1.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -6.7096772193909),
            offang = Angle(0, 0, 180),
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -4.645161151886),
            offang = Angle(0, 0, 180),
        },
        ['models/player/police_agent/male_01_agent.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/police_agent/male_02_agent.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/police_agent/male_03_agent.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/police_agent/male_04_agent.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/police_agent/male_05_agent.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/police_agent/male_06_agent.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/police_agent/male_07_agent.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/police_agent/male_08_agent.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/police_agent/male_09_agent.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/fbi/player/mehdi/fbi04.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/gta5/player/deputypm.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(2.1290321350098, 0, -10.580645561218),
            offang = Angle(0, 0, 180),
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(4.1290321350098, 0, -7.4838709831238),
            offang = Angle(0, 0, 180),
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(4.1290321350098, 0, -11.096774101257),
            offang = Angle(0, 0, 180),
        },
    },
    bone = "ValveBiped.Bip01_Spine2",
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Белый',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Серый',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Черный',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф темно-синий',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Красный',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 4,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Зеленый',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 5,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Розовый',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 6,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

local f = {
    ['FEMALE_CITIZEN'] = {
        offpos = Vector(0, 0, 9.4786729812622),
        offang = Angle(0, 0, 180),
    },
    ['models/player/kerry/police_02_female.mdl'] = {
        offpos = Vector(0, 0, 9.8578195571899),
        offang = Angle(0, 0, 180),
    },
    ['models/code_gs/player/cage.mdl'] = {
        offpos = Vector(-1.2903225421906, 0, 16.516128540039),
        offang = Angle(0, 0, 180),
    },
    ['models/sup/player/custom/cosmonaut/cosmonaut.mdl'] = {
        offpos = Vector(-2.5806450843811, 0, 12),
        offang = Angle(0, 0, 180),
    },
    ['models/player/combine_soldier.mdl'] = {
        offpos = Vector(-2.322580575943, 0, 12),
        offang = Angle(0, 0, 180),
    },
    ['models/player/combine_super_soldier.mdl'] = {
        offpos = Vector(-3.0967741012573, 0, 12),
        offang = Angle(0, 0, 180),
    },
}

rp.hats.Add{
    name = 'RGB Плащ',
    category = 'Плащи',
    type = APPAREL_SCARVES,
    price = 5000000,
    model = 'models/cape/cape.mdl',
    skin = 0,
    offpos = Vector(0, 0, 12),
    offang = Angle(0, 0, 180),
    offsets = f,
    bone = "ValveBiped.Bip01_Spine2",
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет Up-n-Atom',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 1,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет улыбок',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 1,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет слез',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 2,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет немого',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 3,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет ловкости',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 4,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет зубов',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 5,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет невинных',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 6,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Мешок бургер шот',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 7,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет цели',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 8,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет дьявола',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 9,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет полицейского',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 10,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет криков',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 11,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет гнева',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 12,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет Зигзага',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 13,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет черепа',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 14,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет собаки',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 15,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет призрака',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 16,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет пришельца',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 17,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Мешок "HELP ME"',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 18,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет лабиринт',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 19,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет иди нахуй',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 20,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет сэр',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 21,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет с наклейками',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 22,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет красоты',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 23,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет любви',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 24,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет черного цвета',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 25,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Чумной доктор',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 1500000,
    model = 'models/sal/halloween/doctor.mdl',
    skin = 0,
    offpos = Vector(-0.5, -0.3, 1.25),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10,
    offsets = {
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-2.9654035568237, -0.32948929071426, 0.80000001192093),
            scale = 1.0461285008237
        }
    }
}

rp.hats.Add{
    name = 'Чумной доктор 2',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 1500000,
    model = 'models/sal/halloween/doctor.mdl',
    skin = 1,
    offpos = Vector(-0.5, -0.3, 1.25),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Чумной доктор 3',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 1500000,
    model = 'models/sal/halloween/doctor.mdl',
    skin = 2,
    offpos = Vector(-0.5, -0.3, 1.25),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка места преступления',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap1.mdl',
    skin = 0,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка осторожности',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap1.mdl',
    skin = 1,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка осторожности 2',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap1.mdl',
    skin = 2,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка красных стрел',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap1.mdl',
    skin = 3,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка серого',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap2.mdl',
    skin = 0,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка черного',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap2.mdl',
    skin = 1,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка светло-серого цвета',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap2.mdl',
    skin = 2,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка радуги',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap2.mdl',
    skin = 3,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обезьяна',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/monkey.mdl',
    skin = 0,
    offpos = Vector(0.7, 0, 1.3),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обезьяна черная',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/monkey.mdl',
    skin = 1,
    offpos = Vector(0.7, 0, 1.3),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Зомби Обезьяна',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/monkey.mdl',
    skin = 2,
    offpos = Vector(0.7, 0, 1.3),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Старая Обезьяна',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/monkey.mdl',
    skin = 3,
    offpos = Vector(0.7, 0, 1.3),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя чёрный',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 0,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя белый',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 1,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя бежевый',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 2,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя темно-коричневый',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 3,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя серый',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 4,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя камуфляж',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 5,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя бело-красный',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 6,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя черно-белая',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 7,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя бело-черный',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 8,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя розовый камуфляж',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 9,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя чёрно-золотой',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 10,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Череп серый',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/halloween/skull.mdl',
    skin = 0,
    offpos = Vector(0, -0.3, 2.6),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Череп коричневый',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/halloween/skull.mdl',
    skin = 1,
    offpos = Vector(0, -0.3, 2.6),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Череп светло-коричневый',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/halloween/skull.mdl',
    skin = 2,
    offpos = Vector(0, -0.3, 2.6),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Череп чёрный',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/halloween/skull.mdl',
    skin = 3,
    offpos = Vector(0, -0.3, 2.6),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Франкенштейн',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/zombie.mdl',
    skin = 0,
    offpos = Vector(0.5, -0.3, 2.0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Франкенштейн серый',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/zombie.mdl',
    skin = 1,
    offpos = Vector(0.5, -0.3, 2.0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add {
	name = 'Интеллигентный пингвин',
	category = 'Шляпы, которые вы не можете себе позволить',
	type = APPAREL_MASKS,
	price = 99999999,
	model = 'models/sal/penguin.mdl',
	skin = 0,
	offpos = Vector(1, -0.5, 1),
	offang = Angle(2, 15, 0),
	scale = 1.05,
	infooffset = 10,
    offsets = {
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(2.0645160675049, -0.5, 4.3870968818665),
            offang = Angle(2, 15, 0),
            scale = 1.05
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(1.5483870506287, -0.5, 2.8387095928192),
            offang = Angle(2, 15, 0),
            scale = 1.05
        },
    }
}

rp.hats.Add {
    name = 'Бандана',
    category = 'Небольшой изгиб',
    type = APPAREL_MASKS,
    slots = {
        [APPAREL_MASKS] = true
    },
    price = 1500000,
    model = 'models/modified/bandana.mdl',
    skin = 0,
    offpos = Vector(0.5, -0.3, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10,
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(-0.32948929071426, -0.30000001192093, -1.3179571628571),
            scale = 1.0658978583196
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(0, -0.30000001192093, -0.32948929071426),
            scale = 1.0691927512356
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(0, -0.30000001192093, -0.5),
            scale = 1.0494233937397
        },
        ['models/player/breen.mdl'] = {
            offpos = Vector(-0.60000002384186, 0, -0.98846787214279),
            scale = 1.0593080724876
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -0.98846787214279),
            scale = 1.161449752883
        },
        ['models/player/police.mdl'] = {
            offpos = Vector(1.3179571628571, -0.30000001192093, -2.3064250946045),
            scale = 1.3228995057661
        },
        ['models/player/combine_soldier.mdl'] = {
            offpos = Vector(0.32948929071426, 0, -0.5),
            scale = 1.2438220757825
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(0.32948929071426, -0.32948929071426, 0.32948929071426),
            scale = 1.0757825370675
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(0.5, -0.32948929071426, -0.98846787214279),
            scale = 1.2042833607908
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(2.6359143257141, -0.65897858142853, -0.5),
            scale = 1.161449752883
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(0.5, 0, 0),
            scale = 1.1285008237232
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(0.98846787214279, -0.30000001192093, 0),
            scale = 1.1252059308072
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(0.43999999761581, -0.20000000298023, -0.65897858142853),
            offang = Angle(0, 11, 0),
            scale = 1.1054365733114
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.9769357442856),
            offang = Angle(0, 8.3031301498413, 0),
            scale = 1.0757825370675
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(0, 0, 0.32948929071426),
            scale = 1.0527182866557
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0),
            scale = 1.1252059308072
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0.98846787214279),
            scale = 1.171334431631
        },
        ['models/player/eli.mdl'] = {
            offpos = Vector(-0.89999997615814, 0, -0.5),
            scale = 1.1
        },
        ['models/player/mossman.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.3179571628571),
            scale = 1.1
        },
        ['models/player/alyx.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -1.647446513176),
            scale = 1.1
        },
        ['models/player/magnusson.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -1.3179571628571),
            scale = 1.1
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(0.32948929071426, -0.30000001192093, 0.32948929071426),
            scale = 1.0527182866557
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(-0.65897858142853, -0.30000001192093, -0.98846787214279),
            scale = 1.0263591433278
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(-0.32948929071426, -0.30000001192093, 2.6359143257141),
            scale = 1.1845140032949
        },
        ['models/player/guerilla.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0.32948929071426),
            scale = 1.2075782537068
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0),
            scale = 1.1
        },
        ['models/player/odessa.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, -0.65897858142853),
            scale = 1.1120263591433
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(-0.65897858142853, -0.30000001192093, 0.65897858142853),
            scale = 1.1976935749588
        },
        ['models/player/corpse1.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0),
            scale = 1.0296540362438
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -1.3179571628571),
            scale = 0.88797364085667
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(-0.65897858142853, -0.30000001192093, 0.65897858142853),
            scale = 1.1976935749588
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -0.5),
            scale = 1.1219110378913
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -1.3179571628571),
            scale = 1.0296540362438
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -0.65897858142853),
            scale = 1.0593080724876
        },
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(-1.647446513176, -0.30000001192093, -0.65897858142853),
            scale = 1.1
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -1.647446513176),
            scale = 1.1
        },
        ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, 0.98846787214279),
            scale = 1.0164744645799
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0.5, 0, -1.647446513176),
            scale = 1.2306425041186
        }
    }
}

rp.hats.Add {
    name = 'Хипстерские очки',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 500000,
    model = 'models/modified/glasses01.mdl',
    skin = 0,
    offpos = Vector(0, -0.35, 3.5),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10,
    variants = {'Хипстерские очки №2', 'Хипстерские очки №3', 'Хипстерские очки №4', 'Хипстерские очки №5', 'Хипстерские очки №6'}
}

rp.hats.Add {
    name = 'Хипстерские очки №7',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 500000,
    model = 'models/modified/glasses02.mdl',
    skin = 0,
    offpos = Vector(0, -0.35, 3.5),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10,
    variants = {'Хипстерские очки №8', 'Хипстерские очки №9', 'Хипстерские очки №10', 'Хипстерские очки №11'}
}

rp.hats.Add {
    name = 'Шляпа серая',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat01_fix.mdl',
    skin = 0,
    offpos = Vector(0.5, -0.25, 4.5),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10,
    variants = {'Шляпа чёрная', 'Шляпа белая', 'Шляпа бежевая', 'Шляпа красная', 'Шляпа чёрно-красная', 'Шляпа коричневая', 'Шляпа синия'}
}

rp.hats.Add {
    name = 'Обвисшая шапка в красную полоску',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat03.mdl',
    skin = 0,
    offpos = Vector(0.5, -0.25, 4.5),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10,
    variants = {'Обвисшая шапка фиолетовая', 'Обвисшая шапка красная', 'Обвисшая шапка белая', 'Обвисшая шапка в черную полоску'},
    offsets = {
        ['models/player/leet.mdl'] = {
            offpos = Vector(0.79025757312775, -0.22757270932198, 7.1106290817261),
            offang = Angle(-3.3020832538605, 9.7240114212036, 0),
            scale = 1.1144421830497
        }
    }
}

rp.hats.Add {
    name = 'Шапка чёрная',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 0,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add {
    name = 'Шапка серая',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 1,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add {
    name = 'Шапка полосатая',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 2,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add {
    name = 'Шапка растомана',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 3,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шапка синия',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 4,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка Розовая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat05.mdl',
    skin = 1,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепарик!',
    category = 'бейсболки',
    price = 7499999,
    model = 'models/modified/hat06.mdl',
    skin = 0,
    offpos = Vector(1.5, 0, 4.5),
    offang = Angle(5, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка черно-зеленая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 0,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка черно-зеленая 2',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 1,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка серая и черная',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 2,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка белая и черная',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 3,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка зелено-белая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 4,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка темно-зеленая с белым',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 5,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка бордово-белая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 6,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка сине-зеленая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 7,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка коричнево-белая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 8,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка коричнево-белая 2',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 9,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка коричнево-красная',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 1000000,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

local e = {
    ['FEMALE_CITIZEN'] = {
        offpos = Vector(1, -0.30000001192093, 2.3064250946045),
        offang = Angle(2, 12, 0)
    },
    ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
        offpos = Vector(-0.32948929071426, 0, 5.6013178825378),
        offang = Angle(2, 10.082372665405, 0),
        scale = 1.0560131795717
    },
    ['models/auditor/com/honoka/honoka.mdl'] = {
        offpos = Vector(-0.32948929071426, 0.070000000298023, 3.2948930263519),
        offang = Angle(2, 12, 0),
        scale = 1.1
    },
    ['models/player/leet.mdl'] = {
        offpos = Vector(0.20000000298023, 0.059999998658895, 7),
        offang = Angle(2, 0, 0),
        scale = 1.03
    },
    ['models/player/monk.mdl'] = {
        offpos = Vector(1, -0, 4.5),
        offang = Angle(2, 12, 0)
    },
    ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
        offpos = Vector(2, -0.25, 4),
        offang = Angle(2, 8.8950004577637, 0),
        scale = 0.97
    },
    ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
        offpos = Vector(0.10000000149012, -0.20000000298023, 2.5806450843811),
        offang = Angle(2, 16.722579956055, 0),
        scale = 1.1
    },
    ['models/player/combine_soldier.mdl'] = {
        offpos = Vector(-1.2000000476837, -0.10000000149012, 4.9032258987427),
        offang = Angle(2, 10, 0),
        scale = 1.1
    },
    ['models/player/combine_super_soldier.mdl'] = {
        offpos = Vector(-1.5483870506287, 0, 5.6774191856384),
        offang = Angle(2, 1.3935483694077, 0),
        scale = 1.1
    },
    ['models/player/swat.mdl'] = {
        offpos = Vector(0, 0, 6.9677419662476),
        offang = Angle(2, 0, 0),
        scale = 1.1
    },
    ['models/player/combine_soldier_prisonguard.mdl'] = {
        offpos = Vector(-1.0322580337524, -0.10000000149012, 4.5),
        offang = Angle(2, 12, 0),
        scale = 1.05
    },
    ['models/player/alyx.mdl'] = {
        offpos = Vector(-0.69999998807907, 0.20000000298023, 4.5),
        offang = Angle(2, 9, 0)
    },
    ['models/code_gs/player/cage.mdl'] = {
        offpos = Vector(1, -0.30000001192093, 8),
        offang = Angle(2, 12, 0),
    },
}

rp.hats.Add{
    name = 'Кепка дальнобойщика оранжевая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 0,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика сине-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 1,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика коричнево-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 2,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика коричнево-белая 2',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 3,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика красно-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 4,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика зелено-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 5,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика черно-Мульти',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 6,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика черно-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 7,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика черно-белая 2',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 8,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика коричнево-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 9,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика фиолетовая-Мульти',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 10,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика коричнево-белая 2',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 11,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Наушники красные',
    category = 'Airpods MAX',
    price = 500000,
    model = 'models/modified/headphones.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 2.2),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Наушники фиолетовые',
    category = 'Airpods MAX',
    price = 500000,
    model = 'models/modified/headphones.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, 2.2),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Наушники зеленые',
    category = 'Airpods MAX',
    price = 500000,
    model = 'models/modified/headphones.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, 2.2),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Наушники желтые',
    category = 'Airpods MAX',
    price = 500000,
    model = 'models/modified/headphones.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, 2.2),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Маска убийц',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask5.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Афро',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/gmod_tower/afro.mdl',
    offpos = Vector(-3.0967741012573, 0, 5.1612901687622),
    scale = 1,
    infooffset = 7.5
}

rp.hats.Add{
    name = 'Андросс',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/gmod_tower/androssmask.mdl',
    offpos = Vector(2, 0, 1.5),
    scale = 1,
    infooffset = 7.5
}

rp.hats.Add{
    name = 'Авиаторы',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_GLASSES,
    price = 750000,
    model = 'models/gmod_tower/aviators.mdl',
    offpos = Vector(1.75, 0, 3.3548386096954),
    scale = 1,
    infooffset = 7.5
}

rp.hats.Add{
    name = 'Бейсболка',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_HATS,
    price = 750000,
    model = 'models/gmod_tower/baseballcap.mdl',
    offpos = Vector(0, 0, 4.9032258987427),
    offang = Angle(0, 11.612903594971, 0),
    scale = 1.05
}

rp.hats.Add{
    name = 'Бэтмэн',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/gmod_tower/batmanmask.mdl',
    offpos = Vector(2.2903225421906, 0, 3.0967741012573),
    scale = 1.05
}

rp.hats.Add{
    name = 'Шлем',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/gmod_tower/bombermanhelmet.mdl',
    offpos = Vector(1.2903225421906, 0, 3.0967741012573),
    scale = 1.05
}

rp.hats.Add{
    name = 'Федора',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_HATS,
    price = 750000,
    model = 'models/gmod_tower/fedorahat.mdl',
    offpos = Vector(0.25806450843811, 0, 6.1935482025146),
    scale = 1.05
}

rp.hats.Add{
    name = 'Хедкраб',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_HATS,
    price = 750000,
    model = 'models/gmod_tower/headcrabhat.mdl',
    offpos = Vector(0.25806450843811, 0, 6.1935482025146),
    scale = 1.05
}

rp.hats.Add{
    name = 'Наушники',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_HATS,
    price = 750000,
    model = 'models/gmod_tower/headphones.mdl',
    offpos = Vector(0.25806450843811, 0, 3.6129031181335)
}

rp.hats.Add{
    name = 'Ведро KFC',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_HATS,
    price = 750000,
    model = 'models/gmod_tower/kfcbucket.mdl',
    offpos = Vector(0.25806450843811, 0, -1.5483870506287)
}

rp.hats.Add{
    name = 'Рубин',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_HATS,
    price = 750000,
    model = 'models/gmod_tower/king_boos_crown.mdl',
    offpos = Vector(1.8064515590668, 0, 6.4516129493713),
    offang = Angle(0, 18.116128921509, 0)
}

rp.hats.Add{
    name = 'Пластик',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/gmod_tower/legohead.mdl',
    offpos = Vector(0, 0, 2.5)
}

rp.hats.Add{
    name = 'Эльф',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_HATS,
    price = 750000,
    model = 'models/gmod_tower/linkhat.mdl',
    offpos = Vector(0, 0, 2.5)
}

rp.hats.Add{
    name = 'Языческая Маска',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/gmod_tower/majorasmask.mdl',
    offpos = Vector(2.5806450843811, 0, 2.5),
}

rp.hats.Add{
    name = 'Рейнджер',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/gmod_tower/metaknight_mask.mdl',
    offpos = Vector(4.9032258987427, 0, -2.0645160675049),
    scale = 1.2
}

rp.hats.Add{
    name = 'Безликий',
    category = 'Новые Аксессуары',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/gmod_tower/noface.mdl',
    offpos = Vector(4.9032258987427, 0, 2.322580575943),
    scale = 1.2
}

rp.hats.Add{
    name = 'Маска теней',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask6.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Маска света',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask6.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Маска костей',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask6.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Маска природы',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask6.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Неизвестный обезьянавт',
    category = 'Halloween',
    type = APPAREL_PETS,
    price = 70000000,
    model = 'models/player/items/all_class/hwn_ghost_pj.mdl',
    skin = 1,
    offpos = Vector(0, 8, 0),
    offang = Angle(0, -18.116128921509, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{

    name = 'Призрак в капюшоне',

    category = 'Halloween',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/all_class/sf14_hooded_haunter_classes/sf14_hooded_haunter_classes_heavy.mdl',

    skin = 1,

    offpos = Vector(0, 0, 0),

    offpos = Vector(0, 16.25806427002, 10.838709831238),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Проклятое видение',

    category = 'Halloween',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/all_class/hw2013_wandering_soul/hw2013_wandering_soul_heavy.mdl',

    skin = 1,

    offpos = Vector(4.3870968818665, -21.677419662476, -16.25806427002),

    offang = Angle(-32.051612854004, 69.212905883789, -57.135482788086),

    scale = 1,

    infooffset = 10

}

rp.hats.Add{
    name = 'Космический хомяк',
    category = 'Не так одиноко',
    type = APPAREL_PETS,
    price = 70000000,
    model = 'models/workshop/player/items/pyro/invasion_space_hamster_hammy/invasion_space_hamster_hammy.mdl',
    skin = 0,
    offpos = Vector(20.387096405029, 21.161291122437, -34.580646514893),
    scale = 1,
    ooffset = 10
}

rp.hats.Add{
    name = 'REPO',
    category = 'SUPREME',
    type = APPAREL_PETS,
    price = 100000000,
    model = 'models/eclipse_custom/cebula/debil_pizdit.mdl',
    skin = 0,
    offpos = Vector(-17.032258987427, -9.8064517974854, 0.51612901687622),
    offang = Angle(0, 0, 90),
    scale = 1,
    ooffset = 10
}

rp.hats.Add{

    name = 'Гуано',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/all_class/hw2013_the_fire_bat_v2/hw2013_the_fire_bat_v2_heavy.mdl',

    skin = 0,

    offpos = Vector(20.387096405029, 32.25806427002, -72.25806427002),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Иван Несъедобный',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/heavy/hw2013_ivan_the_inedible/hw2013_ivan_the_inedible.mdl',

    skin = 0,

    offpos = Vector(4.1290321350098, 19.87096786499, 39.225807189941),

    offang = Angle(0, -72, 0),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Воздушный шар',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/player/items/all_class/pet_balloonicorn.mdl',

    skin = 0,

    offpos = Vector(9.0322580337524, -22.193548202515, 35.612903594971),

    offang = Angle(0, -18.116128921509, 0.46451613306999),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Бандит де Бонкарс',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/spy/spycrab/spycrab.mdl',

    skin = 1,

    offpos = Vector(17.806451797485, 16.25806427002, -75.096771240234),

    offang = Angle(0, 0, -67.819351196289),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Цитата',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/all_class/hw2013_the_caws_of_death/hw2013_the_caws_of_death_heavy.mdl',

    skin = 0,

    offpos = Vector(20.387096405029, 32.25806427002, -72.25806427002),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Настоящий пингвин',
    category = 'Не так одиноко',
    type = APPAREL_PETS,
    price = 250000000,
    model = 'models/workshop/player/items/all_class/dec19_pebbles_the_penguin/dec19_pebbles_the_penguin_heavy.mdl',
    skin = 0,
    offpos = Vector(4.3870968818665, -0.51612901687622, -78.967742919922),
    scale = 1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Святой Охотник',
    category = 'Halloween',
    type = APPAREL_HATS,
    price = 1000000,
    model = 'models/player/items/sniper/hwn_sniper_hat.mdl',
    skin = 1,
    offpos = Vector(0, 0, 0),
    offpos = Vector(4.1290321350098, -0.25806450843811, -75.870964050293),
    scale = 1.0,
    infooffset = 10,
    offsets = {
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(5, -0.25806450843811, -75)
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(5.6774191856384, -0.25806450843811, -83.612899780273),
            offang = Angle(0, 0, 16.25806427002),
            scale = 1.1
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(4.1290321350098, -0.25806450843811, -73.5)
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(4.5999999046326, -0.25806450843811, -73.5)
        }
    }
}

rp.hats.Add{
    name = 'Коллекционная Забытый король',
    category = 'Halloween',
    type = APPAREL_MASKS,
    price = 25000000,
    model = 'models/workshop/player/items/demo/sf14_deadking_head/sf14_deadking_head.mdl',
    skin = 1,
    offpos = Vector(0, -0.050000000745058, -89.290321350098),
    offang = Angle(3.2516129016876, 5.1096773147583, 0),
    scale = 1.1961290322581,
    infooffset = 10,
    unvisible = true
}

rp.hats.Add{
    name = 'Капюшон заклинателя',
    category = 'Halloween',
    type = APPAREL_HATS,
    price = 1000000,
    model = 'models/workshop/player/items/soldier/hw2013_the_crit_wizard/hw2013_the_crit_wizard.mdl',
    skin = 1,
    offpos = Vector(0.51612901687622, 0, -87.74193572998),
    offang = Angle(-0.46451613306999, 0, 0),
    scale = 1.1754838709677,
    infooffset = 10
}

rp.hats.Add{
    name = 'Тыквоголовый',
    category = 'Halloween',
    type = APPAREL_MASKS,
    price = 25000000,
    model = 'models/player/items/all_class/pumpkin_hat_heavy.mdl',
    skin = 1,
    offpos = Vector(2.5806450843811, 0, -80),
    scale = 1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Крылатый человек',
    category = 'Кулдык-кулдык',
    type = APPAREL_HATS,
    price = 2000000,
    model = 'models/workshop/player/items/scout/hwn2016_wing_mann/hwn2016_wing_mann.mdl',
    skin = 1,
    offpos = Vector(74.322578430176, 0, 1.2903225421906),
    offang = Angle(-1, -90, 0),
    scale = 1.025
}

rp.hats.Add{
    name = 'Робот-цыпленок',
    category = 'Кулдык-кулдык',
    type = APPAREL_HATS,
    price = 2000000,
    model = 'models/workshop_partner/player/items/all_class/as_robot_chicken/as_robot_chicken_heavy.mdl',
    skin = 1,
    offpos = Vector(-1.5483870506287, 0.51612901687622, -0.77419352531433),
    scale = 1.25
}

rp.hats.Add{
    name = 'Clicken bell',
    category = 'Кулдык-кулдык',
    type = APPAREL_MASKS,
    slot = b,
    price = 4000000,
    model = 'models/workshop/player/items/scout/sf14_nugget_noggin/sf14_nugget_noggin.mdl',
    skin = 1,
    offpos = Vector(92.903228759766, 0, 3.3548386096954),
    offang = Angle(0, -76.645164489746, 0),
    scale = 1.275
}

rp.hats.Add{
    name = 'Некоглай',
    category = 'Кулдык-кулдык',
    type = APPAREL_HATS,
    price = 2000000,
    model = 'models/workshop/player/items/all_class/hw2013_tricky_chicken/hw2013_tricky_chicken_heavy.mdl',
    skin = 1,
    offpos = Vector(78.967742919922, 0, 3.3548386096954),
    offang = Angle(0, -77.109680175781, 0),
    offsets = {
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(75.870964050293, 0.51612901687622, 3.3548386096954),
            offang = Angle(1.3935483694077, -77.109680175781, 0),
        },
    },
    scale = 1
}

if CLIENT then
    local function f(g, h, i, j)
        if j < 900 then
            j = j * (1 - j / 900)
        else
            j = j * (1 - j / 4096)
        end

        j = math.Clamp(j, 5, 1000)
        local k = Angle(25, 220, 0)
        local l = h + k:Forward() * j * -15
        local m = {}
        m.fov = 4 + j * 0.04
        m.origin = l + i
        m.znear = 1
        m.zfar = l:Distance(h) + j * 2
        m.angles = k

        return m
    end

    local function n(o, p, q, r)
        p.z = 15

        return f(o, p, q, r * 0.125)
    end

    local function s(o, p, q, r)
        p.z = 0

        return f(o, p, q, r * 0.125)
    end

    SpawniconGenFunctions['models/workshop/player/items/heavy/hw2013_heavy_robin/hw2013_heavy_robin.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/medic/hw2013_medicmedes/hw2013_medicmedes.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/demo/inquisitor/inquisitor.mdl'] = s
    SpawniconGenFunctions['models/workshop/player/items/all_class/dec15_a_well_wrapped_hat/dec15_a_well_wrapped_hat_scout.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/all_class/ai_spacehelmet/ai_spacehelmet_scout.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/pyro/hwn2015_face_of_mercy/hwn2015_face_of_mercy.mdl'] = n
    SpawniconGenFunctions['models/player/items/all_class/xcom_flattop_scout.mdl'] = s
    SpawniconGenFunctions['models/player/items/spy/fez.mdl'] = s
    SpawniconGenFunctions['models/workshop/player/items/spy/short2014_deadhead/short2014_deadhead.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/sniper/thief_sniper_hood/thief_sniper_hood.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/pyro/fall2013_popeyes/fall2013_popeyes.mdl'] = s
    SpawniconGenFunctions['models/player/items/pyro/fireman_helmet.mdl'] = s
    SpawniconGenFunctions['models/player/items/all_class/xms_furcap_scout.mdl'] = s
    SpawniconGenFunctions['models/workshop/player/items/all_class/short2014_tip_of_the_hats/short2014_tip_of_the_hats_scout.mdl'] = s
    SpawniconGenFunctions['models/workshop/player/items/all_class/sbox2014_law/sbox2014_law_scout.mdl'] = s
    SpawniconGenFunctions['models/player/items/pyro/pyro_hat.mdl'] = s

    SpawniconGenFunctions['models/workshop/player/items/heavy/jul13_bear_necessitys/jul13_bear_necessitys.mdl'] = function(o, p, q, r)
        p.z = 40
        p.y = -12

        return f(o, p, q, r * 0.25)
    end

    SpawniconGenFunctions['models/modified/hat08.mdl'] = function(o, p, q, r)
        p.z = -35

        return f(o, p, q, r * 0.15)
    end

    SpawniconGenFunctions['models/sal/acc/fix/scarf01.mdl'] = function(o, p, q, r)
        p.z = -19

        return f(o, p, q, r * 0.25)
    end

    SpawniconGenFunctions['models/modified/bandana.mdl'] = function(o, p, q, r)
        p.z = -31

        return f(o, p, q, r * 0.15)
    end

    SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl'] = function(o, p, q, r)
        p.z = -34

        return f(o, p, q, r * 0.16)
    end

    SpawniconGenFunctions['models/sal/acc/fix/mask_2.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/modified/mask5.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/modified/mask6.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/pig.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/acc/fix/beerhat.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/modified/hat03.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/gingerbread.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/hat01_fix.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/penguin.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']

    --SpawniconGenFunctions['models/team vr/characters/fnaf1/accuracy/chicahead.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/hawk_1.mdl'] = function(o, p, q, r)
        p.z = -13

        return f(o, p, q, r * 0.36)
    end

    SpawniconGenFunctions['models/sal/hawk_2.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/owl.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/wolf.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/fox.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/cat.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/bear.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']

    SpawniconGenFunctions['models/modified/glasses01.mdl'] = function(o, p, q, r)
        p.x = 1
        p.z = -37

        return f(o, p, q, r * 0.11)
    end
end