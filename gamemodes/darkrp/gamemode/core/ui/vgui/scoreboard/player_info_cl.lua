cvar.Register 'player_nicknames'
	:SetDefault('')

function PLAYER:SetNickName(name)
	local cv = cvar.Get('player_nicknames')
	cv:AddMetadata(self:SteamID(), name)
	cv:Save()
end

function PLAYER:GetNickName()
	return cvar.Get('player_nicknames'):GetMetadata(self:SteamID())
end

local function newAdBtn(material, doClick, parent)
	local btn = ui.Create('ui_button', parent)
	btn:SetImage(material)
	btn.DoClick = doClick or function() end

	return btn
end

local PANEL = {}

function PANEL:Init()
	self.Achievements = newAdBtn('sup/gui/generic/achievement.png', nil, self)
	self.Achievements:Dock(LEFT)
	self.Achievements:DockMargin(5, 0, 0, 0)
	self.Achievements:SetText('Нет Достижений')

	self.Buttons = {}

	for k, v in ipairs(rp.achievements.SortedList) do
		local btn = newAdBtn(v.Icon, nil, self)
		btn:SetTooltip(v.Name .. '\n' .. v.Description)
		btn:SetText('')
		btn:SetWide(ui.ButtonHeight)
		btn:Dock(LEFT)
		btn:DockMargin(5, 0, 0, 0)
		btn.UID = v.UID

		self.Buttons[#self.Buttons + 1] = btn
	end
end

function PANEL:SetPlayer(pl)
	self.Player = pl
end

function PANEL:Update()
	local hasAchievements = false
	local AchievementsAmount = 0
	for k, v in ipairs(self.Buttons) do
		local visible = self.Player:HasAchievement(v.UID)
		if visible then
			hasAchievements = true
			AchievementsAmount = AchievementsAmount + 1
		end
		v:SetVisible(visible)
	end

	if hasAchievements then 
        self.Achievements:SetText(AchievementsAmount..'/'..#self.Buttons)
    end 
end

vgui.Register('rp_scoreboard_achievements', PANEL, 'Panel')

PANEL = {}

function PANEL:Init()
	self.Rank = newAdBtn('sup/gui/generic/user.png', nil, self)

	self.PlayTime = newAdBtn('sup/gui/generic/clock.png', nil, self)

	self.Steam = newAdBtn('sup/gui/generic/steam.png', function()
		self.Player:ShowProfile()
	end, self)
	self.Steam:SetText('Профиль')

	self.SteamID = newAdBtn('sup/gui/generic/steam.png', function()
		SetClipboardText(self.Player:SteamID())

		self.SteamID:SetText('Скопировано!')

		timer.Simple(2.5, function()
			if IsValid(self) and IsValid(self.SteamID) then
				self.SteamID:SetText('SteamID')
			end
		end)
	end, self)
	self.SteamID:SetText('SteamID')
	
	self.Achievements = ui.Create('rp_scoreboard_achievements', self)
end

function PANEL:PerformLayout(w, h)
	local btnW, btnH = (w - (5 * 8)) / 7, ui.ButtonHeight
	local btnX, btnY = 5, 5

	self.Rank:SetPos(btnX, btnY)
	self.Rank:SetSize(btnW, btnH)


	btnX = btnX + btnW + 5
	self.PlayTime:SetPos(btnX, btnY)
	self.PlayTime:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.Steam:SetPos(btnX, btnY)
	self.Steam:SetSize(btnW, btnH)

	btnX = btnX + btnW + 5
	self.SteamID:SetPos(btnX, btnY)
	self.SteamID:SetSize(btnW, btnH)
	
	btnY = btnY + ui.ButtonHeight + 5
	self.Achievements:SetPos(0, btnY)
	self.Achievements:SetSize(w - 5, ui.ButtonHeight)
	self.Achievements.Achievements:SetWide(btnW)
end

function PANEL:Update()
	if (not IsValid(self.Player)) or (self:GetParent():GetTall() <= 25) then return end

	self.Rank:SetText(self.Player:GetUserGroup())

	self.Rank:SetImage(
		(self.Player:GetRank() == 'root' and 'divergent/ui/ranks/root.png') or 
		(self.Player:GetRank() == 'subcurator' and 'divergent/ui/ranks/root.png') or 
		(self.Player:GetRank() == 'curator' and 'divergent/ui/ranks/superadmin.png') or 
		(self.Player:GetRank() == 'owner' and 'divergent/ui/ranks/operator.png') or 
		(self.Player:GetRank() == 'superadmin' and 'divergent/ui/ranks/stadmin.png') or 
		(self.Player:GetRank() == 'admin' and 'divergent/ui/ranks/admin.png') or 
		(self.Player:GetRank() == 'moder' and 'divergent/ui/ranks/moder.png') or 
		(self.Player:GetRank() == 'naboradmin' and 'divergent/ui/ranks/helper.png') or 
		(self.Player:GetRank() == 'helper' and 'divergent/ui/ranks/helper.png') or 
		(self.Player:GetRank() == 'probation' and 'divergent/ui/ranks/helper.png') or 
		(self.Player:GetRank() == 'downer' and 'divergent/ui/ranks/sponsor.png') or 
		(self.Player:GetRank() == 'dsuperadmin' and 'divergent/ui/ranks/dsuperadmin.png') or 
		(self.Player:GetRank() == 'dadmin' and 'divergent/ui/ranks/dadmin.png') or 
		(self.Player:GetRank() == 'dmoder' and 'divergent/ui/ranks/dmoder.png') or 
		(self.Player:GetRank() == 'dvip' and 'divergent/ui/ranks/vip.png') or 
		(self.Player:GetRank() == 'vip' and 'divergent/ui/ranks/vip.png') or 
		(self.Player:GetRank() == 'user' and 'divergent/ui/ranks/user.png'))

	self.PlayTime:SetText(ba.str.FormatTime(self.Player:GetPlayTime()))

	self.Achievements:Update()
end

function PANEL:SetPlayer(pl)
	self.Player = pl
	self.Achievements:SetPlayer(pl)
	self:Update()
end

function PANEL:Paint(w, h)
	draw.Box(0, 0, w, h, Color(90, 86, 86))
	draw.RoundedBox(6, 1, 1, w - 2, h - 2, eclipse.col.Eclipse)
end

vgui.Register('rp_scoreboard_playerinfo', PANEL, 'Panel')