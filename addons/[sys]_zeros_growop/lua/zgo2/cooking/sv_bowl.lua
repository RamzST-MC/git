--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.MixerBowl = zgo2.MixerBowl or {}

/*

	Just to combine the ingredients for baking

*/

function zgo2.MixerBowl.Initialize(MixerBowl)
	zclib.EntityTracker.Add(MixerBowl)
	zgo2.Destruction.SetupHealth(MixerBowl)
	MixerBowl.IsMixed = false
end

function zgo2.MixerBowl.OnTouch(MixerBowl,other)

	if not IsValid(MixerBowl) or not IsValid(other) then return end

	if other:GetClass()  ~= "zgo2_backmix" and other:GetClass() ~= "zgo2_jar" then return end

	if MixerBowl.IsMixed == true then return end

	if zclib.util.CollisionCooldown(other) then return end

	if other:GetClass() == "zgo2_backmix" and MixerBowl:GetEdibleID() <= 0 then
		zgo2.MixerBowl.AddBackMix(MixerBowl,other)
	elseif other:GetClass() == "zgo2_jar" and other:GetWeedAmount() > 0 and MixerBowl:GetEdibleID() >= 1 then
		zgo2.MixerBowl.AddWeed(MixerBowl,other)
	end
end

function zgo2.MixerBowl.AddBackMix(MixerBowl,BackMix)

	if zclib.Entity.GettingRemoved(BackMix) then return end

	MixerBowl:SetEdibleID(BackMix.EdibleID)

	MixerBowl:SetBodygroup(0,1)

	zclib.Entity.SafeRemove(BackMix)

	zclib.Sound.EmitFromEntity("zgo2_cooking_flour", MixerBowl)
end

function zgo2.MixerBowl.AddWeed(MixerBowl,weedjar)

	local mixerbowl_amount = MixerBowl:GetWeedAmount()

	local weed_capacity = zgo2.Edible.GetWeedCapacity(MixerBowl:GetEdibleID())

	if mixerbowl_amount >= weed_capacity then return end

	// Check if weed ids are matching
	if MixerBowl:GetWeedID() > 0 and MixerBowl:GetWeedID() ~= weedjar:GetWeedID() then return end

	// Set WeedID
	local _weedid = weedjar:GetWeedID()
	MixerBowl:SetWeedID(_weedid)

	// Set WeedTHC
	if MixerBowl:GetWeedTHC() <= 0 then
		MixerBowl:SetWeedTHC(weedjar:GetWeedTHC())
	else
		MixerBowl:SetWeedTHC((MixerBowl:GetWeedTHC() + weedjar:GetWeedTHC()) / 2)
	end


	local moveamount = weed_capacity

	// Make sure the moveamount gets clamped to the free space available in the mixerbowl_amount
	moveamount = math.Clamp(moveamount,0,weed_capacity - mixerbowl_amount)

	local weedjar_amount = weedjar:GetWeedAmount()

	// If the weedamout in the jar is less then the moveamount then we use the weedjar_amount and remove the jar entity
	if weedjar_amount < moveamount then
		moveamount = weedjar_amount
		SafeRemoveEntity(weedjar)
	else
		weedjar:SetWeedAmount(weedjar_amount - moveamount)
	end

	MixerBowl:SetWeedAmount(mixerbowl_amount + moveamount)

	mixerbowl_amount = MixerBowl:GetWeedAmount()

	MixerBowl:SetBodygroup(1,1)

	zclib.Sound.EmitFromEntity("zgo2_grab_weed", MixerBowl)
end

function zgo2.MixerBowl.Reset(MixerBowl)
	MixerBowl:SetEdibleID(0)
	MixerBowl.IsMixed = false
	MixerBowl:SetWeedID(-1)
	MixerBowl:SetWeedAmount(0)
	MixerBowl:SetWeedTHC(0)
	MixerBowl:SetBodygroup(0,0)
	MixerBowl:SetBodygroup(1,0)
	MixerBowl:SetColor(color_white)
	MixerBowl:SetSkin(0)

	zclib.Sound.EmitFromEntity("zgo2_cooking_dough", MixerBowl)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher