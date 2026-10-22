local draw = draw
local team = team
local IsValid = IsValid
local CurTime = CurTime
PLAYER.GetJobColor = PLAYER.GetJobColor or function(self) return team.GetColor(self:Team()) end
local PANEL = {}
local PlayerVoicePanels = {}
local material_mic = Material'sup/hud/istalking'
local material_muted = Material'materials/sup/gui/generic/micoff.png'
local color_white = Color(255, 255, 255)
local color_bg = Color(0, 0, 0)
local color_outline = Color(20, 20, 20)
local color_vis_outline = Color(200, 200, 200)
local color_vis_bg = Color(40, 40, 40)
function PANEL:Init()
	self.LabelName = ui.Create('DLabel', self)
	self.LabelName:SetFont('ui.15')
	self.LabelName:SetTextColor(color_white)
	self.Avatar = ui.Create('ui_imagebutton', self)
	self.Info = ui.Create('DLabel', self)
	self.Info:SetFont('ui.12')
	self.Info:SetTextColor(ui.col.LightGrey)
	self.Color = color_transparent
	self.LastThink = CurTime()
	self:SetTall(40)
	self:DockPadding(4, 4, 4, 4)
	self:DockMargin(2, 2, 2, 2)
	self:Dock(BOTTOM)
end

function PANEL:Setup(pl)
	local data = hook.Call('PlayerGetVoiceData', nil, pl) or {}
	self.pl = pl
	self.Avatar:SetPlayer(pl)
	self.LabelName:SetText(data.Name or pl:Name())
	self.LabelName:SizeToContents()
	self.Info:SetText(data.Info or pl:GetOrg() or "")
	self.Info:SizeToContents()
	self.OutlineColor = data.OutlineColor or pl:GetJobColor()
	self.Color = pl:GetJobColor()
	self:InvalidateLayout()
end

function PANEL:PerformLayout(w, h)
	self.Avatar:SetPos(4, 4)
	self.Avatar:SetSize(h - 8, h - 8)
	local x, y = self.Avatar:GetPos()
	x, y = h * 0.5, y + self.Avatar:GetWide() + 4
	self.LabelName:SetPos(y, x - ((self.Info:GetText() == "") and (self.LabelName:GetTall() * 0.5) or (self.LabelName:GetTall() - 2)))
	self.Info:SetPos(y, x)
end

function PANEL:Paint(w, h)
	if (not IsValid(self.pl)) or (hook.Call('HUDShouldDraw', nil, 'VoiceBox') == false) then return end
	local x, y = self:LocalToScreen(0, 0)
	local pl = self.pl
	self.Color = ui.col.Button:Copy()
	self.Color.a = 195
	draw.DrawBlur(4, x, y, w, h, nil, self.Color)
end

function PANEL:Think()
	if IsValid(self.pl) then self.LabelName:SetText(self.pl:Name()) end
	if self.fadeAnim then self.fadeAnim:Run() end
end

function PANEL:FadeOut(anim, delta, data)
	if anim.Finished then
		if IsValid(PlayerVoicePanels[self.pl]) then
			PlayerVoicePanels[self.pl]:Remove()
			PlayerVoicePanels[self.pl] = nil
			return
		end
		return
	end

	self:SetAlpha(255 - (255 * delta))
end

derma.DefineControl('ba_VoiceNotify', '', PANEL, 'DPanel')
hook.Add('PlayerStartVoice', 'ba.voicestart.vvis', function(pl)
	print("Начал говорить:", pl)
	if not IsValid(ba.VoiceVis) then return end
	GAMEMODE:PlayerEndVoice(pl)
	if IsValid(PlayerVoicePanels[pl]) then
		if PlayerVoicePanels[pl].fadeAnim then
			PlayerVoicePanels[pl].fadeAnim:Stop()
			PlayerVoicePanels[pl].fadeAnim = nil
		end

		PlayerVoicePanels[pl]:SetAlpha(255)
		return
	end

	if not IsValid(pl) then return end
	local pnl = ba.VoiceVis:Add('ba_VoiceNotify')
	pnl:Setup(pl)
	PlayerVoicePanels[pl] = pnl
end)

hook.Add('PlayerEndVoice', 'ba.voiceend.vvis', function(pl)
	print("ПИЗДА говорить:", pl)
	if IsValid(PlayerVoicePanels[pl]) then
		if PlayerVoicePanels[pl].fadeAnim then return end
		PlayerVoicePanels[pl].fadeAnim = Derma_Anim('FadeOut', PlayerVoicePanels[pl], PlayerVoicePanels[pl].FadeOut)
		PlayerVoicePanels[pl].fadeAnim:Start(1)
	end
end)

timer.Create('VoiceClean', 10, 0, function()
	for k, v in pairs(PlayerVoicePanels) do
		if not IsValid(k) then GAMEMODE:PlayerEndVoice(k) end
	end
end)

if IsValid(ba.VoiceVis) then ba.VoiceVis:Remove() end
ba.VoiceVis = vgui.Create('DPanel')
ba.VoiceVis:ParentToHUD()
ba.VoiceVis:SetPos(ScrW() - 200, 100)
ba.VoiceVis:SetSize(175, ScrH() - 200)
ba.VoiceVis.Paint = function() end
hook.Add("Think", "ba.VoiceUI.RemoveDefaultVoicePanel", function()
	if IsValid(g_VoicePanelList) then g_VoicePanelList:Remove() end
	hook.Remove("Think", "ba.VoiceUI.RemoveDefaultVoicePanel")
end)