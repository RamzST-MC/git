if CLIENT then return end
zmc = zmc or {}
zmc.Washtable = zmc.Washtable or {}
zmc.Washtable.List = zmc.Washtable.List or {}

function zmc.Washtable.Initialize(Washtable)
    zclib.EntityTracker.Add(Washtable)

    Washtable:SetMaxHealth( zmc.config.Damageable[Washtable:GetClass()] )
    Washtable:SetHealth(Washtable:GetMaxHealth())

    table.insert(zmc.Washtable.List,Washtable)
end

function zmc.Washtable.OnUse(Washtable, ply)

    //if zmc.Player.IsCook(ply) == false then return end

    if Washtable:GetPlateCount() <= 0 then return end

    Washtable:SetWashProgress(Washtable:GetWashProgress() + 1)
    zclib.NetEvent.Create("cleaning", {Washtable})

    if Washtable:GetWashProgress() >= zmc.config.Washtable.progress_count then
        Washtable:EmitSound("zmc_plates")
        Washtable:SetPlateCount(math.Clamp(Washtable:GetPlateCount() - 1,0,zmc.config.Washtable.limit))
        Washtable:SetWashProgress(0)
    end
end

function zmc.Washtable.AddDirtyPlate(Washtable)
    Washtable:EmitSound("zmc_plates")
    Washtable:SetPlateCount(math.Clamp(Washtable:GetPlateCount() + 1,0,zmc.config.Washtable.limit))
end

function zmc.Washtable.HasCleanPlates(Washtable)
    return Washtable:GetPlateCount() < zmc.config.Washtable.limit
end

function zmc.Washtable.GetCleanPlates(Washtable)
    return math.Clamp(zmc.config.Washtable.limit - Washtable:GetPlateCount(),0,zmc.config.Washtable.limit)
end


function zmc.Washtable.OnRemove(Washtable)
    zclib.EntityTracker.Remove(Washtable)
    table.RemoveByValue(zmc.Washtable.List,Washtable)
end

concommand.Add("zmc_debug_washtable", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        local tr = ply:GetEyeTrace()
        if tr and tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmc_washtable" then
            zmc.Washtable.AddDirtyPlate(tr.Entity)
        end
    end
end)
