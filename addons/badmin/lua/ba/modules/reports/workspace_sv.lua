util.AddNetworkString("ba.openRatingPlayer")
util.AddNetworkString("ba.closeRatingAdmin")

net.Receive("ba.closeRatingAdmin", function(len, ply)
	if not ply.ratingUsing then return end

	local admsid  = net.ReadString()
	local admname = net.ReadString()
	local admrate = net.ReadFloat()

	local db = ba.data.GetDB()
	if not db then ply.ratingUsing = false return end

	if admrate < 0 or admrate > 5 then
		ply:Kick("attempt to exploit ReportSystem (rating)")
		ply.ratingUsing = false
		return
	end

	local target = player.GetBySteamID(admsid)
	if IsValid(target) then
		ba.notify(target, "Игрок, которому вы разобрали жалобу, оценил вас на " .. admrate .. " баллов!")
	end

	local steam64     = util.SteamIDTo64(admsid)
	local nm = db:escape(admname)

	db:query("INSERT IGNORE INTO ba_rating(steamid, nameid, rate) VALUES(" .. steam64 .. ", \"" .. nm .. "\", 0)")

	db:query_ex('UPDATE ba_rating SET rate = rate + ? WHERE steamid = "?"', {admrate, steam64})

	db:query_ex('INSERT INTO ba_ratinglogs(a_steamid, rate, data, p_steamid) VALUES("?", "?", "?", "?")', {
		util.SteamIDTo64(admsid), admrate, os.time(), ply:SteamID64()
	})

	ply.ratingUsing = false
end)

concommand.Add("cleardbandcreate", function(ply, cmd, args)
	if not ply:IsRoot() then
		ba.notify(ply, "У вас нет доступа к этой команде!")
		return false
	end

	local db = ba.data.GetDB()
	print("Prep...")

	db:query("DROP TABLE IF EXISTS ba_ratinglogs;")
	db:query("DROP TABLE IF EXISTS ba_rating;")
	db:query("DROP TABLE IF EXISTS ba_warns;")

	db:query([[
CREATE TABLE IF NOT EXISTS `ba_ratinglogs` (
  `a_steamid` bigint(50) NOT NULL,
  `rate` tinyint(1) NOT NULL,
  `data` bigint(50) NOT NULL,
  `p_steamid` bigint(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]])

	db:query([[CREATE TABLE IF NOT EXISTS `ba_rating` (
  `steamid` bigint(50) NOT NULL,
  `nameid` text NOT NULL,
  `rate` bigint(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]])
	db:query([[ALTER TABLE `ba_rating` ADD PRIMARY KEY (`steamid`);]])

	db:query([[
CREATE TABLE IF NOT EXISTS `ba_warns` (
  `steamid` bigint(50) NOT NULL,
  `warns` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]])
	db:query([[ALTER TABLE `ba_warns` ADD PRIMARY KEY (`steamid`);]])

	print("Ready!")
end)

hook.Add("PlayerDisconnected", "LeaveJaloba", function(ply)
	local targ = ply:GetBVar("StaffRequestAdmin")
	if not targ or not IsValid(targ) then return end

	if targ:IsAdmin() then
		targ:SetBVar("StaffRequestAdmin", nil)
		net.Start("CloseMenusWow")
		net.Send(targ)
		ba.notify(targ, "Игрок, который подал жалобу, вышел с сервера!")
		return
	end

	targ:SetBVar("StaffRequestAdmin", nil)

	net.Start("ba.openRatingPlayer")
		net.WriteString(ply:Name())
		net.WriteString(ply:SteamID())
	net.Send(targ)

	net.Start("CloseMenusWow")
	net.Send(targ)

	targ.ratingUsing = true
end)