-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

// Here are some Hooks you can use for Custom Code

// Called before the player sells moonshine, can be used to modify the players final earnings
hook.Add("zyb_PreMoonshineSell", "zyb_PreMoonshineSell_Test", function(ply, earning)

    /*
    if IsValid(ply) and ply:IsSuperAdmin() then
        earning = earning * 2
    end
    */
    return earning
end)

// Called when the player sells moonshine
hook.Add("zyb_OnMoonshineSold", "zyb_OnMoonshineSold_Vrondakis", function(ply, npc, earning, jarCount)
    if IsValid(ply) and zyb.config.VrondakisLevelSystem then

        local xp = zyb.config.Vrondakis["Selling"].XP * jarCount
        ply:addXP(xp, " ", true)
    end
end)

// Called when the player produces a moonshine jar
hook.Add("zyb_OnMoonshineProduced", "zyb_OnMoonshineProduced_Vrondakis", function(condenser)
    if IsValid(condenser) and zyb.config.VrondakisLevelSystem then

        local owner = zyb.f.GetOwner(condenser)
        if IsValid(owner) then
            owner:addXP(zyb.config.Vrondakis["Producing"].XP, " ", true)
        end
    end
end)

// Called when a zyb entity got destroyed
hook.Add("zyb_OnObjectDestroyed", "zyb_OnObjectDestroyed_Test", function(ent, dmginfo)

    /*
    // This is a examble for a reward system, so police players who destroy moonshine get cash
    local attacker = dmginfo:GetAttacker()
    if IsValid(ent) and IsValid(attacker) and attacker:IsPlayer() and attacker:Alive() and attacker:Team() == TEAM_POLICE then

        local JarMoneyValue = 15
        local Reward = 0
        local class = ent:GetClass()

        if class == "zyb_jar" and ent:GetMoonShine() > 0 then
            Reward = JarMoneyValue
        elseif class == "zyb_jarcrate" and ent:GetJarCount() > 0 then
            Reward = JarMoneyValue * ent:GetJarCount()
        elseif class == "zyb_palette" and ent:GetCrateCount() > 0 then
            Reward = (JarMoneyValue * 6) * ent:GetCrateCount()
        end

        if Reward > 0 then
            zyb.f.Notify(attacker, "+" .. zyb.f.Money_Display(Reward), 0)
            zyb.f.GiveMoney(attacker, Reward)
        end
    end
    */
end)
-- leak by lordee