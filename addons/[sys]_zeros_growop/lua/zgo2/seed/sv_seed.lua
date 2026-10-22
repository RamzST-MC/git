--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Seed = zgo2.Seed or {}
zgo2.Seed.List = zgo2.Seed.List or {}

/*

	The player can grow plants in Seeds if the bot has soil in it

*/
function zgo2.Seed.Initialize(Seed)
	Seed:SetModel(Seed.Model)
	Seed:PhysicsInit(SOLID_VPHYSICS)
	Seed:SetSolid(SOLID_VPHYSICS)
	Seed:SetMoveType(MOVETYPE_VPHYSICS)
	Seed:SetUseType(SIMPLE_USE)
	Seed:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phy = Seed:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(true)
	end

	zclib.EntityTracker.Add(Seed)

	// Keep track on which weed just got used
	zgo2.Plant.SetActive(Seed:GetPlantID())

	zgo2.Destruction.SetupHealth(Seed)
end

function zgo2.Seed.OnUse(Seed,ply)
	// Start pointing system to ask where the seeds should be planted
	zgo2.Seed.Place(Seed,ply)
end


util.AddNetworkString("zgo2.Seed.Place")
function zgo2.Seed.Place(Seed,ply)
	net.Start("zgo2.Seed.Place")
	net.WriteEntity(Seed)
	net.Send(ply)
end

net.Receive("zgo2.Seed.Place", function(len,ply)
    zclib.Debug_Net("zgo2.Seed.Place", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local seed = net.ReadEntity()

	if not IsValid(seed) then return end
	if seed:GetClass() ~= "zgo2_seed" then return end
	if not zclib.util.InDistance(seed:GetPos(),ply:GetPos(), 400) then return end

	if zclib.Entity.GettingRemoved(seed) then return end

	local tr = ply:GetEyeTrace()
	if tr and tr.Entity and IsValid(tr.Entity) and tr.Entity:GetClass() == "zgo2_pot" and tr.Entity:GetHasSoil() and not IsValid(tr.Entity:GetPlant()) then

		if not zgo2.Pot.GotPlaced(tr.Entity) then
			zclib.Notify(ply,zgo2.language[ "PotMissingRack" ], 1)
			return
		end

		if zgo2.Pot.AddSeed(tr.Entity,seed:GetPlantID(),ply) then
			seed:SetCount(seed:GetCount() - 1)
			if seed:GetCount() <= 0 then
				zclib.Entity.SafeRemove(seed)
			else
				zgo2.Seed.Place(seed,ply)
			end
		end
	end
end)


concommand.Add("zgo2_spawn_seed", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr and tr.Hit and tr.HitPos then

            undo.Create("zgo2_spawn_seed")

            local count = 0
			for i = 1, 30 do

				local ent = ents.Create("zgo2_seed")
				ent:SetPos(tr.HitPos + zclib.util.GetRandomPositionInsideCircle(25, 120, 15))
				ent:SetAngles(Angle(0, math.random(360), 0))
				ent:SetPlantID(zgo2.Plant.GetRandomID())
				zclib.Player.SetOwner(ent, ply)
				ent:Spawn()
				ent:Activate()

				undo.AddEntity(ent)
				undo.SetPlayer(ply)

				count = count + 1
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