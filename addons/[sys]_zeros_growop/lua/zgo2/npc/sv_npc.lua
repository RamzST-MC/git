--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.NPC = zgo2.NPC or {}
zgo2.NPC.List = zgo2.NPC.List or {}

/*

	Players can buy bongs , sell small amounts of weed and request weed transfer positions for large amounts of weed (So that it be send to the global Marketplace)

*/

function zgo2.NPC.Initialize(NPC)
	NPC:SetModel(NPC.Model)
	NPC:SetSolid(SOLID_BBOX)
	NPC:SetHullSizeNormal()
	NPC:SetNPCState(NPC_STATE_SCRIPT)
	NPC:SetHullType(HULL_HUMAN)
	NPC:SetUseType(SIMPLE_USE)

	NPC.NextQuickSell = CurTime()
end

/*
	Open the interface
*/
util.AddNetworkString("zgo2.NPC.Open")
function zgo2.NPC.Open(NPC,ply)
	net.Start("zgo2.NPC.Open")
	net.WriteEntity(NPC)
	net.WriteUInt(NPC.NextQuickSell,32)
	net.Send(ply)
end

/*
	Lets the player buy a bong
*/
util.AddNetworkString("zgo2.NPC.PurchaseBong")
net.Receive("zgo2.NPC.PurchaseBong", function(len,ply)
    zclib.Debug_Net("zgo2.NPC.PurchaseBong", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local bongid = net.ReadUInt(32)

	local BongData = zgo2.Bong.GetData(bongid)
	if not BongData then return end

	if not zgo2.NPC.CanBuyBong(ply,bongid) then return end

	// Check if the player has money
	if not zclib.Money.Has(ply, BongData.price) then
		zclib.PanelNotify.Create(ply, zgo2.language[ "NotEnoughMoney" ], 1)
		return
	end

	// Remove the money from his wallet
	zclib.Money.Take(ply,BongData.price)
	zclib.Notify(ply, "-" .. zclib.Money.Display(BongData.price), 0)

	local swep = ply:GetWeapon("zgo2_bong")
	if not IsValid(swep) then
		swep = ply:Give( "zgo2_bong" )
	end

	if IsValid(swep) then
		swep:SetBongID(bongid)
		swep:SetWeedID(-1)
		swep:SetWeedAmount(0)

		swep:SetIsBusy(false)
		swep:SetIsBurning(false)
		swep:SetIsSmoking(false)
	end
end)

/*
	Lets the player sell small amounts of weed quick
*/
util.AddNetworkString("zgo2.NPC.QuickSell")
net.Receive("zgo2.NPC.QuickSell", function(len,ply)
    zclib.Debug_Net("zgo2.NPC.QuickSell", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

	local npc = net.ReadEntity()
	if not IsValid(npc) then return end
	if npc:GetClass() ~= "zgo2_npc" then return end
	if not zclib.util.InDistance(ply:GetPos(), npc:GetPos(), 300) then return end

	if not zgo2.NPC.IsCustomer(ply) then return end

	if npc.NextQuickSell > CurTime() then
		return
	end


	local Added = 0
	local SoldList = {}
	for k,v in ipairs(ents.FindInSphere(npc:GetPos(),200)) do

		if Added >= zgo2.config.NPC.QuickSell.Amount then break end

		if not IsValid(v) then continue end
		if v:GetClass() ~= "zgo2_jar" then continue end

		local id = v:GetWeedID()
		if id <= 0 then continue end

		local am = v:GetWeedAmount()
		local add = 0
		if am > zgo2.config.NPC.QuickSell.Amount then
			add = zgo2.config.NPC.QuickSell.Amount
		else
			add = am
		end
		v:SetWeedAmount(am - add)

		if v:GetWeedAmount() <= 0 then

			// Create money effect
			zclib.NetEvent.Create("zgo2_buy", { v:GetPos() })

			local parent = v:GetParent()
			if IsValid(parent) and parent:GetClass() == "zgo2_jarcrate" and not zclib.Entity.GettingRemoved(parent) then
				// Drop the jar from the crate
				zgo2.JarCrate.DropJar(parent, v, true)

				// Remove the crate if empty
				if parent.WeedList and table.Count(parent.WeedList) <= 0 then
					zclib.Entity.SafeRemove(parent)
				end
			end

			// Remove the jar
			v:Remove()
		end

		Added = Added + add
		SoldList[ id ] = (SoldList[ id ] or 0) + add
	end

	// Add the weed jars from the backpack
	local backpack = ply:GetWeapon("zgo2_backpack")
	if backpack and IsValid(backpack) and backpack.Inventory then
		local ToClear = {}
		for k, v in pairs(backpack.Inventory) do
			if v and v.Class == "zgo2_jar" and v.DT and v.DT.WeedID then
				SoldList[ v.DT.WeedID ] = (SoldList[ v.DT.WeedID ] or 0) + v.DT.WeedAmount
				ToClear[ k ] = true
			end
		end
		for k, v in pairs(ToClear) do
			backpack.Inventory[ k ] = nil
		end

		// Update the player about his backpack
		zgo2.Backpack.Update(backpack,ply)
	end


	if table.Count(SoldList) <= 0 then
		zclib.Notify(ply, zgo2.language[ "Quick Sell Failed" ], 1)
		return
	end

	for weed_id, weed_amount in pairs(SoldList) do
		local WeedData = zgo2.Plant.GetData(weed_id)
		if not WeedData then continue end
		local WeedValue = ((zgo2.Plant.GetSellValue(weed_id) * weed_amount) / 100) * zgo2.config.NPC.QuickSell.Rate
		zclib.Money.Give(ply, WeedValue)
		zclib.Notify(ply, "+" .. zclib.Money.Display(WeedValue), 0)

		hook.Run("zgo2.NPC.OnQuickSell",ply,weed_id,weed_amount,WeedValue)
	end

	npc.NextQuickSell = CurTime() + zgo2.config.NPC.QuickSell.Cooldown

	timer.Simple(0.6,function()
		if not IsValid(npc) then return end
		if not IsValid(ply) then return end
		net.Start("zgo2.NPC.QuickSell")
		net.WriteEntity(npc)
		net.WriteUInt(npc.NextQuickSell,32)
		net.Send(ply)
	end)
end)


/*
	Called when the player requests a DropZone
*/
util.AddNetworkString("zgo2.NPC.RequestDropZone")
net.Receive("zgo2.NPC.RequestDropZone", function(len,ply)
    zclib.Debug_Net("zgo2.NPC.RequestDropZone", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

	local npc = net.ReadEntity()
	if not IsValid(npc) then return end
	if npc:GetClass() ~= "zgo2_npc_export" then return end

	if not zclib.util.InDistance(ply:GetPos(), npc:GetPos(), 300) then return end

	// Check if the user is even allowed to sell any cargo
	// Get a list of all the cargo types the player is allowed to sell
	local CargoList = zgo2.Cargo.GetAllowed(ply)
	if not CargoList or table.Count(CargoList) <= 0 then return end

	// Find free DropZone
	local FreeZone = zgo2.DropZone.GetFree()
	if not FreeZone then
		zclib.Notify(ply, zgo2.language[ "RequestPickup_failed" ], 1)
		return
	end

	if ply.zgo2_DropZone then
		zclib.Notify(ply, zgo2.language[ "RequestPickup_failed02" ], 1)
		return
	end

	ply.zgo2_DropZone = FreeZone
	zgo2.DropZone.List[FreeZone].User = ply

	zclib.Notify(ply, zgo2.language[ "RequestPickup_accepted" ], 0)

	local Zone = zgo2.DropZone.List[FreeZone]

	local timer_main = "zgo2.NPC.RequestDropZone." .. ply:SteamID64()
	zclib.Timer.Remove(timer_main)
	zclib.Timer.Create(timer_main, zgo2.config.NPC.Export.Time, 1, function()

		if IsValid(ply) then
			local ExportCargo = {}

			// Catch all the weed jars near the zone and only accept the ones in the zone
			for k, v in ipairs(ents.FindInSphere(Zone.pos + (Zone.size / 2), 1000)) do
				if not IsValid(v) then continue end

				// Is the entity even in the dropzone?
				if not zclib.Zone.Check("zgo2_drop_zone",FreeZone,v:GetPos()) then continue end

				// Is the entity owned by the player?
				if zgo2.config.NPC.Export.OwnerCheck and not zclib.Player.IsOwner(ply, v) then continue end

				// Can be used to overwrite the Pickup function for the provided entity
				local ModifiedCargo = hook.Run("zgo2_CargoPickUp_Overwrite",v,ply,ExportCargo)
				if ModifiedCargo then
					ExportCargo = ModifiedCargo
					continue
				end

				// Can the entity even be sold?
				local CargoConfig = zgo2.Cargo.Get(v:GetClass())
				if not CargoConfig then continue end

				// Get the data set from the entity
				local CargoData = CargoConfig.GetData(v)
				if not CargoData then continue end

				// Ignore this entity if it cant be sold
				if not zgo2.Cargo.CanSell(CargoData,ply) then continue end

				v:Remove()

				// Lets try to merge the data in to a existing cargo that matches according to the can merge function
				for id,dat in pairs(ExportCargo) do
					if CargoConfig.CanMerge(dat,CargoData) then
						ExportCargo[id] = CargoConfig.Merge(dat,CargoData)
						CargoData = nil
						break
					end
				end
				// Stop if we could successfully find and merge the data
				if not CargoData then continue end

				// Create new cargo data
				table.insert(ExportCargo,CargoData)
			end


			local MarketplaceID = zgo2.config.NPC.Export.Location
			if MarketplaceID == -1 then MarketplaceID = math.random(#zgo2.Marketplace.List) end

			if ExportCargo and table.Count(ExportCargo) > 0 then
				zgo2.Marketplace.AddCargo(MarketplaceID,ExportCargo,ply)
				zclib.Notify(ply, string.Replace(zgo2.language[ "RequestPickup_completed" ], "$Location", zgo2.Marketplace.List[ MarketplaceID ].name), 0)
			end

			ply.zgo2_DropZone = nil
		end

		zgo2.DropZone.List[FreeZone].User = nil

		zclib.Timer.Remove(timer_main)
	end)

	if zgo2.config.NPC.Export.ReduceTimeOnArrival then
		// This timer will reduce the dropoff waiting time if the player comes near the zone
		local timer_adjuster = "zgo2.NPC.TimeReducer." .. ply:SteamID64()
		zclib.Timer.Remove(timer_adjuster)
		zclib.Timer.Create(timer_adjuster, 1, 0, function()
			if not IsValid(ply) then
				zclib.Timer.Remove(timer_adjuster)
				return
			end

			if zclib.util.InDistance(ply:GetPos(), Zone.pos + (Zone.size / 2), 200) then

				timer.Adjust(timer_main,30)

				// Update the client about the new time
				net.Start("zgo2.NPC.RequestDropZone")
				net.WriteEntity(npc)
				net.WriteUInt(FreeZone,32)
				net.WriteUInt(30,32)
				net.Send(ply)

				zclib.Timer.Remove(timer_adjuster)
			end
		end)
	end


	net.Start("zgo2.NPC.RequestDropZone")
	net.WriteEntity(npc)
	net.WriteUInt(FreeZone,32)
	net.WriteUInt(zgo2.config.NPC.Export.Time,32)
	net.Send(ply)
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher