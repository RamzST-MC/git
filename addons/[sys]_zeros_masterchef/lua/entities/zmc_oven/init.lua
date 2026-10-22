AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	return zmc.Machine.Spawn(self, tr, ply)
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:UseClientSideAnimation()
	self:PhysWake()
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableMotion(true)
	end

	zmc.Oven.Initialize(self)
end

function ENT:OnRemove()
	zmc.Oven.OnRemove(self)
end

function ENT:AcceptInput(inputName, activator, caller, data)
	if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
		if self.NextUse and CurTime() < self.NextUse then return end
		zmc.Oven.OnUse(self, activator)
		self.NextUse = CurTime() + 0.25
	end
end

function ENT:OnTemperaturChange(newTemp)
	zmc.Oven.OnTemperaturChange(self, newTemp)
end

function ENT:StartTouch(other)
	zmc.Machine.StartTouch(self, other)
end

function ENT:OnItemPickUp(ent)
	return zmc.Oven.OnItemPickUp(self, ent)
end

function ENT:OnTakeDamage(dmginfo)
	if (not self.m_bApplyingDamage) then
		self.m_bApplyingDamage = true
		self:TakeDamageInfo(dmginfo)
		zmc.Damage.Inflict(self, dmginfo)
		self.m_bApplyingDamage = false
	end
end
