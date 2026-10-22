-- leak by lordee
ITEM.Name = "Moonshine"
ITEM.Description = "A Jar of Moonshine."
ITEM.Model = "models/zerochain/props_yeastbeast/yb_jar.mdl"
ITEM.Base = "base_darkrp"



function ITEM:CanPickup(pl, ent)
	if ent:GetMoonShine() >= zyb.config.Jar.MoonshineAmount then return true end

	return false
end

function ITEM:SaveData(ent)
	self:SetData("MoonShine", ent:GetMoonShine())
end

function ITEM:LoadData(ent)
	timer.Simple(0.1, function()
		if IsValid(ent) then
			ent:SetMoonShine(self:GetData("MoonShine"))

			local jarMoonshine = ent:GetMoonShine()
			local jarMax = zyb.config.Jar.MoonshineAmount

			if jarMoonshine >= jarMax then
				ent:SetBodygroup(2, 5)
			elseif jarMoonshine >= jarMax * 0.75 then
				ent:SetBodygroup(2, 4)
			elseif jarMoonshine >= jarMax * 0.5 then
				ent:SetBodygroup(2, 3)
			elseif jarMoonshine >= jarMax * 0.25 then
				ent:SetBodygroup(2, 2)
			elseif jarMoonshine >= jarMax * 0.1 then
				ent:SetBodygroup(2, 1)
			else
				ent:SetBodygroup(2, 0)
			end

			ent:SetBodygroup(1,1)
		end
	end)
end
-- leak by lordee