-- leak by lordee
include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	self.JarCount = 0
end

function ENT:Think()
	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 800) then
		if self.ClientProps then
			if self.JarCount ~= self:GetJarCount() then
				self:RemoveClientModels()
				self.JarCount = self:GetJarCount()

				for i = 1, math.Clamp(self.JarCount,0,6) do
					self:SpawnClientModel_Jar(i)
				end
			end
		else
			self.ClientProps = {}
		end
	else
		self:RemoveClientModels()
	end

	self:SetNextClientThink(CurTime())

	return true
end

function ENT:SpawnClientModel_Jar(pos)
	local ent = ents.CreateClientProp()
	ent:SetPos(self:LocalToWorld(Vector(0, 0, -5)))
	ent:SetModel("models/zerochain/props_yeastbeast/yb_jar.mdl")
	ent:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
	ent:Spawn()
	ent:Activate()
	ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	ent:SetParent(self)
	ent:SetPos(self:GetAttachment(pos).Pos - self:GetUp() * 3)

	self.ClientProps[pos] = ent
end

function ENT:RemoveClientModels()
	if (self.ClientProps and table.Count(self.ClientProps) > 0) then
		for k, v in pairs(self.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end

	self.ClientProps = {}
	self.JarCount = 0
end

function ENT:OnRemove()
	self:RemoveClientModels()
end
-- leak by lordee