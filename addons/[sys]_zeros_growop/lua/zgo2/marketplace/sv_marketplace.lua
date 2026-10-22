--leak by matveicher
local function SafeGetBySteamID(steamid)
	for _, ply in ipairs(player.GetAll()) do
		if ply:SteamID() == steamid then return ply end
	end
	return nil
end

--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Marketplace = zgo2.Marketplace or {}

/*

	The Marketplace manages which players has what weed in which Marketplace in the world
	Players can sell large amounts of weed from here

*/

///////////////////////////////////////////////////////////////////

/*
	Updates the buy rates for each Marketplace delayed according to timezone
*/
util.AddNetworkString("zgo2.Marketplace.UpdateRate")
local LastUpdate = CurTime()
function zgo2.Marketplace.UpdateRate()

	LastUpdate = CurTime()

	// We send this mostly for the LastUpdate value, the actual rates will be updates later
	net.Start("zgo2.Marketplace.UpdateRate")
	net.WriteUInt(1,10)
	net.WriteUInt(zgo2.Marketplace.List[1].buy_rate or 100,10)
	net.WriteUInt(LastUpdate,32)
	net.Broadcast()

	// Update buy_rate for all marketplaces
	for k,v in pairs(zgo2.Marketplace.List) do
		timer.Simple((zgo2.config.Marketplace.Sell.Interval / 1500) * v.pos.x,function()
			v.buy_rate = math.random(zgo2.config.Marketplace.Sell.Min,zgo2.config.Marketplace.Sell.Max)

			// Inform the clients
			net.Start("zgo2.Marketplace.UpdateRate")
			net.WriteUInt(k,10)
			net.WriteUInt(v.buy_rate or 100,10)
			net.WriteUInt(LastUpdate,32)
			net.Broadcast()
		end)
	end
end
for k,v in pairs(zgo2.Marketplace.List) do v.buy_rate = math.random(zgo2.config.Marketplace.Sell.Min,zgo2.config.Marketplace.Sell.Max) end

/*
	Updates the specified player which Marketplace got which buyrate
*/
function zgo2.Marketplace.UpdatePlayer(ply)
	for k, v in pairs(zgo2.Marketplace.List) do
		net.Start("zgo2.Marketplace.UpdateRate")
		net.WriteUInt(k, 10)
		net.WriteUInt(v.buy_rate or 100, 10)
		net.WriteUInt(LastUpdate, 32)
		net.Send(ply)
	end
end

/*
	Updates the buy rate for all the marketplaces at once
*/
zclib.Timer.Remove("zgo2.Marketplace.UpdateRate")
zclib.Timer.Create("zgo2.Marketplace.UpdateRate", zgo2.config.Marketplace.Sell.Interval, 0, function()

	// Send net message to all player telling them the current buy value for the marketplaces
	zgo2.Marketplace.UpdateRate()
end)
zgo2.Marketplace.UpdateRate()

///////////////////////////////////////////////////////////////////

// This keeps track which player transfers what type of cargo to which market place
zgo2.Marketplace.Transfers = {
	/*
		[SteamID64] = {
			[TransferID] = {StartID = NUMBER,DestinationID = NUMBER, CargoList = TABLE}
		}
	*/
}

/*
	Adds a list of weed to the specified marketplace for the specified player
*/
function zgo2.Marketplace.AddCargo(MarketplaceID,CargoList,ply)
	local steamid = ply:SteamID64()
	if zgo2.Marketplace.List[MarketplaceID].Cargo == nil then zgo2.Marketplace.List[MarketplaceID].Cargo = {} end

	if zgo2.Marketplace.List[MarketplaceID].Cargo[steamid] == nil then zgo2.Marketplace.List[MarketplaceID].Cargo[steamid] = {} end

	// Add the cargo list to the existing cargo list in the marketplace if there even is one
	for cargo_id,cargo_data in pairs(CargoList) do

		// Can the entity even be sold?
		local CargoConfig = zgo2.Cargo.Get(cargo_data[1])
		if not CargoConfig then continue end

		// Go through all the cargo items which are currently on the market and see if we can merge it with one of them if their data matches
		local CouldMerge = false
		for k,v in pairs(zgo2.Marketplace.List[MarketplaceID].Cargo[steamid]) do
			if CargoConfig.CanMerge(cargo_data,v) then
				zgo2.Marketplace.List[MarketplaceID].Cargo[steamid][k] = CargoConfig.Merge(cargo_data,v)
				CouldMerge = true
				break
			end
		end

		// Stop if we could successfully find and merge the data
		if CouldMerge then continue end

		// Create new cargo item
		table.insert(zgo2.Marketplace.List[MarketplaceID].Cargo[steamid],cargo_data)
	end

	zgo2.Marketplace.UpdateCargo(ply,MarketplaceID)
end

/*
	Sets the cargo list to the specified marketplace for the specified player
*/
function zgo2.Marketplace.SetCargo(MarketplaceID,CargoList,ply)
	local steamid = ply:SteamID64()
	if zgo2.Marketplace.List[MarketplaceID].Cargo == nil then zgo2.Marketplace.List[MarketplaceID].Cargo = {} end

	if zgo2.Marketplace.List[MarketplaceID].Cargo[steamid] == nil then zgo2.Marketplace.List[MarketplaceID].Cargo[steamid] = {} end

	zgo2.Marketplace.List[MarketplaceID].Cargo[steamid] = CargoList

	zgo2.Marketplace.UpdateCargo(ply,MarketplaceID)
end

/*
	Updates the specified player which cargo he has in what marketplace
*/
util.AddNetworkString("zgo2.Marketplace.UpdateCargo")
function zgo2.Marketplace.UpdateCargo(ply,MarketplaceID)
	local steamid = ply:SteamID64()
	if zgo2.Marketplace.List[MarketplaceID].Cargo == nil then zgo2.Marketplace.List[MarketplaceID].Cargo = {} end
	if zgo2.Marketplace.List[MarketplaceID].Cargo[steamid] == nil then zgo2.Marketplace.List[MarketplaceID].Cargo[steamid] = {} end

	local e_String = util.TableToJSON(zgo2.Marketplace.List[MarketplaceID].Cargo[steamid])
	local e_Compressed = util.Compress(e_String)
	net.Start("zgo2.Marketplace.UpdateCargo")
	net.WriteUInt(MarketplaceID,10)
	net.WriteUInt(#e_Compressed,16)
    net.WriteData(e_Compressed,#e_Compressed)
	net.Send(ply)
end

/*
	Sells the specified cargo from a marketplace
*/
util.AddNetworkString("zgo2.Marketplace.SellCargo")
net.Receive("zgo2.Marketplace.SellCargo", function(len,ply)
    zclib.Debug_Net("zgo2.Marketplace.SellCargo", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

	local MarketplaceID = net.ReadUInt(10)

	local SelectedList = {}
    local count = net.ReadUInt(10)
	for i = 1, count do
		SelectedList[ net.ReadUInt(10) ] = net.ReadUInt(32)
	end
	if not SelectedList then return end

	// Do we even allow the direct sell of cargo?
	if not zgo2.config.Marketplace.Sell.Enabled then return end

	zgo2.Marketplace.SellCargo(ply,MarketplaceID,SelectedList)
end)
function zgo2.Marketplace.SellCargo(ply,MarketplaceID,SelectedList)
	local steamid = ply:SteamID64()

	local MarketData = zgo2.Marketplace.List[MarketplaceID]
	if not MarketData then return end

	local StoredCargo = MarketData.Cargo[steamid]
	if not StoredCargo then return end

	// Verify that this player has the cargo in the provided marketplace id
	for cargo_id,cargo_data in pairs(StoredCargo) do

		// If the id is not on the requested sell list then stop
		if not SelectedList[cargo_id] then continue end

		local CargoConfig = zgo2.Cargo.Get(cargo_data[1])
		if not CargoConfig then continue end

		local cargo_name = CargoConfig.GetFullName(cargo_data)
		local cargo_amount = math.Clamp(SelectedList[cargo_id],0,CargoConfig.GetAmount(cargo_data))
		local cargo_sellvalue = CargoConfig.GetSellValue(cargo_data)

		local BuyRate = (1 / 100) * (MarketData.buy_rate or 100)

		local cargo_value = (cargo_sellvalue * cargo_amount) * BuyRate

		// Give him the cash
		zclib.Money.Give(ply,cargo_value)
		zclib.PanelNotify.Create(ply, "+" .. zclib.Money.Display(cargo_value), 0)

		hook.Run("zgo2.Marketplace.OnCargoSold",ply,MarketplaceID,cargo_name,cargo_amount,cargo_value,cargo_data)
	end

	// Only remove the amount which we are moving not everything
	for cargo_id,move_amount in pairs(SelectedList) do
		local StoredCargoData = StoredCargo[cargo_id]
		if not StoredCargoData then continue end

		local CargoConfig = zgo2.Cargo.Get(StoredCargoData[1])
		if not CargoConfig then continue end
		CargoConfig.SetAmount(StoredCargoData,CargoConfig.GetAmount(StoredCargoData) - move_amount)

		if CargoConfig.GetAmount(StoredCargoData) <= 0 then
			StoredCargo[cargo_id] = nil
		end
	end

	// Update the player about what cargo he has
	zgo2.Marketplace.UpdateCargo(ply,MarketplaceID)
end

/*
	Sends the specified cargo list to the specified marketplace
*/
util.AddNetworkString("zgo2.Marketplace.SendCargo")
net.Receive("zgo2.Marketplace.SendCargo", function(len,ply)
    zclib.Debug_Net("zgo2.Marketplace.SendCargo", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

	local StartMarketplace = net.ReadUInt(10)
	local DestinationMarketplace = net.ReadUInt(10)

	local SendList = {}
    local count = net.ReadUInt(10)
	for i = 1, count do SendList[ net.ReadUInt(10) ] = net.ReadUInt(32) end
	if not SendList then return end

	local MuleID = net.ReadUInt(32)

	// If mules are disabled then we always use the Generic Mule, no matter what the client says
	if zgo2.config.Marketplace.DisableMules then MuleID = 6666 end

	zgo2.Marketplace.SendCargo(ply,StartMarketplace,DestinationMarketplace,SendList,MuleID)
end)
function zgo2.Marketplace.SendCargo(ply,StartMarketplace,DestinationMarketplace,SendList,MuleID)
	local steamid = ply:SteamID64()

	if not zgo2.Marketplace.List[StartMarketplace] then return end
	if not zgo2.Marketplace.List[DestinationMarketplace] then return end

	if zgo2.Marketplace.Transfers[steamid] == nil then zgo2.Marketplace.Transfers[steamid] = {} end

	// We only allow 3 active transfer per player per marketplace
	if table.Count(zgo2.Marketplace.Transfers[steamid]) >= zgo2.Marketplace.GetTransferLimit(ply) then
		zclib.PanelNotify.Create(ply, zgo2.language[ "transfer_limit" ], 1)
		return
	end

	if not zgo2.Mule.CanUse(MuleID,ply) then return end

	local CargoList = {}

	// Verify the Start Marketplace has the cargo
	local StoredCargo = zgo2.Marketplace.List[StartMarketplace].Cargo[steamid]
	if not StoredCargo then return end

	// Add the cargo to the send list
	for cargo_id,cargo_amount in pairs(SendList) do

		local StoredCargoData = StoredCargo[cargo_id]
		if not StoredCargoData then continue end

		// This gets the cargo config using the cargo class from the stored cargo
		local CargoConfig = zgo2.Cargo.Get(StoredCargoData[1])
		if not CargoConfig then continue end

		// Make a copy of the stored cargo data and change its amount to what we wanna send
		local MoveData = table.Copy(StoredCargoData)
		local MoveAmount = math.Clamp(cargo_amount,0,CargoConfig.GetAmount(StoredCargoData))
		CargoConfig.SetAmount(MoveData,MoveAmount)
		CargoList[cargo_id] = MoveData//math.Clamp(cargo_amount,0,CargoConfig.GetAmount(StoredCargoData))
	end

	// The player need to pay the transport costs now
	local ShippingCost = zgo2.Marketplace.GetShippingCost(StoredCargo,CargoList)
	ShippingCost = ShippingCost * zgo2.Mule.GetCost(MuleID)

	// Check if the player has money
	if ShippingCost > 0 and not zclib.Money.Has(ply, ShippingCost) then return end

	// Remove the money from his wallet
	if ShippingCost > 0 then
		zclib.Money.Take(ply,ShippingCost)
		timer.Simple(0,function()
			if not IsValid(ply) then return end
			zclib.PanelNotify.Create(ply, zgo2.language[ "Shipping Cost" ] .. ": -" .. zclib.Money.Display(ShippingCost), 0)
		end)
	end

	hook.Run("zgo2.Marketplace.OnCargoSend",ply,StartMarketplace,DestinationMarketplace,MuleID,CargoList,ShippingCost)

	// Only remove the amount which we are moving not everything
	for cargo_id,move_amount in pairs(SendList) do
		local StoredCargoData = StoredCargo[cargo_id]
		if not StoredCargoData then continue end

		local CargoConfig = zgo2.Cargo.Get(StoredCargoData[1])
		if not CargoConfig then continue end
		CargoConfig.SetAmount(StoredCargoData,CargoConfig.GetAmount(StoredCargoData) - move_amount)

		if CargoConfig.GetAmount(StoredCargoData) <= 0 then
			StoredCargo[cargo_id] = nil
		end
	end

	// Update the player that he doesent have the send cargo in his marketplace cargo storage anymore
	zgo2.Marketplace.UpdateCargo(ply,StartMarketplace)

	local TransferID = zclib.util.GenerateUniqueID("xxxxxxxxxx")
	zgo2.Marketplace.Transfers[ steamid ][TransferID] = {
		MuleID = MuleID,
		StartID = StartMarketplace,
		DestinationID = DestinationMarketplace,
		CargoList = CargoList
	}

	// Figure out what the duration of the travel will be using the distance of the used path
	local TravelDuration = zgo2.Marketplace.GetTravelDuration(MuleID,StartMarketplace,DestinationMarketplace)

	local timerid = "zgo2.Marketplace.SendCargo." .. steamid .. TransferID
	zclib.Timer.Remove(timerid)
	zclib.Timer.Create(timerid, TravelDuration, 1, function()

		if not IsValid(ply) then return end

		local MuleData = zgo2.config.Mules[MuleID]

		// How much does all the cargo weigh which has spillage and also get a list of which cargo_id has spillage
		local MaxWeight , SpillageList = zgo2.Marketplace.GetFreightWeight(CargoList,true)

		// How much of the weed will be lost
		local SpillageAmount = math.Round(MaxWeight * ((1 / 100) * MuleData.spillage))

		// How much will we cut per iteration
		local ReduceAmount = math.Round(SpillageAmount * 0.1)

		// Just to be save lets make sure we dont call this endless should something happen
		local CallLimit = 60
		local CallCount = 0

		while SpillageAmount > 0 and CallCount < CallLimit do

			CallCount = CallCount + 1

			// Get a random weed in the list
			local _,cargo_id = table.Random(SpillageList)
			local cargo_data = CargoList[cargo_id]
			if not cargo_data then continue end

			local CargoConfig = zgo2.Cargo.Get(cargo_data[1])
			if not CargoConfig then continue end

			local cargo_amount = CargoConfig.GetAmount(cargo_data)

			// How much can we remove from this weed
			local reduce = cargo_amount > ReduceAmount and ReduceAmount or cargo_amount

			CargoConfig.SetAmount(cargo_data,cargo_amount - reduce)

			SpillageAmount = SpillageAmount - reduce

			if CargoConfig.GetAmount(cargo_data) <= 0 then CargoList[cargo_id] = nil end
		end

		// Add the cargo to the destination
		zgo2.Marketplace.AddCargo(DestinationMarketplace,CargoList,ply)

		// Remove the transfer from the list
		zgo2.Marketplace.Transfers[ steamid ][TransferID] = nil

		zclib.Timer.Remove(timerid)
	end)

	// Update the player about this transfer
	net.Start("zgo2.Marketplace.SendCargo")
	net.WriteString(ply:SteamID64())
	net.WriteString(TransferID)
	net.WriteUInt(StartMarketplace,10)
	net.WriteUInt(DestinationMarketplace,10)
	net.WriteUInt(TravelDuration,32)
	net.WriteUInt(MuleID,32)
	net.Broadcast()
	//net.Send(ply)
end

///////////////////////////////////////////////////////////////////

/*
	Saves all the cargo thats currently in each marketplace
*/
file.CreateDir( "zgo2" )
file.CreateDir( "zgo2/marketplace" )

/*
	Saves the Cargo Data for the specified player
*/
function zgo2.Marketplace.SaveCargoForPlayer(SteamID64)
	if not zgo2.config.Marketplace.Save.Enabled then return end
	if not SteamID64 then return end

	// Build the cargo list
	local PlayerCargo = {}
	for market_id,market_data in pairs(zgo2.Marketplace.List) do

		for steamid64,cargo_list in pairs(market_data.Cargo) do

			// Ignore this
			if steamid64 ~= SteamID64 then continue end

			// Convert the list ids for the weed to the unique ids
			local list = cargo_list or {}
			local UniqueList = {}
			for cargo_id,cargo_data in pairs(list) do

				local CargoConfig = zgo2.Cargo.Get(cargo_data[1])
				if CargoConfig and CargoConfig.PreSave then
					UniqueList[cargo_id] = CargoConfig.PreSave(cargo_data)
				else
					UniqueList[cargo_id] = cargo_data
				end
			end

			if UniqueList and table.Count(UniqueList) > 0 then
				PlayerCargo[market_id] = UniqueList
			end
		end
	end

	// Remove the cargo from the marketplace
	for market_id,market_data in pairs(zgo2.Marketplace.List) do

		for steamid64,cargo_list in pairs(market_data.Cargo) do

			// Ignore this
			if steamid64 ~= SteamID64 then continue end

			// Remove the data from the marketplace
			market_data.Cargo[steamid64] = nil
		end
	end

	local path = "zgo2/marketplace/"..SteamID64..".txt"
	if PlayerCargo == nil or table.Count(PlayerCargo) <= 0 then
		if file.Exists(path, "DATA") then file.Delete(path) end
		return
	end

	file.Write(path, util.TableToJSON(PlayerCargo,true))

	zgo2.Print("[Marketplace] Successfully saved [" .. SteamID64 .. "] cargo!")
end
zclib.Hook.Add("zclib_PlayerDisconnect", "zgo2.Marketplace.SaveOnDeconnect", function(steamid)
	local ply = SafeGetBySteamID(steamid)
	if IsValid(ply) then
		zgo2.Marketplace.SaveCargoForPlayer(ply:SteamID64())
	end
end)

/*
	Saves the Cargo Data for all players
*/
function zgo2.Marketplace.SaveCargoForAll()
	if not zgo2.config.Marketplace.Save.Enabled then return end

	for k,v in pairs(player.GetAll()) do
		if not IsValid(v) then continue end
		zgo2.Marketplace.SaveCargoForPlayer(v:SteamID64())
	end

	//zgo2.Print("[Marketplace] Successfully saved all players cargo!")
end
zclib.Hook.Add("ShutDown", "zgo2.Marketplace.Save", function() zgo2.Marketplace.SaveCargoForAll() end)

/*
	Loads the saved marketplace cargo for the specified player
*/
function zgo2.Marketplace.LoadCargo(ply)
	if not zgo2.config.Marketplace.Save.Enabled then return end

	local path = "zgo2/marketplace/" .. ply:SteamID64() .. ".txt"
	if not file.Exists(path, "DATA") then return end

	local data = file.Read(path, "DATA")
	if data == nil then return end
	data = util.JSONToTable(data)

	for market_id,cargo_list in pairs(data) do

		local converted = {}
		for cargo_id,cargo_data in pairs(cargo_list) do

			local CargoConfig = zgo2.Cargo.Get(cargo_data[1])
			if CargoConfig and CargoConfig.PostLoad then
				converted[cargo_id] = CargoConfig.PostLoad(cargo_data)
			else
				converted[cargo_id] = cargo_data
			end
		end

		zgo2.Marketplace.SetCargo(market_id,converted,ply)
	end

	zgo2.Print("[Marketplace] Successfully loaded cargo for " .. ply:Nick() .. " !")
end

/*
	Clean up any cargo savefile which is older then 1 month
*/
function zgo2.Marketplace.CleanUpCargo()
	local path = "zgo2/marketplace/"
	local files = file.Find(path .. "*", "DATA")

	for k, v in pairs(files) do

		if file.Exists(path .. v, "DATA") and (os.time() - file.Time(path .. v, "DATA")) > zgo2.config.Marketplace.Save.LifeTime then
			file.Delete(path .. v)
		end
	end
end
timer.Simple(3,zgo2.Marketplace.CleanUpCargo)
///////////////////////////////////////////////////////////////////
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher