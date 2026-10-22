-- leak by lordee
if not CLIENT then return end
zyb = zyb or {}
zyb.f = zyb.f or {}
zyb.f.vgui = zyb.f.vgui or {}

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

local zyb_UpgradeInterface = {}
local zyb_Upgrade_Main = {}
local zyb_Upgrade_Actions = {}

-- This gets called when we open the npc interface
net.Receive("zyb_UpgradeMenu_Open_net", function(len)
    local condenser_ent = net.ReadEntity()
    local dataLength = net.ReadUInt(16)
    local boardDecompressed = util.Decompress(net.ReadData(dataLength))
    local installedUpgradIDs = util.JSONToTable(boardDecompressed)
    zyb_Upgrade_Actions.OpenUI(condenser_ent, installedUpgradIDs)
end)

net.Receive("zyb_UpgradeMenu_ForceClose_net", function(len)
    zyb_Upgrade_Actions.CloseUI()
end)


-- Main Actions
function zyb_Upgrade_Actions.OpenUI(condenser_ent, installedUpgradIDs)
    LocalPlayer().zyb_Condenser = condenser_ent
    LocalPlayer().zyb_InstalledUpgrades = installedUpgradIDs
    LocalPlayer().zyb_SelectedUpgrade = 1
    LocalPlayer().zyb_SelectedUpgrade_Installed = false

    if IsValid(zyb_UpgradeInterface_panel) then
        zyb_UpgradeInterface_panel:Remove()
    end

    zyb_UpgradeInterface_panel = vgui.Create("zyb_vgui_UpgradeInterface")
end

function zyb_Upgrade_Actions.CloseUI()
    LocalPlayer().zyb_Condenser = nil

    if IsValid(zyb_UpgradeInterface_panel) then
        zyb_UpgradeInterface_panel:Remove()
    end

    zyb.f.Debug("Closed Condenser Interface")
end

function zyb_Upgrade_Actions.SelectUpgrade(u_id,installed)
    LocalPlayer().zyb_SelectedUpgrade = u_id
    LocalPlayer().zyb_SelectedUpgrade_Installed = installed

    local upgradeData

    if LocalPlayer().zyb_SelectedUpgrade_Installed then
        upgradeData = zyb.config.Upgrades[LocalPlayer().zyb_InstalledUpgrades[LocalPlayer().zyb_SelectedUpgrade]]
    else
        upgradeData = zyb.config.Upgrades[LocalPlayer().zyb_SelectedUpgrade]
    end


    zyb_Upgrade_Main.ItemInfo_Model:SetColor(upgradeData.u_color)
    zyb_Upgrade_Main.ItemInfo_Title:SetText(upgradeData.u_name)
    zyb_Upgrade_Main.ItemInfo_Price:SetText(zyb.config.Currency .. upgradeData.u_price)
    zyb_Upgrade_Main.ItemInfo_Desc:SetText(upgradeData.u_desc)

    local amountInfo = "nil"
    if upgradeData.u_type == 1 then
        amountInfo = zyb.language.VGUI["Speed"] .. ": +" .. 100 * upgradeData.u_amount .. "%"
        zyb_Upgrade_Main.ItemInfo_IconBG.mat = zyb.default_materials["speedboost"]
    elseif upgradeData.u_type == 2 then
        amountInfo = zyb.language.VGUI["Production"] .. ": +" .. 100 * upgradeData.u_amount .. "%"
        zyb_Upgrade_Main.ItemInfo_IconBG.mat = zyb.default_materials["productionboost"]
    end

    zyb_Upgrade_Main.ItemInfo_amount:SetText(amountInfo)

    if table.Count(upgradeData.u_ranks) > 0 then

        zyb_Upgrade_Main.ItemInfo_ranks:SetText(zyb.language.VGUI["Ranks"] .. ": " .. zyb.f.KeyTableConcat(upgradeData.u_ranks, ","))
    else
        zyb_Upgrade_Main.ItemInfo_ranks:SetText("")
    end

    if LocalPlayer().zyb_SelectedUpgrade_Installed then
        zyb_Upgrade_Main.BuyButton:SetVisible(false)
        zyb_Upgrade_Main.SellButton:SetVisible(true)
    else
        zyb_Upgrade_Main.BuyButton:SetVisible(true)
        zyb_Upgrade_Main.SellButton:SetVisible(false)
    end
end

function zyb_Upgrade_Actions.BuyUpgrade()
    if table.Count(LocalPlayer().zyb_InstalledUpgrades) >= 3 then
        notification.AddLegacy( zyb.language.VGUI["UpgradeLimitReached"], NOTIFY_ERROR, 2 )
        surface.PlaySound( "buttons/button15.wav" )
        return
    end

    if zyb.config.Upgrade.Stacking == false and zyb.f.HasModuleType(LocalPlayer().zyb_InstalledUpgrades,LocalPlayer().zyb_SelectedUpgrade)  then
        notification.AddLegacy( zyb.language.VGUI["UpgradeTypeLimitReached"], NOTIFY_ERROR, 3 )
        surface.PlaySound( "buttons/button15.wav" )
        return
    end

    net.Start("zyb_UpgradeMenu_Buy_net")
    net.WriteEntity(LocalPlayer().zyb_Condenser)
    net.WriteInt(LocalPlayer().zyb_SelectedUpgrade,16)
    net.SendToServer()

    zyb_Upgrade_Actions.CloseUI()
end

function zyb_Upgrade_Actions.SellUpgrade()
    net.Start("zyb_UpgradeMenu_Sell_net")
    net.WriteEntity(LocalPlayer().zyb_Condenser)
    net.WriteInt(LocalPlayer().zyb_SelectedUpgrade,16)
    net.SendToServer()

    zyb_Upgrade_Actions.CloseUI()
end


--///// INIT //////////////////
function zyb_UpgradeInterface:Init()
    self:SetSize(920 * wMod, 500 * hMod)
    self:Center()
    self:MakePopup()
    self:SetDraggable(false)
    self:SetSizable(false)
    self:ShowCloseButton(false)
    self:SetTitle("")

    zyb_Upgrade_Main.Title = vgui.Create("DLabel", self)
    zyb_Upgrade_Main.Title:SetPos(10 * wMod,2 * hMod)
    zyb_Upgrade_Main.Title:SetSize(500 * wMod, 45 * hMod)
    zyb_Upgrade_Main.Title:SetText(zyb.language.VGUI["UpgradeMenu"])
    zyb_Upgrade_Main.Title:SetFont("zyb_upgrade_vgui_font05")
    zyb_Upgrade_Main.Title:SetContentAlignment(7)
    zyb_Upgrade_Main.Title:SetTextColor(zyb.default_colors["orange05"])

    zyb_Upgrade_Main.CloseButton = vgui.Create("DButton", self)
    zyb_Upgrade_Main.CloseButton:SetPos(870 * wMod, 10 * hMod)
    zyb_Upgrade_Main.CloseButton:SetSize(40 * wMod, 40 * hMod)
    zyb_Upgrade_Main.CloseButton:SetText("")

    zyb_Upgrade_Main.CloseButton.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(5, 0, 0, w, h, zyb.default_colors["CloseButton_hover"])
        else
            draw.RoundedBox(5, 0, 0, w, h, zyb.default_colors["CloseButton_normal"])
        end
    end

    zyb_Upgrade_Main.CloseButton.DoClick = function()
        zyb_Upgrade_Actions.CloseUI()
    end

    zyb.f.vgui.UpgradeShop(self)
    zyb.f.vgui.ItemInfo(self)
    zyb.f.vgui.InstalledItems(self)

    zyb_Upgrade_Actions.SelectUpgrade(1,false)
end

function zyb_UpgradeInterface:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, zyb.default_colors["grey02"])
end

function zyb.f.vgui.UpgradeShop(parent)

    if zyb_Upgrade_Main and IsValid(zyb_Upgrade_Main.UpgradeShopPanel) then
        zyb_Upgrade_Main.UpgradeShopPanel:Remove()
    end

    zyb_Upgrade_Main.UpgradeShopPanel = vgui.Create("DPanel", parent)
    zyb_Upgrade_Main.UpgradeShopPanel:SetPos(0 * wMod, 60 * hMod)
    zyb_Upgrade_Main.UpgradeShopPanel:SetSize(300 * wMod, 440 * hMod)
    zyb_Upgrade_Main.UpgradeShopPanel:SetBackgroundColor(zyb.default_colors["black02"])

    zyb_Upgrade_Main.InfoPanel = vgui.Create("DPanel", zyb_Upgrade_Main.UpgradeShopPanel)
    zyb_Upgrade_Main.InfoPanel:SetPos(0 * wMod, 0 * hMod)
    zyb_Upgrade_Main.InfoPanel:SetSize(300 * wMod, 40 * hMod)
    zyb_Upgrade_Main.InfoPanel:SetBackgroundColor(zyb.default_colors["black03"])


    zyb_Upgrade_Main.ShopTitle = vgui.Create("DLabel", zyb_Upgrade_Main.InfoPanel)
    zyb_Upgrade_Main.ShopTitle:SetPos(10 * wMod, 0 * hMod)
    zyb_Upgrade_Main.ShopTitle:SetSize(500 * wMod, 45 * hMod)
    zyb_Upgrade_Main.ShopTitle:SetText(zyb.language.VGUI["Shop"])
    zyb_Upgrade_Main.ShopTitle:SetFont("zyb_upgrade_vgui_font01")
    zyb_Upgrade_Main.ShopTitle:SetContentAlignment(7)
    zyb_Upgrade_Main.ShopTitle:SetTextColor(zyb.default_colors["white01"])


    zyb_UpgradeShop_Items = {}
    zyb_UpgradeShop_Items.panel = vgui.Create("DScrollPanel", zyb_Upgrade_Main.UpgradeShopPanel)
    zyb_UpgradeShop_Items.panel:DockMargin(0 * wMod, 45 * hMod, 0 * wMod, 0 * hMod)
    zyb_UpgradeShop_Items.panel:Dock(FILL)

    zyb_UpgradeShop_Items.panel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["black03"])
    end

    local abar = zyb_UpgradeShop_Items.panel:GetVBar()

    function abar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["black03"])
    end

    function abar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["grey04"])
    end

    function abar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h,zyb.default_colors["grey04"])
    end

    function abar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["grey05"])
    end

    zyb.f.vgui.Build_Shopitems()
end

function zyb.f.vgui.Build_Shopitems()
    if zyb_UpgradeShop_Items and IsValid(zyb_UpgradeShop_Items.list) then
        zyb_UpgradeShop_Items.list:Remove()
    end

    if zyb_UpgradeShop_Items and IsValid(zyb_UpgradeShop_Items.panel) then
        zyb_UpgradeShop_Items.list = vgui.Create("DIconLayout", zyb_UpgradeShop_Items.panel)
        zyb_UpgradeShop_Items.list:SetSize(280 * wMod, 705 * hMod)
        zyb_UpgradeShop_Items.list:SetPos(10 * wMod, 10 * hMod)
        zyb_UpgradeShop_Items.list:SetSpaceY(10)

        for i = 1, table.Count(zyb.config.Upgrades) do
            local upgradeData = zyb.config.Upgrades[i]
            zyb_UpgradeShop_Items[i] = zyb_UpgradeShop_Items.list:Add("DFrame")
            zyb_UpgradeShop_Items[i]:SetSizable(false)
            zyb_UpgradeShop_Items[i]:SetTitle("")
            zyb_UpgradeShop_Items[i]:ShowCloseButton(false)
            zyb_UpgradeShop_Items[i]:SetDraggable(false)
            zyb_UpgradeShop_Items[i]:SetSize(zyb_UpgradeShop_Items.list:GetWide(), 45 * hMod)

            zyb_UpgradeShop_Items[i].Paint = function(s, w, h)
                if LocalPlayer().zyb_SelectedUpgrade == i and LocalPlayer().zyb_SelectedUpgrade_Installed == false then
                    draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["blue06"])
                else
                    draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["grey02"])
                end
            end

            zyb_UpgradeShop_Items[i].Title = vgui.Create("DLabel", zyb_UpgradeShop_Items[i])
            zyb_UpgradeShop_Items[i].Title:SetPos(45 * wMod, 0 * hMod)
            zyb_UpgradeShop_Items[i].Title:SetSize(400 * wMod, 50 * hMod)
            zyb_UpgradeShop_Items[i].Title:SetFont("zyb_upgrade_vgui_font02")
            zyb_UpgradeShop_Items[i].Title:SetText(upgradeData.u_name)
            zyb_UpgradeShop_Items[i].Title:SetColor(zyb.default_colors["white01"])


            zyb_UpgradeShop_Items[i].Icon = vgui.Create("DPanel", zyb_UpgradeShop_Items[i])

            if upgradeData.u_type == 1 then
                zyb_UpgradeShop_Items[i].Icon.mat = "speedboost"
            elseif upgradeData.u_type == 2 then
                zyb_UpgradeShop_Items[i].Icon.mat = "productionboost"
            end

            zyb_UpgradeShop_Items[i].Icon:SetPos(0 * wMod, 3 * hMod)
            zyb_UpgradeShop_Items[i].Icon:SetSize(40 * wMod, 40 * hMod)
            zyb_UpgradeShop_Items[i].Icon:SetBackgroundColor(zyb.default_colors["black03"])

            zyb_UpgradeShop_Items[i].Icon.Paint = function(s, w, h)
                surface.SetDrawColor(zyb.default_colors["white01"])
                surface.SetMaterial(zyb.default_materials[s.mat])
                surface.DrawTexturedRect(-w / 40, -h / 40, w, h)
                draw.NoTexture()
            end


            zyb_UpgradeShop_Items[i].button = vgui.Create("DButton", zyb_UpgradeShop_Items[i])
            zyb_UpgradeShop_Items[i].button:SetPos(0 * wMod, 0 * hMod)
            zyb_UpgradeShop_Items[i].button:SetSize(zyb_UpgradeShop_Items[i]:GetWide(), zyb_UpgradeShop_Items[i]:GetTall())
            zyb_UpgradeShop_Items[i].button:SetText("")
            zyb_UpgradeShop_Items[i].button.Paint = function(s, w, h)
                if s:IsHovered() then
                    surface.SetDrawColor(zyb.default_colors["white02"])
                else
                    surface.SetDrawColor(255, 255, 255, 0)
                end

                surface.SetMaterial(zyb.default_materials["square"])
                surface.DrawTexturedRect(0, 0, w, h)

            end

            zyb_UpgradeShop_Items[i].button.DoClick = function()
                zyb_Upgrade_Actions.SelectUpgrade(i,false)
                surface.PlaySound("common/wpn_select.wav")
            end


        end
    end
end

function zyb.f.vgui.ItemInfo(parent)
    if zyb_Upgrade_Main and IsValid(zyb_Upgrade_Main.ItemInfoPanel) then
        zyb_Upgrade_Main.ItemInfoPanel:Remove()
    end

    zyb_Upgrade_Main.ItemInfoPanel = vgui.Create("DPanel", parent)
    zyb_Upgrade_Main.ItemInfoPanel:SetPos(310 * wMod, 60 * hMod)
    zyb_Upgrade_Main.ItemInfoPanel:SetSize(300 * wMod, 440 * hMod)
    zyb_Upgrade_Main.ItemInfoPanel:SetBackgroundColor(zyb.default_colors["black03"])

    zyb_Upgrade_Main.ItemInfo_ModelBG = vgui.Create("Panel", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.ItemInfo_ModelBG:SetPos(10 * wMod, 10 * hMod)
    zyb_Upgrade_Main.ItemInfo_ModelBG:SetSize(280 * wMod, 280 * hMod)
    zyb_Upgrade_Main.ItemInfo_ModelBG:SetAutoDelete(true)

    zyb_Upgrade_Main.ItemInfo_ModelBG.Paint = function(self, w, h)
        surface.SetDrawColor(zyb.default_colors["black03"])
        surface.SetMaterial(zyb.default_materials["square"])
        surface.DrawTexturedRect(0, 0, w, h)
    end

    zyb_Upgrade_Main.ItemInfo_IconBG = vgui.Create("Panel", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.ItemInfo_IconBG:SetPos(10 * wMod, 10 * hMod)
    zyb_Upgrade_Main.ItemInfo_IconBG:SetSize(280 * wMod, 280 * hMod)
    zyb_Upgrade_Main.ItemInfo_IconBG:SetAutoDelete(true)
    zyb_Upgrade_Main.ItemInfo_IconBG.Paint = function(s, w, h)
        if s.mat then
            surface.SetDrawColor(zyb.default_colors["white05"])
            surface.SetMaterial(s.mat)
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end

    local upgradeData = zyb.config.Upgrades[LocalPlayer().zyb_SelectedUpgrade]

    zyb_Upgrade_Main.ItemInfo_Model = vgui.Create("DModelPanel", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.ItemInfo_Model:SetSize(zyb_Upgrade_Main.ItemInfo_ModelBG:GetWide(), zyb_Upgrade_Main.ItemInfo_ModelBG:GetWide())
    zyb_Upgrade_Main.ItemInfo_Model:SetPos(0 * wMod, 0 * hMod)
    zyb_Upgrade_Main.ItemInfo_Model:SetModel("models/zerochain/props_yeastbeast/yb_distillery_filter.mdl")
    zyb_Upgrade_Main.ItemInfo_Model:SetAutoDelete(true)
    zyb_Upgrade_Main.ItemInfo_Model:SetColor(upgradeData.u_color)

    zyb_Upgrade_Main.ItemInfo_Model.LayoutEntity = function(s)

        local ang = Angle(0, 15, 0)
        s.Entity:SetAngles(ang)

        local size1, size2 = s.Entity:GetRenderBounds()
        local size = (-size1 + size2):Length()
        s:SetFOV(40)
        s:SetCamPos(Vector(size * 1, size * 1, size * 0.6))
        s:SetLookAt((size1 + size2) + Vector(0,0,2))
    end

    zyb_Upgrade_Main.ItemInfo_TitleBG = vgui.Create("Panel", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.ItemInfo_TitleBG:SetPos(10 * wMod, 10 * hMod)
    zyb_Upgrade_Main.ItemInfo_TitleBG:SetSize(280 * wMod, 50 * hMod)
    zyb_Upgrade_Main.ItemInfo_TitleBG:SetAutoDelete(true)
    zyb_Upgrade_Main.ItemInfo_TitleBG.Paint = function(self, w, h)
        surface.SetDrawColor(zyb.default_colors["black03"])
        surface.SetMaterial(zyb.default_materials["square"])
        surface.DrawTexturedRect(0, 0, w, h)
    end

    zyb_Upgrade_Main.ItemInfo_Title = vgui.Create("DLabel", zyb_Upgrade_Main.ItemInfo_TitleBG)
    zyb_Upgrade_Main.ItemInfo_Title:SetPos(10 * wMod, 5 * hMod)
    zyb_Upgrade_Main.ItemInfo_Title:SetSize(280 * wMod, 45 * hMod)
    zyb_Upgrade_Main.ItemInfo_Title:SetText(upgradeData.u_name)
    zyb_Upgrade_Main.ItemInfo_Title:SetFont("zyb_upgrade_vgui_font01")
    zyb_Upgrade_Main.ItemInfo_Title:SetContentAlignment(7)
    zyb_Upgrade_Main.ItemInfo_Title:SetTextColor(zyb.default_colors["white01"])


    zyb_Upgrade_Main.ItemInfo_Price = vgui.Create("DLabel", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.ItemInfo_Price:SetPos(0 * wMod, 245 * hMod)
    zyb_Upgrade_Main.ItemInfo_Price:SetSize(280 * wMod, 45 * hMod)
    zyb_Upgrade_Main.ItemInfo_Price:SetText(zyb.config.Currency .. upgradeData.u_price)
    zyb_Upgrade_Main.ItemInfo_Price:SetFont("zyb_upgrade_vgui_font01")
    zyb_Upgrade_Main.ItemInfo_Price:SetContentAlignment(3)
    zyb_Upgrade_Main.ItemInfo_Price:SetTextColor(zyb.default_colors["green02"])

    zyb_Upgrade_Main.ItemInfo_DetailBG = vgui.Create("Panel", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.ItemInfo_DetailBG:SetPos(10 * wMod, 290 * hMod)
    zyb_Upgrade_Main.ItemInfo_DetailBG:SetSize(280 * wMod, 100 * hMod)
    zyb_Upgrade_Main.ItemInfo_DetailBG:SetAutoDelete(true)
    zyb_Upgrade_Main.ItemInfo_DetailBG.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, (h / 40) * 11, w, (h / 40) * 1, zyb.default_colors["black05"])
        draw.RoundedBox(0, 0, (h / 40) * 21, w, (h / 40) * 1, zyb.default_colors["black05"])
    end

    zyb_Upgrade_Main.ItemInfo_Desc = vgui.Create("DLabel", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.ItemInfo_Desc:SetPos(10 * wMod, 295 * hMod)
    zyb_Upgrade_Main.ItemInfo_Desc:SetSize(280 * wMod, 45 * hMod)
    zyb_Upgrade_Main.ItemInfo_Desc:SetText(upgradeData.u_desc)
    zyb_Upgrade_Main.ItemInfo_Desc:SetFont("zyb_upgrade_vgui_font03")
    zyb_Upgrade_Main.ItemInfo_Desc:SetContentAlignment(7)
    zyb_Upgrade_Main.ItemInfo_Desc:SetTextColor(zyb.default_colors["white01"])
    zyb_Upgrade_Main.ItemInfo_Desc:SetWrap(true)

    zyb_Upgrade_Main.ItemInfo_amount = vgui.Create("DLabel", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.ItemInfo_amount:SetPos(10 * wMod, 320 * hMod)
    zyb_Upgrade_Main.ItemInfo_amount:SetSize(280 * wMod, 45 * hMod)
    zyb_Upgrade_Main.ItemInfo_amount:SetText("nil")
    zyb_Upgrade_Main.ItemInfo_amount:SetFont("zyb_upgrade_vgui_font03")
    zyb_Upgrade_Main.ItemInfo_amount:SetContentAlignment(7)
    zyb_Upgrade_Main.ItemInfo_amount:SetTextColor(zyb.default_colors["white01"])

    zyb_Upgrade_Main.ItemInfo_ranks = vgui.Create("DLabel", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.ItemInfo_ranks:SetPos(10 * wMod, 345 * hMod)
    zyb_Upgrade_Main.ItemInfo_ranks:SetSize(280 * wMod, 55 * hMod)
    zyb_Upgrade_Main.ItemInfo_ranks:SetText("")
    zyb_Upgrade_Main.ItemInfo_ranks:SetFont("zyb_upgrade_vgui_font03")
    zyb_Upgrade_Main.ItemInfo_ranks:SetContentAlignment(7)
    zyb_Upgrade_Main.ItemInfo_ranks:SetTextColor(zyb.default_colors["white01"])
    zyb_Upgrade_Main.ItemInfo_ranks:SetWrap(true)

    zyb_Upgrade_Main.BuyButton = vgui.Create("DButton", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.BuyButton:SetPos(10 * wMod, 400 * hMod)
    zyb_Upgrade_Main.BuyButton:SetSize(120 * wMod, 30 * hMod)
    zyb_Upgrade_Main.BuyButton:SetText("")
    zyb_Upgrade_Main.BuyButton:SetVisible(false)
    zyb_Upgrade_Main.BuyButton.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(5, 0, 0, w, h, zyb.default_colors["BuyButton_hover"])
        else
            draw.RoundedBox(5, 0, 0, w, h, zyb.default_colors["BuyButton_normal"])
        end
        draw.SimpleText(zyb.language.VGUI["Buy"], "zyb_upgrade_vgui_font04", w / 2, h / 1.9, zyb.default_colors["white03"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    zyb_Upgrade_Main.BuyButton.DoClick = function()
        zyb_Upgrade_Actions.BuyUpgrade()
    end


    zyb_Upgrade_Main.SellButton = vgui.Create("DButton", zyb_Upgrade_Main.ItemInfoPanel)
    zyb_Upgrade_Main.SellButton:SetPos(170 * wMod, 400 * hMod)
    zyb_Upgrade_Main.SellButton:SetSize(120 * wMod, 30 * hMod)
    zyb_Upgrade_Main.SellButton:SetText("")
    zyb_Upgrade_Main.SellButton:SetVisible(false)

    zyb_Upgrade_Main.SellButton.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(5, 0, 0, w, h, zyb.default_colors["SellButton_hover"])
        else
            draw.RoundedBox(5, 0, 0, w, h, zyb.default_colors["SellButton_normal"])
        end

        draw.SimpleText(zyb.language.VGUI["Sell"], "zyb_upgrade_vgui_font04", w / 2, h / 1.9, zyb.default_colors["white03"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    zyb_Upgrade_Main.SellButton.DoClick = function()
        zyb_Upgrade_Actions.SellUpgrade()
    end
end

function zyb.f.vgui.InstalledItems(parent)

    if zyb_Upgrade_Main and IsValid(zyb_Upgrade_Main.InstalledItemPanel) then
        zyb_Upgrade_Main.InstalledItemPanel:Remove()
    end

    zyb_Upgrade_Main.InstalledItemPanel = vgui.Create("DPanel", parent)
    zyb_Upgrade_Main.InstalledItemPanel:SetPos(620 * wMod, 60 * hMod)
    zyb_Upgrade_Main.InstalledItemPanel:SetSize(300 * wMod, 440 * hMod)
    zyb_Upgrade_Main.InstalledItemPanel:SetBackgroundColor(zyb.default_colors["black02"])



    zyb_Upgrade_Main.InstalledTitlePanel = vgui.Create("DPanel", zyb_Upgrade_Main.InstalledItemPanel)
    zyb_Upgrade_Main.InstalledTitlePanel:SetPos(0 * wMod, 0 * hMod)
    zyb_Upgrade_Main.InstalledTitlePanel:SetSize(300 * wMod, 40 * hMod)
    zyb_Upgrade_Main.InstalledTitlePanel:SetBackgroundColor(zyb.default_colors["black03"])


    zyb_Upgrade_Main.InstalledTitle = vgui.Create("DLabel", zyb_Upgrade_Main.InstalledTitlePanel)
    zyb_Upgrade_Main.InstalledTitle:SetPos(10 * wMod, 0 * hMod)
    zyb_Upgrade_Main.InstalledTitle:SetSize(500 * wMod, 45 * hMod)
    zyb_Upgrade_Main.InstalledTitle:SetText(zyb.language.VGUI["Installed"])
    zyb_Upgrade_Main.InstalledTitle:SetFont("zyb_upgrade_vgui_font01")
    zyb_Upgrade_Main.InstalledTitle:SetContentAlignment(7)
    zyb_Upgrade_Main.InstalledTitle:SetTextColor(zyb.default_colors["white01"])


    zyb_Installed_Items = {}
    zyb_Installed_Items.panel = vgui.Create("DScrollPanel", zyb_Upgrade_Main.InstalledItemPanel)
    zyb_Installed_Items.panel:DockMargin(0 * wMod, 45 * hMod, 0 * wMod, 0 * hMod)
    zyb_Installed_Items.panel:Dock(FILL)

    zyb_Installed_Items.panel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["black03"])
    end

    local abar = zyb_Installed_Items.panel:GetVBar()

    function abar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["black03"])
    end

    function abar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["grey04"])
    end

    function abar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["grey04"])
    end

    function abar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h,  zyb.default_colors["grey05"])
    end

    zyb.f.vgui.Build_Installeditems()
end

function zyb.f.vgui.Build_Installeditems()
    if zyb_Installed_Items and IsValid(zyb_Installed_Items.list) then
        zyb_Installed_Items.list:Remove()
    end

    if zyb_Installed_Items and IsValid(zyb_Installed_Items.panel) then
        zyb_Installed_Items.list = vgui.Create("DIconLayout", zyb_Installed_Items.panel)
        zyb_Installed_Items.list:SetSize(280 * wMod, 705 * hMod)
        zyb_Installed_Items.list:SetPos(10 * wMod, 10 * hMod)
        zyb_Installed_Items.list:SetSpaceY(10)

        for i = 1, table.Count(LocalPlayer().zyb_InstalledUpgrades) do
            local upgradeData = zyb.config.Upgrades[LocalPlayer().zyb_InstalledUpgrades[i]]
            zyb_Installed_Items[i] = zyb_Installed_Items.list:Add("DFrame")
            zyb_Installed_Items[i]:SetSizable(false)
            zyb_Installed_Items[i]:SetTitle("")
            zyb_Installed_Items[i]:ShowCloseButton(false)
            zyb_Installed_Items[i]:SetDraggable(false)
            zyb_Installed_Items[i]:SetSize(zyb_Installed_Items.list:GetWide(), 45 * hMod)

            zyb_Installed_Items[i].Paint = function(self, w, h)
                if LocalPlayer().zyb_SelectedUpgrade == i and LocalPlayer().zyb_SelectedUpgrade_Installed == true then
                    draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["blue06"])
                else
                    draw.RoundedBox(0, 0, 0, w, h, zyb.default_colors["grey02"])
                end
            end

            zyb_Installed_Items[i].Title = vgui.Create("DLabel", zyb_Installed_Items[i])
            zyb_Installed_Items[i].Title:SetPos(45 * wMod, 0 * hMod)
            zyb_Installed_Items[i].Title:SetSize(400 * wMod, 50 * hMod)
            zyb_Installed_Items[i].Title:SetFont("zyb_upgrade_vgui_font02")
            zyb_Installed_Items[i].Title:SetText(upgradeData.u_name)
            zyb_Installed_Items[i].Title:SetColor(zyb.default_colors["white01"])

            zyb_Installed_Items[i].Icon = vgui.Create("DPanel", zyb_Installed_Items[i])
            if upgradeData.u_type == 1 then
                zyb_Installed_Items[i].Icon.mat = "speedboost"
            elseif upgradeData.u_type == 2 then
                zyb_Installed_Items[i].Icon.mat = "productionboost"
            end
            zyb_Installed_Items[i].Icon:SetPos(0 * wMod, 3 * hMod)
            zyb_Installed_Items[i].Icon:SetSize(40 * wMod, 40 * hMod)
            zyb_Installed_Items[i].Icon:SetBackgroundColor(zyb.default_colors["black03"])

            zyb_Installed_Items[i].Icon.Paint = function(s, w, h)
                surface.SetDrawColor(zyb.default_colors["white01"])
                surface.SetMaterial(zyb.default_materials[s.mat])
                surface.DrawTexturedRect(-w / 40, -h / 40, w, h)
                draw.NoTexture()
            end

            zyb_Installed_Items[i].button = vgui.Create("DButton", zyb_Installed_Items[i])
            zyb_Installed_Items[i].button:SetPos(0 * wMod, 0 * hMod)
            zyb_Installed_Items[i].button:SetSize(zyb_Installed_Items[i]:GetWide(), zyb_Installed_Items[i]:GetWide())
            zyb_Installed_Items[i].button:SetText("")
            zyb_Installed_Items[i].button.Paint = function(s, w, h)
                if s:IsHovered() then
                    surface.SetDrawColor(zyb.default_colors["white02"])
                else
                    surface.SetDrawColor(255, 255, 255, 0)
                end

                surface.SetMaterial(zyb.default_materials["square"])
                surface.DrawTexturedRect(0, 0, w, h)
            end

            zyb_Installed_Items[i].button.DoClick = function()
                zyb_Upgrade_Actions.SelectUpgrade(i,true)
                surface.PlaySound("common/wpn_select.wav")
            end
        end
    end
end

vgui.Register("zyb_vgui_UpgradeInterface", zyb_UpgradeInterface, "DFrame")
-- leak by lordee