--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*

	Here we register a custom Backpack item class to overwrite
		What custom data we wanna send to the client
		How the item looks in the slot
		When it can be pickedup or dropped from the inventory

*/

local function SnapshotPanel(itm,SlotData)
	local imgpnl = vgui.Create("DImage", itm)
	imgpnl:Dock(FILL)

	local img = zclib.Snapshoter.Get({
		class = SlotData.Class,
		model = SlotData.Model,
		PlantID = SlotData.weed_id,
	}, imgpnl)

	imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
	return imgpnl
end


zgo2.Backpack.RegisterItem("zgo2_jar",{
	CanPickUp = function(ent) return ent:GetWeedID() > 0 end,

	CanDrop = function(ply, data)
		if zgo2.Jar.ReachedSpawnLimit(ply) then
			zclib.Notify(ply, zgo2.language[ "Spawnlimit" ], 1)

			return
		end
		return true
	end,

	GetData = function(slot_data) return { weed_id = slot_data.DT.WeedID, weed_amount = slot_data.DT.WeedAmount or 1 } end,

	DisplayOverwrite = function(itm,SlotData) return SnapshotPanel(itm,SlotData) end
})

zgo2.Backpack.RegisterItem("zgo2_weedblock",{
	CanPickUp = function(ent) return ent:GetWeedID() > 0 end,

	CanDrop = function(ply, data)
		if zgo2.Weedblock.ReachedSpawnLimit(ply) then
			zclib.Notify(ply, zgo2.language[ "Spawnlimit" ], 1)

			return
		end
		return true
	end,

	GetData = function(slot_data) return { weed_id = slot_data.DT.WeedID, weed_amount = slot_data.DT.WeedAmount or 1 } end,

	DisplayOverwrite = function(itm,SlotData) return SnapshotPanel(itm,SlotData) end
})
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher