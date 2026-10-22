--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*

	This system saves all the weed Equipment to the map and marks it as a public grow setup
	NOTE Right now there are no owner checks i think so everyone can interact with each others entities anyway

*/
local SaveList = {
	[ "zgo2_clipper" ] = true,
	[ "zgo2_dryline" ] = true,
	[ "zgo2_generator" ] = true,
	[ "zgo2_lamp" ] = true,
	[ "zgo2_pot" ] = true,
	[ "zgo2_pump" ] = true,
	[ "zgo2_rack" ] = true,
	[ "zgo2_tent" ] = true,
	[ "zgo2_watertank" ] = true,
	[ "zgo2_packer" ] = true,

	[ "zgo2_soil" ] = true,
	[ "zgo2_crate" ] = true,
}

file.CreateDir("zgo2")

local function FindEntityByID(id, tbl)
	local ent

	for k, v in pairs(tbl) do
		if v.EntID == id then
			ent = v
			break
		end
	end

	return ent
end

zclib.STM.Setup("zgo2_growsetup", "zgo2/" .. string.lower(game.GetMap()) .. "_growsetups.txt", function()
	local data = {}

	for k, v in pairs(ents.GetAll()) do
		if not IsValid(v) then continue end
		local class = v:GetClass()
		if not SaveList[class] then continue end

		local dat = {
			class = v:GetClass(),
			pos = v:GetPos(),
			ang = v:GetAngles(),
			id = v:EntIndex()
		}

		if class == "zgo2_dryline" then
			dat.EndPoint = v:GetEndPoint()
			dat.WallAngle = v:GetWallAngle()
			dat.WallEndAngle = v:GetWallEndAngle()
		end

		if class == "zgo2_generator" then
			dat.GeneratorID = zgo2.Generator.GetID(v:GetGeneratorID())

			dat.OutputIDs = {}
			for a,b in pairs(v.ConnectedEntities) do
				table.insert(dat.OutputIDs,a:EntIndex())
			end
		end

		if class == "zgo2_lamp" then
			dat.LampID = zgo2.Lamp.GetID(v:GetLampID())
			dat.LampColor = v:GetLampColor()
		end

		if class == "zgo2_pot" then
			dat.PotID = zgo2.Pot.GetID(v:GetPotID())
			dat.SpotID = v.SpotID
			if IsValid(v:GetParent()) then
				dat.ParentID = v:GetParent():EntIndex()
			end
		end

		if class == "zgo2_rack" then
			dat.RackID = zgo2.Rack.GetID(v:GetRackID())
		end

		if class == "zgo2_tent" then
			dat.TentID = zgo2.Tent.GetID(v:GetTentID())
		end

		if class == "zgo2_watertank" then
			dat.WatertankID = zgo2.Watertank.GetID(v:GetWatertankID())
		end

		if class == "zgo2_pump" then
			if IsValid(v.InputEntity) then
				dat.inputid = v.InputEntity:EntIndex()
			end
			dat.OutputIDs = {}
			for a,b in pairs(v.OutputEntities) do
				table.insert(dat.OutputIDs,a:EntIndex())
			end
		end

		table.insert(data, dat)
	end

	return data
end, function(data)

	local CreatedEnts = {}

	for k, v in pairs(data) do

		local class = v.class

		local ent = ents.Create(class)
		if not IsValid(ent) then continue end
		ent:SetPos(v.pos)
		ent:SetAngles(v.ang)

		table.insert(CreatedEnts,ent)

		ent.EntID = v.id

		if class == "zgo2_dryline" then
			ent:SetEndPoint(v.EndPoint)
			ent:SetWallAngle(v.WallAngle)
			ent:SetWallEndAngle(v.WallEndAngle)
		end

		if class == "zgo2_generator" then
			ent:SetGeneratorID(zgo2.Watertank.GetListID(v.GeneratorID))

			ent.OutputIDs = {}
			for a,b in pairs(v.OutputIDs) do
				ent.OutputIDs[b] = true
			end
		end

		if class == "zgo2_lamp" then
			ent:SetLampID(zgo2.Lamp.GetListID(v.LampID))
			ent:SetLampColor(v.LampColor)

			ent.temp_LampColor = v.LampColor
		end

		if class == "zgo2_pot" then
			ent:SetPotID(zgo2.Pot.GetListID(v.PotID))

			ent.SpotID = v.SpotID
			ent.ParentID = v.ParentID
		end

		if class == "zgo2_rack" then
			ent:SetRackID(zgo2.Rack.GetListID(v.RackID))
		end

		if class == "zgo2_tent" then
			ent:SetTentID(zgo2.Tent.GetListID(v.TentID))
		end

		if class == "zgo2_watertank" then
			ent:SetWatertankID(zgo2.Watertank.GetListID(v.WatertankID))
		end

		if class == "zgo2_pump" then
			ent.inputid = v.inputid

			ent.OutputIDs = {}
			for a,b in pairs(v.OutputIDs) do
				ent.OutputIDs[b] = true
			end
		end

		ent:Spawn()
		ent:Activate()

		if class == "zgo2_dryline" then
			timer.Simple(1,function()
				if not IsValid(ent) then return end
				zgo2.Dryline.SetEndPoint(ent,false,v.WallEndAngle,v.EndPoint)
			end)
		end
	end

	for k, ent in pairs(CreatedEnts) do

		local class = ent:GetClass()

		if class == "zgo2_pot" then
			if ent.ParentID and ent.SpotID then

				local parent = FindEntityByID(ent.ParentID, CreatedEnts)
				if IsValid(parent) then

					if parent:GetClass() == "zgo2_rack" then
						zgo2.Rack.AddPot(parent, ent, ent.SpotID)
					elseif parent:GetClass() == "zgo2_tent" then
						zgo2.Tent.AddPot(parent, ent, ent.SpotID)
					end
				end
			end

			// NOTE This only exists for getting a quick setup for screenshots
			zgo2.Pot.AddSoil(ent)
			zgo2.Pot.AddWater(ent, 1000)
			zgo2.Pot.AddSeed(ent,zgo2.Plant.GetRandomID())
			//zgo2.Pot.AddSeed(ent, 6)
			zgo2.Plant.SetHarvestReady(ent:GetPlant())

		end

		if class == "zgo2_pump" then
			if ent.inputid then
				zgo2.Pump.ConnectInput(ent,FindEntityByID(ent.inputid, CreatedEnts))
			end

			for a,b in pairs(ent.OutputIDs) do
				zgo2.Pump.ConnectOutput(ent,FindEntityByID(a, CreatedEnts))
			end
		end

		if class == "zgo2_lamp" then
			zgo2.Lamp.AddPower(ent, zgo2.config.Battery.Power)

			timer.Simple(1, function()
				if not IsValid(ent) then return end
				ent:SetLampColor(ent.temp_LampColor)
			end)
		end

		if class == "zgo2_generator" then
			zgo2.Generator.AddFuel(ent, zgo2.Generator.GetFuelCapacity(ent))

			for a, b in pairs(ent.OutputIDs) do
				zgo2.Generator.Connect(ent, FindEntityByID(a, CreatedEnts))
			end
		end
	end

	zgo2.Print("Finished loading Grow Setups!")
end, function()
	for k, v in pairs(ents.GetAll()) do
		if not IsValid(v) then continue end
		if not SaveList[ v:GetClass() ] then continue end
		v:Remove()
	end
end)

concommand.Add("zgo2_public_save", function(ply, cmd, args)
	if zclib.Player.IsAdmin(ply) then
		zclib.STM.Save("zgo2_growsetup")
		zclib.Notify(ply, "Grow Setup saved for " .. string.lower(game.GetMap()) .. "!", 0)
	end
end)

concommand.Add("zgo2_public_remove", function(ply, cmd, args)
	if zclib.Player.IsAdmin(ply) then
		zclib.STM.Remove("zgo2_growsetup")
		zclib.Notify(ply, "Removed all Grow Setups for " .. string.lower(game.GetMap()) .. "!", 0)
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher