rp.pp = rp.pp or {}

--
-- Hooks
--
hook('CanTool', 'pp.CanTool', function(pl, trace, tool)
	local ent = trace.Entity

	return (IsValid(ent) and (ent:GetNetVar('PropIsOwned') == true))
end)

hook('PhysgunPickup', 'pp.PhysgunPickup', function(pl, ent) return false end)

function GM:GravGunPunt(pl, ent)
	return pl:GetRank() == 'console'
end

--
-- Spawnlist
--
local tablePairs = {
	        "models/props_phx/construct/metal_plate1.mdl",
	        "models/props_phx/construct/metal_plate1x2.mdl",
	        "models/props_phx/construct/metal_plate1x2_tri.mdl",
			"models/props_phx/construct/metal_plate1_tri.mdl",
			"models/props_phx/construct/metal_plate2x2.mdl",
			"models/props_phx/construct/metal_plate2x2_tri.mdl",
			"models/props_phx/construct/metal_plate2x4.mdl",
			"models/props_phx/construct/metal_plate2x4_tri.mdl",
			"models/props_phx/construct/metal_plate4x4.mdl",
			"models/props_phx/construct/metal_plate4x4_tri.mdl",
			"models/props_phx/construct/metal_tube.mdl",
			"models/props_phx/construct/metal_tubex2.mdl",
			"models/props_phx/construct/metal_wire1x1.mdl",
			"models/props_phx/construct/metal_wire1x1x1.mdl",
			"models/props_phx/construct/metal_wire1x1x2.mdl",
			"models/props_phx/construct/metal_wire1x1x2b.mdl",
			"models/props_phx/construct/metal_wire1x2.mdl",
			"models/props_phx/construct/metal_wire1x2b.mdl",
			"models/props_phx/construct/metal_wire1x2x2b.mdl",
			"models/props_phx/construct/metal_wire2x2.mdl",
			"models/props_phx/construct/metal_wire2x2b.mdl",
			"models/props_phx/construct/metal_wire2x2x2b.mdl",
			"models/props_phx/construct/windows/window1x1.mdl",
			"models/props_phx/construct/windows/window1x2.mdl",
			"models/props_phx/construct/windows/window2x2.mdl",
			"models/props_phx/construct/windows/window2x4.mdl",
			"models/props_phx/construct/plastic/plastic_angle_180.mdl",
			"models/props_phx/construct/plastic/plastic_angle_360.mdl",
			"models/props_phx/construct/plastic/plastic_angle_90.mdl",
			"models/props_phx/construct/plastic/plastic_panel1x1.mdl",
			"models/props_phx/construct/plastic/plastic_panel1x2.mdl",
			"models/props_phx/construct/plastic/plastic_panel1x3.mdl",
			"models/props_phx/construct/plastic/plastic_panel1x4.mdl",
			"models/props_phx/construct/plastic/plastic_panel1x8.mdl",
			"models/props_phx/construct/plastic/plastic_panel2x2.mdl",
			"models/props_phx/construct/plastic/plastic_panel2x3.mdl",
			"models/props_phx/construct/plastic/plastic_panel2x4.mdl",
			"models/props_phx/construct/plastic/plastic_panel2x8.mdl",
			"models/props_phx/construct/plastic/plastic_panel3x3.mdl",
			"models/props_phx/construct/plastic/plastic_panel4x4.mdl",
			"models/props_phx/construct/plastic/plastic_panel4x8.mdl",
			"models/props_phx/construct/plastic/plastic_panel8x8.mdl",
			"models/mechanics/gears2/pinion_20t3.mdl",
			"models/mechanics/gears2/pinion_40t3.mdl",
			"models/mechanics/gears2/pinion_80t3.mdl",
			"models/hunter/tubes/circle2x2.mdl",
			"models/hunter/tubes/circle2x2c.mdl",
			"models/hunter/tubes/circle4x4.mdl",
			"models/hunter/tubes/circle4x4c.mdl",
			"models/props_phx/construct/metal_angle180.mdl",
			"models/props_phx/construct/metal_angle360.mdl",
			"models/props_phx/construct/metal_angle90.mdl",
			"models/props_phx/construct/metal_plate_curve.mdl",
			"models/props_phx/construct/metal_plate_curve180.mdl",
			"models/props_phx/construct/metal_plate_curve180x2.mdl",
			"models/props_phx/construct/metal_plate_curve2.mdl",
			"models/props_phx/construct/metal_plate_curve2x2.mdl",
			"models/props_phx/construct/metal_plate_curve360.mdl",
			"models/props_phx/construct/metal_plate_curve360x2.mdl",
			"models/props_phx/construct/metal_wire_angle180x1.mdl",
			"models/props_phx/construct/metal_wire_angle180x2.mdl",
			"models/props_phx/construct/metal_wire_angle360x1.mdl",
			"models/props_phx/construct/metal_wire_angle360x2.mdl",
			"models/props_phx/construct/metal_wire_angle90x1.mdl",
			"models/props_phx/construct/metal_wire_angle90x2.mdl",
			"models/props_phx/construct/windows/window_angle180.mdl",
			"models/props_phx/construct/windows/window_angle360.mdl",
			"models/props_phx/construct/windows/window_angle90.mdl",
			"models/props_phx/construct/windows/window_curve180x1.mdl",
			"models/props_phx/construct/windows/window_curve180x2.mdl",
			"models/props_phx/construct/windows/window_curve360x1.mdl",
			"models/props_phx/construct/windows/window_curve360x2.mdl",
			"models/props_phx/construct/windows/window_curve90x1.mdl",
			"models/props_phx/construct/windows/window_curve90x2.mdl",
			"models/hunter/triangles/025x025.mdl",
			"models/hunter/triangles/05x05.mdl",
			"models/hunter/triangles/075x075.mdl",
			"models/hunter/triangles/1x1.mdl",
			"models/hunter/triangles/2x2.mdl",
			"models/hunter/triangles/3x3.mdl",
			"models/hunter/triangles/4x4.mdl",
			"models/hunter/plates/tri2x1.mdl",
			"models/hunter/plates/tri3x1.mdl",
			"models/hunter/triangles/025x025mirrored.mdl",
			"models/hunter/triangles/05x05mirrored.mdl",
			"models/hunter/triangles/075x075mirrored.mdl",
			"models/hunter/triangles/1x1mirrored.mdl",
			"models/hunter/triangles/2x2mirrored.mdl",
			"models/hunter/triangles/3x3mirrored.mdl",
			"models/hunter/triangles/4x4mirrored.mdl",
			"models/hunter/triangles/05x05x05.mdl",
			"models/hunter/triangles/1x05x05.mdl",
			"models/hunter/triangles/1x05x1.mdl",
			"models/hunter/triangles/1x1x1.mdl",
			"models/hunter/triangles/1x1x2.mdl",
			"models/hunter/triangles/1x1x3.mdl",
			"models/hunter/triangles/1x1x4.mdl",
			"models/hunter/triangles/2x1x1.mdl",
			"models/hunter/triangles/2x2x2.mdl",
			"models/hunter/triangles/3x2x2.mdl",
			"models/hunter/triangles/1x1x1carved.mdl",
			"models/hunter/triangles/2x1x1carved.mdl",
			"models/hunter/triangles/2x2x1carved.mdl",
			"models/hunter/triangles/1x1x2carved.mdl",
			"models/hunter/triangles/1x1x1carved025.mdl",
			"models/hunter/triangles/1x1x2carved025.mdl",
			"models/hunter/triangles/1x1x4carved025.mdl",
			"models/xqm/panel45.mdl",
			"models/xqm/panel90.mdl",
			"models/xqm/panel180.mdl",
			"models/xqm/panel360.mdl",
			"models/phxtended/bar1x.mdl",
			"models/phxtended/bar2x.mdl",
			"models/phxtended/tri1x1.mdl",
			"models/phxtended/tri1x1solid.mdl",
			"models/phxtended/tri1x1x1.mdl",
			"models/phxtended/tri1x1x1solid.mdl",
			"models/phxtended/tri1x1x2.mdl",
			"models/phxtended/tri1x1x2solid.mdl",
			"models/phxtended/trieq1x1x1.mdl",
			"models/phxtended/trieq1x1x1solid.mdl",
			"models/phxtended/trieq1x1x2.mdl",
			"models/phxtended/trieq1x1x2solid.mdl",
			"models/hunter/misc/stair1x1.mdl",
			"models/hunter/misc/stair1x1inside.mdl",
			"models/hunter/misc/stair1x1outside.mdl",
			"models/mechanics/robotics/a2.mdl",
			"models/mechanics/robotics/a3.mdl",
			"models/mechanics/robotics/a4.mdl",
			"models/hunter/plates/plate1x1.mdl",
	        "models/hunter/plates/plate1x2.mdl",
	        "models/hunter/plates/plate1x3.mdl",
			"models/hunter/plates/plate1x4.mdl",
	        "models/hunter/plates/plate1x5.mdl",
			"models/hunter/plates/plate1x6.mdl",
	        "models/hunter/plates/plate1x7.mdl",
			"models/hunter/plates/plate1x8.mdl",
	        "models/hunter/plates/plate2x2.mdl",
			"models/hunter/plates/plate2x3.mdl",
	        "models/hunter/plates/plate2x4.mdl",
			"models/hunter/plates/plate2x5.mdl",
	        "models/hunter/plates/plate2x6.mdl",
			"models/hunter/plates/plate2x7.mdl",
	        "models/hunter/plates/plate2x8.mdl",
			"models/hunter/plates/plate3x3.mdl",
	        "models/hunter/plates/plate3x4.mdl",
			"models/hunter/plates/plate3x5.mdl",
	        "models/hunter/plates/plate3x6.mdl",
			"models/hunter/plates/plate3x7.mdl",
	        "models/hunter/plates/plate3x8.mdl",
			"models/hunter/plates/plate4x4.mdl",
	        "models/hunter/plates/plate4x5.mdl",
			"models/hunter/plates/plate4x6.mdl",
	        "models/hunter/plates/plate4x7.mdl",
			"models/hunter/plates/plate4x8.mdl",
	        "models/hunter/plates/plate5x5.mdl",
			"models/hunter/plates/plate5x6.mdl",
	        "models/hunter/plates/plate5x7.mdl",
			"models/hunter/plates/plate5x8.mdl",
	        "models/hunter/plates/plate6x6.mdl",
			"models/hunter/plates/plate6x7.mdl",
	        "models/hunter/plates/plate6x8.mdl",
	        "models/hunter/plates/plate7x7.mdl",
			"models/hunter/plates/plate7x8.mdl",
	        "models/hunter/plates/plate8x8.mdl",
			"models/hunter/blocks/cube025x025x025.mdl",
	        "models/hunter/blocks/cube025x05x025.mdl",
			"models/hunter/blocks/cube025x075x025.mdl",
	        "models/hunter/blocks/cube025x1x025.mdl",
			"models/hunter/blocks/cube025x125x025.mdl",
	        "models/hunter/blocks/cube025x150x025.mdl",
			"models/hunter/blocks/cube025x2x025.mdl",
	        "models/hunter/blocks/cube025x3x025.mdl",
			"models/hunter/blocks/cube025x4x025.mdl",
	        "models/hunter/blocks/cube05x05x025.mdl",
			"models/hunter/blocks/cube05x075x025.mdl",
	        "models/hunter/blocks/cube05x1x025.mdl",
			"models/hunter/blocks/cube05x2x025.mdl",
	        "models/hunter/blocks/cube05x3x025.mdl",
			"models/hunter/blocks/cube05x4x025.mdl",
			"models/hunter/blocks/cube05x5x025.mdl",
			"models/hunter/blocks/cube05x6x025.mdl",
			"models/hunter/blocks/cube05x7x025.mdl",
	        "models/hunter/blocks/cube075x075x025.mdl",
			"models/hunter/blocks/cube075x1x025.mdl",
	        "models/hunter/blocks/cube075x2x025.mdl",
			"models/hunter/blocks/cube075x3x025.mdl",
	        "models/hunter/blocks/cube075x4x025.mdl",
			"models/hunter/blocks/cube1x1x025.mdl",
	        "models/hunter/blocks/cube1x2x025.mdl",
			"models/hunter/blocks/cube1x3x025.mdl",
	        "models/hunter/blocks/cube1x4x025.mdl",
			"models/hunter/blocks/cube1x5x025.mdl",
	        "models/hunter/blocks/cube1x6x025.mdl",
			"models/hunter/blocks/cube1x7x025.mdl",
	        "models/hunter/blocks/cube1x8x025.mdl",
			"models/hunter/blocks/cube2x2x025.mdl",
	        "models/hunter/blocks/cube2x3x025.mdl",
			"models/hunter/blocks/cube2x4x025.mdl",
	        "models/hunter/blocks/cube2x6x025.mdl",
			"models/hunter/blocks/cube2x8x025.mdl",
	        "models/hunter/blocks/cube3x3x025.mdl",
			"models/hunter/blocks/cube3x4x025.mdl",
	        "models/hunter/blocks/cube3x6x025.mdl",
			"models/hunter/blocks/cube3x8x025.mdl",
	        "models/hunter/blocks/cube4x4x025.mdl",
			"models/hunter/blocks/cube4x6x025.mdl",
	        "models/hunter/blocks/cube05x05x05.mdl",
			"models/hunter/blocks/cube05x1x05.mdl",
	        "models/hunter/blocks/cube05x105x05.mdl",
			"models/hunter/blocks/cube05x2x05.mdl",
	        "models/hunter/blocks/cube05x3x05.mdl",
			"models/hunter/blocks/cube05x4x05.mdl",
	        "models/hunter/blocks/cube1x1x05.mdl",
			"models/hunter/blocks/cube1x2x05.mdl",
	        "models/hunter/blocks/cube1x4x05.mdl",
			"models/hunter/blocks/cube1x6x05.mdl",
	        "models/hunter/blocks/cube2x2x05.mdl",
			"models/hunter/blocks/cube2x4x05.mdl",
	        "models/hunter/blocks/cube2x6x05.mdl",
			"models/hunter/blocks/cube3x3x05.mdl",
	        "models/hunter/blocks/cube4x4x05.mdl",
			"models/hunter/blocks/cube4x6x05.mdl",
	        "models/hunter/blocks/cube6x6x05.mdl",
	        "models/props_phx/rt_screen.mdl",
			"models/props_c17/furniturewashingmachine001a.mdl",
			"models/props_c17/furnituretoilet001a.mdl",
			"models/props_c17/furnituresink001a.mdl",
			"models/props_c17/canister_propane01a.mdl",
			"models/props_c17/gaspipes006a.mdl",
			"models/props_canal/mattpipe.mdl",
			"models/props_borealis/mooring_cleat01.mdl",
			"models/props_borealis/door_wheel001a.mdl",
			"models/props_borealis/borealis_door001a.mdl",
			"models/props_borealis/bluebarrel001.mdl",
			"models/props_c17/canister01a.mdl",
			"models/props_c17/canister02a.mdl",
			"models/props_c17/bench01a.mdl",
			"models/props_c17/chair02a.mdl",
			"models/props_c17/door01_left.mdl",
			"models/props_c17/door02_double.mdl",
			"models/props_c17/concrete_barrier001a.mdl",
			"models/props_phx/construct/concrete_barrier00.mdl",
			"models/props_phx/construct/concrete_barrier01.mdl",
			"models/props_c17/fence01a.mdl",
			"models/props_c17/fence01b.mdl",
			"models/props_c17/fence03a.mdl",
			"models/props_c17/fence02b.mdl",
			"models/props_c17/fence02a.mdl",
			"models/props_c17/furniturebathtub001a.mdl",
			"models/props_c17/furniturebed001a.mdl",
			"models/props_c17/furnitureboiler001a.mdl",
			"models/props_c17/furniturechair001a.mdl",
			"models/props_c17/furniturecouch001a.mdl",
			"models/props_c17/furniturecouch002a.mdl",
			"models/props_c17/furniturecupboard001a.mdl",
			"models/props_c17/furnituredrawer001a.mdl",
			"models/props_c17/furnituredrawer002a.mdl",
			"models/props_c17/furnituredrawer003a.mdl",
			"models/props_c17/furnituredresser001a.mdl",
			"models/props_c17/furniturefireplace001a.mdl",
			"models/props_c17/furniturefridge001a.mdl",
			"models/props_c17/furnitureradiator001a.mdl",
			"models/props_wasteland/prison_heater001a.mdl",
			"models/props_c17/furnitureshelf001a.mdl",
			"models/props_c17/furnitureshelf001b.mdl",
			"models/props_c17/furnitureshelf002a.mdl",
			"models/props_c17/furniturestove001a.mdl",
			"models/props_c17/furnituretable001a.mdl",
			"models/props_c17/furnituretable002a.mdl",
			"models/props_c17/furnituretable003a.mdl",
			"models/props_c17/gravestone001a.mdl",
			"models/props_c17/gravestone002a.mdl",
			"models/props_c17/gravestone003a.mdl",
			"models/props_junk/plasticcrate01a.mdl",
			"models/props_c17/lampshade001a.mdl",
			"models/props_c17/lockers001a.mdl",
			"models/props_c17/metalladder001.mdl",
			"models/props_c17/metalladder002.mdl",
			"models/props_c17/metalladder002b.mdl",
			"models/props_c17/oildrum001.mdl",
			"models/props_c17/pulleywheels_small01.mdl",
			"models/props_c17/pulleywheels_large01.mdl",
			"models/props_c17/shelfunit01a.mdl",
			"models/props_c17/signpole001.mdl",
			"models/props_combine/breenchair.mdl",
			"models/props_combine/breendesk.mdl",
			"models/props_combine/breenglobe.mdl",
			"models/props_debris/metal_panel01a.mdl",
			"models/props_debris/metal_panel02a.mdl",
			"models/props_docks/dock01_cleat01a.mdl",
			"models/props_doors/door03_slotted_left.mdl",
			"models/props_interiors/bathtub01a.mdl",
			"models/props_interiors/elevatorshaft_door01a.mdl",
			"models/props_interiors/furniture_chair01a.mdl",
			"models/props_interiors/furniture_chair03a.mdl",
			"models/props_interiors/furniture_couch01a.mdl",
			"models/props_interiors/furniture_couch02a.mdl",
			"models/props_interiors/furniture_desk01a.mdl",
			"models/props_interiors/furniture_lamp01a.mdl",
			"models/props_interiors/furniture_shelf01a.mdl",
			"models/props_interiors/furniture_vanity01a.mdl",
			"models/props_interiors/pot01a.mdl",
			"models/props_interiors/pot02a.mdl",
			"models/props_interiors/radiator01a.mdl",
			"models/props_interiors/refrigerator01a.mdl",
			"models/props_interiors/refrigeratordoor01a.mdl",
			"models/props_interiors/refrigeratordoor02a.mdl",
			"models/props_interiors/sinkkitchen01a.mdl",
			"models/props_interiors/vendingmachinesoda01a.mdl",
			"models/props_interiors/vendingmachinesoda01a_door.mdl",
			"models/props_junk/cardboard_box001a.mdl",
			"models/props_junk/cardboard_box002a.mdl",
			"models/props_junk/cinderblock01a.mdl",
			"models/props_junk/harpoon002a.mdl",
			"models/props_junk/ibeam01a_cluster01.mdl",
			"models/props_junk/ibeam01a.mdl",
			"models/props_junk/meathook001a.mdl",
			"models/props_junk/metal_paintcan001a.mdl",
			"models/props_junk/metalbucket01a.mdl",
			"models/props_junk/metalbucket02a.mdl",
			"models/props_junk/metalgascan.mdl",
			"models/props_junk/propanecanister001a.mdl",
			"models/props_junk/pushcart01a.mdl",
			"models/props_junk/sawblade001a.mdl",
			"models/props_junk/trashbin01a.mdl",
			"models/props_junk/trafficcone001a.mdl",
			"models/props_junk/trashdumpster02b.mdl",
			"models/props_junk/trashdumpster01a.mdl",
			"models/props_junk/wood_crate001a.mdl",
			"models/props_junk/wood_crate002a.mdl",
			"models/props_junk/wood_pallet001a.mdl",
			"models/props_lab/blastdoor001a.mdl",
			"models/props_lab/blastdoor001b.mdl",
			"models/props_lab/blastdoor001c.mdl",
			"models/props_lab/filecabinet02.mdl",
			"models/props_lab/kennel_physics.mdl",
			"models/props_lab/lockerdoorleft.mdl",
			"models/props_trainstation/benchoutdoor01a.mdl",
			"models/props_trainstation/bench_indoor001a.mdl",
			"models/props_trainstation/ceiling_arch001a.mdl",
			"models/props_trainstation/mount_connection001a.mdl",
			"models/props_trainstation/tracksign02.mdl",
			"models/props_trainstation/tracksign03.mdl",
			"models/props_trainstation/tracksign07.mdl",
			"models/props_trainstation/tracksign08.mdl",
			"models/props_trainstation/tracksign09.mdl",
			"models/props_trainstation/tracksign10.mdl",
			"models/props_trainstation/traincar_rack001.mdl",
			"models/props_trainstation/trainstation_clock001.mdl",
			"models/props_trainstation/trainstation_ornament002.mdl",
			"models/props_trainstation/trainstation_post001.mdl",
			"models/props_trainstation/trashcan_indoor001a.mdl",
			"models/props_vehicles/tire001a_tractor.mdl",
			"models/props_vehicles/tire001b_truck.mdl",
			"models/props_vehicles/tire001c_car.mdl",
			"models/props_vehicles/apc_tire001.mdl",
			"models/props_wasteland/barricade001a.mdl",
			"models/props_wasteland/barricade002a.mdl",
			"models/props_wasteland/cafeteria_bench001a.mdl",
			"models/props_wasteland/cafeteria_table001a.mdl",
			"models/props_wasteland/controlroom_desk001a.mdl",
			"models/props_wasteland/controlroom_filecabinet001a.mdl",
			"models/props_wasteland/controlroom_filecabinet002a.mdl",
			"models/props_wasteland/controlroom_storagecloset001a.mdl",
			"models/props_wasteland/gaspump001a.mdl",
			"models/props_wasteland/interior_fence001g.mdl",
			"models/props_wasteland/interior_fence002d.mdl",
			"models/props_wasteland/interior_fence002e.mdl",
			"models/props_wasteland/kitchen_counter001b.mdl",
			"models/props_wasteland/kitchen_counter001d.mdl",
			"models/props_wasteland/kitchen_shelf002a.mdl",
			"models/props_wasteland/kitchen_shelf001a.mdl",
			"models/props_wasteland/laundry_basket001.mdl",
			"models/props_wasteland/laundry_cart001.mdl",
			"models/props_wasteland/laundry_cart002.mdl",
			"models/props_wasteland/laundry_dryer002.mdl",
			"models/props_wasteland/laundry_washer001a.mdl",
			"models/props_wasteland/laundry_washer003.mdl",
			"models/props_wasteland/light_spotlight01_lamp.mdl",
			"models/props_wasteland/medbridge_post01.mdl",
			"models/props_wasteland/panel_leverhandle001a.mdl",
			"models/props_wasteland/prison_bedframe001b.mdl",
			"models/props_wasteland/prison_lamp001c.mdl",
			"models/props_wasteland/prison_shelf002a.mdl",
			"models/props_wasteland/wood_fence01a.mdl",
			"models/props_wasteland/wood_fence02a.mdl",
			"models/gibs/hgibs.mdl",
			"models/props_c17/briefcase001a.mdl",
			"models/props_c17/bench01a.mdl",
			"models/props_c17/cashregister01a.mdl",
			"models/props_c17/chair_kleiner03a.mdl",
			"models/props_c17/chair_stool01a.mdl",
			"models/props_c17/chair_office01a.mdl",
			"models/props_c17/clock01.mdl",
			"models/props_c17/computer01_keyboard.mdl",
			"models/props_c17/consolebox01a.mdl",
			"models/props_c17/consolebox03a.mdl",
			"models/props_c17/consolebox05a.mdl",
			"models/props_c17/doll01.mdl",
			"models/props_c17/frame002a.mdl",
			"models/props_c17/metalpot001a.mdl",
			"models/props_c17/metalpot002a.mdl",
			"models/props_c17/playground_teetertoter_stan.mdl",
			"models/props_c17/playgroundtick-tack-toe_block01a.mdl",
			"models/props_c17/playgroundtick-tack-toe_post01.mdl",
			"models/props_c17/streetsign001c.mdl",
			"models/props_c17/streetsign002b.mdl",
			"models/props_c17/streetsign003b.mdl",
			"models/props_c17/streetsign004e.mdl",
			"models/props_c17/streetsign004f.mdl",
			"models/props_c17/streetsign005b.mdl",
			"models/props_c17/streetsign005c.mdl",
			"models/props_c17/streetsign005d.mdl",
			"models/props_c17/suitcase001a.mdl",
			"models/props_c17/suitcase_passenger_physics.mdl",
			"models/props_c17/tools_wrench01a.mdl",
			"models/props_c17/trappropeller_engine.mdl",
			"models/props_c17/trappropeller_lever.mdl",
			"models/props_c17/tv_monitor01.mdl",
			"models/props_combine/breenbust.mdl",
			"models/props_lab/reciever_cart.mdl",
			"models/props_lab/reciever01d.mdl",
			"models/props_lab/reciever01a.mdl",
			"models/props_lab/reciever01b.mdl",
			"models/props_lab/reciever01c.mdl",
			"models/props_lab/harddrive02.mdl",
			"models/props_lab/frame002a.mdl",
			"models/props_lab/clipboard.mdl",
			"models/props_lab/desklamp01.mdl",
			"models/props_lab/harddrive01.mdl",
			"models/props_lab/huladoll.mdl",
			"models/props_lab/monitor01a.mdl",
			"models/props_lab/monitor01b.mdl",
			"models/props_lab/monitor02.mdl",
			"models/props_lab/partsbin01.mdl",
			"models/props_lab/plotter.mdl",
			"models/props_trainstation/payphone001a.mdl",
			"models/props_vehicles/carparts_axel01a.mdl",
			"models/props_vehicles/carparts_muffler01a.mdl",
			"models/props_trainstation/traincar_seats001.mdl",
			"models/props_vehicles/carparts_wheel01a.mdl",
			"models/props_lab/cactus.mdl",
			"models/props/cs_assault/BarrelWarning.mdl",
			"models/props/cs_assault/camera.mdl",
			"models/props/cs_assault/chaintrainstationsign.mdl",
			"models/props/cs_assault/consolepanelloadingbay.mdl",
			"models/props/cs_assault/dryer_box.mdl",
			"models/props/cs_assault/duct.mdl",
			"models/props/cs_assault/firehydrant.mdl",
			"models/props/cs_assault/floodlight01.mdl",
			"models/props/cs_assault/light_shop2.mdl",
			"models/props/cs_assault/meter.mdl",
			"models/props/cs_assault/noparking.mdl",
			"models/props/cs_assault/nostopssign.mdl",
			"models/props/cs_assault/pylon.mdl",
			"models/props/cs_assault/stoplight.mdl",
			"models/props/cs_assault/streetlight.mdl",
			"models/props/cs_assault/streetsign02.mdl",
			"models/props/cs_assault/ventilationduct01.mdl",
			"models/props/cs_assault/wall_vent.mdl",
			"models/props/cs_assault/wirepipe.mdl",
			"models/props/cs_assault/wirespout.mdl",
			"models/props/cs_militia/bar01.mdl",
			"models/props/cs_militia/barstool01.mdl",
			"models/props/cs_militia/bathroomwallhole01_wood_broken.mdl",
			"models/props/cs_militia/boxes_frontroom.mdl",
			"models/props/cs_militia/boxes_garage_lower.mdl",
			"models/props/cs_militia/caseofbeer01.mdl",
			"models/props/cs_militia/circularsaw01.mdl",
			"models/props/cs_militia/couch.mdl",
			"models/props/cs_militia/crate_extrasmallmill.mdl",
			"models/props/cs_militia/crate_stackmill.mdl",
			"models/props/cs_militia/dryer.mdl",
			"models/props/cs_militia/fencewoodlog01_short.mdl",
			"models/props/cs_militia/fencewoodlog03_long.mdl",
			"models/props/cs_militia/fertilizer.mdl",
			"models/props/cs_militia/food_stack.mdl",
			"models/props/cs_militia/furnace01.mdl",
			"models/props/cs_militia/gun_cabinet.mdl",
			"models/props/cs_militia/haybale_target.mdl",
			"models/props/cs_militia/haybale_target_02.mdl",
			"models/props/cs_militia/haybale_target_03.mdl",
			"models/props/cs_militia/ladderwood.mdl",
			"models/props/cs_militia/lightfixture01.mdl",
			"models/props/cs_militia/light_shop2.mdl",
			"models/props/cs_militia/logpile2.mdl",
			"models/props/cs_militia/mailbox01.mdl",
			"models/props/cs_militia/microwave01.mdl",
			"models/props/cs_militia/militiawindow01.mdl",
			"models/props/cs_militia/militiawindow02_breakable.mdl",
			"models/props/cs_militia/militiawindow02_breakable_frame.mdl",
			"models/props/cs_militia/newspaperstack01.mdl",
			"models/props/cs_militia/oldphone01.mdl",
			"models/props/cs_militia/paintbucket01.mdl",
			"models/props/cs_militia/refrigerator01.mdl",
			"models/props/cs_militia/reloadingpress01.mdl",
			"models/props/cs_militia/reload_scale.mdl",
			"models/props/cs_militia/sawhorse.mdl",
			"models/props/cs_militia/sheetrock_leaning.mdl",
			"models/props/cs_militia/shelves.mdl",
			"models/props/cs_militia/shelves_wood.mdl",
			"models/props/cs_militia/spotlight.mdl",
			"models/props/cs_militia/stove01.mdl",
			"models/props/cs_militia/table_kitchen.mdl",
			"models/props/cs_militia/table_shed.mdl",
			"models/props/cs_militia/television_console01.mdl",
			"models/props/cs_militia/toilet.mdl",
			"models/props/cs_militia/urine_trough.mdl",
			"models/props/cs_militia/wndw01.mdl",
			"models/props/cs_militia/wood_bench.mdl",
			"models/props/cs_militia/wood_table.mdl",
			"models/props/cs_office/bookshelf1.mdl",
			"models/props/cs_office/coffee_mug.mdl",
			"models/props/cs_office/coffee_mug2.mdl",
			"models/props/cs_office/coffee_mug3.mdl",
			"models/props/cs_office/computer.mdl",
			"models/props/cs_office/computer_caseb.mdl",
			"models/props/cs_office/computer_keyboard.mdl",
			"models/props/cs_office/computer_monitor.mdl",
			"models/props/cs_office/computer_mouse.mdl",
			"models/props/cs_office/crates_indoor.mdl",
			"models/props/cs_office/crates_outdoor.mdl",
			"models/props/cs_office/exit_ceiling.mdl",
			"models/props/cs_office/file_box.mdl",
			"models/props/cs_office/file_cabinet1.mdl",
			"models/props/cs_office/file_cabinet1_group.mdl",
			"models/props/cs_office/file_cabinet2.mdl",
			"models/props/cs_office/file_cabinet3.mdl",
			"models/props/cs_office/fire_extinguisher.mdl",
			"models/props/cs_office/light_security.mdl",
			"models/props/cs_office/offcertificatea.mdl",
			"models/props/cs_office/offcorkboarda.mdl",
			"models/props/cs_office/offinspa.mdl",
			"models/props/cs_office/offinspb.mdl",
			"models/props/cs_office/offinspc.mdl",
			"models/props/cs_office/offinspd.mdl",
			"models/props/cs_office/offpaintinga.mdl",
			"models/props/cs_office/offpaintingb.mdl",
			"models/props/cs_office/offpaintingd.mdl",
			"models/props/cs_office/offpaintinge.mdl",
			"models/props/cs_office/offpaintingf.mdl",
			"models/props/cs_office/sofa.mdl",
			"models/props/cs_office/sofa_chair.mdl",
			"models/props/cs_office/table_coffee.mdl",
			"models/props/cs_office/table_meeting.mdl",
			"models/props/cs_office/trash_can.mdl",
			"models/props/de_nuke/light_red1.mdl",
			"models/props/de_nuke/light_red2.mdl",
}

	local spawnlist = {}
	spawnlist.name = 'Разрешенные пропы'
	spawnlist.id = math.random(1000, 9999)
	spawnlist.icon = 'icon16/cog.png'
	spawnlist.parentid = 0
	spawnlist.version = 3
	spawnlist.contents = {}

	for k, v in pairs(tablePairs) do
		spawnlist.contents[#spawnlist.contents + 1] = {
			type = 'model',
			model = v
		}
	end

spawnmenu.AddPropCategory('', spawnlist.name, spawnlist.contents, spawnlist.icon, spawnlist.id, 0)


--
-- Menus
--
local ranks = {
	[0] = 'user',
	[1] = 'VIP',
	[2] = 'Admin',
	[3] = 'Globaladmin'
}

function rp.pp.ToolEditor()
	local tools = net.ReadTable()

	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(500, 400)
		self:SetTitle('Tool editor')
		self:Center()
		self:MakePopup()
	end)

	local targ

	local list = ui.Create('DListView', function(self, p) -- TODO: FIX
		self:SetPos(5, 30)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 65)
		self:SetMultiSelect(false)
		self:AddColumn('Tool')
		self:AddColumn('Rank')

		self.OnRowSelected = function(parent, line)
			targ = self:GetLine(line):GetColumnText(1)
		end

		for a, b in ipairs(spawnmenu.GetTools()) do
			for c, d in ipairs(spawnmenu.GetTools()[a].Items) do
				for e, f in ipairs(spawnmenu.GetTools()[a].Items[c]) do
					if (type(f) == 'table') and string.find(f.Command, 'gmod_tool') then
						self:AddLine(f.ItemName, tools[f.ItemName] and ranks[tools[f.ItemName]] or 'user')
					end
				end
			end
		end
	end, fr)

	for i = 1, 4 do
		ui.Create('DButton', function(self, p)
			self:SetSize(p:GetWide() / 4 - 6, 25)
			self:SetPos((i - 1) * (p:GetWide() / 4 - 6) + (5 * i), p:GetTall() - 30)
			self:SetText(ranks[i - 1])

			self.DoClick = function()
				cmd.Run('settoolgroup', targ, (i - 1))
			end
		end, fr)
	end
