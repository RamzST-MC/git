-- leak by lordee
include("shared.lua")

function ENT:Initialize()
	self.c_YeastStew = -1
	self.l_YeastStew = -1
	self.c_Fuel = 0
	self.CurrentFuelLevel = 0
	self.CurrentPressureLevel = 0
	self.Depressuring = false
	self.HeatEffect = false
	self.Pressure = 0
	self.OverHeatEffect = false
end


function ENT:Draw()
	self:DrawModel()

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:DrawInfo()
		self:DrawHeatInfo()
		self:DrawValveInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawInfo()

	local cooler_ent = self:GetCooler()
	local condenser_ent = self:GetCondenser()

	cam.Start3D2D(self:LocalToWorld(Vector(38, 0, 49)), self:LocalToWorldAngles(Angle(0,90,90)), 0.05)

		-- Title
		draw.RoundedBox(25, -350, 0, 700, 90, zyb.default_colors["black01"])
		draw.SimpleText(zyb.language.General["Distillery"], "zyb_barrel_font01", 0, 10, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		--Info
		draw.RoundedBox(25, -350, 100, 700, 220, zyb.default_colors["black01"])

		if not IsValid(cooler_ent) then
			draw.SimpleText(zyb.language.General["MissingCooler"], "zyb_barrel_font02", -330, 115, zyb.default_colors["red01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		elseif not IsValid(condenser_ent) then
			draw.SimpleText(zyb.language.General["MissingCondenser"], "zyb_barrel_font02", -330, 175, zyb.default_colors["red01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		elseif IsValid(cooler_ent) and IsValid(condenser_ent) then

			local YeastStew = self:GetYeastStew()

			local y_bar = 650 / zyb.config.Distillery.YeastStewAmount * YeastStew
			self.c_YeastStew = self.c_YeastStew + 100 * FrameTime()
			self.c_YeastStew = math.Clamp(self.c_YeastStew, 0, y_bar)

			draw.RoundedBox(5, -325, 130, 650, 70, zyb.default_colors["black03"])
			draw.RoundedBox(5, -325, 130, self.c_YeastStew, 70, zyb.default_colors["brown01"])

			draw.SimpleText(zyb.language.General["YeastStew"] .. ": " .. YeastStew .. zyb.config.LiquidUnit, "zyb_barrel_font02", -320, 140, zyb.default_colors["white01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			local fuel = self:GetFuel()

			local f_bar = 650 / zyb.config.Distillery.FuelAmount * fuel
			self.c_Fuel = self.c_Fuel + 100 * FrameTime()
			self.c_Fuel = math.Clamp(self.c_Fuel, 0, f_bar)

			draw.RoundedBox(5, -325, 220, 650, 70, zyb.default_colors["black03"])
			draw.RoundedBox(5, -325, 220, self.c_Fuel, 70, zyb.default_colors["red02"])

			draw.SimpleText(zyb.language.General["Fuel"] .. ": " .. fuel, "zyb_barrel_font02", -320, 230, zyb.default_colors["white01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	cam.End3D2D()
end

function ENT:DrawHeatInfo()

	local pressure = self.Pressure

	self.CurrentPressureLevel = (1 / 100) * pressure

	local iSize = (200 / 100) * pressure

	local c_Step = 0
	local color = zyb.default_colors["white01"]


	if pressure < 40 then
		c_Step = (1 / 40) * pressure
		color = zyb.f.LerpColor(c_Step, zyb.default_colors["blue01"], zyb.default_colors["green01"])
	elseif pressure >= 40 and pressure < 80 then
		c_Step = (1 / 40) * (pressure-40)
		color = zyb.f.LerpColor(c_Step, zyb.default_colors["green01"], zyb.default_colors["yellow01"])
	elseif pressure >= 80 then
		c_Step = (1 / 20) * (pressure-80)
		color = zyb.f.LerpColor(c_Step, zyb.default_colors["yellow01"], zyb.default_colors["red03"])
	end

	cam.Start3D2D(self:LocalToWorld(Vector(0.5, -34.8, 74.4)), self:LocalToWorldAngles(Angle(0,90,90)), 0.05)

		surface.SetDrawColor(zyb.default_colors["grey01"])
		surface.SetMaterial(zyb.default_materials["circle"])
		surface.DrawTexturedRect(-100,-100, 200, 200)


		surface.SetDrawColor(color)
		surface.SetMaterial(zyb.default_materials["circle"])
		surface.DrawTexturedRect( -iSize / 2,  -iSize / 2, iSize, iSize)


		draw.SimpleText(pressure .. zyb.config.HeatUnit, "zyb_heater_font01", 0, -20, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.SetDrawColor(zyb.default_colors["black04"])
		surface.SetMaterial(zyb.default_materials["shadowcircle"])
		surface.DrawTexturedRect(-84,-84, 170, 170)


		surface.SetDrawColor(zyb.default_colors["white02"])
		surface.SetMaterial(zyb.default_materials["glamcircle"])
		surface.DrawTexturedRect(-95,-97, 196, 196)


		surface.SetDrawColor(zyb.default_colors["white01"])
		surface.SetMaterial(zyb.default_materials["heaterzone"])
		surface.DrawTexturedRect(-85,-85, 170, 170)

	cam.End3D2D()
end

function ENT:DrawValveInfo()
	cam.Start3D2D(self:LocalToWorld(Vector(0, -30, 98.4)), self:LocalToWorldAngles(Angle(0,90,90)), 0.05)
		local text = zyb.language.General["Depressurize"]
		local bSize = 27 * string.len(text)

		if self:OnPressureValve(LocalPlayer()) then
			draw.RoundedBox(20, -bSize / 2, -20, bSize, 80, zyb.default_colors["red04"])
		else
			draw.RoundedBox(20, -bSize / 2, -20, bSize, 80, zyb.default_colors["grey02"])
		end

		draw.SimpleText(text, "zyb_barrel_font02", 0, -10, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	cam.End3D2D()
end

function ENT:HasFuel()
	if self:GetFuel() > 0  then
		return true
	else
		return false
	end
end

function ENT:IsCooking()
	if self:GetFuel() > 0 and self:GetYeastStew() > 0 then
		return true
	else
		return false
	end
end

function ENT:IsOverheating()
	if self.Pressure > 81 then
		return true
	else
		return false
	end
end

function ENT:Think()

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 500) then

		local pressure = self:GetPressureLevel()

		if self.Pressure ~= pressure then
			self.Pressure = pressure

			if self.Pressure > 81 then
				if self.OverHeatEffect == false then

					zyb.f.ParticleEffectAttach("yb_overheat", self, 4)
					self.OverHeatEffect = true
				end
			else
				if self.OverHeatEffect == true then
					self:StopParticlesNamed("yb_overheat")
					self.OverHeatEffect = false
				end
			end
		end


		local depress = self:GetDepressuring()

		if self.Depressuring ~= depress then
			self.Depressuring = depress

			if self.Depressuring then
				zyb.f.PlayClientAnimation(self, "ventil_release", 1)

				local attach = self:GetAttachment(1)
				local ang = attach.Ang
				ang:RotateAroundAxis(ang:Right(),90)

				zyb.f.ParticleEffect("yb_steamjet", attach.Pos, ang, self )
			else
				zyb.f.PlayClientAnimation(self, "ventil_close", 1)
				self:StopParticlesNamed("yb_steamjet")
			end
		end



		if self.ClientProps then
			if not IsValid(self.ClientProps["Fuel"]) then
				self:SpawnClientModel_Fuel()
			else

				local newFuelLvl = (1 / zyb.config.Distillery.FuelAmount) * self:GetFuel()
				local newyeaststew = self:GetYeastStew()

				if self.CurrentFuelLevel ~= newFuelLvl or self.l_YeastStew ~= newyeaststew then

					self.l_YeastStew = newyeaststew

					self.CurrentFuelLevel = self.CurrentFuelLevel + 0.25 * FrameTime()
					self.CurrentFuelLevel = math.Clamp(self.CurrentFuelLevel,0,newFuelLvl)

					self.ClientProps["Fuel"]:SetModelScale(self.CurrentFuelLevel)

					if self.HeatEffect == false then

						zyb.f.ParticleEffectAttach("yb_heaterflame", self, 3)
						self.HeatEffect = true
						self.ClientProps["Fuel"]:SetColor(zyb.default_colors["white01"])
					end

					if newFuelLvl <= 0 or self.l_YeastStew <= 0 and self.HeatEffect then
						self:StopParticlesNamed("yb_heaterflame")
						self.HeatEffect = false
						self.ClientProps["Fuel"]:SetColor(zyb.default_colors["grey02"])
					end

					if newFuelLvl <= 0 then
						self.ClientProps["Fuel"]:SetNoDraw(true)

					else
						self.ClientProps["Fuel"]:SetNoDraw(false)
					end
				end

			end
		else
			self.ClientProps = {}
		end
	else

		if self.HeatEffect then
			self:StopParticlesNamed("yb_heaterflame")
			self.HeatEffect = false
			self.CurrentFuelLevel = 0
		end

		if self.OverHeatEffect == true then
			self:StopParticlesNamed("yb_overheat")
			self.OverHeatEffect = false
			self.Pressure = 0
		end

		self:RemoveClientModels()
	end

	zyb.f.LoopedSound(self, "zyb_steam_loop", self.Depressuring)

	zyb.f.LoopedSound(self, "zyb_burning", self:IsCooking())

	zyb.f.LoopedSound(self, "zyb_cooking", self:IsCooking())

	zyb.f.LoopedSound(self, "zyb_overheat_loop", self:IsOverheating())



	self:SetNextClientThink(CurTime())
	return true
end

function ENT:SpawnClientModel_Fuel()
	local ent = ents.CreateClientProp()
	ent:SetPos( self:LocalToWorld( Vector( 0, 0, 5 ) ) )
	ent:SetModel("models/zerochain/props_yeastbeast/yb_firepit.mdl")
	ent:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, 0 ) ) )
	ent:Spawn()
	ent:Activate()
	ent:SetParent(self)

	self.ClientProps["Fuel"] = ent

	local newFuelLvl = (1 / zyb.config.Distillery.FuelAmount) * self:GetFuel()

	self.CurrentFuelLevel = self.CurrentFuelLevel + 0.25 * FrameTime()
	self.CurrentFuelLevel = math.Clamp(self.CurrentFuelLevel,0,newFuelLvl)

	self.ClientProps["Fuel"]:SetModelScale(self.CurrentFuelLevel)

	if newFuelLvl <= 0 then
		self.ClientProps["Fuel"]:SetNoDraw(true)
	else
		self.ClientProps["Fuel"]:SetNoDraw(false)
	end
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
	self:StopSound("zyb_steam_loop")
	self:StopSound("zyb_burning")
	self:StopSound("zyb_cooking")
	self:StopSound("zyb_overheat_loop")
	self:RemoveClientModels()
end
-- leak by lordee