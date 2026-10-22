DarkRP.createCategory{
	name = "Cuisine",
	categorises = "entities",
	startExpanded = true,
	color = Color(111, 150, 97, 255),
	canSee = function(ply) return true end,
	sortOrder = 103
}

/*
DarkRP.createEntity("Livre de cuisine", {
	ent = "zmc_cookbook",
	model = "models/zerochain/props_kitchen/zmc_cookbook.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_cookbook",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})



DarkRP.createEntity("Frigo", {
	ent = "zmc_fridge",
	model = "models/zerochain/props_kitchen/zmc_fridge.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_fridge",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Poubelle", {
	ent = "zmc_garbagepin",
	model = "models/zerochain/props_kitchen/zmc_garbagebin.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_garbagepin",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Mixer", {
	ent = "zmc_mixer",
	model = "models/zerochain/props_kitchen/zmc_mixer.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_mixer",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Plan de travail", {
	ent = "zmc_worktable",
	model = "models/zerochain/props_kitchen/zmc_worktable.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_worktable",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})


DarkRP.createEntity("Marmite", {
	ent = "zmc_boilpot",
	model = "models/zerochain/props_kitchen/zmc_boilpot.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_boilpot",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Grill", {
	ent = "zmc_grill",
	model = "models/zerochain/props_kitchen/zmc_heater.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_grill",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Four", {
	ent = "zmc_oven",
	model = "models/zerochain/props_kitchen/zmc_heater.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_oven",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Pot a soupe", {
	ent = "zmc_souppot",
	model = "models/zerochain/props_kitchen/zmc_souppot.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_souppot",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Poele", {
	ent = "zmc_wok",
	model = "models/zerochain/props_kitchen/zmc_wok.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_wok",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})



DarkRP.createEntity("Evier", {
	ent = "zmc_dishtable",
	model = "models/zerochain/props_kitchen/zmc_dishtable.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_dishtable",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Table de commandes", {
	ent = "zmc_ordertable",
	model = "models/zerochain/props_kitchen/zmc_ordertable.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_ordertable",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Table client", {
	ent = "zmc_customertable",
	model = "models/zerochain/props_kitchen/zmc_table.mdl",
	price = 500,
	max = 2,
	cmd = "buyzmc_customertable",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})

DarkRP.createEntity("Wash Table", {
	ent = "zmc_washtable",
	model = "models/zerochain/props_kitchen/zmc_washtable.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_washtable",
	allowTools = true,
	allowed = TEAM_ZMC_COOK,
	category = "Cuisine"
})
*/
-- 

//Vanilla
TEAM_SECURITY_ENGINEER = DarkRP.createJob("PDG Sécurité a domicile", {
    color = Color(180, 60, 50, 255),
    model = {"models/smalls_civilians/pack2/male/hoodie_sweatpants/male_01_hoodiesweatpants_pm.mdl",
"models/smalls_civilians/pack2/male/hoodie_sweatpants/male_02_hoodiesweatpants_pm.mdl",
"models/smalls_civilians/pack2/male/hoodie_sweatpants/male_03_hoodiesweatpants_pm.mdl",
"models/smalls_civilians/pack2/male/hoodie_sweatpants/male_04_hoodiesweatpants_pm.mdl",
"models/smalls_civilians/pack2/male/hoodie_sweatpants/male_05_hoodiesweatpants_pm.mdl",
"models/smalls_civilians/pack2/male/hoodie_sweatpants/male_06_hoodiesweatpants_pm.mdl",
"models/smalls_civilians/pack2/male/hoodie_sweatpants/male_07_hoodiesweatpants_pm.mdl",
"models/smalls_civilians/pack2/male/hoodie_sweatpants/male_08_hoodiesweatpants_pm.mdl",
"models/smalls_civilians/pack2/male/hoodie_sweatpants/male_09_hoodiesweatpants_pm.mdl",
"models/smalls_civilians/pack2/female/hoodiezippedsweats/female_01_hoodiezippedsweats_pm.mdl",
"models/smalls_civilians/pack2/female/hoodiezippedsweats/female_02_hoodiezippedsweats_pm.mdl",
"models/smalls_civilians/pack2/female/hoodiezippedsweats/female_03_hoodiezippedsweats_pm.mdl",
"models/smalls_civilians/pack2/female/hoodiezippedsweats/female_04_hoodiezippedsweats_pm.mdl",
"models/smalls_civilians/pack2/female/hoodiezippedsweats/female_06_hoodiezippedsweats_pm.mdl",
"models/smalls_civilians/pack2/female/hoodiezippedsweats/female_07_hoodiezippedsweats_pm.mdl"},
    description = "Vous êtes vendeur d'alarmes de sécurité vous travaillez avec les agents",  
    weapons = {},
    command = "homesecurityceo",
    max = 2,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Métiers exclusifs",
    sortOrder = 1,
})

TEAM_HOME_SECURITY_AGENT = DarkRP.createJob("Agent de sécurité a domicile", {
    color = Color(210, 60, 50, 255),
    model = {"models/player/guard_pack/guard_01.mdl",
        	 "models/player/guard_pack/guard_02.mdl",
        	 "models/player/guard_pack/guard_03.mdl",
        	 "models/player/guard_pack/guard_04.mdl",
        	 "models/player/guard_pack/guard_05.mdl",
        	 "models/player/guard_pack/guard_06.mdl",
        	 "models/player/guard_pack/guard_07.mdl",
        	 "models/player/guard_pack/guard_08.mdl",
        	 "models/player/guard_pack/guard_09.mdl"},
	description = "Vous êtes agent de sécurité sur les installations de maison, vous vous occuper de la bienvaillance de la sécurité",
    weapons = {},
    command = "homesecurityagent",
    max =  4,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Métiers exclusifs",
    sortOrder = 2,
})


