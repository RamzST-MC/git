AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.SeizeReward = 150
ENT.WantReason = 'Девайсы для принтера'

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self:PhysWake()
	
	self:SetTrigger(true)
	self.damage = self.MaxHealth
end

function ENT:OnTakeDamage(dmg)
	local phys = self:GetPhysicsObject()
	if not phys:IsMoveable() then return end

	self.damage = self.damage - dmg:GetDamage()
	if (self.damage <= 0) then
		self:Destruct()
		self:Remove()
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

function ENT:StartTouch(ent)
	if (not self.Used) and IsValid(ent) and (ent:GetClass() == 'money_printer' and ent:GetInk() > 0 and !ent:GetIsDestructing() and !ent:IsCancelingDestruction()) then
		self.Used = true
		self:Remove()
		ent:PrintMoney(true)
		ent:EmitSound('ambient/energy/weld1.wav')
	end
end