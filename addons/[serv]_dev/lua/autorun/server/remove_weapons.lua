local server_name = {
	{
		name = '✦ MajesterRP | ОБНОВЛЕНИЕ | ПРОМО VIP ✦',
	},
	{
		name = '✦ MajesterRP | ОБНОВЛЕНИЕ | ПРОМО VIP ✦',
	},
}

local i = 0

local function changeServerName()
	i = i + 1

	if !server_name[i] then
		i = 1
	end

	for k, v in pairs(server_name[i]) do
		RunConsoleCommand('hostname', v)
	end
end

timer.Create('setServerName', 600, 0, changeServerName)
concommand.Add('SetDefName',  changeServerName)

timer.Create('prospok', 0, 0, function()
	for _, pl in ipairs(player.GetAll()) do
		if !IsValid(pl) then return end

		local count = pl:GetCount('props')
		pl:SetNetVar('PropsCount', count)
	end
end)

-- лимит пропов: по рангу, если ранга нет в таблице - по группе, иначе как у user
local function updateMaxProps(pl)
	if !IsValid(pl) then return end

	local opa = 0
	if pl:HasPurchase('15_prop_limit') then
		opa = pl:HasPurchase('15_prop_limit') * 15
	end

	local limits = rp.cfg.PropLimits or {}
	local base = limits[pl:GetRank()] or limits[pl:GetUserGroup()] or limits['user'] or 40

	pl:SetNetVar('MaxProps', base + opa)
end

hook.Add('PlayerSpawn', 'propscoco', updateMaxProps)

-- ранг загрузился / поменялся - обновляем лимит (раньше он считался только при спавне)
hook.Add('playerRankLoaded', 'propscoco.rank', function(pl) updateMaxProps(pl) end)
hook.Add('playerSetRank', 'propscoco.rank', function(pl)
	if isplayer(pl) then timer.Simple(0, function() updateMaxProps(pl) end) end
end)
