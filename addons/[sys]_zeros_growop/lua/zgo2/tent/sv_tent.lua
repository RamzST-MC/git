--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Tent = zgo2.Tent or {}
zgo2.Tent.List = zgo2.Tent.List or {}

/*

	Growboxes are used for small scale grow operations

*/
function zgo2.Tent.Initialize(Tent)
	local dat = zgo2.Tent.GetData(Tent:GetTentID())

	Tent:SetModel(dat.mdl)
	Tent:PhysicsInit(SOLID_VPHYSICS)
	Tent:SetSolid(SOLID_VPHYSICS)
	Tent:SetMoveType(MOVETYPE_VPHYSICS)
	Tent:SetUseType(SIMPLE_USE)

	local phy = Tent:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Tent)

	zgo2.Tent.List[Tent] = true

	zgo2.Destruction.SetupHealth(Tent)
end

function zgo2.Tent.OnTouch(Tent, ent)
	if not IsValid(Tent) then return end
	if not IsValid(ent) then return end
	if zclib.util.CollisionCooldown(ent) then return end

	if ent:GetClass() == "zgo2_lamp" then
		timer.Simple(0.1,function()
			if not IsValid(Tent) then return end
			if not IsValid(ent) then return end
			zgo2.Tent.AddLamp(Tent,ent)
		end)
	end

	if ent:GetClass() == "zgo2_pot" then
		timer.Simple(0.1,function()
			if not IsValid(Tent) then return end
			if not IsValid(ent) then return end
			zgo2.Tent.AddPot(Tent,ent)
		end)
	end
end

/*
	Returns the first free Lamp spot it finds
*/
function zgo2.Tent.GetLampSpot(Tent)
	if Tent.Lamps == nil then Tent.Lamps = {} end
	local found
	local dat = zgo2.Tent.GetData(Tent:GetTentID())
	for id,_ in pairs(dat.lamps) do
		if not IsValid(Tent.Lamps[id]) then
			found = id
			break
		end
	end
	return found
end

/*
	Adds a lamp to the tent
*/
function zgo2.Tent.AddLamp(Tent,Lamp)
	if Tent.Lamps == nil then Tent.Lamps = {} end

	local LampData = zgo2.Lamp.GetData(Lamp:GetLampID())
	if not LampData then return end
	if not LampData.tent then return end

	local spot = zgo2.Tent.GetLampSpot(Tent)
	if not spot then return end

	Lamp.TentPos = spot

	Tent.Lamps[spot] = Lamp
	DropEntityIfHeld(Lamp)
	local dat = zgo2.Tent.GetData(Tent:GetTentID())

	Lamp:SetPos(Tent:LocalToWorld(dat.lamps[spot][1]))
	Lamp:SetAngles(Tent:LocalToWorldAngles(dat.lamps[spot][2]))
	Lamp:SetParent(Tent)
	Lamp:SetBodygroup(0,1)
	zclib.Sound.EmitFromEntity("zgo2_install", Lamp)
end

/*
	Returns the lamp entity which is on the provided spot id
*/
function zgo2.Tent.GetLamp(Tent,SpotID)
	if Tent.Lamps == nil then Tent.Lamps = {} end
	return Tent.Lamps[SpotID]
end

/*
	Returns the first free pot spot it finds
*/
function zgo2.Tent.GetPotSpot(Tent)
	if Tent.Pots == nil then Tent.Pots = {} end
	local found
	local dat = zgo2.Tent.GetData(Tent:GetTentID())
	for id,_ in pairs(dat.pots) do
		if not IsValid(Tent.Pots[id]) then
			found = id
			break
		end
	end
	return found
end

function zgo2.Tent.AddPot(Tent,Pot,spot)
	if Tent.Pots == nil then Tent.Pots = {} end
	// 1123098134
	if not spot then spot = zgo2.Tent.GetPotSpot(Tent) end
	if not spot then return end

	Tent.Pots[spot] = Pot

	local dat = zgo2.Tent.GetData(Tent:GetTentID())
	DropEntityIfHeld(Pot)
	Pot:SetPos(Tent:LocalToWorld(dat.pots[spot][1]))
	Pot:SetAngles(Tent:LocalToWorldAngles(dat.pots[spot][2]))
	Pot:SetParent(Tent)

	Pot.SpotID = spot

	Pot:EmitSound("physics/plaster/ceiling_tile_step1.wav")
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher