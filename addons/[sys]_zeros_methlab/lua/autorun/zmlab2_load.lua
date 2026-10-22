
local function NicePrint(txt)
	if SERVER then
		MsgC(Color(84, 150, 197), txt .. "\n")
	else
		MsgC(Color(193, 193, 98), txt .. "\n")
	end
end

local function PreLoadFile(path)
	if CLIENT then
		include(path)
	else
		AddCSLuaFile(path)
		include(path)
	end
end

local function LoadFiles(path)
	local files, _ = file.Find(path .. "/*", "LUA")

	for _, v in pairs(files) do
		if string.sub(v, 1, 3) == "sh_" then
			if CLIENT then
				include(path .. "/" .. v)
			else
				AddCSLuaFile(path .. "/" .. v)
				include(path .. "/" .. v)
			end
			NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end

	for _, v in pairs(files) do
		if string.sub(v, 1, 3) == "cl_" then
			if CLIENT then
				include(path .. "/" .. v)
				NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
			else
				AddCSLuaFile(path .. "/" .. v)
			end
		elseif string.sub(v, 1, 3) == "sv_" then
			include(path .. "/" .. v)
			NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end
end

local function Initialize()
	NicePrint(" ")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("////////////// Zeros Methlab 2 ////////////////////")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")

	PreLoadFile("zmlab2/sh_main_config.lua")
	LoadFiles("zmlab2_languages")
	PreLoadFile("zmlab2/sh_meth_config.lua")
	PreLoadFile("zmlab2/sh_tent_config.lua")
	PreLoadFile("zmlab2/sh_equipment_config.lua")
	PreLoadFile("zmlab2/sh_storage_config.lua")
	PreLoadFile("zmlab2/sh_custom_hooks.lua")

	LoadFiles("zmlab2/util")
	LoadFiles("zmlab2/util/player")
	LoadFiles("zmlab2/tent")
	LoadFiles("zmlab2/ventilation")
	LoadFiles("zmlab2/minigame")
	LoadFiles("zmlab2/equipment")
	LoadFiles("zmlab2/furnace")
	LoadFiles("zmlab2/storage")
	LoadFiles("zmlab2/pumpsystem")
	LoadFiles("zmlab2/mixer")
	LoadFiles("zmlab2/filter")
	LoadFiles("zmlab2/filler")
	LoadFiles("zmlab2/frezzer")
	LoadFiles("zmlab2/packing")
	LoadFiles("zmlab2/pollutionsystem")
	LoadFiles("zmlab2/extinguisher")
	LoadFiles("zmlab2/generic")
	LoadFiles("zmlab2/meth")
	LoadFiles("zmlab2/crate")
	LoadFiles("zmlab2/palette")
	LoadFiles("zmlab2/dropoff")
	LoadFiles("zmlab2/npc")
	LoadFiles("zmlab2/save")

	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")
end

PreLoadFile("zmlab2/util/sh_materials.lua")
PreLoadFile("zmlab2/util/cl_fonts.lua")
PreLoadFile("zmlab2/util/cl_settings.lua")

timer.Simple(0,function()
	Initialize()
end)
