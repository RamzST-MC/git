local PANEL = {}

local material_block = Material('divergent/ui/scoreboard/micon.png', 'smooth')
local material_ublock = Material('divergent/ui/scoreboard/micoff.png', 'smooth')
function PANEL:Init()
	self:SetTall(30)
	self:SetText ''

	self.Avatar = ui.Create('ui_imagebutton', self)
	self.Avatar:SetTooltip('Открыть стим профиль')

	self.Mute = ui.Create('ui_button', self)
	self.Mute:SetMaterial(material_block)
	self.Mute:SetText('')
	self.Mute:SetTooltip('Замутить/Размутить игрока')
	self.Mute.DoClick = function()
		if (self.Player == LocalPlayer()) then return end

		self.Player:Block(not self.Player:IsBlocked())
	end
	self.Mute.Paint = function(s, w, h)
		if (not IsValid(self.Player)) then return end
		surface.SetDrawColor(ui.col.White)
		surface.SetMaterial(self.Player:IsBlocked() and material_ublock or material_block)
		surface.DrawTexturedRect(3, 3, 24, 24)
	end

	self.InfoCard = ui.Create('rp_scoreboard_playerinfo', self)
end


function PANEL:PerformLayout(w, h)
	self.Avatar:SetPos(2, 2)
 	self.Avatar:SetSize(26, 26)

	self.Mute:SetPos(self:GetWide() - 30, 0)
	self.Mute:SetSize(30, 30)

	self.InfoCard:SetPos(0, 30)
	self.InfoCard:SetSize(self:GetWide(), self:GetTall() - 30)

	self:Update()
end

function PANEL:DoClick()
	if self.Open then
		self.TargetHeight = 30
		self.Open = nil
	else
		self.TargetHeight = (ui.ButtonHeight * 2) + 45
		self.Open = true
	end
end

function PANEL:Think()
	if (self.TargetHeight and self:GetTall() ~= self.TargetHeight) then
		local tall = self:GetTall()
		local mul = tall > self.TargetHeight and -1 or 1

		tall = tall + FrameTime() * (tall - self.TargetHeight * -mul) * 3 * mul
		if (math.abs(tall - self.TargetHeight) < 1) then
			tall = self.TargetHeight
			if (self.TargetHeight == 135) then
				self.TargetHeight = 135
			else
				self.TargetHeight = nil
			end
		end
		self:SetTall(tall)
		rp.Scoreboard.PlayerList:InvalidateLayout()
	end
end

function PANEL:Update()
	if (not IsValid(self.Player)) then return end

	local w = self:GetWide()

	local job = self.Player:GetJob()
	if self.Job and (self.Job ~= job) then
		self:GetParent():GetParent():PerformLayout()
	end

	self.Job = job

	self.PlayerColor 	= self.Player:GetJobColor():Copy()
	self.PlayerColor.a = 200

	--local eTag = self.Player:GetChatTag()
	--local chatTag = eTag and ba.chatEmotes[eTag:Trim()]

	local badgeimg = 
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
	(self.Player:GetRank() == 'user' and 'divergent/ui/ranks/user.png')
	self.RankMaterial 	= chatTag and chatTag.mat or Material(badgeimg, 'smooth')

	self.PlayerName = self.Player:Name()

	if (not self.Player:Alive()) and LocalPlayer():IsAdmin() then
		surface.SetFont('ui.17')
		local w, h = surface.GetTextSize(self.PlayerName)
		self.PlayerNameSize = w
		self.DrawName = self.DrawNameDead
	elseif self.Player:IsWanted() then
		self.DrawName = self.DrawNameWanted
	else
		self.DrawName = self.DrawNameNormal
	end

	surface.SetFont('ui.18')


	self.JobName 		= self.Player:GetJobName()
	self.JobNamePos 	= (w * 0.25)

	self.TimePlayed 	= ba.str.FormatTime(self.Player:GetPlayTime()) .. ' (' .. self.Player:GetPlayTimeRank() .. ')'
	self.TimePlayedPos 	= (w * 0.75)

	self.InfoCard:Update()
end	

function PANEL:SetPlayer(pl)
	self.Player = pl
	self.Avatar:SetPlayer(pl)
	self.InfoCard:SetPlayer(pl)
	self.Mute:SetMaterial(pl:IsBlocked() and micoff or micon)

	if (pl == LocalPlayer()) then
		self.Mute:SetVisible(false)
	end

	self:Update()
end


function PANEL:DrawNameNormal()

	if IsValid(self.Player) and self.Player:IsBlocked() then
		surface.SetTextColor(0, 0, 0, 255)
	else
		surface.SetTextColor(255, 255, 255, 255)
	end

	surface.DrawText(self.PlayerName)
end

function PANEL:DrawNameWanted()
	surface.SetTextColor(255, math.sin(CurTime() * math.pi) * 255, math.sin(CurTime() * math.pi) * 255, 255)
	surface.DrawText(self.PlayerName)
end

function PANEL:DrawNameDead(x)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(x, 15, self.PlayerNameSize, 1)

	surface.SetTextColor(0, 0, 0, 255)
	surface.DrawText(self.PlayerName)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(5, 0, 0, w, h, self.PlayerColor)

	local iconX, iconY = 32, 1
	local iconS = 28
	surface.SetDrawColor(255, 255, 255, 255)



	iconY = 3

	iconS = 24
	surface.SetMaterial(self.RankMaterial)
	surface.DrawTexturedRect(iconX, iconY, iconS, iconS)

	iconX = iconX + iconS + 4

	surface.SetFont('ui.17')
	surface.SetTextPos(iconX, 7)
	self:DrawName(iconX)

	surface.SetTextColor(255, 255, 255, 255)

	surface.SetTextPos(self.JobNamePos, 7)
	surface.DrawText(self.JobName)

	--if self.OrgName then
	--	surface.SetTextPos(self.OrgNamePos, 7)
	--	surface.DrawText(self.OrgName)
	--end

	surface.SetTextPos(self.TimePlayedPos, 7)
	surface.DrawText(self.TimePlayed)
end

vgui.Register('rp_scoreboard_player', PANEL, 'DButton')