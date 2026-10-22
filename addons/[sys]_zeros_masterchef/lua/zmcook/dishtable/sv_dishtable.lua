if CLIENT then return end
zmc = zmc or {}
zmc.Dishtable = zmc.Dishtable or {}


function zmc.Dishtable.Initialize(Dishtable)
    zmc.Inventory.Setup(Dishtable,12)
    zclib.EntityTracker.Add(Dishtable)

    Dishtable:SetMaxHealth( zmc.config.Damageable[Dishtable:GetClass()] )
    Dishtable:SetHealth(Dishtable:GetMaxHealth())
end

function zmc.Dishtable.OnUse(Dishtable, ply)
    if zmc.Player.IsCook(ply) == false then return end
    zmc.Dishtable.Open(Dishtable,ply)
end

function zmc.Dishtable.OnRemove(Dishtable)
    zclib.EntityTracker.Remove(Dishtable)
end

function zmc.Dishtable.StartTouch(Dishtable,other)
    if not IsValid(Dishtable) then return end
    if not IsValid(other) then return end
    if other:GetClass() ~= "zmc_item" then return end
    if zclib.util.CollisionCooldown(other) then return end
    if Dishtable:GetDishID() <= 0 then return end

	if zclib.Entity.GettingRemoved(other) then return end

    local ItemID = other:GetItemID()
    if Dishtable:CanPickUp(ItemID) ~= true then return end

    if zmc.Inventory.Give(Dishtable, ItemID) == false then return end

    zmc.Dishtable.FinishDish(Dishtable)

    zclib.Entity.SafeRemove(other)
end

zclib.Hook.Add("zmc_Inventory_GotItemThrown", "zmc_Inventory_GotItemThrown_Dishtable", function(from,target,slot,SlotData)
    if IsValid(target) and target:GetClass() == "zmc_dishtable" then zmc.Dishtable.FinishDish(target) end
end)


util.AddNetworkString("zmc_Dishtable_open")
function zmc.Dishtable.Open(Dishtable,ply)

    local e_String = util.TableToJSON(Dishtable.DishWhitelist or {})
    local e_Compressed = util.Compress(e_String)
    net.Start("zmc_Dishtable_open")
    net.WriteEntity(Dishtable)
    net.WriteUInt(#e_Compressed,16)
    net.WriteData(e_Compressed,#e_Compressed)
    net.Send(ply)
end



util.AddNetworkString("zmc_Dishtable_selectdish")
net.Receive("zmc_Dishtable_selectdish", function(len,ply)
    zclib.Debug_Net("zmc_Dishtable_selectdish", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    local Dishtable = net.ReadEntity()
    local DishID = net.ReadUInt(16)

    if not IsValid(Dishtable) then return end

    if Dishtable:GetClass() ~= "zmc_dishtable" then return end
    if zclib.util.InDistance(Dishtable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

	// If its not a public entity and the player dont owns it then stop
	if not Dishtable.IsPublicEntity and not zclib.Player.IsOwner(ply, Dishtable) then
		zclib.Notify(ply, zmc.language["YouDontOwnThis"], 1)
		return
	end

    if DishID == nil then return end

    // Only allow whitelisted item to be selected
    if Dishtable.DishWhitelist and table.Count(Dishtable.DishWhitelist) > 0 and Dishtable.DishWhitelist[tostring(zmc.Dish.GetUniqueID(DishID))] == nil then return end

    local CanCook = hook.Run("zmc_CanCookDish",ply,DishID)
    if CanCook ~= nil and CanCook == false then return end

    Dishtable:SetDishID(DishID)

    // Any other player gets informed too
    timer.Simple(zmc.config.NetDelay,function()
        net.Start("zmc_Dishtable_selectdish")
        net.WriteEntity(Dishtable)
        net.Broadcast()
    end)
end)

util.AddNetworkString("zmc_Dishtable_canceldish")
net.Receive("zmc_Dishtable_canceldish", function(len,ply)
    zclib.Debug_Net("zmc_Dishtable_canceldish", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    if zmc.Player.IsCook(ply) == false then return end

    local Dishtable = net.ReadEntity()

    if not IsValid(Dishtable) then return end

    if Dishtable:GetClass() ~= "zmc_dishtable" then return end
    if zclib.util.InDistance(Dishtable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

	// If its not a public entity and the player dont owns it then stop
	if not Dishtable.IsPublicEntity and not zclib.Player.IsOwner(ply, Dishtable) then
		zclib.Notify(ply, zmc.language["YouDontOwnThis"], 1)
		return
	end

    Dishtable:SetDishID(-1)
    zmc.Inventory.Setup(Dishtable,12)

    // Any other player gets informed too
    timer.Simple(zmc.config.NetDelay,function()
        net.Start("zmc_Dishtable_canceldish")
        net.WriteEntity(Dishtable)
        net.Broadcast()
    end)
end)


function zmc.Dishtable.TakeIngredients(Dishtable)
    local DishData = zmc.Dish.GetData(Dishtable:GetDishID())
    for k,v in pairs(DishData.items) do
        zmc.Inventory.Take(Dishtable, tostring(v.uniqueid))
    end
end

function zmc.Dishtable.FinishDish(Dishtable)
    local DishData = zmc.Dish.GetData(Dishtable:GetDishID())
    if DishData == nil then return end

    local missing = zmc.Dishtable.GetMissingIngredients(Dishtable)
    if table.IsEmpty(missing) then

        // Remove ingredients
        zmc.Dishtable.TakeIngredients(Dishtable)

        // Spawn the food
        local dish_ent = zmc.Dish.Spawn(Dishtable:LocalToWorld(Vector(0,0,50)),tostring(DishData.uniqueid))

        hook.Run("zmc_OnDishMade",Dishtable,tostring(DishData.uniqueid),dish_ent)
    end
end




util.AddNetworkString("zmc_Dishtable_setwhitelist")
net.Receive("zmc_Dishtable_setwhitelist", function(len,ply)
    zclib.Debug_Net("zmc_Dishtable_setwhitelist", len)

    if zclib.Player.Timeout(nil,ply) == true then return end
    if zclib.Player.IsAdmin(ply) == false then return end

    local Dishtable = net.ReadEntity()
    local dataLength = net.ReadUInt(16)
    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
    local list = util.JSONToTable(dataDecompressed)

    if not IsValid(Dishtable) then return end
    if Dishtable:GetClass() ~= "zmc_dishtable" then return end
    if zclib.util.InDistance(Dishtable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

	// If its not a public entity and the player dont owns it then stop
	if not Dishtable.IsPublicEntity and not zclib.Player.IsOwner(ply, Dishtable) then
		zclib.Notify(ply, zmc.language["YouDontOwnThis"], 1)
		return
	end

    zmc.Dishtable.SetWhitelist(Dishtable,list)
end)

function zmc.Dishtable.SetWhitelist(Dishtable,List)
    if Dishtable.DishWhitelist == nil then Dishtable.DishWhitelist = {} end

    local cleanList = {}
    if List then
        for k,v in pairs(List) do
            if zmc.Dish.GetData(k) then
                cleanList[tostring(k)] = true
            end
        end
    end

    Dishtable.DishWhitelist = table.Copy(cleanList)
end