end

net('rp.toolEditor', rp.pp.ToolEditor)

function rp.pp.SharePropMenu()
	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(500, 400)
		self:SetTitle('Поделиться Пропами')
		self:Center()
		self:MakePopup()
	end)
	local x, y = fr:GetDockPos()
	local sharedPlayers
	local unSharedPlayers

	ui.Create('DLabel', function(self)
		self:SetPos(x, y - 2)
		self:SetFont('ui.20')
		self:SetText('Добавить игрока')
		self:SizeToContents()
	end, fr)

	ui.Create('DLabel', function(self)
		self:SetPos(x + (fr:GetWide() * 0.5) + 5, y - 2)
		self:SetFont('ui.20')
		self:SetText('Удалить игрока')
		self:SizeToContents()
	end, fr)

	local sharedKeys = LocalPlayer():GetNetVar('ShareProps') or {}
	unSharedPlayers = ui.Create('ui_playerrequest', function(self, p)
		self:SetPos(x, y + 20)
		self:SetSize((fr:GetWide() * 0.5) - 7.5, (fr:GetTall() - y) - 25)

		self.LayoutPlayers = function(self)
			self:SetPlayers(table.Filter(player.GetAll(), function(v)
				return (sharedKeys[v] == false or sharedKeys[v] == nil)
			end))

			self.PlayerList:AddPlayers()
		end

		self.OnSelection = function(self, row, pl)
			cmd.Run('shareprops', pl:SteamID())

			sharedKeys[pl] = true

			self:LayoutPlayers()
			sharedPlayers:LayoutPlayers()
		end

		self:LayoutPlayers()
	end, fr)

	sharedPlayers = ui.Create('ui_playerrequest', function(self, p)
		self:SetPos(x + unSharedPlayers:GetWide() + 7.5, y + 20)
		self:SetSize((fr:GetWide() * 0.5) - 7.5, (fr:GetTall() - y) - 25)

		self.LayoutPlayers = function(self)
			self:SetPlayers(table.Filter(player.GetAll(), function(v)
				return (sharedKeys[v] == true and sharedKeys[v] ~= nil)
			end))

			self.PlayerList:AddPlayers()
		end

		self.OnSelection = function(self, row, pl)
			cmd.Run('shareprops', pl:SteamID())

			sharedKeys[pl] = false

			self:LayoutPlayers()
			unSharedPlayers:LayoutPlayers()
		end

		self:LayoutPlayers()
	end, fr)

end