hook.Add("PlayerShouldTakeDamage", "sup_AntiTeamkill", function(ply, attacker)
    if ply:IsGov() and attacker:IsPlayer() and attacker:IsGov() then
        return false
    end
end)