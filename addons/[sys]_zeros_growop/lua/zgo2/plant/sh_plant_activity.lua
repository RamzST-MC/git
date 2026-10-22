--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}

/*

	Updates the players about activity change

*/

if SERVER then
	util.AddNetworkString("zgo2.Plant.UpdateActivity")

	function zgo2.Plant.SendActivityList(ply)
		net.Start("zgo2.Plant.UpdateActivity")
		net.WriteUInt(table.Count(zgo2.config.Plants), 32)

		for k, v in pairs(zgo2.config.Plants) do
			net.WriteUInt(k, 10)
			net.WriteUInt(v.Activity or 0, 32)
		end

		net.Send(ply)
	end

	net.Receive("zgo2.Plant.UpdateActivity", function(len,ply)
		zclib.Debug_Net("zgo2.Plant.UpdateActivity", len)
	    if zclib.Player.Timeout(nil,ply) == true then return end
		if not zclib.Player.IsAdmin(ply) then return end
		zgo2.Plant.SendActivityList(ply)
	end)
else
	function zgo2.Plant.RequestActivityList()
		net.Start("zgo2.Plant.UpdateActivity")
		net.SendToServer()
	end

	net.Receive("zgo2.Plant.UpdateActivity", function(len, ply)
		zclib.Debug_Net("zgo2.Plant.UpdateActivity", len)

		for i = 1, net.ReadUInt(32) do
			zgo2.config.Plants[ net.ReadUInt(10) ].Activity = net.ReadUInt(32) or 0
		end
	end)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher