if CLIENT then return end
zmc = zmc or {}
zmc.Wok = zmc.Wok or {}


function zmc.Wok.Initialize(Wok)
    zmc.Inventory.Setup(Wok,12)
    zmc.Machine.Initialize(Wok)

    /*
    timer.Simple(2,function()
        Wok:SetItemID(zmc.Item.GetListID("3b44867a77"))
        local ItemData = zmc.Item.GetData(Wok:GetItemID())
        for k,v in pairs(ItemData.wok.items) do
            zmc.Inventory.Give(Wok, v)
        end
    end)
    */

    Wok:SetMaxHealth( zmc.config.Damageable[Wok:GetClass()] )
    Wok:SetHealth(Wok:GetMaxHealth())
end

util.AddNetworkString("zmc_wok_pointercheck")
function zmc.Wok.OnUse(Wok, ply)
    if Wok.NextUse and CurTime() < Wok.NextUse then return end
    Wok.NextUse = CurTime() + zmc.Wok.GetCooldown()

    if zmc.Player.IsCook(ply) == false then return end

    if zmc.Machine.InProgress(Wok) then
        return
    end

    zmc.Machine.Open(Wok, ply)
end
net.Receive("zmc_wok_pointercheck", function(len,ply)
    zclib.Debug_Net("zmc_wok_pointercheck", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    local Wok = net.ReadEntity()
    local result = net.ReadBool()
    if not IsValid(Wok) then return end
    if zclib.util.InDistance(Wok:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

    if result == false then return end

    // Increase Progress
    Wok:SetProgress(Wok:GetProgress() + 1)

    if Wok.Finished == true then return end

    local ItemData = zmc.Item.GetData(Wok:GetItemID())
    if ItemData == nil then return end
    if ItemData.wok == nil then return end
    if ItemData.wok.cycle == nil then return end
    if Wok:GetProgress() >= ItemData.wok.cycle then
        Wok.Finished = true
        // We delay it a bit so it can finish the last flip animation before it resets itself
        timer.Simple(1, function()
            if IsValid(Wok) then
                Wok.Finished = nil
                if IsValid(ply) then zmc.Wok.Finished(Wok, ply) end
            end
        end)
    end
end)

function zmc.Wok.OnRemove(Wok)
    zclib.EntityTracker.Remove(Wok)
end

function zmc.Wok.OnItemPickUp(Wok,other)
    if Wok:GetItemID() <= 0 then return end
    if zmc.Machine.InProgress(Wok) then return end

    local ItemID = other:GetItemID()

    if Wok:CanPickUp(ItemID) ~= true then return end

    if zmc.Inventory.Give(Wok, ItemID) == false then return end

    return true
end

function zmc.Wok.CanSelectRecipe(Wok,ItemID)
    if zmc.Machine.InProgress(Wok) then return false end
    local itemData = zmc.Item.GetData(ItemID)
    if itemData == nil then return false end

    // Can it even be mixed
    if itemData.wok == nil then return false end

    return true
end

function zmc.Wok.CanCancel(Wok)
    if zmc.Machine.InProgress(Wok) then return false end
    zmc.Wok.Reset(Wok)
    return true
end

function zmc.Wok.Start(Wok,ply)

    local ItemData = zmc.Item.GetData(Wok:GetItemID())
    if ItemData == nil then return end
    if ItemData.wok == nil then return end

    local missing = zmc.Inventory.GetMissing(Wok,ItemData.wok.items)
    if table.IsEmpty(missing) then

        // Remove all the ingredients which are needed
        zmc.Inventory.TakeItems(Wok, ItemData.wok.items)

        Wok:SetProgress(0)
        return true
    end
end

function zmc.Wok.Finished(Wok,ply)
    local ItemData = zmc.Item.GetData(Wok:GetItemID())
    if ItemData == nil then return end
    if ItemData.wok == nil then return end

    zmc.Machine.RemoveFuel(Wok, ItemData.wok.cycle)

    // Spawn the food
    for i = 1,ItemData.wok.amount do
        if zmc.Inventory.Give(Wok, ItemData.uniqueid) == false then
            // We could not find a free slot so lets just drop the item to the floor
            local item_ent = zmc.Item.Spawn(Wok:LocalToWorld(Vector(0,0,15 + (5 * i))),ItemData.uniqueid)
            if not IsValid(item_ent) then return end
            zclib.Player.SetOwner(item_ent, ply)
        end
    end

    zmc.Wok.Reset(Wok)
end

function zmc.Wok.Reset(Wok)
    Wok:SetProgress(-1)
end
