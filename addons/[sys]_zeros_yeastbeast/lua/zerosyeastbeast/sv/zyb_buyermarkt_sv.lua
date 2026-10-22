-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Check_BuyerMarkt_TimerExist()
	zyb.f.Timer_Create("zyb_buyermarkt_id", zyb.config.NPC.RefreshRate, 0, zyb.f.ChangeMarkt)
end

function zyb.f.ChangeMarkt()
	for k, v in pairs(ents.FindByClass("zyb_buyer_npc")) do
		if (IsValid(v)) then
			v:RefreshBuyRate()
		end
	end
end

timer.Simple(0,function()
	zyb.f.Check_BuyerMarkt_TimerExist()
end)

// The SAVE / LOAD Functions
function zyb.f.Save_BuyerNPC(ply)
	local data = {}

	for u, j in pairs(ents.FindByClass("zyb_buyer_npc")) do
		table.insert(data, {
			pos = j:GetPos(),
			ang = j:GetAngles()
		})
	end

	if data and table.Count(data) > 0 then

		if not file.Exists("zyb", "DATA") then
			file.CreateDir("zyb")
		end

		file.Write("zyb/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt", util.TableToJSON(data))

		zyb.f.Notify(ply, "Buyer NPC´s have been saved for the map " .. game.GetMap() .. "!", 0)
	end
end

function zyb.f.Remove_BuyerNPC(ply)
	for u, j in pairs(ents.FindByClass("zyb_buyer_npc")) do
		if IsValid(j) then
			SafeRemoveEntity(j)
		end
	end


	if file.Exists("zyb/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt", "DATA") then
		file.Delete("zyb/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt", "DATA")
	end

	zyb.f.Notify(ply, "Buyer NPC´s have been removed for the map " .. game.GetMap() .. "!", 0)
end

function zyb.f.Load_BuyerNPC()
	if file.Exists("zyb/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt", "DATA") then
		local data = file.Read("zyb/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt", "DATA")
		data = util.JSONToTable(data)

		if data and table.Count(data) > 0 then
			for k, v in pairs(data) do
				local npc = ents.Create("zyb_buyer_npc")
				npc:SetPos(v.pos)
				npc:SetAngles(v.ang)
				npc:Spawn()
				npc:Activate()
			end

			print("[Zeros YeastBeast] Finished loading Buyer NPCs.")
		end
	else
		print("[Zeros YeastBeast] No map data found for BuyerNPCs entities. Please place some and do !savezyb to create the data.")
	end
end

timer.Simple(0,function()
	zyb.f.Load_BuyerNPC()
end)
hook.Add("PostCleanupMap", "zyb_SpawnBuyerNPCPostCleanUp", zyb.f.Load_BuyerNPC)

--hook.Add("PlayerSay", "zyb_SaveBuyerNPC", function(ply, text)
rp.AddCommand('zyb_savepos', function(ply, text)
	--if string.sub(string.lower(text), 1, 8) == "!savezyb" then
		if ply:IsRoot() then
			zyb.f.Save_BuyerNPC(ply)
		else
			ply:Kick("шел наху отсуда")
		end
	--end
end)

rp.AddCommand('zyb_remove', function(ply, text)
	--if string.sub(string.lower(text), 1, 8) == "!savezyb" then
		if ply:IsRoot() then
			zyb.f.Remove_BuyerNPC(ply)
			ply:ChatPrint('Да')
		else
			ply:Kick("шел наху отсуда")
		end
	--end
end)
	
--end)
-- leak by lordee