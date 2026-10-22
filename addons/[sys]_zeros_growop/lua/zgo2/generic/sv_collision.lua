--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
/*
	Enables the use of the ShouldCollide Hook which prevents small entities like jars / weedbranches to collide.
	NOTE: This hook can cause all physics to break under certain conditions.
*/
if not zgo2.config.CollisionFix then return end

local IsWeedBranch = {["zgo2_weedbranch"] = true}
local WeedBranchCollider = {
	["zgo2_crate"] = true,
	["zgo2_clipper"] = true,
	["zgo2_dryline"] = true,
}

zclib.Hook.Add("ShouldCollide", "zgo2.Weedbranch.ShouldCollide", function(ent1, ent2)
	if IsValid(ent1) and IsValid(ent2) then

		// Make sure the player can still collide with it for physgun reasons
		if IsWeedBranch[ent1:GetClass()] and ent2:IsPlayer() then return true end

		// If the second entity is not in out WeedBranchCollider list then prevent any collision
		if IsWeedBranch[ent1:GetClass()] and not WeedBranchCollider[ent2:GetClass()] then return false end
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher