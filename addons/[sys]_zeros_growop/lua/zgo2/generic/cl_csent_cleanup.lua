--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
	Quick system to cleanup client models out of distance
*/
zgo2.ClientModels = zgo2.ClientModels or {}
zclib.Timer.Remove("zgo2_clientmodel_cleanup")

zclib.Timer.Create("zgo2_clientmodel_cleanup", 10, 0, function()
	if zgo2.ClientModels then
		for _, ent in pairs(zgo2.ClientModels) do
			if not IsValid(ent) then continue end

			if not IsValid(ent:GetParent()) then
				ent:Remove()
				continue
			end

			if zclib.util.InDistance(ent:GetPos(), LocalPlayer():GetPos(), 1000) == false then
				ent:Remove()
			end
		end
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher