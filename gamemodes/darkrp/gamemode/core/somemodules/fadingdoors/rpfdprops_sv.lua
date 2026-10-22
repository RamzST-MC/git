rp.fadingdoor = rp.fadingdoor or {}
rp.fadingdoor.Props = rp.fadingdoor.Props or {}

function rp.fadingdoor.AddProp(pl, prop)
    if not IsValid(pl) or not IsValid(prop) then return end
    if not prop:IsProp() then return end
    
    rp.fadingdoor.Props[pl] = rp.fadingdoor.Props[pl] or {}
    
    if not table.HasValue(rp.fadingdoor.Props[pl], prop) then
        table.insert(rp.fadingdoor.Props[pl], prop)
        prop:SetNWBool("FadingDoorBool", true)
    end
end

function rp.fadingdoor.RemoveProp(pl, prop)
    if not IsValid(pl) or not IsValid(prop) then return end
    
    if rp.fadingdoor.Props[pl] then
        table.RemoveByValue(rp.fadingdoor.Props[pl], prop)
        prop:SetNWBool("FadingDoorBool", false)
    end
end

function rp.fadingdoor.HasProp(pl, prop)
    if not IsValid(pl) or not IsValid(prop) then return false end
    
    return rp.fadingdoor.Props[pl] and table.HasValue(rp.fadingdoor.Props[pl], prop) or false
end

function rp.fadingdoor.GetProps(pl)
    return rp.fadingdoor.Props[pl] or {}
end

function rp.fadingdoor.ClearProps(pl)
    if rp.fadingdoor.Props[pl] then
        for _, prop in ipairs(rp.fadingdoor.Props[pl]) do
            if IsValid(prop) then
                prop.FadingDoor = nil
            end
        end
        rp.fadingdoor.Props[pl] = {}
    end
end

function rp.fadingdoor.Toggle(prop, state)
    if not IsValid(prop) then return end
    
    if state == nil then
        state = not prop:GetNWBool("FadingDoor")
    end
    
    prop:SetNWBool("FadingDoor", state)
    prop:Fire(state and "Open" or "Close")
end

hook.Add("PlayerDisconnected", "FadingDoorCleanup", function(pl)
    rp.fadingdoor.ClearProps(pl)
end)

function PLAYER:GetItems(str)
	if not self._SpawnedItems or not self._SpawnedItems[str] then return {} end

	local valid = {}
	for _, ent in ipairs(self._SpawnedItems[str]) do
		if IsValid(ent) then
			table.insert(valid, ent)
		end
	end

	return valid
end
