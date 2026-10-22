--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Baggy = zgo2.Baggy or {}
zgo2.Baggy.List = zgo2.Baggy.List or {}

/*

	The weed baggies holds weed

*/
function zgo2.Baggy.Initialize(Baggy)

	zclib.EntityTracker.Add(Baggy)
	zgo2.Destruction.SetupHealth(Baggy)

	zgo2.Baggy.List[ Baggy ] = true

	// Keep track on which weed just got used
	zgo2.Plant.SetActive(Baggy:GetWeedID())
end

/*
	Checks if the player is allowed to spawn another Baggy
*/
function zgo2.Baggy.ReachedSpawnLimit(ply)
	local count = 0
	for ent,_ in pairs(zgo2.Baggy.List) do
		if IsValid(ent) and zclib.Player.IsOwner(ply, ent) then
			count = count + 1
		end
	end

	return count >= zgo2.config.Plant.spawnlimit_baggy
end

concommand.Add("zgo2_spawn_baggies", function(ply, cmd, args)
	if zclib.Player.IsAdmin(ply) then

		local tr = ply:GetEyeTrace()

		if tr and tr.Hit and tr.HitPos then

			undo.Create("zgo2_spawn_baggies")

			local count = 0
			for i = 1, 25 do

				local ent = ents.Create("zgo2_baggy")
				ent:SetPos(tr.HitPos + zclib.util.GetRandomPositionInsideCircle(25, 120, 15))
				ent:SetAngles(Angle(0, math.random(360), 0))
				ent:SetWeedID(zgo2.Plant.GetRandomID())
				ent:SetWeedAmount(zgo2.config.Baggy.Capacity)
				ent:SetWeedTHC(100)
				zclib.Player.SetOwner(ent, ply)
				ent:Spawn()
				ent:Activate()
				undo.AddEntity(ent)
				undo.SetPlayer(ply)

				count = count + 1
			end

			undo.Finish()
		end
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher