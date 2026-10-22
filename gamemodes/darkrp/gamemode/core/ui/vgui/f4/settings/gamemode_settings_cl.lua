local a = {}
function a:Init()
    self:DockPadding(0, 0, 0, 5)
    self.LeftContainer = ui.Create('Panel', self)
    self.LeftContainer:Dock(LEFT)
    self.Cvars = ui.Create('ui_settingspanel', self.LeftContainer)
    self.Cvars:Populate({'Media Players', 'Chat', 'HUD', 'Staff', 'Other', 'TeamSpeak Sync'})
    self.Cvars:Dock(FILL)

    self.Colors = ui.Create('rp_settings_color', self)
    self.Colors:Dock(RIGHT)
end

function a:PerformLayout(q, r)
    local s = (q - 5) * 0.5
    self.LeftContainer:SetWide(s)
    self.Colors:SetWide(s)
end

vgui.Register('rp_settings_gamemode', a, 'Panel')