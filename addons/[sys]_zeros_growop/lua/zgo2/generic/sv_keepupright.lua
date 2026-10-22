--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
if CLIENT then return end

/*
	Makes the entity up right once dropped
*/

local list = {
	[ "zgo2_crate" ] = true,
	[ "zgo2_jarcrate" ] = true,
	[ "zgo2_lamp" ] = true,
	[ "zgo2_rack" ] = true,

	[ "zgo2_palette" ] = true,
	[ "zgo2_clipper" ] = true,
	[ "zgo2_packer" ] = true,
}

zclib.Hook.Add("GravGunOnDropped", "zgo2_entityaligment", function(ply, ent)
	if IsValid(ent) and list[ ent:GetClass() ] then
		local ang = ply:GetAngles()
		ang:RotateAroundAxis(ply:GetUp(), 180)
		ent:SetAngles(Angle(0, ang.y, 0))
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher