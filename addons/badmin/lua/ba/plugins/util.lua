-------------------------------------------------
-- Cloak
-------------------------------------------------
term.Add('AdminCloackEnable', '# сделал себя невидимым.')
term.Add('AdminCloackDisable', '# сделал себя видимым.')

ba.cmd.Create('Cloak', function(pl, args)
	if !pl:GetBVar('adminmode') and !pl:IsRoot() then
		ba.notify(pl, "Войди сначала в админмод!")
		return
	end

    if pl:GetNoDraw() then
		ba.notify_staff(term.Get('AdminCloackDisable'), pl)
		pl:SetNoDraw(false)
		for _, v in pairs(pl:GetWeapons()) do
            v:SetNoDraw(false)
        end
	else
		ba.notify_staff(term.Get('AdminCloackEnable'), pl)
		pl:SetNoDraw(true)
		for _, v in pairs(pl:GetWeapons()) do
            v:SetNoDraw(true)
        end
	end
end)
:SetFlag('h')
:SetHelp('Сделать невидимым.')

-------------------------------------------------
-- Lookup
-------------------------------------------------
if (SERVER) then
	util.AddNetworkString('ba.Lookup')
end

local fr
local ranks = {
	['user'] = 'icon16/user.png',
	['vip'] = 'icon16/heart.png',
	['dvip'] = 'icon16/heart_add.png',
	['dmoder'] = 'icon16/heart_add.png',
	['dadmin'] = 'icon16/star.png',
	['dsuperadmin'] = 'icon16/award_star_silver_2.png',
	['downer'] = 'icon16/money_dollar.png',
	['probation'] = 'icon16/user_go.png',
	['helper'] = 'icon16/user_add.png',
	['naboradmin'] = 'icon16/user_suit.png',
	['moder'] = 'icon16/shield.png',
	['admin'] = 'icon16/shield_add.png',
	['superadmin'] = 'icon16/award_star_gold_3.png',
	['owner'] = 'icon16/award_star_add.png',
	['curator'] = 'icon16/lightning_add.png',
	['globaladmin'] = 'icon16/world.png',
	['subcurator'] = 'icon16/tux.png',
	['root'] = 'icon16/user.png',
}

ba.cmd.Create('lookup', function(pl, args)
	local tbl = {
		name = args.target:Name(),
		stm = args.target:SteamID(),
		group = args.target:GetRank(),
		time = ba.str.FormatTime(args.target:GetPlayTime())
	}
	
	local data = util.TableToJSON(tbl)
	local size = #data
 	net.Start('ba.Lookup')
		net.WriteUInt(size, 16)
		net.WriteString(data)
	net.Send(pl)
end)
:AddParam('player_entity', 'target')
:SetFlag('u')
:SetHelp('Показывает информацию об игроке\n/lookup <Ник/SteamID>')
:AddAlias('l')
:RunOnClient(function(args)
	net.Receive('ba.Lookup', function(len)
 		local size = net.ReadUInt(16)
		local columns = util.JSONToTable(net.ReadString())
		if (IsValid(fr)) then fr:Remove() end

		fr = ui.Create('ui_frame', function(self)
			self:SetSize(427.5, 208)
			self:SetTitle("Информация об игроке")
			self:Center()
			self:SetDraggable(true)
			self:MakePopup()
		end)

		local info = ui.Create('ui_scrollpanel', function(self, p)
			self:Dock(FILL)
			self:SetSize(610, 120)
		end, fr)

		local player = ui.Create('ui_panel')
		player:SetSkin('SUP')
		player:SetSize(fr:GetWide(), fr:GetTall() - 35)

		local line = {columns.name .. ' (' .. columns.stm .. ')'}
	 
		local time = os.time() + 10800
   	 	local date = os.date("!%H:%M:%S - %d/%m/%Y", time)

		local j = ui.Label('Ник: ' .. columns.name, 'ui.22', 25, 5,  player)
		local h = ui.Label('SteamID: ' .. columns.stm, 'ui.22', 25, 27,  player)
		local f = ui.Label('Привилегия: ' .. columns.group, 'ui.22', 25, 48,  player)
		local a = ui.Label('Наигранное время: ' .. columns.time, 'ui.22', 25, 69,  player)
		local dat = ui.Label('[MSK] Дата: ' .. date, 'ui.22', 25, 91,  player)
		local x = ui.Create('DImage', function(self)
			self:SetPos(5, 8)
			self:SetImage('icon16/user_red.png')
			self:SetSize(16, 16)
		end, player)
		local w = ui.Create('DImage', function(self)
			self:SetPos(5, 73.5)
			self:SetImage('icon16/application_form.png')
			self:SetSize(16, 16)
		end, player)
			local i = ui.Create('DImage', function(self)
			self:SetPos(5, 51)
			self:SetImage((ranks[columns.group] or 'icon16/user.png'))
			self:SetSize(16, 16)
		end, player)
			local q = ui.Create('DImage', function(self)
			self:SetPos(5, 30.5)
			self:SetImage('icon16/user_edit.png')
			self:SetSize(16, 16)
		end, player)
			local da = ui.Create('DImage', function(self)
			self:SetPos(5, 95.5)
			self:SetImage('icon16/clock.png')
			self:SetSize(16, 16)
		end, player)
			local b = ui.Create('ui_button', function(self)
			self:SetSize(172, 30)
			self:SetPos(0, 115)
			self:SetText('Скопировать SteamID')
			self.DoClick = function()
				SetClipboardText(columns.stm)
				LocalPlayer():ChatPrint(ui.col.White, 'Скопировано!')
			end
		end, player)
			local ws = ui.Create('ui_button', function(self)
			self:SetSize(246, 30)
			self:SetPos(171, 115)
			self:SetText('Скопировать ссылку на профиль')
			self.DoClick = function()
				SetClipboardText('https://steamcommunity.com/profiles/' .. util.SteamIDTo64(columns.stm))
				LocalPlayer():ChatPrint(ui.col.White, 'Скопировано!')
			end
		end, player)
			local gs = ui.Create('ui_button', function(self)
			self:SetSize(417, 30)
			self:SetPos(0, 143)
			self:SetText('Скопировано!')
			self.DoClick = function()
				SetClipboardText(columns.name .. '(' .. columns.stm .. ')')
				LocalPlayer():ChatPrint(ui.col.White, 'Скопировано!')
			end
		end, player)
		info:AddItem(player)
	end)
end)
-------------------------------------------------
-- Strip Weapons
-------------------------------------------------
ba.cmd.Create('Strip', function(pl, args)
	args.target:StripWeapons()
	ba.notify(args.target, "У вас забрали все оружие")
end)
:SetFlag('*')
:AddParam('player_entity', 'target')
:SetHelp('Забрать всё оружее.')
-------------------------------------------------
-- God
-------------------------------------------------
ba.cmd.Create('God', function(pl)
	if !pl:GetBVar('adminmode') and !pl:IsRoot() then
		ba.notify("Войди сначала в админмод!")
		return
	end
	if pl:HasGodMode() then
		pl:GodDisable()
		ba.notify(pl, "Бессмертие выключено!")
	else
		pl:GodEnable()
		ba.notify(pl, "Бессмертие включено!")
	end
end)
:SetFlag('w')
:SetHelp('Сделать бессмертным.')
-------------------------------------------------
-- Bots -- 
-------------------------------------------------
ba.cmd.Create('Bots', function(pl, args)
	for i = 1, tonumber(args.number) do
		RunConsoleCommand('bot')
	end
end)
:AddParam('string', 'number')
:SetFlag '*'
:SetHelp 'Заспавнить роботов'

ba.cmd.Create('KickBots', function(pl)
	for k, v in ipairs(player.GetBots()) do
		v:Kick()
	end
end) 
:SetFlag '*'
:SetHelp 'Кикнуть всех роботов' 

ba.cmd.Create('StripLook', function(pl)
	local tr = pl:GetEyeTrace().Entity
	if IsValid(tr) and tr:IsPlayer() then
		tr:StripWeapons()
		timer.Simple(.1, function()
			tr:Give('weapon_physgun')
			tr:Give('gmod_tool')
			tr:Give('keys')
		end)
		ba.notify(tr, "У вас забрали все оружие")
	else
		rp.Notify(pl, NOTIFY_ERROR, 'Вы не смотрите на игрока!')
	end
end)
:SetFlag('*')
:SetHelp('Забрать всё оружее.')
-------------------------------------------------
-- SetScale -- 
-------------------------------------------------
ba.cmd.Create('Set Scale', function(pl, args)
	args.player:SetModelScale(args.number)
end)
:SetFlag('*')
:AddParam('player_entity', 'player')
:AddParam('string', 'number')
:SetHelp('Увеличить размер модели.')