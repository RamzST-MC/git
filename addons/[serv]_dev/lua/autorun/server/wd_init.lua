include("../wd_config.lua")

util.AddNetworkString("start_wd_hack")
util.AddNetworkString("stop_wd_hack")
util.AddNetworkString("start_wd_emp")
util.AddNetworkString("start_wd_cooldown")

util.AddNetworkString("wd_camera_hack")
util.AddNetworkString("wd_exit_camera")

util.AddNetworkString("wd_cl_hackrange")

local Cooldown = wd_Config["HackCooldown"]
//local hackRange = wd_Config["HackRange"]

local entsTable = { "wd_signal_amplifier", "wd_power_booster" } 
cameraHackers = {}

--

local cd_old = Cooldown
function wd_nocooldown( ply, cmd, args )

	if not ply:IsAdmin() then return end

    if args[1] == "1" then
    	ply.wd_cd = false
    	ply:ChatPrint("You have disabled cooldowns.")
    elseif args[1] == "0" then
    	ply.wd_cd = true
    	ply:ChatPrint("You have enabled cooldowns.")
    end

end
concommand.Add( "wd_nocooldown", wd_nocooldown )

function wd_hackrange( ply, cmd, args )

	if tonumber( args[1] ) == nil then return end

	if ply:IsAdmin() then
		ply.wdHackRange = tonumber(args[1])
		net.Start("wd_cl_hackrange")
			net.WriteInt( tonumber(args[1]), 32 )
		net.Send( ply )
		ply:ChatPrint("You have changed the hack range to " .. args[1] .. ".")
	end

end
concommand.Add( "wd_hackrange", wd_hackrange )

--

local function VehicleHack( ent )
	local vPoint = ent:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("cball_explode", effectdata)

	ent:Fire("TurnOff", 1, 0)
	ent:EmitSound("vehicles/airboat/fan_motor_shut_off1.wav", 100, 100)
	// or "vehicles/v8/v8_stop1.wav"

	if timer.Exists("VehicleDisable" .. ent:EntIndex()) then
		timer.Destroy("VehicleDisable" .. ent:EntIndex())
	end

	timer.Create("VehicleDisable" .. ent:EntIndex(), 5, 1,function()
		if ent:IsValid() then
			ent:Fire("TurnOn", 1, 0)
		end
	end)
end

local function HackerHack( ent)

	if not ent:IsPlayer() then return end

	local vPoint = ent:GetPos() + Vector(0, 0, 30)
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("cball_explode", effectdata)

	ent:EmitSound("buttons/button18.wav", 100, 100)

	if ent.wdHackCooldown < wd_Config["HackCooldown"] then
		net.Start("start_wd_cooldown")
			net.WriteInt(Cooldown, 32)
		net.Send( ent )
		ent.wdHackCooldown = CurTime() + Cooldown
	end
end

--

local function GetHackable( range, ply )

	local entsTable = {}

	for k, v in pairs(ents.GetAll()) do
		if table.HasValue(wdEntList, v:GetClass()) or v:IsVehicle() then
			//maybe use DistToSqr() in future
			if v:GetPos():Distance( ply:GetPos() ) < range then
				table.insert(entsTable, v)
			end
		end
	end

	return entsTable

end

local function IsHackable( ply, range, ent )

	local entsTable = {}

	if ent:IsVehicle() then
	
		for k, v in pairs( ents.GetAll() ) do
			if v:IsVehicle() then
				if v:EntIndex() == ent:EntIndex() then
					if ent:GetPos():Distance( ply:GetPos() ) < range then
						return true
					end
				end
			end
		end

	else

		for k, v in pairs(ents.FindByClass(ent:GetClass())) do
			if v:EntIndex() == ent:EntIndex() then
				if ent:GetPos():Distance( ply:GetPos() ) < range then
					return true
				end
			end
		end

	end

	return false

end

--

net.Receive("start_wd_hack", function( len, ply )
	local ent = net.ReadEntity()

	if ply:InVehicle() then
		return false
	end

	if ply:GetPos():Distance(ent:GetPos()) > wd_Config["HackRange"] then
		return false
	end

	if ply:GetActiveWeapon():IsValid() then
		if ply:GetActiveWeapon():GetClass() != "weapon_hack_phone" then
			return
		end
	end

	if ply.wdHackCooldown == nil then ply.wdHackCooldown = CurTime() end

	if ply.wd_cd == nil then ply.wd_cd = true end

	if CurTime() < ply.wdHackCooldown then return end

	local cd = Cooldown
	local hackRange = ply.wdHackRange or wd_Config["HackRange"]

	if ent:IsValid() then
		if IsHackable( ply, hackRange, ent ) and (table.HasValue( wdEntList, ent:GetClass() ) or ent:IsVehicle())  then
			if timer.Exists("WDHack" .. ent:EntIndex()) then
				ply:ChatPrint("Already being hacked!")
			else
				timer.Create("WDHack" .. ent:EntIndex(), wd_Config["Time"], 1, function()

					-- Add any exceptions here to hackable ents, such as vehicles. Otherwide leave it to the wdEntInfo table.
					if ent:IsVehicle() then 
						VehicleHack( ent )
					elseif not ent:IsPlayer() then
						wdEntInfo[ent:GetClass()]( ent, ply )
					else
						if ent:GetActiveWeapon():IsValid() then
							if ent:GetActiveWeapon():GetClass() == "weapon_hack_phone" then
								HackerHack( ent )  
							else
								wdEntInfo[ent:GetClass()]( ent, ply )		
							end
						end
					end

					if ply.wd_cd == false then return end

					net.Start("start_wd_cooldown")
						net.WriteInt(cd, 32)
					net.Send( ply )
					ply.wdHackCooldown = CurTime() + cd

				end)
			end
		end
	end
end)

net.Receive("stop_wd_hack", function( len, ply )
	local ent = net.ReadEntity()

	if timer.Exists("WDHack" .. ent:EntIndex()) then
		timer.Destroy("WDHack" .. ent:EntIndex())
	end
end)

net.Receive("start_wd_emp", function( len, ply )
	if ply.wdHackCooldown == nil then ply.wdHackCooldown = CurTime() end

	if CurTime() < ply.wdHackCooldown then return end

	if ply.wd_cd == nil then ply.wd_cd = true end

	local cd = wd_Config["EmpCooldown"]
	local hackRange = wd_Config["HackRange"]

	for k, v in pairs(ents.FindInSphere(ply:GetPos(), 200)) do
		if table.HasValue(entsTable, v:GetClass()) then
			if v:GetClass() == "wd_signal_amplifier" then
				hackRange = hackRange * 3 -- Multiplier for range increase (needs to be changed on client aswell)
			elseif v:GetClass() == "wd_power_booster" then
				cd = math.Round(cd/1.5)
			end
		end
	end

	timer.Simple( 0.5, function()

	local hackEnts = GetHackable( hackRange, ply )

	for k, v in pairs( hackEnts ) do
		if v:IsVehicle() then 
			VehicleHack( v )
		elseif v:GetClass() != "gmod_cameraprop" and not v:IsPlayer() then
			if v:IsValid() then
				wdEntInfo[v:GetClass()]( v, ply )
			end
		end
	end

	ply:EmitSound("vehicles/junker/radar_ping_friendly1.wav", 100, 100)

	if ply.wd_cd == true then

		net.Start("start_wd_cooldown")
			net.WriteInt(cd, 32)
		net.Send( ply )
		ply.wdHackCooldown = CurTime() + cd

		end

	end)

end)

net.Receive("wd_exit_camera", function( len, ply )

	for k, v in pairs( cameraHackers ) do
		if ply == v[1] then
			v[2].wd_Hacker = nil
			table.remove( cameraHackers, k )
			return
		end
	end

	ply:SetMoveType( MOVETYPE_WALK )

end)

local function CameraThink()

	for k, v in pairs( cameraHackers ) do

		if v[1]:IsValid() and v[2]:IsValid() then

		if v[1]:KeyDown( IN_FORWARD ) then
			v[2]:SetAngles( v[2]:GetAngles() - Angle(0.5, 0, 0) )
		end
		if v[1]:KeyDown( IN_BACK ) then
			v[2]:SetAngles( v[2]:GetAngles() + Angle(0.5, 0, 0) )
		end
		if v[1]:KeyDown( IN_MOVELEFT ) then
			v[2]:SetAngles( v[2]:GetAngles() + Angle(0, 0.5, 0) )
		end
		if v[1]:KeyDown( IN_MOVERIGHT ) then
			v[2]:SetAngles( v[2]:GetAngles() - Angle(0, 0.5, 0) )
		end

		else

			for i, p in pairs( cameraHackers ) do
				if v[1] == p[1] then
					v[2].wd_Hacker = nil
					v[1]:SetMoveType( MOVETYPE_WALK )
					table.remove( cameraHackers, i )
					return
				end
			end

		end
	end

end
hook.Add("Think", "wd_CameraThink", CameraThink)