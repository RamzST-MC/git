local a = {}
function a:Init()
    self.Tabs = ui.Create('ui_tablist_horizontal', self)
    self.Tabs:Dock(FILL)
    self.Tabs:AddTab('Основное', function() return ui.Create'rp_settings_gamemode' end, true):SetIcon'sup/gui/generic/gear.png'
end

function a:PerformLayout(b, c)
end

vgui.Register('rp_settings', a, 'Panel')

hook.Add('ba.LayoutSettingsPanel', 'rp.CrosshairMenu.Panel', function(x)
    x:AddSpacer('Настройки прицела')

    x:AddItem(ui.Create('ui_button', function(self)
        self:SetTall(ui.ButtonHeight)
        self:SetText('Открыть Редактор Прицела')

        self.DoClick = function()
            rp.ToggleF4Menu()
            rp.CrosshairMenu()
        end
    end))
end)