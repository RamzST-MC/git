--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Multitool = zgo2.Multitool or {}
zgo2.Multitool.List = zgo2.Multitool.List or {}

/*

	Interaction:
		We could make 1 swep to let the player access / start all interactions
		Buy / Place entities from the shop
		Move Entities
		Plant seeds
		Water plants (Item shooter water balls?)
		Cut down plants
		Move branches to trying rack
		Cut buds from branches on some kind of table?
		Package weed from jars to blocks

*/

// We dont allow him to drop his multitool
zclib.Hook.Add("canDropWeapon", "MultitoolDrop", function(ply,swep)
    if IsValid(swep) and  swep:GetClass() == "zgo2_multitool" then
        return false
    end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher