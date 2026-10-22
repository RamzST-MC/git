--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Weedbranch = zgo2.Weedbranch or {}
zgo2.Weedbranch.List = zgo2.Weedbranch.List or {}

/*

	WeedBranchs are cut of parts from the weed plant which can be dried and cut

*/
function zgo2.Weedbranch.Initialize(Weedbranch)
	Weedbranch:SetModel(Weedbranch.Model)
	Weedbranch:PhysicsInit(SOLID_VPHYSICS)
	Weedbranch:SetSolid(SOLID_VPHYSICS)
	Weedbranch:SetMoveType(MOVETYPE_VPHYSICS)
	Weedbranch:SetUseType(SIMPLE_USE)
	Weedbranch:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phy = Weedbranch:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(true)
	end

	zclib.EntityTracker.Add(Weedbranch)

	Weedbranch:DrawShadow(false)
	Weedbranch:SetNoDraw(true)

	if zgo2.config.CollisionFix then Weedbranch:SetCustomCollisionCheck( true ) end

	zgo2.Weedbranch.List[Weedbranch] = true

	zgo2.Destruction.SetupHealth(Weedbranch)

	timer.Simple(0.1, function()
		if IsValid(Weedbranch) then
			Weedbranch.Initialized = true
			Weedbranch:SetNoDraw(false)

			// Keep track on which weed just got used
			zgo2.Plant.SetActive(Weedbranch:GetPlantID())
		end
	end)
end

function zgo2.Weedbranch.OnUse(Weedbranch,ply)

	if not Weedbranch.Initialized then return end

	if not Weedbranch:GetIsDried() then
		zclib.Notify(ply, zgo2.language["DryFirst"], 1)
		return
	end

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	zgo2.Weedbranch.OpenClipper(Weedbranch,ply)
end

/*
	Set the weedbranch dry
*/
function zgo2.Weedbranch.SetDry(Weedbranch)

	Weedbranch:SetIsDried(true)

	// Disable normal leafs
	Weedbranch:SetBodygroup(4,1)

	// Enable shrunk leafs
	Weedbranch:SetBodygroup(6,1)
	Weedbranch:SetBodygroup(7,1)
	Weedbranch:SetBodygroup(8,1)

	// Disable hair
	//Weedbranch:SetBodygroup(3,1)
end

/*
	Set the weedbranch cut
*/
function zgo2.Weedbranch.SetCut(Weedbranch,ply)
	if zclib.Entity.GettingRemoved(Weedbranch) then return end

	if zgo2.Jar.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		return
	end


	// TODO Before spawning a new jar lets search for a nearby jar with the same weed id and which has room for weed

	// Spawn weedjar
	local ent = ents.Create("zgo2_jar")
	ent:SetPos(Weedbranch:GetPos())
	ent:Spawn()
	ent:Activate()
	zclib.Player.SetOwner(ent, ply)

	zgo2.Jar.AddWeed(ent, Weedbranch:GetPlantID(), Weedbranch.WeedAmount,Weedbranch.WeedTHC)

	zclib.Entity.SafeRemove(Weedbranch)
end

/*
	Open the interface to play the clipping game
*/
util.AddNetworkString("zgo2.Weedbranch.OpenClipper")
function zgo2.Weedbranch.OpenClipper(Weedbranch,ply)
	net.Start("zgo2.Weedbranch.OpenClipper")
	net.WriteEntity(Weedbranch)
	net.Send(ply)
end

util.AddNetworkString("zgo2.Weedbranch.FinishClip")
net.Receive("zgo2.Weedbranch.FinishClip", function(len,ply)
    zclib.Debug_Net("zgo2.Weedbranch.FinishClip", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

	// This is important since player need atleast 2 seconds to clip a weed and anything below that time is probably just some client cheating using some client hack
	if ply.zgo2_NextClip and CurTime() < ply.zgo2_NextClip then return end
	ply.zgo2_NextClip = CurTime() + 1

    local ent = net.ReadEntity()
	if not IsValid(ent) then return end
	if ent:GetClass() ~= "zgo2_weedbranch" then return end
	if not zclib.util.InDistance(ent:GetPos(),ply:GetPos(), 200) then return end

	if not ent:GetIsDried() then return end

	zgo2.Weedbranch.SetCut(ent,ply)
end)

concommand.Add("zgo2_spawn_weedbranch", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then

        local tr = ply:GetEyeTrace()

        if tr and tr.Hit and tr.HitPos then

            undo.Create("zgo2_spawn_weedbranch")

            local count = 0
			for i = 1, 30 do

				local ent = ents.Create("zgo2_weedbranch")
				ent:SetPos(tr.HitPos + zclib.util.GetRandomPositionInsideCircle(25, 120, 15))
				ent:SetAngles(Angle(0, math.random(360), 0))
				//ent:SetPlantID(2)
				ent:SetPlantID(zgo2.Plant.GetRandomID())
				ent.WeedAmount = 500
				ent.WeedTHC = 50
				zclib.Player.SetOwner(ent, ply)
				ent:Spawn()
				ent:Activate()

				if args[ 1 ] == "1" then
					zgo2.Weedbranch.SetDry(ent)
				end


				undo.AddEntity(ent)
				undo.SetPlayer(ply)

				count = count + 1
			end

            undo.Finish()
        end
    end
end)

/*
	Checks if the player is allowed to spawn another WeedBranch
*/
function zgo2.Weedbranch.ReachedSpawnLimit(ply)
	local count = 0
	for ent,_ in pairs(zgo2.Weedbranch.List) do
		if IsValid(ent) and zclib.Player.IsOwner(ply, ent) then
			count = count + 1
		end
	end

	return count >= zgo2.config.Plant.spawnlimit_weedbranch
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher