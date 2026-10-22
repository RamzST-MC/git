-- leak by lordee-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Palette_Initzialize(palette)
	zyb.f.EntList_Add(palette)
end

function zyb.f.Palette_OnTouch(palette, other)
	if not IsValid(palette) then return end
	if not IsValid(other) then return end
	if other:GetClass() ~= "zyb_jarcrate" then return end
	if zyb.f.CollisionCooldown(other) then return end
	zyb.f.Palette_AddCrate(palette, other)
end

function zyb.f.Palette_AddCrate(palette, crate)
	if crate:GetJarCount() < 6 then return end
	if palette:GetCrateCount() >= zyb.config.Palette.Limit then return end
	palette:SetCrateCount(palette:GetCrateCount() + 1)
	SafeRemoveEntity(crate)
end
-- leak by lordee