if CLIENT then return end
zmc = zmc or {}
zmc.Grill = zmc.Grill or {}


function zmc.Grill.Initialize(Grill)
    zmc.Inventory.Setup(Grill,12)
    zmc.Machine.Initialize(Grill)

    Grill:SetBodygroup(1,1)
    Grill:SetMaxHealth( zmc.config.Damageable[Grill:GetClass()] )
    Grill:SetHealth(Grill:GetMaxHealth())
end

function zmc.Grill.OnUse(Grill, ply)

    if zmc.Player.IsCook(ply) == false then return end

    if Grill:GetQuickTimeEvent() > 0 then
        zclib.NetEvent.Create("grill_flip", {Grill})
        zmc.Grill.QuickTimeEvent_Respone(Grill,ply)
        return
    end

    zmc.Machine.Open(Grill, ply)
end

function zmc.Grill.OnRemove(Grill)
    zclib.EntityTracker.Remove(Grill)
    zclib.Timer.Remove("zmc_Grill_timer_" .. Grill:EntIndex())
    zclib.Timer.Remove("zmc_Grill_quicktimeevent_timer_" .. Grill:EntIndex())
end

function zmc.Grill.OnItemPickUp(Grill,other)
    local ItemID = other:GetItemID()

    if Grill:CanPickUp(ItemID) ~= true then return false end

    if zmc.Inventory.Give(Grill, ItemID,{grill_prog = other.grill_prog}) == false then return end

    if Grill:GetTemperatur() > 0 then
        zmc.Grill.StartGrilling(Grill)
    end

    return true
end


// This hook gets called when a item gets dropped from a entities inventory
zclib.Hook.Add("zmc_Inventory_Drop", "zmc_Inventory_Drop_Grill", function(ent,SlotID,SlotData,item_ent)

    // If the slotdata had a baking progress then lets give the item that too
    if SlotData.grill_prog then
        item_ent.grill_prog = SlotData.grill_prog

        local ItemData = zmc.Item.GetData(SlotData.itm)

        local ResultItemData = zmc.Item.GetData(ItemData.grill.item)

        local fract = (1 / ItemData.grill.time) * (item_ent.grill_prog or 0)

        // Change color depending on progress
        local col = zclib.util.LerpColor(fract, ItemData.color or color_white, ResultItemData.color or color_white)
        item_ent:SetColor(col)

        // Change size depending on progress
        item_ent:SetModelScale(Lerp(fract,ItemData.scale or 1,ResultItemData.scale or 1),0)
    end
end)

function zmc.Grill.OnTemperaturChange(Grill,newTemp)
    if newTemp > 0 then
        zmc.Grill.StartGrilling(Grill)
    else
        local timerid = "zmc_Grill_timer_" .. Grill:EntIndex()
        zclib.Timer.Remove(timerid)
    end
end

function zmc.Grill.StartGrilling(Grill)
    zclib.Debug("zmc.Grill.StartGrilling")

    local timerid = "zmc_Grill_timer_" .. Grill:EntIndex()
    if timer.Exists(timerid) == true then return end

    zclib.Timer.Create(timerid,1,0,function()
        if not IsValid(Grill) then zclib.Timer.Remove(timerid) return end
        local temp = Grill:GetTemperatur()

        local icrease = (1 * ((zmc.config.Grill.heat_speed_mul / 100) * temp))
        local DidGrillSomthing = false
        for slot_id,slot_data in pairs(zmc.Inventory.Get(Grill)) do
            local ItemData = zmc.Item.GetData(slot_data.itm)
            if ItemData == nil then continue end
            if ItemData.grill == nil then continue end


            // Increase some progress value for this item
            slot_data.grill_prog = (slot_data.grill_prog or 0) + icrease

            DidGrillSomthing = true

            if slot_data.grill_prog >= ItemData.grill.time then
                zmc.Inventory.Replace(Grill, slot_id, ItemData.grill.item)
                slot_data.grill_prog = 0
            end
        end

        zmc.Machine.RemoveFuel(Grill, 1)

        if zmc.config.Grill.CanIgniteObjects then
            local c_trace = zclib.util.TraceLine({
                start = Grill:LocalToWorld(Vector(0, 0, 43)),
            endpos = Grill:LocalToWorld(Vector(0, 0, 60)),
                filter = {Grill}
            }, "zmc_grill_igniter")
            //debugoverlay.Line( Grill:LocalToWorld(Vector(0, 0, 43)),  Grill:LocalToWorld(Vector(0, 0, 60)), 1,  Color( 255, 0, 0 ),true )
            if c_trace and c_trace.Hit and IsValid(c_trace.Entity) then
                c_trace.Entity:Ignite(1,1)
            end
        end

        if DidGrillSomthing then
            zmc.Inventory.Synch(Grill)

            // Check if a overcook event should appear?
            if Grill.NextQuickTimeEvent == nil or CurTime() > Grill.NextQuickTimeEvent then
                Grill.NextQuickTimeEvent = CurTime() + zmc.config.Grill.qte_interval

                // Does a event occur?
                if math.random(100) < ((zmc.config.Grill.qte_chance / 100) * Grill:GetTemperatur()) then

                    // Start quicktime event
                    zmc.Grill.QuickTimeEvent_Start(Grill)
                    return
                end
            end
        end
    end)
end

function zmc.Grill.QuickTimeEvent_Start(Grill)
    zclib.Debug("zmc.Grill.QuickTimeEvent_Start")

    Grill:EmitSound("zmc_grill_qte_start")

    // Stop work timer
    timer.Pause("zmc_Grill_timer_" .. Grill:EntIndex())

    // Set some var to indicate the net event
    Grill:SetQuickTimeEvent(CurTime() + zmc.config.Grill.qte_respone_time)

    local timerid = "zmc_Grill_quicktimeevent_timer_" .. Grill:EntIndex()
    zclib.Timer.Remove(timerid)
    zclib.Timer.Create(timerid,zmc.config.Grill.qte_respone_time,1,function()
        if not IsValid(Grill) then zclib.Timer.Remove(timerid) return end
        Grill:EmitSound("zmc_grill_qte_fail")
        local ValidItems = {}
        for k,v in pairs(zmc.Inventory.Get(Grill)) do
            if v and v.itm and math.random(10) > 5 then
                table.insert(ValidItems,k)
            end
        end

        ValidItems = zclib.table.randomize( ValidItems )

        local count = 0
        for k,v in pairs(ValidItems) do
            if count > zmc.config.Grill.qte_fail_loss then
                break
            else
                zmc.Inventory.EmptySlot(Grill, v)
                count = count + 1
            end
        end
        zmc.Inventory.Synch(Grill)

        zmc.Grill.QuickTimeEvent_Respone(Grill)
    end)
end

function zmc.Grill.QuickTimeEvent_Respone(Grill,ply)
    zclib.Debug("zmc.Grill.QuickTimeEvent_Respone")
    // Continue
    timer.UnPause("zmc_Grill_timer_" .. Grill:EntIndex())
    zclib.Timer.Remove("zmc_Grill_quicktimeevent_timer_" .. Grill:EntIndex())
    Grill:SetQuickTimeEvent(-1)
end
