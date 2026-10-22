--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Pot = zgo2.Pot or {}
zgo2.Pot.List = zgo2.Pot.List or {}

if not zgo2.config.Pot.TiltCheck then return end

/*

	This system checks if a pot got rotated and spill its dirt if tilted too far

*/

local timerid = "zgo2_pot_TiltChecker"
zclib.Timer.Remove(timerid)
zclib.Timer.Create(timerid, 3, 0, function()
	for Pot, _ in pairs(zgo2.Pot.List) do
		if not IsValid(Pot) then continue end
		if not Pot:GetHasSoil() then continue end
		local ang = Pot:GetAngles()

		if ang ~= Pot.LastAng then
			Pot.LastAng = ang

			if ang.x > 75 or ang.x < -75 or ang.z > 75 or ang.z < -75 then
				zclib.NetEvent.Create("zgo2_pot_expodedirt", { Pot:LocalToWorld(Pot:OBBCenter()) })

				zgo2.Pot.Reset(Pot)
			end
		end
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher