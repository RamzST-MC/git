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
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetCustomCollisionCheck(true)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.Condenser = nil
	self.Destroyed = false
	self.AttachCoolDown = false

	self:UpdateVisuals()

	zyb.f.EntList_Add(self)
end

function ENT:AcceptInput(key, ply)
	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive() and zyb.f.InDistance(ply:GetPos(), self:GetPos(), 100)) then
		self.lastUsed = CurTime() + 0.15
		if self.Destroyed then return end

		if not IsValid(self.Condenser) and self:GetMoonShine() > 0 then

			// Drink moonshine
			local newHealth = ply:Health() + zyb.config.Jar.Health

			newHealth = math.Clamp(newHealth, -100, ply:GetMaxHealth())
			ply:SetHealth(newHealth)

			zyb.f.CreateDrunkEffect(zyb.config.Jar.EffectDuration, ply)

			ply._zybJarDamageReduce = true

			timer.Simple(zyb.config.Jar.EffectDuration, function()
				if IsValid(ply) then
					ply._zybJarDamageReduce = nil
				end
			end)


			ply:EmitSound("zyb_drinking")
			self:Remove()
		end
	end
end

function ENT:OnTakeDamage(dmg)
	if self.Destroyed then return end
	self:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = 10

	if entHealth > 0 and not IsValid(self.Condenser) and self:GetMoonShine() > 0 then
		self.CurrentHealth = (self.CurrentHealth or entHealth) - damage

		if (self.CurrentHealth <= 0) then

			// Call a custom hook
			hook.Run("zyb_OnObjectDestroyed",self,dmg)

			zyb.f.CreateNetEffect("jar_explode",self:GetPos())
			self.Destroyed = true
			self:SetNoDraw(true)
			SafeRemoveEntityDelayed(self, 0.1)
		end
	end
end

function ENT:UpdateVisuals()
	local jarMoonshine = self:GetMoonShine()
	local jarMax = zyb.config.Jar.MoonshineAmount

	if jarMoonshine >= jarMax then
		self:SetBodygroup(2, 5)
	elseif jarMoonshine >= jarMax * 0.75 then
		self:SetBodygroup(2, 4)
	elseif jarMoonshine >= jarMax * 0.5 then
		self:SetBodygroup(2, 3)
	elseif jarMoonshine >= jarMax * 0.25 then
		self:SetBodygroup(2, 2)
	elseif jarMoonshine >= jarMax * 0.1 then
		self:SetBodygroup(2, 1)
	else
		self:SetBodygroup(2, 0)
	end

	if jarMoonshine >= jarMax then
		self:SetBodygroup(1,1)
	end
end

hook.Add("EntityTakeDamage", "zyb_JarDamageReduction", function(target, dmginfo)
	if target:IsPlayer() and target._zybJarDamageReduce then
		local reduction = 0.5
		local newDmg = dmginfo:GetDamage() * (1 - reduction)
		dmginfo:SetDamage(newDmg)
	end
end)