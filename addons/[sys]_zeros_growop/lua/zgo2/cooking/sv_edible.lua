--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Edible = zgo2.Edible or {}
zgo2.Edible.List = zgo2.Edible.List or {}

/*

	Edibles can be consumed by players and could make them high

*/

function zgo2.Edible.Initialize(Edible)
	zgo2.Destruction.SetupHealth(Edible)
	zclib.EntityTracker.Add(Edible)

	timer.Simple(0,function()
		if IsValid(Edible) and Edible:GetWeedID() > 0 then Edible:SetBodygroup(0,1) end
	end)
end

function zgo2.Edible.USE(Edible,ply)
	if not IsValid(Edible) then return end
	if not IsValid(ply) then return end

	if Edible:GetWeedID() > 0 then
		zgo2.HighEffect.Start(Edible:GetWeedID(),Edible:GetWeedTHC(),30,ply)
	end

	local EdibleData = zgo2.Edible.GetData(Edible:GetEdibleID())
	if EdibleData == nil then SafeRemoveEntity(Edible) return end

	local _health = EdibleData.health

	local _NewHealth

	// Give the player Energy instead of health if we can find the var for it
	if zclib.Gamemode.Hungermod(ply) then
		_NewHealth = math.Clamp((ply:getDarkRPVar("Energy") or 100) + _health, 0, EdibleData.healthcap)
		ply:setDarkRPVar("Energy", _NewHealth)
	else
		_NewHealth = math.Clamp(ply:Health() + _health, 0, EdibleData.healthcap)
		ply:SetHealth(_NewHealth)
	end

	zclib.Sound.EmitFromPosition(ply:GetPos(),"zgo2_muffin_eat")

	SafeRemoveEntity(Edible)
end

concommand.Add("zgo2_spawn_edibles", function(ply, cmd, args)
	if zclib.Player.IsAdmin(ply) then
		local tr = ply:GetEyeTrace()

		if tr and tr.Hit and tr.HitPos then
			undo.Create("zgo2_spawn_edibles")

			for i = 1, 25 do
				local edible_id = math.random(#zgo2.config.Edibles)
				local edible_data = zgo2.Edible.GetData(edible_id)
				local ent = ents.Create("zgo2_edible")
				ent:SetPos(tr.HitPos + zclib.util.GetRandomPositionInsideCircle(25, 100, 15))
				ent:SetAngles(Angle(0, math.random(360), 0))


				if math.random(10) > 5 then
					ent:SetWeedID(zgo2.Plant.GetRandomID())
					ent:SetWeedAmount(edible_data.weed_capacity)
					ent:SetWeedTHC(100)
				end


				zclib.Player.SetOwner(ent, ply)
				ent:Spawn()
				ent:Activate()
				ent:SetModel(edible_data.edible_model)
				ent:SetEdibleID(edible_id)

				if ent:GetWeedID() > 0 then
					ent:SetBodygroup(0, 1)
				end
				undo.AddEntity(ent)
				undo.SetPlayer(ply)
			end

			undo.Finish()
		end
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher