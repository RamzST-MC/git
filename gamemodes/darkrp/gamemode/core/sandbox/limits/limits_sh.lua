rp.Limits = rp.Limits or {}
function rp.RegisterLimit(name)
    nw.Register('Limit_' .. name):Write(net.WriteUInt, 12):Read(net.ReadUInt, 12):SetLocalPlayer()
    rp.Limits[name] = true
    return name
end

function PLAYER:RpGetCount(name, count)
    local limit = self:GetNetVar('Limit_' .. name)
    if limit and limit > 0 then return limit - (count or 0) end
    return 0
end

function PLAYER:GetCount(str, minus)
	if (self._Counts and self._Counts[str]) then
		return self._Counts[str] - (minus or 0)
	end
	return 0
end