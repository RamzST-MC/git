-- ╔══════════════════════════════════╗
-- ║   F4 MENU BUTTONS CONFIG         ║
-- ╚══════════════════════════════════╝
F4Buttons = F4Buttons or {}
F4Buttons = {
    Actions      = { enabled = true,  disabled = false }, -- Вкладка "Действия"
    Jobs         = { enabled = true,  disabled = false }, -- Вкладка "Работы"
    Shop         = { enabled = true,  disabled = false }, -- Вкладка "Магазин"
    Cosmetics    = { enabled = true,  disabled = false }, -- Вкладка "Аксессуары"
    Orgs         = { enabled = true,  disabled = false }, -- Вкладка "Организации"

    Donat        = { enabled = true,  disabled = false }, -- Кнопка "Донат"
    Achievements = { enabled = true,  disabled = false }, -- Кнопка "Достижения"
    Settings     = { enabled = true,  disabled = false }, -- Кнопка "Настройки"
    Discord      = { enabled = true,  disabled = false }, -- Кнопка "Discord"
    Steam        = { enabled = true,  disabled = false }, -- Кнопка "Steam"
    Rules        = { enabled = true,  disabled = false }, -- Кнопка "Правила"
}

-- Ссылка на правила сервера
local RulesURL = 'https://docs.google.com/document/d/1QfS-w6wHjBwPsIHJUXfP8RrqMYG7yZEdKa-eieESscU/edit?usp=sharing'
-- enabled = false  -> кнопка полностью скрыта
-- disabled = true  -> кнопка видна но некликабельна (серая)

local id = 1
local fr

local txt1 = ''
local txt2 = ''

function rp.ToggleF4Menu(c)
    if IsValid(fr) then
        fr:Close()

        return
    end

    local d, e = math.Clamp(ScrW() * 0.75, 1100, ScrW()), math.Clamp(ScrH() * 0.7, 575, ScrH())

    fr = ui.Create('ui_frame', function(self)
        self:SetTitle('')
        self:SetSize(d, e)
        self:MakePopup()
        self:Center()
        local f = false

        function self:Think()
            if input.IsKeyDown(KEY_F4) and f then
                self:Close()
            elseif not input.IsKeyDown(KEY_F4) then
                f = true
            end
        end

        function self:OnClose()
            id = self.tabs:GetActiveTabID()
--            net.Ping('rp.CloseF4Menu')
        end

        -- название и метка в шапке F4 убраны (раньше здесь рисовались txt1 / txt2)
    end)

    fr.tabs = ui.Create('ui_tablist', fr)
    fr.tabs:DockToFrame()
    fr.tabs.tabList:DockMargin(5, 5, 5, ui.SpacerHeight * 3 + 30)

    if F4Buttons.Actions.enabled then
        local tabAct = fr.tabs:AddTab('Действия', function(self)
            if F4Buttons.Actions.disabled then return end
            return ui.Create'rp_commandlist'
        end)
        tabAct:SetImage'divergent/ui/hud/f4/actions.png'
        if F4Buttons.Actions.disabled then tabAct:SetAlpha(120) tabAct:SetCursor('no') end
    end

    if F4Buttons.Jobs.enabled then
        local tabJobs = fr.tabs:AddTab('Работы', function(self)
            if F4Buttons.Jobs.disabled then return end
            return ui.Create'rp_jobslist'
        end)
        tabJobs:SetImage'divergent/ui/hud/f4/jobs.png'
        if F4Buttons.Jobs.disabled then tabJobs:SetAlpha(120) tabJobs:SetCursor('no') end
    end

    if F4Buttons.Shop.enabled then
        local tabShop = fr.tabs:AddTab('Магазин', function(self)
            if F4Buttons.Shop.disabled then return end
            return ui.Create'rp_shoplist'
        end)
        tabShop:SetImage'divergent/ui/hud/f4/shop.png'
        if F4Buttons.Shop.disabled then tabShop:SetAlpha(120) tabShop:SetCursor('no') end
    end

    if F4Buttons.Cosmetics.enabled then
        local h
        local tabCos = fr.tabs:AddTab('Аксессуары', function(self)
            if F4Buttons.Cosmetics.disabled then return end
            h = ui.Create 'rp_hatspanel'
            return h
        end)
        tabCos:SetImage'divergent/ui/hud/f4/cosmetics.png'
        if F4Buttons.Cosmetics.disabled then tabCos:SetAlpha(120) tabCos:SetCursor('no') end
    end

    hook.Call('PopulateF4Tabs', GAMEMODE, fr.tabs, fr)
    
    local k = ui.Create('Panel', fr)
    k:SetSize(150, ui.SpacerHeight * 6 + 30)
    k:SetPos(5, fr:GetTall() - k:GetTall())

    if F4Buttons.Donat.enabled then
        local l = fr.tabs:AddButton('Донат', function()
            if F4Buttons.Donat.disabled then return end
            IGS.UI()
            rp.ToggleF4Menu()
        end)
        l:SetImage'divergent/ui/hud/icons/coin.png'
        l:SetParent(k)
        l:DockMargin(0, 0, 0, 0)
        l:SetTall(ui.SpacerHeight)
        l:Dock(TOP)
        if F4Buttons.Donat.disabled then l:SetAlpha(120) l:SetCursor('no') end
    end

    if F4Buttons.Achievements.enabled then
        local m = fr.tabs:AddTab('Достижения', function(self)
            if F4Buttons.Achievements.disabled then return end
            return ui.Create'rp_achievements'
        end)
        m:SetImage'divergent/ui/hud/f4/achievement.png'
        m:SetParent(k)
        m:DockMargin(0, 5, 0, 0)
        m:SetTall(ui.SpacerHeight)
        m:Dock(TOP)
        if F4Buttons.Achievements.disabled then m:SetAlpha(120) m:SetCursor('no') end
    end

    if F4Buttons.Settings.enabled then
        local n = fr.tabs:AddTab('Настройки', function(self)
            if F4Buttons.Settings.disabled then return end
            return ui.Create'rp_settings'
        end)
        n:SetImage'divergent/ui/hud/f4/settings.png'
        n:SetParent(k)
        n:DockMargin(0, 5, 0, 0)
        n:SetTall(ui.SpacerHeight)
        n:Dock(TOP)
        if F4Buttons.Settings.disabled then n:SetAlpha(120) n:SetCursor('no') end
    end

    local function newF4Btn(label, img, action)
        local btn = ui.Create('ui_button', k)
        btn:SetText(label)
        btn:SetImage(img)
        btn:SetParent(k)
        btn:DockMargin(0, 5, 0, 0)
        btn:Dock(TOP)
        btn.DoClick = function()
            if isfunction(action) then action() else gui.OpenURL(action) end
        end
        return btn
    end

    local function newF4BtnSized(cfgKey, label, img, action)
        if not F4Buttons[cfgKey].enabled then return end
        local btn = newF4Btn(label, img, action)
        btn:SetTall(ui.SpacerHeight)
        if F4Buttons[cfgKey].disabled then
            btn:SetAlpha(120)
            btn:SetCursor('no')
            btn.DoClick = function() end
        end
        return btn
    end
    newF4BtnSized('Discord', 'Discord', 'divergent/ui/hud/icons/discord.png', rp.cfg.DiscordURL or '')
    newF4BtnSized('Steam',   'Steam',   'divergent/ui/scoreboard/steam.png',  rp.cfg.SteamURL or '')
    newF4BtnSized('Rules',   'Правила', 'divergent/ui/scoreboard/credits.png', RulesURL)


    if not c then
        fr.tabs:SetActiveTab(id)
    else
        fr.tabs:SetActiveTab(9)
    end

    if IsValid(i) then
        i:AddControls(fr)
    end

    if IsValid(h) then
        h:AddControls(fr)
    end

    if IsValid(g) then
        g:AddControls(fr)
    end

    function fr.tabs:TabChanged(o)
        if IsValid(fr) then
            if IsValid(i) then
                if o ~= i then
                    i:HideControls()
                else
                    i:AddControls(fr)
                end
            end

            if IsValid(h) then
                if o ~= h then
                    h:HideControls()
                else
                    h:AddControls(fr)
                end
            end

            if IsValid(g) then
                if o ~= g then
                    g:HideControls()
                else
                    g:AddControls(fr)
                end
            end

            hook.Call('F4TabChanged', nil, o)
        end
    end
end

local PANEL = {}

function PANEL:Init()
    self.HTML = ui.Create("DHTML", self)

    self.HTML.Paint = function(self, w, h)
        draw.Box(0, 0, w, h, color_white)
    end

    self.HTML:OpenURL(rp.cfg.RulesURL)
end

function PANEL:PerformLayout()
    self.HTML:SetPos(5, 5)
    self.HTML:SetSize(self:GetWide() - 10, self:GetTall() - 10)
end

function GM:ShowSpare2()
    rp.ToggleF4Menu()
end

vgui.Register('rp_rulespanel', PANEL, 'Panel')