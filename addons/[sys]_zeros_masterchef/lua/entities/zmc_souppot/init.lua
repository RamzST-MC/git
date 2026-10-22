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

	zmc.SoupPot.Initialize(self)
end

function ENT:OnRemove()
	zmc.SoupPot.OnRemove(self)
end

function ENT:AcceptInput(inputName, activator, caller, data)
	if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
		zmc.SoupPot.OnUse(self, activator)
	end
end

function ENT:CanSelectRecipe(ItemID)
	return zmc.SoupPot.CanSelectRecipe(self, ItemID)
end

function ENT:CanCancel()
	return zmc.SoupPot.CanCancel(self)
end

function ENT:Start(ply)
	return zmc.SoupPot.Start(self, ply)
end

function ENT:StartTouch(other)
	zmc.Machine.StartTouch(self, other)
end

function ENT:OnItemPickUp(ent)
	return zmc.SoupPot.OnItemPickUp(self, ent)
end

function ENT:OnTakeDamage(dmginfo)
	if (not self.m_bApplyingDamage) then
		self.m_bApplyingDamage = true
		self:TakeDamageInfo(dmginfo)
		zmc.Damage.Inflict(self, dmginfo)
		self.m_bApplyingDamage = false
	end
end
