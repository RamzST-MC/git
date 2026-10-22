-------------------------------------------------
-- Совместимость: в некоторых сборках GMod нет player.Iterator() / ents.Iterator().
-- Стандартные модули (team.GetPlayers, player.GetBySteamID64 и др.) вызывают их и падают с
--   "attempt to call field 'Iterator' (a nil value)".
-- Здесь функции создаются только если их нет, поэтому на новых сборках ничего не меняется.
-------------------------------------------------

local function makeIterator(getAll)
	return function()
		local list, i = getAll(), 0

		return function()
			i = i + 1
			local v = list[i]
			if (v ~= nil) then return i, v end
		end
	end
end

if (not player.Iterator) then
	player.Iterator = makeIterator(player.GetAll)
end

if (not ents.Iterator) then
	ents.Iterator = makeIterator(ents.GetAll)
end
