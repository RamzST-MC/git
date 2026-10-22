-- leak by lordee
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Player_GetID(ply)
    if ply:IsBot() then
        return ply:UserID()
    else
        return ply:SteamID()
    end
end

function zyb.f.Player_GetName(ply)
    if ply:IsBot() then
        return "Bot_" .. ply:UserID()
    else
        return ply:Nick()
    end
end
-- leak by lordee