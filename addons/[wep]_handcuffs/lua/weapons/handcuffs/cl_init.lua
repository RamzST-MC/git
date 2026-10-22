include("shared.lua")

SWEP.PrintName = "Наручники"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Tooltips					= {LeftClick = 'Надеть', RightClick = 'Снять'}

--[[local table_arrests = {
	{name = 'Нелегальные предметы'},
	{name = 'Покушение'},
	{name = 'Убийство'},
	{name = 'Нанесение увечий'},
	{name = 'Побег из тюрьмы'},
	{name = 'Неподчинение'},
	{name = 'Нарушение К.Ч.'}
}

net.Receive('rp::handcuffs_weapons', function(len, pl)
    local guns = net.ReadTable()
    local ply = net.ReadEntity()

    if IsValid(frWep) then frWep:Remove() end

    frWep = vgui.Create('ui_frame')
    frWep:SetSize(500, 200)
    frWep:SetPos(ScrW() / 2 - 250, ScrH() - 210)
    frWep:SetDraggable(false)
    frWep:MakePopup()
    frWep:SetTitle('Арест игрока')

    local drag = vgui.Create('MantleSlideBox', frWep)
    drag:SetPos(25, 45)
    drag:SetSize(450, 45)
    drag:SetText("Время ареста (сек)")
    drag:SetRange(60,180,0)
    drag:UpdateSliderPosition(60)

    local btn = vgui.Create("ui_button", frWep)
    btn:SetSize(100, 30)
    btn:SetPos(frWep:GetWide() - 120, frWep:GetTall() - 40)
    btn:SetText("Принять")
    btn.DoClick = function()
        net.Start("cuffs::arrest")
            net.WriteEntity(ply)
            net.WriteInt(drag.value, 16)
        net.SendToServer()
        frWep:Remove()
    end
end)]]

local function frametext(text, font, x, y, color, x_a, y_a, color_shadow)
    color_shadow = color_shadow or Color(0, 0, 0)
    draw.SimpleText(text, font, x + 1, y + 1, color_shadow, x_a, y_a)
    local w, h = draw.SimpleText(text, font, x, y, color, x_a, y_a)
    return w, h
end

