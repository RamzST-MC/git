rp.parties = rp.parties or {}

function rp.parties.GetPlayers(a)
    return table.Filter(player.GetAll(), function(b) return b:GetParty() == a end)
end

function rp.parties.Exists(a)
    for c, b in player.Iterator() do
        if b:InParty() and b:GetParty():lower() == a:lower() then return true end
    end
    return false
end

function PLAYER:GetParty()
    return self:GetNetVar('Party')
end

function PLAYER:InParty()
    return self:GetParty() ~= nil
end

function PLAYER:IsPartyLeader()
    return self:GetNetVar('PartyLeader') == true
end

function PLAYER:IsPartyCoLeader()
    return self:GetNetVar('PartyCoLeader') == true
end

function PLAYER:IsPartyVoiceEnabled()
    return self:GetNetVar('PartyVoice') == true
end