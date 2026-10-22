AddCSLuaFile("shared.lua")
include("shared.lua")

--Handle damage
function ENT:OnTakeDamage(damage)
	self:SetHealth(self:Health() - damage:GetDamage())
	if self:Health() <= 0 then
		self:Remove()
	end
end

function ENT:PhysgunPickup(pl)
	return (pl == self.ItemOwner)
end