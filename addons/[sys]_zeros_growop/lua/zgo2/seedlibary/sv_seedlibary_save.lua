--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.SeedLibary = zgo2.SeedLibary or {}

/*

	The seedlibary stores the players seeds

*/

file.CreateDir( "zgo2" )
file.CreateDir( "zgo2/seedlibary" )

/*
	Saves the players seedlibary
*/
function zgo2.SeedLibary.Save(ply)
	if not ply.zgo2_seedlibary then ply.zgo2_seedlibary = {} end

	local SteamID64 = ply:SteamID64()
	local path = "zgo2/seedlibary/" .. SteamID64 .. ".txt"

	// Delete old savefile
	file.Delete(path)

	// Create new savefile
	if ply.zgo2_seedlibary and table.Count(ply.zgo2_seedlibary) > 0 then
		file.Write(path, util.TableToJSON(ply.zgo2_seedlibary, true))

		zgo2.Print("[SeedLibary] Successfully saved [" .. SteamID64 .. "] seeds!")
	end
end

/*
	Save on disconnect
*/
zclib.Hook.Add("zclib_PlayerDisconnect", "zgo2.SeedLibary.SaveOnDeconnect", function(steamid)
	local ply = player.GetBySteamID( steamid )
	if IsValid(ply) then
		zgo2.SeedLibary.Save(ply)
	end
end)

/*
	Saves the seedlibary Data for all players
*/
function zgo2.SeedLibary.SaveForAll()
	for k,v in pairs(player.GetAll()) do
		if not IsValid(v) then continue end
		zgo2.SeedLibary.Save(v)
	end
end
zclib.Hook.Add("ShutDown", "zgo2.SeedLibary.Save", function() zgo2.SeedLibary.SaveForAll() end)

/*
	Load the players SeedLibary
*/
function zgo2.SeedLibary.Load(ply)

	local SteamID64 = ply:SteamID64()
	local path = "zgo2/seedlibary/" .. SteamID64 .. ".txt"
	if not file.Exists(path, "DATA") then return end

	local data = file.Read(path, "DATA")
	if not data then return end
	data = util.JSONToTable(data)
	if not data then return end

	if not ply.zgo2_seedlibary then ply.zgo2_seedlibary = {} end

	// Lets validate first which of the seeds still exist and which one dont
	for k,v in pairs(data) do
		if not zgo2.Plant.IsValid(v.id) then continue end
		ply.zgo2_seedlibary[k] = v
	end

	zgo2.Print("[SeedLibary] Successfully loaded [" .. SteamID64 .. "] seeds!")
end

function zgo2.SeedLibary.Delete(ply)
	ply.zgo2_seedlibary = {}

	local SteamID64 = ply:SteamID64()
	local path = "zgo2/seedlibary/" .. SteamID64 .. ".txt"
	if not file.Exists(path, "DATA") then return end
	file.Delete(path)
end


/*
	Clean up any savefile which is older then 1 month
*/
function zgo2.SeedLibary.CleanUp()
	local path = "zgo2/seedlibary/"
	local files = file.Find(path .. "*", "DATA")

	for k, v in pairs(files) do

		if file.Exists(path .. v, "DATA") and (os.time() - file.Time(path .. v, "DATA")) > zgo2.config.SeedLibary.LifeTime then
			file.Delete(path .. v)
		end
	end
end
timer.Simple(3,zgo2.SeedLibary.CleanUp)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher