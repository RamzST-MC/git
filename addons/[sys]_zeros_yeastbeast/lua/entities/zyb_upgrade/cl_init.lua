-- leak by lordee
include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:DrawUpgradeInfo()
		self:DrawUpgradeTypeInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	self.u_Id = 0
	self.u_val = "+25%"
	self.u_dirty = false
end

function ENT:Think()
	if zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		local u_id = self:GetUpgradeID()
		local isDirty = self:GetIsDirty()

		if u_id > 0 and (u_id ~= self.u_Id or isDirty ~= self.u_dirty) then
			self.u_Id = u_id
			self.u_dirty = isDirty


			local u_Data = zyb.config.Upgrades[self.u_Id]
			self.u_type = u_Data.u_type

			local boostAmount = 100 * u_Data.u_amount

			if isDirty then
				boostAmount = boostAmount / 2
			end

			if u_Data.u_type == 1 then
				self.u_val = "+" .. boostAmount .. "%"
			elseif u_Data.u_type == 2 then
				self.u_val = "+" .. boostAmount .. "%"
			end
		end
	else
		self.u_Id = -1
	end

end

function ENT:DrawUpgradeInfo()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetUp(),90)
	ang:RotateAroundAxis(self:GetRight(),-90)

	cam.Start3D2D(self:LocalToWorld(Vector(3.9, 0, 0)), ang, 0.05)

		surface.SetDrawColor(zyb.default_colors["black04"])
		surface.SetMaterial(zyb.default_materials["circle"])
		surface.DrawTexturedRect(-50,-50, 100, 100)
		draw.NoTexture()

		if self.u_dirty then
			draw.SimpleText(self.u_val, "zyb_upgrade_font01", 0, -20, zyb.default_colors["red05"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		else
			draw.SimpleText(self.u_val, "zyb_upgrade_font01", 0, -20, zyb.default_colors["white03"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		surface.SetDrawColor(zyb.default_colors["black04"])
		surface.SetMaterial(zyb.default_materials["shadowcircle"])
		surface.DrawTexturedRect(-43,-43, 86, 86)
		draw.NoTexture()

		surface.SetDrawColor(zyb.default_colors["white02"])
		surface.SetMaterial(zyb.default_materials["glamcircle"])
		surface.DrawTexturedRect(-43,-43, 86, 86)
		draw.NoTexture()

	cam.End3D2D()
end

function ENT:DrawUpgradeTypeInfo()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetUp(),90)
	ang:RotateAroundAxis(self:GetRight(),-90)
	ang:RotateAroundAxis(self:GetUp(),90)
	cam.Start3D2D(self:LocalToWorld(Vector(0, 4, 0)), ang, 0.05)


		if self.u_type == 1 then
			surface.SetDrawColor(zyb.default_colors["white03"])
			surface.SetMaterial(zyb.default_materials["speedboost"])
			surface.DrawTexturedRect(-60, -60, 120, 120)
			draw.NoTexture()

		elseif self.u_type == 2 then
			surface.SetDrawColor(zyb.default_colors["white03"])
			surface.SetMaterial(zyb.default_materials["productionboost"])
			surface.DrawTexturedRect(-60, -60, 120, 120)
			draw.NoTexture()
		end

	cam.End3D2D()
end
-- leak by lordee