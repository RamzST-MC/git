timer.Simple(2,function()
util.AddNetworkString('ba.RunCommand')

-- Команды доступные только в TEAM_ADMIN (или curator рангах / whitelist SteamID)
ADMIN_ONLY_COMMANDS = {
	['ban']              = true,
	['perma']            = true,
	['updateban']        = true,
	['unban']            = true,
	['kick']             = true,
	['mute']             = true,
	['unmute']           = true,
	['mutechat']            = true,
	['cunmute']          = true,
	['warn']             = true,
	['unwarn']           = true,
	['banrep']           = true,
	['addimmunity']      = true,
	['addimmid']         = true,
	['addimmunityid']    = true,
	['removeimmunity']   = true,
	['remimm']           = true,
	['removeimmunityid'] = true,
	['remimmid']         = true,
}

-- Ранги которые могут использовать команды наказания с любой профессии
local CURATOR_RANKS = {
	['root'] = true,
	['subcurator'] = true,
	['curator']    = true,
}

-- SteamID которые могут использовать команды наказания с любой профессии
local PUNISHMENT_WHITELIST = {
	['STEAM_0:0:124918272'] = true, -- замени на реальный SteamID
	-- ['STEAM_0:0:111111111'] = true,
}

-- Возвращает true ТОЛЬКО если игрок имеет право наказывать вне TEAM_ADMIN
local function hasCuratorAccess(pl)
	if not isplayer(pl) then return false end

	-- Проверка по SteamID (высший приоритет)
	if PUNISHMENT_WHITELIST[pl:SteamID()] then return true end

	-- Проверка строго по рангу badmin
	local rank = pl:GetRankTable()
	if not rank then return false end
	return CURATOR_RANKS[rank:GetName():lower()] == true
end

function ba.cmd.RunCommand(pl, cmd, args)
	cmd = cmd:lower()

	local is_player = isplayer(pl) and not pl:IsListenServerHost()

	-- Проверка: команды только для TEAM_ADMIN или куратор/вайтлист
	if is_player and ADMIN_ONLY_COMMANDS[cmd] then
		local inAdminTeam = pl:Team() == TEAM_ADMIN
		local hasCurator  = hasCuratorAccess(pl)
		if not inAdminTeam and not hasCurator then
			ba.notify_err(pl, 'Эта команда доступна только администраторам!')
			return
		end
	end

	local cancmd, err = (is_player and ba.Call('playerCanRunCommand', pl, cmd) or true)

	if not cancmd and err then
		ba.notify_err(pl, err)
	elseif not ba.cmd.Exists(cmd) then
		ba.notify_err(pl, term.Get('InvalidCommand'), cmd)
	else
		cmd = ba.cmd.Get(cmd)
		local name = cmd:GetName()
		local flag = cmd:GetFlag()

		if is_player and not pl:HasFlag(flag) then
			ba.notify_err(pl, term.Get('NeedFlagToUseCommand'), flag:upper(), name)
		else
			if not ba.cmd.Parse(pl, name, args) then return end
			ba.Call('playerRunCommand', pl, name, args)
			cmd:Init(pl, args)
		end
	end
end

hook.Add('PlayerSay', 'cmd.PlayerSay', function(pl, text)
    local text = text:Trim()
    if text[1] == '!' or text[1] == '/' then
        local args = string.Explode(" ", text)
        local command = args[1]:sub(2)
        table.remove(args, 1)
        if cmd.Exists(command) then
			cmd.Run(pl, command, args)
        elseif ba.cmd.Exists(command) then
            ba.cmd.RunCommand(pl, command, args)
        elseif not cmd.Exists(command) then
            rp.Notify(pl, NOTIFY_ERROR, "Неизвестная команда: #", command)
        elseif not ba.cmd.Exists(command) then
            ba.notify_err(pl, "# такой команды не существует!", command)
        end
        return ''
    end
end)

function ba.cmd.ConCommand(pl, cmd, args)
	if not args[1] then return end
	local cmd = args[1]
	table.remove(args, 1)

	for k, v in ipairs(args) do
		if (string.upper(tostring(v)) == 'STEAM_0') and (args[k + 4]) then
			args[k] = table.concat(args, '', k, k + 4)
			for i = 1, 4 do
				table.remove(args, k + 1)
			end
			break
		end
	end

	ba.cmd.RunCommand(pl, cmd, args)
end
concommand.Add('_ba', ba.cmd.ConCommand)
end)