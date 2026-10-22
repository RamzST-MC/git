if CLIENT then return end
zmc = zmc or {}
zmc.Dish = zmc.Dish or {}

function zmc.Dish.Spawn(pos,DishID)
    local DishData = zmc.Dish.GetData(DishID)

    local ent = ents.Create("zmc_dish")
    if not IsValid(ent) then return end
    ent:SetPos(pos)
    ent:Spawn()
    ent:Activate()

    if DishData.mdl then ent:SetModel(DishData.mdl) end

    ent:SetDishID(zmc.Dish.GetUniqueID(DishID))

    return ent
end

function zmc.Dish.Initialize(Dish)
    zclib.EntityTracker.Add(Dish)

    Dish:PhysicsInit(SOLID_VPHYSICS)
    Dish:SetSolid(SOLID_VPHYSICS)
    Dish:SetMoveType(MOVETYPE_VPHYSICS)
    Dish:SetUseType(SIMPLE_USE)
    Dish:DrawShadow(false)
    Dish:PhysWake()

    local phys = Dish:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetDragCoefficient(200)
        phys:SetAngleDragCoefficient(2500)
    end

    Dish:SetMaxHealth( zmc.config.Damageable[Dish:GetClass()] )
    Dish:SetHealth(Dish:GetMaxHealth())

    Dish.CanEat = false
    timer.Simple(1,function()
        if IsValid(Dish) then
            Dish.CanEat = true
        end
    end)
end

function zmc.Dish.OnRemove(Dish)
    zclib.EntityTracker.Remove(Dish)
end

function zmc.Dish.Use(Dish, ply)
    // We delay it a bit to fix the iventory pickup issue
    timer.Simple(0.1,function()
        if IsValid(Dish) and IsValid(ply) and Dish.CanEat == true then zmc.Dish.Eat(Dish, ply) end
    end)
end

function zmc.Dish.Eat(Dish, ply)

    local DishData = zmc.Dish.GetData(Dish:GetDishID())
    if DishData == nil then return end
    if DishData.items == nil then return end
    local foodCount = table.Count(DishData.items)
    if foodCount == 0 then return end

    if Dish:GetEatProgress() == -1 then Dish:SetEatProgress(foodCount) end

    local prog = Dish:GetEatProgress()

    zmc.Item.Eat(DishData.items[prog].uniqueid, ply)

    zclib.NetEvent.Create("eat_effect", {ply,false})
    Dish:SetEatProgress(Dish:GetEatProgress() - 1)
    ply:AddHunger(foodCount)

    if Dish:GetEatProgress() <= 0 then
        SafeRemoveEntity(Dish)
    end
end

concommand.Add("zmc_spawn_dish", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        local tr = ply:GetEyeTrace()
        if tr and tr.Hit and tr.HitPos then
            local id = tonumber(args[1]) or 1
            zmc.Dish.Spawn(tr.HitPos,zmc.config.Dishs[id].uniqueid)
        end
    end
end)

concommand.Add("zmc_spawn_dish_all", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        local tr = ply:GetEyeTrace()

        if tr and tr.Hit and tr.HitPos then
            undo.Create("zmc_spawn_dish_all")
            local y = 0
            local x = 0
            local count = 0
            for k, v in pairs(zmc.config.Dishs) do
                if count > 5 then
                    count = 0
                    y = 0
                    x = x + 25
                end
                local ent = zmc.Dish.Spawn(tr.HitPos + Vector(x, y, 25), v.uniqueid)
                undo.AddEntity(ent)
                undo.SetPlayer(ply)

                y = y + 25
                count = count + 1
            end

            undo.Finish()
        end
    end
end)
