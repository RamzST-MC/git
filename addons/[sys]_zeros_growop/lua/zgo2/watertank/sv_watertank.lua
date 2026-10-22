--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Watertank = zgo2.Watertank or {}
zgo2.Watertank.List = zgo2.Watertank.List or {}

/*

	Watertanks provide water and refill over time

*/
function zgo2.Watertank.Initialize(Watertank)
	local dat = zgo2.Watertank.GetData(Watertank:GetWatertankID())
	Watertank:SetModel(dat.mdl)
	Watertank:PhysicsInit(SOLID_VPHYSICS)
	Watertank:SetSolid(SOLID_VPHYSICS)
	Watertank:SetMoveType(MOVETYPE_VPHYSICS)
	Watertank:SetUseType(SIMPLE_USE)

	local phy = Watertank:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Watertank)

	zgo2.Watertank.List[Watertank] = true

	zgo2.Destruction.SetupHealth(Watertank)
end

function zgo2.Watertank.OnUse(Watertank,ply)

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	net.Start("zgo2.Watertank.Use")
	net.WriteEntity(Watertank)
	net.Send(ply)
end

util.AddNetworkString("zgo2.Watertank.Use")
net.Receive("zgo2.Watertank.Use", function(len,ply)
    zclib.Debug_Net("zgo2.Watertank.Use", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local watertank = net.ReadEntity()
	local pot = net.ReadEntity()

	if not IsValid(watertank) then return end
	if watertank:GetClass() ~= "zgo2_watertank" then return end

	// How much water does the tank have?
	local water = zgo2.Watertank.GetUseWater(watertank)
	if water <= 0 then return end

	watertank:SetWater(math.Clamp(watertank:GetWater() - water, 0, zgo2.Watertank.GetCapacity(watertank)))

	if not IsValid(pot) then return end
	if pot:GetClass() ~= "zgo2_pot" then return end

	local center = (watertank:GetPos() + pot:GetPos()) / 2

	if not zclib.util.InDistance(center,ply:GetPos(), 400) then return end

	zgo2.Pot.AddWater(pot,water)
end)

/*
	Refill the watertank over time
*/
function zgo2.Watertank.Refill()
	for ent, _ in pairs(zgo2.Watertank.List) do
		if not IsValid(ent) then continue end
		ent:SetWater(math.Clamp(ent:GetWater() + zgo2.Watertank.GetRefillRate(ent), 0, zgo2.Watertank.GetCapacity(ent)))
	end
end
zclib.Timer.Remove("zgo2_Watertank_logic")
zclib.Timer.Create("zgo2_Watertank_logic", 1, 0, function()
	zgo2.Watertank.Refill()
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher