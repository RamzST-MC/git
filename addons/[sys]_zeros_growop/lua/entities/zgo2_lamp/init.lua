--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 5
	local ang = (ply:GetPos() - SpawnPos):Angle()
	ang = Angle(0, 180 + ang.y, 0)
	local ent = ents.Create(self.ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	zclib.Player.SetOwner(ent, ply)

	return ent
end

function ENT:Initialize()
	zgo2.Destruction.SetupHealth(self)
	zgo2.Lamp.Initialize(self)
end

function ENT:AcceptInput(inputName, activator, caller, data)
	if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
		zgo2.Lamp.OnUse(self, activator)
	end
end

function ENT:PhysicsCollide(data, physobj)
	zgo2.Lamp.OnTouch(self, data.HitEntity)
end

function ENT:AddPower(power)
	return zgo2.Lamp.AddPower(self, power, true)
end

function ENT:OnTakeDamage(dmginfo)
	-- Make sure we're not already applying damage a second time
	-- This prevents infinite loops
	if not self.m_bApplyingDamage then
		self.m_bApplyingDamage = true
		self:TakeDamageInfo(dmginfo)
		zgo2.Destruction.OnDamaged(self, dmginfo)
		self.m_bApplyingDamage = false
	end
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher