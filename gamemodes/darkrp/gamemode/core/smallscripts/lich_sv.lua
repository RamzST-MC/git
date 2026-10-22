hook.Add("InitPostEntity", "MakeDoorsStayOpen", function()
	for _, ent in ipairs(ents.GetAll()) do
		if ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating"  or ent:GetClass() == 'prop_door_rotating' then
			ent:SetKeyValue("returndelay", "-1")
		end
	end
end)

hook.Add("OnPlayerChangedTeam", "Kravermodel1", function(pl, oldteam, newteam)
	if newteam == TEAM_DOCTOR and pl:SteamID() == 'STEAM_0:0:596896021' then
		timer.Simple(.5, function()
			pl:SetModel('models/player/puntleycmb/worker.mdl')
		end)
	end
end)

hook.Add('PlayerSpawn', 'Kravermodel2', function(pl)
	if pl:GetJob() == TEAM_DOCTOR and pl:SteamID() == 'STEAM_0:0:596896021' then
		timer.Simple(.5, function()
			pl:SetModel('models/player/puntleycmb/worker.mdl')
		end)
	end
	if (pl:GetJob() == TEAM_GANGSTER or pl:GetJob() == TEAM_VIPGANG or pl:GetJob() == TEAM_KARMAN) and pl:SteamID() == 'STEAM_0:0:596896021' then
		timer.Simple(.5, function()
			pl:SetModel('models/spardadmc3um/playermodels/spardaumc3.mdl')
		end)
	end
	if (pl:GetJob() == TEAM_GANGSTER or pl:GetJob() == TEAM_VIPGANG or pl:GetJob() == TEAM_KARMAN) and pl:SteamID() == 'STEAM_0:1:568325293' then
		timer.Simple(.5, function()
			pl:SetModel('models/lskovfoged/dmc4/dante/dante.mdl')
		end)
	end
end)

concommand.Add('slawa_model', function(pl)
	if !pl:Alive() then return end

	if pl:SteamID() == 'STEAM_0:0:463385455' then
		pl:SetModel('models/survivors/shinano_loose_punk.mdl')
	end
end)