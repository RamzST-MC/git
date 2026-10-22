-- leak by lordee
include("shared.lua")

function ENT:Initialize()
	self.c_Water = 0
	self.c_Steam = 0
	self.c_MoonSine = 0
	self.c_Deflow = false
	self.Temp = 0
	self.CurrentTempLevel = 0
	self.c_WaterColor = zyb.default_colors["white01"]
end

function ENT:Think()

	local deflow = self:GetDeflowWater()

	if self.c_Deflow ~= deflow then
		self.c_Deflow = deflow

		if self.c_Deflow then
			zyb.f.PlayClientAnimation(self, "ventil_output_open", 1)

			local attach = self:GetAttachment(1)
			local ang = attach.Ang
			ang:RotateAroundAxis(ang:Right(),90)

			zyb.f.ParticleEffect("yb_water", attach.Pos, ang, self )
		else
			zyb.f.PlayClientAnimation(self, "ventil_output_close", 1)
			self:StopParticlesNamed("yb_water")
		end
	end

	zyb.f.LoopedSound(self, "zyb_fill_liquid", self.c_Deflow)

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:ConvertHeatToColor()
	self.Temp = self:GetWaterTemperatur()
	self.CurrentTempLevel = (1 / 100) * self.Temp
	self.c_WaterColor = zyb.f.LerpColor(self.CurrentTempLevel, zyb.default_colors["blue02"], zyb.default_colors["orange02"])
end

function ENT:Draw()
	self:DrawModel()

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then

		self:ConvertHeatToColor()

		self:DrawName()
		self:DrawInfo()
		self:DrawValveInfo()
		self:DrawHeatInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawHeatInfo()
	cam.Start3D2D(self:LocalToWorld(Vector(14.2,0, 99.2)), self:LocalToWorldAngles(Angle(0,90,90)), 0.05)

		surface.SetDrawColor(zyb.default_colors["grey03"])
		surface.SetMaterial(zyb.default_materials["circle"])
		surface.DrawTexturedRect(-70,-70, 140, 140)

		draw.SimpleText(self.Temp .. zyb.config.HeatUnit, "zyb_barrel_font02", 0, -25, self.c_WaterColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.SetDrawColor(zyb.default_colors["black04"])
		surface.SetMaterial(zyb.default_materials["shadowcircle"])
		surface.DrawTexturedRect(-55,-56, 110, 110)

		surface.SetDrawColor(zyb.default_colors["white02"])
		surface.SetMaterial(zyb.default_materials["glamcircle"])
		surface.DrawTexturedRect(-65,-65, 130, 130)
	cam.End3D2D()
end

function ENT:DrawName()
	cam.Start3D2D(self:LocalToWorld(Vector(14, 0, 110)), self:LocalToWorldAngles(Angle(0,90,90)), 0.05)

		-- Title
		local text = zyb.language.General["Cooler"]
		local bSize = 35 * string.len( text )
		draw.RoundedBox(25, -bSize / 2, 0, bSize, 90, zyb.default_colors["black01"])
		draw.SimpleText(text, "zyb_barrel_font01", 0, 10, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	cam.End3D2D()
end

function ENT:DrawInfo()
	local water = self:GetWater()
	local yeastSteam = self:GetYeastStewSteam()
	local moonShine = self:GetWeakMoonShine()

	cam.Start3D2D(self:LocalToWorld(Vector(14, 0, 41)), self:LocalToWorldAngles(Angle(0,-90,-90)), 0.05)

		local w_bar = math.Clamp((540 / zyb.config.Cooler.WaterAmount) * water,0,540)

		if w_bar > self.c_Water then
			self.c_Water = self.c_Water + 100 * FrameTime()
			self.c_Water = math.Clamp(self.c_Water, 0, w_bar)
		else
			self.c_Water = self.c_Water - 50 * FrameTime()
			self.c_Water = math.Clamp(self.c_Water, w_bar, 540)
		end



		surface.SetDrawColor(zyb.default_colors["white01"])
		surface.SetMaterial(zyb.default_materials["barfront02bg"])
		surface.DrawTexturedRect(-190,510, 380, 560)

		if self.c_Water > 0 then
			draw.RoundedBox(0, -25, 520, 50, self.c_Water, self.c_WaterColor)
		end

		surface.SetDrawColor(zyb.default_colors["white03"])
		surface.SetMaterial(zyb.default_materials["barfront02fg"])
		surface.DrawTexturedRect(-200,500, 400, 580)

		surface.SetDrawColor(zyb.default_colors["orange03"])
		surface.SetMaterial(zyb.default_materials["barfront02"])
		surface.DrawTexturedRect(-200,500, 400, 580)


		surface.SetDrawColor(zyb.default_colors["white01"])
		surface.SetMaterial(zyb.default_materials["barfront02bg"])
		surface.DrawTexturedRect(-116,510, 380, 560)


		local s_bar = math.Clamp((540 / zyb.config.Cooler.YeastSteamAmount) * yeastSteam,0,540)
		self.c_Steam = self.c_Steam + 100 * FrameTime()
		self.c_Steam = math.Clamp(self.c_Steam, 0, s_bar)

		if self.c_Steam  > 0 then
			draw.RoundedBox(0, 50, 520, 50, self.c_Steam , zyb.default_colors["brown08"])
		end

		surface.SetDrawColor(zyb.default_colors["white03"])
		surface.SetMaterial(zyb.default_materials["barfront02fg"])
		surface.DrawTexturedRect(-125,500, 400, 580)

		surface.SetDrawColor(zyb.default_colors["orange03"])
		surface.SetMaterial(zyb.default_materials["barfront02"])
		surface.DrawTexturedRect(-126,500, 400, 580)




		surface.SetDrawColor(zyb.default_colors["white01"])
		surface.SetMaterial(zyb.default_materials["barfront02bg"])
		surface.DrawTexturedRect(-268,510, 380, 560)

		local m_bar = math.Clamp((540 / zyb.config.Cooler.WeakMoonshineStorage) * moonShine,0,540)
		self.c_MoonSine = self.c_MoonSine + 100 * FrameTime()
		self.c_MoonSine = math.Clamp(self.c_MoonSine, 0, m_bar)

		if self.c_MoonSine > 0 then
			draw.RoundedBox(0, -100, 520, 50, self.c_MoonSine, zyb.default_colors["brown02"])
		end


		surface.SetDrawColor(zyb.default_colors["white03"])
		surface.SetMaterial(zyb.default_materials["barfront02fg"])
		surface.DrawTexturedRect(-276,500, 400, 580)

		surface.SetDrawColor(zyb.default_colors["orange03"])
		surface.SetMaterial(zyb.default_materials["barfront02"])
		surface.DrawTexturedRect(-276,500, 400, 580)


	cam.End3D2D()
end

function ENT:DrawValveInfo()
	cam.Start3D2D(self:LocalToWorld(Vector(15, 0, 65)), self:LocalToWorldAngles(Angle(0,90,90)), 0.05)

		local text = zyb.language.General["ReleaseWater"]
		local bSize = 27 * string.len(text)

		if self:OnWaterValve(LocalPlayer()) then
			draw.RoundedBox(20, -bSize / 2, -20, bSize, 80, zyb.default_colors["blue02"])
		else
			draw.RoundedBox(20, -bSize / 2, -20, bSize, 80, zyb.default_colors["grey02"])
		end

		draw.SimpleText(text, "zyb_barrel_font02", 0, -10, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	cam.End3D2D()
end
-- leak by lordee