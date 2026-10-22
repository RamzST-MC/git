rp.cfg.Limits = {
	['dynamite']	= 0,
	['hoverballs']	= 0,
	['turrets']		= 0,
	['spawners']	= 0,
	['emitters']	= 0,
	['effects']		= 0,
	['buttons']		= 5,
	['ragdolls']	= 0,
	['npcs']		= 0,
	['lamps']		= 0,
	['balloons']	= 0,
	['lights']		= 0,
	['props']		= rp.cfg.PropLimit,
	['vehicles']	= 0,
	['sents']		= 25,
	['keypads']		= 10,
	['textscreens'] = 3,
	['cameras']		= 3,
	['shields']     = 3,
	['biometrics']     = 8,
	['tolls']     = 4
}

function rp.GetLimit(name)
	return rp.cfg.Limits[name] or 0
end

function rp.SetLimit(name, limit)
	rp.cfg.Limits[name] = limit
end