net.Receive('rp::handcuffs_weapons', function(len, pl)
    local guns = net.ReadTable()
    local ply = net.ReadEntity()

    if IsValid(frWep) then frWep:Close() end
    
    local colorframe = Color(28, 28, 28)

    frWep = vgui.Create('ui_frame')
    frWep:SetSize(460, 432)
    frWep:Center()
    frWep:MakePopup()
    frWep:SetTitle('')
    frWep.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, colorframe)
        draw.SimpleText("Обыск", 'ui.16', w / 2, 15, color_white, 1, 1)
    end

    local top_panel = ui.Create("DPanel", frWep)
    top_panel:Dock(TOP)
    top_panel:InvalidateParent(true)
    top_panel:SetTall(frWep:GetTall() / 4)
    top_panel.Paint = function(self, w, h)
        frametext(ply:Name(), 'ui.26', top_panel:GetTall() + 5, 15, team.GetColor(ply:Team()), 0, 1)
        frametext(ply:HasLicense() and "Имеет лицензию" or "Лицензия не найдена", "ui.24", top_panel:GetTall() + 5, 35, Color(255, 255, 255, 40), 0, 1)
    end

    local avatar = ui.Create("AvatarImage", top_panel)
    avatar:SetPos(0, 5)
    avatar:SetSize(100, 100)
    avatar:SetPlayer(ply, 128)

    local info_panel = ui.Create("DPanel", top_panel)
    info_panel:Dock(RIGHT)
    info_panel:SetWide(top_panel:GetWide() - top_panel:GetTall())
    info_panel.Paint = nil

    local Scroll = vgui.Create("DScrollPanel", frWep)
    Scroll:Dock(FILL)
    Scroll.Paint = function(self, w, h)
        if #guns == 0 then frametext("У человека нету оружия :С", "ui.20", w * .5, 115.776, Color(255, 255, 255), 1, 1) end
    end

    Scroll.VBar:SetWide(3)
    Scroll:DockMargin(0, 5, 0, 0)
    local bar = Scroll.VBar
    bar:SetHideButtons(true)
    --   bar.Paint = function(this, w, h) end
    bar.btnUp.Paint = function(this, w, h) end
    bar.btnDown.Paint = function(this, w, h) end
    local List = ui.Create("DIconLayout", Scroll)
    List:Dock(FILL)
    if table.Count(guns) >= 9 then
        List:SetSpaceY(2)
        List:SetSpaceX(2)
    else
        List:SetSpaceY(3)
        List:SetSpaceX(3)
    end

    List.Paint = nil
    surface.SetFont('ui.22')
    local x1, y1 = surface.GetTextSize('[Включено]')
    local x2, y2 = surface.GetTextSize('[Выключено]')
    local tr = util.TraceLine({
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + (LocalPlayer():GetAimVector() * 100),
        filter = LocalPlayer()
    })

    if not ply:HasLicense() then
        for k, v in pairs(guns) do
            if not istable(weapons.Get(v[1])) then continue end
            -- if weapons.Get(v[1]).Base ~= 'bobs_gun_base' then continue end
            if weapons.Get(v[1]).Base == 'weapon_rp_base' then continue end
            if table.HasValue(rp.cfg.DefaultWeapons, v[1]) then continue end
            local ListItem = List:Add("ui_panel")
            ListItem:SetSize(145, 115)
            ListItem:DockMargin(5, 2.5, 5, 0)
            ListItem:SetText("")
            ListItem.HoverAlpha = 0
            ListItem.Paint = function(this, w, h)
                --draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35))
                draw.RoundedBox(7, 0, 0, w, h, Color(36, 36, 36))
                frametext(weapons.Get(v[1]).PrintName, "ui.19", w / 2, h - 13, Color(255, 255, 255), 1, 1)
                if this:IsHovered() then
                    this.HoverAlpha = Lerp(FrameTime() * 10, this.HoverAlpha, 255)
                else
                    this.HoverAlpha = Lerp(FrameTime() * 10, this.HoverAlpha, 0)
                end

                local boxcolor = Color(73, 170, 250, this.HoverAlpha)
                if this.HoverAlpha > 0 then
                    surface.SetDrawColor(boxcolor)
                    surface.DrawOutlinedRect(0, 0, w, h)
                end
            end

            local model = ui.Create("DModelPanel", ListItem)
            model:SetPos(2, 2)
            model:SetSize(ListItem:GetTall() - 4, ListItem:GetTall() - 4)
            model:SetFOV(35)
            function model:LayoutEntity(Entity)
                return
            end

            model:SetModel(weapons.Get(v[1]).WorldModel)
            local min, max = model.Entity:GetRenderBounds()
            model:SetCamPos(min:Distance(max) * Vector(0.5, 0.5, 0.2) + Vector(0, 33, 0))
            model:SetLookAt((max + min) * .5)
            local pidor = model.Think
            model.Think = function(self)
                if self:IsHovered() then
                    ListItem.HoverAlpha = Lerp(FrameTime() * 10, ListItem.HoverAlpha, 255)
                else
                    ListItem.HoverAlpha = Lerp(FrameTime() * 10, ListItem.HoverAlpha, 0)
                end

                if pidor then pidor(self) end
            end

            model.OnMousePressed = function()
                local menu = DermaMenu()
                menu:SetSkin('SUP')
                menu:AddOption("Изъять", function()
                    net.Start('cuffs::takegun')
                    net.WriteEntity(tr.Entity)
                    net.WriteString(v[1])
                    net.SendToServer()
                    ListItem:Remove()
                end)

                menu:Open()
            end
        end
    end
end)