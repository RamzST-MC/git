function PLAYER:IsZiptied()
    return self:GetNetVar('Ziptied') == true
end

function PLAYER:IsCarrying()
    return self:GetNetVar('ZiptieCarrying') ~= nil
end

function PLAYER:IsBeingCarried()
    return self:GetNetVar('ZiptieCarrier') ~= nil
end

function PLAYER:GetCarried()
    return SERVER and self:GetNetVar('ZiptieCarrying') or Entity(self:GetNetVar('ZiptieCarrying') or 0)
end

function PLAYER:GetCarrier()
    return SERVER and self:GetNetVar('ZiptieCarrier') or Entity(self:GetNetVar('ZiptieCarrier') or 0)
end

function PLAYER:CanUseZipties()
    return self:GetTeamTable().CanHostage or self:IsCP()
end

hook('Move', 'rp.Zipties.Move', function(a, b)
    if a:IsZiptied() or a:IsCarrying() then
        if a:GetMoveType() ~= MOVETYPE_LADDER then b:SetButtons(bit.band(b:GetButtons(), bit.bnot(b:GetButtons(), IN_JUMP))) end
        local c = 0.25
        if a:IsCarrying() and a:CanUseZipties() then c = 0.65 end
        b:SetMaxClientSpeed(rp.cfg.WalkSpeed * c)
    end
end)

function GM:PlayerCanZiptiedRansom(a, d)
    return d:IsZiptied() and not d:IsBeingCarried()
end

function GM:PlayerCanZiptiedPickup(a, d)
    return not a:IsCarrying() and not a:IsBeingCarried() and not a:IsZiptied() and not d:IsBeingCarried() and d:IsZiptied()
end

function GM:PlayerCanCutZipties(a, d)
    if not d:IsZiptied() or d:IsBeingCarried() then return false end
    local e = a:GetActiveWeapon()
    return a:IsCP() or IsValid(e) and e:IsKnife()
end