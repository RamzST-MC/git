local discord = Material('sup/gui/generic/discord.png', 'smooth noclamp')
local rules = Material('sup/gui/generic/agenda.png', 'smooth noclamp')

local PANEL = {}

function PANEL:Init()
    self:SetText''
end

local f = ui.col.White:Copy()
f.a = 150

function PANEL:Paint(w, h)
    if self:IsHovered() then
        derma.SkinHook('Paint', 'TabButton', self, w, h)
    else
        draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)
        draw.RoundedBox(5, 0, 0, h, h, ui.col.Background)
    end

    surface.SetDrawColor(255, 255, 255, self.IsClaimed and 150 or 255)
    surface.SetMaterial(self.Material)
    surface.DrawTexturedRect(10, 10, h - 20, h - 20)
    local i = w * 0.5
    draw.SimpleText(self.Title, 'ui.22', i, h / 2 - 10, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.Description, 'ui.18', i, h / 2 + 10, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:DoClick()
    gui.OpenURL(self.URL)
end

function PANEL:Think()
    self:SetEnabled(self.IsClaimable or not self.IsClaimed)
end

vgui.Register('ba_reward_task', PANEL, 'DButton')

PANEL = {}

function PANEL:Init()
    self.Loading = true
    self.Title = ui.Create('ui_button', self)
    self.Title:SetText'Мы в социальных сетях'
    self.Title:SetEnabled(false)
    self.Title:Dock(TOP)
    self.Discord = ui.Create('ba_reward_task', self)
    self.Discord:Dock(TOP)
    self.Discord:DockMargin(0, 5, 0, 0)
    self.Discord.Title = 'Discord'
    self.Discord.Description = 'Вступите в наш Discord'
    self.Discord.Material = discord
    self.Discord.URL = rp.cfg.DiscordURL
    self.Rules = ui.Create('ba_reward_task', self)
    self.Rules:Dock(TOP)
    self.Rules:DockMargin(0, 5, 0, 0)
    self.Rules.Title = 'Правила'
    self.Rules.Description = 'Прочитайте правила перед игрой на сервере!'
    self.Rules.Material = rules
    self.Rules.URL = rp.cfg.RulesURL
end

function PANEL:PerformLayout(g, h)
    for k, l in ipairs(self:GetChildren()) do
        l:SetTall(64)
    end

    self.Title:SetTall(ui.SpacerHeight)
end

function PANEL:Paint(g, h)
    if self.Loading then
        draw.RoundedBox(5, 0, 0, g, h, ui.col.Background)
        local m = SysTime() * 5
        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawArc(g * 0.5, h * 0.5, 20, 25, m * 80, m * 80 + 180, 20)
    end
end

function PANEL:SetData(o)
    self.Loading = false
    self.Data = o
    self.Discord.IsClaimable = o.award_discord
    self.Discord.IsClaimed = o.award_discord_claimed
end

function PANEL:FetchData()
    ba.http.FetchJson('rewards/' .. LocalPlayer():SteamID64(), function(o)
        if not IsValid(self) then return end
        self:SetData(o)
    end)
end

vgui.Register('ba_rewards_panel', PANEL, 'Panel')