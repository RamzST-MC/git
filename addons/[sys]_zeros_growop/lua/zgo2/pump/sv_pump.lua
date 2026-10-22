--ds - matveicher
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

zgo2 = zgo2 or {}
zgo2.Pump = zgo2.Pump or {}
zgo2.Pump.List = zgo2.Pump.List or {}

/*

	Pumps move water from watertanks to pots

*/
function zgo2.Pump.Initialize(Pump)
	Pump:SetModel(Pump.Model)
	Pump:PhysicsInit(SOLID_VPHYSICS)
	Pump:SetSolid(SOLID_VPHYSICS)
	Pump:SetMoveType(MOVETYPE_VPHYSICS)
	Pump:SetUseType(SIMPLE_USE)

	local phy = Pump:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Pump)

	zgo2.Pump.List[Pump] = true

	Pump.InputEntity = nil

	Pump.OutputEntities = {}

	zgo2.Destruction.SetupHealth(Pump)
end

function zgo2.Pump.OnUse(Pump,ply)
	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	if Pump:OnConnect_Input(ply) then
		// Start the connection / selection pointer system
		net.Start("zgo2.Pump.Connect.Input")
		net.WriteEntity(Pump)
		net.Send(ply)
		return
	end

	if Pump:OnConnect_Output(ply) then
		// Start the connection / selection pointer system
		net.Start("zgo2.Pump.Connect.Output")
		net.WriteEntity(Pump)
		net.Send(ply)
		return
	end

	if not Pump:OnSwitch(ply) then return end

	if Pump.NextTry and CurTime() < Pump.NextTry then return end
	Pump.NextTry = CurTime() + 1

	Pump:SetTurnedOn(not Pump:GetTurnedOn())
	Pump:EmitSound("buttons/lightswitch2.wav")
end

/*
	Adds power to the pumps battery
*/
function zgo2.Pump.AddPower(Pump,power)

	local before = Pump:GetPower()
	Pump:SetPower(math.Clamp(Pump:GetPower() + power, 0, zgo2.config.Battery.Power))
	local after = Pump:GetPower()

	// Tells us how much energy got added
	return after - before
end

function zgo2.Pump.DeconnectInput(Pump,ent)
	Pump.InputEntity = nil
	zclib.Sound.EmitFromEntity("zgo2_plug", ent)

	net.Start("zgo2.Pump.Update")
	net.WriteEntity(Pump)
	net.WriteEntity(ent)
	net.WriteBool(false)
	net.WriteBool(true)
	net.Broadcast()
end

function zgo2.Pump.DeconnectOutput(Pump,ent)
	Pump.OutputEntities[ent] = nil
	zclib.Sound.EmitFromEntity("zgo2_plug", ent)

	net.Start("zgo2.Pump.Update")
	net.WriteEntity(Pump)
	net.WriteEntity(ent)
	net.WriteBool(false)
	net.WriteBool(false)
	net.Broadcast()
end

util.AddNetworkString("zgo2.Pump.Update")
util.AddNetworkString("zgo2.Pump.Connect.Input")
net.Receive("zgo2.Pump.Connect.Input", function(len,ply)
    zclib.Debug_Net("zgo2.Pump.Connect.Input", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Pump = net.ReadEntity()
	local ent = net.ReadEntity()

	if not IsValid(Pump) then return end
	if Pump:GetClass() ~= "zgo2_pump" then return end

	if not zgo2.Pump.IsInput(Pump,ent)  then return end

	if not zclib.util.InDistance(Pump:GetPos(),ent:GetPos(), zgo2.config.Cable.Distance) then return end

	zgo2.Pump.ConnectInput(Pump,ent)
end)

function zgo2.Pump.ConnectInput(Pump,ent)
	if Pump.InputEntity then
		if Pump.InputEntity == ent then
			Pump.InputEntity = nil
		else
			Pump.InputEntity = ent
		end
	else
		Pump.InputEntity = ent
	end

	zclib.Sound.EmitFromEntity("zgo2_plug", ent)

	local connected = IsValid(Pump.InputEntity)

	net.Start("zgo2.Pump.Update")
	net.WriteEntity(Pump)
	net.WriteEntity(ent)
	net.WriteBool(connected)
	net.WriteBool(true)
	net.Broadcast()
end

util.AddNetworkString("zgo2.Pump.Connect.Output")
net.Receive("zgo2.Pump.Connect.Output", function(len,ply)
    zclib.Debug_Net("zgo2.Pump.Connect.Output", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Pump = net.ReadEntity()
	local ent = net.ReadEntity()

	if not IsValid(Pump) then return end
	if Pump:GetClass() ~= "zgo2_pump" then return end

	if not zgo2.Pump.IsOutput(Pump,ent)  then return end

	if not zclib.util.InDistance(Pump:GetPos(),ent:GetPos(), zgo2.config.Cable.Distance) then return end

	zgo2.Pump.ConnectOutput(Pump,ent)
end)

/*
	Returns how many valid entities are currently connected to the pump
*/
function zgo2.Pump.GetOutputCount(Pump)
	local count = 0
	if Pump.OutputEntities then
		for k,v in pairs(Pump.OutputEntities) do
			if IsValid(k) then count = count + 1 end
		end
	end
	return count
end

function zgo2.Pump.ConnectOutput(Pump,ent,ply)
	if Pump.OutputEntities[ent] then
		Pump.OutputEntities[ent] = nil
	else

		// Check how many pots are currently connected
		if zgo2.Pump.GetOutputCount(Pump) >= zgo2.config.Pump.PotLimit then
			zclib.Notify(ply, zgo2.language[ "ConnectionLimitReached" ], 1)
			return
		end

		Pump.OutputEntities[ent] = true
	end
	zclib.Sound.EmitFromEntity("zgo2_plug", ent)

	local connected = Pump.OutputEntities[ent] == true

	net.Start("zgo2.Pump.Update")
	net.WriteEntity(Pump)
	net.WriteEntity(ent)
	net.WriteBool(connected)
	net.WriteBool(false)
	net.Broadcast()
end

util.AddNetworkString("zgo2.Pump.UpdateAll")
net.Receive("zgo2.Pump.UpdateAll", function(len,ply)
	zclib.Debug_Net("zgo2.Pump.UpdateAll", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Pump = net.ReadEntity()

	if not IsValid(Pump) then return end
	if Pump:GetClass() ~= "zgo2_pump" then return end

	if not zclib.util.InDistance(Pump:GetPos(),ply:GetPos(), zgo2.config.Cable.Distance) then return end

	local count = table.Count(Pump.OutputEntities or {})

	net.Start("zgo2.Pump.UpdateAll")
	net.WriteEntity(Pump)
	net.WriteUInt(count,10)
	for k,v in pairs(Pump.OutputEntities or {}) do
		net.WriteEntity(k)
	end
	net.WriteEntity(Pump.InputEntity)
	net.Send(ply)
end)

/*
	The core logic of the Pump
*/
function zgo2.Pump.Logic()
	for pump, _ in pairs(zgo2.Pump.List) do
		if not IsValid(pump) then continue end

		// Is the pump turned on?
		if not pump:GetTurnedOn() then continue end

		// Does the pump have power?
		if pump:GetPower() <= 0 then continue end

		if not IsValid(pump.InputEntity) then continue end

		if not zclib.util.InDistance(pump:GetPos(),pump.InputEntity:GetPos(), zgo2.config.Cable.Distance) then
			zgo2.Pump.DeconnectInput(pump,pump.InputEntity)
			continue
		end

		// Calculate the water movement rate per second according to how many output entities are connected
		if pump.NextRateUpdate == nil or CurTime() >= pump.NextRateUpdate then
			pump.NextRateUpdate = CurTime() + 1
			pump:SetWaterTransferRate(pump.WaterTransfered or 0)
			pump.WaterTransfered = 0
		end

		// Dont send water from the InputEntity(Watertank) if its water amount is less then the TransferRate
		if pump.InputEntity:GetWater() < zgo2.config.Pump.TransferRate then continue end

		// Send the water from the InputEntity to the OutputEntities
		for pot,v in pairs(pump.OutputEntities) do

			if pump:GetPower() <= 0 then break end

			// Stop if the water amount from the InputEntity(Watertank) is less then the TransferRate
			if pump.InputEntity:GetWater() < zgo2.config.Pump.TransferRate then break end

			if IsValid(pot) then

				if not zclib.util.InDistance(pump:GetPos(),pot:GetPos(), zgo2.config.Cable.Distance) then
					zgo2.Pump.DeconnectOutput(pump,pot)
					continue
				end

				if (pot:GetWater() + zgo2.config.Pump.TransferRate) > zgo2.Pot.GetWaterLimit(pot) then continue end

				pump.InputEntity:SetWater(math.Clamp(pump.InputEntity:GetWater() - zgo2.config.Pump.TransferRate, 0, zgo2.Watertank.GetCapacity(pump.InputEntity)))

				pump.WaterTransfered = (pump.WaterTransfered or 0) + zgo2.config.Pump.TransferRate

				zgo2.Pot.AddWater(pot,zgo2.config.Pump.TransferRate)
			end
		end

		pump:SetPower(math.Clamp(pump:GetPower() - zgo2.config.Pump.PowerUsage,0,1000))
	end
end
zclib.Timer.Remove("zgo2_pump_logic")
zclib.Timer.Create("zgo2_pump_logic", 1, 0, function() zgo2.Pump.Logic() end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher