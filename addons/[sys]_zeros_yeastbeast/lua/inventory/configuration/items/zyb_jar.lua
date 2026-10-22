-- leak by lordee
local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(10)
ITEM:SetModel("models/zerochain/props_yeastbeast/yb_jar.mdl")
ITEM:SetDescription("A Jar of Moonshine.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data
	ent:SetMoonShine(data.Moonshine)
	ent:UpdateVisuals()
	zyb.f.SetOwner(ent, ply)
end)

function ITEM:OnPickup(ply, ent)
	if (not IsValid(ent)) then return end
	if ent:GetMoonShine() <= 0 then
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


function ITEM:CanStack(newItem, invItem)
	return newItem.data.Moonshine == invItem.data.Moonshine
end


function ITEM:GetData(ent)
	return {
		Moonshine = ent:GetMoonShine(),
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	return "Moonshine Jar"
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -22,
		Z = 25,
		Angles = Angle(0, -15, 0),
		Pos = Vector(0, 0, -1)
	}
end

function ITEM:GetClientsideModel(tbl, mdlPanel)

	local jarMoonshine = tbl.data.Moonshine
	local jarMax = zyb.config.Jar.MoonshineAmount

	if jarMoonshine >= jarMax then
		mdlPanel.Entity:SetBodygroup(2, 5)
	elseif jarMoonshine >= jarMax * 0.75 then
		mdlPanel.Entity:SetBodygroup(2, 4)
	elseif jarMoonshine >= jarMax * 0.5 then
		mdlPanel.Entity:SetBodygroup(2, 3)
	elseif jarMoonshine >= jarMax * 0.25 then
		mdlPanel.Entity:SetBodygroup(2, 2)
	elseif jarMoonshine >= jarMax * 0.1 then
		mdlPanel.Entity:SetBodygroup(2, 1)
	else
		mdlPanel.Entity:SetBodygroup(2, 0)
	end

	mdlPanel.Entity:SetBodygroup(1, 1)
end

ITEM:Register("zyb_jar")
-- leak by lordee