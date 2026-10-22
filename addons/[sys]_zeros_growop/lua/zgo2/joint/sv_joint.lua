--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Joint = zgo2.Joint or {}
zgo2.Joint.List = zgo2.Joint.List or {}

/*

	Bongs are used to smoke da weed

*/

local function HasJoint(ply)
	return IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "zgo2_joint"
end

function zgo2.Joint.Initialize(Joint)
	Joint:SetHoldType(Joint.HoldType)
	Joint.LastWeedHit = -1
	Joint.SmokeCount = 0

	// Keep track on which weed just got used
	zgo2.Plant.SetActive(Joint:GetWeedID())
end

function zgo2.Joint.Holster(Joint)
	-- Stops the bong sound
	zgo2.Joint.StopSound(Joint)

	-- Removes the swep timers
	zclib.Timer.Remove("zgo2_joint_smokeweed_" .. Joint:EntIndex() .. "_timer")
	zclib.Timer.Remove("zgo2_joint_stopsmoking_" .. Joint:EntIndex() .. "_timer")
	zclib.Timer.Remove("zgo2_joint_drawanim_" .. Joint:EntIndex() .. "_timer")

	Joint.SmokeCount = 0
	Joint:SendWeaponAnim(ACT_VM_HOLSTER)
	Joint:SetIsSmoking(false)
	Joint:SetIsBusy(false)

	if Joint:GetWeedAmount() <= 0 then
		zgo2.Joint.RemoveJoint(Joint)
	end

	local ply = Joint:GetOwner()
	if not IsValid(ply) then return end
	-- Stops Third person smoking animation
	zgo2.SmokeAnim.Stop(ply)

	return true
end

function zgo2.Joint.Deploy(Joint)
	local ply = Joint:GetOwner()
	if not IsValid(ply) then return end

	ply:SetAnimation(PLAYER_IDLE)
	zgo2.Joint.EnableWeed(Joint)
	zgo2.Joint.PlayDrawAnim(Joint)

	return true
end

function zgo2.Joint.PrimaryAttack(Joint)
	if Joint:GetIsBusy() then return false end

	if Joint:GetWeedID() ~= -1 then
		Joint:SetIsBusy(true)
		zgo2.Joint.DoPrimaryAnims(Joint)
	else
		local ply = Joint:GetOwner()
		if not IsValid(ply) then return end
		zclib.Notify(ply, zgo2.language[ "Missing Weed" ], 1)
	end

	Joint:SetNextPrimaryFire(CurTime() + 1)
end

function zgo2.Joint.Think(Joint)
	if Joint:GetIsSmoking() and Joint.LastWeedHit < CurTime() then
		local ply = Joint:GetOwner()
		if not IsValid(ply) then return end

		if Joint:GetWeedAmount() > 0 and IsValid(ply) and ply:KeyDown(IN_ATTACK) then
			zgo2.Joint.SmokeWeed(Joint)
		else
			zgo2.Joint.StopSmoking(Joint)
		end
	end
end

function zgo2.Joint.SecondaryAttack(Joint)
	if Joint:GetIsBusy() then return end
	Joint:SetNextSecondaryFire(CurTime() + 0.7)
end

function zgo2.Joint.Reload(Joint)
	if Joint:GetIsBusy() then return end
	zgo2.Joint.RemoveJoint(Joint)
end

function zgo2.Joint.StopSound(Joint)
	Joint:SetIsSmoking(false)
	local ply = Joint:GetOwner()
	if not IsValid(ply) then return end

	if Joint:GetIsBurning() then
		zclib.Sound.EmitFromEntity("zgo2_joint_stop", ply)
	end
end

function zgo2.Joint.EnableWeed(Joint)
	local weedID = Joint:GetWeedID()

	if weedID ~= -1 then
		local ply = Joint:GetOwner()
		if not IsValid(ply) then return end

		if Joint:GetIsBurning() then
			ply:GetViewModel():SetSkin(1)
		else
			ply:GetViewModel():SetSkin(0)
		end
	else
		zgo2.Joint.RemoveJoint(Joint)
	end
