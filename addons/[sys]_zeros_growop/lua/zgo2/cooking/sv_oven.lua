--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Oven = zgo2.Oven or {}

/*

	Bakes the dough

*/

function zgo2.Oven.Initialize(Oven)
	zclib.EntityTracker.Add(Oven)
	zgo2.Destruction.SetupHealth(Oven)
	/*
	Oven:SetIsBaking(true)
	Oven:SetWeedID(math.random(#zgo2.config.Plants))
	Oven.WeedAmount = 25
	Oven.WeedTHC = 50
	local edibleID = math.random(#zgo2.config.Edibles)
	Oven:SetEdibleID(edibleID)
	Oven:SetSkin(1)

	timer.Simple(zgo2.Edible.GetBakeDuration(edibleID), function()
		if IsValid(Oven) then
			zgo2.Oven.FinishedBaking(Oven)
		end
	end)
	*/
end

function zgo2.Oven.OnTouch(Oven,other)

	if not IsValid(Oven) or not IsValid(other) then return end

	if other:GetClass() ~= "zgo2_mixerbowl" then return end

	if zclib.util.CollisionCooldown(other) then return end

	if not Oven:GetIsBaking() and other.IsMixed then

		// Add dough to oven and empty bowl
		zgo2.Oven.AddDough(Oven,other)
	end
end

function zgo2.Oven.AddDough(Oven,bowl)

	Oven:SetIsBaking(true)

	local _weedid = bowl:GetWeedID()
	if _weedid ~= -1 then
		Oven:SetWeedID(_weedid)
		Oven.WeedAmount = bowl:GetWeedAmount()
		Oven.WeedTHC = bowl:GetWeedTHC()
	end

	Oven:SetEdibleID(bowl:GetEdibleID())

	zgo2.MixerBowl.Reset(bowl)

	Oven:SetSkin(1)

	timer.Simple(zgo2.Edible.GetBakeDuration(Oven:GetEdibleID()),function()
		if IsValid(Oven) then
			zgo2.Oven.FinishedBaking(Oven)
		end
	end)
end

function zgo2.Oven.FinishedBaking(Oven)
	Oven:SetIsBaking(false)

	Oven:SetSkin(0)

	local edible_data = zgo2.Edible.GetData(Oven:GetEdibleID())

	local ent = ents.Create("zgo2_edible")
	ent:SetPos(Oven:GetPos() + Oven:GetUp() * 15 + Oven:GetRight() * -35)
	ent:Spawn()
	ent:SetModel(edible_data.edible_model)
	ent:Activate()

	zclib.Player.SetOwner(ent, zclib.Player.GetOwner(Oven))

	ent:SetEdibleID(Oven:GetEdibleID())

	if Oven:GetWeedID() > 0 then
		ent:SetWeedID(Oven:GetWeedID())
		ent:SetWeedAmount(math.Round(Oven.WeedAmount))
		ent:SetWeedTHC(math.Round(Oven.WeedTHC,2))

		ent:SetBodygroup(0,1)
	end

	Oven:SetEdibleID(0)
	Oven:SetWeedID(-1)
	Oven.WeedAmount = nil
	Oven.WeedTHC = nil
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher