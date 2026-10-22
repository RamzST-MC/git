-- leak by lordee
zyb = zyb or {}
zyb.f = zyb.f or {}

if SERVER then
	function zyb.f.Notify(ply, msg, ntfType)
		if not IsValid(ply) then return end
		if DarkRP and DarkRP.notify then
			DarkRP.notify(ply, ntfType, 8, msg)
		else
			ply:ChatPrint(msg)
		end
	end

	// Used to fix the Duplication Glitch
	function zyb.f.CollisionCooldown(ent)
		if ent.zyb_CollisionCooldown == nil then
			ent.zyb_CollisionCooldown = true

			timer.Simple(0.1,function()
				if IsValid(ent) then
					ent.zyb_CollisionCooldown = false
				end
			end)

			return false
		else
			if ent.zyb_CollisionCooldown then
				return true
			else
				ent.zyb_CollisionCooldown = true

				timer.Simple(0.1,function()
					if IsValid(ent) then
						ent.zyb_CollisionCooldown = false
					end
				end)
				return false
			end
		end
	end
else
	function zyb.f.LoopedSound(ent, soundfile, shouldplay)
		if shouldplay and zyb.f.InDistance(LocalPlayer():GetPos(), ent:GetPos(), 500) then

			if ent.Sounds == nil then
				ent.Sounds = {}
			end

			if ent.Sounds[soundfile] == nil then
				ent.Sounds[soundfile] = CreateSound(ent, soundfile)
			end

			if ent.Sounds[soundfile]:IsPlaying() == false then
				ent.Sounds[soundfile]:Play()
				ent.Sounds[soundfile]:ChangeVolume(1, 0)
			end
		else
			if ent.Sounds == nil then
				ent.Sounds = {}
			end

			if ent.Sounds[soundfile] ~= nil and ent.Sounds[soundfile]:IsPlaying() == true then
				ent.Sounds[soundfile]:ChangeVolume(0, 0)
				ent.Sounds[soundfile]:Stop()
				ent.Sounds[soundfile] = nil
			end
		end
	end

	function zyb.f.LerpColor(t, c1, c2)
		local c3 = Color(0, 0, 0)
		c3.r = Lerp(t, c1.r, c2.r)
		c3.g = Lerp(t, c1.g, c2.g)
		c3.b = Lerp(t, c1.b, c2.b)
		c3.a = Lerp(t, c1.a, c2.a)

		return c3
	end
end

function zyb.f.InDistance(pos01, pos02, dist)
	return pos01:DistToSqr(pos02) < (dist * dist)
end

function zyb.f.RandomChance(chance)
	if math.random(0, 100) < chance then
		return true
	else
		return false
	end
end

// Tells us if the function is valid
function zyb.f.FunctionValidater(func)
	if (type(func) == "function") then return true end
	// 416932157
	return false
end

// Used to concat the keys of a table
function zyb.f.KeyTableConcat(_tbl, concator)
	local str = ""

	local count = 1
	for k, v in pairs(_tbl) do
		str = str .. tostring(k)
		if count < table.Count(_tbl) then
			str = str .. concator
		end
		count = count + 1
	end

	return str
end




////////////////////////////////////////////
///////////////// Timer ////////////////////
////////////////////////////////////////////
concommand.Add("zyb_debug_Timer_PrintAll", function(ply, cmd, args)
	if zyb.f.IsAdmin(ply) then
		zyb.f.Timer_PrintAll()
	end
end)

if zyb_TimerList == nil then
	zyb_TimerList = {}
end

function zyb.f.Timer_PrintAll()
	PrintTable(zyb_TimerList)
end

function zyb.f.Timer_Create(timerid, time, rep, func)

	zyb.f.Timer_Remove(timerid)

	if zyb.f.FunctionValidater(func) then
		timer.Create(timerid, time, rep, func)
		table.insert(zyb_TimerList, timerid)
		zyb.f.Debug("Timer Created: " .. timerid)
	end
end

function zyb.f.Timer_Remove(timerid)
	if timer.Exists(timerid) then
		timer.Remove(timerid)
		table.RemoveByValue(zyb_TimerList, timerid)
		zyb.f.Debug("Timer Removed: " .. timerid)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////






////////////////////////////////////////////
///////////////// OWNER ////////////////////
////////////////////////////////////////////
if SERVER then
	// This saves the owners SteamID
	function zyb.f.SetOwnerByID(ent, id)
		ent:SetNWString("zyb_Owner", id)
	end

	// This saves the owners SteamID
	function zyb.f.SetOwner(ent, ply)
		if IsValid(ply) then
			ent:SetNWString("zyb_Owner", ply:SteamID())

			if CPPI then
				ent:CPPISetOwner(ply)
			end
		else
			ent:SetNWString("zyb_Owner", "world")
		end
	end
end

// This returns the entites owner SteamID
function zyb.f.GetOwnerID(ent)
	return ent:GetNWString("zyb_Owner", "nil")
end

// This returns the owner
function zyb.f.GetOwner(ent)
	if (IsValid(ent)) then
		local id = ent:GetNWString("zyb_Owner", "nil")
		local ply = player.GetBySteamID(id)

		if IsValid(ply) then
			return ply
		else
			return false
		end
	else
		return false
	end
end

// This returns true if the input is the owner
function zyb.f.IsOwner(ply, ent)
	if IsValid(ent) then
		local id = ent:GetNWString("zyb_Owner", "nil")
		local ply_id = ply:SteamID()

		if (IsValid(ply) and id == ply_id or id == "world") then
			return true
		else
			return false
		end
	else
		return false
	end
end

// This returns true if the player is a admin
function zyb.f.IsAdmin(ply)
	if IsValid(ply) and ply:IsPlayer() then

		if xAdmin then
			// xAdmin Support
			return ply:IsAdmin()
		elseif sam then
			return ply:IsAdmin()
		else
			if zyb.config.AdminRanks[zyb.f.GetPlayerRank(ply)] then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

/////////////////////////////////////////////
/////////////////////////////////////////////



////////////////////////////////////////////
////////////// Rank / Job //////////////////
////////////////////////////////////////////

function zyb.f.RankCheck(ply,ranks)
	if not IsValid(ply) or ranks == nil then
		return false
	end

	if table.Count(ranks) > 0 then
		if xAdmin then

			local HasRank = false
			for k, v in pairs(ranks) do
				if ply:IsUserGroup(k) then
					HasRank = true
					break
				end
			end
			return HasRank
		else
			if ranks[zyb.f.GetPlayerRank(ply)] then
				return true
			else
				return false
			end
		end
	else
		return true
	end
end

// Returns the player rank / usergroup
function zyb.f.GetPlayerRank(ply)
	if SG then
		return ply:GetSecondaryUserGroup() or ply:GetUserGroup()
	else
		return ply:GetUserGroup()
	end
end

// Returns the players job
function zyb.f.GetPlayerJob(ply)
	return ply:Team()
end
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
//////////////// CUSTOM ////////////////////
////////////////////////////////////////////
function zyb.f.HasModuleType(installedID,newID)
	local HasType = false
	local newType = zyb.config.Upgrades[newID].u_type
	for k, v in pairs(installedID) do
		if newType == zyb.config.Upgrades[v].u_type then
			HasType = true
			break
		end
	end

	return HasType
end
////////////////////////////////////////////
////////////////////////////////////////////
-- leak by lordee