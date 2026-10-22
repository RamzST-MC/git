local a = {}
function a:SetAchievement(b)
	self.Achievement = b
end

local color_bar = ui.col.SUP:Copy()
color_bar.a = 25

local received = ui.col.Green:Copy()
received.a = 25

function a:Paint(w, h)
	if not self.Achievement then return end

	draw.RoundedBox(8, 0, 0, w, h, Color(30, 30, 40, 240))

	local hasAchievement = LocalPlayer():HasAchievement(self.Achievement.UID)
	local progress = self.Achievement.GetProgress and self.Achievement.GetProgress(self.Achievement, LocalPlayer()) or LocalPlayer():GetAchievementProgress(self.Achievement.UID)

	local buttonColor = hasAchievement and Color(60, 200, 120, 255) or Color(80, 80, 100, 255)
	draw.RoundedBoxEx(8, 0, 0, h, h, buttonColor, true, hasAchievement, true, hasAchievement)

	if (not hasAchievement) and progress then
		local barWidth = (w - 74) * progress / self.Achievement.Total
		draw.RoundedBoxEx(4, 74, h - 12, barWidth, 8, Color(100, 180, 255, 100), false, true, false, true)
	end

	if hasAchievement then
		draw.RoundedBoxEx(4, 74, h - 12, w - 74, 8, Color(100, 255, 150, 100), false, true, false, true)
	end

	if self.Achievement.Material then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.Achievement.Material)
		surface.DrawTexturedRect(5, 5, 64, 64)
	end

	local textX = (w * 0.5) + 32
	draw.SimpleText(self.Achievement.Name, 'ui.20', h + 5, 5, Color(255, 255, 255), 0, TEXT_ALIGN_TOP)
	draw.SimpleText(self.Achievement.Description .. (self.Achievement.Reward and (' - Награда ' .. self.Achievement.Reward) or ''), 'ui.18', h + 5, h * 0.5, Color(200, 200, 200), 0, TEXT_ALIGN_CENTER)

	if hasAchievement then
		draw.SimpleText('Получено!', 'ui.18', textX, h - 15, Color(255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	elseif progress then
		draw.SimpleText(self.Achievement.FormatProgress and self.Achievement.FormatProgress(self.Achievement, progress, self.Achievement.Total) or (string.Comma(math.floor(progress)) .. '/' .. string.Comma(self.Achievement.Total)), 'ui.18', w - 5, h / 2, Color(200, 220, 255), 2, 1)
	else
		draw.SimpleText(self.Achievement.FormatProgress and self.Achievement.FormatProgress(self.Achievement, 0, self.Achievement.Total) or ('0/' .. string.Comma(self.Achievement.Total)), 'ui.18', w - 5, h / 2, Color(200, 220, 255), 2, 1)
	end
end


vgui.Register('rp_achievement_button', a, 'Panel')
a = {}
function a:Init()
	self.List = ui.Create('ui_listview', self)
	self.List.Paint = function() end
	self.List:SetSpacing(5)
	self.Containers = {}
	local j = {}
	local k = {}
	local l = {}
	local m = {}
	for n, o in ipairs(rp.achievements.SortedList) do
		if LocalPlayer():HasAchievement(o.UID) then
			m[#m + 1] = o
		elseif not o.Disabled then
			if o.Reward then
				j[#j + 1] = o
			else
				k[#k + 1] = o
			end
		end
	end

	self.List:AddSpacer'С наградой'
	self:AddAchievements(j)
	self.List:AddSpacer'Незавершенные'
	self:AddAchievements(k)
	self.List:AddSpacer'Завершенные'
	self:AddAchievements(m)
end

function a:AddAchievements(t)
	local u = 0
	for n, o in ipairs(t) do
		if u == 0 then
			self.Cont = ui.Create('DPanel', function(v) v.Paint = function() end end)
			self.Containers[#self.Containers + 1] = self.Cont
			self.List:AddCustomRow(self.Cont)
		end

		ui.Create('rp_achievement_button', function(v)
			v:SetAchievement(o)
			v:Dock(LEFT)
			v:DockMargin(u == 1 and 2.5 or 0, 0, u == 0 and 2.5 or 0, 0)
		end, self.Cont)

		u = u == 1 and 0 or u + 1
	end
end

function a:PerformLayout(d, e)
	self.List:SetPos(5, 5)
	self.List:SetSize(d - 10, e - 10)
	for n, o in ipairs(self.Containers) do
		o:SetSize(self.List:GetWide(), 74)
		for u, w in ipairs(o:GetChildren()) do
			w:SetSize(o:GetWide() * 0.5 - 5, o:GetTall())
			w:SetPos((u - 1) * (w:GetWide() + 5), 0)
		end
	end
end

vgui.Register('rp_achievements', a, 'Panel')
net.Receive('rp.achievement.Finish', function()
	local ply = net.ReadEntity()
	local uid = net.ReadUInt(32)
	local tbl = rp.achievements.List[uid]
	hook.Call('AchievementFinished', nil, ply, tbl)
	chat.AddText(ply, ui.col.White, " получил достижение ", ui.col.Yellow, tbl.Name, ui.col.White, ' - ', ui.col.Yellow, tbl.Description)
end)
