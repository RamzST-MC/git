
include("shared.lua")


function ENT:DrawButtons()
	cam.Start3D2D(self:LocalToWorld(Vector(0, 11, 5.4)), self:LocalToWorldAngles(Angle(0,180,90)), 0.05)

		if zyb.config.NPC.SellMode == 2 then
			local atext = zyb.language.General["Collect"]
			local aSize = 35 * string.len(atext)

			if self:OnCollectButton(LocalPlayer()) then
				draw.RoundedBox(20, -aSize / 2 , -120, aSize, 100,  zyb.default_colors["orange01"])
			else
				draw.RoundedBox(20, -aSize / 2 , -120, aSize, 100, zyb.default_colors["grey02"])
			end

			draw.SimpleText(atext, "zyb_jarcrate_font01", 0, -105, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local btext = zyb.language.General["Extract"]
		local bSize = 35 * string.len(btext)

		if self:OnExtractButton(LocalPlayer()) then
			draw.RoundedBox(20, -bSize / 2, -5, bSize, 100,  zyb.default_colors["orange01"])
		else
			draw.RoundedBox(20, -bSize / 2 , -5, bSize, 100, zyb.default_colors["grey02"])
		end

		draw.SimpleText(btext, "zyb_jarcrate_font01", 0, 10, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	if self.JarCount > 0 and zyb.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:DrawButtons()
	end
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
	ent:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
	ent:SetModel("models/zerochain/props_yeastbeast/yb_jar.mdl")
	ent:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
	ent:Spawn()
	ent:Activate()
	ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	ent:SetParent(self)
	ent:SetBodygroup(1, 1)
	ent:SetBodygroup(2, 5)

	if pos == 1 then
		ent:SetPos(self:LocalToWorld(Vector(10, 5, 1)))
	elseif pos == 2 then
		ent:SetPos(self:LocalToWorld(Vector(0, 5, 1)))
	elseif pos == 3 then
		ent:SetPos(self:LocalToWorld(Vector(-10, 5, 1)))
	elseif pos == 4 then
		ent:SetPos(self:LocalToWorld(Vector(10, -5, 1)))
	elseif pos == 5 then
		ent:SetPos(self:LocalToWorld(Vector(0, -5, 1)))
	elseif pos == 6 then
		ent:SetPos(self:LocalToWorld(Vector(-10, -5, 1)))
	end

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