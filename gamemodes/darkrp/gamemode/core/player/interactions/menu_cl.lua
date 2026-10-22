local a = {
    Buttons = {
        {
            Name = 'Test Btn',
            DoClick = function(b) print('Test') end
        }
    },
    Categories = {
        {
            Name = 'Test Cat',
            Icon = 'sup/gui/generic/party.png',
            Buttons = {
                {
                    Name = 'Test Cat Btn',
                    DoClick = function(b) print('Test') end
                }
            }
        }
    }
}

local c = {}
function c:Init()
    self:SetKeyBoardInputEnabled(false)
    self:SetMouseInputEnabled(false)
    self.Index = 1
    hook('SuppressWeaponSwitcher', self, function() return true end)
    local function d()
        local e = self:GetActiveChildren()
        if self.Index < 1 then
            self.Index = #e
        elseif self.Index > #e then
            self.Index = 1
        end

        if e[self.Index] then self.ActiveButton = e[self.Index] end
    end

    hook('PlayerBindPress', self, function(self, b, f, g)
        if not g then return end
        if f:StartsWith('slot') then
            local h = tonumber(f:sub(5))
            if h == self.Index and self.ActiveButton then
                self.ActiveButton:DoClick()
            else
                self.Index = h
                d()
            end
            return true
        end

        if f == 'invnext' then
            self.Index = self.Index + 1
            d()
            return true
        end

        if f == 'invprev' then
            self.Index = self.Index - 1
            d()
            return true
        end

        if f == '+attack' then
            if self.ActiveButton then self.ActiveButton:DoClick() end
            return true
        end

        if f == '+attack2' then
            self:Close()
            return true
        end
    end)

    self.Options = a
end

function c:Paint(i, j)
    draw.RoundedBox(4, 0, 0, i, j, ui.col.FlatBlack)
    self:UpdateTransform()
end

function c:Think()
    if self.Entity ~= nil and not IsValid(self.Entity) or not LocalPlayer():CanInteract(self.Entity) then self:Close() end
end

function c:Close()
    net.Start'rp.interaction.Close'
    net.SendToServer()
    self:Remove()
end

function c:GetActiveChildren()
    return table.Filter(self:GetChildren(), function(k) return not k:IsMarkedForDeletion() end)
end

function c:SizeToChildren()
    local e = self:GetActiveChildren()
    self.ActiveButton = e[1]
    self:SetSize(200, #e * (ui.ButtonHeight + 5) + 5)
end

function c:AddButton()
    local l = #self:GetActiveChildren() + 1
    local m = ui.Create('ui_button', self)
    m:Dock(TOP)
    m:SetSize(190, ui.ButtonHeight)
    m:DockMargin(5, 5, 5, 0)
    m.IsHovered = function(n) return self.ActiveButton == n end
    m.Paint = function(n, i, j)
        derma.SkinHook('Paint', 'Button', n, i, j)
        -- draw.SimpleText(l, 'ui.12', i - 3, 1, ui.col.SUP, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end
    return m
end

function c:AddButtons(o)
    self.Index = 1
    for p, k in ipairs(o) do
        if k.CanUse and not k.CanUse(self.Entity) then continue end
        local m = self:AddButton()
        if k.Name then m:SetText(k.Name) end
        m.Think = function(n) if k.GetText then n:SetText(k.GetText(self.Entity)) end end
        m.DoClick = function()
            if not k.CanUse or k.CanUse(self.Entity) then
                if k.DoClick then k.DoClick(self.Entity) end
                if k.Command then cmd.Run(k.Command) end
                self:Remove()
            else
                self:Close()
            end
        end
    end
end

function c:AddCategories()
    if not self.Options.Categories then return end
    for p, k in ipairs(self.Options.Categories) do
        if k.CanUse and not k.CanUse(self.Entity) then continue end
        local m = self:AddButton()
        m:SetText(k.Name)
        m:SetIcon(k.Icon)
        m.DoClick = function() self:EnterCategory(k.Buttons) end
    end
end

function c:EnterCategory(o)
    self:Clear()
    local m = self:AddButton()
    m:SetText'Назад'
    m.DoClick = function()
        self:Clear()
        self:AddButtons(self.Options.Buttons)
        self:AddCategories()
        self:SizeToChildren()
    end

    self:AddButtons(o)
    self:SizeToChildren()
end

function c:UpdateTransform()
    local s = isplayer(self.Entity) and self.Entity:GetShootPos() or self.Entity:GetPos()
    local t = LocalPlayer():GetShootPos()
    t.z = s.z
    local u = t - s
    local v = s + u:GetNormalized() * 30
    if self.IsThirdPerson then v.z = v.z + 25 end
    local w = u:Angle()
    w.y = w.y + 90
    w.r = w.r + 90
    v = v + w:Forward() * -(self:GetWide() * (self.IsThirdPerson and 0.1 or 0.04))
    self.Position, self.Angles = self:OnUpdateTransform(v, w)
end

function c:OnUpdateTransform(x, y)
    return x, y
end

function c:Start3D(z)
    self.IsThreeDimensional = true
    hook.Add('PostDrawTranslucentRenderables', self, function()
        vgui.Start3D2D(self.Position, self.Angles, z)
        self:Paint3D2D()
        vgui.End3D2D()
    end)
end

function c:SetOptions(A)
    self.Options = A
end

function c:SetEntity(b)
    self.Entity = b
    self.IsThirdPerson = rp.thirdPerson.isEnabled()
    if self.IsThirdPerson then hook('ShouldHidePlayerInfo', self, function(self, b) if b == self.Entity then return true end end) end
    self:Start3D(self.IsThirdPerson and 0.2 or 0.08)
    self:UpdateTransform()
    self:AddButtons(self.Options.Buttons)
    self:AddCategories()
    self:SizeToChildren()
end

vgui.Register('rp_interactions_menu', c, 'EditablePanel')