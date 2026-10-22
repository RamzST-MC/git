hook.Add('PlayerDisconnected', 'gamb::remove', function(pl)
    if pl:GetJob() == TEAM_CASINOOWNER then
        pl:SetNetVar('GamblingZarobotok', nil)
        pl:SetNetVar('GamblingUbitok', nil)
    end
end)

local function SetGamblingMachinePrice(ply, args)
	local amount = math.floor(tonumber(args))
	if amount < 500 then
		rp.Notify(ply, NOTIFY_ERROR, 'Нельзя установить цену ниже $500!')
		return ''
	end

	if amount > 1000000 then
		rp.Notify(ply, NOTIFY_ERROR, 'Нельзя установить цену больше $1,000,000!')
		return ''
	end

	if not IsValid(ply:GetEyeTrace().Entity) then return end
	if ply:Team() ~= TEAM_CASINOOWNER then
		rp.Notify(ply, NOTIFY_ERROR, 'Вы не являетесь владельцем казино!')
		return
	end

	if ply:GetEyeTrace().Entity.ItemOwner ~= ply then
		rp.Notify(ply, NOTIFY_ERROR, 'Этот слот не принадлежит вам!')
		return
	end

	if (ply:GetEyeTrace().Entity:GetPos() - ply:GetPos()):Length() > 200 then
		rp.Notify(ply, NOTIFY_ERROR, 'Вы должны быть ближе к слоту!')
		return
	end

	ply:GetEyeTrace().Entity:Setprice(amount)
	rp.Notify(ply, NOTIFY_SUCCESS, 'Вы установили ставку' .. rp.FormatMoney(amount) .. '!')
	return ''
end

rp.AddCommand('setprice', SetGamblingMachinePrice):AddParam(cmd.NUMBER)
rp.AddCommand("setmachineservice", function(pl, text, args)
	if pl:Team() ~= TEAM_CASINOOWNER then
		rp.Notify(pl, NOTIFY_ERROR, 'Вы не являетесь владельцем казино!')
		return
	end

	if pl:GetEyeTrace().Entity.ItemOwner ~= pl then
		rp.Notify(pl, NOTIFY_ERROR, 'Этот слот не принадлежит вам!')
		return
	end

	if (pl:GetEyeTrace().Entity:GetPos() - pl:GetPos()):Length() > 200 then
		rp.Notify(pl, NOTIFY_ERROR, 'Вы должны быть ближе к слоту!')
		return
	end

	--if pl:GetEyeTrace().Entity:GetIsPayingOut() then rp.Notify(pl, NOTIFY_ERROR, 'Нельзя выключить слот во время выплаты!') return end
	if not pl:GetEyeTrace().Entity:GetInService() then
		pl:GetEyeTrace().Entity:SetInService(true)
		rp.Notify(pl, NOTIFY_SUCCESS, 'Вы включили слот!')
	else
		pl:GetEyeTrace().Entity:SetInService(false)
		rp.Notify(pl, NOTIFY_SUCCESS, 'Вы выключили слот!')
	end
end)