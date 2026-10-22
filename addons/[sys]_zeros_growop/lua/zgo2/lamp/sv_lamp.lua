--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Lamp = zgo2.Lamp or {}
zgo2.Lamp.List = zgo2.Lamp.List or {}

/*

	The player can grow plants in Lamps if the bot has soil in it

*/
function zgo2.Lamp.Initialize(Lamp)
	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())

	Lamp:SetModel(dat.mdl)
	Lamp:PhysicsInit(SOLID_VPHYSICS)
	Lamp:SetSolid(SOLID_VPHYSICS)
	Lamp:SetMoveType(MOVETYPE_VPHYSICS)
	Lamp:SetUseType(SIMPLE_USE)
	Lamp:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phy = Lamp:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Lamp)

	zgo2.Lamp.List[Lamp] = true

	timer.Simple(0.5,function()
		if not IsValid(Lamp) then return end

		local color = zgo2.Lamp.GetLightColor(Lamp)
		Lamp:SetLampColor(Vector(color.r,color.g,color.b))

		if dat.bulbs then
			Lamp.Bulbs = {}
			for k,v in pairs(dat.bulbs) do
				Lamp.Bulbs[k] = math.random(zgo2.config.Bulb.Lifetime.min,zgo2.config.Bulb.Lifetime.max)
				Lamp:SetBodygroup(v,1)
				zgo2.Lamp.UpdateBulbs(Lamp)
			end
		end
	end)

	zgo2.Destruction.SetupHealth(Lamp)
end

function zgo2.Lamp.OnUse(Lamp,ply)

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	if Lamp:OnLightSwitch(ply) then
		Lamp:SetLightSwitch(not Lamp:GetLightSwitch())
		Lamp:EmitSound("buttons/lightswitch2.wav")
	end

	// Open the color change
	if zgo2.Lamp.CanChangeColor(Lamp) and Lamp:OnColorChange(ply) then
		zgo2.Lamp.ChangeColor(Lamp,ply)
		Lamp:EmitSound("buttons/lightswitch2.wav")
	end
end

function zgo2.Lamp.OnTouch(Lamp,other)
	if not IsValid(Lamp) then return end
    if not IsValid(other) then return end
	if zclib.util.CollisionCooldown(other) then return end

	if other:GetClass() == "zgo2_battery" then
		if zclib.Entity.GettingRemoved(other) then return end
		DropEntityIfHeld(other)

		zgo2.Lamp.AddPower(Lamp,zgo2.config.Battery.Power)

		zclib.Entity.SafeRemove(other)
	end

	if other:GetClass() == "zgo2_bulb" and not zclib.Entity.GettingRemoved(other) and zgo2.Lamp.AddBulb(Lamp) then

		DropEntityIfHeld(other)

		zclib.Entity.SafeRemove(other)
	end
end

/*
	Quick interface to let the player select the color
*/
function zgo2.Lamp.ChangeColor(Lamp,ply)
	net.Start("zgo2.Lamp.SelectColor")
	net.WriteEntity(Lamp)
	net.Send(ply)
end

util.AddNetworkString("zgo2.Lamp.SelectColor")
net.Receive("zgo2.Lamp.SelectColor", function(len,ply)
    zclib.Debug_Net("zgo2.Lamp.SelectColor", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local ent = net.ReadEntity()

	local r = net.ReadUInt(8)
	local g = net.ReadUInt(8)
	local b = net.ReadUInt(8)

    local color = Color(r,g,b)
	if not IsValid(ent) then return end
	if ent:GetClass() ~= "zgo2_lamp" then return end
	if not zgo2.Lamp.CanChangeColor(ent) then return end

	if not color then return end

	if not zclib.util.InDistance(ent:GetPos(),ply:GetPos(), 400) then return end

	ent:SetLampColor(Vector(color.r, color.g, color.b))
end)

/*
	Adds power to the lamps battery
*/
function zgo2.Lamp.AddPower(Lamp,power,supress_sound)

	local before = Lamp:GetPower()
	Lamp:SetPower(math.Clamp(Lamp:GetPower() + power, 0, zgo2.config.Battery.Power))
	local after = Lamp:GetPower()

	if not supress_sound then zclib.Sound.EmitFromEntity("zgo2_install", Lamp) end
	// 1123098134
	local Tent = Lamp:GetParent()
	if IsValid(Tent) and Tent:GetClass() == "zgo2_tent" then
		local TentData = zgo2.Tent.GetData(Tent:GetTentID())
		if TentData then
			Tent:SetBodygroup(TentData.battery_bg[Lamp.TentPos],1)
		end
	else
		local dat = zgo2.Lamp.GetData(Lamp:GetLampID())
		if dat.cable_bg then Lamp:SetBodygroup(dat.cable_bg,1) end
		if dat.battery_bg then Lamp:SetBodygroup(dat.battery_bg,1) end
	end

	// Tells us how much energy got added
	return after - before
end

/*
	Adds a bulb to the lamp if supported
*/
function zgo2.Lamp.AddBulb(Lamp)
	local Added = false

	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())
	if dat and dat.bulbs then
		for k,v in pairs(dat.bulbs) do
			if not Lamp.Bulbs[k] then
				Lamp.Bulbs[k] = math.random(zgo2.config.Bulb.Lifetime.min,zgo2.config.Bulb.Lifetime.max)
				Added = true
				Lamp:SetBodygroup(v,1)
				zclib.Sound.EmitFromEntity("zgo2_bulb", Lamp)
				break
			end
		end

		if Added then zgo2.Lamp.UpdateBulbs(Lamp) end
	end

	return Added
end

/*
	Returns if this lamp has a free socket for another bulb
*/
function zgo2.Lamp.CanAddBulb(Lamp)
	local Added = false
	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())
	if dat and dat.bulbs then
		for k,v in pairs(dat.bulbs) do
			if not Lamp.Bulbs[k] then
				Added = true
				break
			end
		end
	end
	return Added
end

/*
	Called if the client wants to know how many bulbs the lamp has
*/
util.AddNetworkString("zgo2.Lamp.UpdateBulbs")
net.Receive("zgo2.Lamp.UpdateBulbs", function(len,ply)
    zclib.Debug_Net("zgo2.Lamp.UpdateBulbs", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local ent = net.ReadEntity()
	if not IsValid(ent) then return end
	if ent:GetClass() ~= "zgo2_lamp" then return end
	if not zclib.util.InDistance(ent:GetPos(),ply:GetPos(), 400) then return end
	if not zgo2.Lamp.UsesBulbs(ent) then return end

	zgo2.Lamp.UpdateBulbs(ent)
end)

/*
	Update the clients about which bulb the lamp currently has
*/
function zgo2.Lamp.UpdateBulbs(Lamp)
	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())

	if Lamp.Bulbs == nil then Lamp.Bulbs = {} end

	local count = table.Count(dat.bulbs)
	net.Start("zgo2.Lamp.UpdateBulbs")
	net.WriteEntity(Lamp)
	net.WriteUInt(count,4)
	for k,v in pairs(dat.bulbs) do
		net.WriteUInt(k,4)
		net.WriteBool(Lamp.Bulbs[k] ~= nil)
	end
	net.Broadcast()
end

/*
	Emits light on plants and uses power
*/
function zgo2.Lamp.EmitLight(Lamp)

	// Calculate how much power is used according to how many bulbs are currently in use
	local UsePower = zgo2.Lamp.GetPowerUsage(Lamp)

	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())
	if dat and dat.bulbs then

		local WorkingBulbs = 0

		for k,v in pairs(dat.bulbs) do
			if not Lamp.Bulbs[k] then continue end

			// Reduce bulb lifetime
			Lamp.Bulbs[k] = Lamp.Bulbs[k] - 1

			WorkingBulbs = WorkingBulbs + 1

			// Did the bulb burn out?
			if Lamp.Bulbs[k] <= 0 then
				// Disable bg
				Lamp:SetBodygroup(v,0)

				// Remove bulb
				Lamp.Bulbs[k] = nil

				// Play SFX/VFX
				Lamp:EmitSound("zgo2_bulb_burnout")
				zclib.Effect.Generic("ManhackSparks",Lamp:LocalToWorld(dat.visuals[k].lpos))

				zgo2.Lamp.UpdateBulbs(Lamp)
			end
		end

		// Reduce power consumtion according to how many working light bulbs this lamp currently has
		UsePower = (UsePower / table.Count(dat.bulbs)) * WorkingBulbs
	end

	// Reduce power
	Lamp:SetPower(Lamp:GetPower() - UsePower)

	if Lamp:GetPower() > 0 then return end

	local Tent = Lamp:GetParent()
	if IsValid(Tent) and Tent:GetClass() == "zgo2_tent" then
		local TentData = zgo2.Tent.GetData(Tent:GetTentID())
		if TentData then
			Tent:SetBodygroup(TentData.battery_bg[Lamp.TentPos],0)
		end
	else
		if dat.cable_bg then Lamp:SetBodygroup(dat.cable_bg,0) end
		if dat.battery_bg then Lamp:SetBodygroup(dat.battery_bg,0) end
	end
end

/*
	Handles the client light ray model being created / Updated
*/
function zgo2.Lamp.Logic()
    for ent,_ in pairs(zgo2.Lamp.List) do

        if not IsValid(ent) then
			continue
		end

		if ent:GetLightSwitch() and ent:GetPower() > 0 then
			zgo2.Lamp.EmitLight(ent)
		end
    end
end
zclib.Timer.Remove("zgo2_lamp_logic")
zclib.Timer.Create("zgo2_lamp_logic", 1, 0, function() zgo2.Lamp.Logic() end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher