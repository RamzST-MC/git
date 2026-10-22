--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Pot = zgo2.Pot or {}
zgo2.Pot.List = zgo2.Pot.List or {}

if not zgo2.config.Plant.proximity_check then return end

/*

	This system keeps track on the distance between plants

*/
function zgo2.Pot.PerformCrampedCheck(Pot)
	if not zgo2.config.Plant.proximity_check then return end

	if not IsValid(Pot) then return end

	Pot.NeighborPots = {}

	local pos = Pot:GetPos()

	// Recalculate if this pot is too close to another pot
	local dist = 40
	// TODO Would a ents.FindInSphere(Vector origin,number radius) be more optimized then looping through every single pot and calculating distance?
	for other,_ in pairs(zgo2.Pot.List) do
		if not IsValid(other) then continue end
		if other == Pot then continue end
		if pos:DistToSqr(other:GetPos()) < (dist * dist) then

			Pot.NeighborPots[other] = true
		end
	end

	Pot:SetIsCramped(table.Count(Pot.NeighborPots) > 0)

	for pot,_ in pairs(Pot.NeighborPots) do
		pot:SetIsCramped(true)
	end
end

function zgo2.Pot.ReEvaluateProximity(Pot)
	// Recalculate his neighbors
	for neigh, _ in pairs(Pot.NeighborPots or {}) do
		if neigh == Pot then continue end

		timer.Simple(0.5, function()
			if IsValid(neigh) then
				zgo2.Pot.PerformCrampedCheck(neigh)
			end
		end)
	end

	// Recalculate himself
	zgo2.Pot.PerformCrampedCheck(Pot)
end

local timerid = "zgo2_plant_proximitychecker"
zclib.Timer.Remove(timerid)
zclib.Timer.Create(timerid, 3, 0, function()
	for pot,_ in pairs(zgo2.Pot.List) do
		if not IsValid(pot) then continue end

		// Did the position change?
		local pos = pot:GetPos()
		if pos ~= pot.LastPos then
			pot.LastPos = pos

			zgo2.Pot.ReEvaluateProximity(pot)
		end
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher