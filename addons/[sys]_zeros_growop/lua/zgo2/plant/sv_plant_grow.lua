--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}

/*

	The Weed plant is the core element of the game and it can have a lot of diffrent stats

*/


/*
	Starts the grow timer
*/
function zgo2.Plant.GrowTimer(Plant)

	local data = zgo2.Plant.GetData(Plant:GetPlantID())
	if not data then
		zclib.Entity.SafeRemove(Plant)
		return
	end

	local timerid = "zgo2_plant_"..Plant:EntIndex()
	zclib.Timer.Remove(timerid)
	zclib.Timer.Create(timerid, 1, 0, function()

		if not IsValid(Plant) then
			zclib.Timer.Remove(timerid)
			return
		end

		zgo2.Plant.GrowLogic(Plant)
	end)
end

/*
	Causes the plant to DeGrow
*/
function zgo2.Plant.DeGrow(Plant)
	Plant:SetGrowProgress(math.Round(math.Clamp(Plant:GetGrowProgress() - (1 * zclib.Convar.Get("zgo2_sv_growspeed")),0,999999999)))

	if Plant.ReadyToDie and Plant:GetGrowProgress() <= 0 then

		zgo2.Pot.Reset(Plant:GetParent())

		zclib.Entity.SafeRemove(Plant)
	end
end

/*
	Makes the plant grow
*/
function zgo2.Plant.Grow(Plant)

	Plant:SetGrowProgress(math.Round(Plant:GetGrowProgress() + (1 * zclib.Convar.Get("zgo2_sv_growspeed"))))

	// Once the plant reaches 15 seconds grow progress its allowed to die if it is missing something
	if Plant:GetGrowProgress() > zgo2.Plant.GetGrowTime(Plant:GetPlantID(),Plant) * 0.1 then
		Plant.ReadyToDie = true
	end
end

/*
	Performs the core grow logic
*/
function zgo2.Plant.GrowLogic(Plant)
	local PlantID = Plant:GetPlantID()
	local data = zgo2.Plant.GetData(PlantID)

	local Pot = Plant:GetParent()
	if not IsValid(Pot) then
		zclib.Timer.Remove("zgo2_plant_"..Plant:EntIndex())
		zclib.Entity.SafeRemove(Plant)
		return
	end

	local Lamp , dist = nil , 9999999999

	local Tent = Pot:GetParent()
	if IsValid(Tent) and Tent:GetClass() == "zgo2_tent" then
		// Since the pot is part of a tent lets get the lamp over the pot
		Lamp = zgo2.Tent.GetLamp(Tent,Pot.SpotID)
	else
		// Get closest lamp
		Lamp , dist = zgo2.Plant.GetNearestLightSource(Plant)
	end

	// Are we getting enough light?
	if not IsValid(Lamp) then
		Plant:SetLightLevel(0)

		zgo2.Plant.DeGrow(Plant)
		return
	end

	// Skip if the lamp is not emitting light
	if not zgo2.Lamp.IsEmittingLight(Lamp) then
		Plant:SetLightLevel(0)

		zgo2.Plant.DeGrow(Plant)
		return
	end

	// Is the plant too close to the lamp?
	if zgo2.Lamp.CausesHeat(Lamp) and dist < (zgo2.config.Plant.overheat_dist * zgo2.config.Plant.overheat_dist) then

		Plant:SetLightLevel(2)

		zgo2.Plant.DeGrow(Plant)

		if Plant.HeatStart == nil then Plant.HeatStart = CurTime() end

		// If the plant is too long and too close to that lamp then ignite it
		if (CurTime() - Plant.HeatStart) > zgo2.config.Plant.overheat_time and Plant.ReadyToDie then
			if Plant:Health() <= 0 then
				zgo2.Pot.Reset(Pot)
				zclib.Timer.Remove("zgo2_plant_" .. Plant:EntIndex())
			else
				Plant:Ignite(4,5)
			end
		end

		return
	end
	Plant.HeatStart = nil

	// Check to see if this plant requieres a certain light color?
	if data.grow.pref_lightcolor_req and data.grow.pref_lightcolor_color then
		local reqHue = ColorToHSV(data.grow.pref_lightcolor_color)

		local diff = Lamp.ColorHue - reqHue
		// If our diffrence is larger then 180 degrees then that meant we did go the long way to get that value so lets remove 360
		if diff > 180 then diff = 360 - diff end

		// If the diffrence between the requiered color of the plant and the current color of the lamp is greater then 15 degrees then stop
		if math.abs(diff) > 15 then

			Plant:SetLightLevel(3)

			zgo2.Plant.DeGrow(Plant)
			return
		end
	end

	Plant:SetLightLevel(1)

	// Do we have enough water?
	local needWater = zgo2.Plant.GetWaterNeed(PlantID)

	// If we use a sodium lamp which produces heat then we will need more water
	if zgo2.Lamp.UsesBulbs(Lamp) then needWater = needWater * zgo2.config.Plant.heat_water_penalty end

	needWater = needWater / zgo2.Plant.GetGrowTime(PlantID,Plant)

	if not zgo2.Plant.HasWater(Plant,needWater) then
		zgo2.Plant.DeGrow(Plant)
		return
	end
	zgo2.Pot.UseWater(Plant:GetParent(),needWater)

	// Check if the plant has enough space to grow
	if Pot:GetIsCramped(IsCramped) then
		zgo2.Plant.DeGrow(Plant)
		return
	end

	if zgo2.Plant.HarvestReady(Plant) then
		zgo2.Plant.SetHarvestReady(Plant)
	else
		zgo2.Plant.Grow(Plant)
	end
end

/*
	Marks the plant as harvest ready
*/
function zgo2.Plant.SetHarvestReady(Plant)

	Plant:SetGrowProgress(zgo2.Plant.GetGrowTime(Plant:GetPlantID(),Plant))

	zclib.Timer.Remove("zgo2_plant_" .. Plant:EntIndex())

	// Keep track when we completed the grow
	Plant:SetGrowCompletedTime(CurTime())

	Plant:SetLightLevel(0)

	// Enable the plants physics to receive Use traces
	Plant:PhysicsInit(SOLID_VPHYSICS)
	Plant:SetSolid(SOLID_VPHYSICS)
	Plant:SetMoveType(MOVETYPE_NONE)
	Plant:SetUseType(SIMPLE_USE)

	Plant:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	// This is requiered to make the touch function for the leaf effect work
	Plant:SetTrigger(true)

	// 1123098134
end

/*
	Returns the nearest lamp that is lightning this plant
*/
local offset = Vector(0,0,20)
function zgo2.Plant.GetNearestLightSource(Plant)
	local pos = Plant:LocalToWorld(offset)

	local nearest
	local dist = 999999999999

	for ent,_ in pairs(zgo2.Lamp.List) do

        if not IsValid(ent) then
			continue
		end

		// Skip if the lamp is part of a tent
		if IsValid(ent:GetParent()) then continue end

		// Skip if the lamp is not emitting light
		if not zgo2.Lamp.IsEmittingLight(ent) then continue end

		// Skip if the plant is not inside the light area
		if not zgo2.Lamp.InsideLightArea(ent,Plant) then continue end

		local cdist = pos:DistToSqr(ent:GetPos())
		if cdist < dist then
			dist = cdist
			nearest = ent
		end
    end

	return nearest , dist
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher