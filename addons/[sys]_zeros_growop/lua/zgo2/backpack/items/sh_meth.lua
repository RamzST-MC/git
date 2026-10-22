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
		extraData = SlotData.extraData,
	}, imgpnl)

	imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
	return imgpnl
end

zgo2.Backpack.RegisterItem("zmlab2_item_crate",{
	CanPickUp = function(ent) return ent:GetMethAmount() > 0 end,

	CanDrop = function(ply, data)
		return true
	end,

	GetData = function(slot_data) return {
		extraData = {
			meth_type = slot_data.DT.MethType,
			meth_amount = slot_data.DT.MethAmount,
			meth_qual = slot_data.DT.MethQuality,
		}
	}
	end,

	DisplayOverwrite = function(itm,SlotData) return SnapshotPanel(itm,SlotData) end
})







zgo2.Backpack.RegisterItem("zmlab2_item_meth",{
	CanPickUp = function(ent) return ent:GetMethAmount() > 0 end,

	CanDrop = function(ply, data)
		return true
	end,

	GetData = function(slot_data) return {
		extraData = {
			meth_type = slot_data.DT.MethType,
			meth_amount = slot_data.DT.MethAmount,
			meth_qual = slot_data.DT.MethQuality,
		}
	}
	end,

	DisplayOverwrite = function(itm,SlotData) return SnapshotPanel(itm,SlotData) end
})


zclib.CacheModel("models/zerochain/props_methlab/zmlab2_bag.mdl")

zclib.Snapshoter.SetPath("zmlab2_item_meth", function(ItemData)
	if ItemData.extraData.meth_amount > 0 then
		return "zmlab2/meth/meth_" .. math.Round(ItemData.extraData.meth_type) .. "_" .. math.Round((3 / 100) * ItemData.extraData.meth_qual)
	end
end)

hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosMethlab2_zgo2", function(cEnt, ItemData)
	if zmlab2 and ItemData.class == "zmlab2_item_meth" and ItemData.extraData and ItemData.extraData.meth_amount > 0 then
		local MethMat = zmlab2.Meth.GetMaterial(ItemData.extraData.meth_type, ItemData.extraData.meth_qual)

		if MethMat then
			cEnt:SetSubMaterial(0, "!" .. MethMat)
		end
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher