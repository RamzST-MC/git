rp.interactions = rp.interactions or {}
if IsValid(rp.interactions.Menu) then rp.interactions.Menu:Remove() end
local a = {
    Buttons = {
        {
            Name = 'Предложить секс',
            Command = 'sex',
            CanUse = function(b) return LocalPlayer():GetTeamTable().Hoe end
        },
        {
            Name = 'Нанять',
            Command = 'hire',
            CanUse = function(b) return b:IsHirable() and not b:IsHired() end,
            DoClick = function(b) cmd.Run('hire', b:SteamID(), b:GetHirePrice()) end
        }
    },
    Categories = {
        {
            Name = 'Пати',
            Icon = 'sup/gui/generic/party.png',
            Buttons = {
                {
                    Name = 'Пригласить в пати',
                    DoClick = function(b) cmd.Run('inviteparty', b:SteamID()) end,
                    CanUse = function(b) return b:GetParty() ~= LocalPlayer():GetParty() end
                },
                {
                    Name = 'Кикнуть с пати',
                    DoClick = function(b) cmd.Run('kickparty', b:SteamID()) end,
                    CanUse = function(b) return b:GetParty() == LocalPlayer():GetParty() end
                },
                {
                    Name = 'Повысить до совладельца пати',
                    DoClick = function(b) cmd.Run('promotecoleader', b:SteamID()) end,
                    CanUse = function(b) return b:GetParty() == LocalPlayer():GetParty() and not b:IsPartyCoLeader() and LocalPlayer():IsPartyLeader() end
                },
                {
                    Name = 'Убрать совладельца пати',
                    DoClick = function(b) cmd.Run('demotecoleader', b:SteamID()) end,
                    CanUse = function(b) return b:GetParty() == LocalPlayer():GetParty() and b:IsPartyCoLeader() and LocalPlayer():IsPartyLeader() end
                },
                {
                    Name = 'Передать пати',
                    DoClick = function(b) cmd.Run('transferparty', b:SteamID()) end,
                    CanUse = function(b) return b:GetParty() == LocalPlayer():GetParty() and LocalPlayer():IsPartyLeader() end
                }
            },
            CanUse = function(b) return LocalPlayer():InParty() and (LocalPlayer():IsPartyLeader() or LocalPlayer():IsPartyCoLeader()) end
        },
        {
            Name = 'Деньги',
            Icon = 'sup/gui/generic/money.png',
            Buttons = {
                {
                    Name = 'Дать Денег',
                    DoClick = function(b) ui.NumberRequest('Дать ' .. b:Name() .. ' денег', 'Введите сумму для передачи денег ' .. b:Name(), 1, 1000, LocalPlayer():GetMoney(), function(c) if IsValid(b) then cmd.Run('give', c) end end) end
                },
            }
        },
        {
            Name = 'Действия',
            Icon = 'sup/gui/generic/actions.png',
            Buttons = {
                {
                    Name = 'Заказать убийство',
                    DoClick = function(b) ui.NumberRequest('Заказать убийство', 'Введите сумму для заказа (Минимум ' .. string.FormatUSD(rp.cfg.HitMinCost) .. ')?', rp.cfg.HitMinCost, rp.cfg.HitMinCost, LocalPlayer():GetMoney(), function(c) if IsValid(b) then cmd.Run('hit', b:SteamID(), c) end end) end
                },
                {
                    Name = 'Уволить',
                    DoClick = function(b) ui.StringRequest('Уволить', 'Введите причину для увольнения ' .. b:Name(), '', function(c) if IsValid(b) then cmd.Run('demote', b:SteamID(), c) end end) end
                }
            }
        },
        {
            Name = 'Утилиты',
            Icon = 'sup/gui/generic/admin.png',
            Buttons = {
                {
                    Name = 'Скопировать SteamID',
                    DoClick = function(b) SetClipboardText(b:SteamID()) end
                },
                {
                    Name = 'Открыть Профиль',
                    DoClick = function(b) b:ShowProfile() end
                },
                {
                    Name = 'Замутить/Размутить',
                    DoClick = function(b) b:Block(not b:IsBlocked()) end
                }
            }
        },
        {
            Name = 'Государство',
            Icon = 'divergent/ui/hud/generic/court.png',
            Buttons = {
                {
                    Name = 'Посмотреть список нелегала',
                    DoClick = function(b)
                        net.Start('cuffs::govno')
                        net.WriteEntity(b)
                        net.SendToServer()
                    end,
                    -- CanUse = function(b) return LocalPlayer():IsCP() and !b:IsGov() and b:IsCuffed() end
                },
                {
                    Name = 'Подать в розыск',
                    DoClick = function(b) ui.StringRequest('Розыск', 'Введите причину розыска', '', function(c) if IsValid(b) then cmd.Run('want', b:SteamID(), c) end end) end,
                    CanUse = function(b) return !b:IsGov() and !b:IsWanted() end
                },
                {
                    Name = 'Снять розыск',
                    DoClick = function(b) cmd.Run('unwant', b:SteamID()) end,
                    CanUse = function(b) return !b:IsGov() and b:IsWanted() end
                },
                {
                    Name = 'Взять ордер',
                    DoClick = function(b) ui.StringRequest('Ордер', 'Введите причину ордера', '', function(c) if IsValid(b) then cmd.Run('warrant', b:SteamID(), c) end end) end,
                    CanUse = function(b) return !b:IsGov() end
                }
            },
            CanUse = function(b) return LocalPlayer():IsGov() end
        }
    }
}

net('rp.interaction.Open', function()
    local b = net.ReadPlayer()
    if not IsValid(b) then return end
    if IsValid(rp.interactions.Menu) then
        if rp.interactions.Menu.Player ~= b then rp.interactions.Menu:Remove() end
    else
        rp.interactions.Menu = ui.Create('rp_interactions_menu', function(self)
            self:SetOptions(a)
            self:SetEntity(b)
        end)
    end
end)

net('rp.interaction.Close', function() if IsValid(rp.interactions.Menu) then rp.interactions.Menu:Remove() end end)