-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_yeastbeast/yb_grinder.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Grinder"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Grinding")
	self:NetworkVar("Int", 0, "YeastAmount")

	if (SERVER) then
		self:SetGrinding(false)
		self:SetYeastAmount(0)
	end
end
-- leak by lordee