cvar.Register('HasClosedBlockMsg')
	:SetDefault(false, true)

local function newAdBtn(label, material, url, parent)
	local btn = ui.Create('ui_button', parent)
	btn:SetText(label)
	btn:SetImage(material)

	function btn:DoClick()
		if isfunction(url) then
			url(self)
		else
			gui.OpenURL(url)
		end
	end

	return btn
end

surface.CreateFont('tab.benz', { font = 'Benzin-Bold', size = 40, weight = 900, extended = true, })

local PANEL = {}

local filters = {
	{'Все', function(self, pl) return true end},
	{'Админы', function(self, pl) return pl:IsAdmin() end},
	{'Ты', function(self, pl) return (pl == LocalPlayer()) end}
}

function PANEL:Init()
	self:SetVisible(false)

	self:SetSize(ScrW() * 0.8, ScrH() * 0.8)

	self.ButtonCredits = newAdBtn('', 'divergent/ui/scoreboard/credits.png', function() IGS.UI() rp.Scoreboard:Close() end, self)
	self.ButtonDiscord = newAdBtn('', 'divergent/ui/hud/icons/discord.png', rp.cfg.DiscordURL, self)
	self.ButtonSteam = newAdBtn('', 'divergent/ui/scoreboard/steam.png', rp.cfg.SteamURL, self)

	self.Filter = 1

	self.ButtonSearch = newAdBtn('Все', 'divergent/ui/scoreboard/filter.png', function(s)
		self.Filter = (self.Filter  == #filters) and 1 or (self.Filter  + 1)
		s:SetText(filters[self.Filter ][1])
		self:Update()
	end, self)
	self.ButtonSearch.DoRightClick = function(s)
		self.Filter = (self.Filter  == 1) and #filters or (self.Filter  - 1)
		s:SetText(filters[self.Filter ][1])
		self:Update()
	end

	self.PlayerRows = {}
	self.PlayerList = ui.Create('ui_scrollpanel', self)
	self.PlayerList:HideScrollbar(true)
	self.PlayerList.contentContainer._GetChildren = self.PlayerList.contentContainer.GetChildren
	self.PlayerList.contentContainer.GetChildren = function(s)
		local children = s:_GetChildren()

		local sortedChildren = {}

		local sorted = {}
		for i = 1, #rp.teams do
			sorted[i] = {}
		end

		for k, v in ipairs(children) do
			local pl = v.Player
			if IsValid(pl) and sorted[pl:GetJob()] then
				table.insert(sorted[pl:GetJob()], v)
			end
		end

		for _, t in ipairs(sorted) do
			table.sort(t, function (a, b) return a.Player:Name():lower() < b.Player:Name():lower() end)
			for k, v in ipairs(t) do
				table.insert(sortedChildren, v)
			end
		end
		return sortedChildren
	end

	self.PlayerList.Paint = function(self, w, h) draw.RoundedBox(5, 0, 0, w, h, Color(24, 24, 24, 120)) end

	self.Hostname = ui.Create('DLabel', self )
	self.Hostname:SetFont('tab.benz')
	self.Hostname:SetTextColor(Color(255, 255, 255))
	-- название и логотип в шапке скорборда убраны
	self.Hostname:SetText('')
	self.Hostname.Paint = function() end

	self.SearchBar = ui.Create('DTextEntry', self)
	self.SearchBar:SetPlaceholderText('Поиск...')
end

function PANEL:PerformLayout(w, h)
	local listW, listH = w - 10, h - 91
	self.PlayerList:SetSize(listW, listH)

	local listX, listY = 5, 85
	self.PlayerList:SetPos(listX, listY )
	self.PlayerList:SetPadding(0)
	self.PlayerList:SetSpacing(1)

	local btnW, btnH = 95, 35
	local btnX, btnY = (w - btnW) - 60, 5
	self.SearchBar.x = btnX

	self.Hostname:SizeToContents()
	self.Hostname:SetPos(20, 7.5)

	btnX = btnX + btnH + 5
	self.ButtonDiscord:SetPos(btnX, btnY)
	self.ButtonDiscord:SetSize(btnH, btnH)

	btnX = btnX + btnH + 5
	self.ButtonSteam:SetPos(btnX, btnY)
	self.ButtonSteam:SetSize(btnH, btnH)

	btnX = btnX + btnH + 5
	self.ButtonCredits:SetPos(btnX, btnY)
	self.ButtonCredits:SetSize(btnH, btnH)

	btnY = btnY + btnH + 5
	self.SearchBar.y = btnY
	self.SearchBar:SetSize(btnW * 3 + 10, btnH)

	self.ButtonSearch:SetPos(w - 110 - 5, btnY)
	self.ButtonSearch:SetSize(110, btnH)
end

function PANEL:Open()
	self.StartAnim = SysTime()
	self.StartY = self.ActualY or -self:GetTall()
	self.EndY = (ScrH() - self:GetTall()) * 0.5
	self.ActualY = self.StartY
	self.Opening = true

	self:SetVisible(true)
end

function PANEL:Close()
	if (self.Filter == 5) then
		return
	end

	self.StartAnim = SysTime()
	self.StartY = self.ActualY or 0
	self.EndY = -self:GetTall()
	self.ActualY = self.StartY
	self.Opening = false
end

function PANEL:Update()
	local filterFunc = filters[self.Filter][2]

	self.SearchBar:SetVisible(self.Filter == 5)
	self:SetKeyboardInputEnabled(self.Filter == 5)

	local total_players, active_players, total_staff, active_staff = player.GetCount(), 0, 0, 0

	for k, v in ipairs(player.GetAll()) do
		if v:IsAdmin() then
			total_staff = total_staff + 1
		end
		if v:Alive() or (v:Team() ~= 1) then
			active_players = active_players + 1
			if v:IsAdmin() then
				active_staff = active_staff + 1
			end
		end

		if (not self.PlayerRows[v]) and filterFunc(self, v) then
			local row = ui.Create('rp_scoreboard_player')
			row:SetPlayer(v)
			self.PlayerList:AddItem(row)
			self.PlayerRows[v] = row
		end
	end

	for k, v in pairs(self.PlayerRows) do
		if (not IsValid(k)) or (not filterFunc(self, k)) then
			v:Remove()
			self.PlayerRows[k] = nil
		else
			self.PlayerRows[k]:Update()
		end
	end

	local ponline = 'Игроков онлайн: ' ..  total_players

	self.LabelPlayers = ponline

	local hours = math.floor(CurTime() / 3600)
	local minutes = math.floor((CurTime() % 3600) / 60)
	local seconds = math.floor(CurTime() - (hours * 3600) - (minutes * 60))
	if (minutes < 10) then minutes = '0' .. minutes end
	if (seconds < 10) then seconds = '0' .. seconds end
	self.LabelUptime = 'Время работы сервера: ' .. hours .. ':' .. minutes .. ':' .. seconds
end

function PANEL:Think()
	if self:IsVisible() then
		self:MoveToFront()

		if (not self.NextThink) or (self.NextThink < CurTime()) then
			self:Update()
			self.NextThink = CurTime() + 1
		end

		local mul = self.Opening and
			(math.sin(math.Clamp((SysTime() - self.StartAnim) / .5, 0, 1) * (math.pi / 1.42)) * 1.25)
		or
			(1 - math.sin((math.Clamp((SysTime() - self.StartAnim) / .3, 0, 1) - 2.42) * (math.pi / 1.42)) * 1.25)

		self.ActualY = self.StartY + mul * (self.EndY - self.StartY)
		self:SetPos((ScrW() - self:GetWide()) * 0.5, self.ActualY)

		if (!self.Opening and math.Round(mul) == 1) then self:SetVisible(false) end
	end
end

function PANEL:Paint(w, h)
	local x, y = self:LocalToScreen(0, 0)

	draw.DrawBlur(5, x, y, w, h, nil, Color(58, 58, 58, 195))

	surface.SetDrawColor(255, 255, 255)
end

vgui.Register('rp_scoreboard', PANEL, 'EditablePanel')