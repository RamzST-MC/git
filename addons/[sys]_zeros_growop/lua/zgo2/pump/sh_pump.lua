--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Pump = zgo2.Pump or {}
zgo2.Pump.List = zgo2.Pump.List or {}

/*

	Pumps move water from watertanks to pots

*/
function zgo2.Pump.IsInput(Pump,ent)
	if not IsValid(ent) then return false end
	if string.sub(ent:GetClass(),1,14) == "zgo2_watertank" then return true end
	return false
end

function zgo2.Pump.IsOutput(Pump,ent)
	if not IsValid(ent) then return false end
	if ent:GetClass() == "zgo2_pot" and zgo2.Pot.HasHoseConnection(ent) then return true end
	return false
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g