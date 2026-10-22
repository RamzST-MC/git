--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Multitool = zgo2.Multitool or {}

function zgo2.Multitool.SecondaryAttack(Multitool)
	if LocalPlayer().zgo2_LockSwep and LocalPlayer().zgo2_LockSwep > CurTime() then return end

	zgo2.Multitool.OpenMenu(nil, zgo2.Shop.List)
end

function zgo2.Multitool.Holster(Multitool)
	if not IsFirstTimePredicted() then return end
	zclib.PointerSystem.Stop()
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher