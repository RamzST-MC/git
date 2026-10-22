function PLAYER:Ziptie()
	self.ZiptieTime = CurTime()

	self.ZiptiedWeapons = {}
	self.ZiptiedWeaponAmmo = {}

	local weps = self:GetWeapons()
	for i, v in ipairs(weps) do
		self.ZiptiedWeapons[i] = {v:GetClass(), v.donate}
		self.ZiptiedWeaponAmmo[v:GetPrimaryAmmoType()] = self:GetAmmoCount(v:GetPrimaryAmmoType())
	end

	self:StripWeapons()

	self:Give('weapon_ziptied')
	self:SelectWeapon('weapon_ziptied')
	
	self:SetNetVar('Ziptied', true)
	self:SetNetVar('ZiptieCutting', nil)
end

function PLAYER:RemoveZiptie()
	self:SetNetVar('Ziptied', false)
	self:SetNetVar('ZiptieCarrying', nil)
	self:SetNetVar('ZiptieCarrier', nil)
	self:SetNetVar('ZiptieCutting', nil)
	self:StripWeapons()

	for i, v in ipairs(self.ZiptiedWeapons) do
		if v[2] == true then
			self:Give(v[1], true).donate = true
		else
			self:Give(v[1], true)
		end
	end

	for k, v in pairs(self.ZiptiedWeaponAmmo) do
		self:SetAmmo(v, k)
	end
	
	self:SelectWeapon('weapon_physgun')
end

function PLAYER:StopCarrying(xz, pos)
	if self.ZiptieTarget == nil then return end
	if not self:IsCarrying() then return end
	local jertva = self.ZiptieTarget
	jertva:SetPos(pos)
	self:SetNetVar('ZiptieCarrying', nil)
	jertva:SetNetVar('ZiptieCarrier', nil)
	self:SetNetVar('ZiptieCutting', nil)
	jertva:SetNetVar('ZiptieCutting', nil)
	self:StripWeapon('weapon_ziptie_carrying')
	jertva:SetNoDraw(false)
	jertva:SetCollisionGroup(COLLISION_GROUP_NONE)
	jertva:SetMoveType(MOVETYPE_WALK)

	for i, v in ipairs(self.ZiptieCarWeapons) do
		self:Give(v[1], true)
	end
end

local function GetTrace(pl)
  local tr = util.TraceLine({
    start  = pl:EyePos(),
    endpos = pl:EyePos() + (pl:GetAimVector() * 100),
    filter = pl
})

if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
  local cuffed, wep = tr.Entity:IsZiptied()
  if cuffed then return tr, wep end
end
end

hook.Add("KeyPress", "zip::binds", function(ply, key)
	if (key == IN_USE) then
		local tr = GetTrace(ply)

		if tr then
			local chel = tr.Entity

			if chel:IsPlayer() then
				if ply:IsCarrying() then return end
				chel:SetNetVar('ZiptieCutting', 1)
				ply:SetNetVar('ZiptieCutting', 1)
				ply.popitka = 0
				chel:SetNetVar('ZiptieUncuffTime', ply.popitka)
				ply:SetNetVar('ZiptieUncuffTime', ply.popitka)
				timer.Create('uncuff_'..ply:EntIndex(), 1, 10, function()
					ply.popitka = ply.popitka + 1
					if (IsValid(chel) and chel:GetPos():DistToSqr(ply:GetPos()) > 3500) or chel:IsBeingCarried() then
						-- ply:Notify(NOTIFY_ERROR, 'Слишком далеко!')
						chel:SetNetVar('ZiptieCutting', nil)
						ply:SetNetVar('ZiptieCutting', nil)
						timer.Remove('uncuff_'..ply:EntIndex())
						return
					end
					if ply.popitka == 10 then
						chel:RemoveZiptie()
						ply:SetNetVar('ZiptieCutting', nil)
					end
				end)
			end
		end
	elseif (key == IN_RELOAD) then
		local tr = GetTrace(ply)
		if tr then
			local chel = tr.Entity
			if !chel:IsZiptied() then return end
			if chel:IsBeingCarried() then return end

			if chel:IsPlayer() then
				ply:SetNetVar('ZiptieCarrying', chel)
				chel:SetNetVar('ZiptieCarrier', ply)
				ply.ZiptieTarget = chel

				ply.ZiptieCarWeapons = {}

				local weps = ply:GetWeapons()
				for i, v in ipairs(weps) do
					ply.ZiptieCarWeapons[i] = {v:GetClass()}
				end

				ply:StripWeapons()

				ply:Give('weapon_ziptie_carrying')
				ply:SelectWeapon('weapon_ziptie_carrying')
				chel:SetCollisionGroup(COLLISION_GROUP_WORLD)
				chel:SetNoDraw(true)
				chel:GodEnable()
				chel:SetMoveType(MOVETYPE_FLY)
				timer.Create('rapped'..chel:EntIndex(),.1,0,function()
					if not IsValid(chel) then
						timer.Remove('rapped' .. chel:EntIndex())
						ply:SetNetVar('ZiptieCarrying', nil)
						ply:StripWeapon('weapon_ziptie_carrying')
						return
					end
					if not chel:Alive() then
						timer.Remove('rapped' .. chel:EntIndex())
						ply:SetNetVar('ZiptieCarrying', nil)
						ply:StripWeapon('weapon_ziptie_carrying')
						return
					end
					if not ply:IsCarrying() then
						timer.Remove('rapped' .. chel:EntIndex())
						chel:SetNoDraw(false)
						chel:GodDisable()
						chel:SetCollisionGroup(COLLISION_GROUP_NONE)
						return
					end
					if not ply:Alive() then
						timer.Remove('rapped' .. chel:EntIndex())
						chel:SetNoDraw(false)
						chel:GodDisable()
						chel:SetCollisionGroup(COLLISION_GROUP_NONE)
						ply:StopCarrying(nil, ply:GetPos())
						return
					end
					chel:SetPos(ply:GetPos() + Vector(0, 0, 35))
				end)
			end
		end
	end
end)

hook.Add('PostPlayerDeath', 'zip::OnDeath', function(pl)
  if pl:IsZiptied() then
	pl:RemoveZiptie()
  end
  if pl:IsCarrying() then
	pl:StopCarrying(nil, pl:GetPos())
  end
end)

hook.Add("PlayerArrested", "zip::OnArrest", function(pl)
  if pl:IsZiptied() then
	pl:RemoveZiptie()
  end
  if pl:IsCarrying() then
	pl:StopCarrying(nil, pl:GetPos())
  end
end)

hook.Add('PlayerUnArrested', 'zip::UnArrest', function(pl)
  if pl:IsZiptied() then
		pl:RemoveZiptie()
  end
  if pl:IsCarrying() then
	pl:StopCarrying(pl:GetPos())
  end
end)

hook.Add("playerCanChangeTeam", "zip::changeteam",function(pl)
  if pl:IsZiptied() or pl:IsCarrying() then
    return false
  end
end)

hook.Add('PlayerSpawnedProp', 'zip::spawnprop', function(pl, mdl, ent)
	if pl:IsZiptied() or pl:IsCarrying() then ent:Remove() end
end)
