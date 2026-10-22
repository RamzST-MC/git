--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
if not SERVER then return end
zgo2 = zgo2 or {}
zgo2.Sniffer = zgo2.Sniffer or {}

util.AddNetworkString("zgo2_sniffer_check")
function zgo2.Sniffer.Primary(ply)
	net.Start("zgo2_sniffer_check")
	net.Send(ply)
	zclib.Sound.EmitFromEntity("zgo2_sniff", ply)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher