--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Bong = zgo2.Bong or {}
zgo2.Bong.List = zgo2.Bong.List or {}

/*

	Bongs are used to smoke da weed

*/

local function HasBong(ply)
	return IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "zgo2_bong"
end

local function SendViewModelAnim(Bong, act , index , rate )

	if ( not game.SinglePlayer() and not IsFirstTimePredicted() ) then
		return
	end

	local ply = Bong:GetOwner()
	local vm = ply:GetViewModel( index )

	if ( not IsValid( vm ) ) then
		return
	end

	local seq = vm:SelectWeightedSequence( act )

	if ( seq == -1 ) then
		return
	end

	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( rate or 1 )
end

function zgo2.Bong.Initialize(Bong)
	Bong:SetHoldType(Bong.HoldType)
	Bong.LastWeedHit = -1
	Bong.SmokeCount = 0

	zgo2.Destruction.SetupHealth(Bong)
end

function zgo2.Bong.Holster(Bong)

	local viewmodel1 = Bong:GetOwner():GetViewModel( 0 )
	if ( IsValid( viewmodel1 ) ) then
		--set its weapon to nil, this way the viewmodel won't show up again
		viewmodel1:SetWeaponModel( Bong.ViewModel , nil )
	end

	// Removes the swep timers
	zclib.Timer.Remove("zgo2_bong_smokeweed_" .. Bong:EntIndex() .. "_timer")
	zclib.Timer.Remove("zgo2_bong_stopsmoking_" .. Bong:EntIndex() .. "_timer")
	zclib.Timer.Remove("zgo2_bong_secondaryanim_" .. Bong:EntIndex() .. "_timer")
	zclib.Timer.Remove("zgo2_bong_drawanim_" .. Bong:EntIndex() .. "_timer")

	if Bong:GetIsSmoking() == true then

		// Stops the bong sound
		Bong:StopBongSound()

		Bong.SmokeCount = 0

		Bong:SetIsSmoking(false)

		// Stops Third person smoking animation
		zgo2.SmokeAnim.Stop(Bong:GetOwner())
	end

	Bong:SetIsBusy(false)

	SendViewModelAnim(Bong, ACT_VM_HOLSTER , 0 )

	zgo2.Bong.ResetWeed(Bong)

	return true
end

function zgo2.Bong.Deploy(Bong)

	local ply = Bong:GetOwner()
	if not IsValid(ply) then return end

	// Set the ViewModel
	local BongTypeData = zgo2.Bong.GetTypeData(Bong:GetBongID())
	Bong.ViewModel = BongTypeData.vm
	ply:GetViewModel( 0 ):SetWeaponModel(BongTypeData.vm, Bong )


	ply:SetAnimation(PLAYER_IDLE)
	zgo2.Bong.EnableWeed(Bong)
	zgo2.Bong.PlayDrawAnim(Bong)
	return true
end

function zgo2.Bong.PrimaryAttack(Bong)
	if Bong:GetIsBusy() then
		return false
	end
	if Bong:GetWeedID() ~= -1 then
		Bong:SetIsBusy(true)
		zgo2.Bong.DoPrimaryAnims(Bong)
	else
		zclib.Notify(Bong:GetOwner(),zgo2.language["Missing Weed"], 1)
	end
	Bong:SetNextPrimaryFire(CurTime() + 1)
end

function zgo2.Bong.SecondaryAttack(Bong)
	if Bong:GetIsBusy() then return end

	local ply = Bong:GetOwner()
	if not IsValid(ply) then return end

	local tr = ply:GetEyeTrace()
	if not tr.Hit  then return end

	local ent = tr.Entity
	if not IsValid(ent) then return end
	local class = ent:GetClass()

	if class ~= "zgo2_jar" and class ~= "zgo2_baggy" then return end
	if ent:GetWeedAmount() <= 0 then return end

	Bong:SetIsBusy(true)

	zgo2.Bong.DoSecondaryAnims(Bong)

	local BongData = zgo2.Bong.GetData(Bong:GetBongID())
	local capacity = BongData.capacity or 25

	local ent_capacity = zgo2.config.Jar.Capacity
	if class == "zgo2_baggy" then ent_capacity = zgo2.config.Baggy.Capacity end

	local ent_amount = ent:GetWeedAmount()
	local weedID = ent:GetWeedID()

	Bong:SetWeedID(weedID)
	Bong:SetWeedAmount(math.Clamp(capacity,1,ent_amount))
	Bong:SetWeedTHC(ent:GetWeedTHC())

	zgo2.Bong.EnableWeed(Bong)

	if ent_amount > capacity then
		ent:SetWeedAmount(math.Clamp(ent:GetWeedAmount() - capacity, 0, ent_capacity))
	else
		ent:Remove()
	end

	// Punch the player's view
	ply:ViewPunch( Angle( -3, 0, 0 ) )
	ply:SetAnimation(PLAYER_ATTACK1)

	Bong:SetNextSecondaryFire(CurTime() + 0.7)
end

function zgo2.Bong.Think(Bong)
	local ply = Bong:GetOwner()
	if Bong:GetIsSmoking() and Bong.LastWeedHit < CurTime() then

		if Bong:GetWeedAmount() > 0 and IsValid(ply) and ply:KeyDown(IN_ATTACK) then
			zgo2.Bong.SmokeWeed(Bong)
		else
			zgo2.Bong.StopSmoking(Bong)
		end
	end
end

function zgo2.Bong.Reload(Bong)
	if Bong:GetIsBusy() then return end

	if Bong:GetWeedID() ~= -1 then

		zgo2.Bong.ResetWeed(Bong)

		Bong:SetWeedID(-1)
		Bong:SetWeedAmount(0)
		Bong:SetIsBurning(false)
	end

	zgo2.Bong.PlayIdleAnim(Bong)
end

/////////////////////////////////////////

function zgo2.Bong.DoPrimaryAnims(Bong)
	if not IsValid(Bong) then return end // Safety first!

	local ply = Bong:GetOwner()
	if not IsValid(ply) then return end

	// Play primary anim
	SendViewModelAnim(Bong, ACT_VM_PRIMARYATTACK , 0 )

	local timerID = "zgo2_bong_smokeweed_" .. Bong:EntIndex() .. "_timer"
	zclib.Timer.Remove(timerID)
	zclib.Timer.Create(timerID,1,1,function()
		if IsValid(Bong) and HasBong(ply) then

			ply:EmitSound("zgo2_igniter_lit")

			// Start Third person smoking animation
			zgo2.SmokeAnim.Start(ply)

			zgo2.Bong.SmokeWeed(Bong)
		end
	end)
end

function zgo2.Bong.DoSecondaryAnims(Bong)
	if not IsValid(Bong) then return end // Safety first!

	// Play secondary anim
	SendViewModelAnim(Bong, ACT_VM_SECONDARYATTACK , 0 )

	local ply = Bong:GetOwner()
	if not IsValid(ply) then return end

	local timerID = "zgo2_bong_secondaryanim_" .. Bong:EntIndex() .. "_timer"
	zclib.Timer.Remove(timerID)
	zclib.Timer.Create(timerID,0.7,1,function()
		if IsValid(Bong) then
			Bong:SetIsBusy(false)
		end
		if HasBong(ply) then
			zgo2.Bong.PlayIdleAnim(Bong)
		end
	end)
end

function zgo2.Bong.PlayDrawAnim(Bong)
	if not IsValid(Bong) then return end // Safety first!

	local ply = Bong:GetOwner()
	if not IsValid(ply) then return end

	// Play draw anim
	SendViewModelAnim(Bong, ACT_VM_DRAW , 0 )

	local timerID = "zgo2_bong_drawanim_" .. Bong:EntIndex() .. "_timer"
	zclib.Timer.Remove(timerID)
	zclib.Timer.Create(timerID,0.3,1,function()
		if HasBong(ply) then
			zgo2.Bong.PlayIdleAnim(Bong)
		end
	end)
end

function zgo2.Bong.PlayIdleAnim(Bong)
	if not IsValid(Bong) then return end // Safety first!

	if Bong:GetIsBurning() then

		// A idle animation with burn effect
		SendViewModelAnim(Bong, ACT_VM_HITLEFT , 0 )
	else

		// Player idle anim
		SendViewModelAnim(Bong, ACT_VM_IDLE , 0 )
	end
end

function zgo2.Bong.StopSound(Bong)
	Bong:SetIsSmoking(false)
	Bong:GetOwner():EmitSound("zgo2_bong_end")
end

function zgo2.Bong.SmokeWeed(Bong)

	local ply = Bong:GetOwner()
	if not IsValid(ply) then return end

	ply:SetAnimation(PLAYER_START_AIMING)

	Bong:SetIsSmoking(true)

	// Inhale animation
	SendViewModelAnim(Bong, ACT_VM_THROW , 0 )

	zgo2.HighEffect.Start(Bong:GetWeedID(),Bong:GetWeedTHC(),zgo2.config.HighEffect.Duration,ply)

	// Reduce weed amount
	Bong:SetWeedAmount(Bong:GetWeedAmount() - zgo2.config.Bong.Use)

	Bong:SetIsBurning(true)

	Bong.SmokeCount = Bong.SmokeCount + 1

	Bong.LastWeedHit = CurTime() + 0.5
