rp.interactions = rp.interactions or {}
rp.interactions.a = {
    mask = -1,
    filter = {}
}

function PLAYER:CanInteract(b)
    local c = self:GetAimVector()
    local d = b:GetPos()
    local e = (d - self:GetShootPos()):GetNormalized()
    local f = c:Dot(e)
    if f < 0.35 then return false end
    if self:EyePos():DistToSqr(d) > 30000 then return false end
    return self:IsLineOfSightClear(b) and (not isplayer(b) or b:Alive())
end

keybind.Add('Player Interaction Menu', KEY_E, function(self, pl)
    --if IsValid(pl:GetLastInteraction()) then
    --    net.Start'rp.interaction.Close'
    --    net.Send(pl)
    --else
        local int = pl:GetEyeTraceNoCursor().Entity
        if IsValid(int) and int:IsPlayer() and not int:IsZiptied() and not int:IsBeingCarried() then
            pl:SetLastInteraction(int)
            net.Start'rp.interaction.Open'
            net.WritePlayer(int)
            net.Send(pl)
        end
    --end
end)
:SetCanRun(function(self, pl)
    return not pl:IsBanned() and isplayer(pl:GetEyeTraceNoCursor().Entity) and not pl:IsCarrying()
end)
:SetCooldown(0)
:EnableEntityTooltip(true)
:SetTooltipText'Взаимодействовать'
:SetShouldDrawTooltip(function(self, int)
    return int:IsPlayer() and not int:IsZiptied() and not int:IsBeingCarried() and not IsValid(rp.interactions.Menu)
end)