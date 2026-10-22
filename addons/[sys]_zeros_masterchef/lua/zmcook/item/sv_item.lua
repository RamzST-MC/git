if CLIENT then return end
zmc = zmc or {}
zmc.Item = zmc.Item or {}

zmc.Item.List = zmc.Item.List or {}
function zmc.Item.Spawn(pos,ItemID)

    local ItemData = zmc.Item.GetData(ItemID)
    if ItemData == nil then return end

    local ent = ents.Create("zmc_item")
    if not IsValid(ent) then return end
    ent:SetPos(pos)
    ent:Spawn()

    zmc.Item.UpdateVisual(ent,ItemData,true)

    ent:SetItemID(tostring(ItemData.uniqueid))

    ent:Activate()
    return ent
end

function zmc.Item.Initialize(Item)
    zclib.EntityTracker.Add(Item)

    Item:PhysicsInit(SOLID_VPHYSICS)
    Item:SetSolid(SOLID_VPHYSICS)
    Item:SetMoveType(MOVETYPE_VPHYSICS)
    Item:SetUseType(SIMPLE_USE)
    Item:DrawShadow(false)

    Item:SetMaxHealth( zmc.config.Damageable[Item:GetClass()] )
    Item:SetHealth(Item:GetMaxHealth())

    timer.Simple(1, function()
        if IsValid(Item) then
            zmc.RotSystem.Add(Item)
        end
    end)

    zmc.Item.Despawner(Item)
end

function zmc.Item.OnRemove(Item)
    zclib.EntityTracker.Remove(Item)
end

function zmc.Item.Use(Item, ply)
    -- We delay it a bit to fix the iventory pickup issue
    timer.Simple(0.1, function()
        if IsValid(Item) and IsValid(ply) then
            if Item:GetIsRotten() then
                zmc.Item.EatRotten(ply)
                zclib.NetEvent.Create("eat_effect", {ply, true})
                SafeRemoveEntity(Item)
            else
                if zmc.Item.Eat(Item:GetItemID(), ply) then
                    local itemData = zmc.Item.GetData(Item:GetItemID())
                    zclib.NetEvent.Create("eat_effect", {ply, itemData.edible.health <= 0})
                    SafeRemoveEntity(Item)
                end
            end
        end
    end)
end

function zmc.Item.Eat(ItemID, ply)
    local itemData = zmc.Item.GetData(ItemID)
    if itemData and itemData.edible then

        local _health = itemData.edible.health or 1
        local _cap = itemData.edible.health_cap or 100

        local newEnergy = math.Clamp(_health, 1, _cap)
        ply:AddHunger(newEnergy)

        return true
    end
end

function zmc.Item.EatRotten(ply)
    local _health = -10
    local _cap = 10

    local newEnergy = math.Clamp((ply:GetHunger() or 100) + _health, 1, _cap)
    ply:AddHunger(newEnergy)
end

concommand.Add("zmc_spawn_item", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        local name = args[1]
        local tr = ply:GetEyeTrace()
        if tr and tr.Hit and tr.HitPos and name then
            zmc.Item.Spawn(tr.HitPos,name)
        end
    end
end)

concommand.Add("zmc_spawn_item_all", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then

        local comp = args[1]

        local tr = ply:GetEyeTrace()

        if tr and tr.Hit and tr.HitPos then
            undo.Create("zmc_spawn_item_all")
            local y = 0
            local x = 0
            local count = 0
            for k, v in pairs(zmc.config.Items) do
                if comp and isstring(comp) and v[comp] == nil then continue end

                if count > 5 then
                    count = 0
                    y = 0
                    x = x + 25
                end

                local ent = zmc.Item.Spawn(tr.HitPos + Vector(x, y , 25), tostring(v.uniqueid))
                undo.AddEntity(ent)
                undo.SetPlayer(ply)

                y = y + 25
                count = count + 1
            end

            undo.Finish()
        end
    end
end)

function zmc.Item.Despawner(Item)
    if zmc.config.Item.DespawnTime <= 0 then return end

    Item.DeSpawnTime = CurTime() + zmc.config.Item.DespawnTime

    table.insert(zmc.Item.List, Item)

    if timer.Exists("zmc_item_despawn") == false then
        zclib.Timer.Create("zmc_item_despawn", 10, 0, function()
            if zmc.Item.List == nil then
                zclib.Timer.Remove("zmc_item_despawn")
            end

            if table.Count(zmc.Item.List) <= 0 then
                zclib.Timer.Remove("zmc_item_despawn")
            end

            for k, v in pairs(zmc.Item.List) do
                if v == nil then
                    zmc.Item.List[k] = nil
                    continue
                end

                if not IsValid(v) then
                    zmc.Item.List[k] = nil
                    continue
                end

                if CurTime() > v.DeSpawnTime then
                    SafeRemoveEntity(v)
                    zmc.Item.List[k] = nil
                end
            end
        end)
    end
end

function zmc.Item.Spoil(Item)
    Item:SetIsRotten(true)
    Item:SetMaterial("zerochain/props_kitchen/zmc_rott_diff")
end
