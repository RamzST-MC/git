term.Add('AdminKickedPlayer', '# кикнул #. Причина: #.')
term.Add('AdminBannedPlayer', '# забанил # на #. Причина: #.')
term.Add('AdminUpdatedBan', '# перебанил # на #. Причина: #.')
term.Add('PlayerAlreadyBanned', 'Этот игрок уже забанен. Вам нужен флаг "S" чтобы перебанить игрока.')
term.Add('BanNeedsPermission', 'Вам необходимо указать сотрудника, который дал вам разрешение на перманентный бан. Добавьте perm:(имя) к вашей причине.')
term.Add('AdminPermadPlayer', '# перманентно забанил #. Причина: #.')
term.Add('AdminUpdatedBanPerma', '# перебанил # на перманент. Причина: #.')
term.Add('PlayerAlreadyPermad', 'Этот игрок уже забанен! Вам нужен флаг "D" чтобы забанить игрока на перманент.')
term.Add('AdminUnbannedPlayer', '# разбанил #. Причина: #.')
term.Add('MaxBanReached', 'Ваша привилегия не позволяет банить больше чем на #')

ba.cmd.Create('Kick', function(pl, args)
	local kickTimeLast = pl.kickTimeLast or 0  -- Используем локальную переменную
	if (CurTime() > kickTimeLast + 30 or pl:IsRoot()) then 
		ba.notify_all(term.Get('AdminKickedPlayer'), pl, args.target, args.reason)
		hook.Call('BA_PlayerKicked', nil, pl, args.target, args.reason)
		args.target:Kick(args.reason)
		pl.kickTimeLast = CurTime()  -- Сохраняем время (если это работает)
	else
		ba.notify_err(pl, "Подождите еще " .. string.FormattedTime(30 - math.abs(kickTimeLast - CurTime()), "%02i:%02i:%02i") .. " сек перед следующим киком.")
	end
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'reason')
:SetFlag 'M'
:SetHelp 'Кикнуть'
-------------------------------------------------
-- Ban
-------------------------------------------------
ba.cmd.Create('Ban', function(pl, args)
	if pl:IsPlayer() then
		local banned, info = ba.IsBanned(ba.InfoTo64(args.target))

		pl.lastTimeUsed = pl.lastTimeUsed or 0

		local tbl = pl:GetRankTable()
		local maxBan = tbl[ "MaxBan" ]
		if maxBan and args.time and table.Count( maxBan ) > 1 then
			if args.time > maxBan[ 1 ] then
				ba.notify_err(pl, term.Get('MaxBanReached'), maxBan[ 2 ])
				return
			end
		end

		if ( CurTime() > pl.lastTimeUsed + 30 or pl:IsRoot() or pl:HasAccess("S") ) then 
			if not banned then
				ba.Ban(args.target, args.reason, args.time, pl, function()
					ba.notify_all(term.Get('AdminBannedPlayer'), pl, args.target, args.raw.time, args.reason)
				end)

			elseif banned and (not isplayer(pl) or pl:HasAccess('S')) then
				if info.unban_time == 0 and !pl:HasAccess('*') then 
					ba.Ban(pl, "Ахуел? Нельзя перебанивать с пермы "..args.target, 0)
				else
					ba.UpdateBan(ba.InfoTo64(args.target), args.reason, args.time, pl, function()
						ba.notify_all(term.Get('AdminUpdatedBan'), pl, args.target, args.raw.time, args.reason)
						hook.Call('BA_PlayerBanned', nil, pl, args.target, args.raw.time, args.reason)
					end)
				end
			else
				ba.notify_err(pl, term.Get('PlayerAlreadyBanned'))
			end
			pl.lastTimeUsed = CurTime()
		else
			ba.notify_err(pl,"Подождите еще "..string.FormattedTime(30-math.abs( pl.lastTimeUsed - CurTime() ),"%02i:%02i:%02i").." сек перед следующим баном.")
		end
	else
		if not banned then
			ba.Ban(args.target, args.reason, args.time, pl, function()
				ba.notify_all(term.Get('AdminBannedPlayer'), pl, args.target, args.raw.time, args.reason)
				hook.Call('BA_PlayerBanned', nil, pl, args.target, args.raw.time, args.reason)
			end)
		elseif banned and (not isplayer(pl) or pl:HasAccess('S')) then
			ba.UpdateBan(ba.InfoTo64(args.target), args.reason, args.time, pl, function()
				ba.notify_all(term.Get('AdminUpdatedBan'), pl, args.target, args.raw.time, args.reason)
				hook.Call('BA_PlayerBanned', nil, pl, args.target, args.raw.time, args.reason)
			end)
		else
			ba.notify_err(pl, term.Get('PlayerAlreadyBanned'))
		end
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('time', 'time')
:AddParam('string', 'reason')
:SetFlag 'M'
:SetHelp 'Забанить'

-------------------------------------------------
-- Perma
-------------------------------------------------
ba.cmd.Create('Perma', function(pl, args)
	local banned, _ = ba.IsBanned(ba.InfoTo64(args.target))
	if not banned then
		ba.Ban(args.target, args.reason, 0, pl, function()
			ba.notify_all(term.Get('AdminPermadPlayer'), pl, args.target, args.reason)
			hook.Call('BA_PlayerPermaBanned', nil, pl, args.target, args.reason)
		end)
	elseif banned and (not isplayer(pl) or pl:HasAccess('S')) then
		ba.UpdateBan(ba.InfoTo64(args.target), args.reason, 0, pl, function()
			ba.notify_all(term.Get('AdminUpdatedBanPerma'), pl, args.target, args.reason)
			hook.Call('BA_PlayerPermaBanned', nil, pl, args.target, args.reason)
		end)
	else
		ba.notify_err(pl, term.Get('PlayerAlreadyPermad'))
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'reason')
:SetFlag '*'
:SetHelp 'Забанить навсегда'

-------------------------------------------------
-- Unban
-------------------------------------------------
ba.cmd.Create('Unban', function(pl, args)
	-- Исправлено: было pl == args.steamid, теперь корректное сравнение SteamID
	if pl:IsPlayer() and not pl:IsRoot() and pl:SteamID() == args.steamid then return end

	local steamid64 = ba.InfoTo64(args.steamid)

	-- ПРОВЕРКА: Заблокирован ли игрок
	-- ВАЖНО: Если в вашем фреймворке функция проверки называется иначе 
	-- (например, ba.GetBanInfo, ba.CheckBan или стандартная util.IsSteamIDBanned), 
	-- замените ba.IsBanned на актуальную функцию.
	if not ba.IsBanned(steamid64) then 
		local msg = "Игрок не заблокирован"
		
		-- Вывод сообщения игроку или в консоль
		if IsValid(pl) then
			pl:ChatPrint(msg) -- Если в вашем моде есть кастомный чат (например, ba.notify(pl, msg)), используйте его
		else
			MsgC(Color(255, 255, 255), msg .. "\n")
		end
		
		return -- Прерываем выполнение, чтобы не вызывать ba.Unban
	end

	-- Если игрок заблокирован, выполняем стандартный разбан
	ba.Unban(steamid64, args.reason .. ' [' .. (IsValid(pl) and pl:SteamID() or 'Console') .. ']', function()
		ba.notify_all(term.Get('AdminUnbannedPlayer'), pl, args.steamid, args.reason)
		hook.Call('BA_PlayerUnbanned', nil, pl, args.steamid, args.reason)

		hook.Call('ba.SendUnBanInfo', nil, pl, args )
	end)
end)
:AddParam('player_steamid', 'steamid')
:AddParam('string', 'reason')
:SetFlag 'l'
:SetHelp 'Разбанить'