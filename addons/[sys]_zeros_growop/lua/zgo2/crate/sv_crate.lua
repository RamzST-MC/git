--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Crate = zgo2.Crate or {}
zgo2.Crate.List = zgo2.Crate.List or {}

/*

	Players can use crates to easly move multiple weedbranches

*/

function zgo2.Crate.Initialize(Crate)
	Crate:SetModel(Crate.Model)
	Crate:PhysicsInit(SOLID_VPHYSICS)
	Crate:SetSolid(SOLID_VPHYSICS)
	Crate:SetMoveType(MOVETYPE_VPHYSICS)
	Crate:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	Crate:SetUseType(SIMPLE_USE)
	local phy = Crate:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(true)
	end

	zclib.EntityTracker.Add(Crate)

	zgo2.Crate.List[Crate] = true

	zgo2.Destruction.SetupHealth(Crate)
end

/*
	Called when something touches the entity
*/
function zgo2.Crate.OnTouch(Crate,other)
	if not IsValid(Crate) then return end
    if not IsValid(other) then return end
	if zclib.util.CollisionCooldown(other) then return end

	if other:GetClass() == "zgo2_weedbranch" then
		timer.Simple(0.1,function()
			if not IsValid(Crate) then return end
			if not IsValid(other) then return end
			zgo2.Crate.AddWeed(Crate,other)
		end)
	end
end

/*
	Called when someone press e on the Crate
*/
local vec01 = Vector(-50,0,25)
function zgo2.Crate.OnUse(Crate, ply)
	if Crate.NextUse and CurTime() < Crate.NextUse then return end
	Crate.NextUse = CurTime() + 0.25

	if zgo2.Weedbranch.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		return
	end

	if Crate.WeedBranches == nil then Crate.WeedBranches = {} end

	// Drop one weed stick from the crate
	local id
	for k,v in pairs(Crate.WeedBranches) do
		if v then
			if id then
				// Lets find the weedbranch with the highest spot (The one on top of the crate)
				if k > id then
					id = k
				end
			else
				id = k
			end
		end
	end
	if not id then return end
	local data = Crate.WeedBranches[id]
	if not data then return end

	// Remove branch from crate
	Crate.WeedBranches[id] = nil

	// Spawn branch
	local ent = ents.Create("zgo2_weedbranch")
	if not IsValid(ent) then return end
	ent:SetPos(Crate:LocalToWorld(vec01))
	ent:Spawn()
	ent:Activate()

	ent:SetPlantID(data.id)
	ent.WeedAmount = data.amount
	ent.WeedTHC = data.thc

	if data.dried then zgo2.Weedbranch.SetDry(ent) end

	zclib.Player.SetOwner(ent, ply)

	zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_plant_hang")

	zgo2.Crate.Update(Crate)
end

/*
	Find a free spot
*/
function zgo2.Crate.GetFreeSpot(Crate)
	local spot
	for i=1,#zgo2.Crate.Spots do
		if not Crate.WeedBranches[i] then
			spot = i
			break
		end
	end
	return spot
end

/*
	Adds a weebranch to the Crate
*/
function zgo2.Crate.AddWeed(Crate,WeedBranch)

	if zclib.Entity.GettingRemoved(WeedBranch) then return end

	if Crate.WeedBranches == nil then Crate.WeedBranches = {} end

	// Do we have a free spot?
	local spot = zgo2.Crate.GetFreeSpot(Crate)
	if not spot then return end

	DropEntityIfHeld(WeedBranch)
	WeedBranch:SetNoDraw(true)

	timer.Simple(0.25,function()
		if not IsValid(WeedBranch) then return end
		if not IsValid(Crate) then return end

		// Do we have a free spot?
		spot = zgo2.Crate.GetFreeSpot(Crate)

		// We didnt find a free spot so make the entity visible again
		if not spot then
			WeedBranch:SetNoDraw(false)
			return
		end

		Crate.WeedBranches[spot] = {
			id =  WeedBranch:GetPlantID(),
			amount = WeedBranch.WeedAmount or 50,
			thc = WeedBranch.WeedTHC or 50,
			dried = WeedBranch:GetIsDried() == true
		}

		zclib.Entity.SafeRemove(WeedBranch)

		// Send a net message to all clients informing them that the weedbanch count changed
		zgo2.Crate.Update(Crate)
	end)

	Crate:EmitSound("zgo2_crate_addweed")
end

/*
	Send a net message to all clients informing them that the weedbanch count changed
*/
util.AddNetworkString("zgo2.Crate.Update")
function zgo2.Crate.Update(Crate)
	net.Start("zgo2.Crate.Update",true)
	net.WriteEntity(Crate)
	net.WriteUInt(table.Count(Crate.WeedBranches),20)
	for spot,data in pairs(Crate.WeedBranches) do
		net.WriteUInt(spot,20)
		net.WriteUInt(data.id,20)
		net.WriteUInt(data.amount,20)
		net.WriteBool(data.dried)
	end
	net.Broadcast()
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher