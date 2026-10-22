if CLIENT then return end
zmc = zmc or {}
zmc.Fridge = zmc.Fridge or {}


function zmc.Fridge.Initialize(Fridge)
    zclib.EntityTracker.Add(Fridge)

    Fridge:SetMaxHealth( zmc.config.Damageable[Fridge:GetClass()] )
    Fridge:SetHealth(Fridge:GetMaxHealth())
end

function zmc.Fridge.OnUse(Fridge, ply)
    if zmc.Player.IsCook(ply) == false then return end
    zmc.Fridge.Open(Fridge,ply)
end

function zmc.Fridge.OnRemove(Fridge)
    zclib.EntityTracker.Remove(Fridge)
end

util.AddNetworkString("zmc_fridge_open")
function zmc.Fridge.Open(Fridge,ply)
    local e_String = util.TableToJSON(Fridge.BuyWhitelist or {})
    local e_Compressed = util.Compress(e_String)
    net.Start("zmc_fridge_open")
    net.WriteEntity(Fridge)
    net.WriteUInt(#e_Compressed,16)
    net.WriteData(e_Compressed,#e_Compressed)
    net.Send(ply)
end

util.AddNetworkString("zmc_fridge_buy")
net.Receive("zmc_fridge_buy", function(len,ply)
    zclib.Debug_Net("zmc_fridge_buy", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    local fridge = net.ReadEntity()
    local SelectedItem = net.ReadUInt(16)
    if not IsValid(fridge) then return end
    if fridge:GetClass() ~= "zmc_fridge" then return end
    if zclib.util.InDistance(fridge:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

    if zmc.Item.LimitCheck(ply) == false then
        zclib.Notify(ply, zmc.language["item_limit_reached"], 1)

        return
    end

    local itemData = zmc.Item.GetData(SelectedItem)

    if itemData == nil then return end
    if itemData.fridge == nil then return end

    // If the Fridge has a buy whitelist and the item is not in the list then stop
    if fridge.BuyWhitelist and table.Count(fridge.BuyWhitelist) > 0 and fridge.BuyWhitelist[itemData.uniqueid] == nil then return end

	if not zmc.config.FridgeItemsForFree then
	    if zclib.Money.Has(ply, itemData.fridge.price) == false then return end

	    zclib.Money.Take(ply, itemData.fridge.price)

	    local notify = zmc.language["ItemBoughtNotify"]
	    notify = string.Replace(notify,"$ItemName",itemData.name)
	    notify = string.Replace(notify,"$CurrencyAmount",zclib.Money.Display(itemData.fridge.price))
	    zclib.Notify(ply, notify, 0)
	end

    local ent = zmc.Item.Spawn(fridge:LocalToWorld(Vector(-50,0,50)),itemData.uniqueid)
    if not IsValid(ent) then return end
    zclib.Player.SetOwner(ent, ply)

    zclib.Sound.EmitFromEntity("cash", fridge)
end)

util.AddNetworkString("zmc_fridge_setwhitelist")
net.Receive("zmc_fridge_setwhitelist", function(len,ply)
    zclib.Debug_Net("zmc_fridge_setwhitelist", len)

    if zclib.Player.Timeout(nil,ply) == true then return end
    if zclib.Player.IsAdmin(ply) == false then return end

    local fridge = net.ReadEntity()
    local dataLength = net.ReadUInt(16)
    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
    local list = util.JSONToTable(dataDecompressed)

    if not IsValid(fridge) then return end
    if fridge:GetClass() ~= "zmc_fridge" then return end
    if zclib.util.InDistance(fridge:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    zmc.Fridge.SetWhitelist(fridge,list)
end)

function zmc.Fridge.SetWhitelist(Fridge,List)
    if Fridge.BuyWhitelist == nil then Fridge.BuyWhitelist = {} end

    local cleanList = {}
    for k,v in pairs(List) do
        if zmc.Item.GetData(k) then
            cleanList[tostring(k)] = true
        end
    end

    Fridge.BuyWhitelist = table.Copy(cleanList)
end
