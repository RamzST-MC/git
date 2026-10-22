-- leak by lordee
ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Moonshine Buyer"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros YeastBeast"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Price")
	if (SERVER) then
		self:SetPrice(1)
	end
end
-- leak by lordee