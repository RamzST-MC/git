if SERVER then 
	include( "ballistic_shields/sh_bs_util.lua" ) 
	include( "ballistic_shields/sv_bs_util.lua" ) 
end
include( "bs_config.lua" ) 
include( "ballistic_shields/sh_bs_lang.lua" ) 


SWEP.PrintName = "Баллистический щит"
SWEP.Author	= "D3G"
SWEP.Instructions = "LMB - Deploy shield | RMB - Toggle visibility"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = ""
SWEP.WorldModel = "models/bshields/dshield.mdl"

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom	= false

SWEP.Slot = 5
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Category = "Щиты"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.CanVisToggle = true
SWEP.VisToggle = false
SWEP.HitDistance = 55

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()
	self:SetHoldType("melee2")
end

function SWEP:DrawWorldModel()
	self:SetNoDraw( true ) 
end

local function bsGetHoldType(ply)
	if (ply:LookupAttachment( "anim_attachment_RH" )>0) then return {1,"anim_attachment_RH"} end
	if (ply:LookupAttachment( "forward" )>0) then return {2,"forward"} end
	return {3, "anim_attachment_head"}
end

local ShieldIcon = Material("bshields/ui/deployable_shield", "smooth")
local BackgroundIcon = Material("bshields/ui/background")
function SWEP:DrawHUD()
	if(bshields.config.disablehud) then return end
	surface.SetDrawColor(255,255,255,200)	
	surface.SetMaterial(BackgroundIcon)
	surface.DrawTexturedRect( ScrW()/2-ScrH()/10, ScrH()/2-ScrH()/30+ScrH()/3, ScrH()/4.25, ScrH()/15)

	local aim = LocalPlayer():GetAimVector()
	local tr = util.TraceLine( {
		start  = LocalPlayer():GetShootPos() ,
		endpos = LocalPlayer():GetShootPos() + aim * 120,
		filter = LocalPlayer()
	} )
	surface.SetDrawColor(255,255,255,125)
	draw.SimpleTextOutlined( bshields.lang[bshields.config.language].rshieldprim, "bshields.HudFont", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/22, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	surface.SetMaterial(ShieldIcon)

	surface.DrawTexturedRect( ScrW()/2-ScrH()/10.2, ScrH()/2-ScrH()/32+ScrH()/3, ScrH()/16, ScrH()/16) 
	if(self.VisToggle) then
		draw.SimpleTextOutlined( bshields.lang[bshields.config.language].sec, "bshields.HudFont", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/48, Color( 255, 255, 255, 25 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	else
		draw.SimpleTextOutlined( bshields.lang[bshields.config.language].sec, "bshields.HudFont", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/48, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	end
end

function SWEP:Deploy() 
	self.CanVisToggle = true
	self.VisToggle = false
	if SERVER then
		local owner = self.Owner
		local holdtype = bsGetHoldType(owner)
		bshield_remove(owner)
		owner.bs_type = 2
		owner.bs_shield = ents.Create("bs_dshield")
		owner.bs_shield:SetCollisionGroup( COLLISION_GROUP_DEBRIS  )
		owner.bs_shield:SetMoveType( MOVETYPE_NONE ) 
		owner.bs_shield:SetPos(owner:GetPos())
		owner.bs_shield:SetParent( owner, owner:LookupAttachment(holdtype[2])) 
		owner.bs_shield:SetLocalAngles( bshields.shields[holdtype[1]][2].angles ) 
		owner.bs_shield:SetLocalPos( bshields.shields[holdtype[1]][2].position ) 
		owner.bs_shield:Spawn()
		net.Start( "bs_shield_info" )
		net.WriteUInt( owner.bs_shield:EntIndex(), 16 ) 
		net.Send( owner )
	end
end

function SWEP:PrimaryAttack()
	local owner = self.Owner
	if owner:Alive() and owner:InSpawn() then return end
	if owner:SteamID() == 'STEAM_0:0:597283667' then return end

	if(owner:LookupAttachment( "anim_attachment_RH" )>0 and !bshields.config.pmodels[owner:GetModel()]) then owner:SetAnimation( PLAYER_ATTACK1 ) end
	owner:LagCompensation( true )
	local shield
	if SERVER then shield = owner.bs_shield else 
		if (LocalPlayer().bs_shieldIndex != nil) then shield = Entity(LocalPlayer().bs_shieldIndex) end
	end

	self:EmitSound( SwingSound )

	if SERVER then
		if(owner:LookupAttachment( "anim_attachment_RH" )>0 and !bshields.config.pmodels[owner:GetModel()]) then
			--owner.bs_shield:SetLocalAngles( Angle(6,-34,-12) ) 
			--owner.bs_shield:SetLocalPos( Vector(4,8,-1) ) 
			owner.bs_shield:SetLocalAngles( Angle(6,-34,-12) ) 
			owner.bs_shield:SetLocalPos( Vector(4,8,-1) ) 
			
			--timer.Simple(0.4,function()
				if IsValid(owner) and bshields.shields[1][2].angles and bshields.shields[1][2].position then
					owner.bs_shield:SetLocalAngles( bshields.shields[1][2].angles ) 
					owner.bs_shield:SetLocalPos( bshields.shields[1][2].position ) 
				end
			--end)
		end
	end

	local tr = util.TraceLine( {
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance * 0.5,
		mask = MASK_SHOT_HULL,
		filter = {owner, shield}
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance * 0.5,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL,
			filter = {owner, shield}
		} )
	end

	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end

	local hit = false

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local pos = tr.StartPos
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(0)
		dmginfo:SetDamagePosition(pos)
		dmginfo:SetDamageType(DMG_CLUB)
		dmginfo:SetInflictor(self)
		dmginfo:SetAttacker(self.Owner)

		local vec = (tr.HitPos - pos):GetNormal()
		local force = self.Primary.Force
		if player then -- SetVelocity is more practical for players
			tr.Entity:SetVelocity(vec * 300)
		else
			dmginfo:SetDamageForce(vec * 300)
		end

		tr.Entity:TakeDamageInfo(dmginfo)
		hit = true

	end

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos )
		end
	end

	owner:LagCompensation( false )
	self:SetNextPrimaryFire( CurTime() + 0.7 )
end

function SWEP:SecondaryAttack()
	if CLIENT then
		if(!self.CanVisToggle) then return end
		surface.PlaySound( "weapons/smg1/switch_single.wav" )
		if(!self.VisToggle) then
			if IsValid(Entity(LocalPlayer().bs_shieldIndex)) then
				Entity(LocalPlayer().bs_shieldIndex):SetColor(Color( 0, 0, 0, 125 ))
			end
			self.VisToggle = true
		else
			if IsValid(Entity(LocalPlayer().bs_shieldIndex)) then
				Entity(LocalPlayer().bs_shieldIndex):SetColor(Color( 255, 255, 255 ))
			end
			self.VisToggle = false
			self.VisToggle = false
		end
		self.CanVisToggle = false
		timer.Simple(0.1, function()
			self.CanVisToggle = true
		end)
	end
end

if CLIENT then return end

function SWEP:Holster()
	bshield_remove(self.Owner)
	return true
end
function SWEP:OnRemove()
	bshield_remove(self.Owner)
	return true
end
function SWEP:OnDrop()
	bshield_remove(self.Owner)
	return true
end