local ASSeller=TEAM_SECURITY_ENGINEER //Alarm system seller

DarkRP.createCategory{
	name = "Système de sécurité", -- The name of the category.
	categorises = "entities", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
	startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
	color = Color(210, 60, 50, 255), -- The color of the category header.
	canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
	sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
} 

DarkRP.createEntity("Ordinateur de gestion", {
	ent = "alarm_computer_white",
	model = "models/props/cs_office/computer.mdl",
	price = 2200,
	max = 5,
	cmd = "buycomputerw",
	allowed = ASSeller,
	category = "Système de sécurité",  
	sortOrder = 90,
})

DarkRP.createEntity("Terminal - Client", {
	ent = "alarm_terminal",
	model = "models/alarm_system/terminal.mdl",
	price = 1500,
	max = 400,
	cmd = "buyterminal",
	allowed = ASSeller,
	category = "Système de sécurité", 
	sortOrder = 90,
})

DarkRP.createEntity("Sirène - Client", {
	ent = "alarm_siren",
	model = "models/alarm_system/siren.mdl",
	price = 1000,
	max = 400,
	cmd = "buysiren",
	allowed = ASSeller,
	category = "Système de sécurité", 
	sortOrder = 90,
})

DarkRP.createEntity("Détecteur de porte receveur - Client", {
	ent = "alarm_door_sensor",
	model = "models/alarm_system/door_sensor_1.mdl",
	price = 400,
	max = 400,
	cmd = "buysensordr",
	allowed = ASSeller,
	category = "Système de sécurité", 
	sortOrder = 90,
})

DarkRP.createEntity("Détecteur de porte éméteur - Client", {
	ent = "alarm_door_sensor_2",
	model = "models/alarm_system/door_sensor_2.mdl",
	price = 400,
	max = 2,
	cmd = "buysensorde",
	allowed = ASSeller,
	category = "Système de sécurité", 
	sortOrder = 90,
})

DarkRP.createEntity("Laser receveur - Client", {
	ent = "alarm_laser_rec",
	model = "models/alarm_system/laser_alarm.mdl",
	price = 400,
	max = 400,
	cmd = "buysensorlr",
	allowed = ASSeller,
	category = "Système de sécurité", 
	sortOrder = 90,
})

DarkRP.createEntity("Laser - Client", {
	ent = "alarm_laser_2",
	model = "models/alarm_system/laser_alarm.mdl",
	price = 400,
	max = 400,
	cmd = "buysensorle",
	allowed = ASSeller,
	category = "Système de sécurité", 
	sortOrder = 90,
})

DarkRP.createEntity("Détecteur de mouvement - Client", {
	ent = "alarm_motion_sensor",
	model = "models/alarm_system/bewegungsmelder.mdl",
	price = 800,
	max = 400,
	cmd = "buysensorm",
	allowed = ASSeller,
	category = "Système de sécurité", 
	sortOrder = 90,
})

DarkRP.createEntity("Détecteur de fumée - Client", {
	ent = "alarm_fire_sensor",
	model = "models/alarm_system/fire_detector.mdl",
	price = 800,
	max = 400,
	cmd = "buysensorf",
	allowed = ASSeller,
	category = "Système de sécurité", 
	sortOrder = 90,
})

//Enchanced rp module
DarkRP.createEntity("Serveur", {
	ent = "alarm_server",
	model = "models/props_lab/servers.mdl",
	price = 3000,
	max = 2,
	cmd = "buyserver",
	allowed = ASSeller,
	category = "Système de sécurité", 
	sortOrder = 90,
})



local ASSeller=TEAM_SECURITY_ENGINEER //Alarm system seller

DarkRP.createCategory{
	name = "Security system tools", -- The name of the category.
	categorises = "weapons", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
	startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
	color = Color(210, 60, 50, 255), -- The color of the category header.
	canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
	sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
} 

DarkRP.createShipment("Alarm Remote", {                 -- Name of the shipment
    model = "models/alarm_system/remote.mdl",    -- The model that the shipment spawns (should be the world model...)
    entity = "alarm_remote",                    -- The class name of the weapon. Usually something of the form weapon_something.
    price = 1500,                               -- The price of one shipment
    amount = 1,                                -- How many guns there are in one shipment
    separate = true,                            -- Whether the item in this shipment is also sold separately
    pricesep = 160,                             -- OPTIONAL: The price of a single weapon when sold separately
    noship = true,                             -- OPTIONAL: True/false, whether this weapon is sold in a shipment
    allowed = ASSeller,                       -- OPTIONAL: List of jobs who can buy the shipment
    category = "Security system tools",                        -- OPTIONAL: The category the shipment should be in, in the F4 menu
})

//hacking module
local ASblackmarket=TEAM_BLK //Alarm system hacking seller
DarkRP.createShipment("Hacking device", {                 -- Name of the shipment
    model = "models/alarm_system/hacking_device_w.mdl",    -- The model that the shipment spawns (should be the world model...)
    entity = "hacking_device",                    -- The class name of the weapon. Usually something of the form weapon_something.
    price = 3000,                               -- The price of one shipment
    amount = 1,                                -- How many guns there are in one shipment
    separate = true,                           -- Whether the item in this shipment is also sold separately
    pricesep = 500,                             -- OPTIONAL: The price of a single weapon when sold separately
    noship = true,                             -- OPTIONAL: True/false, whether this weapon is sold in a shipment
    allowed = ASblackmarket,                       -- OPTIONAL: List of jobs who can buy the shipment
    category = "Security system tools",                        -- OPTIONAL: The category the shipment should be in, in the F4 menu
})

