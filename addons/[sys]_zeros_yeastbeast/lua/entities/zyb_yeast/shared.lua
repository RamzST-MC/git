-- leak by lordee-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_yeastbeast/yb_yeast.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Yeast"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "YeastAmount")

	if (SERVER) then
		self:SetYeastAmount(zyb.config.YeastBlock.Amount)
	end
end
-- leak by lordee