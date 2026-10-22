function PLAYER:IsCarryingItem()
	return IsValid(self:GetNetVar('CarriedItem'))
end

function PLAYER:SetCarryingItem(item)
	self:SetNetVar('CarriedItem', item)
end

util.AddNetworkString 'rp.crarryitems.Toggle'
net.Receive('rp.crarryitems.Toggle',function(_, pl)
	local ent = pl:GetEyeTrace().Entity

	local bone = pl:LookupBone('ValveBiped.Bip01_Spine')
	if not bone then return end

	if IsValid(ent) and ent:GetClass() == 'money_printer' and ent:InRack() then return end
	if pl:Team() == TEAM_ADMIN then return end

	if pl:IsCarryingItem() then
		local trace = {}
		trace.start = pl:EyePos()
		trace.endpos = trace.start + pl:GetAimVector() * 85
		trace.filter = pl

		local ent = pl:GetNetVar('CarriedItem')
		ent:SetParent(NULL)
		local tr = util.TraceLine(trace).HitPos
		tr.z = ent:GetClass() == 'money_printer' and tr.z + 18 or tr.z + 15
		ent:SetPos(tr)
		local ok = pl:EyeAngles()
		ok[1] = 270
		ok[3] = 0
		ent:SetAngles(ok)
		ent:PhysicsInit(SOLID_VPHYSICS)
		ent:SetMoveType(MOVETYPE_VPHYSICS)
		ent:SetSolid(SOLID_VPHYSICS)
		ent:SetUseType(SIMPLE_USE)
		ent:PhysWake()
		ent:SetCollisionGroup(ent.oldCollision)
		ent.isCarring = false
		ent:SetNoDraw(false)

		pl:SetCarryingItem(NULL)

		return
	end

	if ent:IsPlayer() then return end
	if IsValid(ent) and (pl:GetPos():Distance(ent:GetPos()) < 115) then
		if ent.CanCarry then
			if ent:GetClass() == 'money_printer' then
				local ang = pl:GetAngles()+Angle(270, 90, 270)
				ent.oldCollision = ent:GetCollisionGroup()
				ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				ent:SetAngles(ang)
				ent:SetPos(pl:GetBonePosition(bone)-ang:Up() * -6)

				ent:SetMoveType(MOVETYPE_VPHYSICS)
				ent:SetParent(pl, bone)
				ent.isCarring = true
				ent:SetNoDraw(false)

				pl:SetCarryingItem(ent)
			elseif ent:GetClass() == 'derma_printer' then
				local ang = pl:GetAngles()+Angle(90, 90, 270)
				local bone = pl:LookupBone('ValveBiped.Bip01_Spine')
				ent.oldCollision = ent:GetCollisionGroup()
				ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				ent:SetAngles(ang)
				ent:SetPos(pl:GetBonePosition(bone)-ang:Up() * -6)

				ent:SetMoveType(MOVETYPE_VPHYSICS)
				ent:SetParent(pl, bone)
				ent.isCarring = true
				ent:SetNoDraw(false)

				pl:SetCarryingItem(ent)
			elseif ent:GetClass() == 'spawned_shipment' then
				local ang = pl:GetAngles()+Angle(90, 90, 270)
				ent:SetAngles(ang)
				ent:SetPos(pl:GetBonePosition(bone)-ang:Up() * -2.4)

				ent:SetMoveType(MOVETYPE_VPHYSICS)
				ent:SetParent(pl, bone)
				ent.oldCollision = ent:GetCollisionGroup()
				ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				ent.isCarring = true
				ent:SetNoDraw(false)

				pl:SetCarryingItem(ent)		
			elseif ent:GetClass() == 'money_basket' then
				local ang = pl:GetAngles() + Angle(180, 90, 270)
				ent:SetAngles(ang)
				ent:SetPos(pl:GetBonePosition(bone)-ang:Up() * -9)

				ent:SetMoveType(MOVETYPE_VPHYSICS)
				ent:SetParent(pl, bone)
				ent.oldCollision = ent:GetCollisionGroup()
				ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				ent.isCarring = true
				ent:SetNoDraw(false)

				pl:SetCarryingItem(ent)
			else
				local ang = pl:GetAngles()+Angle(90, 90, 270)
				ent:SetAngles(ang)
				ent:SetPos(pl:GetBonePosition(bone)-ang:Up() * -7)

				ent:SetMoveType(MOVETYPE_VPHYSICS)
				ent:SetParent(pl, bone)
				ent.oldCollision = ent:GetCollisionGroup()
				ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				ent.isCarring = true
				ent:SetNoDraw(false)

				pl:SetCarryingItem(ent)
			end
		end
	end
end)

hook.Add( "PlayerDeath", "PDCarry", function( pl )
	if pl:IsCarryingItem() then
		local trace = {}
		trace.start = pl:EyePos()
		trace.endpos = trace.start + pl:GetAimVector() * 85
		trace.filter = pl
		local tr = util.TraceLine(trace)

		local ent = pl:GetNetVar('CarriedItem')
		ent:SetParent(NULL)
		ent:SetPos(tr.HitPos)
		ent:SetAngles(Angle(0, 0, 0))
		ent:PhysicsInit(SOLID_VPHYSICS)
		ent:SetMoveType(MOVETYPE_VPHYSICS)
		ent:SetSolid(SOLID_VPHYSICS)
		ent:SetUseType(SIMPLE_USE)
		ent:PhysWake()
		ent:SetCollisionGroup(ent.oldCollision)
		ent.isCarring = false
		ent:SetNoDraw(false)

		pl:SetCarryingItem(NULL)
	end
end )

hook.Add("playerCanChangeTeam", "PDCarry", function(pl)
	if pl:IsCarryingItem() then
		local trace = {}
		trace.start = pl:EyePos()
		trace.endpos = trace.start + pl:GetAimVector() * 85
		trace.filter = pl
		local tr = util.TraceLine(trace)

		local ent = pl:GetNetVar('CarriedItem')
		ent:SetParent(NULL)
		ent:SetPos(tr.HitPos)
		ent:SetAngles(Angle(0, 0, 0))
		ent:PhysicsInit(SOLID_VPHYSICS)
		ent:SetMoveType(MOVETYPE_VPHYSICS)
		ent:SetSolid(SOLID_VPHYSICS)
		ent:SetUseType(SIMPLE_USE)
		ent:PhysWake()
		ent:SetCollisionGroup(ent.oldCollision)
		ent.isCarring = false
		ent:SetNoDraw(false)

		pl:SetCarryingItem(NULL)
	end
end )

hook.Add('PlayerUse', 'prevent_use_carry', function(pl,ent)
	if ent.isCarring then
		return false
	end
end)
