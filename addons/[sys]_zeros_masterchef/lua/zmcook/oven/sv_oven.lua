if CLIENT then return end
zmc = zmc or {}
zmc.Oven = zmc.Oven or {}


function zmc.Oven.Initialize(Oven)
    zmc.Inventory.Setup(Oven,12)
    zmc.Machine.Initialize(Oven)
    Oven:SetBodygroup(1,2)

    Oven:SetMaxHealth( zmc.config.Damageable[Oven:GetClass()] )
    Oven:SetHealth(Oven:GetMaxHealth())
end

function zmc.Oven.OnUse(Oven, ply)
    if zmc.Player.IsCook(ply) == false then return end
    zmc.Machine.Open(Oven, ply)
end

function zmc.Oven.OnRemove(Oven)
    zclib.Timer.Remove("zmc_oven_timer_" .. Oven:EntIndex())
    zclib.EntityTracker.Remove(Oven)
end

function zmc.Oven.OnItemPickUp(Oven,other)
    local ItemID = other:GetItemID()

    if Oven:CanPickUp(ItemID) ~= true then return end

    if zmc.Inventory.Give(Oven, ItemID,{bake_prog = other.bake_prog}) == false then return end

    if Oven:GetTemperatur() > 0 then
        zmc.Oven.StartBaking(Oven)
    end

    return true
end

// This hook gets called when a item gets dropped from a entities inventory
zclib.Hook.Add("zmc_Inventory_Drop", "zmc_Inventory_Drop_oven", function(ent,SlotID,SlotData,item_ent)

    // If the slotdata had a baking progress then lets give the item that too
    if SlotData.bake_prog then
        item_ent.bake_prog = SlotData.bake_prog

        local ItemData = zmc.Item.GetData(SlotData.itm)

        local ResultItemData = zmc.Item.GetData(ItemData.bake.item)

        local fract = (1 / ItemData.bake.time) * (item_ent.bake_prog or 0)

        // Change color depending on progress
        local col = zclib.util.LerpColor(fract, ItemData.color or color_white, ResultItemData.color or color_white)
        item_ent:SetColor(col)

        // Change size depending on progress
        item_ent:SetModelScale(Lerp(fract,ItemData.scale or 1,ResultItemData.scale or 1),0)
    end
end)

function zmc.Oven.OnTemperaturChange(Oven,newTemp)
    if newTemp > 0 then
        zmc.Oven.StartBaking(Oven)
    else
        local timerid = "zmc_oven_timer_" .. Oven:EntIndex()
        zclib.Timer.Remove(timerid)
    end
end

function zmc.Oven.StartBaking(Oven)

    local timerid = "zmc_oven_timer_" .. Oven:EntIndex()
    if timer.Exists(timerid) == true then return end

    zclib.Timer.Create(timerid,1,0,function()
        if not IsValid(Oven) then zclib.Timer.Remove(timerid) return end

        local temp = Oven:GetTemperatur()

        local DidBakeSomthing = false
        for slot_id,slot_data in pairs(zmc.Inventory.Get(Oven)) do
            local ItemData = zmc.Item.GetData(slot_data.itm)
            if ItemData == nil then continue end
            if ItemData.bake == nil then continue end
            // 181085724
            // Does the item have the correct temperatur to bake?
            if zmc.Machine.TemperaturCheck(ItemData.bake, temp) then

                // Increase some progress value for this item
                slot_data.bake_prog = (slot_data.bake_prog or 0) + 1

                DidBakeSomthing = true

                if slot_data.bake_prog >= ItemData.bake.time then
                    zmc.Inventory.Replace(Oven, slot_id, ItemData.bake.item)
                    slot_data.bake_prog = 0
                end
            end
        end


        zmc.Machine.RemoveFuel(Oven, 1)

        if DidBakeSomthing then
            zmc.Inventory.Synch(Oven)
        end
    end)
end
