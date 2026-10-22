if CLIENT then return end
zmc = zmc or {}
zmc.OrderMenu = zmc.OrderMenu or {}

// Keeps track on what player order what food
zmc.OrderMenu.PlayerOrders = zmc.OrderMenu.PlayerOrders or {}

// Adds a DishID to the OrderTracker
function zmc.OrderMenu.AddOrder(DishID, steamid64)
    if zmc.OrderMenu.PlayerOrders[steamid64] == nil then zmc.OrderMenu.PlayerOrders[steamid64] = {} end
    table.insert(zmc.OrderMenu.PlayerOrders[steamid64],DishID)
end

// Removes a DishID to the OrderTracker
function zmc.OrderMenu.RemoveOrder(DishID, steamid64)
    if zmc.OrderMenu.PlayerOrders[steamid64] == nil then zmc.OrderMenu.PlayerOrders[steamid64] = {} end
    table.RemoveByValue(zmc.OrderMenu.PlayerOrders[steamid64],DishID)
end

// Returns how many orders the player currently has
function zmc.OrderMenu.GetTotalOrderCount(steamid64)
    if zmc.OrderMenu.PlayerOrders[steamid64] == nil then zmc.OrderMenu.PlayerOrders[steamid64] = {} end
    return table.Count(zmc.OrderMenu.PlayerOrders[steamid64])
end

// Returns how many orders of the specified DishID the player currently has
function zmc.OrderMenu.GetOrderCount(DishID, steamid64)
    if zmc.OrderMenu.PlayerOrders[steamid64] == nil then zmc.OrderMenu.PlayerOrders[steamid64] = {} end
    local count = 0
    for k,v in pairs(zmc.OrderMenu.PlayerOrders[steamid64]) do
        if v == DishID then
            count = count + 1
        end
    end
    return count
end

/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

util.AddNetworkString("zmc_OrderMenu_OrderDish")
net.Receive("zmc_OrderMenu_OrderDish", function(len, ply)
    zclib.Debug_Net("zmc_OrderMenu_OrderDish", len)
    if zclib.Player.Timeout(nil, ply) == true then return end
    local Ordertable = net.ReadEntity()
    local DishID = net.ReadUInt(32)
    if not IsValid(Ordertable) then return end
    if Ordertable:GetClass() ~= "zmc_ordertable" then return end
    if zclib.util.InDistance(Ordertable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    zmc.OrderMenu.Order(Ordertable, ply, zmc.Dish.GetUniqueID(DishID))
end)

function zmc.OrderMenu.Order(Ordertable, ply, DishID)

    if Ordertable:GetAcceptOrders() == false then
        zclib.Notify(ply, zmc.language["OrdertableClosed"], 1)
        return
    end

    local steamid64 = ply:SteamID64()

    // Check how many food items the player has ordered
    if zmc.OrderMenu.GetTotalOrderCount(steamid64) >= zmc.config.Order.player_order_limit then
        zclib.Notify(ply, zmc.language["Orderlimit"], 1)
        return
    end

    // Check if the player has enough money to order the food
    local price = zmc.Dish.GetPrice(DishID)
    if zclib.Money.Has(ply, price) == false then
        zclib.Notify(ply, zmc.language["NotEnoughMoney"], 1)
        return
    end

    // If a nearby washtable has no more room for dirty plates then stop
    if zmc.Ordertable.WashtableCheck(Ordertable) == false then
        zclib.Notify(ply, zmc.language["NoCleanPlates"], 1)
        return
    end

    // Lets search for a ReadyToGo food before making a new order
    local FoundAtSlot = zmc.Ordertable.FindReadyToGoOrder(Ordertable,DishID)
    if FoundAtSlot then

        // Send him the food
        zmc.Ordertable.OnOrderSendToPlayer(Ordertable,DishID,steamid64)

        // Pay for the dish
        zclib.Money.Take(ply, price)

        local str = string.Replace(zmc.language["DishBought"],"$DishName",zmc.Dish.GetName(DishID))
        str = string.Replace(str,"$Money",zclib.Money.Display(price))
        zclib.Notify(ply, str, 0)

        zclib.Sound.EmitFromPosition(ply:GetPos(),"cash")


        // Clear food from inv
        zmc.Inventory.EmptySlot(Ordertable, FoundAtSlot)
        return
    end

    // If we dont allow the player to make new orders and the thing he wanted was not available then stop
    if Ordertable:GetCustomOrders() == false and FoundAtSlot == nil then
        zclib.Notify(ply, string.Replace(zmc.language["DishNotAvailable"],"$DishName",zmc.Dish.GetName(DishID)), 1)
        return
    end

    // Make a direct player order
    if zmc.Ordertable.AddPlayerOrder(Ordertable,DishID,steamid64) then

        zclib.Money.Take(ply, price)

        local str = string.Replace(zmc.language["OrderAccepted"],"$DishName",zmc.Dish.GetName(DishID))
        str = string.Replace(str,"$Money",zclib.Money.Display(price))
        zclib.Notify(ply, str, 0)

        zclib.Sound.EmitFromPosition(ply:GetPos(),"cash")

        zmc.OrderMenu.AddOrder(DishID, steamid64)
    else
        zclib.Notify(ply, zmc.language["OrdertableFull"], 1)
    end
end

function zmc.OrderMenu.Deliver(DishID, steamid64)

    zmc.OrderMenu.RemoveOrder(DishID, steamid64)

    local ply = player.GetBySteamID64(steamid64)
    if IsValid(ply) then
        local dishName = zmc.Dish.GetName(DishID)

        local dishEnt =  zmc.Dish.Spawn(ply:GetPos() + zclib.util.GetRandomPositionInsideCircle(50,100,15),DishID)

        // Either spawn the food by the player or put it in his inventory
        if zclib.Inventory.Pickup(ply, dishEnt, "zmc_dish") then
            zclib.Notify(ply, string.Replace(zmc.language["OrderCompleted02"],"$DishName",dishName), 0)
        end

        zclib.Notify(ply,string.Replace(zmc.language["OrderCompleted01"],"$DishName",dishName), 0)
    end
end

function zmc.OrderMenu.OrderFailed(DishID, steamid64)

    zmc.OrderMenu.RemoveOrder(DishID, steamid64)

    local ply = player.GetBySteamID64(steamid64)
    if IsValid(ply) then

        // Give him back the money
        local price = zmc.Dish.GetPrice(DishID)
        zclib.Notify(ply, string.Replace(zmc.language["OrderFailed03"],"$Money",zclib.Money.Display(price)), 0)
        zclib.Sound.EmitFromPosition(ply:GetPos(),"cash")
        zclib.Money.Give(ply, price)

        zclib.Notify(ply,zmc.language["OrderFailed02"], 1)
        zclib.Notify(ply,string.Replace(zmc.language["OrderFailed01"],"$DishName",zmc.Dish.GetName(DishID)), 1)
    end
end
