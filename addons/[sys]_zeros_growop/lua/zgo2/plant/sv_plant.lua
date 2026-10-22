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
function zgo2.Plant.Initialize(Plant)

	Plant:SetModel(zgo2.Plant.GetMesh(zgo2.Plant.GetData(Plant:GetPlantID())))

	Plant:DrawShadow(false)
	Plant:SetUseType(SIMPLE_USE)

	Plant.PhysgunDisabled = true
	Plant.GravGunPickupAllowed = false

	zclib.EntityTracker.Add(Plant)

	zgo2.Plant.GrowTimer(Plant)

	zgo2.Destruction.SetupHealth(Plant)
end

/*
	Will later be used for cutting?
*/
function zgo2.Plant.OnUse(Plant,ply)

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	if zgo2.Plant.HarvestReady(Plant) then

		zgo2.Plant.Harvest(Plant,ply)
	end
end

function zgo2.Plant.StartTouch(Plant,other)
	if not IsValid(other) then return end
	zclib.NetEvent.Create("zgo2_plant_leafrushling", { Plant,other:GetPos() })
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher