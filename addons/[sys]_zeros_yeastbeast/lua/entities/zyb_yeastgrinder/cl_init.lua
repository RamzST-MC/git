-- leak by lordee
include("shared.lua")

function ENT:Initialize()
	self.IsGrinding = false
	self.YeastAmount = 0
	self.c_BlockHeight = 0
	self.c_BlockScale = 0
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()


	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 500) then
		self.YeastAmount = self:GetYeastAmount()

		local grinding = self:GetGrinding()
		zyb.f.LoopedSound(self, "zyb_grinding", grinding)

		if self.IsGrinding ~= grinding then
			self.IsGrinding = grinding

			if self.IsGrinding then
				zyb.f.PlayClientAnimation(self,"spin", 1)

				zyb.f.ParticleEffectAttach("yb_yeast", self, 1)
				zyb.f.ParticleEffectAttach("yb_yeastgrinding", self, 2)
			else
				zyb.f.PlayClientAnimation(self,"idle", 1)
				self:StopParticlesNamed("yb_yeast")
				self:StopParticlesNamed("yb_yeastgrinding")
			end

		end

		if self.ClientProps then
			if not IsValid(self.ClientProps["YeastBlock"]) then
				self:SpawnClientModel_Yeastblock()
			else

				if self.YeastAmount <= 0 then
					self.ClientProps["YeastBlock"]:SetNoDraw(true)
				else
					self.ClientProps["YeastBlock"]:SetNoDraw(false)

					local height = 5 - ((5 / zyb.config.YeastBlock.Amount) * self.YeastAmount)
					self.c_BlockHeight = self.c_BlockHeight + 1 * FrameTime()
					self.c_BlockHeight = math.Clamp(self.c_BlockHeight, 0, height)
					self.ClientProps["YeastBlock"]:SetPos(self:GetPos() + self:GetUp() * 50 + self:GetUp() * -self.c_BlockHeight)


					local mScale = math.Clamp((1 / zyb.config.YeastBlock.Amount) * self.YeastAmount, 0.8, 1)
					self.c_BlockScale = self.c_BlockScale + 1 * FrameTime()
					self.c_BlockScale = math.Clamp(self.c_BlockScale, 0, mScale)
					self.ClientProps["YeastBlock"]:SetModelScale(self.c_BlockScale)

					if self.IsGrinding then
						self.ClientProps["YeastBlock"]:SetLocalAngles(Angle(90, RealTime() * 180, 0))
					end
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

function ENT:SpawnClientModel_Yeastblock()
	local ent = ents.CreateClientProp()
	ent:SetPos( self:LocalToWorld( Vector( 0, 0, 15 ) ) )
	ent:SetModel("models/zerochain/props_yeastbeast/yb_yeastblock.mdl")
	ent:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, 0 ) ) )
	ent:Spawn()
	ent:Activate()
	ent:SetParent(self)

	self.ClientProps["YeastBlock"] = ent
	self.ClientProps["YeastBlock"]:SetNoDraw(true)
	self.ClientProps["YeastBlock"]:SetLocalAngles(Angle(90, 0, 0))
	self.ClientProps["YeastBlock"]:SetPos(self:GetPos() + self:GetUp() * 50 )
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
end

function ENT:OnRemove()
	self:RemoveClientModels()
end
-- leak by lordee