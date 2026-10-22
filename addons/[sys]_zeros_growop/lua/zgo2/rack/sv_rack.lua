--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Rack = zgo2.Rack or {}
zgo2.Rack.List = zgo2.Rack.List or {}

/*

	Players can place pots on the rack, just so the pots just stand randomly in a room. Idk looks better

*/

function zgo2.Rack.Initialize(Rack)
	local dat = zgo2.Rack.GetData(Rack:GetRackID())

	Rack:SetModel(dat.mdl)
	Rack:PhysicsInit(SOLID_VPHYSICS)
	Rack:SetSolid(SOLID_VPHYSICS)
	Rack:SetMoveType(MOVETYPE_VPHYSICS)
	Rack:SetUseType(SIMPLE_USE)
	local phy = Rack:GetPhysicsObject()
	if IsValid(phy) then
		phy:Wake()
		phy:EnableMotion(false)
	end

	zclib.EntityTracker.Add(Rack)

	zgo2.Rack.List[Rack] = true

	zgo2.Destruction.SetupHealth(Rack)
end

/*
	Called when something touches the entity
*/
function zgo2.Rack.OnTouch(Rack,other)
	if not IsValid(Rack) then return end
    if not IsValid(other) then return end
	if zclib.util.CollisionCooldown(other) then return end

	if other:GetClass() == "zgo2_pot" then
		timer.Simple(0.1,function()
			if not IsValid(Rack) then return end
			if not IsValid(other) then return end
			zgo2.Rack.AddPot(Rack,other)
		end)
	end
end

/*
	Returns the first free spot it finds
*/
function zgo2.Rack.GetPotSpot(Rack)
	if Rack.Pots == nil then Rack.Pots = {} end
	local found
	local dat = zgo2.Rack.GetData(Rack:GetRackID())
	for id,_ in pairs(dat.PotPositions) do
		if not IsValid(Rack.Pots[id]) then
			found = id
			break
		end
	end
	return found
end

/*
	Adds a pot to the rack
*/
function zgo2.Rack.AddPot(Rack,Pot,spot)
	if Rack.Pots == nil then Rack.Pots = {} end

	if not spot then
		spot = zgo2.Rack.GetPotSpot(Rack)
	end
	if not spot then return end

	DropEntityIfHeld(Pot)

	Rack.Pots[spot] = Pot

	local dat = zgo2.Rack.GetData(Rack:GetRackID())

	Pot:SetPos(Rack:LocalToWorld(dat.PotPositions[ spot ][ 1 ]))
	Pot:SetAngles(Rack:LocalToWorldAngles(dat.PotPositions[ spot ][ 2 ]))
	Pot:SetParent(Rack)

	Pot.SpotID = spot

	Pot:EmitSound("physics/plaster/ceiling_tile_step1.wav")
end
--ds - matveicher
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher