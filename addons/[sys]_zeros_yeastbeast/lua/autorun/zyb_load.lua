-- leak by lordee
zyb = zyb or {}
zyb.f = zyb.f or {}

local function NicePrint(txt)
	if SERVER then
		MsgC(Color(193, 120, 98), txt .. "\n")
	else
		MsgC(Color(193, 193, 98), txt .. "\n")
	end
end

local IgnoreFileTable = {}
function zyb.f.PreLoadFile(fdir,afile,info)
	IgnoreFileTable[afile] = true
	zyb.f.LoadFile(fdir,afile,info)
end

function zyb.f.LoadFile(fdir,afile,info)

	if info then
		local nfo = "// [ Initialize ]: " .. afile .. string.rep( " ", 30 - afile:len() ) .. "//"
		NicePrint(nfo)
	end

	if SERVER then
		AddCSLuaFile(fdir .. afile)
	end

	include(fdir .. afile)
end

function zyb.f.LoadAllFiles(fdir)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, afile in ipairs(files) do
		if string.match(afile, ".lua") and not IgnoreFileTable[afile] then
			zyb.f.LoadFile(fdir,afile,true)
		end
	end

	for _, dir in ipairs(dirs) do
		zyb.f.LoadAllFiles(fdir .. dir .. "/")
	end
end

// Initializes the Script
function zyb.f.Initialize()
	NicePrint(" ")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("/////////////// Zeros Yeastbeast //////////////////")
	NicePrint("///////////////////////////////////////////////////")

	zyb.f.PreLoadFile("zerosyeastbeast/sh/","zyb_materials.lua",true)
	zyb.f.PreLoadFile("zerosyeastbeast/sh/","zyb_config.lua",true)

	zyb.f.LoadAllFiles("zyb_languages/")


	zyb.f.LoadAllFiles("zerosyeastbeast/sh/")
	if SERVER then
		zyb.f.LoadAllFiles("zerosyeastbeast/sv/")
	end
	zyb.f.LoadAllFiles("zerosyeastbeast/cl/")

	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")
end

if SERVER then
	timer.Simple(0,function()
		zyb.f.Initialize()
	end)
else

	// This needs to be called instantly on client since client settings wont work otherwhise
	zyb.f.PreLoadFile("zerosyeastbeast/sh/","zyb_materials.lua",false)
	zyb.f.PreLoadFile("zerosyeastbeast/cl/","zyb_fonts_cl.lua",false)
	zyb.f.PreLoadFile("zerosyeastbeast/cl/","zyb_settings_cl.lua",false)

	timer.Simple(0,function()
		zyb.f.Initialize()
	end)
end
-- leak by lordee