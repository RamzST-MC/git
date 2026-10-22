-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Transport Palette"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros YeastBeast"
ENT.Model = "models/props_junk/wood_pallet001a.mdl"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "CrateCount")

	if (SERVER) then
		self:SetCrateCount(0)
	end
end
-- leak by lordee