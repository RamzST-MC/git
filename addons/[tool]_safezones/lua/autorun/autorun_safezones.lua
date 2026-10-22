/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/

SH_SZ = {}

include("sz_config.lua")
include("safezones/sh_shapes.lua")
include("safezones/sh_main.lua")

if (SERVER) then
	AddCSLuaFile("autorun/autorun_safezones.lua")
	AddCSLuaFile("safezones/sh_shapes.lua")
	AddCSLuaFile("safezones/sh_main.lua")
	AddCSLuaFile("safezones/cl_interface.lua")
	AddCSLuaFile("safezones/cl_main.lua")
	AddCSLuaFile("safezones/cl_editor.lua")
	AddCSLuaFile("sz_config.lua")

	include("safezones/sv_main.lua")
else
	include("safezones/cl_interface.lua")
	include("safezones/cl_main.lua")
	include("safezones/cl_editor.lua")
end

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/