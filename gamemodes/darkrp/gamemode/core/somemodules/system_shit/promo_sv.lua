local promos = {
	"neweclipse",
	"may",
	"vip"
}

rp.AddCommand("promo", function(pl, args)
	file.CreateDir("promos")
	if table.HasValue(promos, args) then
		if args == "neweclipse" then
			if (pl:GetPlayTime() and pl:GetPlayTime() < 60 * 15) or pl:GetPlayTime() < 60 * 15 then
				return ba.notify_err(pl, "Осталось отыграть ".. ba.str.FormatTime(60 * 15 - pl:GetPlayTime()) .." до активации промо 'neweclipse'!")
			end

			if file.Exists("promos/neweclipse/"..pl:SteamID64()..".txt", "DATA") then
				return ba.notify_err(pl, "Вы уже использовали данный промокод!")
			else
				file.CreateDir("promos/neweclipse")
				file.Write("promos/neweclipse/"..pl:SteamID64()..".txt", "")
				pl:AddIGSFunds(500, "Использование промокода 'neweclipse'")
				ba.notify(pl, "Вы получили 500 Rub на донат счёт за использование промокода 'neweclipse'!")
				ba.notify_staff('Игрок ' .. pl:Name() .. '(' .. pl:SteamID() .. ") активировал промо 'neweclipse'")
			end
		elseif args == "may" then
			if file.Exists("promos/may/"..pl:SteamID64()..".txt", "DATA") then
				return ba.notify_err(pl, "Вы уже использовали данный промокод!")
			end

			if (pl:GetSessionTime() and pl:GetSessionTime() < 60 * 30) or pl:GetSessionTime() < 60 * 30 then
				return ba.notify_err(pl, "Осталось отыграть ".. ba.str.FormatTime(60 * 30 - pl:GetSessionTime()) .." до активации промо 'may'!")
			end

			file.CreateDir("promos/may")
			file.Write("promos/may/"..pl:SteamID64()..".txt", "")
			pl:AddIGSFunds(250, "Использование промокода 'may'")
			ba.notify(pl, "Вы получили 250 Rub на донат счёт за использование промокода 'may'!")
			ba.notify_staff('Игрок ' .. pl:Name() .. '(' .. pl:SteamID() .. ") активировал промо 'may'")
		
		elseif args == "vip" then
			-- Проверка: использовал ли уже промокод (только 1 раз)
			if file.Exists("promos/vip/"..pl:SteamID64()..".txt", "DATA") then
				return ba.notify_err(pl, "Вы уже использовали данный промокод!")
			end

			-- Проверка: отыгран ли 1 день (1440 минут)
			if (pl:GetPlayTime() and pl:GetPlayTime() < 60 * 24) or pl:GetPlayTime() < 60 * 24 then
				return ba.notify_err(pl, "Осталось отыграть ".. ba.str.FormatTime(60 * 60 - pl:GetPlayTime()) .." до активации промо 'vip'!")
			end

			-- Сохраняем факт использования
			file.CreateDir("promos/vip")
			file.Write("promos/vip/"..pl:SteamID64()..".txt", "")

			-- Выдача VIP на 7 дней
			local expireTime = os.time() + 60 * 60 * 24 * 7
			ba.data.SetRank(pl, 'vip', 'user', expireTime, function()
				ba.notify(pl, "Вы получили привилегию VIP на 7 дней за промокод 'vip'!")
				ba.notify_staff('Игрок ' .. pl:Name() .. ' (' .. pl:SteamID() .. ") активировал промо 'vip' — выдан VIP на 7 дней")
			end)
		end
	end
end)
:AddParam(cmd.STRING)