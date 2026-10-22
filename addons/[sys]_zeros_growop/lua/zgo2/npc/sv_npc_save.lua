--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher


/*
	Saves the NPC to the Map and loads it after restart / cleanup
*/
file.CreateDir("zgo2")
zclib.STM.Setup("zgo2_npc", "zgo2/" .. string.lower(game.GetMap()) .. "_npcs.txt", function()
	local data = {}

	for k, v in ipairs(ents.FindByClass("zgo2_npc")) do
		if IsValid(v) then
			table.insert(data, {
				class = "zgo2_npc",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end

	for k, v in ipairs(ents.FindByClass("zgo2_npc_export")) do
		if IsValid(v) then
			table.insert(data, {
				class = "zgo2_npc_export",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end

	return data
end, function(data)
	for k, v in pairs(data) do
		local ent = ents.Create(v.class)
		if not IsValid(ent) then continue end
		ent:SetPos(v.pos)
		ent:SetAngles(v.ang)
		ent:Spawn()
		ent:Activate()
	end

	zgo2.Print("Finished loading NPCs!")
end, function()
	for k, v in pairs(ents.FindByClass("zgo2_npc")) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k, v in pairs(ents.FindByClass("zgo2_npc_export")) do
		if IsValid(v) then
			v:Remove()
		end
	end
end)

concommand.Add("zgo2_npc_save", function(ply, cmd, args)
	if ply:GetRank() == 'root' then
		zclib.STM.Save("zgo2_npc")
		zclib.Notify(ply, "NPCs saved for " .. string.lower(game.GetMap()) .. "!", 0)
	end
end)

concommand.Add("zgo2_npc_remove", function(ply, cmd, args)
	if ply:GetRank() == 'root' then
		zclib.STM.Remove("zgo2_npc")
		zclib.Notify(ply, "Removed all NPCs for " .. string.lower(game.GetMap()) .. "!", 0)
	end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher