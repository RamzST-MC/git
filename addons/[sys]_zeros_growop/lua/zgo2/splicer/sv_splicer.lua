--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Splicer = zgo2.Splicer or {}
zgo2.Splicer.List = zgo2.Splicer.List or {}

/*

	Splicers are used to create new weedseeds from existing one

*/
function zgo2.Splicer.Initialize(Splicer)

	Splicer:SetModel(Splicer.Model)
	Splicer:PhysicsInit(SOLID_VPHYSICS)
	Splicer:SetSolid(SOLID_VPHYSICS)
	Splicer:SetMoveType(MOVETYPE_VPHYSICS)
	Splicer:SetUseType(SIMPLE_USE)

	local phy = Splicer:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Splicer)

	zgo2.Splicer.List[Splicer] = true

	zgo2.Destruction.SetupHealth(Splicer)

	// This will hold all the weeddata sets from the diffrent weedbranches
	Splicer.DataSets = {}
end

util.AddNetworkString("zgo2.Splicer.Open")
function zgo2.Splicer.OnUse(Splicer,ply)

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	if Splicer:GetSpliceStart() > 0 then return end

	net.Start("zgo2.Splicer.Open")
	net.WriteEntity(Splicer)
	net.Send(ply)
end

function zgo2.Splicer.OnTouch(Splicer, ent)
	if not IsValid(Splicer) then return end
	if not IsValid(ent) then return end
	if zclib.util.CollisionCooldown(ent) then return end

	if table.Count(Splicer.DataSets) >= zgo2.Splicer.ItemLimit then return end

	if ent:GetClass() == "zgo2_weedbranch" then

		if not zgo2.Splicer.CanUse(Splicer) then
			return
		end

		if zclib.Entity.GettingRemoved(ent) then return end

		timer.Simple(0.1,function()
			if not IsValid(Splicer) then return end
			if not IsValid(ent) then return end

			if table.Count(Splicer.DataSets) >= zgo2.Splicer.ItemLimit then return end

			// Add weedbranch
			zgo2.Splicer.AddWeed(Splicer, ent)

			DropEntityIfHeld(ent)
			zclib.Entity.SafeRemove(ent)
		end)
	end
end

function zgo2.Splicer.AddWeed(Splicer, ent)
	local WeedID = zgo2.Plant.GetID(ent:GetPlantID())
	local WeedData = zgo2.Plant.GetData(WeedID)
	if not WeedData then return end

	table.insert(Splicer.DataSets,WeedID)

	zgo2.Splicer.Update(Splicer)
end

function zgo2.Splicer.Update(Splicer, ply)
	net.Start("zgo2.Splicer.Update")
	net.WriteEntity(Splicer)
	net.WriteUInt(table.Count(Splicer.DataSets),8)
	for k,v in pairs(Splicer.DataSets) do
		net.WriteUInt(k,8)
		net.WriteString(tostring(v))
	end
	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

util.AddNetworkString("zgo2.Splicer.Update")
net.Receive("zgo2.Splicer.Update", function(len,ply)
	zclib.Debug_Net("zgo2.Splicer.Update", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Splicer = net.ReadEntity()

	if not IsValid(Splicer) then return end
	if Splicer:GetClass() ~= "zgo2_splicer" then return end

	if not zclib.util.InDistance(Splicer:GetPos(),ply:GetPos(), 1000) then return end

	zgo2.Splicer.Update(Splicer, ply)
end)

util.AddNetworkString("zgo2.Splicer.Clear")
net.Receive("zgo2.Splicer.Clear", function(len,ply)
	zclib.Debug_Net("zgo2.Splicer.Clear", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Splicer = net.ReadEntity()
	if not IsValid(Splicer) then return end
	if Splicer:GetClass() ~= "zgo2_splicer" then return end
	local SlotID = net.ReadUInt(8)

	if not zclib.util.InDistance(Splicer:GetPos(),ply:GetPos(), 1000) then return end

	zgo2.Splicer.Clear(Splicer, SlotID, ply)
end)
function zgo2.Splicer.Clear(Splicer,SlotID, ply)
	table.remove(Splicer.DataSets,SlotID)
	zgo2.Splicer.Update(Splicer)
end

util.AddNetworkString("zgo2.Splicer.Start")
net.Receive("zgo2.Splicer.Start", function(len,ply)
	zclib.Debug_Net("zgo2.Splicer.Start", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Splicer = net.ReadEntity()
	local name = net.ReadString()
	if not IsValid(Splicer) then return end
	if Splicer:GetClass() ~= "zgo2_splicer" then return end

	if not name then return end
	if string.len(name) < 3 then
		return
	end
	if string.len(name) > 20 then
		return
	end

	if not zclib.util.InDistance(Splicer:GetPos(),ply:GetPos(), 1000) then return end


	if not zgo2.Splicer.CanUse(Splicer) then
		return
	end

	zgo2.Splicer.Start(Splicer,name, ply)
end)

local function MashUpData(Splicer,ply,NewData,ListKey)

	// Get all values from the current key and choose one at random
	for key,value in pairs(NewData[ListKey]) do

		if istable(value) and not value.r and not value.x then

			for k,v in pairs(value) do

				local rnd = {}
				for slotid,weedid in pairs(Splicer.DataSets) do
					if not zgo2.Splicer.CanSplice(Splicer,ply,slotid) then continue end

					local weeddata = zgo2.Plant.GetData(weedid)
					if not weeddata then continue end

					local val = weeddata[ListKey][key][k]
					if not val then continue end

					table.insert(rnd,val)
				end

				NewData[ListKey][key][k] = rnd[math.random(#rnd)]
			end

		else
			local rnd = {}
			for slotid,weedid in pairs(Splicer.DataSets) do
				if not zgo2.Splicer.CanSplice(Splicer,ply,slotid) then continue end

				local weeddata = zgo2.Plant.GetData(weedid)
				if not weeddata then continue end

				local val = weeddata[ListKey][key]
				if not val then continue end

				table.insert(rnd,val)
			end
			NewData[ListKey][key] = rnd[math.random(#rnd)]
		end
	end
	return NewData
end

zgo2.Splicer.Cooldown = zgo2.Splicer.Cooldown or {}
function zgo2.Splicer.Start(Splicer,name, ply)
	local id64 = ply:SteamID64()

	if zgo2.Splicer.Cooldown[ id64 ] and zgo2.Splicer.Cooldown[ id64 ] > CurTime() then
		zclib.Notify(ply, zgo2.language["Cooldown"] .. " " .. string.FormattedTime(zgo2.Splicer.Cooldown[ id64 ] - CurTime(), "%02i:%02i"), 1)
		return
	end

	if Splicer:GetSpliceStart() > 0 then return end

	// Do we have enough data sets?
	if not zgo2.Splicer.HasEnoughSpliceData(Splicer,ply) then return end

	// Do we have enough money?
	local cost = zgo2.Splicer.GetCost(Splicer)
	if not zclib.Money.Has(ply, cost) then return end

	// Set the cooldown
	zgo2.Splicer.Cooldown[ id64 ] = CurTime() + zgo2.config.Splicer.Cooldown

	zclib.Money.Take(ply, cost)

	// Set the splicer in to Splicing State
	Splicer:SetSpliceStart(CurTime())

	/////////////////////////////////////////////
	// Generate new data set
	local NewData = zgo2.Plant.VerifyData({})

	// Mash up the data
	NewData = MashUpData(Splicer,ply,NewData,"style")
	NewData = MashUpData(Splicer,ply,NewData,"grow")
	NewData = MashUpData(Splicer,ply,NewData,"screeneffect")
	NewData = MashUpData(Splicer,ply,NewData,"weed")

	// Some generic value
	NewData = MashUpData(Splicer,ply,NewData,"sell")

	NewData.name = name
	NewData.creator_id = id64
	NewData.creator_name = ply:Nick()
	NewData.creator_rank = zclib.Player.GetRank(ply)

	// Create new plant config
	local uniqueid = zgo2.Plant.CreateSplice(NewData)

	zgo2.Print(ply:Nick() .. " created a new weedplant type " .. uniqueid)

	// Remove the Weedbranches and update clients
	Splicer.DataSets = {}

	// Update visuals on clients
	timer.Simple(2,function() if IsValid(Splicer) then zgo2.Splicer.Update(Splicer) end end)

	// Tell the system that the new plant just got active
	zgo2.Plant.SetActive(uniqueid)
	/////////////////////////////////////////////

	Splicer:SetSpliceID(zgo2.Plant.GetListID(uniqueid))

	// Start splicing timer
	local timerid = "zgo2.Splicer.Start"..Splicer:EntIndex()
	zclib.Timer.Remove(timerid)
	zclib.Timer.Create(timerid, zgo2.config.Splicer.SpliceTime, 1, function() zgo2.Splicer.Finish(Splicer,uniqueid, ply) end)
end

function zgo2.Splicer.Finish(Splicer,uniqueid, ply)
	if not IsValid(Splicer) then return end

	local ent = ents.Create("zgo2_seed")
	ent:SetPos(Splicer:LocalToWorld(Vector(0, 5, 50)))
	ent:SetAngles(Splicer:LocalToWorldAngles(Angle(0, -90, -90)))
	ent:Spawn()
	ent:Activate()
	ent:SetPlantID(zgo2.Plant.GetListID(uniqueid))
	ent:SetCount(zgo2.config.Seedbox.Count)
	zclib.Player.SetOwner(ent, ply)

	Splicer:SetSpliceStart(-1)
	Splicer:SetSpliceID(-1)
end

/*
local delay = 0
for i = 1, 50 do
	timer.Simple(delay, function()
		local data = zgo2.Plant.VerifyData({})
		data = zgo2.Plant.RandomizeData(data)
		data.name = "Test Plant"
		data.creator_id = "509854069809"
		data.creator_name = "Jack"
		data.creator_rank = "vip"
		local uniqueid = zgo2.Plant.CreateSplice(data)
		zgo2.Plant.SetActive(uniqueid)
	end)
	delay = delay + 0.1
end
*/
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher