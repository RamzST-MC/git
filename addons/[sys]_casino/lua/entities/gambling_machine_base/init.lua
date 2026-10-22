dash.IncludeCL 'cl_init.lua'
dash.IncludeSH 'shared.lua'

util.AddNetworkString("rp.gambling.Loss")
util.AddNetworkString("rp.CasinoOwner")
util.AddNetworkString("rp.gambling.Profit")

function ENT:Initialize()
	self:SetModel('models/sup/gamblingmachine/machine.mdl')

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:Setprice(self.MinPrice)
	self:SetInService(false)

	--	self:EnableMotion(false)

	self:SetInService(false)
	self:SetIsPayingOut(false)
	self:Setprice(500)
	self:SetHealth(150)
end

--[[function ENT:OnTakeDamage(dmg)
    self:SetHealth(self:Health() - dmg:GetDamage())
	if self:Health() <= 0 then
		self:Destruct()
	end
end]]

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())

	if (self:Health() <= 0) then
		self:Explode()
		self:Remove()
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)

	if IsValid(self:Getowning_ent()) then
		rp.Notify(self:Getowning_ent(), NOTIFY_ERROR, term.Get('PrinterExploded'))
	end
end

function ENT:PhysgunPickup(pl)
	return (pl == self.ItemOwner or ba.canAdmin(pl))
end