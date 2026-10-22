if CLIENT then return end
zmc = zmc or {}
zmc.Inventory = zmc.Inventory or {}

/*

    This inventory system does not get saved and is only used to temporarly store items

*/


function zmc.Inventory.Setup(ent,size)
    zclib.Debug("zmc.Inventory.Setup")
    ent.zmc_inv = {}
    for i = 1, size do ent.zmc_inv[i] = {} end

    timer.Simple(0.1,function()
         zmc.Inventory.Synch(ent)
    end)
end

function zmc.Inventory.SetSlotData(ent, SlotID,SlotData)
    ent.zmc_inv[SlotID] = table.Copy(SlotData)
end

function zmc.Inventory.Give(ent, ItemID,extraData)
    zclib.Debug("zmc.Inventory.Give " .. ItemID)
    local FreeSlot = zmc.Inventory.FindFreeSlot(ent)
    if FreeSlot then
        ent.zmc_inv[FreeSlot] = {itm = ItemID}
        if extraData then table.Merge( ent.zmc_inv[FreeSlot], extraData ) end

        zmc.Inventory.Synch(ent)
    end
    return FreeSlot
end

function zmc.Inventory.Take(ent, ItemID)
    zclib.Debug("zmc.Inventory.Take " .. ItemID)
    local key = zmc.Inventory.FindItem(ent,ItemID)
    if key then
        ent.zmc_inv[key] = {}
        zmc.Inventory.Synch(ent)
        return key
    else
        return false
    end
end

function zmc.Inventory.TakeItems(ent, Items)
    for k, v in pairs(Items) do
        local key = zmc.Inventory.FindItem(ent, v)
        if key then
            ent.zmc_inv[key] = {}
        end
    end
    zmc.Inventory.Synch(ent)
end

function zmc.Inventory.EmptySlot(ent, SlotID)
    zclib.Debug("zmc.Inventory.EmptySlot " .. SlotID)
    if ent.zmc_inv[SlotID] == nil or ent.zmc_inv[SlotID] == {} then return false end
    ent.zmc_inv[SlotID] = {}
    zmc.Inventory.Synch(ent)
    return true
end

// Replaces the specified slot with another ItemID
function zmc.Inventory.Replace(ent, Slot, ItemID)
    zclib.Debug("zmc.Inventory.Replace " .. ItemID)
    ent.zmc_inv[Slot] = {itm = ItemID}

    //zmc.Inventory.Synch(ent)
    return slot
end
