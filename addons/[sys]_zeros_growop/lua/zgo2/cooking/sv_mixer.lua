--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Mixer = zgo2.Mixer or {}

/*

	Used for combining the ingredients for baking

*/

function zgo2.Mixer.Initialize(Mixer)
	zclib.EntityTracker.Add(Mixer)
	zgo2.Destruction.SetupHealth(Mixer)

	//Enable Bucket
	Mixer:SetBodygroup(0,1)
end

function zgo2.Mixer.OnTouch(Mixer,other)

	if not IsValid(Mixer) or not IsValid(other) then return end

	if other:GetClass() ~= "zgo2_mixerbowl" then return end

	if zclib.util.CollisionCooldown(other) then return end

	if Mixer:GetHasBowl() == false and other.IsMixed == false then
		zgo2.Mixer.AddBowl(Mixer,other)
	end
end

function zgo2.Mixer.USE(Mixer,ply)
	if Mixer:GetHasBowl() == false then return end
	if Mixer:GetWorkState() == 3 then return end

	if Mixer:GetHasDough() == false and Mixer:OnRemoveButton(ply) then
		zgo2.Mixer.RemoveBowl(Mixer)
	end
end

function zgo2.Mixer.AddBowl(Mixer,bowl)

	Mixer:SetHasBowl(true)
	Mixer:SetWorkState(2)

	local b_WID = bowl:GetWeedID()
	local b_WAmount = bowl:GetWeedAmount()
	local b_WeedTHC = bowl:GetWeedTHC()

	Mixer:SetWeedID(b_WID)
	Mixer:SetWeedAmount(b_WAmount)
	Mixer:SetWeedTHC(b_WeedTHC)

	Mixer:SetEdibleID(bowl:GetEdibleID())

	// Enable Bucket
	Mixer:SetBodygroup(0,1)

	if bowl:GetEdibleID() >= 1 then

		// Enable dough
		Mixer:SetBodygroup(1,1)

		Mixer:SetHasDough(true)

		// Enable weed
		if b_WID > 0 then
			Mixer:SetBodygroup(2,1)
		end

		timer.Simple(1,function()
			if IsValid(Mixer) then
				zgo2.Mixer.StartMixing(Mixer)
			end
		end)
	end

	zclib.Sound.EmitFromEntity("zgo2_mixerbowl_add", Mixer)

	SafeRemoveEntity(bowl)
end

function zgo2.Mixer.RemoveBowl(Mixer)
	Mixer:SetHasBowl(false)
	Mixer:SetHasDough(false)

	Mixer:SetWorkState(1)

	zclib.Sound.EmitFromEntity("zgo2_mixerbowl_remove", Mixer)

	timer.Simple(0.3,function()
		if IsValid(Mixer) then
			// Disable Bucket
			Mixer:SetBodygroup(0,0)

			// Disable Dough
			Mixer:SetBodygroup(1,0)

			// Disable Weed
			Mixer:SetBodygroup(2,0)

			local ent = ents.Create("zgo2_mixerbowl")
			ent:SetPos(Mixer:GetPos() + Mixer:GetUp() * 15 + Mixer:GetRight() * -35)
			ent:Spawn()
			ent:Activate()

			zclib.Player.SetOwner(ent, zclib.Player.GetOwner(Mixer))

			zclib.Sound.EmitFromEntity("zgo2_mixerbowl_add", ent)
		end
	end)
end

function zgo2.Mixer.StartMixing(Mixer)
	Mixer:SetWorkState(3)

	local mix_duration = zgo2.Edible.GetMixDuration(Mixer:GetEdibleID())

	 timer.Simple(mix_duration * 0.2,function()
		 if IsValid(Mixer) then
			 // Change Skin from flour to dough
		 	Mixer:SetSkin(1)
		 end
	 end)

	timer.Simple(mix_duration,function()
		if IsValid(Mixer) then
			zgo2.Mixer.FinishMixing(Mixer)
		end
	end)
end

function zgo2.Mixer.FinishMixing(Mixer)
	Mixer:SetWorkState(1)
	Mixer:SetHasBowl(false)
	Mixer:SetHasDough(false)

	// Disable Bucket
	Mixer:SetBodygroup(0,0)

	// Disable Dough
	Mixer:SetBodygroup(1,0)

	// Disable Weed
	Mixer:SetBodygroup(2,0)

	// Reset skin
	Mixer:SetSkin(0)

	local ent = ents.Create("zgo2_mixerbowl")
	ent:SetPos(Mixer:GetPos() + Mixer:GetUp() * 15 + Mixer:GetRight() * -35)
	ent:Spawn()
	ent:Activate()

	ent:SetEdibleID(Mixer:GetEdibleID())

	zclib.Player.SetOwner(ent, zclib.Player.GetOwner(Mixer))

	// Enable dough mesh
	ent:SetBodygroup(0,1)

	// Change to dough skin
	ent:SetSkin(1)

	ent.IsMixed = true

	local _weedid = Mixer:GetWeedID()
	if _weedid ~= -1 then
		ent:SetWeedID(_weedid)
		ent:SetWeedAmount(Mixer:GetWeedAmount())
		ent:SetWeedTHC(Mixer:GetWeedTHC())

		//Set Color of dough depending on weed id
		ent:SetColor(zgo2.Plant.GetColor(_weedid))
	end

	zgo2.Mixer.Reset(Mixer)
end

function zgo2.Mixer.Reset(Mixer)
	Mixer:SetEdibleID(0)
	Mixer:SetWeedID(-1)
	Mixer:SetWeedAmount(0)
	Mixer:SetWeedTHC(0)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher