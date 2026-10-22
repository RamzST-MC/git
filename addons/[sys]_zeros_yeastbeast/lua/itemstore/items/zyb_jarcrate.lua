-- leak by lordee
ITEM.Name = "Moonshine Crate"
ITEM.Description = "A crate full of Moonshine Jars."
ITEM.Model = "models/zerochain/props_yeastbeast/yb_jarcrate.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetDescription()
	local desc = self.Description
	local JarCount = self:GetData("JarCount")
	desc = "JarCount: " .. tostring(JarCount)

	return self:GetData("Description", desc)
end

function ITEM:CanPickup(pl, ent)
	if ent:GetJarCount() > 0 then return true end

	return false
end

function ITEM:SaveData(ent)
	self:SetData("JarCount", ent:GetJarCount())
end

function ITEM:LoadData(ent)
	ent:SetJarCount(self:GetData("JarCount"))
	timer.Simple(0.1,function()
		if IsValid(ent) then
			ent:ItemStoreSpawn()
		end
	end)
end
-- leak by lordee