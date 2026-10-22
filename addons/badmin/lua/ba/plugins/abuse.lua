-------------------------------------------------
-- Slay
-------------------------------------------------
term.Add('AbusePlayerNotAlive', '# мертв!')
term.Add('AbuseAdminSlainPlayer', '# убил #.')

ba.cmd.Create('Slay', function(pl, args)
	if (not args.target:Alive()) then
		ba.notify_err(pl, term.Get('AbusePlayerNotAlive'), args.target)
		return
	end

	args.target:SetVelocity(Vector(0, 0, 2048))
	timer.Simple(0.2, function()	
		local effect = EffectData()
		effect:SetOrigin(args.target:GetPos())
		effect:SetMagnitude(512)
		effect:SetScale(128)
		util.Effect('Explosion', effect)
		args.target:Kill()
	end)

	ba.notify_staff(term.Get('AbuseAdminSlainPlayer'), pl, args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag '*'
:SetHelp 'Убить'

ba.cmd.Create('ignite', function(pl, args)
	if IsValid(args.targ) and args.targ:IsPlayer() and args.targ:Alive() then
		args.targ:Extinguish()
		args.targ:Ignite(args.time)
	end
end)
:AddParam('player_entity', 'targ')
:AddParam('string', 'time')
:SetFlag '*'
:SetHelp 'Поджечь'

ba.cmd.Create('superignite', function(pl, args)
	if IsValid(args.targ) and args.targ:IsPlayer() and args.targ:Alive() then
		args.targ:Ignite(4)
		timer.Simple(3, function()
			if IsValid(args.targ) and args.targ:IsPlayer() and args.targ:Alive() then
				args.targ:Kill()
			end
		end)
	end
end)
:AddParam('player_entity', 'targ')
:SetFlag '*'
:SetHelp 'Поджечь'

ba.cmd.Create('massignitekill', function(pl, args)
	for k, p in ipairs(player.GetAll()) do
		if IsValid(p) and p:IsPlayer() and p:Alive() then
			p:Ignite(4)
			timer.Simple(3, function()
				if IsValid(p) and p:IsPlayer() and p:Alive() then
					p:Kill()
				end
			end)
		end
	end
end)
:SetFlag '*'
:SetHelp 'Поджечь'