if IsValid(rp.Scoreboard) then rp.Scoreboard:Remove() end

function GM:ScoreboardShow()
	if (not IsValid(rp.Scoreboard)) then
		rp.Scoreboard = ui.Create 'rp_scoreboard'
	end

	rp.Scoreboard:Open()
	rp.Scoreboard:MakePopup()
end

function GM:ScoreboardHide()
	if IsValid(rp.Scoreboard) then
		rp.Scoreboard:Close()
	end
end