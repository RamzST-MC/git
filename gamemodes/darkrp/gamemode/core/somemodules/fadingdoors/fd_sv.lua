function ENTITY:Fade()
	self.Faded = true
	self.FadedMaterial = self:GetMaterial()
	self.fCollision = self:GetCollisionGroup()

	self:SetMaterial("sprites/heatwave")
	self:DrawShadow(false)
	self:SetNotSolid(true)

	local obj = self:GetPhysicsObject()
	if (IsValid(obj)) then
		self.FadedMotion = obj:IsMoveable()
		obj:EnableMotion(false)
	end
end

function ENTITY:UnFade()
	if (!self:IsValid()) then return end
	self.Faded = nil

	self:SetMaterial(self.FadedMaterial or "")
	self:DrawShadow(true)
	self:SetNotSolid(false)

	local obj = self:GetPhysicsObject()
	if (IsValid(obj)) then
		obj:EnableMotion(false)
	end
end