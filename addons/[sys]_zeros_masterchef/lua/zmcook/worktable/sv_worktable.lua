if CLIENT then return end
zmc = zmc or {}
zmc.Worktable = zmc.Worktable or {}


function zmc.Worktable.Initialize(Worktable)
    zmc.Inventory.Setup(Worktable,28)
    zclib.EntityTracker.Add(Worktable)

    Worktable:SetMaxHealth( zmc.config.Damageable[Worktable:GetClass()] )
    Worktable:SetHealth(Worktable:GetMaxHealth())
end

function zmc.Worktable.OnUse(Worktable, ply)

    if zmc.Player.IsCook(ply) == false then return end

    local ItemID = Worktable:GetItemID()
    local itemData = zmc.Item.GetData(ItemID)
    if itemData then

        if Worktable:GetProgress() <= 0 then
            zmc.Worktable.FinishedTask(Worktable,ply)
            return
        end
        Worktable:SetProgress(Worktable:GetProgress() - 1)

        // Send custom net message to animate the client model we are currently working on
        zclib.NetEvent.Create("worktable_interact", {Worktable})
    else
        zmc.Worktable.Open(Worktable,ply)
    end
end

function zmc.Worktable.OnRemove(Worktable)
    zclib.EntityTracker.Remove(Worktable)
end

function zmc.Worktable.StartTouch(Worktable,other)
    if not IsValid(Worktable) then return end
    if not IsValid(other) then return end
    if other:GetClass() ~= "zmc_item" then return end
    if zclib.util.CollisionCooldown(other) then return end

	if zclib.Entity.GettingRemoved(other) then return end

    local ItemID = other:GetItemID()
    local ItemData = zmc.Item.GetData(ItemID)
    if ItemData == nil then return end

    if other:GetIsRotten() == true then return end

    //if ItemData.cut == nil and ItemData.knead == nil then return end

    if zmc.Inventory.Give(Worktable, ItemID) == false then return end

    zclib.Entity.SafeRemove(other)
end

util.AddNetworkString("zmc_Worktable_open")
function zmc.Worktable.Open(Worktable, ply)
    net.Start("zmc_Worktable_open")
    net.WriteEntity(Worktable)
    net.Send(ply)
end

util.AddNetworkString("zmc_Worktable_start")
net.Receive("zmc_Worktable_start", function(len,ply)
    zclib.Debug_Net("zmc_Worktable_start", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    local Worktable = net.ReadEntity()
    local SlotID = net.ReadUInt(16)
    local TaskID = net.ReadUInt(2)
    if not IsValid(Worktable) then return end
    if Worktable:GetClass() ~= "zmc_worktable" then return end
    if zclib.util.InDistance(Worktable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

    local SlotData = zmc.Inventory.GetSlotData(Worktable,SlotID)
    local ItemID = SlotData.itm
    if ItemID == nil then return end

    local itemData = zmc.Item.GetData(ItemID)
    if itemData == nil then return end

    // Can it even be cut or knead?
    if itemData.cut == nil and itemData.knead == nil then return end

    local count = 0
    if TaskID == 1 and itemData.cut then
        count = itemData.cut.cycle
        Worktable:SetTaskType(1)
    elseif TaskID == 2 and itemData.knead then
        count = itemData.knead.cycle
        Worktable:SetTaskType(2)
    end

    if count <= 0 then return end

    // Does this slot even have anything?
    if zmc.Inventory.EmptySlot(Worktable, SlotID) == false then return end

    // Set the item we are currently processing
    Worktable:SetItemID(zmc.Item.GetListID(ItemID))
    Worktable:SetProgress(count)

    zmc.vgui.ForceCloseAll(Worktable)
end)

util.AddNetworkString("zmc_Worktable_craft")
net.Receive("zmc_Worktable_craft", function(len,ply)
    zclib.Debug_Net("zmc_Worktable_craft", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    local Worktable = net.ReadEntity()
    local ItemID = net.ReadUInt(16)
    if not IsValid(Worktable) then return end
    if Worktable:GetClass() ~= "zmc_worktable" then return end
    if zclib.util.InDistance(Worktable:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

    local itemData = zmc.Item.GetData(ItemID)
    if itemData == nil then return end

    if table.IsEmpty(zmc.Inventory.GetMissing(Worktable,itemData.craft.items)) == false then return end

    zmc.Inventory.TakeItems(Worktable, itemData.craft.items)

    Worktable:SetTaskType(3)
    Worktable:SetItemID(ItemID)
    Worktable:SetProgress(table.Count(itemData.craft.items))

    zmc.vgui.ForceCloseAll(Worktable)
end)

function zmc.Worktable.FinishedTask(Worktable, ply)
    local ItemID = Worktable:GetItemID()
    local ItemData = zmc.Item.GetData(ItemID)
    if ItemData == nil then return end

    local function SpawnItem(itm,i)
        if zmc.Inventory.Give(Worktable, itm) == false then
            // We could not find a free slot so lets just drop the item to the floor
            local item_ent = zmc.Item.Spawn(Worktable:LocalToWorld(Vector(0,0,15 + (5 * i))),itm)
            if not IsValid(item_ent) then return end
            zclib.Player.SetOwner(item_ent, ply)
        end

        local ReceivedItemData = zmc.Item.GetData(itm)
        if ReceivedItemData == nil then return end
        zclib.Notify(ply, "+ " .. ReceivedItemData.name, 0)
    end
    local tasktype = Worktable:GetTaskType()
    if tasktype == 3 then
        for i = 1,ItemData.craft.amount do SpawnItem(ItemData.uniqueid,i) end
    else
        if tasktype == 1 and ItemData.cut then
            for k,v in pairs(ItemData.cut.items) do if v then SpawnItem(v,k) end end
        elseif tasktype == 2 and ItemData.knead then
            for i = 1,ItemData.knead.amount do SpawnItem(ItemData.knead.item,i) end
        end
    end

    // Back to the interface because its better for the usalbility
    zmc.Worktable.Open(Worktable,ply)

    Worktable:SetItemID(-1)
    Worktable:SetProgress(-1)
end
