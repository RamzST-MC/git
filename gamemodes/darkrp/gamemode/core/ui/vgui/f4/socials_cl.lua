PANEL = {}

function PANEL:Init()
    self.Discord = ui.Create('ui_button', self)
    self.Discord:SetText('')
    self.Discord.Paint = function(_, w, h)
        local col_ds = Color(114, 137, 218)
        if self.Discord:IsHovered() then
            self.ds = Lerp(FrameTime() * 5, self.ds or 0, 50)
        else
            self.ds = Lerp(FrameTime() * 5, self.ds or 0, 0)
        end

        col_ds.r = col_ds.r + self.ds
        col_ds.g = col_ds.g + self.ds
        col_ds.b = col_ds.b + self.ds

        draw.RoundedBox(16, 0, 0, w, h, col_ds)
        draw.Material(10, 10, w - 20, h - 20, eclipse.mat.DS)
    end
    self.Discord.DoClick = function()
        gui.OpenURL(rp.cfg.DiscordURL)
    end

    self.STEAM = ui.Create('ui_button', self)
    self.STEAM:SetText('')
    self.STEAM.Paint = function(_, w, h)
        local col_steam = Color(255, 220, 95)
        if self.STEAM:IsHovered() then
            self.steam = Lerp(FrameTime() * 5, self.steam or 0, 50)
        else
            self.steam = Lerp(FrameTime() * 5, self.steam or 0, 0)
        end

        col_steam.r = col_steam.r + self.steam
        col_steam.g = col_steam.g + self.steam
        col_steam.b = col_steam.b + self.steam

        draw.RoundedBox(16, 0, 0, w, h, col_steam)
        draw.Material(10, 10, w - 20, h - 20, eclipse.mat.Donate)
    end
    self.STEAM.DoClick = function()
        IGS.UI()
        rp.ToggleF4Menu()
    end
end

function PANEL:PerformLayout(w, h)
    self.Discord:SetPos(w / 2 - 202.5, h / 2 - 100)
	self.Discord:SetSize(200, 200)

    self.STEAM:SetPos(w / 2, h / 2 - 100)
	self.STEAM:SetSize(200, 200)
end

vgui.Register('rp_socials', PANEL, 'Panel')