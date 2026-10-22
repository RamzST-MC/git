-- leak by lordee
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(zyb.config.NPC.Model)
	self:SetSolid(SOLID_BBOX)
	--self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetHullType(HULL_HUMAN)
	self:SetUseType(SIMPLE_USE)

	self:SetMaxYawSpeed(90)

	if zyb.config.NPC.Capabilities then
		self:CapabilitiesAdd(CAP_ANIMATEDFACE)
		self:CapabilitiesAdd(CAP_TURN_HEAD)
	end

	self:RefreshBuyRate()
end

function ENT:AcceptInput(key, ply)
	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) and zyb.f.InDistance(ply:GetPos(), self:GetPos(), 100) then
		self.lastUsed = CurTime() + 0.25
		 zyb.f.NPC_OnUse(self,ply)
	end
end

function ENT:RefreshBuyRate()
	self:SetPrice(math.random(zyb.config.NPC.MinBuyRate, zyb.config.NPC.MaxBuyRate))
end
-- leak by lordee