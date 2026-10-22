--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.ScreenEffect = zgo2.ScreenEffect or {}

/*

	ScreenEffects are show when players get stoned

*/

util.AddNetworkString("zgo2.ScreenEffect.Start")
function zgo2.ScreenEffect.Start(WeedID,WeedTHC,Duration,ply)
	net.Start("zgo2.ScreenEffect.Start")
	net.WriteUInt(WeedID,32)
	net.WriteUInt(math.Round(WeedTHC),20)
	net.WriteFloat(Duration)
	net.Send(ply)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher