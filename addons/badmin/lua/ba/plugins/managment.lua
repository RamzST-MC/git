-------------------------------------------------
-- Mute
-------------------------------------------------
term.Add('AdminMutedPlayer', '# дал мут # на #. Причина: #')
term.Add('AdminMutedYou', '# дал вам мут на #. Причина: #')
term.Add('AdminUnmutedYou', '# с вас был снят мут.')
term.Add('AdminUnmutedPlayer', '# снял мут с #.')
term.Add('YouAreUnmuted', 'С вас сняли мут.')
term.Add('PlayerAlreadyMuted', '# на нем уже есть мут!')
term.Add('PlayerNotMuted', '# не имеет мута!')
term.Add('AdminAddedYourMoney', '# начислил $# на ваш кошелёк.')
term.Add('AdminAddedMoney', 'Вы начислили $# на кошелёк #.')

ba.cmd.Create('Mute', function(pl, args)
	pl:ChatPrint('Используйте команды Mutevoice или Mutechat!')
end)
:SetFlag '*'
:SetHelp 'Замутить чат/голос'

ba.cmd.Create('UnMute', function(pl, args)
	if (args.target:IsChatMuted() or args.target:IsVoiceMuted()) then
		args.target:UnChatMute()
		args.target:UnVoiceMute()
		hook.Call('BA_PlayerChatUnmuted', nil, pl, args.target)
		hook.Call('BA_PlayerVoiceUnmuted', nil, pl, args.target)
		ba.notify(args.target, term.Get('AdminUnmutedYou'), pl)
		return ba.notify_staff(term.Get('AdminUnmutedPlayer'), pl, args.target)
	end
	return ba.notify_err(pl, term.Get('PlayerNotMuted'), args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag 'M'
:SetHelp 'Размутить чат/голос'

-------------------------------------------------
-- Mute Chat
-------------------------------------------------
term.Add('AdminUnmutedPlayerChat', '# снял мут чата с #.')
term.Add('AdminUnmutedYouChat', '# снял с вас мут чата.')
term.Add('YouAreUnmutedChat', 'С вас сняли мут чата.')
term.Add('AdminMutedPlayerChat', '# дал мут чата # на # по причине #.')
term.Add('AdminMutedYouChat', '# дал вам мут чата на # по причине #.')

ba.cmd.Create('MuteChat', function(pl, args)
	if (not args.target:IsChatMuted()) then
		args.target:ChatMute(args.time, function()
			ba.notify(args.target, term.Get('YouAreUnmutedChat'))
		end)

		ba.notify(args.target, term.Get('AdminMutedYouChat'), pl, args.raw.time, args.reason)
		hook.Call('BA_PlayerChatMuted', nil, pl, args.target, args.raw.time, args.reason)
		return ba.notify_staff(term.Get('AdminMutedPlayerChat'), pl, args.target, args.raw.time, args.reason)
	end
	return ba.notify_err(pl, term.Get('PlayerAlreadyMuted'), args.target)
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time')
:AddParam('string', 'reason')
:SetFlag 'M'
:SetHelp 'Замутить чат'

ba.cmd.Create('UnMuteChat', function(pl, args)
	if args.target:IsChatMuted() and not CustomCheck then
		args.target:UnChatMute()
		hook.Call('BA_PlayerChatUnmuted', nil, pl, args.target)
		ba.notify(args.target, term.Get('AdminUnmutedYouChat'), pl)
		return ba.notify_staff(term.Get('AdminUnmutedPlayerChat'), pl, args.target)
	end
	return ba.notify_err(pl, term.Get('PlayerNotMuted'), args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag 'M'
:SetHelp 'Размутить чат'

-------------------------------------------------
-- Mute Voice
-------------------------------------------------
term.Add('AdminUnmutedPlayerVoice', '# снял мут голосового чата с #.')
term.Add('AdminUnmutedYouVoice', '# снял с вас мут голосового чата.')
term.Add('YouAreUnmutedVoice', 'С вас сняли мут голосового чата.')
term.Add('AdminMutedPlayerVoice', '# дал мут голосового чата # на # по причине #.')
term.Add('AdminMutedYouVoice', '# дал вам мут голосового чата на # по причине #.')

ba.cmd.Create('MuteVoice', function(pl, args)
	if (not args.target:IsVoiceMuted()) then
		args.target:VoiceMute(args.time, function()
			ba.notify(args.target, term.Get('YouAreUnmutedVoice'))
		end)
		ba.notify(args.target, term.Get('AdminMutedYouVoice'), pl, args.raw.time, args.reason)
		hook.Call('BA_PlayerVoiceMuted', nil, pl, args.target, args.raw.time, args.reason)
		return ba.notify_staff(term.Get('AdminMutedPlayerVoice'), pl, args.target, args.raw.time, args.reason)
	end
	return ba.notify_err(pl, term.Get('PlayerAlreadyMuted'), args.target)
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time')
:AddParam('string', 'reason')
:SetFlag 'M'
:SetHelp 'Замутить голосовой'

ba.cmd.Create('UnMuteVoice', function(pl, args)
	if args.target:IsVoiceMuted() then
		args.target:UnVoiceMute()
		hook.Call('BA_PlayerVoiceUnmuted', nil, pl, args.target)
		ba.notify(args.target, term.Get('AdminUnmutedYouVoice'), pl)
		return ba.notify_staff(term.Get('AdminUnmutedPlayerVoice'), pl, args.target)
	end
	return ba.notify_err(pl, term.Get('PlayerNotMuted'), args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag 'M'
:SetHelp 'Размутить голосовой'

ba.cmd.Create('zatichka', function(pl, args)
	local daun = pl:GetEyeTrace().Entity
	if !IsValid(daun) or not daun:IsPlayer() then return end
	daun:VoiceMute('1mi')
	ba.notify(daun, 'Вы были замучены на 1 минуту затычкой')
end)
:SetFlag '*'
:SetHelp 'Замутить голосовой'

-------------------------------------------------
-- Spectate
-------------------------------------------------
term.Add('AdminIsSpectating', '# в настоящее время наблюдает за кем-то!')
term.Add('SpectateTargInvalid', 'Необходимо выбрать действительную цель!')

local specPlayers = {}
local handleSpectate;

ba.cmd.Create('Spectate', function(pl, args)
	if (not pl:Alive()) then
		pl:Spawn()
	end

	if pl:InVehicle() then
		pl:ExitVehicle()
	end

	if pl == args.target then return end

	if (args.target ~= nil) and args.target:GetBVar('Spectating') then
		ba.notify_err(pl, term.Get('AdminIsSpectating'), args.target)
	elseif (args.target ~= nil) then
		if (!pl:GetBVar('Spectating')) then
			pl:SetBVar('PreSpectatePos', pl:GetPos())
			local preSpecWeapons = {}

			for _, wep in ipairs(pl:GetWeapons()) do
				preSpecWeapons[#preSpecWeapons + 1] = wep:GetClass()
			end
			pl:SetBVar('PreSpectateWeapons', preSpecWeapons)

			pl:StripWeapons()
			pl:Flashlight(false)
			pl:Spectate(OBS_MODE_IN_EYE)
			
			pl:SetBVar('Spectating', true)
			pl:SetNetVar('Spectating', true)
			
			specPlayers[#specPlayers + 1] = {pl = pl, targ = args.target}
		else
			local patchedtable = false
			for k, v in ipairs(specPlayers) do
				if (v.pl == pl) then
					v.targ = args.target
					patchedtable = true
					break
				end
			end
			
			if (!patchedtable) then
				ErrorNoHalt("Couldn't find the admin's spectate table. This SHOULD NOT HAPPEN.")
				ba.notify_err(pl, "Случилось что-то необычное. Попробуй еще раз.")
				pl:SetBVar('Spectating', nil)
				return
			end
		end
		
		pl:SpectateEntity(args.target)
	elseif pl:GetBVar('Spectating') then
		pl:SetBVar('Spectating', nil)
	else
		ba.notify_err(pl, term.Get('SpectateTargInvalid'))
	end
end)
:AddParam('player_entity', 'target', 'optional')
:SetFlag('A')
:SetHelp('Следить')
:AddAlias('spec')

hook.Add('PlayerDeath', 'UnSpectateAdmin', function(pl)
	if pl:GetBVar('Spectating') then
		pl:SetBVar('Spectating', nil)
	end
end)

if (CLIENT) then
	hook.Add('HUDShouldDraw', 'ba.HUDShouldDraw', function(name, pl)
		if (name == 'PlayerDisplay') and IsValid(pl) and pl:GetNetVar('Spectating') then return false end -- Use this for your gamemode or whatever.
	end)
else
	handleSpectate = function()
		for i=#specPlayers, 1, -1 do
			local v = specPlayers[i]
			if not v.pl:IsValid() or not v.targ:IsValid() or not v.pl:GetBVar('Spectating') then
				table.remove(specPlayers, i)
				if not v.pl:IsValid() then return end

				local pos = util.FindEmptyPos(v.pl:GetBVar('PreSpectatePos'))
				
				v.pl:SetNetVar('Spectating', nil)
				v.pl:SetBVar('Spectating', nil)
				v.pl:UnSpectate()
				v.pl:Spawn()
				v.pl:SetPos(pos)

				for _, wep in ipairs(v.pl:GetBVar('PreSpectateWeps') or {}) do
					v.pl:Give(wep)
				end
				continue
			end
			v.pl:SetPos(v.targ:EyePos())
		end
	end
	hook.Add('Think', 'ba.HandleSpectate', handleSpectate)
	hook.Add("canChangeJob","ba.Spectate", function( ply )
		if ply:GetBVar('Spectating') then
			return false
		end
	end)
end

nw.Register 'Spectating'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

	-----------------------------------------------
-- Add Money
-----------------------------------------------

ba.cmd.Create('Add Money', function(pl, args)
	args.target:AddMoney(tonumber(args.amount), 'Администратор ' .. pl:SteamID64() .. ' выдал деньги')
	ba.notify(args.target, term.Get('AdminAddedYourMoney'), pl, args.amount)
	ba.notify(pl, term.Get('AdminAddedMoney'), args.amount, args.target)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'amount')
:SetFlag '*'
:SetHelp 'Выдать деньги'

ba.cmd.Create('Set Money', function(pl, args)
	rp.data.SetMoney(args.target, tonumber(args.amount))
	args.target:SetNetVar('Money', tonumber(args.amount))
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'amount')
:SetFlag '*'
:SetHelp 'Установить деньги'

local function addTime(pl, amount, cback)
local db = rp._Stats
	db:Query('SELECT * FROM `ba_users` WHERE steamid="'..pl:SteamID64()..'";', function(_data)
		local data = _data[1] or {}
		local total = amount * 60 + data.playtime
		db:Query("UPDATE `ba_users` SET `playtime`="..total.." WHERE steamid="..pl:SteamID64()..";")
		pl:SetNetVar('PlayTime', total)	
	end)
end

ba.cmd.Create('Add PlayTimes', function(pl, args)
	addTime(args.target, tonumber(args.amount))
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'amount')
:SetFlag('*')
:SetHelp('Добавляет время в Минутах')

concommand.Add("addplaytime", function(pl, args)
	if pl:GetUserGroup() == "root" then
		addTime(pl, tonumber(args[1]))
	end
end)
