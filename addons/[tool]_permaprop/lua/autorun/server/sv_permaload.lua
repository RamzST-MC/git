if not PermaProps then PermaProps = {} end

for k, v in pairs(file.Find("permaprops/sv_*.lua", "LUA")) do
	include("permaprops/".. v)
end

for k, v in pairs(file.Find("permaprops/sh_*.lua", "LUA")) do
	AddCSLuaFile("permaprops/".. v)
	include("permaprops/".. v)
end

for k, v in pairs(file.Find("permaprops/cl_*.lua", "LUA")) do
	AddCSLuaFile("permaprops/".. v)
end