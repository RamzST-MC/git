AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create(self.ClassName)
	if not IsValid(ent) then return end
	ent:SetPos(SpawnPos)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 90)
	ent:SetAngles(angle)
	ent:Spawn()
	ent:Activate()
	zclib.Player.SetOwner(ent, ply)

	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:UseClientSideAnimation()
	self:PhysWake()
	local health = math.random(10,25)
	self:SetMaxHealth(health)
	self:SetHealth(health)
	self.Destroyed = false
end

function ENT:OnTakeDamage( dmginfo )
	if zmc.config.Gastank.CanExplode == false then return end
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		self:TakeDamageInfo( dmginfo )

		if self.Destroyed then
			self.m_bApplyingDamage = false
			return
		end

		self:SetHealth(self:Health() - dmginfo:GetDamage())
		if self:Health() <= 0 then
			self:ExplodeDelayed()
		else
			local pos = dmginfo:GetDamagePosition()
			local lpos = self:WorldToLocal(pos)
			zclib.NetEvent.Create("gastank_damage", {self,lpos})
		end
		self.m_bApplyingDamage = false
	end
end

function ENT:ExplodeDelayed()

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(25)
		phys:SetDragCoefficient(0)
		local f_dir = self:GetUp() * math.random(200,600)
		phys:ApplyForceCenter(phys:GetMass() * f_dir)
	end

	self.Destroyed = true

	self:EmitSound("zmc_explosivegasleak")
	zclib.NetEvent.Create("gastank_preexplo", {self})

	timer.Simple(math.Rand(1,1.5),function()
		if not IsValid(self) then return end
		zclib.Damage.Explosion(self, self:GetPos(), 100, DMG_BLAST, 50,false)


		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(1)
		effectdata:SetScale(1)
		effectdata:SetRadius(10)
		util.Effect("Explosion", effectdata)


		SafeRemoveEntityDelayed(self,FrameTime() * 2)
	end)
end


function ENT:OnRemove()
    self:StopSound("zmc_explosivegasleak")
end
