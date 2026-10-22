if CLIENT then return end
zmc = zmc or {}
zmc.BoilPot = zmc.BoilPot or {}


function zmc.BoilPot.Initialize(BoilPot)
    zmc.Inventory.Setup(BoilPot,12)
    zmc.Machine.Initialize(BoilPot)

    BoilPot:SetMaxHealth( zmc.config.Damageable[BoilPot:GetClass()] )
    BoilPot:SetHealth(BoilPot:GetMaxHealth())
end

function zmc.BoilPot.OnUse(BoilPot, ply)
    if zmc.Player.IsCook(ply) == false then return end
    zmc.Machine.Open(BoilPot, ply)
end

function zmc.BoilPot.OnRemove(BoilPot)
    zclib.Timer.Remove("zmc_BoilPot_timer_" .. BoilPot:EntIndex())
    zclib.EntityTracker.Remove(BoilPot)
end

function zmc.BoilPot.CanPickUp(BoilPot,ItemID)
    local ItemData = zmc.Item.GetData(ItemID)
    if ItemData == nil then return false end
    if ItemData.boil == nil then return false end
    return true
end

function zmc.BoilPot.OnItemPickUp(BoilPot,other)
    local ItemID = other:GetItemID()
    if BoilPot:CanPickUp(ItemID) ~= true then return end

    if zmc.Inventory.Give(BoilPot, ItemID) == false then return end

    if BoilPot:GetTemperatur() > 0 then
        zmc.BoilPot.StartBoiling(BoilPot)
    end

    return true
end

function zmc.BoilPot.OnTemperaturChange(BoilPot,newTemp)
    if newTemp > 0 then
        zmc.BoilPot.StartBoiling(BoilPot)
    else
        local timerid = "zmc_BoilPot_timer_" .. BoilPot:EntIndex()
        zclib.Timer.Remove(timerid)
    end
end

function zmc.BoilPot.StartBoiling(BoilPot)

    local timerid = "zmc_BoilPot_timer_" .. BoilPot:EntIndex()
    if timer.Exists(timerid) == true then return end

    zclib.Timer.Create(timerid,1,0,function()
        if not IsValid(BoilPot) then zclib.Timer.Remove(timerid) return end
        local temp = BoilPot:GetTemperatur()

        local DidBoilSomthing = false
        for slot_id,slot_data in pairs(zmc.Inventory.Get(BoilPot)) do
            local ItemData = zmc.Item.GetData(slot_data.itm)
            if ItemData == nil then continue end
            if ItemData.boil == nil then continue end

            // Does the item have the correct temperatur to boil?
            if zmc.Machine.TemperaturCheck(ItemData.boil, temp) then

                // Increase some progress value for this item
                slot_data.boil_prog = (slot_data.boil_prog or 0) + 1

                DidBoilSomthing = true

                if slot_data.boil_prog >= ItemData.boil.time then
                    zmc.Inventory.Replace(BoilPot, slot_id, ItemData.boil.item)
                    slot_data.boil_prog = 0
                end
            end
        end

        zmc.Machine.RemoveFuel(BoilPot, 1)

        if DidBoilSomthing then
            zmc.Inventory.Synch(BoilPot)
        end
    end)
end
