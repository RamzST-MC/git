-- leak by lordee
include("shared.lua")

function ENT:Initialize()

	self.c_WeakMoonshine = 0
	self.c_Moonshine = 0
	self.FillingJar = false
	self.HasFillEffect = false
end

function ENT:Draw()
	self:DrawModel()

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:DrawInfo()
		self:DrawName()
		self:DrawUpgradeInfo()
		self:DrawWeakMoonShine()
	end
end

function ENT:DrawName()
	cam.Start3D2D(self:LocalToWorld(Vector(14, 0, 80)), self:LocalToWorldAngles(Angle(0,90,90)), 0.05)

		-- Title
		draw.RoundedBox(25, -200, -20, 400, 90, zyb.default_colors["black01"])
		draw.SimpleText(zyb.language.General["Condenser"], "zyb_barrel_font01", 0, -10, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		draw.SimpleText(self:GetMoonShine() .. zyb.config.LiquidUnit, "zyb_condenser_font01", 0, 925, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	cam.End3D2D()
end

function ENT:DrawUpgradeInfo()
	cam.Start3D2D(self:LocalToWorld(Vector(15, 0, 70)), self:LocalToWorldAngles(Angle(0,90,90)), 0.05)
		local text = zyb.language.VGUI["UpgradeMenu"]
		local bSize = 27 * string.len(text)

		if self:OnUpgradeMenu(LocalPlayer()) then
			draw.RoundedBox(20, -bSize / 2, -20, bSize, 80, zyb.default_colors["orange01"])
		else
			draw.RoundedBox(20, -bSize / 2, -20, bSize, 80, zyb.default_colors["grey02"])
		end

		draw.SimpleText(text, "zyb_barrel_font02", 0, -10, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	cam.End3D2D()
end

function ENT:DrawWeakMoonShine()

	local WeakMoonShine = self:GetWeakMoonShine()

	local s_bar = (540 / zyb.config.Condenser.WeakMoonshineStorage) * WeakMoonShine
	self.c_WeakMoonshine = self.c_WeakMoonshine + 100 * FrameTime()
	self.c_WeakMoonshine = math.Clamp(self.c_WeakMoonshine, 0, s_bar)

	cam.Start3D2D(self:LocalToWorld(Vector(16, 0, 70)), self:LocalToWorldAngles(Angle(0,90,90)), 0.05)

		if WeakMoonShine > 0 then
			surface.SetDrawColor(zyb.default_colors["brown02"])
			surface.SetMaterial(zyb.default_materials["circle"])
			surface.DrawTexturedRect(-120, -530, 240, 240)

			draw.SimpleText(self:GetWeakMoonShine() .. zyb.config.LiquidUnit, "zyb_condenser_font01", 0, -450, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		if WeakMoonShine > zyb.config.Condenser.WeakMoonshineStorage / 3 then
			surface.SetDrawColor(zyb.default_colors["brown03"])
			surface.SetMaterial(zyb.default_materials["circle"])
			surface.DrawTexturedRect(-120, -930, 240, 240)

		end

		if WeakMoonShine > zyb.config.Condenser.WeakMoonshineStorage / 2 then
			surface.SetDrawColor(zyb.default_colors["brown04"])
			surface.SetMaterial(zyb.default_materials["circle"])
			surface.DrawTexturedRect(-120, -1330, 240, 240)

		end

		if WeakMoonShine > zyb.config.Condenser.WeakMoonshineStorage / 1.3 then
			surface.SetDrawColor(zyb.default_colors["brown05"])
			surface.SetMaterial(zyb.default_materials["circle"])
			surface.DrawTexturedRect(-120, -1730, 240, 240)

		end
	cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:FillEffect_Start()
	if self.HasFillEffect == false then
		zyb.f.ParticleEffectAttach("yb_moonshine", self, 5)
		self.HasFillEffect = true
	end
end

function ENT:FillEffect_Stop()
	if self.HasFillEffect then
		self:StopParticlesNamed("yb_moonshine")
		self.HasFillEffect = false
	end
end

function ENT:Think()

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 500) then

		local fillingJar = self:GetFillingJar()

		if self.FillingJar ~= fillingJar then
			self.FillingJar = fillingJar

			if self.FillingJar then
				self:FillEffect_Start()
			else
				self:FillEffect_Stop()
			end

		end
	else
		self:FillEffect_Stop()
	end

	zyb.f.LoopedSound(self,"zyb_fill_moonshine", self.FillingJar)

	self:SetNextClientThink(CurTime())
	return true
end


function ENT:DrawInfo()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetUp(),-90)
	ang:RotateAroundAxis(self:GetRight(),-90)

	local moonShine = self:GetMoonShine()

	cam.Start3D2D(self:LocalToWorld(Vector(14, 0, 50)), ang, 0.05)

		surface.SetDrawColor(zyb.default_colors["white01"])
		surface.SetMaterial(zyb.default_materials["barfront01bg"])
		surface.DrawTexturedRect(-390,-440, 780, 780)
		draw.NoTexture()

		local m_bar = (710 / zyb.config.Condenser.MoonshineStorage) * moonShine
		self.c_Moonshine = self.c_Moonshine + 100 * FrameTime()
		self.c_Moonshine = math.Clamp(self.c_Moonshine, 0, m_bar)

		if self.c_Moonshine > 5 then
			draw.RoundedBox(0, -60, -405, 120, self.c_Moonshine, zyb.default_colors["brown06"])
		end

		surface.SetDrawColor(zyb.default_colors["white02"])
		surface.SetMaterial(zyb.default_materials["barfront01fg"])
		surface.DrawTexturedRect(-390,-440, 780, 780)
		draw.NoTexture()

		surface.SetDrawColor(Color(160,160,160,255))
		surface.SetMaterial(zyb.default_materials["barfront01"])
		surface.DrawTexturedRect(-390,-440, 780, 780)
		draw.NoTexture()



	cam.End3D2D()
end
-- leak by lordee