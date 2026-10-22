for k,v in pairs(rp.cfg.weapontablez) do
	if k != 'all' then
		table.Add(rp.cfg.weapontablez.all, v)
	end
end

local function GetTeamAllowed(t)
	local a = {}
	for k,v in pairs(rp.cfg.allowedW) do
		if _G[k] != t then
			continue
		end
		if type(v) == 'string' then
			table.Add(a, rp.cfg.weapontablez[v])
		else
			for _, w in pairs(v) do
				table.Add(a, rp.cfg.weapontablez[w])
			end
		end
	end
	return a
end

local function IsTeamAllowed( t, class )
	if table.HasValue(rp.cfg.weapontablez.all, class) then
		local tbl = GetTeamAllowed(t)
		if table.HasValue(tbl, class) then
			return true
		end
		return false
	end
	return true
end

local function NoticeMe( ply, class )
	ply.noticed = ply.noticed or CurTime()
	
	if ply.noticed > CurTime() then return end
	
	ply.noticed = CurTime() + 1
	
	local a = {}
	
	for k,v in pairs(rp.cfg.allowedW) do
		if _G[k] ==  ply:Team() then
			table.Add(a, type(v) == 'string' and {v} or v)
			break
		end
	end

	ply:ChatPrint('Вы не можете подобрать ' .. class .. '. Это оружие запрещено для данной профессии')
	ply:ChatPrint('Разрешенное оружие: ' .. (#a == 0 and 'нет разрешенного оружия' or string.Implode(', ', a)))
end

hook.Add('PlayerCanPickupWeapon','nonrp_debil',function(ply,w) 
	if w ~= nil then
		-- if ply.InFlameDM then return true end
		if ply:IsCuffed() or ply:IsZiptied() then
			return false
		end
		if not IsTeamAllowed(ply:Team(), w:GetClass()) then
			NoticeMe(ply, w:GetClass())
			return false
		end
    else
    	return  true
	end
end)
