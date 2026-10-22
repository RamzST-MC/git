-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_yeastbeast/yb_distillery_heater.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Distillery"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Cooler")
	self:NetworkVar("Entity", 1, "Condenser")
	self:NetworkVar("Int", 1, "YeastStew")
	self:NetworkVar("Int", 2, "PressureLevel")
	self:NetworkVar("Int", 3, "Fuel")

	self:NetworkVar("Bool", 0, "Depressuring")

	if (SERVER) then
		self:SetYeastStew(0)
		self:SetPressureLevel(0)
		self:SetFuel(0)
		self:SetDepressuring(false)
	end
end


function ENT:OnPressureValve(ply)
	local trace = ply:GetEyeTrace()

	if zyb.f.InDistance(self:LocalToWorld(Vector(0, -30, 103)), trace.HitPos, 15) then
		return true
	else
		return false
	end
end
-- leak by lordee