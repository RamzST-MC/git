--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Generator = zgo2.Generator or {}
zgo2.Generator.List = zgo2.Generator.List or {}

/*

	Generators provide power and refill over time

*/
function zgo2.Generator.Initialize(Generator)
	local dat = zgo2.Generator.GetData(Generator:GetGeneratorID())

	Generator:SetModel(dat.mdl)
	Generator:PhysicsInit(SOLID_VPHYSICS)
	Generator:SetSolid(SOLID_VPHYSICS)
	Generator:SetMoveType(MOVETYPE_VPHYSICS)
	Generator:SetUseType(SIMPLE_USE)

	local phy = Generator:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Generator)

	zgo2.Generator.List[Generator] = true

	Generator.ConnectedEntities = {}

	zgo2.Destruction.SetupHealth(Generator)
end

function zgo2.Generator.OnUse(Generator,ply)

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	if Generator:OnConnect(ply) then
		// Start the connection / selection pointer system
		net.Start("zgo2.Generator.Connect")
		net.WriteEntity(Generator)
		net.Send(ply)
		return
	end

	if not Generator:OnSwitch(ply) then return end

	if Generator.NextTry and CurTime() < Generator.NextTry then return end
	Generator.NextTry = CurTime() + 1

	if Generator:GetTurnedOn() then
		zgo2.Generator.Stop(Generator)
	else

		if Generator:GetFuel() > 0 and math.random(10) < 6 then
			Generator:EmitSound("zgo2_generator_start_sucess")
			timer.Simple(0.8,function()
				if not IsValid(Generator) then return end
				Generator:SetTurnedOn(true)
			end)
		else
			Generator:EmitSound("zgo2_generator_start_fail")
		end
	end
end

function zgo2.Generator.OnTouch(Generator, ent)
	if not IsValid(Generator) then return end
	if not IsValid(ent) then return end
	if zclib.util.CollisionCooldown(ent) then return end

	if ent:GetClass() == "zgo2_fuel" then

		if zclib.Entity.GettingRemoved(ent) then return end

		if zgo2.Generator.FuelLimitReached(Generator) then return end

		timer.Simple(0.1,function()
			if not IsValid(Generator) then return end
			if not IsValid(ent) then return end
			zgo2.Generator.AddFuel(Generator,zgo2.config.Generator.FuelPerCan)
			DropEntityIfHeld(ent)
			zclib.Entity.SafeRemove(ent)
		end)
	end
end

function zgo2.Generator.Stop(Generator)
	Generator:SetTurnedOn(false)
	Generator:EmitSound("zgo2_generator_stop")
end

function zgo2.Generator.Deconnect(Generator,ent)
	Generator.ConnectedEntities[ent] = nil

	zclib.Sound.EmitFromEntity("zgo2_plug", ent)

	net.Start("zgo2.Generator.Update")
	net.WriteEntity(Generator)
	net.WriteEntity(ent)
	net.WriteBool(false)
	net.Broadcast()
end

util.AddNetworkString("zgo2.Generator.Connect")
util.AddNetworkString("zgo2.Generator.Update")
net.Receive("zgo2.Generator.Connect", function(len,ply)
    zclib.Debug_Net("zgo2.Generator.Connect", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Generator = net.ReadEntity()
	local ent = net.ReadEntity()

	zgo2.Generator.Connect(Generator,ent)
end)

function zgo2.Generator.Connect(Generator,ent)
	if not IsValid(Generator) then return end
	if Generator:GetClass() ~= "zgo2_generator" then return end

	if not zgo2.Generator.CanConnect(Generator,ent)  then return end

	if not zclib.util.InDistance(Generator:GetPos(),ent:GetPos(), zgo2.config.Cable.Distance) then return end

	if Generator.ConnectedEntities[ent] then
		Generator.ConnectedEntities[ent] = nil
	else
		Generator.ConnectedEntities[ent] = true
	end

	zclib.Sound.EmitFromEntity("zgo2_plug", ent)

	local connected = Generator.ConnectedEntities[ent] == true

	net.Start("zgo2.Generator.Update")
	net.WriteEntity(Generator)
	net.WriteEntity(ent)
	net.WriteBool(connected)
	net.Broadcast()
end

util.AddNetworkString("zgo2.Generator.UpdateAll")
net.Receive("zgo2.Generator.UpdateAll", function(len,ply)
	zclib.Debug_Net("zgo2.Generator.UpdateAll", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Generator = net.ReadEntity()

	if not IsValid(Generator) then return end
	if Generator:GetClass() ~= "zgo2_generator" then return end

	if not zclib.util.InDistance(Generator:GetPos(),ply:GetPos(), zgo2.config.Cable.Distance) then return end

	local count = table.Count(Generator.ConnectedEntities or {})

	net.Start("zgo2.Generator.UpdateAll")
	net.WriteEntity(Generator)
	net.WriteUInt(count,10)
	for k,v in pairs(Generator.ConnectedEntities or {}) do
		net.WriteEntity(k)
	end
	net.Send(ply)
end)


/*
	Adds fuel
*/
function zgo2.Generator.AddFuel(Generator,fuel)
	if Generator:GetFuel() >= zgo2.Generator.GetFuelCapacity(Generator) then return end
	Generator:SetFuel(math.Clamp(Generator:GetFuel() + fuel,0,zgo2.Generator.GetFuelCapacity(Generator)))
	Generator:EmitSound("zgo2_generator_refill")
end

/*
	The core logic of the generator
*/
function zgo2.Generator.Logic()
	for gen, _ in pairs(zgo2.Generator.List) do
		if not IsValid(gen) then continue end

		local GenConfig = zgo2.Generator.GetData(gen:GetGeneratorID())

		if gen:GetTurnedOn() then
			if gen:GetPower() < (1000 - GenConfig.PowerRate) then
				gen:SetFuel(math.Clamp(gen:GetFuel() - GenConfig.FuelConsumption,0,zgo2.Generator.GetFuelCapacity(gen)))
				gen:SetPower(math.Clamp(gen:GetPower() + GenConfig.PowerRate, 0, 1000))
			end

			if gen:GetFuel() <= 0 then zgo2.Generator.Stop(gen) end
		end

		if gen:GetPower() <= 0 then continue end

		// Send the power to any lamp in distance
		for connectedEnt,_ in pairs(gen.ConnectedEntities) do

			if gen:GetPower() <= 0 then continue end

			if IsValid(connectedEnt) then

				if not zclib.util.InDistance(gen:GetPos(),connectedEnt:GetPos(), zgo2.config.Cable.Distance) then
					zgo2.Generator.Deconnect(gen,connectedEnt)
					continue
				end

				if connectedEnt:GetPower() >= zgo2.config.Battery.Power then continue end

				// The AddPower functions returns how much energy was actully needed
				local UsedAmount = connectedEnt:AddPower(zgo2.config.Generator.TransferRate)

				gen:SetPower(math.Clamp(gen:GetPower() - UsedAmount, 0, 1000))
			end
		end
	end
end
zclib.Timer.Remove("zgo2_Generator_logic")
zclib.Timer.Create("zgo2_Generator_logic", 1, 0, function() zgo2.Generator.Logic() end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher