--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Jar = zgo2.Jar or {}
zgo2.Jar.List = zgo2.Jar.List or {}

/*

	The weed jar holds weed

*/
function zgo2.Jar.Initialize(Jar)
	zgo2.Jar.UpdateBodygroups(Jar)
	zclib.EntityTracker.Add(Jar)
	zgo2.Destruction.SetupHealth(Jar)
	zgo2.Jar.List[ Jar ] = true

	// Keep track on which weed just got used
	zgo2.Plant.SetActive(Jar:GetWeedID())
end

/*
	Updates the bodygroups of the jar
*/
function zgo2.Jar.UpdateBodygroups(Jar)
	Jar:SetBodygroup(0, 0)
	Jar:SetBodygroup(1, 0)
	Jar:SetBodygroup(2, 0)
	Jar:SetBodygroup(3, 0)
	Jar:SetBodygroup(4, 0)

	if Jar:GetWeedAmount() > 0 then
		local bg = math.Clamp(math.Round((5 / zgo2.config.Jar.Capacity) * Jar:GetWeedAmount()),1,5)
		for i = 0, bg-1 do Jar:SetBodygroup(i, 1) end
	end
end

/*
	Called when something touches the entity
*/
function zgo2.Jar.OnTouch(Jar,other)
	if not IsValid(Jar) then return end
    if not IsValid(other) then return end
	if zclib.util.CollisionCooldown(other) then return end

	if other:GetClass() == "zgo2_jar" then

		if Jar.NextTouch and CurTime() < Jar.NextTouch then return end
		Jar.NextTouch = CurTime() + 0.5

		if other.NextTouch and CurTime() < other.NextTouch then return end
		other.NextTouch = CurTime() + 0.5

		timer.Simple(0.1,function()
			if not IsValid(Jar) then return end
			if not IsValid(other) then return end
			zgo2.Jar.Merge(Jar, other)
		end)
	end
end

/*
	Merges the content from Jar01 in to Jar02
*/
function zgo2.Jar.Merge(Jar01, Jar02)

	if zclib.Entity.GettingRemoved(Jar01) then return end
	if zclib.Entity.GettingRemoved(Jar02) then return end

	local jar01_weed_id = Jar01:GetWeedID()
	local jar01_weed_amount = Jar01:GetWeedAmount()

	local jar02_weed_id = Jar02:GetWeedID()
	local jar02_weed_amount = Jar02:GetWeedAmount()

	// Make sure empty jars cant merge if the other jar is full
	if jar01_weed_amount >= zgo2.config.Jar.Capacity and jar02_weed_amount <= 0 then return end
	if jar02_weed_amount >= zgo2.config.Jar.Capacity and jar01_weed_amount <= 0 then return end

	// If both jars are empty then stop
	if jar01_weed_id <= 0 and jar02_weed_id <= 0 then return end

	// If both jars have weed but with diffrent ids then stop
	if jar01_weed_id > 0 and jar02_weed_id > 0 and jar01_weed_id ~= jar02_weed_id then return end

	// Hove much free space has Jar02
	local FreeSpace = zgo2.config.Jar.Capacity - jar02_weed_amount
	if FreeSpace <= 0 then return end

	// How much weed can we take from Jar01
	local MoveAmount = math.Clamp(jar01_weed_amount,0,FreeSpace)

	DropEntityIfHeld(Jar01)
	DropEntityIfHeld(Jar02)

	if (jar01_weed_amount - MoveAmount) <= 0 then
		zclib.Entity.SafeRemove(Jar01)
	else
		Jar01:SetWeedAmount(jar01_weed_amount - MoveAmount)
		zgo2.Jar.UpdateBodygroups(Jar01)
	end

	Jar02:SetWeedID(jar01_weed_id)
	Jar02:SetWeedAmount(Jar02:GetWeedAmount() + MoveAmount)
	zgo2.Jar.UpdateBodygroups(Jar02)
end

/*
	Adds weed to the jar
*/
function zgo2.Jar.AddWeed(Jar, id, amount,thc)
	if not IsValid(Jar) then return end
	if Jar:GetWeedID() > 0 and Jar:GetWeedID() ~= id then return end

	Jar:SetWeedID(id)
	Jar:SetWeedAmount(math.Clamp(Jar:GetWeedAmount() + amount, 0, zgo2.config.Jar.Capacity))

	if Jar:GetWeedTHC() > 0 then
		Jar:SetWeedTHC((Jar:GetWeedTHC() + thc) / 2)
	else
		Jar:SetWeedTHC(thc)
	end

	zgo2.Plant.UpdateMaterial(Jar)

	timer.Simple(1,function()
		if not IsValid(Jar) then return end
		zgo2.Jar.UpdateBodygroups(Jar)
	end)
end

/*
	Use action
*/
util.AddNetworkString("zgo2.Jar.Split")
function zgo2.Jar.OnUse(Jar,ply)

	local par = Jar:GetParent()
	if IsValid(par) and par:GetClass() == "zgo2_clipper" then
		if par.Unloading then return end

		// Check if the player is a weed grower
		if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

		zgo2.Clipper.DropJar(par)
		return
	end

	// Open split interface
	net.Start("zgo2.Jar.Split")
	net.WriteEntity(Jar)
	net.Send(ply)
end
net.Receive("zgo2.Jar.Split", function(len,ply)
	zclib.Debug_Net("zgo2.Jar.Split", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Jar = net.ReadEntity()
	local amount = net.ReadUInt(32)
	local pos = net.ReadVector()

	if not IsValid(Jar) then return end
	if Jar:GetClass() ~= "zgo2_jar" then return end

	if not zclib.util.InDistance(Jar:GetPos(),ply:GetPos(), 1000) then return end
	if not zclib.util.InDistance(pos,ply:GetPos(), 300) then return end

	amount = math.Clamp(amount,0,Jar:GetWeedAmount())
	if not amount then return end

	if zgo2.Baggy.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language[ "Spawnlimit" ], 1)
		return
	end

	Jar:SetWeedAmount(Jar:GetWeedAmount() - amount)
	if Jar:GetWeedAmount() <= 0 then SafeRemoveEntity(Jar) end

	// Spawn weed baggy at position and remove it from
	local ent = ents.Create("zgo2_baggy")
	ent:SetPos(pos + Vector(0,0,40))
	ent:SetWeedID(Jar:GetWeedID())
	ent:SetWeedAmount(amount)
	ent:SetWeedTHC(Jar:GetWeedTHC())
	ent:Spawn()
	ent:Activate()

	zclib.Player.SetOwner(ent, ply)
end)

/*
	Checks if the player is allowed to spawn another jar
*/
function zgo2.Jar.ReachedSpawnLimit(ply)
	local count = 0
	for ent,_ in pairs(zgo2.Jar.List) do
		if IsValid(ent) and zclib.Player.IsOwner(ply, ent) then
			count = count + 1
		end
	end

	return count >= zgo2.config.Plant.spawnlimit_jar
end

concommand.Add("zgo2_spawn_jars", function(ply, cmd, args)
	if zclib.Player.IsAdmin(ply) then

		local tr = ply:GetEyeTrace()

		if tr and tr.Hit and tr.HitPos then

			undo.Create("zgo2_spawn_jars")

			local count = 0
			for i = 1, 25 do

				local ent = ents.Create("zgo2_jar")
				ent:SetPos(tr.HitPos + zclib.util.GetRandomPositionInsideCircle(25, 120, 15))
				ent:SetAngles(Angle(0, math.random(360), 0))
				ent:SetWeedID(zgo2.Plant.GetRandomID())
				ent:SetWeedAmount(zgo2.config.Jar.Capacity)
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