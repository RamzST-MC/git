-- leak by lordee
if (not SERVER) then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

////////////////////////////////////////////
//////////////// NW Timeout ////////////////
////////////////////////////////////////////
// How often are clients allowed to send net messages to the server
ZYB_NW_TIMEOUT = 0.1

function zyb.f.Player_Timeout(ply)
    local Timeout = false

    if ply.zyb_NWTimeout and ply.zyb_NWTimeout > CurTime() then
        zyb.f.Debug("Player_Timeout!")

        Timeout = true
    end

    ply.zyb_NWTimeout = CurTime() + ZYB_NW_TIMEOUT

    return Timeout
end
////////////////////////////////////////////
////////////////////////////////////////////





////////////////////////////////////////////
///////////// Player Initialize ////////////
////////////////////////////////////////////
if zyb_PlayerList == nil then
    zyb_PlayerList = {}
end

function zyb.f.Player_Add(ply)
    zyb_PlayerList[zyb.f.Player_GetID(ply)] = ply
end

function zyb.f.Player_Remove(steamid)
    zyb_PlayerList[steamid] = nil
end

util.AddNetworkString("zyb_Player_Initialize")
net.Receive("zyb_Player_Initialize", function(len, ply)

    if not IsValid(ply) then return end

    if ply.zyb_HasInitialized then
        return
    else
        ply.zyb_HasInitialized = true
    end

    zyb.f.Debug("zyb_Player_Initialize Netlen: " .. len)

    zyb.f.Player_Add(ply)
end)
////////////////////////////////////////////
////////////////////////////////////////////





hook.Add("GravGunOnDropped", "zyb_EntityAligment", function(ply, ent)
	if IsValid(ent) and (ent:GetClass() == "zyb_fermbarrel" or ent:GetClass() == "zyb_jarcrate" or ent:GetClass() == "zyb_jarpack") then
		local ang = ply:GetAngles()

		if ent:GetClass() == "zyb_jarcrate" then
			ang:RotateAroundAxis(ply:GetUp(), 90)
		else
			ang:RotateAroundAxis(ply:GetUp(), -90)
		end

		ent:SetAngles(Angle(ang.p, ang.y, 0))
	end
end)

hook.Add("PlayerDeath", "zyb_PlayerDeath", function(victim, inflictor, attacker)
	// Stops the screeneffect
	net.Start("zyb_stop_screeneffect")
	net.Send(victim)

	// Drops the moonshine if enabled
	if zyb.config.DropMoonshineOnDeath then
		zyb.f.PlayerDeath(victim, inflictor, attacker)
	end

	// Closes the interface if open
	zyb.f.ForceClose_UpgradeMenu(victim)
end)

function zyb.f.PlayerDeath(victim, inflictor, attacker)
	if IsValid(victim) and victim:zyb_GetMoonshineJars() > 0 then
		zyb.f.DropAllMoonshine(victim, victim:GetPos() + victim:GetUp() * 5)
	end
end

function zyb.f.DropMoonshine(jarcount, pos)
	local ent = ents.Create("zyb_jarcrate")
	ent:SetAngles(Angle(0, 0, 0))
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	ent:SetJarCount(jarcount)
end

function zyb.f.DropAllMoonshine(ply, pos)
	local jarCount = ply:zyb_GetMoonshineJars()
	local fullcrateCount = math.floor(jarCount / 6)

	for i = 1, fullcrateCount do
		zyb.f.DropMoonshine(6, pos + ply:GetUp() * 25 * i)
	end

	local restAmount = jarCount - (6 * fullcrateCount)

	if restAmount > 0 then
		zyb.f.DropMoonshine(restAmount, pos)
	end

	ply:zyb_Reset_MoonshineJar()
end

hook.Add("PlayerSay", "zyb_DropMoonshineCommand", function(aply, text)
	if string.sub(string.lower(text), 1, 14) == "!dropmoonshine" then
		local jarCount = aply:zyb_GetMoonshineJars()

		if jarCount > 0 then
			local trace = aply:GetEyeTrace()

			if trace.Hit and zyb.f.InDistance(aply:GetPos(), trace.HitPos, 300) then
				zyb.f.DropAllMoonshine(aply, trace.HitPos)
			end
		else
			zyb.f.Notify(aply, zyb.language.General["Inventoryempty"], 1)
		end
	end
end)

local entTable = {
    ["zyb_distillery"] = true,
    ["zyb_constructionkit_cooler"] = true,
    ["zyb_constructionkit_condenser"] = true,
    ["zyb_fermbarrel"] = true,
    ["zyb_fuel"] = true,
    ["zyb_jarpack"] = true,
    ["zyb_jarcrate"] = true,
    ["zyb_yeastgrinder"] = true,
    ["zyb_motor"] = true,
    ["zyb_paperbag"] = true,
    ["zyb_sugar"] = true,
    ["zyb_water"] = true,
    ["zyb_yeast"] = true,
    ["zyb_distillery_cooler"] = true,
    ["zyb_distillery_condenser"] = true,
    ["zyb_palette"] = true
}

function zyb.f.RemovePlayerEntities(ply)
    for k, v in pairs(zyb.EntList) do
        if IsValid(v) and entTable[v:GetClass()] and zyb.f.IsOwner(ply, v) then
            SafeRemoveEntity(v)
        end
    end
end

hook.Add("PlayerDisconnected", "zyb_PlayerDisconnected", function(ply)
    zyb.f.RemovePlayerEntities(ply)
end)

hook.Add("PlayerChangedTeam", "zyb_PlayerChangedTeam", function(ply, before, after)

	if zyb.config.MoonShine_Customer[before] then
		zyb.f.RemovePlayerEntities(ply)
	end
end)

local ply = FindMetaTable("Player")

function ply:zyb_AddMoonshineJarSold(mAmount)
	self.zyb_SoldMoonSineJars = self.zyb_SoldMoonSineJars or 0
	self.zyb_SoldMoonSineJars = self.zyb_SoldMoonSineJars + mAmount
end

function ply:zyb_GetMoonshineJarSold()
	return self.zyb_SoldMoonSineJars or 0
end

function ply:zyb_GetMoonshineJars()
	return self.zyb_MoonSineJars or 0
end

function ply:zyb_Reset_MoonshineJar()
	self.zyb_MoonSineJars = 0
end

function ply:zyb_Add_MoonshineJar(mAmount)
	zyb.f.Notify(self, "+" .. mAmount .. " " .. zyb.language.General["MoonshineJars"], 0)
	self.zyb_MoonSineJars = self.zyb_MoonSineJars or 0
	self.zyb_MoonSineJars = self.zyb_MoonSineJars + mAmount
end
-- leak by lordee