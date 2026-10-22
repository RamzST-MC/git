-- leak by lordee
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 180)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zyb.f.SetOwner(ent, ply)

	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(CONTINUOUS_USE)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	self:UseClientSideAnimation()
	zyb.f.Cooler_Initialize(self)
end

function ENT:OnTakeDamage(dmg)
	if IsValid(self.Distillery) then
		zyb.f.Entity_OnTakeDamage(self.Distillery, dmg)
	end
end

function ENT:StartTouch(other)
	zyb.f.Cooler_OnTouch(self, other)
end

function ENT:Think()
	zyb.f.Cooler_CoolingProcess(self)
	zyb.f.Cooler_ReleaseWater(self)
end

function ENT:AcceptInput(key, ply)
	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive() and zyb.f.InDistance(ply:GetPos(), self:GetPos(), 100)) then
		self.lastUsed = CurTime() + 0.15
		zyb.f.Cooler_OnUse(self, ply)
	end
end
-- leak by lordee