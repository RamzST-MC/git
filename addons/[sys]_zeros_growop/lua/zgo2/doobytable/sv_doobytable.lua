--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.DoobyTable = zgo2.DoobyTable or {}

function zgo2.DoobyTable.Initialize(DoobyTable)
	DoobyTable:SetModel(DoobyTable.Model)
	DoobyTable:PhysicsInit(SOLID_VPHYSICS)
	DoobyTable:SetSolid(SOLID_VPHYSICS)
	DoobyTable:SetMoveType(MOVETYPE_VPHYSICS)
	DoobyTable:SetUseType(SIMPLE_USE)
	DoobyTable:UseClientSideAnimation()
	DoobyTable:PhysWake()

	zclib.EntityTracker.Add(DoobyTable)

	DoobyTable.Wait = false
end

function zgo2.DoobyTable.Touch(DoobyTable, other)
	if not IsValid(other) then return end
	if other:GetClass() ~= "zgo2_jar" and other:GetClass() ~= "zgo2_baggy" then return end
	if zclib.util.CollisionCooldown(other) then return end
	if DoobyTable:GetDoobyProgress() ~= 0 then return end
	if other:GetWeedAmount() <= 0 then return end
	if DoobyTable:GetWeedID() ~= -1 and other:GetWeedID() ~= DoobyTable:GetWeedID() then return end

	zgo2.DoobyTable.AddWeed(DoobyTable, other)
end

function zgo2.DoobyTable.USE(DoobyTable, ply)
	if DoobyTable.Wait then return end

	local progress = DoobyTable:GetDoobyProgress()

	if progress == 0 and DoobyTable:GetWeedAmount() >= zgo2.config.DoobyTable.WeedPerJoint then

		if DoobyTable:OnStartButton(ply) then
			zgo2.DoobyTable.PlaceWeed(DoobyTable)
		elseif DoobyTable:OnRemoveButton(ply) then
			zgo2.DoobyTable.RemoveWeed(DoobyTable)
		end

	elseif progress >= 1 and progress < 5 and DoobyTable:OnGrinder(ply) then
		zgo2.DoobyTable.GrindWeed(DoobyTable)
	elseif progress == 5 and DoobyTable:OnPaper(ply) then
		zgo2.DoobyTable.TakePaper(DoobyTable)
	elseif progress == 6 and DoobyTable:OnGrinder(ply) then
		zgo2.DoobyTable.PlaceWeedOnPaper(DoobyTable)
	elseif progress >= 7 and progress < 11 and DoobyTable:OnHitButton(ply) then
		zgo2.DoobyTable.MakeJoint(DoobyTable)
	end
end

function zgo2.DoobyTable.AddWeed(DoobyTable, weedjar)

	DoobyTable:SetWeedID(weedjar:GetWeedID())
	DoobyTable:SetWeedTHC(weedjar:GetWeedTHC())

	local WeedInJar = weedjar:GetWeedAmount()
	local m_Amount = zgo2.config.DoobyTable.Capacity - DoobyTable:GetWeedAmount()

	m_Amount = math.Clamp(m_Amount,0,WeedInJar)

	if m_Amount < WeedInJar then
		DoobyTable:SetWeedAmount(DoobyTable:GetWeedAmount() + m_Amount)
		weedjar:SetWeedAmount(WeedInJar - m_Amount)
	else
		DoobyTable:SetWeedAmount(DoobyTable:GetWeedAmount() + m_Amount)
		SafeRemoveEntity( weedjar )
	end
end

function zgo2.DoobyTable.RemoveWeed(DoobyTable)
	DoobyTable:SetWeedID(-1)
	DoobyTable:SetWeedAmount(0)
	DoobyTable:SetWeedTHC(0)
end

function zgo2.DoobyTable.PlaceWeed(DoobyTable)

	DoobyTable:SetWeedAmount(DoobyTable:GetWeedAmount() - zgo2.config.DoobyTable.WeedPerJoint)
	// 1123098134
	DoobyTable:SetDoobyProgress(1)
end

function zgo2.DoobyTable.GrindWeed(DoobyTable)
	DoobyTable.Wait = true

	timer.Simple(0.25,function()
		if IsValid(DoobyTable) then
			DoobyTable.Wait = false
		end
	end)

	DoobyTable:SetDoobyProgress(DoobyTable:GetDoobyProgress() + 1)
end

function zgo2.DoobyTable.TakePaper(DoobyTable)
	DoobyTable.Wait = true

	timer.Simple(0.55,function()
		if IsValid(DoobyTable) then
			DoobyTable.Wait = false
		end
	end)
	DoobyTable:SetDoobyProgress(6)
end

function zgo2.DoobyTable.PlaceWeedOnPaper(DoobyTable)
	DoobyTable.Wait = true

	timer.Simple(0.55,function()
		if IsValid(DoobyTable) then
			DoobyTable.Wait = false
		end
	end)

	DoobyTable:SetDoobyProgress(7)
	DoobyTable:SetGamePos(Vector(-8, 10, 5))
end

function zgo2.DoobyTable.MakeJoint(DoobyTable)
	DoobyTable.Wait = true

	DoobyTable:SetGamePos(Vector(-8, DoobyTable:GetGamePos().y - 5, 5))
	DoobyTable:SetDoobyProgress(DoobyTable:GetDoobyProgress() + 1)

	if DoobyTable:GetDoobyProgress() == 11 then

		timer.Simple(1.25, function()

			if IsValid(DoobyTable) then

				DoobyTable.Wait = false

				// Spawn Joint
				zgo2.DoobyTable.SpawnJoint(DoobyTable)
			end
		end)
	else

		timer.Simple(0.25, function()
			if IsValid(DoobyTable) then
				DoobyTable.Wait = false
			end
		end)
	end
end

function zgo2.DoobyTable.SpawnJoint(DoobyTable)
	local ent = ents.Create("zgo2_joint_ent")
	if not IsValid(ent) then return end
	ent:SetPos(DoobyTable:GetPos() + DoobyTable:GetUp() * 15)
	ent:Spawn()
	ent:Activate()

	ent:SetWeedID(DoobyTable:GetWeedID())
	ent:SetWeedTHC(DoobyTable:GetWeedTHC())
	ent:SetWeedAmount(zgo2.config.DoobyTable.WeedPerJoint)

	DoobyTable:SetDoobyProgress(0)

	if DoobyTable:GetWeedAmount() <= 0 then
		DoobyTable:SetWeedID(-1)
		DoobyTable:SetWeedAmount(0)
		DoobyTable:SetWeedTHC(0)
	end

	DoobyTable:SetGamePos(Vector(0,0,0))
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher