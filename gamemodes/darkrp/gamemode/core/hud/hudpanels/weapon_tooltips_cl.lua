local PANEL = {}

function PANEL:Init()
    self.BaseClass.Init(self)
end

local b = {
    LeftClick = 'ui/mouse_left.png',
    RightClick = 'ui/mouse_right.png',
    Info = 'divergent/ui/hud/icons/info.png'
}

local c = {'LeftClick', 'RightClick', 'R', 'Info'}

function PANEL:AddTooltip(d, e)
    local f = self:Add'rp_hud_iconbox'
    f:SetMaterial(b[d] or 'divergent/ui/hud/icons/blank_button.png')
    f:SetColor(ui.col.FlatBlack)
    f:Dock(TOP)
    f:DockMargin(0, 0, 0, 5)

    function f:GetString()
        return isfunction(e) and e() or e
    end

    f:Update()

    if not b[d] then
        function f:PaintOver(g, h)
            draw.SimpleText(d, 'ui.19', 17, 17, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

function PANEL:SetWeapon(i)
    self.Weapon = i
    if not IsValid(i) or i.Tooltips == nil then return end

    for j, k in ipairs(c) do
        if i.Tooltips[k] then
            self:AddTooltip(k, i.Tooltips[k])
        end
    end

    for j, k in pairs(i.Tooltips) do
        if not table.HasValue(c, j) then
            self:AddTooltip(j, k)
        end
    end

    local l, m = 0, 0

    for k, v in ipairs(self:GetChildren()) do
        if not v:IsMarkedForDeletion() then
            local wide = v:GetWide()

            if wide > l then
                l = wide
            end

            m = m + v:GetTall() + 5
        end
    end

    self:SetSize(l, m)
    self:SetPos(ScrW() - l - 5, ScrH() - m)
end

function PANEL:Clear()
    self:SetSize(0, 0)

    for j, k in ipairs(self:GetChildren()) do
        k:Remove()
    end

    self.Weapon = nil
end

function PANEL:Update()
    self.BaseClass.Update(self)
    if not IsValid(LocalPlayer()) then return end

    if not LocalPlayer():Alive() or not IsValid(self.Weapon) then
        self:Clear()
    elseif self.Weapon ~= LocalPlayer():GetActiveWeapon() then
        self:Clear()
        self:SetWeapon(LocalPlayer():GetActiveWeapon())
    end
end

vgui.Register('rp_hud_weapon_tooltips', PANEL, 'rp_hud_base')