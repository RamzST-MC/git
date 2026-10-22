-- leak by lordee
zyb = zyb or {}
zyb.f = zyb.f or {}

zyb.Sounds = {
	["clean"] = {
		Sound("ambient/water/water_splash1.wav"),
		Sound("ambient/water/water_splash2.wav"),
		Sound("ambient/water/water_splash3.wav"),
	},
    ["jar_broke"] = {
        Sound("physics/glass/glass_bottle_break1.wav"),
        Sound("physics/glass/glass_bottle_break2.wav"),
    },
    ["crate_broke"] = {
        Sound("physics/wood/wood_box_break1.wav"),
        Sound("physics/wood/wood_box_break2.wav"),
    },
	["zyb_cash"] = Sound("zyb/zyb_cash01.wav"),
}

sound.Add({
	name = "zyb_ui_click",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"UI/buttonclick.wav"}
})


sound.Add({
    name = "zyb_jar",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_place_jar01.wav","zyb/zyb_place_jar02.wav","zyb/zyb_place_jar03.wav"}
})


sound.Add({
    name = "zyb_npc_wrongjob",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"vo/npc/male01/pardonme01.wav", "vo/npc/male01/pardonme02.wav"}
})

sound.Add({
    name = "zyb_npc_sell",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"vo/NovaProspekt/eli_foundme02.wav", "vo/npc/male01/question02.wav", "vo/npc/male01/question03.wav", "vo/npc/male01/question04.wav", "vo/npc/male01/question05.wav", "vo/npc/male01/question06.wav", "vo/npc/male01/question09.wav", "vo/npc/male01/question10.wav", "vo/npc/male01/question13.wav", "vo/npc/male01/question16.wav", "vo/npc/male01/question17.wav", "vo/npc/male01/question18.wav", "vo/npc/male01/question19.wav", "vo/npc/male01/question23.wav", "vo/npc/male01/question25.wav", "vo/npc/male01/question27.wav", "vo/npc/male01/question28.wav", "vo/npc/male01/question29.wav", "vo/npc/male01/question30.wav"}
})

sound.Add({
    name = "zyb_cooling",
    channel = CHAN_STATIC,
    volume = 0.5,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_cooling.wav"}
})


sound.Add({
    name = "zyb_fermenting",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_fermenting.wav"}
})


sound.Add({
    name = "zyb_condensing",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_condensing.wav"}
})

sound.Add({
    name = "zyb_building",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_70dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_building.wav"}
})

sound.Add({
    name = "zyb_grinding",
    channel = CHAN_STATIC,
    volume = 0.2,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_grind_loop.wav"}
})

sound.Add({
    name = "zyb_cooking",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_cooking.wav"}
})

sound.Add({
    name = "zyb_explosion",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_70dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_explosion.wav"}
})

sound.Add({
    name = "zyb_drinking",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_drinking01.wav","zyb/zyb_drinking02.wav","zyb/zyb_drinking03.wav"}
})

sound.Add({
    name = "zyb_burning",
    channel = CHAN_STATIC,
    volume = 0.1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"ambient/fire/fire_small_loop1.wav"}
})



sound.Add({
    name = "zyb_cash",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_cash01.wav"}
})

sound.Add({
    name = "zyb_shaking_loop",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_70dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_shake_loop.wav"}
})

sound.Add({
    name = "zyb_shaking_end",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_70dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_shake_end.wav"}
})

sound.Add({
    name = "zyb_fill_liquid",
    channel = CHAN_STATIC,
    volume = 0.5,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_fill_liquid01.wav", "zyb/zyb_fill_liquid02.wav", "zyb/zyb_fill_liquid03.wav"}
})

sound.Add({
    name = "zyb_overheat_loop",
    channel = CHAN_STATIC,
    volume = 0.3,
    level = SNDLVL_70dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_overheat.wav"}
})

sound.Add({
    name = "zyb_steam_loop",
    channel = CHAN_STATIC,
    volume = 1 ,
    level = SNDLVL_70dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_release_steam.wav"}
})


sound.Add({
    name = "zyb_fill_moonshine",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_45dB,
    pitch = {100, 100},
    sound = {"zyb/zyb_fill_liquid05.wav"}
})
-- leak by lordee