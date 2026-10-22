-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_yeastbeast/yb_paperbag.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Paperbag"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_OPAQUE



function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "YeastAmount")

	if (SERVER) then
		self:SetYeastAmount(0)
	end
end
-- leak by lordee