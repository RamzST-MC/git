hook.Add('PlayerHasHunger', 'SOD.PlayerHasHunger', function(pl)
	return (pl:Team() ~= TEAM_ADMIN)
end)