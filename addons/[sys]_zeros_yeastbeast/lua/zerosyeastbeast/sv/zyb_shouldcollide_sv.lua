-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.hooks = zyb.hooks or {}

// This disables the collision betweent he smaller entities
local zyb_Ents = {
	["zyb_fuel"] = true,
	["zyb_jar"] = true,
	["zyb_motor"] = true,
	["zyb_paperbag"] = true,
	["zyb_sugar"] = true,
	["zyb_water"] = true,
	["zyb_yeast"] = true,
}

hook.Add("ShouldCollide", "zyb.hooks.ShouldCollide", function(ent1, ent2)
	if (IsValid(ent1) and IsValid(ent2) and zyb_Ents[ent1:GetClass()] and zyb_Ents[ent2:GetClass()]) then return false end
end)
-- leak by lordee