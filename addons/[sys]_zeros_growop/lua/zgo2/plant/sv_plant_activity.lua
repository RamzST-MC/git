--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}

/*

	This system will keep track what weed spliced config gets used how often.
	This way we can removed weed configs which are not used anymore

*/

zgo2.Plant.Activity = zgo2.Plant.Activity or {}

/*
	When did we last use this plant
*/
function zgo2.Plant.SetActive(UniqueID)

	if not zgo2.Plant.IsSplice(UniqueID) then return end

	local ListID = zgo2.Plant.GetListID(UniqueID)

	zgo2.config.Plants[ListID].Activity = os.time()

	zgo2.Plant.Activity[ zgo2.Plant.GetID(UniqueID) ] = os.time()
end

/*
	Returns when did we last use this plant
*/
function zgo2.Plant.GetActive(UniqueID)

	if not zgo2.Plant.IsSplice(UniqueID) then return end

	return zgo2.Plant.Activity[ zgo2.Plant.GetID(UniqueID) ]
end

/*
	Save the plant activity before Shutdown
*/
file.CreateDir( "zgo2" )
function zgo2.Plant.SaveActivity() file.Write("zgo2/plant_activitytracker.txt", util.TableToJSON(zgo2.Plant.Activity,true)) end
zclib.Hook.Add("ShutDown", "zgo2.Plant.SaveActivity", function() zgo2.Plant.SaveActivity() end)

/*
	Load the plant activity on startup
*/
function zgo2.Plant.LoadActivity()
	local data = file.Read("zgo2/plant_activitytracker.txt", "DATA")
	if data == nil then return end
	data = util.JSONToTable(data)
	if data == nil then return end

	zgo2.Plant.Activity = {}
	for k, v in pairs(data) do zgo2.Plant.Activity[ tostring(k) ] = tonumber(v) end
end

/*
	Initializes the plant activity system, gets called after the server did load the plant config
*/
function zgo2.Plant.InitActivity()

	// Load the current plant activity
	zgo2.Plant.LoadActivity()

	for k,v in pairs(zgo2.config.Plants) do
		if v and v.uniqueid and not zgo2.Plant.Activity[v.uniqueid] and zgo2.Plant.IsSplice(k) then
			zgo2.Plant.Activity[v.uniqueid] = os.time()
		end
	end

	timer.Simple(0,function()
		// Cleanup the spliced plant configs which were not used for a long time
		local RemovedIDs = {}
		for id,time in pairs(zgo2.Plant.Activity) do

			if not zgo2.Plant.IsValid(id) then
				RemovedIDs[id] = true
				continue
			end

			if not zgo2.Plant.IsSplice(id) then
				RemovedIDs[id] = true
				continue
			end

			/*
			local atime = zgo2.Plant.GetLifeTime(id) - (os.time() - time)
			print(zgo2.Plant.GetName(id) .. "[" .. id .. "]" .. " Deletion in " .. atime .. " seconds.")
			*/

			if (os.time() - time) > zgo2.Plant.GetLifeTime(id) then

				local PreventDeletion = hook.Run("zgo2.SplicedPlant.PreventDeletion",id)
				if PreventDeletion then continue end

				zgo2.Print("Removed inactive spliced plant config > " .. zgo2.Plant.GetName(id))

				// Delete this plant config
				zgo2.Plant.RemoveSplice(id)

				RemovedIDs[id] = true
			end
		end

		for k,v in pairs(RemovedIDs) do
			zgo2.Plant.Activity[k] = nil
		end

		// Tell the plant config when it was last active, so that this value gets send to clients
		for k,v in pairs(zgo2.config.Plants) do
			if v and v.uniqueid and zgo2.Plant.IsSplice(k) then
				v.Activity = zgo2.Plant.Activity[v.uniqueid]
			end
		end
	end)
end

/*
	Deletes the activity tracker
*/
function zgo2.Plant.DeleteActivity()
	file.Delete("zgo2/plant_activitytracker.txt")
	zgo2.Plant.Activity = {}
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher