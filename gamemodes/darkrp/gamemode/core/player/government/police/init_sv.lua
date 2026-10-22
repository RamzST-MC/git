rp.ArrestedPlayers = rp.ArrestedPlayers or {}

function PLAYER:IsWarranted()
	return (self.HasWarrant == true)
end
-----------------------------------------------------------------------------
-- Warrant
-----------------------------------------------------------------------------
function PLAYER:Warrant(actor, reason)
	if self:IsMayor() then return end
	if self == actor then return end
	if self:IsCP() then return end

	self.HasWarrant = true
	timer.Simple(rp.cfg.WarrantTime, function()
		if IsValid(self) then
			self:UnWarrant()
		end
	end)
	rp.FlashNotifyAll('Новости', term.Get('Warranted'), actor, self, reason, (IsValid(actor) and actor or 'Авто-ордер'))
	hook.Call('PlayerWarranted', GAMEMODE, self, actor, reason)
end

function PLAYER:UnWarrant(actor)
	rp.NotifyAll(1, term.Get('WarrantExpired'), self)
	self.HasWarrant = nil
	hook.Call('PlayerUnWarranted', GAMEMODE, self, actor)
end
-----------------------------------------------------------------------------
-- Cuff
-----------------------------------------------------------------------------
function PLAYER:Cuff(actor)
	if self:InVehicle() then self:ExitVehicle() end
	if self:InSpawn() then rp.Notify(actor, NOTIFY_ERROR, 'На спавне запрещено использовать наручники.') return end
	if self:IsCP() then rp.Notify(actor, NOTIFY_ERROR, 'Вы не можете надевать наручники на других копов.') return end
	if self:Team() == TEAM_ADMIN then rp.Notify(actor, NOTIFY_ERROR, 'На администратора нельзя надеть наручники.') return end
	if self:Team() == TEAM_MAYOR then rp.Notify(actor, NOTIFY_ERROR, 'На мэра нельзя надеть наручники.') return end
	-- if self:IsRoot() then return end

	self:SetNetVar('cuffed', true)
	self:SetWalkSpeed(rp.cfg.WalkSpeed / 2.5)
	self:SetRunSpeed(rp.cfg.RunSpeed / 2.5)
	self.HandcuffedWeapons = {}
	self.HandcuffedWeaponAmmo = {}
	self.HandcuffedWeaponAmmoType = {}

	local weps = self:GetWeapons()
	for i, v in ipairs(weps) do
		self.HandcuffedWeapons[i] = {v:GetClass(), v.donate}
		self.HandcuffedWeaponAmmo[v:GetPrimaryAmmoType()] = self:GetAmmoCount(v:GetPrimaryAmmoType())
	end

	self:SelectWeapon('keys')
	self:StripWeapons()

	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(20, 8.8, 0)) -- Left UpperArm
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(15, 0, 0)) -- Left ForeArm
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 75)) -- Left Hand
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(-15, 0, 0)) -- Right Forearm
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, -75)) -- Right Hand
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(-20, 16.6, 0)) -- Right Upperarm
end

function PLAYER:UnCuff(actor)
	if self:InVehicle() then self:ExitVehicle() end
	self:SwitchToDefaultWeapon()
	-- if self:IsArrested() then return end
	self:SetWalkSpeed(rp.cfg.WalkSpeed)
	self:SetRunSpeed(rp.cfg.RunSpeed)
	
	self:SetNetVar('cuffed', nil)

	for i, v in ipairs(self.HandcuffedWeapons) do
		if v[2] == true then
			self:Give(v[1], true).donate = true
		else
			self:Give(v[1], true)
		end
	end

	for k, v in pairs(self.HandcuffedWeaponAmmo) do
		self:SetAmmo(v, k)
	end

	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(0, 0, 0)) -- Left UpperArm
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(0, 0, 0)) -- Left ForeArm
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 0)) -- Left Hand
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(0, 0, 0)) -- Right Forearm
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, 0)) -- Right Hand
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(0, 0, 0)) -- Right Upperarm
end
-----------------------------------------------------------------------------
-- Wanted
-----------------------------------------------------------------------------
function PLAYER:Wanted(actor, reason)
	-- if self == actor then return end
	if self:IsMayor() then return end

	self.CanEscape = nil
	self:SetNetVar('IsWanted', true)
	self:SetNetVar('WantedReason', reason)
	timer.Create('Wanted' .. self:SteamID64(), rp.cfg.WantedTime, 1, function()
		if IsValid(self) then
			self:UnWanted()
		end
	end)
	rp.FlashNotifyAll('Новости', term.Get('Wanted'), self, reason, (IsValid(actor) and actor or 'Авто-розыск'))
	hook.Call('PlayerWanted', GAMEMODE, self, actor, reason)
end

function PLAYER:UnWanted(actor)
	self:SetNetVar('IsWanted', nil)
	self:SetNetVar('WantedReason', nil)
	timer.Destroy('Wanted' .. self:SteamID64())
	hook.Call('PlayerUnWanted', GAMEMODE, self, actor)
end
-----------------------------------------------------------------------------
-- Arrest
-----------------------------------------------------------------------------
local jails = rp.cfg.JailPos[game.GetMap()]
function PLAYER:Arrest(actor)
	local time = 180
	timer.Create('Arrested' .. self:SteamID64(), time, 1, function()
		if IsValid(self) then
			self:UnArrest()
		end
	end)

	self:SetNetVar('ArrestedInfo', {Release = CurTime() + time, Actor = actor:Name()})
	self:SetNetVar('IsArrested', true)
	-- self:UnCuff(actor)
	if self:IsWanted() then self:UnWanted() end

	rp.ArrestedPlayers[self:SteamID64()] = true

	if self:GetNetVar('IsDisguise') == true then
		self:SetNetVar('IsDisguise',false)
		self:SetModel(self.MainModel)
		self:SetNetVar('DisguiseJob', nil)
		self:SetNetVar('DisguiseTeam', nil)
		rp.Notify(self,NOTIFY_ERROR,'Ваша маскировка была снята из-за ареста.')	
	end
	if self:IsCuffed() then self:UnCuff(actor) end
	self:StripWeapons()
	self:SetHunger(100)
	self:SetHealth(100)
	self:SetArmor(0)

	rp.FlashNotifyAll('Новости', term.Get('Arrested'), self, time)
	hook.Call('PlayerArrested', GAMEMODE, self, actor)
	if IsValid(actor) then
		actor:SetPData('arrestcount', actor:GetPData('arrestcount', 0) + 1)
	end

	self:Spawn(util.FindEmptyPos(jails[math.random(#jails)]))
	self.CanEscape = true
	self:SetWalkSpeed(rp.cfg.WalkSpeed / 2.5)
	self:SetRunSpeed(rp.cfg.RunSpeed / 2.5)
end

function PLAYER:UnArrest(actor)
	self:SetNetVar('ArrestedInfo', nil)
	self:SetNetVar('IsArrested', nil)
	if self:IsCuffed() then self:UnCuff(actor) end
	timer.Remove('Arrested' .. self:SteamID64())
	rp.ArrestedPlayers[self:SteamID64()] = nil
	timer.Simple(0.3, function() -- fucks up otherwise
		local _, pos = GAMEMODE:PlayerSelectSpawn(self)
		self:Spawn(pos)
		self:SetHealth(100)
		hook.Call('PlayerLoadout', GAMEMODE, self)
		rp.FlashNotifyAll('Новости', term.Get('UnArrested'), self)
		hook.Call('PlayerUnArrested', GAMEMODE, self, actor)
	end)
end
-----------------------------------------------------------------------------
-- Commands
-----------------------------------------------------------------------------
-- rp.AddCommand('911', function(pl, message)
-- 	chat.Send('911', pl, message)
-- end)
-- :AddParam(cmd.STRING)

rp.AddCommand('want', function(pl, targ, text)
	if not pl:IsCP() and not pl:IsMayor() then return end

	if targ:IsWanted() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerAlreadyWanted'), targ)
	else
		targ:Wanted(pl, text)
	end
end)
:AddParam(cmd.PLAYER_ENTITY)
:AddParam(cmd.STRING)

rp.AddCommand('unwant', function(pl, targ, text)
	if not pl:IsCP() and not pl:IsMayor() then return end
	if not targ:IsWanted() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerNotWanted'), targ)
	else
		targ:UnWanted(pl)
	end
end)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('warrant', function(pl, targ, text)
	if not pl:IsCP() then return end

	for k, v in pairs(player.GetAll()) do

		if player.GetCount(v:IsCP()) < 2 then
			return pl:ChatPrint('Должно быть больше двух копов для взятия ордера.')
		end
	end

	if targ:IsWarranted() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerAlreadyWarranted'), targ)
	else
	    if not rp.teams[pl:Team()] or not rp.teams[pl:Team()].mayor then -- No need to search through all the teams if the player is a mayor
	        local mayors = {}

			for k,v in pairs(rp.teams) do
	            if v.mayor then
	                table.Add(mayors, team.GetPlayers(k))
	            end
	        end

			if #mayors > 0 then
				local mayor = table.Random(mayors)
				local question = pl:Name() .. ' запрашивает\nордер на обыск ' .. targ:Name() .. '\nПричина: ' .. text
				GAMEMODE.ques:Create(question, targ:EntIndex() .. 'warrant', mayors[1], 40, function(ret)
					if not tobool(ret) then
						rp.Notify(pl, NOTIFY_ERROR, 'Мэр ' .. mayor:Name() .. ' отклонил ваш запрос на ордер.')
						return
					end
					if IsValid(targ) then
						targ:Warrant(pl, text)
					end
				end, pl, targ, text)
				rp.Notify(pl, NOTIFY_SUCCESS, 'Запрос на ордер отправлен мэру ' .. mayor:Name())
				return ''
			end
		end
		if IsValid(targ) then
			targ:Warrant(pl, text)
		end
			
		return ''
	end
end)
:AddParam(cmd.PLAYER_ENTITY)
:AddParam(cmd.STRING)

rp.AddCommand('unwarrant', function(pl, targ, text)
	if not pl:IsCP() and not pl:IsMayor() then return end
	if not targ:IsWarranted() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerNotWarranted'), targ)
	else
		targ:UnWarrant(pl)
	end
end)
:AddParam(cmd.PLAYER_ENTITY)

local bounds = rp.cfg.Jails[game.GetMap()]
if bounds then
	hook('PlayerThink', function(pl)
		if IsValid(pl) and pl:IsArrested() and pl.CanEscape and (not pl:InBox(bounds[1], bounds[2])) then
			rp.ArrestedPlayers[pl:SteamID64()] = nil
			pl:SetNetVar('IsArrested', nil)
			pl:SetNetVar('ArrestedInfo', nil)
			hook.Run('UpdatePlayerSpeed', pl)
			timer.Destroy('Arrested' .. pl:SteamID64())
					
			pl:Wanted(nil, 'Побег из тюрьмы')

			hook.Call('PlayerLoadout', GAMEMODE, pl)
		end
	end)
end

hook('PlayerEntityCreated', function(pl)
	if rp.ArrestedPlayers[pl:SteamID64()] then
		pl:Arrest(nil) -- Disconnecting to avoid arrest
	end
end)

hook('PlayerDeath', function(pl, killer, dmginfo)
	if (!killer:IsPlayer()) then return end
	
	if pl:IsWanted() and killer:IsCP() and (pl ~= killer) and (killer ~= game.GetWorld()) then
		pl:UnWanted()
	end
end)

concommand.Add('arrest', function(pl)
	if !pl:IsRoot() then return end

	pl:Arrest(pl)
end)

concommand.Add('unarrest', function(pl)
	if !pl:IsRoot() then return end

	pl:UnArrest(pl)
end)

concommand.Add('cuff', function(pl)
	if !pl:IsRoot() then return end

	pl:Cuff(pl)
end)

concommand.Add('uncuff', function(pl)
	if !pl:IsRoot() then return end

	pl:UnCuff(pl)
end)

concommand.Add('warrant', function(pl)
	if !pl:IsRoot() then return end

	pl:Warrant(pl)
end)

concommand.Add('unwarrant', function(pl)
	if !pl:IsRoot() then return end

	pl:UnWarrant(pl)
end)

concommand.Add('wanted', function(pl)
	if !pl:IsRoot() then return end

	pl:Wanted(pl, 'ЧОРНЫЙ ФЕОЛЕТОВИЙ')
end)

concommand.Add('unwanted', function(pl)
	if !pl:IsRoot() then return end

	pl:UnWanted(pl, 'ЧОРНЫЙ ФЕОЛЕТОВИЙ')
end)