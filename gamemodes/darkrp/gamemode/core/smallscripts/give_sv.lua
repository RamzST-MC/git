hook.Add('PlayerGiveSWEP', 'DonateSWEP', function(ply, class, swep)
    if not IsValid(ply) then return false end
    
    local weapon = rp.cfg.RankWeapons[ply:GetUserGroup()]
    if ply:HasPurchase('fullqmenuaccess') then
        for k, v in ipairs(rp.cfg.WeaponsLimit[3]) do
            if v == class then return true end
        end
    end

    if ply:GetRank() == 'root' then return true end
    if not weapon then return end
    for k, v in ipairs(weapon) do
        if v == class then return true end
    end

    ply:ChatPrint('Вы не можете взять это оружие')
    return false
end)