end

function zgo2.Bong.EnableWeed(Bong)

	local weedID = Bong:GetWeedID()
	if weedID ~= -1 then

		// Enable weed bud bodygroup
		Bong:GetOwner():GetViewModel():SetBodygroup(0, 1)
	else
		zgo2.Bong.ResetWeed(Bong)
	end
end

function zgo2.Bong.ResetWeed(Bong)
	Bong:SetIsBurning(false)

	// Disable weed bud bodygroup
	Bong:GetOwner():GetViewModel():SetBodygroup(0, 0)
end

function zgo2.Bong.StopSmoking(Bong)

	local ply = Bong:GetOwner()
	if not IsValid(ply) then return end

	// Stops Third person smoking animation
	zgo2.SmokeAnim.Stop(ply)

	ply:SetAnimation(PLAYER_LEAVE_AIMING)

	// Stops the bong sound
	zgo2.Bong.StopSound(Bong)

	Bong:SetIsSmoking(false)

	// Finish animation
	SendViewModelAnim(Bong, ACT_VM_PULLPIN , 0 )

	local rest_weed = Bong:GetWeedAmount()
	if rest_weed <= 0 then
		zgo2.Bong.ResetWeed(Bong)
	end

	local timerID = "zgo2_bong_stopsmoking_" .. Bong:EntIndex() .. "_timer"
	zclib.Timer.Remove(timerID)
	zclib.Timer.Create(timerID,2.6,1,function()
		if IsValid(Bong) then
			zgo2.Bong.SmokeFinish(Bong)
		end
	end)

	Bong.LastWeedHit = CurTime() + 0.5
end

function zgo2.Bong.SmokeFinish(Bong)
	local ply = Bong:GetOwner()
	if Bong.SmokeCount > 0 then

		if Bong.SmokeCount > 5 and math.random(1,2) == 1 then
			ply:EmitSound("zgo2_cough")
		end

		zgo2.SmokeAnim.Effect(ply,Bong.SmokeCount)

		Bong.SmokeCount = 0
	end

	if Bong:GetWeedAmount() <= 0 then
		Bong:SetWeedID(-1)
		Bong:SetWeedAmount(0)
	end

	if HasBong(ply) then zgo2.Bong.PlayIdleAnim(Bong) end

	Bong:SetIsBusy(false)
end

// Drop / Share Bong Function
zclib.Hook.Add("PlayerButtonDown", "zgo2_BongDrop", function(ply, key)
	if key == MOUSE_MIDDLE and HasBong(ply) then

		local swep = ply:GetActiveWeapon()
		if (ply.zgo2_NextBongDrop == nil or CurTime() > ply.zgo2_NextBongDrop) then

			if swep:GetIsBusy() then return end

			local tr = ply:GetEyeTrace()
			local target = tr.Entity

			if IsValid(target) and target:IsPlayer() and target:Alive() then
				local bong = target:Give("zgo2_bong", false)

				if bong then
					bong:SetBongID(swep:GetBongID())
					bong:SetWeedID(swep:GetWeedID())
					bong:SetWeedAmount(swep:GetWeedAmount())
					bong:SetIsBurning(swep:GetIsBurning())
					target:SelectWeapon("zgo2_bong")
				end

				ply:StripWeapon("zgo2_bong")
			else
				ply:DropWeapon(swep)

				if swep:GetWeedAmount() > 0 then
					swep:SetBodygroup(0, 1)
				else
					swep:SetBodygroup(0, 0)
				end
			end

			ply.zgo2_NextBongDrop = CurTime() + 1
		end
	end
end)

// If the player already has a bong then dont let him pick up another one
zclib.Hook.Add("PlayerCanPickupWeapon", "zgo2_BongPickUp", function(ply, wep)
	if IsValid(wep) and wep:GetClass() == "zgo2_bong" and ply:HasWeapon("zgo2_bong") then return false end
end)

zclib.Hook.Add("canDropWeapon", "zgo2_canDropWeapon_Bongdrop", function(ply, weapon)
	if IsValid(weapon) and weapon:GetClass() == "zgo2_bong" then
		ply:DropWeapon(weapon)

		if weapon:GetWeedAmount() > 0 then
			weapon:SetBodygroup(0, 1)
		else
			weapon:SetBodygroup(0, 0)
		end

		return false
	end
end)

zclib.Hook.Add("EntityTakeDamage", "zgo2_EntityTakeDamage_BongDamage", function(target, dmg )
	if zgo2.config.Damageable["zgo2_bong"] and zgo2.config.Damageable["zgo2_bong"] > 0 and IsValid(target) and target:GetClass() == "zgo2_bong" then
		zgo2.Destruction.Destroy(target)
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher