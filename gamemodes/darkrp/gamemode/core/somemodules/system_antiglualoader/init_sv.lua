util.AddNetworkString('checkexec')
util.AddNetworkString('MHBAN')
util.AddNetworkString('Sandbox_ArmDupe')
util.AddNetworkString('Ulib_Message')
util.AddNetworkString('DarkRP_AdminWeapons')
util.AddNetworkString("__Detect")

net.Receive("__Detect", function(len,ply)
	local a = net.ReadString()
	if a == "external" then
		RunConsoleCommand("ba", "perma", ply:SteamID(), "Cheats External")
	elseif a == '' then
		RunConsoleCommand("ba", "perma", ply:SteamID(), "Glua Loader Detected!")
		print('stop')
	end
end)

net.Receive("DarkRP_AdminWeapons", function(len, ply)
RunConsoleCommand("ba", "perma", ply:SteamID(), "antigavno srabotalo!!!!")
end)

net.Receive("Sandbox_ArmDupe", function(len, ply)
RunConsoleCommand("ba", "perma", ply:SteamID(), "antigavno srabotalo!!!!")
end)

net.Receive("Ulib_Message", function(len, ply)
RunConsoleCommand("ba", "perma", ply:SteamID(), "antigavno srabotalo!!!!")
end)

net.Receive('MHBAN',function(len,ply)

	RunConsoleCommand("ba", "perma", ply:SteamID(), 'antigavno srabotalo!!!!')

end)
