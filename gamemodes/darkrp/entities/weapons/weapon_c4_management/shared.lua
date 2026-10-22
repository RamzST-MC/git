if (SERVER) then
	AddCSLuaFile('shared.lua')
end

SWEP.PrintName 					= 'C4 (Unlimited)'
SWEP.Slot 						= 3
SWEP.SlotPos 					= 0
SWEP.DrawAmmo 					= false
SWEP.DrawCrosshair 				= false

SWEP.Instructions 				= 'shit c4'
SWEP.Author 					= 'matical'
SWEP.Contact 					= ''
SWEP.Purpose 					= ''

SWEP.ViewModel					= "models/weapons/2_c4.mdl"	-- Weapon view model
SWEP.WorldModel					= "models/weapons/3_c4.mdl"	-- Weapon world model

SWEP.ViewModelFOV 				= 62
SWEP.ViewModelFlip 				= false
SWEP.AnimPrefix	 				= 'rpg'

SWEP.Spawnable 					= true
SWEP.Category 					= 'Eclipse | Specialities'
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
	self.nextReload = 0
	self.Regime = 0
	self:SetHoldType('normal')
end

function SWEP:Deploy()
	if (SERVER) then
		self:GetOwner():DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()
	if (SERVER) then
		if self.Regime == 0 then
			local tr = util.TraceLine({
				start = self:GetOwner():GetShootPos(),
				endpos = self:GetOwner():GetShootPos() + 100 * self:GetOwner():GetAimVector(),
				filter = {self:GetOwner()},
			})
		
			local c4 = ents.Create('ent_c4')
			c4.ItemOwner = self:GetOwner()
			c4:SetPos(tr.HitPos)
			c4:SetAngles(tr.HitNormal:Angle() - Angle(90, 180, 0))
			c4:Spawn()

			c4.ItemOwner = self:GetOwner()

			if tr.Entity and IsValid(tr.Entity) then
				if tr.Entity:GetPhysicsObject():IsValid() then
					c4:SetParent(tr.Entity)
				elseif not tr.Entity:IsNPC() and not tr.Entity:IsPlayer() and tr.Entity:GetPhysicsObject():IsValid() then
					constraint.Weld(c4, tr.Entity)
				end
			else
				c4:SetMoveType(MOVETYPE_NONE)
			end

			--hook.Call('PlayerPlaceC4', nil, self:GetOwner(), tr.Entity)

			if not tr.Hit then
				c4:SetMoveType(MOVETYPE_VPHYSICS)
			end

			self:GetOwner():EmitSound("c4.PlantSound")
		elseif self.Regime == 1 then
			local tr = util.TraceLine({
				start = self:GetOwner():GetShootPos(),
				endpos = self:GetOwner():GetShootPos() + 100 * self:GetOwner():GetAimVector(),
				filter = {self:GetOwner()},
			})
	
			local inc = ents.Create('ent_incendiary')
			inc:SetPos(tr.HitPos)
			inc:SetAngles(tr.HitNormal:Angle() - Angle(90, 180, 0))
			inc:Spawn()
	
			inc.ItemOwner = self:GetOwner()
	
			if tr.Entity and IsValid(tr.Entity) then
				if tr.Entity:GetPhysicsObject():IsValid() then
					inc:SetParent(tr.Entity)
				elseif not tr.Entity:IsNPC() and not tr.Entity:IsPlayer() and tr.Entity:GetPhysicsObject():IsValid() then
					constraint.Weld(inc, tr.Entity)
				end
			else
				inc:SetMoveType(MOVETYPE_NONE)
			end
	
			hook.Call('PlayerPlaceIncendiary', nil, inc.Owner, tr.Entity)
	
			if not tr.Hit then
				inc:SetMoveType(MOVETYPE_VPHYSICS)
			end

			self:GetOwner():EmitSound("c4.PlantSound")
		end
	end
end

function SWEP:Reload()
	if self.Regime == 0 then
		if SERVER then
			self.Regime = 1
		end
	else
		if SERVER then
			self.Regime = 0
		end
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end