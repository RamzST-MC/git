if CLIENT then return end
zmc = zmc or {}
zmc.Customertable = zmc.Customertable or {}

zmc.Customertables = zmc.Customertables or {}

function zmc.Customertable.Initialize(Customertable)
    zclib.EntityTracker.Add(Customertable)

    timer.Simple(0.1,function()
        if not IsValid(Customertable) then return end
        zmc.Customertable.Update(Customertable,Customertable:GetTableID(),Customertable:GetSeatID())
    end)

    table.insert(zmc.Customertables,Customertable)

    Customertable:SetMaxHealth( zmc.config.Damageable[Customertable:GetClass()] )
    Customertable:SetHealth(Customertable:GetMaxHealth())
end

function zmc.Customertable.OnUse(Customertable, ply)
    // If this table is a public entity then only admins can edit it
    if Customertable.IsPublicEntity == true and zclib.Player.IsAdmin(ply) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

    zmc.Customertable.Open(Customertable, ply)
end

util.AddNetworkString("zmc_Customertable_Open")
function zmc.Customertable.Open(Customertable, ply)
    // Since the Customertable only has the appearance editor anymore we only allow to open the interface if its allowed in the config
    if zmc.config.CustomerTable.edit_appearance_adminonly == true and zclib.Player.IsAdmin(ply) == false then return end

    net.Start("zmc_Customertable_Open")
    net.WriteEntity(Customertable)
    net.Send(ply)
end

function zmc.Customertable.OnRemove(Customertable)
    zclib.EntityTracker.Remove(Customertable)
    table.RemoveByValue(zmc.Customertables,Customertable)
end

function zmc.Customertable.StartTouch(Customertable,other)

end

// Checks if the customers Ordertable still exists, otherwhise despawn the customer
function zmc.Customertable.Validate(Customertable)
    if Customertable.CustomerData == nil then return end
    for k,v in pairs(Customertable.CustomerData) do
        if not IsValid(v.o_tbl) and v.customer_id and v.dish_id then
            zmc.Customertable.Clear(Customertable,k)
        end
    end
end

function zmc.Customertable.FindFreeSeat(Customertable)
    local key
    for k,v in pairs(Customertable.CustomerData) do
        if v.customer_id == nil then
            key = k
            break
        end
    end
    return key
end

// Adds a customer to the table
function zmc.Customertable.Add(Customertable,SeatID,Ordertable,DishID)
    local c_id = math.random(#zmc.config.Customers)
    Customertable.CustomerData[SeatID] = {
        o_tbl = Ordertable,
        customer_id = c_id,
        dish_id = DishID,
        order_time = CurTime(),
        received_food = false
    }

    zmc.Customertable.Synch(Customertable)
end

// Serv Food
function zmc.Customertable.ServFood(Customertable,SeatID,IsReadyToGoFood)
    if not IsValid(Customertable) then return end
    local cData = Customertable.CustomerData[SeatID]
    if cData and cData.customer_id and cData.received_food == false then

        cData.received_food = true
        cData.received_time = CurTime()
        zmc.Customertable.Synch(Customertable)

        local timerid = "zmc_customertable_" .. Customertable:EntIndex() .. "_eatfood_" .. SeatID
        zclib.Timer.Remove(timerid)
        zclib.Timer.Create(timerid, math.random(30,50), 1, function()
            if not IsValid(Customertable) then zclib.Timer.Remove(timerid) return end

            // Lets pay the ordertable
            if cData and IsValid(cData.o_tbl) and cData.dish_id and cData.customer_id then
                zmc.Ordertable.OnOrderFinished(cData.o_tbl,cData.dish_id,cData.order_time,cData.customer_id,cData.received_time,IsReadyToGoFood,Customertable)
            end
            zmc.Customertable.Clear(Customertable,SeatID)
            zmc.Customertable.Synch(Customertable)
            zclib.Timer.Remove(timerid)
        end)
    end
end

function zmc.Customertable.Clear(Customertable,SeatID)
    Customertable.CustomerData[SeatID] = {}
    zmc.Customertable.Synch(Customertable)
end

concommand.Add("zmc_debug_customertable", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        local tr = ply:GetEyeTrace()
        if tr and tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zmc_customertable" then
            local c_id = math.random(#zmc.config.Customers)
            local DishID = math.random(#zmc.config.Dishs)
            local FreeSeat = zmc.Customertable.FindFreeSeat(tr.Entity)
            if FreeSeat then
                tr.Entity.CustomerData[FreeSeat] = {
                    customer_id = c_id,
                    dish_id = DishID,
                    order_time = CurTime(),
                    received_food = true
                }

                zmc.Customertable.Synch(tr.Entity)
            end
        end
    end
end)


util.AddNetworkString("zmc_Customertable_Update")
net.Receive("zmc_Customertable_Update", function(len,ply)
    zclib.Debug_Net("zmc_Customertable_Update", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    if zmc.config.CustomerTable.edit_appearance_adminonly == true and zclib.Player.IsAdmin(ply) == false then return end

    local Customertable = net.ReadEntity()
    local SelectedTable = net.ReadUInt(16)
    local SelectedSeat = net.ReadInt(16)

    if Customertable.IsPublicEntity and zclib.Player.IsAdmin(ply) == false then return end

    if not IsValid(Customertable) then return end
    if Customertable:GetClass() ~= "zmc_customertable" then return end
    if zclib.util.InDistance(Customertable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

	// If its not a public entity and the player dont owns it then stop
	if not Customertable.IsPublicEntity and not zclib.Player.IsOwner(ply, Customertable) then
		zclib.Notify(ply, zmc.language["YouDontOwnThis"], 1)
		return
	end

    zmc.Customertable.Update(Customertable,SelectedTable,SelectedSeat)
end)

function zmc.Customertable.Update(Customertable,SelectedTable,SelectedSeat)

    Customertable:SetTableID(SelectedTable)
    Customertable:SetSeatID(SelectedSeat)

    local TableData = zmc.Table.GetData(SelectedTable)

    if Customertable.CustomerData == nil then Customertable.CustomerData = {} end

    // Clear customers
    for k,v in pairs(Customertable.CustomerData) do zmc.Customertable.Clear(Customertable,k) end

    // Rebuild Seats
    Customertable.CustomerData = {}
    for i = 1,table.Count(TableData.positions) do
        Customertable.CustomerData[i] = {}
    end

    Customertable:SetModel(TableData.mdl)
    Customertable:PhysicsInit(SOLID_VPHYSICS)
    Customertable:SetSolid(SOLID_VPHYSICS)
    Customertable:SetMoveType(MOVETYPE_VPHYSICS)
    Customertable:SetUseType(SIMPLE_USE)
    Customertable:DrawShadow(false)
    Customertable:Activate()

    local phys = Customertable:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
    end

    timer.Simple(0.1,function()
        if not IsValid(Customertable) then return end

        zmc.Customertable.Synch(Customertable)
    end)
end
