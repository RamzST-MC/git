-- "addons\\_dev\\lua\\autorun\\client\\cl_qmenu.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

function PANEL:Init()
    self.PanelList = vgui.Create("DPanelList", self)
    self.PanelList:SetPadding(4)
    self.PanelList:SetSpacing(2)
    self.PanelList:EnableVerticalScrollbar(true)
    self:BuildList()
end

local function AddComma(n)
    local sn = tostring(n)
    sn = string.ToTable(sn)
    local tab = {}

    for i = 0, #sn - 1 do
        if i % 3 == #sn % 3 and not (i == 0) then
            table.insert(tab, ",")
        end

        table.insert(tab, sn[i + 1])
    end

    return string.Implode("", tab)
end

function PANEL:BuildList()
    self.PanelList:Clear()


    for CategoryName, _ in SortedPairs(PropWhiteList, true) do
        local Category = vgui.Create("DCollapsibleCategory", self)
        self.PanelList:AddItem(Category)
        Category:SetExpanded(false)
        Category:SetLabel(CategoryName)
        Category:SetCookieName("EntitySpawn." .. CategoryName)

        local Content = vgui.Create("DPanelList")
        Category:SetContents(Content)
        Content:EnableHorizontal(true)
        Content:SetDrawBackground(false)
        Content:SetSpacing(2)
        Content:SetPadding(2)
        Content:SetAutoSize(true)
        number = 1

        Category:DockMargin(0, 0, draw.Weight(5), draw.Height(10))
        Category.Header:SetTall(draw.Height(40))
        Category:SetLabel('')
        Category.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, ColorAlpha(ui.col.Button:Copy(), 125))

            draw.SimpleText(CategoryName, 'ui.16', draw.Weight(15), draw.Height(20), color_white, 0,
                1)
        end

        local number = 1

        for k, v in pairs(PropWhiteList[CategoryName]) do
            local Icon = vgui.Create("ModelImage", self)
            local Model = v
            Icon:DockMargin(0, 0, 0, draw.Height(10))
            Icon:SetModel(v)

            Icon.Hover = 0
            Icon.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(engine.TickInterval(), self.Hover, 255)
                else
                    self.Hover = Lerp(engine.TickInterval(), self.Hover, 0)
                end

                draw.RoundedBox(8, 0, 0, w, h, ColorAlpha(ui.col.SUP:Copy(), self.Hover))
            end

            Icon.OnMousePressed = function(self, key)
                if key == MOUSE_LEFT then
                    RunConsoleCommand("gm_spawn", Model)
                end
            end

            local lable = vgui.Create("DLabel", Icon)
            lable:SetFont("DebugFixedSmall")
            lable:SetTextColor(color_black)
            lable:SetText(Model)
            lable:SetContentAlignment(5)
            lable:SetWide(self:GetWide())
            lable:AlignBottom(-42)
            Content:AddItem(Icon)
            number = number + 1
        end
    end

    self.PanelList:InvalidateLayout()
end

function PANEL:PerformLayout()
    self.PanelList:StretchToParent(0, 0, 0, 0)
end

local CreationSheet = vgui.RegisterTable(PANEL, "Panel")
local function CreateContentPanel()
    local ctrl = vgui.CreateFromTable(CreationSheet)

    return ctrl
end

local function RemoveSandboxTabs()
    local DonateGroup = {"stadmin", "sudo-root", "superadmin", 'sponsor', 'helper', 'moderator', 'operator'}
    local NaborGroup = {"root"}
    local tabstoremove = {language.GetPhrase("spawnmenu.content_tab"), language.GetPhrase("spawnmenu.category.npcs"), language.GetPhrase("spawnmenu.category.entities"), language.GetPhrase("spawnmenu.category.weapons"), language.GetPhrase("spawnmenu.category.vehicles"), language.GetPhrase("spawnmenu.category.postprocess"), language.GetPhrase("spawnmenu.category.dupes"), language.GetPhrase("spawnmenu.category.saves")}
    local removeqmen = {language.GetPhrase("spawnmenu.content_tab"), language.GetPhrase("spawnmenu.category.npcs"), language.GetPhrase("spawnmenu.category.entities"), language.GetPhrase("spawnmenu.category.postprocess"), language.GetPhrase("spawnmenu.category.dupes"), language.GetPhrase("spawnmenu.category.saves")}
    local tabstoremoveSup = {language.GetPhrase("spawnmenu.content_tab"), language.GetPhrase("spawnmenu.category.npcs"), language.GetPhrase("spawnmenu.category.entities"), language.GetPhrase("spawnmenu.category.vehicles"), language.GetPhrase("spawnmenu.category.postprocess"), language.GetPhrase("spawnmenu.category.dupes"), language.GetPhrase("spawnmenu.category.saves")}
    local tabstoremoveadmSup = {language.GetPhrase("spawnmenu.content_tab"), language.GetPhrase("spawnmenu.category.npcs"), language.GetPhrase("spawnmenu.category.postprocess"), language.GetPhrase("spawnmenu.category.dupes"), language.GetPhrase("spawnmenu.category.saves")}
    if LocalPlayer():GetRank() == 'root' then return end
    if table.HasValue(DonateGroup, LocalPlayer():GetUserGroup()) then
        for k, v in pairs(g_SpawnMenu.CreateMenu.Items) do
            if table.HasValue(tabstoremoveSup, v.Tab:GetText()) then
                g_SpawnMenu.CreateMenu:CloseTab(v.Tab, true)
                RemoveSandboxTabs()
            end
        end
    elseif table.HasValue(NaborGroup, LocalPlayer():GetUserGroup()) then
        for k, v in pairs(g_SpawnMenu.CreateMenu.Items) do
            if table.HasValue(tabstoremoveadmSup, v.Tab:GetText()) then
                g_SpawnMenu.CreateMenu:CloseTab(v.Tab, true)
                RemoveSandboxTabs()
            end
        end
    elseif LocalPlayer():HasPurchase('fullqmenuaccess') then
        for k, v in pairs(g_SpawnMenu.CreateMenu.Items) do
            if table.HasValue(removeqmen, v.Tab:GetText()) then
                g_SpawnMenu.CreateMenu:CloseTab(v.Tab, true)
                RemoveSandboxTabs()
            end
        end
    else
        for k, v in pairs(g_SpawnMenu.CreateMenu.Items) do
            if table.HasValue(tabstoremove, v.Tab:GetText()) then
                g_SpawnMenu.CreateMenu:CloseTab(v.Tab, true)
                RemoveSandboxTabs()
            end
        end
    end
end

hook.Add("SpawnMenuOpen", "blockmenutabs", RemoveSandboxTabs)
spawnmenu.AddCreationTab("Разрешенные пропы", CreateContentPanel, "icon16/application_view_tile.png", 4)

concommand.Add('mb', function()
    print(LocalPlayer():GetNetVar('PropsCount'))
end)