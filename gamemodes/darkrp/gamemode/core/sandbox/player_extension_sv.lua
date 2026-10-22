function PLAYER:CheckLimit(str)
	local c = rp.GetLimit(str)
	if (c < 0) then return true end
	if (self:GetCount(str) >= c) then 
		self:LimitHit(str) 
		return false 
	end
	return true
end

function PLAYER:GetCount(str, minus)
	if (self._Counts and self._Counts[str]) then
		return self._Counts[str] - (minus or 0)
	end
	return 0
end

function PLAYER:AddCount(str, ent)
	if (SERVER) then
		if not self._Counts then self._Counts = {} end
		if not self._SpawnedItems then self._SpawnedItems = {} end
		if not self._SpawnedItems[str] then self._SpawnedItems[str] = {} end

		self._Counts[str] = (self._Counts[str] or 0) + 1
		table.insert(self._SpawnedItems[str], ent)

		ent.OnRemoveCount = function()
			if IsValid(self) then
				self._Counts[str] = self._Counts[str] - 1
			end
		end
	end
end


function PLAYER:LimitHit(str)
	rp.Notify(self, NOTIFY_ERROR, term.Get('SboxXLimit'), str)
end

function PLAYER:GetLimit(str)
	return rp.cfg.Limits[str] or 0
end

function PLAYER:AddCleanup(type, ent)
	cleanup.Add(self, type, ent)
end

function PLAYER:GetTool( mode )
	local wep = self:GetWeapon('gmod_tool')
	if (!wep || !wep:IsValid()) then return nil end
	
	local tool = wep:GetToolObject( mode )
	if (!tool) then return nil end
	
	return tool
end

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


hook('EntityRemoved', function(ent)
	if ent.OnRemoveCount then ent.OnRemoveCount() end
end)