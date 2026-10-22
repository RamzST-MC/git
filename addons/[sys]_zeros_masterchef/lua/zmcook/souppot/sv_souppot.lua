if CLIENT then return end
zmc = zmc or {}
zmc.SoupPot = zmc.SoupPot or {}


function zmc.SoupPot.Initialize(SoupPot)
    zmc.Inventory.Setup(SoupPot,12)
    zmc.Machine.Initialize(SoupPot)

    SoupPot:SetMaxHealth( zmc.config.Damageable[SoupPot:GetClass()] )
    SoupPot:SetHealth(SoupPot:GetMaxHealth())
end

function zmc.SoupPot.OnUse(SoupPot, ply)
    if zmc.Player.IsCook(ply) == false then return end
    if SoupPot.NextUse and CurTime() < SoupPot.NextUse then return end
    SoupPot.NextUse = CurTime() + 1

    if zmc.Machine.InProgress(SoupPot) then return end

    zmc.Machine.Open(SoupPot, ply)
end

function zmc.SoupPot.OnRemove(SoupPot)
    zclib.EntityTracker.Remove(SoupPot)
    zclib.Timer.Remove("zmc_SoupPot_timer_" .. SoupPot:EntIndex())
end

function zmc.SoupPot.OnItemPickUp(SoupPot,other)
    if SoupPot:GetItemID() <= 0 then return end
    if zmc.Machine.InProgress(SoupPot) then return end

    local ItemID = other:GetItemID()

    if SoupPot:CanPickUp(ItemID) ~= true then return end

    if zmc.Inventory.Give(SoupPot, ItemID) == false then return end

    return true
end

function zmc.SoupPot.CanSelectRecipe(SoupPot,ItemID)
    if zmc.Machine.InProgress(SoupPot) then return false end
    local itemData = zmc.Item.GetData(ItemID)
    if itemData == nil then return false end

    // Can it even be mixed
    if itemData.soup == nil then return false end

    return true
end

function zmc.SoupPot.CanCancel(SoupPot)
    if zmc.Machine.InProgress(SoupPot) then return false end
    zmc.SoupPot.Reset(SoupPot)
    return true
end

function zmc.SoupPot.Start(SoupPot,ply)

    local ItemData = zmc.Item.GetData(SoupPot:GetItemID())
    if ItemData == nil then return end
    if ItemData.soup == nil then return end

    local missing = zmc.Inventory.GetMissing(SoupPot,ItemData.soup.items)
    if table.IsEmpty(missing) then

        // Remove all the ingredients which are needed
        zmc.Inventory.TakeItems(SoupPot, ItemData.soup.items)

        SoupPot:SetCookStart(CurTime())

        local timerid = "zmc_SoupPot_timer_" .. SoupPot:EntIndex()
        zclib.Timer.Remove(timerid)
        zclib.Timer.Create(timerid,ItemData.soup.time,1,function()
            if not IsValid(SoupPot) then zclib.Timer.Remove(timerid) return end
            zmc.Machine.RemoveFuel(SoupPot, ItemData.soup.time)
            zmc.SoupPot.Finished(SoupPot,ply)
            zclib.Timer.Remove(timerid)
        end)

        return true
    end
end

function zmc.SoupPot.Finished(SoupPot,ply)
    local ItemData = zmc.Item.GetData(SoupPot:GetItemID())
    if ItemData == nil then return end
    if ItemData.soup == nil then return end

    // Spawn the food
    for i = 1,(ItemData.soup.amount or 1) do
        if zmc.Inventory.Give(SoupPot, ItemData.uniqueid) == false then
            // We could not find a free slot so lets just drop the item to the floor
            local item_ent = zmc.Item.Spawn(SoupPot:LocalToWorld(Vector(0,0,15 + (5 * i))),ItemData.uniqueid)
            if not IsValid(item_ent) then return end
            zclib.Player.SetOwner(item_ent, ply)
        end
    end

    zmc.SoupPot.Reset(SoupPot)
end

function zmc.SoupPot.Reset(SoupPot)
    SoupPot:SetCookStart(-1)
end
