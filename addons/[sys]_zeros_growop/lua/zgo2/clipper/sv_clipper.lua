--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Clipper = zgo2.Clipper or {}
zgo2.Clipper.List = zgo2.Clipper.List or {}

/*

	Clippers are used to clip dried weedbranches in to single flowers

*/

function zgo2.Clipper.Initialize(Clipper)
	Clipper:SetModel(Clipper.Model)
	Clipper:PhysicsInit(SOLID_VPHYSICS)
	Clipper:SetSolid(SOLID_VPHYSICS)
	Clipper:SetMoveType(MOVETYPE_VPHYSICS)
	Clipper:SetUseType(CONTINUOUS_USE)
	Clipper:UseClientSideAnimation()
	//Clipper:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phy = Clipper:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Clipper)

	zgo2.Clipper.List[Clipper] = true

	zgo2.Destruction.SetupHealth(Clipper)
end

function zgo2.Clipper.OnUse(Clipper,ply)

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then
		zclib.Notify(ply, zgo2.language["WrongJob"], 1)
		return
	end

	if Clipper.NextTick and CurTime() < Clipper.NextTick then return end

	// If we have a motor then we dont need user input for it to spin
	if Clipper:GetHasMotor() then

		if not Clipper:OnMotorSwitch(ply) then return end

		Clipper.NextTick = CurTime() + 1

		Clipper:EmitSound("buttons/lightswitch2.wav")
		Clipper:SetMotorSwitch(not Clipper:GetMotorSwitch())

		if Clipper:GetMotorSwitch() then

			//if not zgo2.Clipper.CanSpin(Clipper,ply) then return end

			zgo2.Clipper.StartAutoSpinCycle(Clipper)
		else
			zgo2.Clipper.StopSpinCycle(Clipper)
		end
		return
	end
	Clipper.NextTick = CurTime() + 0.20

	if not zgo2.Clipper.CanSpin(Clipper,ply) then return end

	// Start spinning
	zgo2.Clipper.StartSpinCycle(Clipper)

	// If we dont receive any input in the next 0.25 seconds then we are not spinning anymore
	zclib.Timer.Remove("zgo2_Clipper_spin_"..Clipper:EntIndex())
	zclib.Timer.Create("zgo2_Clipper_spin_"..Clipper:EntIndex(), 0.25, 1, function() if IsValid(Clipper) then zgo2.Clipper.StopSpinCycle(Clipper) end end)
end

/*
	Called when something touches the entity
*/
function zgo2.Clipper.OnTouch(Clipper,other)
	if not IsValid(Clipper) then return end
    if not IsValid(other) then return end
	if zclib.util.CollisionCooldown(other) then return end

	if other:GetClass() == "zgo2_battery" then
		if zclib.Entity.GettingRemoved(other) then return end
		DropEntityIfHeld(other)
		zgo2.Clipper.AddPower(Clipper,zgo2.config.Battery.Power)
		zclib.Entity.SafeRemove(other)
	end

	if other:GetClass() == "zgo2_weedbranch" then
		zgo2.Clipper.AddWeedBranch(Clipper,other)
	end

	if other:GetClass() == "zgo2_crate" then
		zgo2.Clipper.AddWeedCrate(Clipper,other)
	end

	if Clipper.Unloading then return end

	if other:GetClass() == "zgo2_jar" then
		zgo2.Clipper.AddJar(Clipper,other)
	end

	if other:GetClass() == "zgo2_motor" then
		zgo2.Clipper.InstallMotor(Clipper,other)
	end
end

/*
	Called when the entity gets removed
*/
function zgo2.Clipper.OnRemove(Clipper)
	zclib.Timer.Remove("zgo2_Clipper_autospin_"..Clipper:EntIndex())
end

/*
	Returns true if we can spin
*/
function zgo2.Clipper.CanSpin(Clipper,ply)

	if Clipper:GetHasMotor() and Clipper.Unloading then return false end

	// We are missing weed
	if Clipper:GetWeedID() <= 0 then
		zclib.Notify(ply,zgo2.language["Missing Weed"], 1)
		return false
	end

	// We are missing a jar
	if not IsValid(Clipper.Jar) then
		zclib.Notify(ply,zgo2.language["Missing Jar"], 1)
		return false
	end

	// Stop if the weed ids dont match
	if Clipper.Jar:GetWeedID() > 0 and Clipper.Jar:GetWeedID() ~= Clipper:GetWeedID() then
		zclib.Notify(ply,zgo2.language["WrongWeedTypeJar"], 1)
		return false
	end
	return true
end

/*
	Starts the auto spin cycle
*/
function zgo2.Clipper.StartAutoSpinCycle(Clipper)
	if not Clipper:GetHasMotor() then return end

	local timerid = "zgo2_Clipper_autospin_"..Clipper:EntIndex()

	if not Clipper:GetMotorSwitch() then
		zclib.Timer.Remove(timerid)
		return
	end

	if timer.Exists(timerid) then return end

	zclib.Timer.Remove(timerid)
	zclib.Timer.Create(timerid, 0.1, 0, function()
		if not IsValid(Clipper) then
			zclib.Timer.Remove(timerid)
			return
		end
		if Clipper.NextPowerConsumption == nil or CurTime() > Clipper.NextPowerConsumption then
			Clipper:SetPower(math.Clamp(Clipper:GetPower() - Clipper:GetPowerNeed(), 0, zgo2.config.Battery.Power))
			Clipper.NextPowerConsumption = CurTime() + 1
		end

		if Clipper:GetPower() <= 0 then
			zgo2.Clipper.StopSpinCycle(Clipper)
		else
			zgo2.Clipper.StartSpinCycle(Clipper)
		end
	end)
end

/*
	Starts the spin cycle
*/
function zgo2.Clipper.StartSpinCycle(Clipper)

	// We are spinning
	Clipper:SetSpin(true)

	if not zgo2.Clipper.CanSpin(Clipper) then return end

	// Increase the progress
	Clipper:SetProgress(Clipper:GetProgress() + 10)

	// We aint completed the progess yet
	if Clipper:GetProgress() < 100 then return end

	// Reset back to start
	Clipper:SetProgress(0)

	// Play output animation
	zclib.NetEvent.Create("zgo2_clipper_play",{Clipper})

	// How much weed got processed
	local amount = Clipper:GetWeedAmount() / Clipper:GetStickCount()

	local id = Clipper:GetWeedID()

	Clipper.Unloading = true

	// Add it to the jar
	zgo2.Jar.AddWeed(Clipper.Jar, id, amount, Clipper.WeedTHC)

	// We delay this because it should only occur after the animation is done playing
	timer.Simple(1.25,function()
		if not IsValid(Clipper) then return end

		// Drop the jar
		if IsValid(Clipper.Jar) and Clipper.Jar:GetWeedAmount() >= zgo2.config.Jar.Capacity then
			zgo2.Clipper.DropJar(Clipper)
		end

		Clipper.Unloading = nil
	end)

	// Remove a stick
	Clipper:SetStickCount(math.Clamp(Clipper:GetStickCount() - 1, 0, 99))

	// Remove the weed amount
	Clipper:SetWeedAmount(math.Clamp(Clipper:GetWeedAmount() - amount, 0, 999999999999))

	// If we dont have any weed anymore then reset
	if Clipper:GetWeedAmount() <= 0 then
		Clipper:SetStickCount(0)
		Clipper:SetWeedID(0)
	end
end

/*
	Stops the spin cycle
*/
function zgo2.Clipper.StopSpinCycle(Clipper)
	Clipper:SetSpin(false)
	zclib.Timer.Remove("zgo2_Clipper_autospin_"..Clipper:EntIndex())
end

/*
	Install a motor
*/
function zgo2.Clipper.InstallMotor(Clipper, motor,FromMultitool)

	// Do we already have a motor installed?
	if Clipper:GetHasMotor() then return end
	if zclib.Entity.GettingRemoved(motor) then return end

	zclib.Sound.EmitFromEntity("zgo2_install", Clipper)

	if FromMultitool then
		Clipper:SetHasMotor(true)
		Clipper:SetBodygroup(1,1)
		Clipper:SetBodygroup(2,1)
		Clipper:SetBodygroup(3,1)
		Clipper:SetBodygroup(0,1)
		return
	end

	DropEntityIfHeld(motor)
	motor:SetNoDraw(true)

	timer.Simple(0.1,function()
		if not IsValid(motor) then return end
		zclib.Entity.SafeRemove(motor)
		if not IsValid(Clipper) then return end
		Clipper:SetHasMotor(true)
		Clipper:SetBodygroup(1,1)
		Clipper:SetBodygroup(2,1)
		Clipper:SetBodygroup(3,1)
		Clipper:SetBodygroup(0,1)
	end)
end

/*
	Adds power to the Clipper battery
*/
function zgo2.Clipper.AddPower(Clipper,power)
	local before = Clipper:GetPower()
	Clipper:SetPower(math.Clamp(Clipper:GetPower() + power, 0, zgo2.config.Battery.Power))
	local after = Clipper:GetPower()

	if Clipper:GetHasMotor() then zgo2.Clipper.StartAutoSpinCycle(Clipper) end

	// Tells us how much energy got added
	return after - before
end

/*
	Adds a jar to the Clipper
*/
local ang01 = Angle(-120,0,0)
local ang02 = Angle(90,0,0)
local vec01 = Vector(-10, 0, 3)
function zgo2.Clipper.AddJar(Clipper, jar)
	if IsValid(Clipper.Jar) then return end

	if jar:GetWeedID() > 0 and Clipper:GetWeedID() > 0 and jar:GetWeedID() ~= Clipper:GetWeedID() then return end

	if jar:GetWeedAmount() >= zgo2.config.Jar.Capacity then return end

	Clipper.Jar = jar

	DropEntityIfHeld(jar)

	jar:EmitSound("zgo2_jar_place")

	jar:ManipulateBoneAngles(jar:LookupBone("metal01_jnt"),ang01)
	jar:ManipulateBoneAngles(jar:LookupBone("metal02_jnt"),ang02)

	timer.Simple(0.1, function()
		if not IsValid(jar) then return end
		if not IsValid(Clipper) then return end

		jar:SetPos(Clipper:LocalToWorld(vec01))
		jar:SetAngles(Clipper:GetAngles())
		jar:SetParent(Clipper)

		if Clipper:GetHasMotor() then zgo2.Clipper.StartAutoSpinCycle(Clipper) end
	end)
end

/*
	Drops the jar from the Clipper
*/
local vec02 = Vector(-35, 0, 2)
function zgo2.Clipper.DropJar(Clipper)
	if not IsValid(Clipper.Jar) then return end

	Clipper.Jar:EmitSound("zgo2_jar_place")

	Clipper.Jar:SetParent(nil)
	Clipper.Jar:SetPos(Clipper:LocalToWorld(vec02))
	Clipper.Jar:SetAngles(Clipper:GetAngles())

	Clipper.Jar:ManipulateBoneAngles(Clipper.Jar:LookupBone("metal01_jnt"),angle_zero)
	Clipper.Jar:ManipulateBoneAngles(Clipper.Jar:LookupBone("metal02_jnt"),angle_zero)

	Clipper.Jar = nil
end

/*
	Adds a weedbrach to the Clipper
*/
function zgo2.Clipper.AddWeed(Clipper,WeedID,WeedAmount,WeedTHC)
	Clipper:SetWeedID(WeedID)
	Clipper:SetWeedAmount(Clipper:GetWeedAmount() + WeedAmount)
	Clipper:SetStickCount(Clipper:GetStickCount() + 1)

	Clipper.WeedTHC = (Clipper.WeedTHC or 0) + WeedTHC

	if Clipper:GetStickCount() > 1 then Clipper.WeedTHC = Clipper.WeedTHC / 2 end
end

/*
	Adds a weedbrach to the Clipper
*/
function zgo2.Clipper.AddWeedBranch(Clipper,weedbranch)

	if not weedbranch:GetIsDried() then return end

	// Do we already have a WeedBranch?
	if Clipper:GetWeedID() > 0 and weedbranch:GetPlantID() ~= Clipper:GetWeedID() then return end

	if Clipper:GetStickCount() > zgo2.config.Clipper.Limit then return end
	if zclib.Entity.GettingRemoved(weedbranch) then return end

	DropEntityIfHeld(weedbranch)

	weedbranch:SetNoDraw(true)

	timer.Simple(0.25,function()
		if not IsValid(weedbranch) then return end
		if not IsValid(Clipper) then return end

		zgo2.Clipper.AddWeed(Clipper,weedbranch:GetPlantID(),weedbranch.WeedAmount,weedbranch.WeedTHC)

		zclib.Entity.SafeRemove(weedbranch)

		if Clipper:GetHasMotor() then zgo2.Clipper.StartAutoSpinCycle(Clipper) end
	end)
end

/*
	Adds a the WeedBranches from a crate to the Clipper
*/
function zgo2.Clipper.AddWeedCrate(Clipper,Crate)
	if not Crate.WeedBranches then return end

	for k,v in pairs(Crate.WeedBranches) do
		// Dont add the dried ones
		if not v.dried then continue end

		if Clipper:GetWeedID() > 0 and v.id ~= Clipper:GetWeedID() then continue end

		if Clipper:GetStickCount() > zgo2.config.Clipper.Limit then break end

		zgo2.Clipper.AddWeed(Clipper, v.id, v.amount, v.thc)

		v.remove = true
	end

	local list = table.Copy(Crate.WeedBranches)
	Crate.WeedBranches = {}
	for k,v in pairs(list) do
		if v.remove then continue end
		table.insert(Crate.WeedBranches,v)
	end

	zgo2.Crate.Update(Crate)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher