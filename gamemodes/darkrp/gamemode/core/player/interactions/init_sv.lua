util.AddNetworkString('rp.interaction.Open')
util.AddNetworkString('rp.interaction.Close')

function PLAYER:SetLastInteraction(int)
    rp = rp or {}
    rp.interactions = rp.interactions or {}

    local id = self:SteamID64()
    rp.interactions[id] = rp.interactions[id] or table.Copy(rp.interactions.a)
    rp.interactions[id].last = int
end

function PLAYER:GetLastInteraction()
    local id = self:SteamID64()
    return rp.interactions and rp.interactions[id] and rp.interactions[id].last or nil
end
