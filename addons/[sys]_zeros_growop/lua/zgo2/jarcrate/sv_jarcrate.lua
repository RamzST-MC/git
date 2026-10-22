--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
if not SERVER then return end
zgo2 = zgo2 or {}
zgo2.JarCrate = zgo2.JarCrate or {}

function zgo2.JarCrate.Initialize(JarCrate)
	JarCrate:SetModel(JarCrate.Model)
	JarCrate:PhysicsInit(SOLID_VPHYSICS)
	JarCrate:SetSolid(SOLID_VPHYSICS)
	JarCrate:SetMoveType(MOVETYPE_VPHYSICS)
	JarCrate:SetUseType(SIMPLE_USE)
	JarCrate:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phy = JarCrate:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(true)
	end

	zclib.EntityTracker.Add(JarCrate)

    JarCrate.WeedList = {}

    JarCrate.LastWeedChange = CurTime()

	zgo2.Destruction.SetupHealth(JarCrate)
end

function zgo2.JarCrate.OnRemove(JarCrate)
    zclib.EntityTracker.Remove(JarCrate)
end

function zgo2.JarCrate.OnUse(JarCrate, ply)

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

    if JarCrate.LastWeedChange and CurTime() < (JarCrate.LastWeedChange + 0.5) then return end

	zgo2.JarCrate.DropRandomJar(JarCrate)

    JarCrate.LastWeedChange = CurTime()
end

function zgo2.JarCrate.OnStartTouch(JarCrate,other)
    if not IsValid(JarCrate) then return end
    if not IsValid(other) then return end
    if JarCrate.LastWeedChange and CurTime() < (JarCrate.LastWeedChange + 0.1) then return end
    if zclib.util.CollisionCooldown(other) then return end
    if other:GetClass() ~= "zgo2_jar" then return end
	if other:GetWeedAmount() <= 0 then return end

	timer.Simple(0.1,function()
		if IsValid(other) then
	    	zgo2.JarCrate.AddWeed(JarCrate,other)
		end
	end)

    JarCrate.LastWeedChange = CurTime()
end

local JarPositions = {
	[ 1 ] = Vector(8, 16, 2),
	[ 2 ] = Vector(8, 0, 2),
	[ 3 ] = Vector(8, -16, 2),
	[ 4 ] = Vector(-8, 16, 2),
	[ 5 ] = Vector(-8, 0, 2),
	[ 6 ] = Vector(-8, -16, 2),
}
function zgo2.JarCrate.AddWeed(JarCrate,Jar)
    zclib.Debug("zgo2.JarCrate.AddWeed")

	local freeSpot
	for i = 1, 6 do
		if not IsValid(JarCrate.WeedList[ i ]) then
			freeSpot = i
			break
		end
	end
	if not freeSpot then return end

	DropEntityIfHeld(Jar)

	Jar:SetPos(JarCrate:LocalToWorld(JarPositions[freeSpot]))
	Jar:SetAngles(JarCrate:GetAngles())
	Jar:SetParent(JarCrate)
	JarCrate.WeedList[freeSpot] = Jar

	Jar.CrateSpot = freeSpot

	JarCrate:EmitSound("zgo2_crate_place")
end

function zgo2.JarCrate.DropRandomJar(JarCrate)
	local jar
	for k,ent in pairs(JarCrate.WeedList) do
		if IsValid(ent) then
			jar = ent
			break
		end
	end

	zgo2.JarCrate.DropJar(JarCrate, jar)
end

local offset = Vector(50, 0, 15)
function zgo2.JarCrate.DropJar(JarCrate, jar,supressSound)
	if not IsValid(jar) then return end
	if not IsValid(JarCrate) then return end

	if JarCrate.WeedList then
		JarCrate.WeedList[ jar.CrateSpot ] = nil
	end
	jar.CrateSpot = nil

	jar:SetParent(nil)
	jar:SetPos(JarCrate:LocalToWorld(offset))
	jar:SetAngles(angle_zero)

	if not supressSound then JarCrate:EmitSound("zgo2_jar_place") end
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher