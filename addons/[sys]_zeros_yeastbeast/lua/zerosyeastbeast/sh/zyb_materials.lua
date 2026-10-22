-- leak by lordee
AddCSLuaFile()
zyb = zyb or {}
zyb.default_materials = zyb.default_materials or {}

zyb.default_materials["circle"] = Material("materials/zerochain/zyb/ui/zyb_circle.png", "smooth")
zyb.default_materials["glamcircle"] = Material("materials/zerochain/zyb/ui/zyb_glam_circle.png", "smooth")
zyb.default_materials["shadowcircle"] = Material("materials/zerochain/zyb/ui/zyb_shadow_circle.png", "smooth")
zyb.default_materials["square"] = Material("materials/zerochain/zyb/ui/zyb_square.png", "smooth")
zyb.default_materials["heaterzone"] = Material("materials/zerochain/zyb/ui/zyb_heater_zones.png", "smooth")

zyb.default_materials["speedboost"] = Material("materials/zerochain/zyb/ui/zyb_upgrade_speedboost.png", "smooth")
zyb.default_materials["productionboost"] = Material("materials/zerochain/zyb/ui/zyb_upgrade_productionboost.png", "smooth")

zyb.default_materials["barfront01"] = Material("materials/zerochain/zyb/ui/zyb_barfront01.png", "smooth")
zyb.default_materials["barfront01fg"] = Material("materials/zerochain/zyb/ui/zyb_barfront01_fg.png", "smooth")
zyb.default_materials["barfront01bg"] = Material("materials/zerochain/zyb/ui/zyb_barfront01_bg.png", "smooth")

zyb.default_materials["barfront02"] = Material("materials/zerochain/zyb/ui/zyb_barfront02.png", "smooth")
zyb.default_materials["barfront02fg"] = Material("materials/zerochain/zyb/ui/zyb_barfront02_fg.png", "smooth")
zyb.default_materials["barfront02bg"] = Material("materials/zerochain/zyb/ui/zyb_barfront02_bg.png", "smooth")

zyb.default_materials["build"] = Material("materials/zerochain/zyb/ui/zyb_build.png", "smooth")
zyb.default_materials["cancel"] = Material("materials/zerochain/zyb/ui/zyb_cancel.png", "smooth")

zyb.default_materials["yeast"] = Material("materials/zerochain/zyb/ui/zyb_ingredient_yeast.png", "smooth")
zyb.default_materials["water"] = Material("materials/zerochain/zyb/ui/zyb_ingredient_water.png", "smooth")
zyb.default_materials["sugar"] = Material("materials/zerochain/zyb/ui/zyb_ingredient_sugar.png", "smooth")





zyb.default_colors = zyb.default_colors or {}

zyb.default_colors["grey_light"] = Color(55, 55, 55, 255)
zyb.default_colors["grey_lighter"] = Color(65, 65, 65, 255)

zyb.default_colors["black01"] = Color(0, 0, 0, 200)
zyb.default_colors["black02"] = Color(0, 0, 0, 25)
zyb.default_colors["black03"] = Color(0, 0, 0, 125)
zyb.default_colors["black04"] = Color(0, 0, 0, 255)
zyb.default_colors["black05"] = Color(0, 0, 0, 75)

zyb.default_colors["grey01"] = Color(55,55,55,255)
zyb.default_colors["grey02"] = Color(59,59,59,255)
zyb.default_colors["grey03"] = Color(25,25,25,255)
zyb.default_colors["grey04"] = Color(100,100,100,255)
zyb.default_colors["grey05"] = Color(200,200,200,255)
zyb.default_colors["grey06"] = Color(55,55,55,0)

zyb.default_colors["orange01"] = Color(213,116,73,255)
zyb.default_colors["orange02"] = Color(189, 72, 44,255)
zyb.default_colors["orange03"] = Color(255,126,88,255)
zyb.default_colors["orange04"] = Color(255, 189, 145)
zyb.default_colors["orange05"] = Color(213, 111, 80,255)

zyb.default_colors["brown01"] = Color(133, 93, 24, 255)
zyb.default_colors["brown02"] = Color(136, 87, 58, 255)
zyb.default_colors["brown03"] = Color(106, 66, 41, 255)
zyb.default_colors["brown04"] = Color(81, 46, 25, 255)
zyb.default_colors["brown05"] = Color(58, 31, 15, 255)
zyb.default_colors["brown06"] = Color(50, 27, 13, 255)
zyb.default_colors["brown07"] = Color(133,93,24,255)
zyb.default_colors["brown08"] = Color(199, 171, 122, 255)

zyb.default_colors["white01"] = Color(255, 255, 255, 255)
zyb.default_colors["white02"] = Color(255, 255, 255, 15)
zyb.default_colors["white03"] = Color(255,255,255,120)
zyb.default_colors["white04"] = Color(225, 225, 225, 255)
zyb.default_colors["white05"] = Color(255,255,255,5)

zyb.default_colors["red01"] = Color(255, 25, 25, 255)
zyb.default_colors["red02"] = Color(189, 44, 44, 255)
zyb.default_colors["red03"] = Color(209, 56, 56, 255)
zyb.default_colors["red04"] = Color(218, 59, 59, 255)
zyb.default_colors["red05"] = Color(255, 45, 45, 150)
zyb.default_colors["red06"] = Color(178, 65, 65,255)
zyb.default_colors["red07"] = Color(255, 0, 0, 230)

zyb.default_colors["pink01"] = Color(153, 130, 136, 125)
zyb.default_colors["pink02"] = Color(213, 181, 189, 255)

zyb.default_colors["blue01"] = Color(70, 111, 197, 255)
zyb.default_colors["blue02"] = Color(44, 116, 189, 255)
zyb.default_colors["blue03"] = Color(84, 100, 153, 125)
zyb.default_colors["blue04"] = Color(117, 140, 213, 255)
zyb.default_colors["blue05"] = Color(0,0,255,255)
zyb.default_colors["blue06"] = Color(70,90,142,255)

zyb.default_colors["green01"] = Color(79, 197, 70, 255)
zyb.default_colors["green02"] = Color(129, 205, 68, 255)
zyb.default_colors["green03"] = Color(131, 178, 65, 255)
zyb.default_colors["green04"] = Color(0, 255, 0, 230)

zyb.default_colors["yellow01"] = Color(233, 157, 58, 255)
zyb.default_colors["yellow02"] = Color(155, 138, 85, 125)
zyb.default_colors["yellow03"] = Color(213, 189, 117, 255)

zyb.default_colors["CloseButton_normal"] = Color(197, 40, 40,255)
zyb.default_colors["CloseButton_hover"] = Color(255, 102, 102,255)

zyb.default_colors["BuyButton_normal"] = Color(97, 222, 88,255)
zyb.default_colors["BuyButton_hover"] = Color(40, 197, 40,255)

zyb.default_colors["SellButton_normal"] = Color(197, 40, 40,255)
zyb.default_colors["SellButton_hover"] = Color(255, 102, 102,255)


zyb.default_colors["yeast"] = Color(249, 240, 128, 255)
zyb.default_colors["sugar"] = Color(255, 255, 255, 255)
zyb.default_colors["water"] = Color(57, 149, 214, 255)
-- leak by lordee