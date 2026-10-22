ba.banneds = ba.banneds or {}
local db = ba.data.GetDB()
hook.Remove('PlayerSay', 'ba.cmd.PlayerSay')
local function banPlayer(pl)
	if isplayer(pl) and IsValid(pl) then
		pl:SetNetVar('IsBanned', true)
		pl:ChangeTeam(TEAM_BANNED, true)
		pl:SetBVar('VoiceMuted', true)
		pl:SetBVar('ChatMuted', true)
		pl:Freeze(false)
		pl:Spawn()
		pl:GodEnable()
	end
end


hook.Add('OnPlayerBan', 'rp.OnPlayerBan', function(pl,reason,a_name,a_steamid, ban_time,ban_len)
	if isplayer(pl) and IsValid(pl) then
		pl:SetBVar('adminmode', false)
		pl:DoorUnOwnAll()
		for k, v in ipairs(ents.GetAll()) do
			if IsValid(v) and (v:CPPIGetOwner() == pl or v.ItemOwner == pl) then
				v:Remove()
			end
		end

		banPlayer(pl,reason,a_name,a_steamid, ban_time,ban_len)
	end
end)

hook.Add('OnPlayerUnban', 'rp.OnPlayerUnban', function(steamid)
	local pl = player.Find(steamid)
	if isplayer(pl) and IsValid(pl) then
		pl:SetNetVar('IsBanned', nil)
		pl:SetNetVar('ReasonBan', nil)
		pl:SetNetVar('AdminBan', nil)
		pl:SetNetVar('TimeBanned', nil)
		pl:SetNetVar('AdminSteamID', nil)
		pl:ChangeTeam(1, true)
		pl:SetBVar('VoiceMuted', false)
		pl:SetBVar('ChatMuted', false)
		pl:GodDisable()
	end
end)

hook.Add('KickOnPlayerBan', 'rp.KickOnPlayerBan', function(pl, reason, time, admin)
	return (time == 0)
end)

hook.Add('playerCanRunCommand', 'rp.playerCanRunCommand', function(pl, cmd)
	if pl:IsBanned() and (cmd ~= 'motd') and (cmd ~= 'smotd') then
		return false, 'You cannot use commands while banned!'
	end
end)

local msg = [[
Вы забанены!
-------------------------------------
Дата бана: %s
Дата разбана: %s
Админ: %s
Причина: %s
-------------------------------------
Купить разбан: https://discord.gg/CGH6ax4n
]]

function ba.bans.CheckPassword(steamid, ip, pass, cl_pass, name)
	local banned, data = ba.IsBanned(steamid)
	ba.banneds[steamid] = banned
	if banned and (data.unban_time == 0) then
		local banDate = os.date('%m/%d/%y - %H:%M', data.ban_time)
		local unbanDate = ((data.unban_time == 0) and 'Never' or os.date('%m/%d/%y - %H:%M', data.unban_time))
		local admin = data.a_name .. '(' .. util.SteamIDFrom64(data.a_steamid) .. ')'

		print('В пермаче ', steamid)
		return false, string.format(msg, banDate, unbanDate, admin, data.reason) 
	end
end
hook.Add('CheckPassword', 'ba.Bans.CheckPassword', ba.bans.CheckPassword)

hook.Add('PlayerEntityCreated', 'rp.checkbans', function(pl)
	if ba.banneds[pl:SteamID64()] then
		banPlayer(pl)
	end
end)

hook.Add('CanPlayerEnterVehicle', 'Banned_PlayerEnteredVehicle', function(pl)
	if pl:IsBanned() then
		return false
	end
end)

hook.Add('PlayerCanUseAdminChat', 'banned.PlayerCanUseAdminChat', function(pl)
	if pl:IsBanned() then
		return false
	end
end)

hook.Add('PlayerAdminCheck', 'banned.PlayerIsAdmin', function(pl)
	if pl:GetRankTable():IsAdmin() and !pl:IsRoot() then
		return !pl:IsBanned()
	end
end)