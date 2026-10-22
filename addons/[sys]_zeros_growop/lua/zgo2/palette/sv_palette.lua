--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
if not SERVER then return end
zgo2 = zgo2 or {}
zgo2.Palette = zgo2.Palette or {}

function zgo2.Palette.Initialize(Palette)
	Palette:SetModel(Palette.Model)
	Palette:PhysicsInit(SOLID_VPHYSICS)
	Palette:SetSolid(SOLID_VPHYSICS)
	Palette:SetMoveType(MOVETYPE_VPHYSICS)
	Palette:SetUseType(SIMPLE_USE)

	local phy = Palette:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(true)
	end

	zclib.EntityTracker.Add(Palette)

    Palette.WeedList = {}

    Palette.LastWeedChange = CurTime()

	zgo2.Destruction.SetupHealth(Palette)
end

function zgo2.Palette.OnRemove(Palette)
    zclib.EntityTracker.Remove(Palette)
end

local offset = Vector(80,0,50)
function zgo2.Palette.OnUse(Palette, ply)
	if Palette.Destroyed then return end

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

    if Palette.LastWeedChange and CurTime() < (Palette.LastWeedChange + 0.5) then return end
	Palette.LastWeedChange = CurTime()

	// Find a weedblock to drop
    local valid_data,valid_key
    for k,weedid in pairs(Palette.WeedList) do
        if weedid and k then
            valid_data = weedid
            valid_key = k
        end
    end
    if not valid_data or not valid_key then return end

	// Check if the player is even allowed to drop one
	if zgo2.Weedblock.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		return
	end

	// Remove from Palette weedlist
	table.remove(Palette.WeedList,valid_key)

	// Spawn entity
    local ent = ents.Create("zgo2_weedblock")
    if not IsValid(ent) then return end
    ent:SetPos(Palette:LocalToWorld(offset))
    ent:SetAngles(angle_zero)
    ent:Spawn()
    ent:Activate()
    ent:SetWeedID(valid_data)
    zclib.Player.SetOwner(ent, ply)

	// Update Palette on clients
    zgo2.Palette.Update(Palette)

    Palette:EmitSound("zgo2_jar_place")
end

function zgo2.Palette.OnStartTouch(Palette,other)
    if not IsValid(Palette) then return end
    if not IsValid(other) then return end
	if Palette.Destroyed then return end
    if Palette.LastWeedChange and CurTime() < (Palette.LastWeedChange + 0.1) then return end
    if zclib.util.CollisionCooldown(other) then return end
    if table.Count(Palette.WeedList) >= zgo2.config.Palette.Limit then return end

    if other:GetClass() ~= "zgo2_weedblock" then return end

    zgo2.Palette.AddWeed(Palette,other)
    Palette.LastWeedChange = CurTime()
    Palette:EmitSound("zgo2_crate_place")
end

function zgo2.Palette.AddWeed(Palette,Weedblock)
    zclib.Debug("zgo2.Palette.AddWeed")

	if zclib.Entity.GettingRemoved(Weedblock) then return end

    // Stop moving if you have physics
    -- if IsValid(Weedblock) and Weedblock.PhysicsDestroy then Weedblock:PhysicsDestroy() end

    // Hide entity
    if Weedblock.SetNoDraw then Weedblock:SetNoDraw(true) end

	timer.Simple(0.1, function()
		if IsValid(Weedblock) and IsValid(Palette) then
			table.insert(Palette.WeedList, Weedblock:GetWeedID())
			zgo2.Palette.Update(Palette)
			zclib.Entity.SafeRemove(Weedblock)
		end
	end)
end

util.AddNetworkString("zgo2_Palette_Update")
function zgo2.Palette.Update(Palette)
	local count = table.Count(Palette.WeedList)
	net.Start("zgo2_Palette_Update")
	net.WriteEntity(Palette)
	net.WriteUInt(table.Count(Palette.WeedList), 32)

	for i = 1, count do
		net.WriteUInt(Palette.WeedList[ i ], 32)
	end

	net.Broadcast()
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher