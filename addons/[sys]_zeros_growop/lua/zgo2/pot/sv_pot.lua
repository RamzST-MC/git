--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Pot = zgo2.Pot or {}
zgo2.Pot.List = zgo2.Pot.List or {}

/*

	The player can grow plants in pots if the bot has soil in it

*/
function zgo2.Pot.Initialize(Pot)
	local mdl = zgo2.Pot.GetModel(Pot:GetPotID())

	Pot:SetModel(mdl)
	Pot:PhysicsInit(SOLID_VPHYSICS)
	Pot:SetSolid(SOLID_VPHYSICS)
	Pot:SetMoveType(MOVETYPE_VPHYSICS)
	Pot:SetUseType(SIMPLE_USE)
	Pot:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phy = Pot:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Pot)

	zclib.util.CallDelayed(Pot,function()
		Pot:SetModelScale(zgo2.Pot.GetScale(Pot),0.0001)

		if zgo2.Pot.HasHoseConnection(Pot) then
			Pot:SetBodygroup(2,1)
		end
	end)

	zgo2.Pot.List[Pot] = true

	zgo2.Destruction.SetupHealth(Pot)
end

function zgo2.Pot.OnRemove(Pot)
	zgo2.Pot.ReEvaluateProximity(Pot)
end

function zgo2.Pot.AddSoil(Pot)
	Pot:SetHasSoil(true)
	Pot:SetBodygroup(0,1)
	zgo2.Pot.UpdateSkin(Pot)
	Pot:EmitSound("player/footsteps/gravel4.wav")

	zclib.NetEvent.Create("zgo2_pot_adddirt",{Pot})
end

function zgo2.Pot.AddSeed(Pot, SeedID)
	local plant = ents.Create("zgo2_plant")

	local min, max = Pot:GetCollisionBounds()
	local height = (min.z + max.z) * zgo2.Pot.GetScale(Pot)

	plant:SetPos(Pot:LocalToWorld(Vector(0, 0, height * 0.5)))
	plant:SetAngles(Pot:LocalToWorldAngles(Angle(0, math.random(360), 0)))
	plant:SetParent(Pot)
	plant:SetPlantID(SeedID)
	plant:Spawn()
	plant:Activate()

	zclib.Player.SetOwner(plant, zclib.Player.GetOwner(Pot))

	// Keep track on which weed just got used
	zgo2.Plant.SetActive(SeedID)

	Pot:SetPlant(plant)
	Pot:EmitSound("player/footsteps/gravel1.wav")

	return plant
end

/*
	Gets called to add water
*/
function zgo2.Pot.AddWater(Pot,amount)
	Pot:SetWater(math.Clamp(Pot:GetWater() + (amount or 1),0,zgo2.Pot.GetWaterLimit(Pot)))
	zgo2.Pot.UpdateSkin(Pot)
end

/*
	Gets called when the plant uses some water
*/
function zgo2.Pot.UseWater(Pot,amount)
	Pot:SetWater(math.Clamp(Pot:GetWater() - (amount or 1),0,zgo2.Pot.GetWaterLimit(Pot)))
	zgo2.Pot.UpdateSkin(Pot)
end

/*
	Updates the soil skin
*/
function zgo2.Pot.UpdateSkin(Pot)
	if Pot:GetWater() <= 0 then
		Pot:SetSkin(0)
	else
		Pot:SetSkin(1)
	end
end

/*
	Resets the pot
*/
function zgo2.Pot.Reset(Pot)

	local plant = Pot:GetPlant()
	if IsValid(plant) then zclib.Entity.SafeRemove(plant) end

	Pot:SetPlant(NULL)
	Pot:SetHasSoil(false)
	Pot:SetWater(0)
	Pot:SetBodygroup(0,0)
	zgo2.Pot.UpdateSkin(Pot)
	Pot:EmitSound("player/footsteps/gravel4.wav")
end

concommand.Add("zgo2_spawn_plants", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr and tr.Hit and tr.HitPos then

			local size = 80

            undo.Create("zgo2_spawn_plants")
            local y = 0
            local x = 0
            local count = 0
			for i = 1,30 do

                if count > 5 then
                    count = 0
                    y = 0
                    x = x + size
                end

				local ent = ents.Create("zgo2_pot")
				ent:SetPos(tr.HitPos + Vector(x, y , 1))
				ent:SetAngles(Angle(0,math.random(360),0))
				ent:Spawn()
				ent:Activate()

				ent:SetPotID(2)


				zclib.Player.SetOwner(ent, ply)

				zgo2.Pot.AddSoil(ent)
				zgo2.Pot.AddWater(ent,1000)

				if args and args[ 1 ] and zgo2.Plant.GetListID(args[ 1 ]) then
					zgo2.Pot.AddSeed(ent, zgo2.Plant.GetListID(args[ 1 ]))
				else
					zgo2.Pot.AddSeed(ent, zgo2.Plant.GetRandomID())
				end
				//zgo2.Pot.AddSeed(ent,2)

				zgo2.Plant.SetHarvestReady(ent:GetPlant())

				zclib.Player.SetOwner(ent:GetPlant(), ply)

                undo.AddEntity(ent)
                undo.SetPlayer(ply)

                y = y + size
                count = count + 1
            end

            undo.Finish()
        end
    end
end)

concommand.Add("zgo2_spawn_leafexplode", function(ply, cmd, args)
	if zclib.Player.IsAdmin(ply) then
		for k, v in pairs(ents.FindByClass("zgo2_plant")) do
			if not IsValid(v) then continue end

			zclib.NetEvent.Create("zgo2_plant_leafrushling", { v , v:GetPos() })
		end
	end
end)

concommand.Add("zgo2_debug_seedall", function(ply, cmd, args)
	if zclib.Player.IsAdmin(ply) then
		for k, v in pairs(ents.FindByClass("zgo2_pot")) do
			if not IsValid(v) then continue end
			zgo2.Pot.Reset(v)
			zgo2.Pot.AddSoil(v)
			zgo2.Pot.AddWater(v,1000)
			zgo2.Pot.AddSeed(v,zgo2.Plant.GetRandomID())
			zgo2.Plant.SetHarvestReady(v:GetPlant())
		end
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher