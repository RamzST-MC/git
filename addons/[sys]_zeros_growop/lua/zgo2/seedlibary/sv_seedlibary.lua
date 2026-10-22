--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.SeedLibary = zgo2.SeedLibary or {}

/*

	The seedlibary stores the players seeds

*/

function zgo2.SeedLibary.Initialize(SeedLibary)
	zgo2.Destruction.SetupHealth(SeedLibary)
end

function zgo2.SeedLibary.USE(SeedLibary,ply)
	zgo2.SeedLibary.Open(SeedLibary,ply)
end

function zgo2.SeedLibary.OnTouch(SeedLibary,other)
	if not IsValid(SeedLibary) then return end
    if not IsValid(other) then return end
	if zclib.util.CollisionCooldown(other) then return end

	if other:GetClass() ~= "zgo2_seed" then return end

	timer.Simple(0.1,function()
		if not IsValid(SeedLibary) then return end
		if not IsValid(other) then return end
		zgo2.SeedLibary.AddSeed(SeedLibary,other)
	end)
end

function zgo2.SeedLibary.GetFreeSpot(ply)
	if not ply.zgo2_seedlibary then
		ply.zgo2_seedlibary = {}
	end

	local FoundID
	for i = 1, 10 do
		if not ply.zgo2_seedlibary[ i ] then
			FoundID = i
			break
		end
	end

	return FoundID
end

function zgo2.SeedLibary.AddSeed(SeedLibary,Seed)

	if zclib.Entity.GettingRemoved(Seed) then return end

	local ply = zclib.Player.GetOwner(SeedLibary)
	if not ply then return end

	// Do we have a free spot?
	local spot = zgo2.SeedLibary.GetFreeSpot(ply)
	if not spot then return end

	DropEntityIfHeld(Seed)
	Seed:SetNoDraw(true)

	timer.Simple(0.25,function()
		if not IsValid(Seed) then return end
		if not IsValid(SeedLibary) then return end

		// Do we have a free spot?
		spot = zgo2.SeedLibary.GetFreeSpot(ply)

		// We didnt find a free spot so make the entity visible again
		if not spot then
			Seed:SetNoDraw(false)
			return
		end

		ply.zgo2_seedlibary[ spot ] = {
			id = zgo2.Plant.GetID(Seed:GetPlantID()),
			count = Seed:GetCount(),
		}

		zclib.Entity.SafeRemove(Seed)
	end)
end

util.AddNetworkString("zgo2.SeedLibary.Open")
function zgo2.SeedLibary.Open(SeedLibary,ply)
	if not ply.zgo2_seedlibary then ply.zgo2_seedlibary = {} end

	// Send the player the current activity list
	zgo2.Plant.SendActivityList(ply)

	local ToSend = {}
	for k,v in pairs(ply.zgo2_seedlibary) do
		local ListID = zgo2.Plant.GetListID(v.id)
		if not ListID then continue end

		local PlantData = zgo2.config.Plants[ListID]
		if not PlantData then continue end

		ToSend[k] = {id = v.id,count = v.count}
	end

	net.Start("zgo2.SeedLibary.Open")
	net.WriteEntity(SeedLibary)
	net.WriteUInt(table.Count(ToSend),32)
	for k,v in pairs(ToSend) do
		net.WriteUInt(k,32)
		net.WriteString(v.id)
		net.WriteUInt(v.count,32)
	end
	net.Send(ply)
end

util.AddNetworkString("zgo2.SeedLibary.Drop")
net.Receive("zgo2.SeedLibary.Drop", function(len,ply)
	zclib.Debug_Net("zgo2.SeedLibary.Drop", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local SeedLibary = net.ReadEntity()
	local SlotID = net.ReadUInt(32)

	if not IsValid(SeedLibary) then return end
	if SeedLibary:GetClass() ~= "zgo2_seedlibary" then return end

	if not ply.zgo2_seedlibary then ply.zgo2_seedlibary = {} end

	local SlotData = ply.zgo2_seedlibary[SlotID]
	if not SlotData then return end

	local ent = ents.Create("zgo2_seed")
	ent:SetPos(SeedLibary:GetPos() + zclib.util.GetRandomPositionInsideCircle(25, 70, 15))
	ent:SetAngles(Angle(0, math.random(360), 0))
	ent:SetPlantID(zgo2.Plant.GetListID(SlotData.id))
	ent:SetCount(SlotData.count)
	zclib.Player.SetOwner(ent, ply)
	ent:Spawn()
	ent:Activate()

	ply.zgo2_seedlibary[SlotID] = nil

	zgo2.SeedLibary.Open(SeedLibary,ply)
end)

util.AddNetworkString("zgo2.SeedLibary.ResetInactivity")
net.Receive("zgo2.SeedLibary.ResetInactivity", function(len,ply)
	zclib.Debug_Net("zgo2.SeedLibary.ResetInactivity", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

	if not zgo2.config.SeedLibary.InactivityReset then return end

	if not ply.zgo2_seedlibary then ply.zgo2_seedlibary = {} end

	for k,v in pairs(ply.zgo2_seedlibary) do
		local ListID = zgo2.Plant.GetListID(v.id)
		if not ListID then continue end

		local PlantData = zgo2.config.Plants[ListID]
		if not PlantData then continue end

		if not zgo2.Plant.IsSplice(v.id) then continue end

		zgo2.Plant.SetActive(v.id)
	end

	zgo2.Plant.SendActivityList(ply)

	net.Start("zgo2.SeedLibary.ResetInactivity")
	net.Send(ply)
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher