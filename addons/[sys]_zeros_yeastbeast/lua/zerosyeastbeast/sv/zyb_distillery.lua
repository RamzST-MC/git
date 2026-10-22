-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Distillery_Initialize(distillery)

	// Is the entity busy
	distillery.IsBusy = false

	// Last time it burned fuel
	distillery.LastFuelBurn = -1

	// Last time of cook think
	distillery.LastCookThink = -1

	// Is it getting depressurized
	distillery.Depressuring = false

	// Last time it got depressurized
	distillery.LastDepressuring = -1

	// Last input from the user
	distillery.LastInput = -1

	zyb.f.EntList_Add(distillery)
end

function zyb.f.Distillery_OnTouch(distillery,other)

	if not IsValid(other) then return end
	if zyb.f.CollisionCooldown(other) then return end
	if distillery.IsBusy then return end
	if not IsValid(distillery:GetCooler()) then return end
	if not IsValid(distillery:GetCondenser()) then return end


	if other:GetClass() == "zyb_fermbarrel" and other:GetStage() == 3 and distillery:GetYeastStew() < zyb.config.Distillery.YeastStewAmount then
		zyb.f.Distillery_AddYeastStew(distillery,other)
	elseif other:GetClass() == "zyb_fuel" and distillery:GetFuel() < zyb.config.Distillery.FuelAmount then
		zyb.f.Distillery_AddWood(distillery,other)
	end
end

function zyb.f.Distillery_OnUse(distillery,ply)
	if distillery:OnPressureValve(ply) and distillery:GetPressureLevel() > 0 then
		distillery.LastInput = CurTime() + 0.15
		distillery:SetDepressuring(true)
		distillery.Depressuring = true
	end
end


function zyb.f.Distillery_AddWood(distillery,wood)
	distillery:SetFuel(math.Clamp(distillery:GetFuel() + zyb.config.Wood.Amount, 0, zyb.config.Distillery.FuelAmount))
	SafeRemoveEntity(wood)
end

function zyb.f.Distillery_AddYeastStew(distillery,barrel)
	distillery.IsBusy = true

	barrel:SetHideUI(true)

	barrel:SetBodygroup(2, 0)

	DropEntityIfHeld(barrel)

	local ang = distillery:GetAngles()
	ang:RotateAroundAxis(distillery:GetRight(), 180)
	ang:RotateAroundAxis(distillery:GetUp(), 180)
	barrel:SetAngles(ang)
	barrel:SetPos(distillery:GetPos() + distillery:GetUp() * 110 + distillery:GetForward() * 32)
	barrel:SetParent(distillery)

	barrel:SetFilling(true)

	zyb.f.CreateNetEffect("add_mash",distillery)

	local emptySpace = zyb.config.Distillery.YeastStewAmount - distillery:GetYeastStew()
	local InBarrel = barrel:GetYeastStew()

	local fillAmount = 0

	if emptySpace > InBarrel then
		// If the empty space in the distillery is bigger then the amount that we have in the barrel then we use the full amount of the barrel as fillamount
		fillAmount = InBarrel
	else
		// If not then we use the empty space
		fillAmount = emptySpace
	end

	timer.Simple(3, function()

		if not IsValid(barrel) then return end
		if not IsValid(distillery) then return end

		barrel:SetParent(nil)
		barrel:SetPos(distillery:GetPos() + distillery:GetUp() * 110 + distillery:GetForward() * 40)
		barrel:SetAngles(distillery:GetAngles())
		barrel:PhysicsInit(SOLID_VPHYSICS)
		barrel:SetMoveType(MOVETYPE_VPHYSICS)
		barrel:SetSolid(SOLID_VPHYSICS)

		local phys = barrel:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion(true)
		end

		distillery:SetYeastStew(distillery:GetYeastStew() + fillAmount )

		barrel:SetYeastStew(barrel:GetYeastStew() - fillAmount)

		emptySpace = zyb.config.Distillery.YeastStewAmount - distillery:GetYeastStew()
		InBarrel = barrel:GetYeastStew()

		if InBarrel <= 0 then
			// If the barrel is empty then we reset it
			zyb.f.Fermbarrel_Reset(barrel)
		else
			// Otherwhise we just close it
			barrel:SetBodygroup(2, 1)
			barrel:SetBodygroup(1, 0)
		end

		barrel:SetHideUI(false)

		barrel:SetFilling(false)

		distillery.IsBusy = false
	end)
end




function zyb.f.Distillery_AddCooler(distillery,cooler)
	cooler:SetBodygroup(2,1)
	distillery:SetCooler(cooler)
end

function zyb.f.Distillery_AddCondenser(distillery,condenser)
	condenser:SetBodygroup(1,1)
	distillery:SetCondenser(condenser)
	condenser.Cooler = distillery:GetCooler()
	distillery:GetCooler().Condenser = condenser
end





function zyb.f.Distillery_ReleaseSteam(distillery)
	if distillery.Depressuring == false then return end

	if CurTime() > distillery.LastInput then
		distillery:SetDepressuring(false)
		distillery.Depressuring = false
	else
		if CurTime() > distillery.LastDepressuring then
			distillery:SetPressureLevel(math.Clamp(distillery:GetPressureLevel() - 5, 0, 100))
			distillery.LastDepressuring = CurTime() + 0.25
		end
	end
end

function zyb.f.Distillery_CookingProcess(distillery)
	if CurTime() < distillery.LastCookThink then return end
	distillery.LastCookThink = CurTime() + 1

	local cooler = distillery:GetCooler()
	local condenser = distillery:GetCondenser()

	if IsValid(cooler) and IsValid(condenser) then
		local fuel = distillery:GetFuel()
		local yeastStew = distillery:GetYeastStew()

		// Here we burn wood every 5 seconds
		if CurTime() > distillery.LastFuelBurn and fuel > 0 and yeastStew > 0 then
			distillery:SetFuel(distillery:GetFuel() - zyb.config.Distillery.FuelUsage)
			distillery.LastFuelBurn = CurTime() + 3
		end

		// Here we increase / decrease the temperatur
		local PressureLevel = distillery:GetPressureLevel()

		if fuel > 0 and yeastStew > 0 then
			distillery:SetPressureLevel(math.Clamp(PressureLevel + 1, 0, 100))
		else
			distillery:SetPressureLevel(math.Clamp(PressureLevel - 1, 0, 100))
		end

		// If we dont have reached the work temperatur then we stop here
		if PressureLevel < 20 then return end

		// If the pressure gets to high then the boiler explodes
		if PressureLevel > 99 then
			zyb.f.Distillery_BoilerExplosion(distillery)
			return
		end

		if yeastStew <= 0 then return end

		if PressureLevel > 90 then
			distillery:SetYeastStew(math.Clamp(yeastStew - zyb.config.Distillery.BurnAmount, 0, 1000000))
		end


		local YeastStewSteam = cooler:GetYeastStewSteam()
		if YeastStewSteam >= zyb.config.Cooler.YeastSteamAmount then return end
		local workAmount = zyb.config.Distillery.ProcessAmount

		// If the distillery has the perfect heat then we increase the produce steam
		if PressureLevel > 40 and PressureLevel < 80 then
			workAmount = workAmount * zyb.config.Distillery.PerfectHeatBoni
		end

		distillery:SetYeastStew(math.Clamp(yeastStew - workAmount, 0, 1000000))
		cooler:SetYeastStewSteam(YeastStewSteam + (workAmount * zyb.config.Distillery.DistillAmount))
	end
end

function zyb.f.Distillery_BoilerExplosion(distillery)
	distillery.IsBusy = true

	zyb.f.CreateNetEffect("boiler_explo",distillery)

	distillery:SetYeastStew(0)
	distillery:SetFuel(0)
	distillery:SetPressureLevel(0)

	local cooler = distillery:GetCooler()

	if IsValid(cooler) then
		cooler:SetYeastStewSteam(0)
		cooler:SetWeakMoonShine(0)
		cooler:SetWaterTemperatur(0)
	end

	timer.Simple(2, function()
		if IsValid(distillery) then
			distillery.IsBusy = false
		end
	end)
end
-- leak by lordee