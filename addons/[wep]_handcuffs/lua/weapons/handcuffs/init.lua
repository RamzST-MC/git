AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('rp::handcuffs_weapons')
util.AddNetworkString('cuffs::arrest')
util.AddNetworkString('cuffs::unarrest')
util.AddNetworkString('cuffs::takegun')
util.AddNetworkString('cuffs::govno')

function SWEP:SecretPrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
	local tr = self.Owner:GetEyeTraceNoCursor()
	if not tr.Entity:IsPlayer() then return end

	if self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < 150 and !tr.Entity:IsCuffed() then
		tr.Entity:Cuff(self.Owner)
		self.Owner:ConCommand('act2 melee')
	end
end

function SWEP:SecretSecondaryAttack()
	local tr = self.Owner:GetEyeTraceNoCursor()
	if not tr.Entity:IsPlayer() then return end
	if self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < 150 and tr.Entity:IsCuffed() then
		tr.Entity:UnCuff(self:GetOwner())
		self:GiveHandcuffWeaponsBack(tr.Entity)
		self:GiveHandcuffWeaponAmmoBack(tr.Entity)
		self.Owner:ConCommand('act2 melee')
	end
end

function SWEP:GiveHandcuffWeaponsBack(pl)
	for i, v in ipairs(pl.HandcuffedWeapons) do
		if v[2] == true then
			pl:Give(v[1], true).donate = true
		else
			pl:Give(v[1], true)
		end
	end
end

function SWEP:GiveHandcuffWeaponAmmoBack(pl)
	for k, v in pairs(pl.HandcuffedWeaponAmmo) do
		pl:SetAmmo(v, k)
	end
end

net.Receive('cuffs::govno', function(len, pl)
	local ent = net.ReadEntity()
	if ent:IsPlayer() and ent:Alive() and pl:GetPos():Distance(ent:GetPos()) < 100 and pl:IsCP() then
		if !ent:IsCuffed() then pl:Notify(NOTIFY_ERROR, 'Игрок не в наручниках!') return end
		if ent.HandcuffedWeapons then
			net.Start('rp::handcuffs_weapons')
			net.WriteTable(ent.HandcuffedWeapons)
			net.WriteEntity(ent)
			net.Send(pl)
		end
	end
end)

net.Receive('cuffs::arrest', function(len, pl)
	local ent = net.ReadEntity()
	local num = net.ReadInt(16)

	if num < 60 or num > 180 then return end

	-- if IsValid(ent) and pl:GetPos():Distance(ent:GetPos()) < 100 and pl:IsCP() then ent:Arrest(pl, num) end
end)

net.Receive('cuffs::unarrest', function(len, pl)
	local ent = net.ReadEntity()

	-- if IsValid(ent) and pl:GetPos():Distance(ent:GetPos()) < 100 and pl:IsCP() then ent:UnArrest(pl) end
end)

net.Receive('cuffs::takegun', function(len, pl)
	local ent = net.ReadEntity()
	local gun = net.ReadString()
	
	if IsValid(ent) and pl:GetPos():Distance(ent:GetPos()) < 100 and pl:IsCP() then
        for k, v in ipairs(ent.HandcuffedWeapons) do
            if v[1] == gun then
                table.remove(ent.HandcuffedWeapons, k)
                break
            end
        end
	end
end)

concommand.Add('daunsdox', function(pl)
	local ent = pl:GetEyeTrace().Entity
	if ent.HandcuffedWeapons then
		net.Start('rp::handcuffs_weapons')
		net.WriteTable(ent.HandcuffedWeapons)
		net.WriteEntity(ent)
		net.Send(pl)
	end
end)