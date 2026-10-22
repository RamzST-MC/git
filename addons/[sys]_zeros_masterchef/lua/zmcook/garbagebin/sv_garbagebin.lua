if CLIENT then return end
zmc = zmc or {}
zmc.Garbagebin = zmc.Garbagebin or {}


function zmc.Garbagebin.Initialize(Garbagebin)
    zclib.EntityTracker.Add(Garbagebin)

    Garbagebin:SetMaxHealth( zmc.config.Damageable[Garbagebin:GetClass()] )
    Garbagebin:SetHealth(Garbagebin:GetMaxHealth())
end

function zmc.Garbagebin.OnRemove(Garbagebin)
    zclib.EntityTracker.Remove(Garbagebin)
end

function zmc.Garbagebin.StartTouch(Garbagebin,other)
    if not IsValid(Garbagebin) then return end
    if not IsValid(other) then return end
    if other:GetClass() ~= "zmc_item" and other:GetClass() ~= "zmc_dish" then return end
    if zclib.util.CollisionCooldown(other) then return end


	if zclib.Entity.GettingRemoved(other) then return end

    zclib.Entity.SafeRemove(other)
end
