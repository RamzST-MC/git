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
	Harvest the plant
*/
local offset = Vector(-75,0,25)
function zgo2.Plant.Harvest(Plant,ply)

	if Plant.NextHarvest and Plant.NextHarvest > CurTime() then return end
	Plant.NextHarvest = CurTime() + 0.1

	if zgo2.Weedbranch.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		return
	end

	local Pot = Plant:GetParent()
	local PlantID = Plant:GetPlantID()
	local data = zgo2.Plant.GetData(PlantID)


	local THC = data.weed.thc

	// Keep track when we started to harvest the plant
	if not Plant.HarvestStartTime then Plant.HarvestStartTime = CurTime() end

	// This is the time our plant stayed in the HarvestReady State
	local ExtraTime = Plant.HarvestStartTime - Plant:GetGrowCompletedTime()

	// Calculate how much more thc the weed will get because of longer grow time
	local thc_boost = zgo2.config.Plant.thc_bonus_boost or 10
	local thc_time = zgo2.config.Plant.thc_bonus_time or 300
	local ExtraTHC = math.Clamp((thc_boost / thc_time) * ExtraTime, 0, thc_boost)

	// The final thc value
	THC = math.Clamp(THC + ExtraTHC,0,100)

	// Get weed amount of the plant
	local weed_amount = zgo2.Plant.GetWeedAmount(PlantID)

	if IsValid(Pot) and Pot:GetClass() == "zgo2_pot" then
		local PotData = zgo2.Pot.GetData(Pot:GetPotID())
		weed_amount = weed_amount * PotData.boost_amount
	end

	// If the plant is inside a tent then we get less weed because of the size
	if zgo2.Plant.InsideTent(Plant) then weed_amount = weed_amount * zgo2.config.Plant.tent_weed_penalty end

	// Change the bodygroup count according to cut off branches
	local BodyGroups = Plant:GetBodyGroups()

	// Get the branch count of the plant since this will be the cut count we will need to deconstruct the plant
	local branch_count = table.Count(BodyGroups)
	if zgo2.config.Plant.branch_count and zgo2.config.Plant.branch_count > 0 then branch_count = zgo2.config.Plant.branch_count end

	local WeedPerBranch = math.Round(weed_amount / branch_count)

	// Disable every branch which got cut
	Plant.CutCount = (Plant.CutCount or branch_count) - 1
	for i = 1, branch_count - Plant.CutCount do
		Plant:SetBodygroup(i-1, 1)
	end

	// Send net message to force update the model of the plant from SERVER to all near CLIENTS since the default update interval for zgo2.Plant.OnThink is too slow
	zgo2.Plant.UpdateModel(Plant)

	// Spawn a plant stick
	local ent = ents.Create("zgo2_weedbranch")
	ent:SetPos(Pot:LocalToWorld(offset))
	local ang = Angle(0,0,0)
	ang:Random(-360,360)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()

	ent:SetPlantID(PlantID)
	ent.WeedAmount = WeedPerBranch
	ent.WeedTHC = THC

	zclib.Player.SetOwner(ent, ply)

	local tr = ply:GetEyeTrace()
	local pos = Plant:LocalToWorld(Plant:OBBCenter())
	if tr and tr.HitPos and IsValid(tr.Entity) and tr.Entity:GetClass() == "zgo2_plant" then
		pos = tr.HitPos
	end

	zclib.NetEvent.Create("zgo2_plant_leafexplode", { pos, PlantID, math.Round(zgo2.Pot.GetScale(Pot) * 100) })

	if Plant.CutCount <= 0 then
		zgo2.Pot.Reset(Pot)
	end
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher