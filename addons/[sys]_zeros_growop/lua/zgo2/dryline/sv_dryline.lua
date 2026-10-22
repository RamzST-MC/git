--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Dryline = zgo2.Dryline or {}
zgo2.Dryline.List = zgo2.Dryline.List or {}

/*

	Drylines are used to dry weed, they are 2 anker points connected by a rope / line

*/

function zgo2.Dryline.Initialize(Dryline)
	Dryline:SetModel(Dryline.Model)
	Dryline:PhysicsInit(SOLID_VPHYSICS)
	Dryline:SetSolid(SOLID_VPHYSICS)
	Dryline:SetMoveType(MOVETYPE_VPHYSICS)
	Dryline:SetUseType(SIMPLE_USE)
	Dryline:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phy = Dryline:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Dryline)

	zgo2.Dryline.List[Dryline] = true

	Dryline.WeedBranches = {}

	// How many branches can we place on the line
	// NOTE This gets set when we set the endpoint since the branch limit depends on the length of the rope
	Dryline.BranchLimit = -1

	zgo2.Destruction.SetupHealth(Dryline)
end

function zgo2.Dryline.OnUse(Dryline,ply)

	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	// Check if the players trace HitPos is near the start or end point of the rope
	local tr = ply:GetEyeTrace()
	if not tr then return end
	if not tr.HitPos then return end

	// debugoverlay.Sphere(tr.HitPos,1,1,Color( 0,255, 0 ),true)

	// Find if a spot is near this HitPos
	local DroppedWeed
	for i = 1, Dryline.BranchLimit do
		if not Dryline.WeedBranches[ i ] then continue end

		if zgo2.Dryline.IsDried(Dryline,i) then
			local fract = (1 / Dryline.BranchLimit) * i
			local spot_pos = Dryline:WorldToLocal(Lerp(fract, Dryline:GetPos(), Dryline:GetEndPoint()))
			local test_pos = Dryline:WorldToLocal(tr.HitPos)
			if test_pos.z > (spot_pos.z - 25) and test_pos.z < (spot_pos.z + 25) then
				zgo2.Dryline.RemoveWeed(Dryline, i,ply)
				DroppedWeed = true
			end
		end
	end
	if DroppedWeed then return end

	// Lets use those checks to specify if we wanna change the start or end point
	if zclib.util.InDistance(tr.HitPos, Dryline:GetPos(), 25) then

		// If the end point equals the start point then the ropes end point was not setup yet so lets do that first
		if Dryline:GetEndPoint() == Dryline:GetPos() then
			zgo2.Dryline.StartPointer(Dryline, ply, false)
		else
			zgo2.Dryline.StartPointer(Dryline, ply, true)
		end
	elseif zclib.util.InDistance(tr.HitPos, Dryline:GetEndPoint(), 25) then
		zgo2.Dryline.StartPointer(Dryline, ply, false)
	end
end

function zgo2.Dryline.OnTouch(Dryline,other)
	if not IsValid(Dryline) then return end
    if not IsValid(other) then return end
	local class = other:GetClass()
	if class ~= "zgo2_weedbranch" and class ~= "zgo2_crate" then return end
	if zclib.util.CollisionCooldown(other) then return end

	if class == "zgo2_weedbranch" then
		zgo2.Dryline.AddWeed(Dryline,other)
		return
	end

	if class == "zgo2_crate" then
		zgo2.Dryline.AddWeedCrate(Dryline,other)
	end
end

/*
	Here we setup the length / endpoint of the line
*/
util.AddNetworkString("zgo2.Dryline.StartPointer")
function zgo2.Dryline.StartPointer(Dryline,ply,IsStartPoint)
	zclib.Debug("zgo2.Dryline.StartPointer")
	net.Start("zgo2.Dryline.StartPointer")
	net.WriteEntity(Dryline)
	net.WriteBool(IsStartPoint)
	net.Send(ply)
end

util.AddNetworkString("zgo2.Dryline.SetPoint")
net.Receive("zgo2.Dryline.SetPoint", function(len,ply)
	zclib.Debug_Net("zgo2.Dryline.SetPoint", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Dryline = net.ReadEntity()
	local IsStartPoint = net.ReadBool()
	if not IsValid(Dryline) then return end
	if Dryline:GetClass() ~= "zgo2_dryline" then return end

	local tr = zclib.util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = {ply,Dryline},
	}, "zgo2.Dryline.SetPoint")
	if not tr then return end
	if not tr.HitPos then return end
	if not tr.Entity then return end
	if zgo2.config.Dryline.WorldOnly and not tr.Entity:IsWorld() then return end
	if not zclib.util.InDistance(IsStartPoint and Dryline:GetEndPoint() or Dryline:GetPos(),tr.HitPos, zgo2.config.Dryline.Distance) then return end

	local ang = tr.HitNormal:Angle()
	ang:RotateAroundAxis(ang:Right(), -90)
	zgo2.Dryline.SetEndPoint(Dryline, IsStartPoint, ang, tr.HitPos, ply)
end)

local function GetBoxData(Dryline)

    local self_pos = Dryline:GetPos()
    local parent_pos = Dryline:GetEndPoint()
    local self_ang = Dryline:GetAngles()

    debugoverlay.Axis(self_pos,self_ang,15,0.1,true)

    parent_pos = parent_pos - Dryline:GetRight() * 40

    local dist = math.Distance( self_pos.x,self_pos.y, parent_pos.x,parent_pos.y )

    local w,l,h = dist,10,30

    local min = Vector(-w-20, -l / 2 , -10)
    local max = Vector(20, l / 2, h)

    local rot = 90

    max:Rotate(Angle(rot,0,0))
    min:Rotate(Angle(rot,0,0))

    return min,max
end

function zgo2.Dryline.SetEndPoint(Dryline,IsStartPoint,HitAngle,HitPos,ply)

	local cost = zgo2.Dryline.GetCost(IsStartPoint and Dryline:GetEndPoint() or Dryline:GetPos(),HitPos)

	if IsValid(ply) then
		if not zclib.Money.Has(ply,cost) then
			zclib.Notify(ply, zgo2.language[ "NotEnoughMoney" ], 1)
			return
		end

		zclib.Money.Take(ply, cost)
		zclib.Notify(ply, "-" .. zclib.Money.Display(cost), 0)

		// This needs to be added to the logbook
		hook.Run("zgo2.Dryline.OnRopeChange", Dryline, ply, cost)
	end

	if IsStartPoint then
		Dryline:SetPos(HitPos)
		Dryline:SetWallAngle(HitAngle)
		Dryline:SetAngles(HitAngle)
	else
		Dryline:SetEndPoint(HitPos)
		Dryline:SetWallEndAngle(HitAngle)
	end

	if zgo2.config.CollisionFix then Dryline:CollisionRulesChanged() end

	local dir = Dryline:GetEndPoint() - Dryline:GetPos()
	local ang = dir:Angle()
	ang:RotateAroundAxis(ang:Right(),-90)
	Dryline:SetAngles(ang)

	Dryline.BranchLimit = nil
	Dryline.BranchLimit = zgo2.Dryline.GetBranchLimit(Dryline)

	Dryline:EmitSound("weapons/crossbow/hit1.wav")

	// Rebuild the physics mesh
	local min,max = GetBoxData(Dryline)
	local x0 = min.x
	local y0 = min.y
	local z0 = min.z
	local x1 = max.x
	local y1 = max.y
	local z1 = max.z
	Dryline:PhysicsInitConvex( {
		Vector( x0, y0, z0 ),
		Vector( x0, y0, z1 ),
		Vector( x0, y1, z0 ),
		Vector( x0, y1, z1 ),

		Vector( x1, y0, z0 ),
		Vector( x1, y0, z1 ),
		Vector( x1, y1, z0 ),
		Vector( x1, y1, z1 )
	} )

	Dryline:SetSolid( SOLID_VPHYSICS )

	Dryline:SetMoveType( MOVETYPE_VPHYSICS  )
	Dryline:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	Dryline:SetSolid(SOLID_VPHYSICS)

	local phy = Dryline:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end
	Dryline:SetCollisionBounds(min,max)
	Dryline:EnableCustomCollisions( true )

	Dryline.PhysgunDisabled = true

	// Throw off any weedbrachenes that dont fit
	local count = 0
	for spot,ent in pairs(Dryline.WeedBranches) do
		if count >= Dryline.BranchLimit then
			zgo2.Dryline.RemoveWeed(Dryline,spot)
			continue
		end
		count = count + 1
	end

	zgo2.Dryline.Update(Dryline)
end



/*
	Find a free spot
*/
function zgo2.Dryline.GetFreeSpot(Dryline)
	local spot
	for i=1,Dryline.BranchLimit do
		if not Dryline.WeedBranches[i] then
			spot = i
			break
		end
	end
	return spot
end

/*
	Adds a weedbrach to the dryline
*/
function zgo2.Dryline.AddWeed(Dryline,weedbranch)

	// Is this dryline even setup yet?
	if Dryline.BranchLimit <= 0 then return end

	// Do we have a free spot?
	local spot = zgo2.Dryline.GetFreeSpot(Dryline)
	if not spot then return end

	if weedbranch:GetIsDried() then return end

	if weedbranch.IsDrying then return end

	if zclib.Entity.GettingRemoved(weedbranch) then return end

	weedbranch.IsDrying = true

	DropEntityIfHeld(weedbranch)
	weedbranch:SetNoDraw(true)

	timer.Simple(0.25,function()
		if not IsValid(weedbranch) then return end
		if not IsValid(Dryline) then return end

		Dryline.WeedBranches[spot] = {
			id =  weedbranch:GetPlantID(),
			amount = weedbranch.WeedAmount or 50,
			thc = weedbranch.WeedTHC or 50,
			time = math.Round(CurTime())
		}

		zclib.Entity.SafeRemove(weedbranch)

		// Send a net message to all clients informing them that the weedbanch count changed
		zgo2.Dryline.Update(Dryline)
	end)
end

/*
	Adds a the WeedBranches from a crate to the dryline
*/
function zgo2.Dryline.AddWeedCrate(Dryline,Crate)

	// Is this dryline even setup yet?
	if Dryline.BranchLimit <= 0 then return end

	if Crate.WeedBranches == nil then Crate.WeedBranches = {} end

	// Check if we got any Dried WeedBranches on the line to collect
	local RemovedWeed = false
	for k,v in pairs(Dryline.WeedBranches) do

		if zgo2.Dryline.IsDried(Dryline,k) then

			local spot = zgo2.Crate.GetFreeSpot(Crate)
			if spot then
				Crate.WeedBranches[spot] = {
					id =  v.id,
					amount = v.amount,
					thc = v.thc,
					dried = true
				}
				Dryline.WeedBranches[k] = nil
				RemovedWeed = true
			end
		end
	end

	local AddedWeed = false
	for k,v in pairs(Crate.WeedBranches) do
		// Dont add the dried ones
		if v.dried then continue end

		// Do we have a free spot?
		local spot = zgo2.Dryline.GetFreeSpot(Dryline)
		if not spot then continue end

		Dryline.WeedBranches[spot] = {
			id =  v.id,
			amount = v.amount,
			thc = v.thc,
			time = math.Round(CurTime())
		}
		AddedWeed = true
		v.remove = true
	end

	if not AddedWeed and not RemovedWeed then return end

	local list = table.Copy(Crate.WeedBranches)
	Crate.WeedBranches = {}
	for k,v in pairs(list) do
		if v.remove then continue end
		table.insert(Crate.WeedBranches,v)
	end

	zgo2.Dryline.Update(Dryline)

	zgo2.Crate.Update(Crate)
end

/*
	Removes a weedbrach from the dryline
*/
function zgo2.Dryline.RemoveWeed(Dryline,spot,ply)

	local WeedData = Dryline.WeedBranches[spot]
	if not WeedData then return end

	if zgo2.Weedbranch.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		return
	end

	Dryline.WeedBranches[spot] = nil

	local ent = ents.Create("zgo2_weedbranch")
	ent:SetPos(Lerp((1 / Dryline.BranchLimit) * spot, Dryline:GetPos(), Dryline:GetEndPoint()) + Vector(0,0,15))
	ent:Spawn()
	ent:Activate()
	ent:SetPlantID(WeedData.id)
	ent.WeedAmount = WeedData.amount
	ent.WeedTHC = WeedData.thc

	zgo2.Weedbranch.SetDry(ent)

	zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_plant_hang")

	zclib.Player.SetOwner(ent, ply)

	// Send a net message to all clients informing them that the weedbanch count changed
	zgo2.Dryline.Update(Dryline)

	return ent
end

/*
	Send a net message to all clients informing them that the weedbanch count changed
*/
util.AddNetworkString("zgo2.Dryline.Update")
function zgo2.Dryline.Update(Dryline)
	net.Start("zgo2.Dryline.Update",true)
	net.WriteEntity(Dryline)
	net.WriteUInt(table.Count(Dryline.WeedBranches),20)
	for spot,data in pairs(Dryline.WeedBranches) do
		net.WriteUInt(spot,20)
		net.WriteUInt(data.id,20)
		net.WriteUInt(data.amount,20)
		net.WriteUInt(math.Round(data.time),32)
	end
	net.Broadcast()
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher