local a = FindMetaTable'Cvar'

function a:ShouldShow()
    return true
end

function a:SetShouldShow(b)
    self.ShouldShow = b

    return self
end

function a:SetCustomElement(c)
    self:AddMetadata('Type', 'Custom')
    self.CustomElementName = c

    return self
end

function a:GetCustomElement()
    return self.CustomElementName
end

local d = {}
Derma_Hook(d, 'Paint', 'Paint', 'Panel')

function d:Populate(e, f)
    local g = {}

    for h, i in ipairs(cvar.GetOrderedTable()) do
        if i:GetMetadata('Menu') or i:GetCustomElement() then
            local j = i:GetMetadata('Category') or i:GetMetadata('Catagory') or 'Остальное'

            if not g[j] then
                g[j] = {}
            end

            g[j][#g[j] + 1] = i
        end
    end

    local function k(h, i)
        self:SetSpacing(1)
        if f and not table.HasValue(e, h) then return end
        self:AddSpacer(h)

        for h, i in ipairs(i) do
            if i:ShouldShow() then
                local l = i:GetMetadata('Type') or 'bool'

                if l == 'bool' then
                    self:AddItem(ui.Create('DPanel', function(self, m)
                        self:SetTall(30)

                        ui.Create('ui_checkbox', function(self, m)
                            self:SetPos(5, 5)
                            self:SetText(i:GetMetadata('Menu'))
                            self:SetConVar(i:GetName())
                            self:SizeToContents()
                        end, self)
                    end))
                elseif l == 'number' then
                    self:AddItem(ui.Create('DPanel', function(self, m)
                        self:SetTall(45)

                        ui.Create('DLabel', function(self, m)
                            self:SetFont('ui.18')
                            self:SetColor(ui.col.ButtonText)
                            self:SetText(i:GetMetadata('Menu'))
                            self:SizeToContents()
                            self:SetTall(14)
                            self:SetPos(5, 5)
                        end, self)

                        ui.Create('ui_slider', function(self, m)
                            self:SetValue(i:GetValue())

                            self.OnChange = function(n, o)
                                i:SetValue(o)
                            end

                            self:SetWide(200)
                            self:SetPos(5, 23)
                        end, self)
                    end))
                elseif l == 'Custom' then
                    self:AddItem(ui.Create(i:GetCustomElement(), function(self)
                        self:SetCvar(i)
                    end))
                end
            end
        end
    end

    if e then
        for h, i in ipairs(e) do
            if g[i] then
                k(i, g[i])
                g[i] = nil
            end
        end
    end

    for h, i in pairs(g) do
        k(h, i)
    end

    hook.Call('ba.LayoutSettingsPanel', nil, self)
end

function d:DockToFrame()
    local m = self:GetParent()
    local p, q = m:GetDockPos()
    self:SetPos(p, q)
    self:SetSize(m:GetWide() - 10, m:GetTall() - (q + 5))
end

vgui.Register('ui_settingspanel', d, 'ui_listview')