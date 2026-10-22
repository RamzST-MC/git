--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Weedblock = zgo2.Weedblock or {}
zgo2.Weedblock.List = zgo2.Weedblock.List or {}

/*

	Weedblocks can hold more weed then jars

*/

function zgo2.Weedblock.Initialize(Weedblock)
	Weedblock:SetUseType(CONTINUOUS_USE)

	zgo2.Destruction.SetupHealth(Weedblock)

	zgo2.Weedblock.List[Weedblock] = true

	// Keep track on which weed just got used
	zgo2.Plant.SetActive(Weedblock:GetWeedID())
end

function zgo2.Weedblock.OnUse(Weedblock, ply)

	zgo2.Destruction.SetupHealth(Weedblock)

	Weedblock:SetProgress(Weedblock:GetProgress() + 1)

	if Weedblock:GetProgress() >= 100 then
		zgo2.Weedblock.SplittToJars(Weedblock,ply)
	end

	zclib.Timer.Remove("zgo2_weedblock_use_" .. Weedblock:EntIndex())

	zclib.Timer.Create("zgo2_weedblock_use_" .. Weedblock:EntIndex(), 1, 1, function()
		if IsValid(Weedblock) then
			Weedblock:SetProgress(0)
		end
	end)
end

function zgo2.Weedblock.SplittToJars(Weedblock,ply)

	if zgo2.Jar.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		return
	end

	if Weedblock.IsSplitting then return end
	Weedblock.IsSplitting = true

	local id = Weedblock:GetWeedID()
	local amount = zgo2.config.Packer.Capacity

	if id <= 0 then return end
	if amount <= 0 then return end

	local count = math.Round(amount / zgo2.config.Jar.Capacity)
	for i = 1, count do
		local ent = ents.Create("zgo2_jar")
		ent:SetPos(Weedblock:GetPos() + zclib.util.GetRandomPositionInsideCircle(25, 50, 15))
		ent:SetWeedID(id)
		ent:SetWeedAmount(zgo2.config.Jar.Capacity)
		ent:SetWeedTHC(50)
		ent:Spawn()
		ent:Activate()
		zclib.Player.SetOwner(ent, ply)
	end

	zclib.Entity.SafeRemove(Weedblock)
end

/*
	Checks if the player is allowed to spawn another weedblock
*/
function zgo2.Weedblock.ReachedSpawnLimit(ply)
	local count = 0
	for ent,_ in pairs(zgo2.Weedblock.List) do
		if IsValid(ent) and zclib.Player.IsOwner(ply, ent) then
			count = count + 1
		end
	end

	return count >= zgo2.config.Plant.spawnlimit_weedblock
end

concommand.Add("zgo2_spawn_weedblocks", function(ply, cmd, args)
	if zclib.Player.IsAdmin(ply) then

		local tr = ply:GetEyeTrace()

		if tr and tr.Hit and tr.HitPos then

			undo.Create("zgo2_spawn_weedblocks")

			local count = 0
			for i = 1, 8 do

				local ent = ents.Create("zgo2_weedblock")
				ent:SetPos(tr.HitPos + zclib.util.GetRandomPositionInsideCircle(25, 120, 15))
				ent:SetAngles(Angle(0, math.random(360), 0))
				ent:SetWeedID(zgo2.Plant.GetRandomID())
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