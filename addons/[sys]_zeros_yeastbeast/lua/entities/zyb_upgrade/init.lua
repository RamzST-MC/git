-- leak by lordee
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.Condenser = nil
end

function ENT:AcceptInput(key, ply)
	if zyb.config.Upgrade.Cleaning == false then return end
	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive() and zyb.f.InDistance(ply:GetPos(), self:GetPos(), 200)) then
		self.lastUsed = CurTime() + 0.15

		if self:GetIsDirty() then
			self:SetIsDirty(false)
			zyb.f.CreateNetEffect("fx_clean",self:GetPos())
			self:SetSkin(0)
			zyb.f.UpdateBoostValues(self.Condenser)
		end
	end
end
-- leak by lordee