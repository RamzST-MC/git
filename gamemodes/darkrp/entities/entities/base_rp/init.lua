dash.IncludeCL 'cl_init.lua'
dash.IncludeSH 'shared.lua'

util.AddNetworkString('rp.EntityUse')

function ENT:Use(activator, caller, usetype, value)
	if caller:IsPlayer() and ((not caller['NextUse' .. self:GetClass()]) or (caller['NextUse' .. self:GetClass()] <= CurTime())) and self:CanUse(caller) then
		self:PlayerUse(caller)
	end
end

function ENT:PlayerUse(pl)
	if self.NetworkPlayerUse then
		net.Start('rp.EntityUse')
		net.WriteEntity(self)
		net.Send(pl)
	end
end

function EntityUse(pl)
end

function ENT:CanUse(pl)
	return true
end

function ENT:NextUse(pl, time)
	pl['NextUse' .. self:GetClass()] = (CurTime() + time)
end

function ENT:OnTakeDamage(dmg)
	if self.PrintName == 'Money Printer' then return end

	if self.MaxHealth then
		self.MaxHealth = self.MaxHealth - (dmg:GetDamage() * 0.5)
		if (self.MaxHealth <= 0) then
			if self.ExplodeOnRemove then
				self:Explode()
			else
				self:Remove()
			end
			local owner = self.ItemOwner
			if IsValid(owner) then
				owner:Notify(NOTIFY_ERROR, term.Get('YourEntDestroyed'), self.PrintName)
			end
		end
	end
end

function ENT:Explode()
	local pos = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(pos)
	effectdata:SetOrigin(pos)
	effectdata:SetScale(1)
	util.Effect('Explosion', effectdata)
end

net('rp.EntityUse', function(_, pl)
	local ent = net.ReadEntity()
	local ignoreval = net.ReadBool()

	if not ignoreval and not IsValid(ent) then return end

	ent:EntityUse(pl)
end)

hook.Add('InitPostEntity', 'rp.fix.InitPostEntity', function() end)