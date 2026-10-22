AddCSLuaFile()

SWEP.PrintName 					= 'Динамит'
SWEP.Slot 						= 3
SWEP.SlotPos 					= 1
SWEP.DrawAmmo 					= false
SWEP.DrawCrosshair 				= true

SWEP.Instructions 				= 'Click to set shit on fire'
SWEP.Author 					= 'пингуин супсуп'

SWEP.WorldModel = Model("models/weapons/w_tnt.mdl")
SWEP.ViewModel = Model("models/weapons/v_tnt.mdl")


SWEP.ViewModelFOV 				= 62
SWEP.ViewModelFlip 				= false
SWEP.AnimPrefix	 				= 'rpg'

SWEP.Spawnable 					= true
SWEP.Category 					= 'RP'
SWEP.Sound 						= ''
SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip 		= 0
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 				= ''

SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= 0
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= ''

function SWEP:Initialize()
	self:SetHoldType('slam')
end

function SWEP:PrimaryAttack()
	self:SetHoldType('pistol')

	if (SERVER) then
		local tr = util.TraceLine({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector(),
			filter = {self.Owner},
		})

		local inc = ents.Create('ent_incendiary')
		inc:SetPos(tr.HitPos)
		inc:SetAngles(tr.HitNormal:Angle() - Angle(90, 180, 0))
		inc:Spawn()

		inc.ItemOwner = self.Owner

		if tr.Entity and IsValid(tr.Entity) then
			if tr.Entity:GetPhysicsObject():IsValid() then
				inc:SetParent(tr.Entity)
			elseif not tr.Entity:IsNPC() and not tr.Entity:IsPlayer() and tr.Entity:GetPhysicsObject():IsValid() then
				constraint.Weld(inc, tr.Entity)
			end
		else
			inc:SetMoveType(MOVETYPE_NONE)
		end

		hook.Call('PlayerPlaceIncendiary', nil, self.Owner, tr.Entity)

		if not tr.Hit then
			inc:SetMoveType(MOVETYPE_VPHYSICS)
		end

		self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_PLACE)
		self.Owner:EmitSound("c4.PlantSound")
		self.Owner:StripWeapon('weapon_incendiary')
		rp.achievements.AddProgress(inc.ItemOwner, ACHIEVEMENT_C4, 1)
	end
end

function SWEP:AdjustWorldModelPos()
	local boneIndex = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
	if not boneIndex then return end

	local pos, ang = self.Owner:GetBonePosition(boneIndex)
	pos = pos + ang:Right() * 5 + ang:Forward() * 4
	ang:RotateAroundAxis(ang:Right(), 270)

	self:SetRenderOrigin(pos)
	self:SetRenderAngles(ang)
	self:SetModelScale(0.8)
end

function SWEP:DrawWorldModel()
	self:AdjustWorldModelPos()
	self:DrawModel()
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end