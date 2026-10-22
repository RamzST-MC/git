if SERVER then

    AddCSLuaFile("blues_pharm_translation.lua")

end



include("blues_pharm_translation.lua")



BLUES_PHARMA = BLUES_PHARMA or {}







--A list of all chemical types. An entity can set ChemicalID on it to be considered a chemical

BLUES_PHARMA.Chemicals = {

    [1] = {name = "Кето кислота", color = Color(220,20,60)},

    [2] = {name = "Салициловая кислота", color = Color(95,158,160)},

    [3] = {name = "Пропионовая кислота", color = Color(154,205,50)},

    [4] = {name = "Уксусный ангидрид", color = Color(46,139,87)},

    [5] = {name = "Диоксид селена", color = Color(218,165,32)},

    [6] = {name = "2-Нафтол", color = Color(30,144,255)},

    [7] = {name = "Метилтестостерон", color = Color(173,255,47)},

    [8] = {name = "Ацетон", color = Color(210,105,30)},

    [9] = {name = "Прогестерон", color = Color(255,99,71)},

    [10] = {name = "Деионизированная вода", color = Color(135,206,235)},

    [11] = {name = BLUES_PHARMA.TRANS.BurnedChemicals, color = Color(20,20,20)},

    [12] = {name = "Юуль" , abrv = "Высший" , color = Color(238,232,170)}

} 



BLUES_PHARMA.Medicines = {

    [1] = {

        name = "Аспирин", 

        cookTime = 60, -- Number of seconds it takes to finish cooking

        freezeTime = 60 * 2, --Number of seconds it takes to freeze

        mixIncrement = 5, --The amount to add to the mix value (between 0-100) each mix tick

        overdoseRate = 10, --This is how much it adds to the "overdose" var which has a max of 1 and decreases over time

        pillCount = 5, --This is how many uses a single bottle has

        recipe = {

            [2] = 150, --150ML Salicylic acid

            [4] = 300, --300ml of Acetic anhydride

            [10] = 50 --Water

        },

        onConsumed = function(self, user) --Called when someone eats/takes this medicine. 

            user:BPAddDamageResistance(15, 60)

        end

    },

    [2] = {

        name = "Ибупрофен", 

        cookTime = 90, -- Number of seconds it takes to finish cooking

        freezeTime = 60 * 2.5, --Number of seconds it takes to freeze

        mixIncrement = 6, --The amount to add to the mix value (between 0-100) each mix tick

        overdoseRate = 20, --This is how much it adds to the "overdoes" var which has a max of 1 and decreases over time

        pillCount = 4, --This is how many uses a single bottle has

        recipe = {

            [3] = 150,

            [4] = 300, 

            [10] = 50

        },

        onConsumed = function(self, user) --Called when someone eats/takes this medicine. 

            user:BPAddDamageResistance(40, 40)

        end

    },

    [3] = {

        name = "Напроксен", 

        cookTime = 75, -- Number of seconds it takes to finish cooking

        freezeTime = 60 * 3, --Number of seconds it takes to freeze

        mixIncrement = 7, --The amount to add to the mix value (between 0-100) each mix tick

        overdoseRate = 35, --This is how much it adds to the "overdoes" var which has a max of 1 and decreases over time

        pillCount = 4, --This is how many uses a single bottle has

        recipe = {

            [6] = 250,

            [4] = 150, 

            [10] = 100

        },

        onConsumed = function(self, user) --Called when someone eats/takes this medicine. 

            user:BPAddPassiveHealth(10, 4, 40)

        end

    },

    [4] = {

        name = "Стероиды", 

        cookTime = 60 * 2, -- Number of seconds it takes to finish cooking

        freezeTime = 60 * 3, --Number of seconds it takes to freeze

        mixIncrement = 12, --The amount to add to the mix value (between 0-100) each mix tick

        overdoseRate = 35, --This is how much it adds to the "overdoes" var which has a max of 1 and decreases over time

        pillCount = 5, --This is how many uses a single bottle has

        recipe = {

            [7] = 100,

            [5] = 300, 

            [10] = 100

        },

        onConsumed = function(self, user) --Called when someone eats/takes this medicine. 

            user:BPAddDamageBuff(20, 20)

        end

    },

    [5] = {

        name = "Витамины", 

        cookTime = 120, -- Number of seconds it takes to finish cooking

        freezeTime = 60 * 4, --Number of seconds it takes to freeze

        mixIncrement = 3, --The amount to add to the mix value (between 0-100) each mix tick

        overdoseRate = 10, --This is how much it adds to the "overdoes" var which has a max of 1 and decreases over time

        pillCount = 10, --This is how many uses a single bottle has

        recipe = {

            [1] = 150,

            [8] = 200, 

            [10] = 150

        },

        onConsumed = function(self, user) --Called when someone eats/takes this medicine. 

            user:BPAddDamageBuff(10, 60)

            user:BPAddDamageResistance(10, 60)

            user:BPAddPassiveHealth(4, 4, 20)

            user:BPAddSpeedJumpBoost(10, 60)



        end

    },

    [6] = {

        name = "Кортикостероид", 

        cookTime = 60 * 3, -- Number of seconds it takes to finish cooking

        freezeTime = 60 * 4, --Number of seconds it takes to freeze

        mixIncrement = 4, --The amount to add to the mix value (between 0-100) each mix tick

        overdoseRate = 44, --This is how much it adds to the "overdoes" var which has a max of 1 and decreases over time

        pillCount = 4, --This is how many uses a single bottle has

        recipe = {

            [4] = 200,

            [9] = 200, 

            [10] = 100

        },

        onConsumed = function(self, user) --Called when someone eats/takes this medicine. 

            user:BPDoubleRemainingTime()

        end

    },

    [7] = {

        name = "Дианабол", 

        cookTime = 60 * 2, -- Number of seconds it takes to finish cooking

        freezeTime = 60 * 3, --Number of seconds it takes to freeze

        mixIncrement = 6, --The amount to add to the mix value (between 0-100) each mix tick

        overdoseRate = 10, --This is how much it adds to the "overdoes" var which has a max of 1 and decreases over time

        pillCount = 10, --This is how many uses a single bottle has

        recipe = {

            [7] = 200,

            [1] = 150, 

            [10] = 150

        },

        onConsumed = function(self, user) --Called when someone eats/takes this medicine. 

            user:BPAddSpeedJumpBoost(30, 120)

        end

    },

    [8] = {

        name = "Анадрол", 

        cookTime = 60 * 2, -- Number of seconds it takes to finish cooking

        freezeTime = 60 * 4, --Number of seconds it takes to freeze

        mixIncrement = 6, --The amount to add to the mix value (between 0-100) each mix tick

        overdoseRate = 70, --This is how much it adds to the "overdoes" var which has a max of 1 and decreases over time

        pillCount = 2, --This is how many uses a single bottle has

        recipe = {

            [7] = 300,

            [9] = 100, 

            [10] = 100

        },

        onConsumed = function(self, user) --Called when someone eats/takes this medicine. 

            user:BPAddDamageBuff(50, 40)

        end

    }

}

  

BLUES_PHARMA.Pages = {

    [1] = {

        type = "header",

        title = [[Книга рецептов]],

        contents = BLUES_PHARMA.TRANS.BOOK.MiniTutorial1,

        contentsRight = BLUES_PHARMA.TRANS.BOOK.MiniTutorial2..[[





]]

    },

    --healers 

    [2] = {

       type = "recipe",

       recipeID = 1, 

       desc = [[Аспирин, также известный как ацетилсалициловая кислота, является лекарством, используемым для лечения боли, лихорадки или воспаления. Конкретные воспалительные состояния, для лечения которых используют аспирин, включают болезнь Кавасаки, перикардит и ревматизм. Аспирин, назначаемый вскоре после сердечного приступа, снижает риск смерти.]],

       effects = [[Предоставляет пользователю небольшое (15%) увеличение сопротивления урону в течение 1 минуты. Эффекты этого лекарства не складываются, и попытки сделать это рискуют передозировкой.]],

    },

    [3] = {

       type = "recipe",

       recipeID = 2, 

       desc = [[Ибупрофен - это лекарство из класса нестероидных противовоспалительных препаратов, которое используется для лечения боли, лихорадки и воспаления. Это включает болезненные менструальные периоды, мигрени и ревматоидный артрит. Он также может быть использован для закрытия открытого артериального протока у недоношенного ребенка.]],

       effects = [[Дает пользователю умеренное (40%) увеличение сопротивления урону в течение 40 секунд. Эффекты этого лекарства не складываются, и попытки сделать это рискуют передозировкой.]],

    },

    [4] = {

       type = "recipe",

       recipeID = 3, 

       desc = [[Напроксен, продаваемый под другими торговыми марками Aleve и Naprosyn, является нестероидным противовоспалительным препаратом, используемым для лечения боли, менструальных спазмов, воспалительных заболеваний, таких как ревматоидный артрит и лихорадка. Это взято ртом. Это доступно в формулировках немедленного и отсроченного выпуска.]],

       effects = [[Мягко лечит пользователя (+10 л.с. каждые 4 секунды) в течение 80 секунд, в результате чего исцеляется 100 л.с. Эффекты этого лекарства не складываются, и попытки сделать это рискуют передозировкой.]],

    },



    --Buffs

    [5] = {

       type = "recipe",

       recipeID = 4, 

       desc = [[Стероид представляет собой биологически активное органическое соединение с четырьмя кольцами, расположенными в определенной молекулярной конфигурации. Стероиды выполняют две основные биологические функции: как важные компоненты клеточных мембран, которые изменяют текучесть мембран; и как сигнальные молекулы.]],

       effects = [[Дает пользователю легкий (20%) бафф к урону в течение минуты. Эффекты этого лекарства не складываются, и попытки сделать это рискуют передозировкой.]],

    },

    [6] = {

       type = "recipe",

       recipeID = 5, 

       desc = [[Витамин - это органическая молекула, который необходим организму в небольших количествах для правильного функционирования его метаболизма. Основные питательные вещества не могут быть синтезированы в организме, или вообще, или не в достаточных количествах, и, следовательно, должны быть получены с помощью диеты.]],

       effects = [[Дает пользователю мягкое лечение (4 л.с. за 4 секунды) в течение 20 секунд и небольшое увеличение (10%) для таких вещей, как: скорость передвижения, высота прыжка, сопротивление урону и урону в течение приблизительно минуты. Эффекты этого лекарства не складываются, и попытки сделать это рискуют передозировкой.]],

    },

    [7] = {

       type = "recipe",

       recipeID = 6, 

       desc = [[Кортикостероиды - это искусственные препараты, которые очень похожи на кортизол, гормон, который вырабатывают ваши надпочечники естественным путем. Кортикостероиды часто называют сокращенным термином «стероиды». Кортикостероиды отличаются от стероидных соединений, связанных с мужскими гормонами, которыми злоупотребляют некоторые спортсмены.]],

       effects = [[Увеличивает продолжительность активных в настоящее время эффектов исцеления и сопротивления урону в два раза больше оставшегося времени. Эффекты этого лекарства не складываются, и попытки сделать это рискуют передозировкой.]],

    },

    [8] = {

        type = "recipe",

        recipeID = 7,

        desc = [[Метандиенон, также известный как метандиенон или метандростенолон и продаваемый под торговой маркой Dianabol, является препаратом андрогенов и анаболических стероидов, который в основном больше не используется. Он также используется немедицински в целях повышения физической формы и работоспособности. Это взято ртом.]],

        effects = [[Предоставляет умеренное (30%) увеличение скорости движения и высоты прыжка для пользователей примерно на 2 минуты. Эффекты этого лекарства не складываются, и попытки сделать это рискуют передозировкой.]],

    },

    [9] = {

        type = "recipe",

        recipeID = 8,

        desc = [[Оксиметолон, продаваемый под другими торговыми марками Anadrol и Anapolon, является препаратом андрогенов и анаболических стероидов, который используется главным образом для лечения анемии. Он также используется для лечения остеопороза, синдрома истощения ВИЧ / СПИДа, а также для стимулирования увеличения веса и роста мышц в определенных ситуациях.]],

        effects = [[Предоставляет большой (50%) бафф к урону в течение 40 секунд. Эффекты этого лекарства не складываются, и попытки сделать это рискуют передозировкой.]],

    }

}