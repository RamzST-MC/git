dash.IncludeCL 'cl_init.lua'
dash.IncludeSH 'shared.lua'

util.AddNetworkString('rp.ItemLabCraft')
util.AddNetworkString('rp.ItemLabRefill')
util.AddNetworkString('rp.ItemLabRepeating')

function ENT:Initialize()
	self:SetModel(self.MainModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:PhysWake()

	self:SetMetal(3)
	self:SetHealth(200)
end

function ENT:StartCraft(index)
	local metal = self:GetMetal()
	local tb = self:GetCraftables()
	local shipID = rp.ShipmentMap[tb[index].Class]
	local ship = rp.shipments[shipID]
	local priceSep = ship.pricesep
	self:SetCraftID(index)
	self:SetCraftTime(CurTime() + self:GetCraftingTime(pl, priceSep))
	self:SetMetal(metal-1)
	timer.Create(self:EntIndex().. 'Craft', self:GetCraftingTime(pl, priceSep), 0, function()
		if !IsValid(self) then timer.Destroy(self:EntIndex() .. 'Craft') return end
		self:EndCraft(index)
	end)
end

function ENT:EndCraft(index)
	timer.Destroy(self:EntIndex() .. 'Craft')
	self:SetCraftTime(0)

	local metal = self:GetMetal()
	if self:GetRepeating() and metal > 0 then
		timer.Simple(.1, function()
			self:StartCraft(index)
		end)
	end

	self:EmitSound('physics/wood/wood_crate_break3.wav')

	local weapon = ents.Create('spawned_weapon')

	local weaponAng = self:GetAngles()
	local weaponPos = self:GetAngles():Up() * 45

	local tb = self:GetCraftables()
	local contents = rp.ShipmentMap[tb[index].Class]
	local class = rp.shipments[contents].entity
	local model = rp.shipments[contents].model

	weapon.weaponclass = class
	weapon:SetModel(model)
	weapon.ammoadd = (weapons.Get(class) and weapons.Get(class).Primary.DefaultClip)
	weapon:SetPos(self:GetPos() + weaponPos)
	weapon:SetAngles(weaponAng)
	weapon:Spawn()
	weapon.number = contents
end

net('rp.ItemLabCraft', function(_, pl)
	local ent = net.ReadEntity()
	local index = net.ReadUInt(10)
	local plishere = false
	for k, v in ipairs(ents.FindInSphere(ent:GetPos(), 200)) do
		if v:IsPlayer() and v == pl then
			plishere = true
		end
	end
	if !plishere then return end
	local metal = ent:GetMetal()
	if metal < 1 then return end
	local tb = ent:GetCraftables()
	local shipID = rp.ShipmentMap[tb[index].Class]
	local ship = rp.shipments[shipID]
	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('ItemLabCrafting'), 1, ship.name)
	ent:StartCraft(index)
end)

net.Receive('rp.ItemLabRefill', function(_, pl)
	local ent = net.ReadEntity()
	local metal = 3 - ent:GetMetal()
	local money = ent.MetalPrice * metal
	if !pl:CanAfford(money) then return rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAfford')) end
	ent:SetMetal(3)
	pl:TakeMoney(money)
	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('ItemLabRefilled'), money, 3)
end)

net('rp.ItemLabRepeating', function(_, pl)
	local ent = net.ReadEntity()
	local bool = net.ReadBool()
	ent:SetRepeating(bool)
end)

function ENT:OnTakeDamage(damageData)
	self:SetHealth(self:Health() - damageData:GetDamage())

	if (self:Health() <= 0) then
		self:Explode()
	end
end

function ENT:Explode()
	timer.Destroy(self:EntIndex().. 'Craft')
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect('Explosion', effectdata)

	self:Remove()
end