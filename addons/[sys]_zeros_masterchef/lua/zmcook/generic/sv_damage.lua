zmc = zmc or {}
zmc.Damage = zmc.Damage or {}

function zmc.Damage.Inflict(entity,dmg)

	if zmc.config.Damageable[entity:GetClass()] and zmc.config.Damageable[entity:GetClass()] <= -1 then return end

	entity:SetHealth(entity:Health() - dmg:GetDamage())

    if entity:Health() <= 0 then

        if entity:GetClass() == "zmc_item" or entity:GetClass() == "zmc_dish" then
            zclib.NetEvent.Create("eat_effect", {entity,false})
        else
            zclib.Damage.Effect(entity, "HelicopterMegaBomb")
            zclib.Sound.EmitFromPosition(entity:GetPos(), "machine_explode")
        end

        // Stop moving if you have physics
        if entity.PhysicsDestroy then entity:PhysicsDestroy() end

        // Hide entity
        if entity.SetNoDraw then entity:SetNoDraw(true) end

        // This got taken from a Physcollide function but maybe its needed to prevent a crash
        local deltime = FrameTime() * 2
        if not game.SinglePlayer() then deltime = FrameTime() * 6 end
        SafeRemoveEntityDelayed(entity, deltime)
    end
end
