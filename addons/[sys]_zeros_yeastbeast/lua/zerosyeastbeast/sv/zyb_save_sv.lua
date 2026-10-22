-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.PublicSetup = zyb.PublicSetup or {}

/*

	A system for saving a whole distillery for the map

*/


function zyb.PublicSetup.Save(ply)
	local data = {}

	for u, j in pairs(ents.FindByClass("zyb_distillery")) do
		if not IsValid(j) then continue end

		local package = {
			main = {pos = j:GetPos(),ang = j:GetAngles()},
		}

		local cooler = j:GetCooler()
		if IsValid(cooler) then
			package.cooler = {pos = cooler:GetPos(),ang = cooler:GetAngles()}
		end

		local condenser = j:GetCondenser()
		if IsValid(condenser) then
			package.condenser = {pos = condenser:GetPos(),ang = condenser:GetAngles()}
		end


		table.insert(data, package)
	end

	for u, j in pairs(ents.FindByClass("zyb_yeastgrinder")) do
		if not IsValid(j) then continue end

		local package = {
			grinder = {pos = j:GetPos(),ang = j:GetAngles(),HasMotor = IsValid(j.Motor)},
		}

		table.insert(data, package)
	end

	if data then

		if not file.Exists("zyb", "DATA") then
			file.CreateDir("zyb")
		end

		file.Write("zyb/" .. string.lower(game.GetMap()) .. "_publicsetup" .. ".txt", util.TableToJSON(data))

		zyb.f.Notify(ply, "Public setup has been saved for the map " .. game.GetMap() .. "!", 0)
	end
end

function zyb.PublicSetup.Load()
	if file.Exists("zyb/" .. string.lower(game.GetMap()) .. "_publicsetup" .. ".txt", "DATA") then
		local data = file.Read("zyb/" .. string.lower(game.GetMap()) .. "_publicsetup" .. ".txt", "DATA")
		data = util.JSONToTable(data)

		if data and table.Count(data) > 0 then

			local function CreateEntity(class,pos,ang)
				local ent = ents.Create(class)
				ent:SetPos(pos)
				ent:SetAngles(ang)
				ent:Spawn()
				ent:Activate()

				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
					phys:EnableMotion(false)
				end

				ent.zyb_IsPublicEntity = true

				return ent
			end

			for k, v in pairs(data) do

				if v.main then
					local distillery = CreateEntity("zyb_distillery",v.main.pos,v.main.ang)

					local cooler
					if v.cooler then
						cooler = CreateEntity("zyb_distillery_cooler",v.cooler.pos,v.cooler.ang)
						distillery:DeleteOnRemove(cooler)
						constraint.Axis(distillery, cooler, 0, 0, distillery:WorldToLocal(distillery:GetPos() + distillery:GetUp() * 147), distillery:GetPos() + distillery:GetUp() * 150,0,0,0,1, distillery:GetUp(), false )
						cooler.Distillery = distillery
						zyb.f.Distillery_AddCooler(distillery,cooler)
					end

					if IsValid(cooler) and v.condenser then
						local condenser = CreateEntity("zyb_distillery_condenser",v.condenser.pos,v.condenser.ang)
						distillery:DeleteOnRemove(condenser)
						constraint.Axis(cooler, condenser, 0, 0, cooler:WorldToLocal(cooler:GetPos() + cooler:GetUp() * 147  - cooler:GetRight() * 5), cooler:WorldToLocal(cooler:GetPos() + cooler:GetUp() * 150  - cooler:GetRight() * 5),0,0,0,1, cooler:GetUp(), false )
						condenser.Distillery = distillery
						zyb.f.Distillery_AddCondenser(distillery,condenser)
					end
				end

				if v.grinder then
					local grinder = CreateEntity("zyb_yeastgrinder",v.grinder.pos,v.grinder.ang)

					if v.grinder.HasMotor then
						local motor = CreateEntity("zyb_motor", v.grinder.pos + Vector(0, 0, 100), v.grinder.ang)
						zyb.f.Grinder_AddMotor(grinder, motor)
					end
				end
			end

			print("[Zeros YeastBeast] Finished loading Public Setup.")
		end
	end
end


function zyb.PublicSetup.Remove(ply)
	for u, j in pairs(ents.FindByClass("zyb_distillery")) do
		if IsValid(j) and j.zyb_IsPublicEntity == true then
			SafeRemoveEntity(j)
		end
	end

	for u, j in pairs(ents.FindByClass("zyb_yeastgrinder")) do
		if IsValid(j) and j.zyb_IsPublicEntity == true then
			SafeRemoveEntity(j)
		end
	end

	if file.Exists("zyb/" .. string.lower(game.GetMap()) .. "_publicsetup" .. ".txt", "DATA") then
		file.Delete("zyb/" .. string.lower(game.GetMap()) .. "_publicsetup" .. ".txt", "DATA")
	end

	zyb.f.Notify(ply, "Public setup has been removed for the map " .. game.GetMap() .. "!", 0)
end

timer.Simple(0,function()
	zyb.PublicSetup.Load()
end)
hook.Add("PostCleanupMap", "zyb_SpawnPublicSetupPostCleanUp", zyb.PublicSetup.Load)



concommand.Add("zyb_public_save", function(ply, cmd, args)
	if zyb.f.IsAdmin(ply) then
		zyb.PublicSetup.Save(ply)
	end
end)

concommand.Add("zyb_public_remove", function(ply, cmd, args)
	if zyb.f.IsAdmin(ply) then
		zyb.PublicSetup.Remove(ply)
	end
end)
-- leak by lordee