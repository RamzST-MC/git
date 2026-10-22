term.Add('AdminGoneTo', '# телепортировался к #.')
term.Add('AdminRoomUnset', 'Админ комната не установлена!')
term.Add('AdminGoneToAdminRoom', '# телепортировался на Админ-базу.')
term.Add('AdminRoomSet', 'Админ-база была обозначена.')
term.Add('AdminReturnedSelf', '# вернул себя на spawn.')
term.Add('NoKnownPositionPlayer', 'У # нет последней локации!')
-------------------------------------------------
-- Tele
-------------------------------------------------
ba.cmd.Create('Tele', function(pl, args)
	for k, v in ipairs(args.targets) do
		if (not v:Alive()) then
			v:Spawn()
		end

		if v:InVehicle() then
			v:ExitVehicle()
		end

		v:SetBVar('ReturnPos', v:GetPos())

		v:SetPos(util.FindEmptyPos(pl:GetEyeTrace().HitPos))
	end

	ba.notify_staff('# телепортировал к себе ' .. ('# '):rep(#args.targets) .. '.', pl, unpack(args.targets))
end)
:AddParam('player_entity_multi', 'targets')
:SetFlag 'M'
:SetHelp 'Телепорт к себе'
:AddAlias 'tp'

-------------------------------------------------
-- Goto
-------------------------------------------------
ba.cmd.Create('Goto', function(pl, args)
	if not pl:Alive() then
		pl:Spawn()
	end
		
	if pl:InVehicle() then
		pl:ExitVehicle()
	end

	pl:SetBVar('ReturnPos', pl:GetPos())

	local pos = util.FindEmptyPos(args.target:GetPos()) 

	pl:SetPos(pos)

	ba.notify_staff(term.Get('AdminGoneTo'), pl, args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag 'M'
:SetHelp 'Телепорт к игроку'

-------------------------------------------------
-- Sit
-------------------------------------------------
if (SERVER) then
	ba.adminRoom = ba.svar.Get('adminroom') and pon.decode(ba.svar.Get('adminroom'))[1]
	ba.svar.Create('adminroom', nil, false, function(svar, old_value, new_value)
		ba.adminRoom = pon.decode(new_value)[1]
	end)
end

ba.cmd.Create('Sit', function(pl, args)
	if not ba.svar.Get('adminroom') then
		ba.notify_err(pl, term.Get('AdminRoomUnset'))
		return
	end

	if (not pl:Alive()) then
		pl:Spawn()
	end

	if pl:InVehicle() then
		pl:ExitVehicle()
	end

	pl:SetBVar('ReturnPos', pl:GetPos())
	local pos = util.FindEmptyPos(ba.adminRoom)
	pl:SetPos(pos)
	ba.notify_staff(term.Get('AdminGoneToAdminRoom'), pl)
end)
:SetFlag 'M'
:SetHelp 'Телепорт в зону админов'

-------------------------------------------------
-- Set Admin Room
-------------------------------------------------
ba.cmd.Create('SetAdminRoom', function(pl, args)
	ba.svar.Set('adminroom', pon.encode({pl:GetPos()}))
	ba.notify(pl, term.Get('AdminRoomSet'))
end)
:SetFlag('*')
:SetHelp('Установить админ зону')

-------------------------------------------------
-- Return
-------------------------------------------------
ba.cmd.Create('Return', function(pl, args)
	if (args.targets == nil) then
		if (pl:GetBVar('ReturnPos') ~= nil) then
			if not pl:Alive() then
				pl:Spawn()
			end
			
			local pos = util.FindEmptyPos(pl:GetBVar('ReturnPos'))
			pl:SetPos(pos)

			pl:SetBVar('ReturnPos', nil)

			ba.notify_staff(term.Get('AdminReturnedSelf'), pl)
		else
			ba.notify_err(pl, term.Get('NoKnownPosition'))
		end
		return
	end

	for k, v in ipairs(args.targets) do
		if (v:GetBVar('ReturnPos') == nil) then
			ba.notify_err(pl, term.Get('NoKnownPositionPlayer'), v)
			return
		end

		if not v:Alive() then
			v:Spawn()
		end
			
		if v:InVehicle() then
			v:ExitVehicle()
		end

		local pos = util.FindEmptyPos(v:GetBVar('ReturnPos'))

		v:SetPos(pos)
		v:SetBVar('ReturnPos', nil)
	end

	ba.notify_staff('# вернул ' .. ('# '):rep(#args.targets) .. ' в последнюю локацию.', pl, unpack(args.targets))
end)
:AddParam('player_entity_multi', 'targets', 'optional')
:SetFlag('M')
:SetHelp('Возращает игрока в последнюю локацию.')
:SetIcon('icon16/arrow_down.png')

-------------------------------------------------
-- Spawn
-------------------------------------------------
ba.cmd.Create('Spawn', function(pl, args)
	if (args.targets == nil) then
		if pl:InVehicle() then
			pl:ExitVehicle()
		end

		pl:Spawn()

		return ba.notify_staff('# вернул себя на спавн', pl)
	end

	for k, v in ipairs(args.targets) do
		if v:InVehicle() then
			v:ExitVehicle()
		end

		v:Spawn()
	end

	ba.notify_staff('# вернул на спавн ' .. ('#'):rep(#args.targets), pl, unpack(args.targets))
end)
:AddParam('player_entity_multi', 'targets', 'optional')
:SetFlag 'M'
:SetHelp 'Вернуть игрока на спавн'

-- Freeze
-------------------------------------------------
term.Add('AdminFrozePlayer', '# заморозил #.')
term.Add('AdminUnfrozePlayer', '# разморозил #.')
term.Add('PlayerIsFrozen', '# уже заморожен!')
term.Add('PlayerIsNotFrozen', '# не заморожен!')

if (SERVER) then
    function PLAYER:IsAdminFrozen() -- only use where it matters if an admin did it
        return (self:GetBVar('IsAdminFrozen') == true) and self:IsFrozen()
    end

    PLAYER._Freeze = PLAYER._Freeze or PLAYER.Freeze
    function PLAYER:Freeze(frozen)
        if (not frozen) then
            if self:GetBVar('PreFrozenMoveType') then
                self:SetMoveType(self:GetBVar('PreFrozenMoveType'))
                self:SetBVar('PreFrozenMoveType', nil)
            end

            if self:GetBVar('IsAdminFrozen') then
                self:SetBVar('IsAdminFrozen', nil)
            end
        end

        return self:_Freeze(frozen)
    end

    function PLAYER:AdminFreeze(pl)
        if (not self:Alive()) then
            self:Spawn()
        end

        if self:InVehicle() then
            self:ExitVehicle()
        end

        if (not self:IsFrozen()) then
            self:SetBVar('PreFrozenMoveType', self:GetMoveType())

            self:Freeze(true)
            self:SetMoveType(MOVETYPE_NOCLIP)
            self:SetBVar('IsAdminFrozen', true)

            ba.notify_staff(term.Get('AdminFrozePlayer'), pl, self)
        else
            ba.notify_err(pl, term.Get('PlayerIsFrozen'), self)
        end
    end

    function PLAYER:AdminUnFreeze(pl)
        if (not self:Alive()) then
            self:Spawn()
        end

        if self:IsFrozen() then
            self:Freeze(false)

            ba.notify_staff(term.Get('AdminUnfrozePlayer'), pl, self)
        else
            ba.notify_err(pl, term.Get('PlayerIsNotFrozen'), self)
        end
    end

    hook.Add('PhysgunPickup', 'ba.PhysgunPickup.PlayerPhysgun', function(pl, ent)
        if isplayer(ent) and pl:HasAccess('m') and ba.ranks.CanTarget(pl, ent) and ba.canAdmin(pl) then
            pl:SetBVar('HoldingPlayer', ent)

            if (not ent:IsAdminFrozen()) then
                ent:SetMoveType(MOVETYPE_NOCLIP)
                ent:Freeze(true)
            end

            return true
        end
    end)

    hook.Add('PhysgunDrop', 'ba.PhysgunDrop.PlayerPhysgun', function(pl, ent)
        if isplayer(ent) then
            if (not ent:IsAdminFrozen()) then
                ent:SetMoveType(MOVETYPE_WALK)
                ent:Freeze(false)
            end

            local hookId = 'ba.KeyRelease.PlayerPhysgun' .. pl:SteamID() .. ent:SteamID()
            hook.Add('KeyRelease', hookId, function(pl2, key)
                local holdingPlayer = pl:GetBVar('HoldingPlayer')

                if (pl == pl2) and (key == IN_ATTACK2) and IsValid(holdingPlayer) and IsValid(ent) and (holdingPlayer == ent) then
                    if ent:IsAdminFrozen() then
                        ent:AdminUnFreeze(pl)
                    else
                        ent:AdminFreeze(pl)
                    end

                    hook.Remove('KeyRelease', hookId)
                end
            end)

            timer.Simple(1, function()
                hook.Remove('KeyRelease', hookId)
            end)
        end
    end)
end

-- Команда заморозки
ba.cmd.Create('Freeze', function(pl, args)
    if not IsValid(args.target) then return end
    args.target:AdminFreeze(pl)  -- ИСПРАВЛЕНО: args.target вместо targ
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Замораживает игрока')

-- Команда разморозки
ba.cmd.Create('UnFreeze', function(pl, args)
    if not IsValid(args.target) then return end
    args.target:AdminUnFreeze(pl)  -- ИСПРАВЛЕНО: args.target вместо targ
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Размораживает игрока')

-------------------------------------------------
-- Noclip
-------------------------------------------------

local naborranks = {'downer', 'helper', 'naboradmin', 'moder', 'admin', 'superadmin', 'owner', 'subcurator', 'curator', 'root'}

hook.Add('PlayerNoClip', 'ba.PlayerNoClipAgva', function(pl)
    if (SERVER) and table.HasValue(naborranks, pl:GetRank()) or pl:Team() == TEAM_ADMIN then
        return pl:GetBVar('adminmode')
	else
		return false
    end
end)