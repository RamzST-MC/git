-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Cooler_Initialize(cooler)

	cooler.Distillery = nil
	cooler.IsBusy = false
	cooler.LastThink = 1
	cooler.LastWaterTempIncrease = 1

	cooler.LastInput = 1
	cooler.DeflowWater = false
	cooler.LastWaterDecrease = 1

	cooler.WaterTemp = 0

	zyb.f.EntList_Add(cooler)
end

function zyb.f.Cooler_OnTouch(cooler,other)
	if not IsValid(other) then return end
	if zyb.f.CollisionCooldown(other) then return end
	if cooler.IsBusy then return end

	if other:GetClass() == "zyb_water" and cooler:GetWater() < zyb.config.Cooler.WaterAmount then
		zyb.f.Cooler_AddWater(cooler,other)
	end
end

function zyb.f.Cooler_OnUse(cooler,ply)
	if cooler:OnWaterValve(ply) and cooler:GetWater() > 0 then
		cooler.LastInput = CurTime() + 0.15
		cooler:SetDeflowWater(true)
		cooler.DeflowWater = true
	end
end

function zyb.f.Cooler_AddWater(cooler,water)
	cooler.IsBusy = true

	cooler:SetBodygroup(1,1)

	DropEntityIfHeld(water)

	local ang = cooler:GetAngles()
	ang:RotateAroundAxis(cooler:GetRight(), 180)
	ang:RotateAroundAxis(cooler:GetUp(), 180)

	water:SetAngles(ang)
	water:SetPos(cooler:GetPos() + cooler:GetUp() * 155 + cooler:GetRight() * 26)
	water:SetParent(cooler)

	water:SetFilling(true)

	zyb.f.CreateNetEffect("fx_water_fill",water)

	timer.Simple(2, function()

		cooler:SetBodygroup(1,1)

		SafeRemoveEntity(water)

		cooler:SetBodygroup(1,0)

		cooler.IsBusy = false

		cooler:SetWater(math.Clamp(cooler:GetWater() + zyb.config.Water.Amount,0,zyb.config.Cooler.WaterAmount))
		cooler:SetWaterTemperatur(math.Clamp(cooler:GetWaterTemperatur() - 25,0,100))
	end)
end

function zyb.f.Cooler_CoolingProcess(cooler)
	if CurTime() < cooler.LastThink then return end
	cooler.LastThink = CurTime() + math.Clamp(zyb.config.Cooler.CoolingSpeed * (cooler.WaterTemp / 100), 0.2, 100)

	if cooler:GetWater() <= 0 then
		return
	end

	// If the water gets hotter then 50 degree then we start to vaporize it
	if cooler.WaterTemp > 50 then
		cooler:SetWater( math.Clamp(cooler:GetWater() - 5,0,zyb.config.Cooler.WaterAmount))
	end

	local YeastSteam = cooler:GetYeastStewSteam()
	if YeastSteam > 0 and cooler:GetWeakMoonShine() < zyb.config.Cooler.WeakMoonshineStorage then

		// The work amount of yeaststeam we use
		local workAmount = zyb.config.Cooler.ProcessAmount

		// Subtract the yeaststeam
		cooler:SetYeastStewSteam(math.Clamp(YeastSteam - workAmount, 0, 10000))

		//Calculate the moonshine amount of it
		local moonshine = workAmount * zyb.config.Cooler.CoolAmount

		// If the water is warmer then 40 degree then we reduce the moonshine
		if cooler.WaterTemp > 40 then
			moonshine = math.Round(moonshine * zyb.config.Cooler.HeatPenalty)
		end

		// Here we add the weak moonshine
		cooler:SetWeakMoonShine(math.Clamp(cooler:GetWeakMoonShine() + moonshine, 0, zyb.config.Cooler.WeakMoonshineStorage))

		zyb.f.CreateNetEffect("sfx_cooling",cooler)
	end

	// Every 5 seconds we increase the water temperatur
	if CurTime() > cooler.LastWaterTempIncrease then
		if YeastSteam > 0 then
			cooler:SetWaterTemperatur(math.Clamp(cooler:GetWaterTemperatur() + 5,0,100))
		else
			cooler:SetWaterTemperatur(math.Clamp(cooler:GetWaterTemperatur() - 5,0,100))
		end
		cooler.WaterTemp = cooler:GetWaterTemperatur()
		cooler.LastWaterTempIncrease = CurTime() + 5
	end

	if IsValid(cooler.Condenser) and cooler:GetWeakMoonShine() > 0 and cooler.Condenser:GetWeakMoonShine() < zyb.config.Condenser.WeakMoonshineStorage then

		local workAmount = 10

		if cooler.WaterTemp < 25 then
			workAmount = 20
		end

		// Add weak moonshine to the condenser
		cooler.Condenser:SetWeakMoonShine(math.Clamp(cooler.Condenser:GetWeakMoonShine() + workAmount,0,zyb.config.Condenser.WeakMoonshineStorage))

		// Remove weak moonshine from the cooler
		cooler:SetWeakMoonShine(math.Clamp(cooler:GetWeakMoonShine() -10, 0, zyb.config.Cooler.WeakMoonshineStorage))
	end
end

function zyb.f.Cooler_ReleaseWater(cooler)
	if cooler.DeflowWater == false then return end

	if CurTime() > cooler.LastInput then
		cooler:SetDeflowWater(false)
		cooler.DeflowWater = false
	else
		if CurTime() > cooler.LastWaterDecrease then
			cooler:SetWater(math.Clamp(cooler:GetWater() - 10, 0, zyb.config.Cooler.WaterAmount))
			cooler.LastWaterDecrease = CurTime() + 0.1
		end
	end
end
-- leak by lordee