--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Backpack = zgo2.Backpack or {}
zgo2.Backpack.List = zgo2.Backpack.List or {}

/*

	The backpack swep can be used to transport weed

*/

/*
	Returns the first empty slot it can find
*/
function zgo2.Backpack.FindFreeSlot(Backpack,ply)

	if not ply.zgo2_backpack then ply.zgo2_backpack = {} end

	local slot
	for i = 1, zgo2.config.Backpack.SlotCount do
		if not ply.zgo2_backpack[ i ] then
			slot = i
			break
		end
	end

	return slot
end

/*
	Returns if the players backpack has items
*/
function zgo2.Backpack.HasItems(ply)

	if not ply.zgo2_backpack then ply.zgo2_backpack = {} end

	local result = false
	for i = 1, zgo2.config.Backpack.SlotCount do
		if ply.zgo2_backpack[ i ] then
			result = true
			break
		end
	end

	return result
end

/*
	Checks if the player is allowed to pick up this entity
*/
function zgo2.Backpack.AllowPickup(ent,ply)
	local allowed_item = false
	local itemclass = ent:GetClass()

	local result = hook.Run("zgo2.Backpack.AllowPickup",ply,ent)
	if result ~= nil then return result end

	for _, allowed in pairs(zgo2.config.Backpack.Allowed) do
		if (itemclass:find(allowed)) then
			allowed_item = true
			break
		end
	end

	for _, banned in pairs(zgo2.config.Backpack.Blocked) do
		if (itemclass:find(banned)) then
			ply:ChatPrint(zgo2.language[ "Backpack_pickup_blocked" ])
			allowed_item = false
			break
		end
	end

	// If the player does not own the entity then stop
	if zclib.Player.GetOwner(ent) ~= ply then
		ply:ChatPrint(zgo2.language[ "Backpack_pickup_notowner" ])
		allowed_item = false
	end

	return allowed_item
end

/*
	The Primary function of the backpack swep to pick up objects
*/
function zgo2.Backpack.PrimaryAttack(Backpack)
	if not IsFirstTimePredicted() then return end

	local ply = Backpack:GetOwner()
	if not IsValid(ply) then return end

	local tr = ply:GetEyeTrace()
	if not tr then return end
	local ent = tr.Entity
	if not IsValid(ent) then return end

	local TargetData = zgo2.Backpack.Items[ent:GetClass()]
	if TargetData and TargetData.CanPickUp then
		if not TargetData.CanPickUp(ent) then return end
	else
		if not zgo2.Backpack.AllowPickup(ent,ply) then return end
	end

	// Perform pickup action
	local slot = zgo2.Backpack.FindFreeSlot(Backpack,ply)
	if not slot then return end

	ply.zgo2_backpack[slot] = duplicator.CopyEntTable( ent )
	SafeRemoveEntity(ent)
	zclib.Sound.EmitFromEntity("inv_add", ply)

	zgo2.Backpack.Update(ply,ply)
end

local function BuildPackage(SlotData)
	local dat = {}

	dat.Class = SlotData.Class
	dat.Model = SlotData.Model
	dat.Skin = SlotData.Skin

	local TargetData = zgo2.Backpack.Items[SlotData.Class]
	if TargetData and TargetData.GetData then
		dat = table.Merge(dat,TargetData.GetData(SlotData))
	end

	return dat
end

local function CompressBackpack(BackpackData)
	local compressed = {}
	for slot_id,slot_data in pairs(BackpackData) do
		compressed[slot_id] = BuildPackage(slot_data)
	end
	return compressed
end

util.AddNetworkString("zgo2.Backpack.Open")
function zgo2.Backpack.Open(ply,InvEnt)
	if not IsValid(ply) then return end

	net.Start("zgo2.Backpack.Open")
	net.WriteEntity(InvEnt)
	local e_String = util.TableToJSON(CompressBackpack(InvEnt.zgo2_backpack))
	local e_Compressed = util.Compress(e_String)
    net.WriteUInt(#e_Compressed,16)
    net.WriteData(e_Compressed,#e_Compressed)
	net.Send(ply)
end

util.AddNetworkString("zgo2.Backpack.Update")
function zgo2.Backpack.Update(ply,InvEnt)
	if not IsValid(ply) then return end

	net.Start("zgo2.Backpack.Update")
	net.WriteEntity(InvEnt)
	local e_String = util.TableToJSON(CompressBackpack(InvEnt.zgo2_backpack))
	local e_Compressed = util.Compress(e_String)
	net.WriteUInt(#e_Compressed,16)
	net.WriteData(e_Compressed,#e_Compressed)
	net.Send(ply)
end

function zgo2.Backpack.SecondaryAttack(Backpack)
	if not IsFirstTimePredicted() then return end

	local ply = Backpack:GetOwner()
	zgo2.Backpack.Open(ply,ply)
end

util.AddNetworkString("zgo2.Backpack.Drop")
util.AddNetworkString("zgo2.Backpack.ForceClose")
net.Receive("zgo2.Backpack.Drop", function(len,ply)
	zclib.Debug_Net("zgo2.Backpack.Drop", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

	local BackpackEntity = net.ReadEntity()
	if not IsValid(BackpackEntity) then return end

	// If the backpack entity is not a dropped backpack and not the player then we dont allow him to acess the inventory
	if BackpackEntity:GetClass() ~= "zgo2_backpack_ent" and BackpackEntity ~= ply then return end

	if not zclib.util.InDistance(BackpackEntity:GetPos(), ply:GetPos(), 500) then return end

	local SlotID = net.ReadUInt(32)
	if not SlotID then return end
	local SlotData = BackpackEntity.zgo2_backpack[SlotID]
	if not SlotData then return end

	local TargetData = zgo2.Backpack.Items[SlotData.Class]
	if TargetData and TargetData.CanDrop and not TargetData.CanDrop(ply,SlotData) then return end

	local ent = duplicator.CreateEntityFromTable(ply,SlotData)
	if not IsValid(ent) then
		ply:ChatPrint("Could not rebuild " .. tostring(SlotData.Class) .. "! Invalid Entity?")
		return
	end
	ent:SetPos(ply:EyePos() + ply:EyeAngles():Forward() * 35)
	ent:Spawn()
	zclib.Player.SetOwner(ent, ply)

	BackpackEntity.zgo2_backpack[SlotID] = nil

	if BackpackEntity:GetClass() == "zgo2_backpack_ent" then

		if zgo2.Backpack.HasItems(BackpackEntity) then
			zgo2.Backpack.Open(ply,BackpackEntity)
		else

			net.Start("zgo2.Backpack.ForceClose")
			net.Send(ply)

			SafeRemoveEntity(BackpackEntity)
		end
	else
		zgo2.Backpack.Open(ply,BackpackEntity)
	end
end)

// We dont allow him to drop his Backpack
zclib.Hook.Add("canDropWeapon", "BackpackDrop", function(ply,swep)
    if IsValid(swep) and swep:GetClass() == "zgo2_backpack" then
        return false
    end
end)

zclib.Hook.Add("PlayerDeath", "BackpackDropOnDeath", function(victim, inflictor, attacker)
    if IsValid(victim) and zgo2.config.Backpack.DropOnDeath and victim:HasWeapon("zgo2_backpack") and victim.zgo2_backpack and zgo2.Backpack.HasItems(victim) then

		// Drop backpack entity
		local ent = ents.Create("zgo2_backpack_ent")
		ent:SetPos(victim:GetPos() + Vector(0,0,20))
		ent.zgo2_backpack = victim.zgo2_backpack
		ent:Spawn()
		ent:Activate()
		zclib.Player.SetOwner(ent, victim)

		victim.zgo2_backpack = {}
	end
end)

/*
	Called when the backpack entity Initializes
*/
function zgo2.Backpack.Initialize(Backpack)
	if zgo2.config.Backpack.DespawnTime and zgo2.config.Backpack.DespawnTime > 0 then
		SafeRemoveEntityDelayed(Backpack,zgo2.config.Backpack.DespawnTime)
	end
end

/*
	Called when a player trys to open a dropped backpack world entity
*/
function zgo2.Backpack.OnUse(Backpack,ply)

	// Open backpack inventory if it exists
	if not Backpack.zgo2_backpack then
		SafeRemoveEntity(Backpack)
		return
	end

	zgo2.Backpack.Open(ply,Backpack)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher