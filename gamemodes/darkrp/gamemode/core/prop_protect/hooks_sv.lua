local oktools = {
	["#Tool.advdupe2.name"] = true,
	["#Tool.stacker.name"] = true
}

local usergr = {
	["user"] = 40,
	["vip"] = 70,
	["dvip"] = 100,
	["dmoder"] = 200,
	["dadmin"] = 210,
	["dsuperadmin"] = 220,
	["downer"] = 230,
	["probation"] = 235,
	["helper"] = 240,
	["naboradmin"] = 245,
	["moder"] = 250,
	["admin"] = 260,
	["superadmin"] = 270,
	["owner"] = 570,
	["subcurator"] = 10000,
	["curator"] = 10000,
	["root"] = 10000,
}

hook.Add('PlayerSpawnProp', 'PropLimit', function(pl)
	local new = rp.cfg.PropLimits[pl:GetUserGroup()] or rp.cfg.PropLimits['user'] or 40
	local pig = pl:HasPurchase('15_prop_limit') or 0
	if pl:GetCount('props') >= new + pig * 15 then
		rp.Notify(pl, NOTIFY_ERROR, 'Вы достигли лимита пропов!')
		return false
	end
end)

hook('PlayerSpawnProp', 'pp.PlayerSpawnProp', function(pl, mdl)
	local tool = pl:GetTool()
	if pl.lastPropSpawn and (pl.lastPropSpawn > CurTime() - .25) and ((tool == nil) or not oktools[tool.Name]) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('SpawnPropsSoFast'))
		if pl.failedPropAttempts and (pl.failedPropAttempts >= 5) and (pl.toldStaff ~= true) then
			ba.notify_staff('# создал более 5 пропов в секунду. Не спускай глаз с него!', pl)
			pl.toldStaff = true
		end

		pl.lastPropSpawn = CurTime()
		pl.failedPropAttempts = (pl.failedPropAttempts or 0) + 1
		return false
	end

	pl.toldStaff = nil
	pl.failedPropAttempts = nil
	pl.lastPropSpawn = CurTime()
	-- pl:ChatPrint(mdl)

	local found = false

	for k, v in pairs(PPLIST) do
		if string.lower(v) == string.lower(mdl) then
			found = true
			break
		end
	end

	-- if not found then
	-- 	rp.Notify(pl, NOTIFY_ERROR, term.Get('PropNotWhitelisted'), mdl)

	-- 	local issuper = pl:GetRank() == 'root'
	-- 	if issuper then
	-- 		local pc_count = table.Count(rp.pp.ModelCache)
	-- 		if pc_count >= 100 then
	-- 			pl:Notify(NOTIFY_ERROR, term.Get('CacheFull'), pc_count)
	-- 			return false
	-- 		end

	-- 		rp.pp.ModelCache[mdl] = true
	-- 	end
	-- 	return issuper
	-- end

	if not found and not pl:IsRoot() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PropNotWhitelisted'), mdl)
		return false
	end
end)

hook('PlayerSpawnedProp', 'pp.PlayerSpawnedProp', function(pl, mdl, ent)
	ent:CPPISetOwner(pl)
	ent:SetNWEntity("PP_Owner", pl)
	ent:SetNWString("PP_Owner_Uid", pl:UniqueID())
end)

hook('PlayerSpawnedVehicle', 'pp.PlayerSpawnedVehicle', function(pl, ent) ent:CPPISetOwner(pl) end)
hook('PlayerSpawnedSENT', 'pp.PlayerSpawnedSENT', function(pl, ent) ent:CPPISetOwner(pl) end)
function GM:CanTool(pl, trace, tool)
	return rp.pp.PlayerCanTool(pl, trace.Entity, tool)
end

hook('PhysgunPickup', 'pp.PhysgunPickup', function(pl, ent)
	if IsValid(ent) then
		if ent:GetClass() == "derma_printer" and not pl:IsAdmin() then return false end
		local canphys = rp.pp.PlayerCanManipulate(pl, ent)
		if (not canphys) and ent.PhysgunPickup then
			canphys = ent:PhysgunPickup(pl)
		elseif ent.LazyFreeze then
			canphys = ((ent.ItemOwner == pl) or (ent.AllLazyFreeze == true)) and (not ent.BeingPhysed)
		end

		if canphys == true then
			ent.BeingPhysed = true
			hook.Call('PlayerPhysgunEntity', GAMEMODE, pl, ent)
		end
		return canphys
	end
	return false
end)

local vec = Vector(0, 0, 0)
function GM:PhysgunDrop(pl, ent)
	ent.BeingPhysed = false
	if IsValid(ent) and (not ent:IsPlayer()) then
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddAngleVelocity(phys:GetAngleVelocity() * -1)
			phys:SetVelocityInstantaneous(vec)
			phys:EnableMotion(false)
		end
	end
end

local ents_f = ents.FindInBox
local phys
hook.Add("OnPhysgunPickup", "StopCollideBitch", function(p, e)
	if IsValid(e) and not e:IsPlayer() then
		if e.Old_ColGroup or not e.Old_ColGroup then
			e.Old_ColGroup = e:GetCollisionGroup() or COLLISION_GROUP_NONE
			e:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			phys = e:GetPhysicsObject()
			if IsValid(phys) then
				phys:AddAngleVelocity(phys:GetAngleVelocity() * -1)
				phys:SetVelocityInstantaneous(vec)
				phys:EnableMotion(false)
			end
		end
	end
end)

hook.Add("PhysgunDrop", "YeahDropItBitch", function(p, e)
	if IsValid(e) and not e:IsPlayer() then
		local min = e:LocalToWorld(e:OBBMins())
		local max = e:LocalToWorld(e:OBBMaxs())
		local foundEnts = ents_f(min, max)
		phys = e:GetPhysicsObject()
		e:SetCollisionGroup(COLLISION_GROUP_NONE)
		phys = e:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddAngleVelocity(phys:GetAngleVelocity() * -1)
			phys:SetVelocityInstantaneous(vec)
			phys:EnableMotion(false)
		end
	end
end)

hook('OnPhysgunFreeze', 'pp.OnPhysgunFreeze', function(weapon, physobj, ent, pl)
	ent.BeingPhysed = false
	if IsValid(physobj) and (ent.ItemOwner == pl or ent.AllLazyFreeze) and ent.LazyFreeze then
		--physobj:Sleep()
		return false
	end
end)

function GM:GravGunOnPickedUp(pl, ent)
	if ent:IsConstrained() then DropEntityIfHeld(ent) end
end

function GM:GravGunPunt(pl, ent)
	if pl:IsRoot() then return true end
	DropEntityIfHeld(ent)
	return false
end

function GM:OnPhysgunReload(wep, pl)
	return false
end

function GM:GravGunPickupAllowed(pl, ent)
	if ent:IsValid() and ent.GravGunPickupAllowed then return ent:GravGunPickupAllowed(pl) end
	return true
end