end

function zgo2.Joint.RemoveJoint(Joint)
	local ply = Joint:GetOwner()
	if not IsValid(ply) then return end
	Joint:SetIsSmoking(false)
	Joint:SetIsBurning(false)
	ply:GetViewModel():SetSkin(0)
	ply:StripWeapon("zgo2_joint")
end

function zgo2.Joint.PlayDrawAnim(Joint)
	if not IsValid(Joint) then return end -- Safety first!
	Joint:SendWeaponAnim(ACT_VM_DRAW) -- Play draw anim

	local timerID = "zgo2_joint_drawanim_" .. Joint:EntIndex() .. "_timer"
	zclib.Timer.Remove(timerID)

	local ply = Joint:GetOwner()
	if not IsValid(ply) then return end

	zclib.Timer.Create(timerID, 0.3, 1, function()
		zclib.Timer.Remove(timerID)

		if HasJoint(ply) then
			zgo2.Joint.PlayIdleAnim(Joint)
		end
	end)
end

function zgo2.Joint.PlayIdleAnim(Joint)
	if not IsValid(Joint) then return end -- Safety first!

	if Joint:GetIsBurning() then
		-- A idle animation with burn effect
		Joint:SendWeaponAnim(ACT_VM_HITLEFT)
	else
		-- Player idle anim
		Joint:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function zgo2.Joint.DoPrimaryAnims(Joint)
	if not IsValid(Joint) then return end -- Safety first!
	Joint:SendWeaponAnim(ACT_VM_PRIMARYATTACK) -- Play primary anim
	local timerID = "zgo2_joint_smokeweed_" .. Joint:EntIndex() .. "_timer"
	zclib.Timer.Remove(timerID)

	local ply = Joint:GetOwner()
	if not IsValid(ply) then return end

	-- Creates the screeneffect
	zclib.Timer.Create(timerID, 1, 1, function()
		if HasJoint(ply) then

			ply:EmitSound("zgo2_igniter_lit")
			zclib.Sound.EmitFromEntity("zgo2_joint_start", ply)

			-- Start Third person smoking animation
			zgo2.SmokeAnim.Start(ply)

			zgo2.Joint.SmokeWeed(Joint)
		end

		zclib.Timer.Remove(timerID)
	end)
end

function zgo2.Joint.SmokeWeed(Joint)
	Joint:SetIsSmoking(true)

	-- Inhale animation
	Joint:SendWeaponAnim(ACT_VM_THROW)

	local ply = Joint:GetOwner()
	if not IsValid(ply) then return end

	zgo2.HighEffect.Start(Joint:GetWeedID(), Joint:GetWeedTHC(),zgo2.config.HighEffect.Duration, ply)
	Joint:SetWeedAmount(Joint:GetWeedAmount() - 1)
	ply:GetViewModel():SetSkin(1)

	Joint:SetIsBurning(true)
	Joint.SmokeCount = Joint.SmokeCount + 1
	Joint.LastWeedHit = CurTime() + 0.5
end

function zgo2.Joint.StopSmoking(Joint)
	local ply = Joint:GetOwner()
	if not IsValid(ply) then return end

	-- Stops Third person smoking animation
	zgo2.SmokeAnim.Stop(ply)

	-- Stops the bong sound
	zgo2.Joint.StopSound(Joint)
	Joint:SetIsSmoking(false)

	-- Finish animation
	Joint:SendWeaponAnim(ACT_VM_PULLPIN)
	local timerID = "zgo2_joint_stopsmoking_" .. Joint:EntIndex() .. "_timer"
	zclib.Timer.Remove(timerID)

	zclib.Timer.Create(timerID, 2.6, 1, function()
		if HasJoint(ply) then
			zgo2.Joint.SmokeFinish(Joint)
		end
	end)

	Joint.LastWeedHit = CurTime() + 0.5
end

function zgo2.Joint.SmokeFinish(Joint)
	if not IsValid(Joint) then return end
	local ply = Joint:GetOwner()
	if not IsValid(ply) then return end

	if Joint.SmokeCount > 0 then
		if Joint.SmokeCount > math.Round(zgo2.config.DoobyTable.WeedPerJoint * 0.5) and math.random(1, 2) == 1 then
			ply:EmitSound("zgo2_cough")
		end

		zgo2.SmokeAnim.Effect(ply,Joint.SmokeCount)
		Joint.SmokeCount = 0
	end

	if Joint:GetWeedAmount() <= 0 then
		zgo2.Joint.RemoveJoint(Joint)
	else
		if HasJoint(ply) then
			zgo2.Joint.PlayIdleAnim(Joint)
		end
	end

	Joint:SetIsBusy(false)
end

zclib.Hook.Add("PlayerButtonDown", "zgo2_JointDrop", function(ply, key)
	if key == MOUSE_MIDDLE and HasJoint(ply) then
		local swep = ply:GetActiveWeapon()

		if ply.zgo2_NextBongDrop == nil or CurTime() > ply.zgo2_NextBongDrop then

			if swep:GetIsBusy() then return end

			local tr = ply:GetEyeTrace()
			local target = tr.Entity

			if IsValid(target) and target:IsPlayer() and target:Alive() then
				if swep:GetWeedAmount() <= 0 then
					ply:StripWeapon("zgo2_joint")

					return
				end

				local joint = target:Give("zgo2_joint", false)

				if joint then
					joint:SetWeedID(swep:GetWeedID())
					joint:SetWeedAmount(swep:GetWeedAmount())
					joint:SetIsBurning(swep:GetIsBurning())
					target:SelectWeapon("zgo2_joint")
				end

				ply:StripWeapon("zgo2_joint")
			else
				if not zclib.util.InDistance(ply:GetPos(), tr.HitPos, 100) then return end

				if swep:GetWeedAmount() > 0 then
					local ent = ents.Create("zgo2_joint_ent")
					ent:SetPos(tr.HitPos)
					zclib.Player.SetOwner(ent, ply)
					ent:SetWeedID(swep:GetWeedID())
					ent:SetWeedTHC(swep:GetWeedTHC())
					ent:SetWeedAmount(swep:GetWeedAmount())
					ent:SetIsBurning(swep:GetIsBurning())
					ent:Spawn()
					ent:Activate()
				end

				ply:StripWeapon("zgo2_joint")
			end

			ply.zgo2_NextBongDrop = CurTime() + 1
		end
	end
end)
zclib.Hook.Add("PlayerCanPickupWeapon", "zgo2_JointPickUp", function(ply, wep)
	if IsValid(wep) and wep:GetClass() == "zgo2_joint" and ply:HasWeapon("zgo2_joint") then return false end
end)

zclib.Hook.Add("canDropWeapon", "zgo2_canDropWeapon_Jointdrop", function(ply, weapon)
	if IsValid(weapon) and weapon:GetClass() == "zgo2_joint" then
		//ply:DropWeapon(weapon)
		return false
	end
end)

zclib.Hook.Add("EntityTakeDamage", "zgo2_EntityTakeDamage_BongDamage", function(target, dmg )
	if IsValid(target) and target:GetClass() == "zgo2_joint" then
		zgo2.Destruction.Destroy(target)
	end
end)


concommand.Add("zgo2_spawn_joints", function(ply, cmd, args)
	if zclib.Player.IsAdmin(ply) then

		local tr = ply:GetEyeTrace()

		if tr and tr.Hit and tr.HitPos then

			undo.Create("zgo2_spawn_joints")

			local count = 0
			for i = 1, 25 do

				local ent = ents.Create("zgo2_joint_ent")
				ent:SetPos(tr.HitPos + zclib.util.GetRandomPositionInsideCircle(25, 120, 15))
				ent:SetAngles(Angle(0, math.random(360), 0))
				ent:SetWeedID(zgo2.Plant.GetRandomID())
				ent:SetWeedAmount(zgo2.config.DoobyTable.WeedPerJoint)
				ent:SetWeedTHC(100)
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