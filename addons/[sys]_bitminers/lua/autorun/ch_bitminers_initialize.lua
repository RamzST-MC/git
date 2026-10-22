-- INITIALIZE SCRIPT

CH_Bitminers = CH_Bitminers and CH_Bitminers or {}
CH_Bitminers.Config = CH_Bitminers.Config and CH_Bitminers.Config or {}
CH_Bitminers.Design = CH_Bitminers.Design and CH_Bitminers.Design or {}
CH_Bitminers.Config.MineMoneyInterval = CH_Bitminers.DesigMineMoneyIntervaln and CH_Bitminers.MineMoneyInterval or {}

if SERVER then
	for k, v in pairs( file.Find( "ch_bitminers/server/*.lua", "LUA" ) ) do
		include( "ch_bitminers/server/" .. v )
		--print("server: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_bitminers/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_bitminers/client/" .. v )
		--print("cs client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_bitminers/shared/*.lua", "LUA" ) ) do
		include( "ch_bitminers/shared/" .. v )
		--print("shared: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_bitminers/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_bitminers/shared/" .. v )
		--print("cs shared: ".. v)
	end
end

if CLIENT then
	for k, v in pairs( file.Find( "ch_bitminers/client/*.lua", "LUA" ) ) do
		include( "ch_bitminers/client/" .. v )
		--print("client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_bitminers/shared/*.lua", "LUA" ) ) do
		include( "ch_bitminers/shared/" .. v )
		--print("shared client: ".. v)
	end
end