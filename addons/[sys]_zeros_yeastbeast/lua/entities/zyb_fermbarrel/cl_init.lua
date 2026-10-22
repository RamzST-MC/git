-- leak by lordee
include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) and self:GetHideUI() == false then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawInfo()
	local y_bar = 500 / zyb.config.FermBarrel.YeastAmount * self.Yeast
	local w_bar = 500 / zyb.config.FermBarrel.WaterAmount * self.Water
	local s_bar = 500 / zyb.config.FermBarrel.SugarAmount * self.Sugar

	self.stage = self:GetStage()


	cam.Start3D2D(self:LocalToWorld(Vector(0, 0, 70)), Angle(0, EyeAngles().y - 90, -EyeAngles().x + 90), 0.05)

		// Title
		draw.RoundedBox(25, -350, 0, 700, 90, zyb.default_colors["black01"])
		draw.SimpleText(zyb.language.General["Fermentation Barrel"], "zyb_barrel_font01", 0, 10, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )


		//Info
		--draw.RoundedBox(25, -350, 100, 700, 320, zyb.default_colors["black01"])

		if self.stage == 0 then

			--draw.RoundedBox(39, -195, 115, 510, 80, zyb.default_colors["white01"])
			draw.RoundedBox(35, -190, 120, 500, 70, zyb.default_colors["black03"])
			draw.RoundedBox(35, -190, 120, y_bar, 70, zyb.default_colors["yeast"])
			//draw.SimpleText(zyb.language.General["Yeast"] .. ":", "zyb_barrel_font02", -325, 110, zyb.default_colors["white01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			surface.SetDrawColor(zyb.default_colors["white01"])
			surface.SetMaterial(zyb.default_materials["yeast"])
			surface.DrawTexturedRect(-320, 100, 100, 100)

			--draw.RoundedBox(39, -195, 215, 510, 80, zyb.default_colors["white01"])
			draw.RoundedBox(35, -190, 220, 500, 70, zyb.default_colors["black03"])
			draw.RoundedBox(35, -190, 220, s_bar, 70, zyb.default_colors["sugar"])
			//draw.SimpleText(zyb.language.General["Sugar"] .. ":", "zyb_barrel_font02", -325, 180, zyb.default_colors["white01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			surface.SetDrawColor(zyb.default_colors["white01"])
			surface.SetMaterial(zyb.default_materials["sugar"])
			surface.DrawTexturedRect(-320, 200, 100, 100)

			--draw.RoundedBox(39, -195, 315, 510, 80, zyb.default_colors["white01"])
			draw.RoundedBox(35, -190, 320, 500, 70, zyb.default_colors["black03"])
			draw.RoundedBox(35, -190, 320, w_bar, 70, zyb.default_colors["water"])
			//draw.SimpleText(zyb.language.General["Water"] .. ":", "zyb_barrel_font02", -325, 250, zyb.default_colors["white01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			surface.SetDrawColor(zyb.default_colors["white01"])
			surface.SetMaterial(zyb.default_materials["water"])
			surface.DrawTexturedRect(-320, 300, 100, 100)



		elseif self.stage == 1 then
			draw.SimpleText(zyb.language.General["Shakeit"], "zyb_barrel_font03", 0, 125, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			local shake_bar = 500 / zyb.config.FermBarrel.ShakeCount * self:GetShakeProgress()

			self.CurrentShakeBar = self.CurrentShakeBar + 100 * FrameTime()
			self.CurrentShakeBar = math.Clamp(self.CurrentShakeBar,0,shake_bar)


			draw.RoundedBox(5, -250, 225, 500, 50, zyb.default_colors["black03"])
			draw.RoundedBox(5, -250, 225, self.CurrentShakeBar, 50, zyb.default_colors["white04"])
		elseif self.stage == 2 then
			draw.SimpleText(zyb.language.General["Fermenting"], "zyb_barrel_font03", 0, 125, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			local ferment_bar = 500 / zyb.config.FermBarrel.FermentingTime * (zyb.config.FermBarrel.FermentingTime-(self:GetFermentingTime() - CurTime()))

			self.CurrentShakeBar = self.CurrentShakeBar + 100 * FrameTime()
			self.CurrentShakeBar = math.Clamp(self.CurrentShakeBar,0,ferment_bar)

			local ferment_col = 1 / zyb.config.FermBarrel.FermentingTime * (zyb.config.FermBarrel.FermentingTime-(self:GetFermentingTime() - CurTime()))
			local fermColor = zyb.f.LerpColor(ferment_col, zyb.default_colors["brown08"], zyb.default_colors["brown01"])


			draw.RoundedBox(5, -250, 225, 500, 50, zyb.default_colors["black03"])
			draw.RoundedBox(5, -250, 225, self.CurrentShakeBar, 50, fermColor)
		elseif self.stage == 3 then

			local ys_amount =  self:GetYeastStew()

			draw.SimpleText(zyb.language.General["YeastStew"] .. ": " .. ys_amount .. zyb.config.LiquidUnit, "zyb_barrel_font02", 0, 135, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			local YeastStew_bar = (500 / zyb.config.FermBarrel.YeastStew) * ys_amount

			self.CurrentShakeBar = self.CurrentShakeBar + 100 * FrameTime()
			self.CurrentShakeBar = math.Clamp(self.CurrentShakeBar,0,YeastStew_bar)


			draw.RoundedBox(5, -250, 225, 500, 50, zyb.default_colors["black03"])
			draw.RoundedBox(5, -250, 225, self.CurrentShakeBar, 50, zyb.default_colors["brown01"])
		elseif self.stage == 4 then
			draw.SimpleText(zyb.language.General["Cleanit"], "zyb_barrel_font01", 0, 175, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		end

	cam.End3D2D()
end

function ENT:Initialize()
	self.CurrentMixtureLevel = -1
	self.Yeast = 0
	self.Water = 0
	self.Sugar = 0
	self.LastProgress = -1

	self.LastShake = -1
	self.CurrentShakeBar = 0

	self.CurrentCleanLevel = 0

	self.MashEffect = false
	self.FermentEffect = false
end

function ENT:IsFermenting()
	if self:GetStage() == 2 then
		return true
	else
		return false
	end
end

function ENT:Think()

	zyb.f.LoopedSound(self, "zyb_fill_liquid", self:GetFilling())
	zyb.f.LoopedSound(self, "zyb_fermenting", self:IsFermenting())

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 500) then

		self.Yeast = self:GetYeastAmount()
		self.Water = self:GetWaterAmount()
		self.Sugar = self:GetSugarAmount()

		self:ShakeSound()

		if self.ClientProps then
			if not IsValid(self.ClientProps["Water"]) then
				self:SpawnClientModel_Mixture()
			else

				local maxCap = zyb.config.FermBarrel.YeastAmount + zyb.config.FermBarrel.WaterAmount + zyb.config.FermBarrel.SugarAmount
				local newMixLvl = (1 / maxCap) * (self.Yeast + self.Water + self.Sugar)

				if self.CurrentMixtureLevel ~= newMixLvl then

					self.CurrentMixtureLevel = self.CurrentMixtureLevel + 0.25 * FrameTime()
					self.CurrentMixtureLevel = math.Clamp(self.CurrentMixtureLevel,0,newMixLvl)

					local mat = Matrix()
					mat:Scale(Vector(1, 1, self.CurrentMixtureLevel))
					self.ClientProps["Water"]:EnableMatrix("RenderMultiply", mat)

					if newMixLvl <= 0 then
						self.ClientProps["Water"]:SetNoDraw(true)
					else
						self.ClientProps["Water"]:SetNoDraw(false)
					end

					local col = zyb.f.LerpColor(newMixLvl, zyb.default_colors["blue05"], zyb.default_colors["brown07"])
					self.ClientProps["Water"]:SetColor(col)
				end

				self.ClientProps["Water"]:SetPos( self:LocalToWorld( Vector( 0, 0, 0 ) ) )
			end
		else
			self.ClientProps = {}
		end

		if self:GetFermentingTime() > 0 then
			if self.FermentEffect == false then
				zyb.f.ParticleEffectAttach("yb_fermenting", self, 1)
				self.FermentEffect = true
			end
		else
			if self.FermentEffect then
				self:StopParticlesNamed("yb_fermenting")
				self.FermentEffect = false
			end
		end


		local clean = self:GetDirtLevel()

		if self.CurrentCleanLevel ~= clean then
			self.CurrentCleanLevel = clean

			self:SetColor(zyb.f.LerpColor((1 / zyb.config.FermBarrel.DirtAmount) * clean, zyb.default_colors["white01"], zyb.default_colors["orange04"]))

			if clean <= 0 then
				self:SetColor(zyb.default_colors["white01"])
			end
		end
	else
		if self.FermentEffect then
			self:StopParticlesNamed("yb_fermenting")
			self.FermentEffect = false
		end
		self.CurrentMixtureLevel = -1
		self:RemoveClientModels()
	end

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:SpawnClientModel_Mixture()
	local ent = ents.CreateClientProp()
	ent:SetPos( self:LocalToWorld( Vector( 0, 0, 0 ) ) )
	ent:SetModel("models/zerochain/props_yeastbeast/yb_barrel_liquid.mdl")
	ent:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, 0 ) ) )
	ent:Spawn()
	ent:Activate()
	ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	ent:SetColor(zyb.default_colors["blue05"])
	ent:SetParent(self)

	self.ClientProps["Water"] = ent
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
	self:StopSound("zyb_fill_liquid")
	self:StopSound("zyb_fermenting")
	self:RemoveClientModels()
end

function ENT:ShakeSound()
	if self.stage ~= 1 then
		if self.ShakeSoundObj and self.ShakeSoundObj:IsPlaying() == true then
			self.ShakeSoundObj:ChangeVolume(0, 0)
			self.ShakeSoundObj:Stop()
			self:EmitSound("zyb_shaking_end")
		end

		return
	end

	if CurTime() < self.LastShake then return end

	if self:GetVelocity():Length() > 50 then
		if self.ShakeSoundObj == nil then
			self.ShakeSoundObj = CreateSound(self, "zyb_shaking_loop")
		end

		if self.ShakeSoundObj:IsPlaying() == false then
			self.ShakeSoundObj:Play()
			self.ShakeSoundObj:ChangeVolume(1, 0)
		end
	else
		if self.ShakeSoundObj and self.ShakeSoundObj:IsPlaying() == true then
			self.ShakeSoundObj:ChangeVolume(0, 0)
			self.ShakeSoundObj:Stop()
			self:EmitSound("zyb_shaking_end")
		end
	end

	self.LastShake = CurTime() + 0.5
end
-- leak by lordee