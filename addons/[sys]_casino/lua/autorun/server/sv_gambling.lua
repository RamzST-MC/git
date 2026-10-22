hook.Add('PlayerDisconnected', 'gamb::remove', function(pl)
    if pl:GetJob() == TEAM_CASINOOWNER then
        pl:SetNetVar('GamblingZarobotok', nil)
        pl:SetNetVar('GamblingUbitok', nil)
    end
end)