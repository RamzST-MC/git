rp.emotes = {
    Registered = {},
    Lookup = {}
}

nw.Register('Emotes'):Read(function()
    local a = net.ReadUInt(8)
    local b = {}
    for c = 1, a do
        b[net.ReadUInt(8)] = true
    end
    return b
end):Write(function(b)
    net.WriteUInt(table.Count(b), 8)
    for d, e in pairs(b) do
        net.WriteUInt(d, 8)
    end
end):SetLocalPlayer()

function rp.emotes.Register(f, g)
    g.ID = #rp.emotes.Registered + 1
    g.UID = f
    rp.emotes.Registered[g.ID] = g
    rp.emotes.Lookup[f] = g.ID
end

function rp.emotes.GetID(f)
    return rp.emotes.Lookup[f]
end

function rp.emotes.GetByID(j)
    return rp.emotes.Registered[j]
end

function rp.emotes.GetByUID(f)
    local j = rp.emotes.GetID(f)
    return j and rp.emotes.GetByID(j)
end

function PLAYER:HasEmote(f)
    local j = rp.emotes.GetID(f)
    return self:HasEmoteID(j)
end

function PLAYER:HasEmoteID(j)
    local b = self:GetNetVar('Emotes')
    if b ~= nil then return b[j] == true end
    return false
end