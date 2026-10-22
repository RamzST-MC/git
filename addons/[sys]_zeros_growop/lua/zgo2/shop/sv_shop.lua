--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Shop = zgo2.Shop or {}
zgo2.Shop.List = zgo2.Shop.List or {}

/*

	Interaction:
		We could make 1 swep to let the player access / start all interactions
		Buy / Place entities from the shop
		Move Entities
		Plant seeds
		Water plants (Item shooter water balls?)
		Cut down plants
		Move branches to trying rack
		Cut buds from branches on some kind of table?
		Package weed from jars to blocks

*/

/*
	Updates the client about the category and itemid this entity is bound to
*/
util.AddNetworkString("zgo2.Shop.Update")
function zgo2.Shop.Update(ent,price)
	net.Start("zgo2.Shop.Update")
	net.WriteEntity(ent)
	net.WriteUInt(price,32)
	net.Broadcast()
end

util.AddNetworkString("zgo2.Shop.Purchase")
net.Receive("zgo2.Shop.Purchase", function(len,ply)
    zclib.Debug_Net("zgo2.Shop.Purchase", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local category = net.ReadString()
    local itemid = net.ReadUInt(32)

	if not zgo2.Shop.List[category] then return end

	local data = zgo2.Shop.List[category].items[itemid]
	if not data then return end

	if not zgo2.Shop.CanBuy(ply,category,itemid) then return end

	if zgo2.Shop.ReachedLimit(ply,category,itemid) then
		zclib.Notify(ply,"Reached Entity limit!", 1)
		return
	end

	local tr = zclib.util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = function(ent) return ent:GetClass() ~= "zgo2_plant" and not ent:IsPlayer() end
	}, "zgo2.Shop.Purchase")

	if not tr then return end
	if not tr.HitPos then return end

	if not zgo2.Multitool.IsPlaceTarget(ply,data.class,tr.HitPos,tr.Entity,category,itemid) then return end

	// We dont allow spliced plants to be bought
	if data.class == "zgo2_seed" and zgo2.Plant.IsSplice(data.id) then return end

	if data.class == "zgo2_pot" and IsValid(tr.Entity) and tr.Entity:GetClass() == "zgo2_tent" and not zgo2.Tent.GetPotSpot(tr.Entity) then return end
	if data.class == "zgo2_lamp" and IsValid(tr.Entity) and tr.Entity:GetClass() == "zgo2_tent" and not zgo2.Tent.GetLampSpot(tr.Entity) then return end

	if data.class == "zgo2_bulb" then
		if not IsValid(tr.Entity) then return end
		if tr.Entity:GetClass() ~= "zgo2_lamp" then return end

		// Check If this lamp even has space for another bulb
		if not zgo2.Lamp.CanAddBulb(tr.Entity) then
			zclib.Notify(ply, zgo2.language[ "No free socket found!" ], 1)
			return
		end
	end

	// If we gonna place the seed directly in a bot then we only buy 1 and only need to pay for 1
	local price = data.price
	if data.class == "zgo2_seed" and IsValid(tr.Entity) and not tr.HitWorld and tr.Entity:GetClass() == "zgo2_pot" then price = (price / zgo2.config.Seedbox.Count) * 1 end

	// Check if the player has money
	if not zclib.Money.Has(ply, price) then zclib.Notify(ply, zgo2.language[ "NotEnoughMoney" ], 1) return end

	// Remove the money from his wallet
	zclib.Money.Take(ply, price)

	hook.Run("zgo2.Shop.OnPurchase",ply,data)

	zclib.Notify(ply, "-" .. zclib.Money.Display(price), 0)

	zclib.NetEvent.Create("zgo2_buy", { tr.HitPos })

	if data.class == "zgo2_battery" and IsValid(tr.Entity) then
		if tr.Entity:GetClass() == "zgo2_lamp" then
			zgo2.Lamp.AddPower(tr.Entity, zgo2.config.Battery.Power)
		end

		if tr.Entity:GetClass() == "zgo2_clipper" and tr.Entity:GetHasMotor() then
			zgo2.Clipper.AddPower(tr.Entity, zgo2.config.Battery.Power)
		end

		return
	end

	if data.class == "zgo2_soil" and IsValid(tr.Entity) and tr.Entity:GetClass() == "zgo2_pot" then zgo2.Pot.AddSoil(tr.Entity,ply) return end

	if data.class == "zgo2_seed" and IsValid(tr.Entity) and not tr.HitWorld then zgo2.Pot.AddSeed(tr.Entity,data.id,ply) return end

	if data.class == "zgo2_bulb" then zgo2.Lamp.AddBulb(tr.Entity) return end

	if data.class == "zgo2_motor" then zgo2.Clipper.InstallMotor(tr.Entity,nil,true) return end

	if data.class == "zgo2_fuel" and IsValid(tr.Entity) and tr.Entity:GetClass() == "zgo2_generator" then zgo2.Generator.AddFuel(tr.Entity,zgo2.config.Generator.FuelPerCan) return end

	local ang = (ply:GetPos() - tr.HitPos):Angle()
	ang = Angle(0, 180 + ang.y + zgo2.Multitool.GetOffset(data.mdl), 0)

	local ent = ents.Create(data.class)
	if not IsValid(ent) then return end
	ent:SetPos(tr.HitPos)
	ent:SetAngles(ang)

	ent.zgo2_shop_price = price
	ent.zgo2_shop_data = data

	timer.Simple(1.5,function()
		if IsValid(ent) then
			zgo2.Shop.Update(ent,price)
		end
	end)

	if data.class == "zgo2_generator" then ent:SetGeneratorID(data.id) end

	if data.class == "zgo2_watertank" then ent:SetWatertankID(data.id) end

	if data.class == "zgo2_seed" then ent:SetPlantID(data.id) end

	if data.class == "zgo2_tent" then ent:SetTentID(data.id) end

	if data.class == "zgo2_rack" then ent:SetRackID(data.id) end

	if data.class == "zgo2_lamp" then ent:SetLampID(data.id) end

	if data.class == "zgo2_pot" then ent:SetPotID(data.id) end

	if data.class == "zgo2_backmix" then ent.EdibleID = data.id end

	// 1123098134
	ent:Spawn()
	ent:Activate()

	zclib.Player.SetOwner(ent, ply)

	local min,max = ent:GetCollisionBounds()
	local height = math.abs(min.z) + math.abs(max.z)
	ent:SetPos(tr.HitPos + Vector(0,0,height - math.abs(max.z)))


	if data.class == "zgo2_jar" and IsValid(tr.Entity) and tr.Entity:GetClass() == "zgo2_clipper" then zgo2.Clipper.AddJar(tr.Entity, ent) end

	if data.class == "zgo2_lamp" and IsValid(tr.Entity) and tr.Entity:GetClass() == "zgo2_tent" then zgo2.Tent.AddLamp(tr.Entity, ent) end

	if data.class == "zgo2_pot" and IsValid(tr.Entity) then
		if tr.Entity:GetClass() == "zgo2_tent" then
			zgo2.Tent.AddPot(tr.Entity,ent)
		end

		if string.sub(tr.Entity:GetClass(),1,9) == "zgo2_rack" then
			zgo2.Rack.AddPot(tr.Entity,ent)
		end
	end

	/*
		Starts the pointer system to let the player select the endpoint of the dryline
	*/
	if data.class == "zgo2_dryline" then
		timer.Simple(0.25,function()
			if not IsValid(ply) then return end
			if not IsValid(ent) then return end
			zgo2.Dryline.StartPointer(ent,ply)
		end)
		ang = tr.HitNormal:Angle()
		ang:RotateAroundAxis(ang:Right(),-90)
		ent:SetWallAngle(ang)
		ent:SetAngles(ang)

		ent:EmitSound("weapons/crossbow/hit1.wav")
	end
end)

util.AddNetworkString("zgo2.Shop.Sell")
net.Receive("zgo2.Shop.Sell", function(len,ply)
    zclib.Debug_Net("zgo2.Shop.Sell", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

	local ent = net.ReadEntity()
	if not IsValid(ent) then return end
	if not zclib.util.InDistance(ent:GetPos(),ply:GetPos(), 400) then return end

	if zgo2.config.Shop.Refund <= 0 then return end

	zgo2.Shop.Sell(ent,ply)
end)

function zgo2.Shop.Sell(ent,ply)
	if not zclib.Player.IsOwner(ply, ent) then return end

	if zclib.Entity.GettingRemoved(ent) then return end

	// Sell any entities parented to this entity first
	for k,v in ipairs(ent:GetChildren()) do
		if IsValid(v) then
			zgo2.Shop.Sell(v,ply)
		end
	end

	local price = zgo2.Shop.GetItemRefund(ent.zgo2_shop_price)
	if not price then return end

	zclib.NetEvent.Create("zgo2_buy", { ent:LocalToWorld(ent:OBBCenter()) })

	zclib.Entity.SafeRemove(ent)

	zclib.Money.Give(ply, price)

	hook.Run("zgo2.Shop.OnSell",ply,ent.zgo2_shop_data,price)

	zclib.Notify(ply, "+" .. zclib.Money.Display(price), 0)
end

zclib.Hook.Add("playerBoughtCustomEntity", "zgo2.Shop.SetItemPrice", function(ply, enttbl, ent, price)

	if enttbl and string.sub(ent:GetClass(),1,4) == "zgo2" then

		local dat = table.Copy(enttbl)
		dat.price = price
		dat.class = dat.ent

		ent.zgo2_shop_price = price
		ent.zgo2_shop_data = enttbl

		timer.Simple(1.5,function()
			if not IsValid(ent) then return end
			zgo2.Shop.Update(ent,price)
		end)
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher