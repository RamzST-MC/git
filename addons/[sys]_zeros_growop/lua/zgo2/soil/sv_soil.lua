--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Soil = zgo2.Soil or {}
zgo2.Soil.List = zgo2.Soil.List or {}

function zgo2.Soil.OnUse(Soil,ply)

	// Start pointing system to ask where the seeds should be planted
	zgo2.Soil.Place(Soil,ply)
end

util.AddNetworkString("zgo2.Soil.Place")
function zgo2.Soil.Place(Soil,ply)
	net.Start("zgo2.Soil.Place")
	net.WriteEntity(Soil)
	net.Send(ply)
end

net.Receive("zgo2.Soil.Place", function(len,ply)
    zclib.Debug_Net("zgo2.Soil.Place", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Soil = net.ReadEntity()

	if not IsValid(Soil) then return end
	if Soil:GetClass() ~= "zgo2_soil" then return end
	if not zclib.util.InDistance(Soil:GetPos(),ply:GetPos(), 400) then return end
	if zclib.Entity.GettingRemoved(Soil) then return end

	local tr = ply:GetEyeTrace()
	if tr and tr.Entity and IsValid(tr.Entity) and tr.Entity:GetClass() == "zgo2_pot" and not tr.Entity:GetHasSoil() then
		zclib.Entity.SafeRemove(Soil)
		zgo2.Pot.AddSoil(tr.Entity)
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher