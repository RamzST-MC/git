--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Logbook = zgo2.Logbook or {}
zgo2.Logbook.List = zgo2.Logbook.List or {}

/*

	The logbook keeps track on how much the player paid in equipment and how much money he made by selling weed

*/

function zgo2.Logbook.Initialize(Logbook)
	zclib.EntityTracker.Add(Logbook)
	zgo2.Destruction.SetupHealth(Logbook)
end

function zgo2.Logbook.OnUse(Logbook,ply)
	// Check if the player is a weed grower
	if not zgo2.Player.IsWeedGrower(ply) then zclib.Notify(ply, zgo2.language["WrongJob"], 1) return end

	zgo2.Logbook.Open(Logbook,ply)
end

/*
	Open the interface
*/
util.AddNetworkString("zgo2.Logbook.Open")
function zgo2.Logbook.Open(Logbook,ply)

	local logdata = zgo2.Logbook.GetLog(ply)

	net.Start("zgo2.Logbook.Open")
	net.WriteUInt(table.Count(logdata),32)
	for k,v in pairs(logdata) do
		net.WriteString(v.name)
		net.WriteUInt(v.money,32)
		net.WriteBool(v.expense ~= nil)
		net.WriteUInt(v.count or 1,32)
		net.WriteString(v.class)
	end
	net.Send(ply)
end

function zgo2.Logbook.GetLog(ply)
	local steamdid64 = ply:SteamID64()
	if zgo2.Logbook.List[steamdid64] == nil then zgo2.Logbook.List[steamdid64] = {} end

	local data = table.Copy(zgo2.Logbook.List[steamdid64])

	// Check if we have some players who share their data with us and merge it to the datapack
	local SharedPlayers = zgo2.Logbook.GetShared(ply)

	for p_sid64,_ in pairs(SharedPlayers) do

		if not zgo2.Logbook.List[p_sid64] then continue end

		for itm_name,itm_data in pairs(zgo2.Logbook.List[p_sid64]) do
			if data[itm_name] then
				data[itm_name].money = (data[itm_name].money or 0) + itm_data.money

				if itm_data.expense then
					data[itm_name].count = (data[itm_name].count or 0) + 1
				else
					data[itm_name].count = (data[itm_name].count or 0) + itm_data.count
				end
			else
				data[itm_name] = itm_data
			end
		end
	end

	return data
end

function zgo2.Logbook.Add(ply,Data)
	local steamdid64 = ply:SteamID64()

	if zgo2.Logbook.List[steamdid64] == nil then zgo2.Logbook.List[steamdid64] = {} end

	// NOTE Its important to make sure that the items we log have unique names otherwhise it would be added together to other items with the same name

	if zgo2.Logbook.List[steamdid64][Data.name] then
		zgo2.Logbook.List[steamdid64][Data.name].money = (zgo2.Logbook.List[steamdid64][Data.name].money or 0) + Data.money

		if Data.expense then
			zgo2.Logbook.List[steamdid64][Data.name].count = (zgo2.Logbook.List[steamdid64][Data.name].count or 0) + 1
		else
			zgo2.Logbook.List[steamdid64][Data.name].count = (zgo2.Logbook.List[steamdid64][Data.name].count or 0) + Data.count
		end
	else
		zgo2.Logbook.List[steamdid64][Data.name] = Data
	end
end

util.AddNetworkString("zgo2.Logbook.Reset")
net.Receive("zgo2.Logbook.Reset", function(len,ply)
    zclib.Debug_Net("zgo2.Logbook.Reset", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

	local steamdid64 = ply:SteamID64()

	zgo2.Logbook.List[steamdid64] = {}

	zgo2.Logbook.Open(nil,ply)
end)


zclib.Hook.Add("zgo2.Marketplace.OnCargoSold", "zgo2.Marketplace.OnCargoSold.Logbook", function(ply,MarketplaceID,cargo_name,cargo_amount,cargo_value,cargo_data)
	zgo2.Logbook.Add(ply, {
		name = cargo_name,
		money = cargo_value,
		count = cargo_amount,

		// The type of cargo we just sold
		class = cargo_data[1]
	})
end)

zclib.Hook.Add("zgo2.NPC.OnQuickSell", "zgo2.NPC.OnQuickSell.Logbook", function(ply, weed_id, weed_amount, sellvalue)
	zgo2.Logbook.Add(ply, {
		name = zgo2.Plant.GetName(weed_id),
		money = sellvalue,
		count = weed_amount,
		class = ""
	})
end)

zclib.Hook.Add("zgo2.Shop.OnPurchase", "zgo2.Shop.OnPurchase.Logbook", function(ply, data)
	zgo2.Logbook.Add(ply, {
		name = data.name or data.class,
		money = data.price,
		expense = true,
		count = 1,
		class = data.class or ""
	})
end)

/*
	Bellow we integrate the log book for DarkRP and BaseWars
*/
zclib.Hook.Add("playerBoughtCustomEntity", "zgo2.Shop.DarkRP_SetOwnerOnEntBuy", function(ply, enttbl, ent, price)
	if zgo2.util.ClassList[ent:GetClass()] then
		zgo2.Logbook.Add(ply, {
			name = enttbl.name or enttbl.class,
			money = price,
			expense = true,
			count = 1,
			class = enttbl.class or ""
		})
		zclib.Player.SetOwner(ent, ply)
	end
end)

zclib.Hook.Add("zgo2.Marketplace.OnCargoSend", "zgo2.Marketplace.OnCargoSend.Logbook", function(ply,StartMarketplace,DestinationMarketplace,MuleID,CargoList,ShippingCost)
	zgo2.Logbook.Add(ply, {
		name = zgo2.language["Shipping Cost"],
		money = ShippingCost,
		expense = true,
		count = 1,
		class = ""
	})
end)


function zgo2.Logbook.Remove(ply,Data)
	local steamdid64 = ply:SteamID64()

	if zgo2.Logbook.List[steamdid64] == nil then zgo2.Logbook.List[steamdid64] = {} end

	// NOTE Its important to make sure that the items we log have unique names otherwhise it would be added together to other items with the same name

	if zgo2.Logbook.List[steamdid64][Data.name] then
		zgo2.Logbook.List[steamdid64][Data.name].money = (zgo2.Logbook.List[steamdid64][Data.name].money or 0) - Data.money

		if Data.expense then
			zgo2.Logbook.List[steamdid64][Data.name].count = (zgo2.Logbook.List[steamdid64][Data.name].count or 0) - 1
		else
			zgo2.Logbook.List[steamdid64][Data.name].count = (zgo2.Logbook.List[steamdid64][Data.name].count or 0) - Data.count
		end

		if zgo2.Logbook.List[steamdid64][Data.name].count <= 0 then
			zgo2.Logbook.List[steamdid64][Data.name] = nil
		end
	else
		zgo2.Logbook.List[steamdid64][Data.name] = Data
	end
end

zclib.Hook.Add("zgo2.Shop.OnSell", "zgo2.Shop.OnSell.Logbook", function(ply, data)
	zgo2.Logbook.Remove(ply, {
		name = data.name or data.class,
		money = data.price,
		expense = true,
		count = 1,
		class = data.class or ""
	})
end)

zclib.Hook.Add("zgo2.Dryline.OnRopeChange", "zgo2.Dryline.OnRopeChange.Logbook", function(Dryline,ply,cost)
	zgo2.Logbook.Remove(ply, {
		name = zgo2.language["Dryline Rope"],
		money = cost,
		expense = true,
		count = 1,
		class = ""
	})
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher