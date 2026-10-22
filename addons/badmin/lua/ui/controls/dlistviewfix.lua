timer.Simple(0, function()
    local a = vgui.GetControlTable'DListView'
    a._PerformLayout = a._PerformLayout or a.PerformLayout

    a.PerformLayout = function(self, b, c)
        self._PerformLayout(self, b, c)
    end
end)