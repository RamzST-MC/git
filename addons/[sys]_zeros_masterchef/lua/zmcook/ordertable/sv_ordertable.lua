if CLIENT then return end
zmc = zmc or {}
zmc.Ordertable = zmc.Ordertable or {}

function zmc.Ordertable.Initialize(Ordertable)

    Ordertable.DishWhitelist = {}

    zclib.EntityTracker.Add(Ordertable)

    zmc.Inventory.Setup(Ordertable, 8)

    Ordertable:SetMaxHealth( zmc.config.Damageable[Ordertable:GetClass()] )
    Ordertable:SetHealth(Ordertable:GetMaxHealth())
end

function zmc.Ordertable.OnUse(Ordertable, ply)
    zmc.Ordertable.Open(Ordertable, ply)
end

function zmc.Ordertable.OnRemove(Ordertable)
    zclib.Timer.Remove("zmc_ordertable_updatetimer_" .. Ordertable:EntIndex())
    zclib.Timer.Remove("zmc_ordertable_customertimer_" .. Ordertable:EntIndex())
    zclib.EntityTracker.Remove(Ordertable)
	zmc.Ordertable.ClearAllOrders(Ordertable)
end

function zmc.Ordertable.StartTouch(Ordertable,other)
    if not IsValid(Ordertable) then return end
    if not IsValid(other) then return end
    if other:GetClass() ~= "zmc_dish" then return end
    if zclib.util.CollisionCooldown(other) then return end

	if zclib.Entity.GettingRemoved(other) then return end

    // Did someone already eat from that?
    if other:GetEatProgress() ~= -1 then return end

    local DishID = other:GetDishID()

    // Check if we got a order for this Dish
    local Dish_ListID = zmc.Dish.GetListID(other:GetDishID())
    if Dish_ListID == nil then return end

    // Find the order with the least amount of time left who wants this dish
    local slot = zmc.Ordertable.GetOrder(Ordertable,DishID)

    // Add the Dish as a ReadyToGo order for someone later to eat
    if slot == false and zmc.Inventory.Give(Ordertable, DishID,{ReadyToGo = true}) ~= false then

        zclib.Entity.SafeRemove(other)

        zmc.Ordertable.OrderUpdate_Start(Ordertable)
        return
    end

    local SlotData = zmc.Inventory.GetSlotData(Ordertable,slot)
    if SlotData == nil then return end

    // If the Food Order has a player assigned then give the player the food, otherwhise serv it a npc
    if SlotData.ply then
        zmc.Ordertable.OnOrderSendToPlayer(Ordertable,DishID,SlotData.ply)
    else
        // Serve food
        zmc.Customertable.ServFood(SlotData.cu_tbl,SlotData.seat,false)
    end

    // Update Customer spawn interval
    zmc.Ordertable.UpdateCustomerInterval(Ordertable)

    // Clear food from inv
    zmc.Inventory.EmptySlot(Ordertable, slot)

    // Remove food ent
    zclib.Entity.SafeRemove(other)
end

function zmc.Ordertable.GetActiveOrders(Ordertable)
    local Count = 0
    for slot_id,slot_data in pairs(zmc.Inventory.Get(Ordertable)) do
        if slot_data == nil then continue end
        if slot_data.itm == nil then continue end

        Count = Count + 1
    end
    return Count
end

function zmc.Ordertable.AddOrder(Ordertable,DishID,CustomerTable,SeatID)
    zmc.Inventory.Give(Ordertable, DishID,{time = CurTime(),cu_tbl = CustomerTable,seat = SeatID})

    zmc.Ordertable.OrderUpdate_Start(Ordertable)
end

function zmc.Ordertable.AddPlayerOrder(Ordertable,DishID,SteamID64)

    zmc.Ordertable.OrderUpdate_Start(Ordertable)
    return zmc.Inventory.Give(Ordertable, DishID,{time = CurTime(),ply = SteamID64})
end

// Returns the slot of the order with the least amount of time left
function zmc.Ordertable.GetOrder(Ordertable,DishID)
    if DishID == nil then return false end
    local slot = false
    local time = 999999999999
    for k,v in pairs(zmc.Inventory.Get(Ordertable)) do
        if v == nil then continue end
        if v.time == nil then continue end
        if v.itm ~= DishID then continue end
        local orderTime = zmc.Dish.GetOrderTime(v.itm)
        local left = math.Clamp((v.time + orderTime) - CurTime(),0,orderTime)

        if left > time then continue end
        time = left
        slot = k
    end
    return slot
end

// Returns the first ReadyToGo order that matches the specified DishID
function zmc.Ordertable.FindReadyToGoOrder(Ordertable,DishID)
    local Slot

    for k,v in pairs(zmc.Inventory.Get(Ordertable)) do
        if v == nil then continue end
        if v.ReadyToGo and v.itm == DishID then
            Slot = k
            break
        end
    end
    return Slot
end

function zmc.Ordertable.GetReadyToGoOrder(Ordertable,CustomerTable)
    local Slot,DishID

    for k,v in pairs(zmc.Inventory.Get(Ordertable)) do
        if v == nil then continue end
        if v.ReadyToGo then
            // If the table which is ordering has a DishWhitelist then lets check if the buffet has any food that the table preferes
            if CustomerTable.DishWhitelist and table.Count(CustomerTable.DishWhitelist) > 0 then
                if CustomerTable.DishWhitelist[v.itm] then
                    Slot = k
                    DishID = v.itm
                    break
                end
            else
                Slot = k
                DishID = v.itm
                break
            end
        end
    end
    return Slot,DishID
end

function zmc.Ordertable.OrderUpdate_Start(Ordertable)
    local timerid = "zmc_ordertable_updatetimer_" .. Ordertable:EntIndex()
    if timer.Exists(timerid) == true then return end
    zclib.Timer.Remove(timerid)
    zclib.Timer.Create(timerid, 1, 0, function()
        if not IsValid(Ordertable) then zclib.Timer.Remove(timerid) return end
        zmc.Ordertable.UpdateOrders(Ordertable)
    end)
end

function zmc.Ordertable.UpdateOrders(Ordertable)
    if not IsValid(Ordertable) then return end

    if zmc.Ordertable.GetActiveOrders(Ordertable) <= 0 then
        zclib.Timer.Remove("zmc_ordertable_updatetimer_" .. Ordertable:EntIndex())
        return
    end

    for slot_id,slot_data in pairs(zmc.Inventory.Get(Ordertable)) do
        if slot_data == nil then continue end
        if slot_data.time == nil then continue end

        if slot_data.ply == nil and not IsValid(slot_data.cu_tbl) then
            zmc.Inventory.EmptySlot(Ordertable, slot_id)
            continue
        end

        local orderTime = zmc.Dish.GetOrderTime(slot_data.itm)

        // Times up, remove it again, customer angry
        if CurTime() > (slot_data.time + orderTime) then

            if slot_data.ply then
                zmc.OrderMenu.OrderFailed(slot_data.itm, slot_data.ply)
            end

            // Remove Dish Order from table
            zmc.Inventory.EmptySlot(Ordertable, slot_id)

            // Give bad review
            if IsValid(slot_data.cu_tbl) and slot_data.seat and IsValid(Ordertable) and slot_data.cu_tbl.CustomerData[slot_data.seat] then
                zmc.Ordertable.OnOrderFailed(Ordertable,slot_data.itm,slot_data.cu_tbl.CustomerData[slot_data.seat].customer_id)

                zmc.Customertable.Clear(slot_data.cu_tbl,slot_data.seat)
            end

            // Update Customer spawn interval
            zmc.Ordertable.UpdateCustomerInterval(Ordertable)
        end
    end
end

// Clears all the orders which arent delivered yet
function zmc.Ordertable.ClearAllOrders(Ordertable)
    for slot_id,slot_data in pairs(zmc.Inventory.Get(Ordertable)) do
        if slot_data == nil then continue end
        if slot_data.time == nil then continue end

        if IsValid(slot_data.cu_tbl) and slot_data.seat then
            zmc.Customertable.Clear(slot_data.cu_tbl,slot_data.seat)
        end

        // Make sure you refund the players if we clear its order
        if slot_data.ply then
            zmc.OrderMenu.OrderFailed(slot_data.itm, slot_data.ply)
        end

        zmc.Inventory.EmptySlot(Ordertable, slot_id)
    end
end

function zmc.Ordertable.UpdateCustomerInterval(Ordertable)
    local rating = Ordertable:GetCustomerRating()

    // Adjust the timer but with modified interval, depending on rating
    local t = (1 / 100) * rating
    local interval = Lerp(t,zmc.config.Order.customer_interval.max,zmc.config.Order.customer_interval.min)

	// If we dont accept custom orders then we make the npcs spawn more often
	if not Ordertable:GetCustomOrders() then
		interval = zmc.config.Order.customer_interval.min
	end

    timer.Adjust( "zmc_ordertable_customertimer_" .. Ordertable:EntIndex(), interval )
end

// Checks if we have space on the washtable for more dirty plates aka New orders
function zmc.Ordertable.WashtableCheck(Ordertable)
    local CleanPlates = 0
    local FoundWashtable = false
    for k,v in pairs(zmc.Washtable.List) do
        if IsValid(v) and zclib.util.InDistance(v:GetPos(), Ordertable:GetPos(), zmc.config.Order.search_dist) then
            FoundWashtable = true
            CleanPlates = CleanPlates + zmc.Washtable.GetCleanPlates(v)
        end
    end
    if FoundWashtable and CleanPlates <= 0 then
        return false
    else
        return true
    end
end

util.AddNetworkString("zmc_Ordertable_open")
function zmc.Ordertable.Open(Ordertable, ply)

    local e_String = util.TableToJSON(Ordertable.DishWhitelist or {})
    local e_Compressed = util.Compress(e_String)

    net.Start("zmc_Ordertable_open")
    net.WriteEntity(Ordertable)
    net.WriteUInt(#e_Compressed,16)
    net.WriteData(e_Compressed,#e_Compressed)
    net.Send(ply)
end

///////////////////////////////////////////////////////////////////

util.AddNetworkString("zmc_Ordertable_toggle")
net.Receive("zmc_Ordertable_toggle", function(len,ply)
    zclib.Debug_Net("zmc_Ordertable_toggle", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Ordertable = net.ReadEntity()
    local toggle = net.ReadBool()

    //if zmc.config.Order.allow_customer_orders_adminonly == true and zclib.Player.IsAdmin(ply) == false then return end

    if not IsValid(Ordertable) then return end
    if Ordertable:GetClass() ~= "zmc_ordertable" then return end
    if zclib.util.InDistance(Ordertable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end
    if toggle == nil then return end

    if zmc.Player.IsCook(ply) == false then return end

	// If its not a public entity and the player dont owns it then stop
	if not Ordertable.IsPublicEntity and not zclib.Player.IsOwner(ply, Ordertable) then
		zclib.Notify(ply, zmc.language["YouDontOwnThis"], 1)
		return
	end

    Ordertable:SetAcceptOrders(toggle)

    // Clear any existing orders which are not delivered yet!
    zmc.Ordertable.ClearAllOrders(Ordertable)

    Ordertable:SetSkin(toggle and 1 or 0)

    if toggle == true then
        zmc.Ordertable.Start(Ordertable)
    else
        zclib.Timer.Remove("zmc_ordertable_customertimer_" .. Ordertable:EntIndex())

        // Spawn Money
        local money = Ordertable:GetEarnings()
        if money > 0 then zmc.config.SpawnMoney(money,Ordertable:LocalToWorld(Vector(0,0,50))) end
        Ordertable:SetEarnings(0)
    end
end)

// Returns either a random dish or one which is on the whitelist
function zmc.Ordertable.GetDish(Ordertable)
    if table.Count(Ordertable.DishWhitelist) > 0 then
        // Get food item from ordertable whitelist
        local _,id = table.Random(Ordertable.DishWhitelist)
        return id
    else
        // Get Random food item
        local dat = zmc.config.Dishs[math.random(#zmc.config.Dishs)]
        return dat.uniqueid
    end
end

function zmc.Ordertable.Start(Ordertable)

    // Get random table in close distance and check if he has room for a customer
    local timerid01 = "zmc_ordertable_customertimer_" .. Ordertable:EntIndex()
    zclib.Timer.Remove(timerid01)
    zclib.Timer.Create(timerid01, 1, 0, function()
        if not IsValid(Ordertable) then zclib.Timer.Remove(timerid01) return end

        // If the Ordertable does not accept NPCs then stop
        if Ordertable:GetNPCCustomer() == false then return end

        // Get all the customer tables which are close to the ordertable
        local CloseTables = {}
        for k,v in pairs(zmc.Customertables) do
            if IsValid(v) and zclib.util.InDistance(v:GetPos(), Ordertable:GetPos(), zmc.config.Order.search_dist) then
                table.insert(CloseTables,v)
            end
        end

        // Randomize the list
        CloseTables = zclib.table.randomize( CloseTables )

        // Pick a random table
        local CustomerTable = CloseTables[math.random(#CloseTables)]

        if IsValid(CustomerTable) then

            // Checks if this table has a customer which is linked to a invalid Ordertable and clears it
            zmc.Customertable.Validate(CustomerTable)

            // If a nearby washtable has no more room for dirty plates then stop
            if zmc.Ordertable.WashtableCheck(Ordertable) == false then return end


            local DishID
            // Check if there is some ReadyToGo food and take it instead of making a new order
            local rdg_slot,rdg_dishid = zmc.Ordertable.GetReadyToGoOrder(Ordertable,CustomerTable)
            if rdg_slot and rdg_dishid then // Lets add a 50% chance
                DishID = rdg_dishid
            end

            //print("[Customer] " .. tostring(CustomerTable), "[DishID] " .. tostring(DishID))

            // If custom orders are enabled then lets make one
            if Ordertable:GetCustomOrders() == true then
                // If there was no ReadyToGo then lets create a random order
                if DishID == nil then
                    DishID = zmc.Ordertable.GetDish(Ordertable)

                // There was a ReadyToGo Order but lets give it a chance to still wanting a custom one
                elseif math.random(10) > 5 then
                    DishID = zmc.Ordertable.GetDish(Ordertable)
                end
            end

            // There was no ReadyToGo Food and the customers are not allowed to make custom orders
            if DishID == nil then return end

            // Does he have a free seat?
            local FreeSeat = zmc.Customertable.FindFreeSeat(CustomerTable)
            if FreeSeat and DishID then

                zclib.Debug("Customer wants " .. zmc.Dish.GetName(DishID))

                // Was ReadyToGo Food found (rdg_slot) and is it what the Customer really wants? (DishID)
                if rdg_slot and Ordertable.zmc_inv[rdg_slot] and Ordertable.zmc_inv[rdg_slot].itm == DishID then

                    zclib.Debug("Customer found " .. zmc.Dish.GetName(DishID) .. " on the Buffet!")

                    // Spawn the customer
                    zmc.Customertable.Add(CustomerTable,FreeSeat,Ordertable,DishID)

                    // Serve food and tell him that its from a Buffet, so no service review later
                    zmc.Customertable.ServFood(CustomerTable,FreeSeat,true)

                    // Update Customer spawn interval
                    zmc.Ordertable.UpdateCustomerInterval(Ordertable)

                    // Clear food from inv
                    zmc.Inventory.EmptySlot(Ordertable, rdg_slot)

                    return
                end

                // Do we even have room for a order?
                if zmc.Ordertable.GetActiveOrders(Ordertable) >= 8 then return end

                zclib.Debug("Customer ordered " .. zmc.Dish.GetName(DishID) .. "!")

                // Spawn the customer
                zmc.Customertable.Add(CustomerTable,FreeSeat,Ordertable,DishID)

                // Add the Order
                zmc.Ordertable.AddOrder(Ordertable,DishID,CustomerTable,FreeSeat)
            end
        end
    end)

    zmc.Ordertable.UpdateCustomerInterval(Ordertable)
end

///////////////////////////////////////////////////////////////////

// Called once a NPC customer finished eating and wants to pay
util.AddNetworkString("zmc_Customertable_notify")
function zmc.Ordertable.SendReview(Ordertable,Reward,DishID,CustomerID)
    for k,v in pairs(zclib.Player.GetInSphere(Ordertable:GetPos(),400)) do
        if not IsValid(k) then continue end
        if zmc.Player.IsCook(k) ~= true then continue end

        // Create Notify panel on top right with DModel of customer giving his rating!
        net.Start("zmc_Customertable_notify")
        net.WriteUInt(CustomerID,16)
        net.WriteUInt(Reward,16)
        net.WriteString(tostring(DishID))
        net.Send(k)
    end
end

function zmc.Ordertable.OnOrderFinished(Ordertable,DishID,OrderTime,CustomerID,received_time,IsReadyToGoFood,Customertable)

    // Give the nearest valid washtable a dirty plate
    for k,v in pairs(zmc.Washtable.List) do
        if IsValid(v) and zclib.util.InDistance(v:GetPos(), Ordertable:GetPos(), zmc.config.Order.search_dist) and zmc.Washtable.GetCleanPlates(v) > 0 then
            zmc.Washtable.AddDirtyPlate(v)
            break
        end
    end


    // Pay the player
    local price = zmc.Dish.GetPrice(DishID)
    Ordertable:SetEarnings( Ordertable:GetEarnings() + price)
    zclib.Sound.EmitFromEntity("cash", Ordertable)

    hook.Run("zmc_OnDishSold",DishID,Ordertable,IsReadyToGoFood,Customertable)

    // If the food was IsReadyToGoFood aka from a Buffet then we wont increase customer happyness much or give a review
    local reward = 1
    if IsReadyToGoFood then
        reward = 1
    else
        // How much time had the player for deliver the food?
        local cooktime = zmc.Dish.GetOrderTime(DishID)

        // How long did he take to deliver the food?
        local real_time = received_time - OrderTime

        // How much reward can he get?
        reward = math.Clamp(math.Round((zmc.config.Order.rating_reward_time / cooktime) * (cooktime - real_time)),1,10)

        // Create Notify panel on top right with DModel of customer giving his rating!
        zmc.Ordertable.SendReview(Ordertable,reward,DishID,CustomerID)
    end

    // Give review depending on rating
    Ordertable:SetCustomerRating(math.Clamp(Ordertable:GetCustomerRating() + reward,0,100))
end

function zmc.Ordertable.OnOrderFailed(Ordertable,DishID,CustomerID)

    // Give review depending on rating
    Ordertable:SetCustomerRating(math.Clamp(Ordertable:GetCustomerRating() - zmc.config.Order.rating_penaltiy_time,0,100))

    if CustomerID == nil then return end
    if DishID == nil then return end

    // Create Notify panel on top right with DModel of customer giving his rating!
    zmc.Ordertable.SendReview(Ordertable,0,DishID,CustomerID)
end

// Gets called when a player received his food
function zmc.Ordertable.OnOrderSendToPlayer(Ordertable,DishID,steamid64)

    // Deliver the food to the player
    zmc.OrderMenu.Deliver(DishID, steamid64)

    // Give the nearest valid washtable a dirty plate
    for k,v in pairs(zmc.Washtable.List) do
        if IsValid(v) and zclib.util.InDistance(v:GetPos(), Ordertable:GetPos(), zmc.config.Order.search_dist) and zmc.Washtable.GetCleanPlates(v) > 0 then
            zmc.Washtable.AddDirtyPlate(v)
            break
        end
    end

    // Pay the player
    local price = zmc.Dish.GetPrice(DishID)
    Ordertable:SetEarnings( Ordertable:GetEarnings() + price)
    zclib.Sound.EmitFromEntity("cash", Ordertable)

    hook.Run("zmc_OnDishSoldToPlayer",DishID,Ordertable,steamid64)
end

///////////////////////////////////////////////////////////////////

// Switches the Ordertable between Normal and BuffetMode
// NOTE In BuffetMode the player / npcs can only buy whats on the table
util.AddNetworkString("zmc_Ordertable_CustomOrders")
net.Receive("zmc_Ordertable_CustomOrders", function(len,ply)
    zclib.Debug_Net("zmc_Ordertable_CustomOrders", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Ordertable = net.ReadEntity()
    local toggle = net.ReadBool()
    if not IsValid(Ordertable) then return end
    if Ordertable:GetClass() ~= "zmc_ordertable" then return end
    if zclib.util.InDistance(Ordertable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end
    if toggle == nil then return end

    if zmc.Player.IsCook(ply) == false then return end

	// If its not a public entity and the player dont owns it then stop
	if not Ordertable.IsPublicEntity and not zclib.Player.IsOwner(ply, Ordertable) then
		zclib.Notify(ply, zmc.language["YouDontOwnThis"], 1)
		return
	end

    if zmc.config.Order.allow_customer_orders_adminonly == true and zclib.Player.IsAdmin(ply) == false then return end

    Ordertable:SetCustomOrders(toggle)
end)

// Enables / Disables if NPC can buy the players food
util.AddNetworkString("zmc_Ordertable_NPCCustomer")
net.Receive("zmc_Ordertable_NPCCustomer", function(len,ply)
    zclib.Debug_Net("zmc_Ordertable_NPCCustomer", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Ordertable = net.ReadEntity()
    local toggle = net.ReadBool()
    if not IsValid(Ordertable) then return end
    if Ordertable:GetClass() ~= "zmc_ordertable" then return end
    if zclib.util.InDistance(Ordertable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end
    if toggle == nil then return end

    if zmc.Player.IsCook(ply) == false then return end

	// If its not a public entity and the player dont owns it then stop
	if not Ordertable.IsPublicEntity and not zclib.Player.IsOwner(ply, Ordertable) then
		zclib.Notify(ply, zmc.language["YouDontOwnThis"], 1)
		return
	end

    Ordertable:SetNPCCustomer(toggle)
end)

// Defines what kind of Food can be bought / orders here
util.AddNetworkString("zmc_Ordertable_setwhitelist")
net.Receive("zmc_Ordertable_setwhitelist", function(len,ply)
    zclib.Debug_Net("zmc_Ordertable_setwhitelist", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    local Ordertable = net.ReadEntity()
    local dataLength = net.ReadUInt(16)
    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
    local list = util.JSONToTable(dataDecompressed)

    if not IsValid(Ordertable) then return end
    if Ordertable:GetClass() ~= "zmc_ordertable" then return end
    if zclib.util.InDistance(Ordertable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

	// If its not a public entity and the player dont owns it then stop
	if not Ordertable.IsPublicEntity and not zclib.Player.IsOwner(ply, Ordertable) then
		zclib.Notify(ply, zmc.language["YouDontOwnThis"], 1)
		return
	end

    if zmc.Ordertable.CanEditWhitelist(Ordertable,ply) == false then return end

    zmc.Ordertable.SetWhitelist(Ordertable,list)
end)

function zmc.Ordertable.SetWhitelist(Ordertable,List)
    if Ordertable.DishWhitelist == nil then Ordertable.DishWhitelist = {} end

    local cleanList = {}
    if List then
        for k,v in pairs(List) do
            if zmc.Dish.GetData(k) then
                cleanList[tostring(k)] = true
            end
        end
    end

    Ordertable.DishWhitelist = table.Copy(cleanList)
end
