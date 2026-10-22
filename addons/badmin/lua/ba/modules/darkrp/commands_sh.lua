term.Add('EntityNoOwner', 'У этого предмета нет владельца.')
term.Add('CannotUnown', 'Вы не можете выселить из этой двери.')
term.Add('EntityOwnedBy', '# владелец этого #, созданного # назад.')
term.Add('AdminUnownedYourDoor', '# удалил вас из двери.')
term.Add('AdminUnownedPlayerDoor', '# удалил # из двери.')
term.Add('AdminChangedYourJob', '# переместил вас за #.')
term.Add('AdminChangedPlayerJob', '# заставил работать # за #.')
term.Add('JobNotFound', 'Работа # не найдена')
term.Add('AdminUnwantedYou', '# снял с вас розыск.')
term.Add('AdminUnwantedPlayer', '# снял розыск с #.')
term.Add('PlayerNotWanted', '# не в розыске!')
term.Add('AdminUnarrestedYou', '# выпустил вас и тюрьмы.')
term.Add('AdminUnarrestedPlayer', '# выпустил # из тюрьмы.')
term.Add('PlayerNotArrested', '# не в тюрьме!')
term.Add('AdminUnwarrantedYou', '# has force unwarranted you.')
term.Add('AdminUnwarrantedPlayer', '# has force unwarranted #.')
term.Add('PlayerNotWarranted', '# is not warranted!')
term.Add('EventInvalid', '# не является валидным ивентом!')
term.Add('AdminStartedEvent', '# запустил ивент # на #.')
term.Add('AdminFrozePlayersProps', '# заморозил пропы #')
term.Add('AdminFrozeAllProps', '# заморозил все пропы.')
term.Add('PlayerVoteInvalid', 'No vote for # exists!')
term.Add('AdminDeniedVote', '# has denied #\'s vote.')
term.Add('AdminDeniedTeamVote', '# has denied the # vote.')
term.Add('AdminAddedYourMoney', '# has added $# to your wallet.')
term.Add('AdminAddedMoney', 'You have added $# to #\'s wallet.')
term.Add('AdminAddedYourCredits', '# выдал вам # рублей на аккаунт.')
term.Add('AdminAddedCredits', 'Вы добавили # кредитов на счет #.')
-- term.Add('AdminMovedPlayers', 'Moved # players to the other server.')
term.Add('PlayerNotFound', 'Игрок # не найден.')
term.Add('AdminSetHealth', '# установил # здоровье на #.')
term.Add('AdminSetYourHealth', '# установил ваше здоровье на #.')
term.Add('AdminSetArmor', '# установил # броню на #.')
term.Add('AdminSetYourArmor', '# установил вашу броню на #.')
term.Add('AdminSetHunger', '# установил # голод на #.')
term.Add('AdminSetYourHunger', '# установил ваш голод на #.')

if SERVER then
	util.AddNetworkString('ba.darkrp.GetOwner')

	hook('OnEntityCreated', 'ba.darkrp.OnEntityCreated', function(ent)
		ent.GoCmdCreationTime = CurTime() or 0
	end)
else
	require'outline'

	for k, v in ipairs(ents.GetAll()) do
		outline.Add(v, ui.col.Red, outline.MODE_BOTH)
	end

    net.Receive('ba.darkrp.GetOwner', function()
        local c = net.ReadEntity()
        local d = CurTime() + 4
        hook.Add('SetupOutlines', c, function()
            if d <= CurTime() then
                hook.Remove('SetupOutlines', c)
            else
                outline.Add(c, ui.col.Red, outline.MODE_BOTH)
            end
        end)
    end)
end

ba.cmd.Create('Go', function(pl)
	local ent = pl:GetEyeTrace().Entity
	local owner = ent:CPPIGetOwner() or ent.ItemOwner
	if IsValid(ent) and IsValid(owner) then
		net.Start'ba.darkrp.GetOwner'
        net.WriteEntity(ent)
        net.Send(pl)
		ba.notify(pl, term.Get('EntityOwnedBy'), owner, (ent.PrintName and (ent.PrintName ~= '')) and ent.PrintName or ent:GetClass(), ent.GoCmdCreationTime and ba.str.FormatTime(CurTime() - ent.GoCmdCreationTime) or 'Unknown')
	else
		ba.notify_err(pl, term.Get('EntityNoOwner'))
	end
end)
:SetFlag 'U'
:SetHelp 'Shows the owner of a prop'

ba.cmd.Create('Unown', function(pl, args)
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() then
		ba.notify(ent:DoorGetOwner(), term.Get('AdminUnownedYourDoor'), pl)
		ba.notify_staff(term.Get('AdminUnownedPlayerDoor'), pl, ent:DoorGetOwner())
		ent:DoorUnOwn()
	else
		ba.notify_err(pl, term.Get('CannotUnown'))
	end
end)
:SetFlag 'M'
:SetHelp 'Убрать владельца двери'

ba.cmd.Create('Setjob', function(pl, args)
	for k, v in ipairs(rp.teams) do
		if string.find(v.name:lower(), args.name:lower()) then
			ba.notify(args.target, term.Get('AdminChangedYourJob'), pl, v.name)
			ba.notify_staff(term.Get('AdminChangedPlayerJob'), pl, args.target, v.name)
			if not args.target:Alive() then
				args.target:Spawn()
			end
			args.target:ChangeTeam(k, true)
			args.target:Spawn()
			return
		end
	end
	return ba.notify_err(pl, term.Get('JobNotFound'), args.name)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'name')
:SetFlag 'A'
:SetHelp 'Установить профессию'

ba.cmd.Create('Unwant', function(pl, args)
	if args.target:IsWanted() then
		ba.notify(args.target, term.Get('AdminUnwantedYou'), pl)
		ba.notify_staff(term.Get('AdminUnwantedPlayer'), pl, args.target)
		args.target:UnWanted(pl, false)
	else
		return ba.notify_err(pl, term.Get('PlayerNotWanted'), args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Убрать розыск'
:AddAlias 'funwant'

ba.cmd.Create('Unarrest', function(pl, args)
	if args.target:IsArrested() then
		ba.notify(args.target, term.Get('AdminUnarrestedYou'), pl)
		ba.notify_staff(term.Get('AdminUnarrestedPlayer'), pl, args.target)
		args.target:UnArrest(pl, false)
	else
		return ba.notify_err(pl, term.Get('PlayerNotArrested'), args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Вытащить из тюрьмы'
:AddAlias 'funarrest'

ba.cmd.Create('UnWarrant', function(pl, args)
	if args.target:IsWarranted() then
		ba.notify(args.target, term.Get('AdminUnwarrantedYou'), pl)
		ba.notify_staff(term.Get('AdminUnwarrantedPlayer'), pl, args.target)
		args.target:UnWarrant(pl)
	else
		return ba.notify_err(pl, term.Get('PlayerNotWarranted'), args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Убрать ордер'
:AddAlias 'funwarrant'

ba.cmd.Create('Freeze Props', function(pl, args)
	if IsValid(args.target) then
		ba.notify_staff(term.Get('AdminFrozePlayersProps'), pl, args.target)
		for k, v in ipairs(ents.GetAll()) do
	        if IsValid(v) and v:IsProp() and (v:CPPIGetOwner() == args.target) then
	            local phys = v:GetPhysicsObject()
	            if IsValid(phys) then
	                phys:EnableMotion(false)
	            end
	            constraint.RemoveAll(v)
	        end
	    end
	else
		ba.notify_staff(term.Get('AdminFrozeAllProps'), pl)
		for k, v in ipairs(ents.GetAll()) do
	        if IsValid(v) and v:IsProp() then
	            local phys = v:GetPhysicsObject()
	            if IsValid(phys) then
	                phys:EnableMotion(false)
	            end
	            constraint.RemoveAll(v)
	        end
	    end
	end
end)
:AddParam('player_entity', 'target', 'optional')
:SetFlag 'A'
:SetHelp 'Заморозить все пропы'

ba.cmd.Create('Deny Vote', function(pl, args)
	if (not rp.VoteExists(args.target)) then
		ba.notify_err(pl, term.Get('PlayerVoteInvalid'), args.target)
	else
		GAMEMODE.vote.DestroyVotesWithEnt(args.target)
		ba.notify_staff(term.Get('AdminDeniedVote'), pl, args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'M'
:SetHelp 'Отметь голосование'

ba.cmd.Create('Deny Team Vote', function(pl, args)
	if (!rp.teamVote.Votes[args.target]) then
		ba.notify_err(pl, term.Get('PlayerVoteInvalid'), args.target)
	else
		rp.teamVote.Votes[args.target] = nil
		for k, v in ipairs(rp.teams) do
			if (v.name == args.target) then
				v.CurVote = nil
			end
		end
		ba.notify_staff(term.Get('AdminDeniedTeamVote'), pl, args.target)
	end
end)
:AddParam('string', 'target')
:SetFlag 'M'
:SetHelp 'Отметь голосование группы'

ba.cmd.Create('Add Credits', function(pl, args)
	note = note or ''
	--if !pl:SteamID() == 'STEAM_0:0:579509691' then return end
    if !pl:IsPlayer() and isplayer(args.target) then
    	args.target:AddIGSFunds(args.amount)
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'amount')
:SetFlag('*')
:SetHelp('Выдать кредиты')

local setHealth = ENTITY._SetHealth or ENTITY.SetHealth
ba.cmd.Create('Set Health', function(pl, args)
	setHealth(args.target, args.health)

	ba.notify_staff(term.Get('AdminSetHealth'), pl, args.target, args.health)
	ba.notify(args.target, term.Get('AdminSetYourHealth'), pl, args.health)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'health')
:SetFlag 'S'
:SetHelp 'Установить здоровье'

ba.cmd.Create('Set Armor', function(pl, args)
	args.target:SetArmor(args.armor)

	ba.notify_staff(term.Get('AdminSetArmor'), pl, args.target, args.armor)
	ba.notify(args.target, term.Get('AdminSetYourArmor'), pl, args.armor)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'armor')
:SetFlag 'S'
:SetHelp 'Установить броню'

ba.cmd.Create('Set Hunger', function(pl, args)
	args.target:SetHunger(args.hunger)

	ba.notify_staff(term.Get('AdminSetHunger'), pl, args.target, args.hunger)
	ba.notify(args.target, term.Get('AdminSetYourHunger'), pl, args.hunger)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'hunger')
:SetFlag 'S'
:SetHelp 'Установить голод'

ba.cmd.Create('Start Event', function(pl, args)
	local event = string.lower(args.event)
	if (rp.Events[event] == nil) then
		ba.notify_err(pl, term.Get('EventInvalid'), event)
	else
		rp.StartEvent(event, args.time)
		ba.notify_all(term.Get('AdminStartedEvent'), pl, event, args.raw.time)
	end
end)
:AddParam('string', 'event')
:AddParam('time', 'time')
:SetFlag('*')
:SetHelp('Starts and event')