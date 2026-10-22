util.AddNetworkString('rp.parties.ToggleVoice')

net.Receive('rp.parties.ToggleVoice', function(len, pl)
end)

rp.AddCommand('createparty', function(pl, args)
    if utf8.len(args) > 12 then return end
    if utf8.len(args) < 3 then return end

    if IsValid(pl) and !pl:InParty() then
        pl:SetNetVar('Party', args)
        pl:SetNetVar('PartyLeader', true)
        pl:Notify(NOTIFY_SUCCESS, 'Вы создали пати ' .. pl:GetParty() .. '.')
    end
end)
:AddParam(cmd.STRING)

rp.AddCommand('leaveparty', function(pl)
    if IsValid(pl) and pl:InParty() then
        if pl:IsPartyLeader() then 
            for k, v in ipairs(player.GetAll()) do
                if pl:GetParty() == v:GetParty() and pl != v then
                    v:SetNetVar('Party', nil)
                    v:Notify(NOTIFY_ERROR, 'Пати ' .. pl:GetParty() .. ' была распущена.')
                end
                pl:SetNetVar('PartyLeader', nil)
            end
            pl:Notify(NOTIFY_SUCCESS, 'Вы распустили пати ' .. pl:GetParty() .. '.')
        else
            pl:Notify(NOTIFY_SUCCESS, 'Вы вышли из пати ' .. pl:GetParty() .. '.')
        end
        pl:SetNetVar('Party', nil)
    end
end)

rp.AddCommand('inviteparty', function(pl, args)
    if !IsValid(args) and !args:IsPlayer() then return end
    if args:InParty() then pl:Notify(NOTIFY_ERROR, 'Игрок уже находится в пати.') return end
    pl:Notify(NOTIFY_ERROR, 'Вы пригласили ' .. args:Name() .. ' присоединиться к пати.')

    GAMEMODE.ques:Create('Вас пригласили в пати ' .. pl:GetParty(), 'PARTY_' .. CurTime(), args, 30, function(answer)
        if answer != true then return end
        if !pl:GetParty() then return end
        if args:GetParty() then return end

        pl:Notify(NOTIFY_ERROR, 'Игрок ' .. args:Name() .. ' присоединился к пати.')
        args:SetNetVar('Party', pl:GetParty())
    end)
end)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('kickparty', function(pl, args)
    if !pl:IsPartyLeader() then return end

    args:SetNetVar('Party', nil)
    args:Notify(NOTIFY_ERROR, 'Вас исключили из пати ' .. pl:GetParty())
    pl:Notify(NOTIFY_ERROR, 'Вы исключили из пати ' .. args:GetName())
end)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('promotecoleader', function(pl, args)
    if !pl:IsPartyLeader() then return end
    if args:IsPartyCoLeader() then pl:Notify(NOTIFY_ERROR, 'Игрок уже совладелец пати.') return end
    
    args:SetNetVar('PartyCoLeader', true)
    pl:Notify(NOTIFY_ERROR, 'Вы выдали права совладельца пати игроку '.. args:Name() ..'.')
    args:Notify(NOTIFY_ERROR, 'Вам выданы права совладельца пати.')
end)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('demotecoleader', function(pl, args)
    if !pl:IsPartyLeader() then return end
    if !args:IsPartyCoLeader() then pl:Notify(NOTIFY_ERROR, 'Игрок не совладелец пати.') return end
    
    args:SetNetVar('PartyCoLeader', nil)
    pl:Notify(NOTIFY_ERROR, 'Вы забрали права совладельца пати игроку '.. args:Name() ..'.')
    args:Notify(NOTIFY_ERROR, 'У вас забраны права совладельца пати.')
end)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('transferparty', function(pl, args)
    if !pl:IsPartyLeader() then return end
    if args:IsPartyLeader() then return end
    
    pl:SetNetVar('PartyLeader', nil)
    args:SetNetVar('PartyLeader', true)
    pl:Notify(NOTIFY_ERROR, 'Вы передали права владельца пати игроку '.. args:Name() ..'.')
    args:Notify(NOTIFY_ERROR, 'Вам переданы права совладельца пати.')
end)
:AddParam(cmd.PLAYER_ENTITY)
