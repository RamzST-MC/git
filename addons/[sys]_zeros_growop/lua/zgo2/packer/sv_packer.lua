--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Packer = zgo2.Packer or {}
zgo2.Packer.List = zgo2.Packer.List or {}

/*

	The WeedPacker compresses weed jars in to weedpacks

*/

function zgo2.Packer.Initialize(Packer)
	Packer:SetModel(Packer.Model)
	Packer:PhysicsInit(SOLID_VPHYSICS)
	Packer:SetSolid(SOLID_VPHYSICS)
	Packer:SetMoveType(MOVETYPE_VPHYSICS)
	Packer:SetUseType(CONTINUOUS_USE)
	Packer:UseClientSideAnimation()

	local phy = Packer:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Packer)

	zgo2.Packer.List[Packer] = true

	zgo2.Destruction.SetupHealth(Packer)
end

function zgo2.Packer.OnUse(Packer,ply)

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	if Packer.NextTick and CurTime() < Packer.NextTick then return end
	Packer.NextTick = CurTime() + 0.20

	if Packer:GetProgress() <= 0 and Packer:OnDrop(ply) and Packer:GetWeedAmount() > 0 then
		zgo2.Packer.DropJar(Packer,ply)
		return
	end

	if not zgo2.Packer.CanPress(Packer,ply) then return end

	// Start pressing
	zgo2.Packer.StartPressCycle(Packer,ply)
end

/*
	Called when something touches the entity
*/
function zgo2.Packer.OnTouch(Packer,other)
	if not IsValid(Packer) then return end
    if not IsValid(other) then return end
	if zclib.util.CollisionCooldown(other) then return end

	if Packer.Unloading then return end

	if other:GetClass() == "zgo2_jar" then
		zgo2.Packer.AddWeed(Packer,other)
	end
end

/*
	Returns true if we can spin
*/
function zgo2.Packer.CanPress(Packer,ply)

	if Packer.Unloading then return false end

	// We are missing weed
	if Packer:GetWeedID() <= 0 then
		zclib.Notify(ply,zgo2.language[ "Missing Weed" ], 1)
		return false
	end

	// Do we still need more weed?
	if Packer:GetWeedAmount() < zgo2.config.Packer.Capacity then
		zclib.Notify(ply, zgo2.language[ "Packer_NeedMoreWeed" ] .. " [" .. Packer:GetWeedAmount() .. "/" .. zgo2.config.Packer.Capacity .. "]", 1)
		return false
	end

	return true
end

/*
	Starts the spin cycle
*/
local offset = Vector(0,0,21)
local offset02 = Vector(50,0,15)
function zgo2.Packer.StartPressCycle(Packer,ply)

	if not zgo2.Packer.CanPress(Packer) then return end

	if zgo2.Weedblock.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		return
	end

	// Increase the progress
	Packer:SetProgress(Packer:GetProgress() + 8)

	// Hide the weed junks so they dont glitch through the press
	if Packer:GetProgress() > 45 then
		Packer:SetBodygroup(0,0)
	end

	// We aint completed the progess yet
	if Packer:GetProgress() < 100 then return end

	Packer.Unloading = true

	// Set net var to make the press go back to idle open state
	Packer:SetProgress(0)
	Packer:SetWeedAmount(0)

	// Spawn weedblock
	local ent = ents.Create("zgo2_weedblock")
	ent:SetPos(Packer:LocalToWorld(offset))
	ent:SetAngles(Packer:GetAngles())
	ent:SetParent(Packer)
	ent:SetWeedID(Packer:GetWeedID())
	ent:Spawn()
	ent:Activate()
	zclib.Player.SetOwner(ent, ply)

	zclib.Sound.EmitFromEntity("zgo2_plant_cut", Packer)

	timer.Simple(1.5,function()
		if not IsValid(Packer) then return end

		zclib.Sound.EmitFromEntity("zgo2_plant_hang", Packer)

		// Move weed block in front of press and remove parent
		if IsValid(ent) then
			ent:SetParent(nil)
			ent:SetPos(Packer:LocalToWorld(offset02))
			ent:PhysWake()
		end

		zgo2.Packer.Reset(Packer)

		Packer.Unloading = nil
	end)
end

/*
	Drops the jar from the Packer
*/
function zgo2.Packer.DropJar(Packer,ply)

	if Packer.NextDrop and CurTime() < Packer.NextDrop then return end
	Packer.NextDrop = CurTime() + 0.8

	if zgo2.Jar.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		return
	end

	local amount = Packer:GetWeedAmount()
	if amount >= zgo2.config.Jar.Capacity then amount = zgo2.config.Jar.Capacity end

	local ent = ents.Create("zgo2_jar")
	ent:SetPos(Packer:LocalToWorld(offset02))
	ent:SetWeedID(Packer:GetWeedID())
	ent:SetWeedAmount(amount)
	ent:SetWeedTHC(50)
	ent:Spawn()
	ent:Activate()
	zclib.Player.SetOwner(ent, ply)

	Packer:SetWeedAmount(Packer:GetWeedAmount() - amount)

	if Packer:GetWeedAmount() <= 0 then
		zgo2.Packer.Reset(Packer)
	else
		local bg = (3 / zgo2.config.Packer.Capacity) * Packer:GetWeedAmount()
		bg = math.Clamp(math.Round(bg), 1, 3)
		Packer:SetBodygroup(0, math.Round(bg))
		zclib.Sound.EmitFromEntity("zgo2_plant_cut", Packer)
	end
end

/*
	Adds a weedbrach to the Packer
*/
function zgo2.Packer.AddWeed(Packer,Jar)

	if Jar:GetWeedAmount() <= 0 then return end

	// Do we already have a weed?
	if Packer:GetWeedID() > 0 and Jar:GetWeedID() ~= Packer:GetWeedID() then return end

	if Packer:GetWeedAmount() >= zgo2.config.Packer.Capacity then return end

	if zclib.Entity.GettingRemoved(Jar) then return end

	DropEntityIfHeld(Jar)

	Jar:SetNoDraw(true)

	timer.Simple(0.25,function()
		if not IsValid(Jar) then return end
		if not IsValid(Packer) then return end

		local prevAmount = Packer:GetWeedAmount()

		Packer:SetWeedID(Jar:GetWeedID())
		Packer:SetWeedAmount(Packer:GetWeedAmount() + Jar:GetWeedAmount())

		local bg = (3 / zgo2.config.Packer.Capacity) * Packer:GetWeedAmount()

		bg = math.Clamp(math.Round(bg),1,3)

		timer.Simple(prevAmount > 0 and 0 or 0.15,function()
			if not IsValid(Packer) then return end
			Packer:SetBodygroup(0,math.Round(bg))
			zclib.Sound.EmitFromEntity("zgo2_plant_cut", Packer)
		end)

		zclib.Entity.SafeRemove(Jar)
	end)
end

function zgo2.Packer.Reset(Packer)
	Packer:SetBodygroup(0,0)
	Packer:SetWeedAmount(0)
	Packer:SetWeedID(0)
	Packer:SetProgress(0)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher