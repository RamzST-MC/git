local spawns = rp.cfg.Spawns[game.GetMap()]
local spawns2 = {Vector(-3106.2568359375, 2463.96875, 143.45938110352), Vector(-2917.1950683594, 2271.8454589844, 0.03125)}

if not spawns or not spawns[1] or not spawns[2] then
	ErrorNoHalt("[DarkRP] WARNING: No spawn zone (rp.cfg.Spawns) defined for map '" .. game.GetMap() .. "'. SpawnClean and spawn protection will be disabled.\n")
else

timer.Create('SpawnClean', 0, 0, function()
	for k, v in ipairs(ents.FindInBox(spawns[1], spawns[2])) do
		if IsValid(v) then
			v.IsInSpawn = CurTime() + 1
			if rp.cfg.SpawnDisallow[v:GetClass()] then
				rp.Notify(v.ItemOwner or v:CPPIGetOwner(), NOTIFY_ERROR, term.Get('NotAllowedInSpawn'), v:GetClass())
				v:Remove()
			end
		end
	end
	for k, v in ipairs(ents.FindInBox(spawns2[1], spawns2[2])) do
		if IsValid(v) then
			v.IsInSpawn = CurTime() + 1
			if rp.cfg.SpawnDisallow[v:GetClass()] then
				rp.Notify(v.ItemOwner or v:CPPIGetOwner(), NOTIFY_ERROR, term.Get('NotAllowedInSpawn'), v:GetClass())
				v:Remove()
			end
		end
	end
end)

hook.Add('PlayerShouldTakeDamage', 'spawn::asdf', function(p, at)
	if table.HasValue(ents.FindInBox(spawns[1], spawns[2]), p) or table.HasValue(ents.FindInBox(spawns[1], spawns[2]), at) then
		return false
	end
	if table.HasValue(ents.FindInBox(spawns2[1], spawns2[2]), p) or table.HasValue(ents.FindInBox(spawns2[1], spawns2[2]), at) then
		return false
	end
	return true
end)

end -- spawns guard
