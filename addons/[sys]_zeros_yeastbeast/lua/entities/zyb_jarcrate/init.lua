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
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.Initializing = true
	self.Full = false
	self.Destroyed = false

	timer.Simple(0.5, function()
		if IsValid(self) then
			self.Initializing = false
		end
	end)

	zyb.f.EntList_Add(self)
end

function ENT:ItemStoreSpawn()
	if self:GetJarCount() >= 6 then
		self.Full = true
	end
end

function ENT:StartTouch(other)
	if not IsValid(other) then return end
	if other:GetClass() ~= "zyb_jar" then return end

	if zyb.f.CollisionCooldown(other) then return end

	if self.Initializing then return end
	if self.Destroyed then return end
	if self.Full then return end

	if other:GetMoonShine() >= zyb.config.Jar.MoonshineAmount then
		self:AddJar(other)
	end
end

function ENT:AddJar(jar)
	self:SetJarCount(self:GetJarCount() + 1)
	SafeRemoveEntity(jar)

	if self:GetJarCount() >= 6 then
		self.Full = true
	end

	zyb.f.CreateNetEffect("sfx_jar",self)
end

function ENT:AcceptInput(key, ply)
	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) and zyb.f.InDistance(ply:GetPos(), self:GetPos(), 100) then
		self.lastUsed = CurTime() + 0.25
		if self.Destroyed then return end

		if self:GetJarCount() > 0 then
			if self:OnCollectButton(ply) and zyb.config.NPC.SellMode == 2 then
				ply:zyb_Add_MoonshineJar(self:GetJarCount())
				SafeRemoveEntity(self)
			elseif self:OnExtractButton(ply) then
				self:ExtractJar()
			end
		end
	end
end

function ENT:ExtractJar()
	local ent = ents.Create("zyb_jar")
	ent:SetAngles(Angle(0, 0, 0))
	ent:SetPos(self:GetPos() + self:GetUp() * 30 + self:GetRight() * 30)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1, 1)
	ent:SetBodygroup(2, 5)
	ent:SetMoonShine(zyb.config.Jar.MoonshineAmount)
	self:SetJarCount(self:GetJarCount() - 1)
	self.Full = false
end

function ENT:OnTakeDamage(dmg)
	if self.Destroyed then return end
	self:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = 50

	if entHealth > 0 and self:GetJarCount() > 0 then
		self.CurrentHealth = (self.CurrentHealth or entHealth) - damage

		if (self.CurrentHealth <= 0) then

			// Call a custom hook
			hook.Run("zyb_OnObjectDestroyed",self,dmg)

			zyb.f.CreateNetEffect("crate_explode",self:GetPos())
			self.Destroyed = true
			self:SetNoDraw(true)
			SafeRemoveEntityDelayed(self, 0.1)
		end
	end
end
-- leak by lordee