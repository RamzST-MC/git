local a = {}
local b = utf8.char(0xf067)
local d = utf8.char(0xf32f)
local e = utf8.char(0xf028)
function a:Init()
self.Label = ui.Create('ui_button', self)
self.Label:SetText'Пати'
self.Label:SetEnabled(false)
self.Label:Dock(TOP)
self.Label.Corners = {true, true, false, false}
self.LeaveParty = ui.Create('ui_button', self.Label)
self.LeaveParty:SetFont'ui.16'
self.LeaveParty:SetText('Выйти')
self.LeaveParty:DockMargin(2.5, 2.5, 2.5, 2.5)
self.LeaveParty:Dock(RIGHT)
self.LeaveParty.DoClick = function(f) ui.BoolRequest('Выйти с пати', LocalPlayer():IsPartyLeader() and 'Вы действительно хотите выйти с пати? Пати будет распущена.' or 'Вы действительно хотите выйти с пати?', function(g) if g then cmd.Run('leaveparty') end end) end
self.SendInvite = ui.Create('ui_button', self.Label)
self.SendInvite:SetFont'ui.16'
self.SendInvite:SetText('Пригласить')
self.SendInvite:DockMargin(2.5, 2.5, 2.5, 2.5)
self.SendInvite:Dock(RIGHT)
self.SendInvite.DoClick = function(f)
ui.PlayerRequest(table.Filter(player.GetAll(), function(h)
return h ~= LocalPlayer() and h:GetParty() ~= LocalPlayer():GetParty() and !h:InParty()
end), function(i)
cmd.Run('inviteparty', i:SteamID())
end)
end
self.CreateParty = ui.Create('ui_button', self.Label)
self.CreateParty:SetText'Создать'
self.CreateParty:DockMargin(2.5, 2.5, 2.5, 2.5)
self.CreateParty:Dock(RIGHT)
self.CreateParty.DoClick = function(f)
    ui.StringRequest('Создать пати', 'Как вы назовете свою пати?', '', function(m)
        cmd.Run('createparty', m)
    end)
end

self.PartyMembers = ui.Create('ui_listview', self)
self.PartyMembers.PaintOver = function(f, n, o)
    if not LocalPlayer():InParty() then
        draw.RoundedBoxEx(5, 0, 0, n, o, ui.col.Background, false, false, true, true)
        draw.SimpleText('Вы не в пати!', 'ui.24', n * 0.5, o * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

self.PartyMembers:Dock(FILL)
if LocalPlayer():InParty() then self:PopulateMembers() end
hook('nw.Party', self, function(self, i, k, l)
    if i == LocalPlayer() or k == LocalPlayer():GetParty() then
        self.PartyMembers:Reset()
        if k ~= nil then self:PopulateMembers(k) end
    end
end)
end
local p = utf8.char(0xf005)
local q = utf8.char(0xf123)
function a:PopulateMembers(r)
for s, h in ipairs(rp.parties.GetPlayers(r or LocalPlayer():GetParty())) do
local t = self.PartyMembers:AddPlayer(h)
t.DoClick = function(f)
local u, v = LocalPlayer():IsPartyLeader(), LocalPlayer():IsPartyCoLeader()
if h == LocalPlayer() or not (u or v) then return end
local w = ui.DermaMenu(f)
if (u or v) and not h:IsPartyLeader() then
w:AddOption('Кикнуть', function()
f:Remove()
if IsValid(h) then cmd.Run('kickparty', h:SteamID()) end
end)
end
        if u then
            if not h:IsPartyCoLeader() then
                w:AddOption('Повысить до совладельца', function() if IsValid(h) then cmd.Run('promotecoleader', h:SteamID()) end end)
            else
                w:AddOption('Понизить совладельца', function() if IsValid(h) then cmd.Run('demotecoleader', h:SteamID()) end end)
            end

            w:AddOption('Передать права пати', function()
                f:Remove()
                if IsValid(h) then cmd.Run('transferparty', h:SteamID()) end
            end)
        end

        w:Open()
    end

    t.PaintOver = function(s, w, hh)
        if h:IsPartyLeader() then
            draw.Material(27.5, 2.5, 25, 25, eclipse.mat.Star)
        elseif h:IsPartyCoLeader() then
            draw.Material(27.5, 2.5, 25, 25, eclipse.mat.StarHalf)
        end

        --draw.SimpleText(h:IsPartyVoiceEnabled() and e or d, 'ui.16', w - 5, hh * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end
end
function a:Think()
local x = LocalPlayer():InParty()
self.LeaveParty:SetVisible(x)
self.SendInvite:SetVisible(x and (LocalPlayer():IsPartyLeader() or LocalPlayer():IsPartyCoLeader()))
-- self.ToggleVoice:SetVisible(x)
self.CreateParty:SetVisible(not x)
end
function a:PerformLayout(n, o)
self.Label:SetTall(ui.SpacerHeight)
local y = ui.SpacerHeight - 5
self.LeaveParty:SetWide(self.LeaveParty:GetWide() + 10)
self.SendInvite:SetWide(self.SendInvite:GetWide() + 10)
-- self.ToggleVoice:SetWide(y)
self.CreateParty:SizeToContentsX()
self.CreateParty:SetWide(self.CreateParty:GetWide() + 10)
end
vgui.Register('rp_parties_panel', a, 'Panel')
cvar.Register'disable_party_outlines'
:SetDefault(false, true)
:AddMetadata('Catagory', 'Пати')
:AddMetadata('Menu', 'Выключить обводку соучастникам пати')
hook.Add('SetupOutlines', 'rp::parties::outline', function()
for k, v in ipairs(player.GetAll()) do
if IsValid(v) and v:Alive() and LocalPlayer():InParty() and v:GetParty() == LocalPlayer():GetParty() and v != LocalPlayer() and !cvar.GetValue('disable_party_outlines') then
outline.Add(v, ui.col.Green, outline.MODE_BOTH)
end
if IsValid(v) and v:Alive() and v:HasHit() and LocalPlayer():IsHitman() then
outline.Add(v, ui.col.Red, outline.MODE_VISIBLE)
end
end
end)