-- leak by lordee
local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_yeastbeast/yb_jarcrate_full.mdl")
ITEM:SetDescription("A crate with Moonshine jars.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data
	ent:SetJarCount(data.JarCount)
	zyb.f.SetOwner(ent, ply)
end)

/*
function ITEM:CanStack(newItem, invItem)
	return newItem.data.JarCount == invItem.data.JarCount
end
*/

function ITEM:OnPickup(ply, ent)
	if (not IsValid(ent)) then return end
	if ent:GetJarCount() <= 0 then
		return
	end

	local info = {
		ent = self:GetEntityClass(ent),
		dropEnt = self:GetDropEntityClass(ent),
		amount = self:GetEntityAmount(ent),
		data = self:GetData(ent)
	}

	self:Pickup(ply, ent, info)

	return true
end

function ITEM:GetData(ent)
	return {
		JarCount = ent:GetJarCount(),
	}
end

function ITEM:GetVisualAmount(item)
	return item.data.JarCount
end


function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	return "Moonshine Crate"
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -22,
		Z = 25,
		Angles = Angle(0, -190, 0),
		Pos = Vector(0, 0, -1)
	}
end
/*
function ITEM:GetClientsideModel(tbl, mdlPanel)

	local genValue = tbl.data.GenValue
	local genType = tbl.data.GenType
	local genclass = tbl.data.GenClass

	if genType ~= 0 then
		mdlPanel.Entity:SetBodygroup(0, 1)
	end

	if genType == 1 then
		// Check if sample is from player and color the liquid red
		if genclass and genclass == "player" then
			mdlPanel.Entity:SetSubMaterial(0, "zerochain/props_bloodlab/flask/zyb_flask_liquid_bloodsample")
		end
	elseif genType == 2 then
		local vaccine_data = zyb.config.Vaccines[genValue]
		if vaccine_data then
			if vaccine_data.isvirus == true then

				mdlPanel.Entity:SetSubMaterial(0, vaccine_data.mat)
			else
				mdlPanel.Entity:SetSubMaterial(0, "zerochain/props_bloodlab/flask/zyb_flask_liquid_abillity_diff")
			end
		end
	elseif genType == 3 then
		mdlPanel.Entity:SetSubMaterial(0, "zerochain/props_bloodlab/flask/zyb_flask_liquid_cure_diff")
	end
end
*/
ITEM:Register("zyb_jarcrate")
-- leak by lordee