-- База данных геймода (MySQL)

local ip = '192.168.0.174'
local us = 'xenforo_user'
local ps = 'rDTHO7fBjSsLvxnhP6iU'
local tb = 'test'

rp._Stats = mysql(ip, us, ps, tb, 3306)
rp._Credits = rp._Stats

-- =====================================================================
-- rp.data: обёртка для работы с данными игроков
-- =====================================================================
rp.data = rp.data or {}

function rp.data.IsLoaded(ply)
	if not IsValid(ply) then return false end
	return ply:GetBVar('DataLoaded', false) and true or false
end

function rp.data.GetMoney(ply)
	if not IsValid(ply) then return 0 end
	return ply:GetNetVar('Money', 0)
end

function rp.data.SetMoney(ply, amount)
	if not IsValid(ply) then return end
	amount = math.floor(amount or 0)
	ply:SetNetVar('Money', amount)
	local steamid = ply:SteamID64()
	rp._Stats:Query('UPDATE player_data SET Money=? WHERE SteamID=?', amount, steamid)
end

function rp.data.AddMoney(ply, amount)
	if not IsValid(ply) then return end
	amount = math.floor(amount or 0)
	local current = rp.data.GetMoney(ply)
	rp.data.SetMoney(ply, current + amount)
end

function rp.data.CanAfford(ply, amount)
	if not rp.data.IsLoaded(ply) then return false end
	amount = math.floor(amount or 0)
	return (amount >= 0) and ((rp.data.GetMoney(ply) - amount) >= 0)
end

function rp.data.GetName(ply)
	if not IsValid(ply) then return 'Unknown' end
	return ply:GetNetVar('RPName', ply:Name())
end

function rp.data.GetPocket(ply)
	if not IsValid(ply) then return '{}' end
	return ply:GetNetVar('Pocket', '{}')
end

function rp.data.SetPocket(ply, data)
	if not IsValid(ply) then return end
	ply:SetNetVar('Pocket', data)
	local steamid = ply:SteamID64()
	rp._Stats:Query('UPDATE player_data SET Pocket=? WHERE SteamID=?', data, steamid)
end

hook.Add('PlayerInitialSpawn', 'rp.data.LoadPlayer', function(ply)
	local steamid = ply:SteamID64()
	rp._Stats:Query('SELECT * FROM player_data WHERE SteamID=?', steamid, function(data)
		if not IsValid(ply) then return end

		local row = data and data[1]
		if not row then
			rp._Stats:Query('INSERT INTO player_data(SteamID, Name, Money, Pocket) VALUES(?, ?, 0, \'{}\')',
				steamid, ply:Name())
			ply:SetNetVar('Money', 0)
			ply:SetNetVar('Pocket', '{}')
		else
			ply:SetNetVar('Money', tonumber(row.Money) or 0)
			ply:SetNetVar('Pocket', row.Pocket or '{}')
		end

		ply:SetBVar('DataLoaded', true)
	end)
end)

hook.Add('PlayerDisconnected', 'rp.data.SavePlayer', function(ply)
	if not ply:GetBVar('DataLoaded', false) then return end
	local steamid = ply:SteamID64()
	local money   = rp.data.GetMoney(ply)
	rp._Stats:Query('UPDATE player_data SET Money=?, Name=? WHERE SteamID=?',
		money, ply:Name(), steamid)
end)