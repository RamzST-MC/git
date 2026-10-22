local actionsMenus = {
	{
		Name = 'Деньги',
		DoClick = function(p)
			local menu = ui.DermaMenu(p)
			menu:AddOption("Выкинуть деньги", function() ui.NumberRequest('Кошелёк', 'Сколько вы хотите выкинуть денег?', 2, 2, LocalPlayer():GetMoney(), function(b) cmd.Run('dropmoney', tostring(b)) end) end)
			menu:AddOption("Передать деньги", function() ui.NumberRequest('Кошелёк', 'Сколько вы хотите передать денег?', 2, 2, LocalPlayer():GetMoney(), function(b) cmd.Run('give', tostring(b)) end) end)
			menu:Open()
		end
	},
	{
		Name = 'Оружие',
		DoClick = function(p)
			local menu = ui.DermaMenu(p)
			menu:AddOption("Купить патроны", function()
				if not LocalPlayer():GetActiveWeapon().Primary then return end
				cmd.Run("buyammo", string.lower(LocalPlayer():GetActiveWeapon().Primary.Ammo))
			end)

			menu:AddOption("Выкинуть оружие", function() cmd.Run('drop') end)
			menu:Open()
		end
	},
	{
		Name = 'Уволить игрока',
		DoClick = function(p) ui.PlayerRequest(function(v) ui.StringRequest('Уволить игрока', 'Введите причину', '', function(a) if IsValid(v) then cmd.Run('demote', v:SteamID(), a) end end) end) end
	},
	-- {
	-- 	Name 	= 'Покакать',
	-- 	DoClick = function(p)
	-- 		cmd.Run('poop')
	-- 	end
	-- },
	-- {
	-- 	Name 	= 'Пописать',
	-- 	DoClick = function(p)
	-- 		cmd.Run('piss')
	-- 	end
	-- },
	{
		Name = 'Эмоции',
		DoClick = function(p)
			local m = ui.DermaMenu(p)
			for k, v in pairs(rp.PlayerActs) do
				local name = k[1]:upper() .. k:sub(2)
				m:AddOption(name, function() cmd.Run('act', k) end)
			end

			m:Open()
		end
	},
	{
		Name = 'Жесты',
		DoClick = function(p)
			local m = ui.DermaMenu(p)
			for k, v in ipairs(rp.emotes.Registered) do
				if v.CanRun == nil or v:CanRun(LocalPlayer()) then
					m:AddOption(v.Name, function()
						cmd.Run('emote', v.UID)
					end)
				end
			end

			m:Open()
		end
	}
}

local unilitiesMenus = {
	{
		Name = 'Доступ',
		DoClick = function(p) rp.pp.SharePropMenu() end
	}
}

local function makeMenus(x, y, name, menus, cont)
	local fr = ui.Create('ui_frame', function(self, p)
		self:SetPos(x, y)
		self:ShowCloseButton(false)
		self:SetTitle(name)
	end, cont)

	local x, y = fr:GetDockPos()
	local c = 0
	for k, v in ipairs(menus) do
		fr:SetSize(200, y + k * 35)
		ui.Create('ui_button', function(self)
			self:SetSize(200 - 10, 30)
			self:SetPos(x, y + c * 35)
			self:SetText(v.Name)
			self.DoClick = v.DoClick
		end, fr)

		c = c + 1
	end
	return fr
end

hook('ContextMenuCreated', function(cont)
	local actions = makeMenus(10, ScrH() / 2 - (#actionsMenus * 30), 'Действия', actionsMenus, cont)
	local x, y = actions:GetPos()
	local utilities = makeMenus(x, y + actions:GetTall() + 5, 'Утилиты', unilitiesMenus, cont)
	x, y = utilities:GetPos()
	hook.Run("CreateThirdPersonContextMenu", x, y + utilities:GetTall() + 5)
end)