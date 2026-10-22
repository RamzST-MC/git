rp.func = rp.func or {}

util.AddNetworkString('kazna::ask')
util.AddNetworkString('kazna::try')

local function destroy(pl, txt)
    nw.SetGlobal("Kazna::EstTime", 0)
    pl:Notify(NOTIFY_ERROR, txt)
    timer.Remove("KaznaOgr")

    for k, v in pairs(player.GetAll()) do
        v:Notify(NOTIFY_ERROR, 'Ограбление казны завершено.')
    end
end

local function restorekazna()
    nw.SetGlobal("Kazna::BoolOgr", nil)
    nw.SetGlobal('Kazna::CoolDown', rp.cfg.CD)
    timer.Create('kazna::cd', 1, rp.cfg.CD, function()
        if nw.GetGlobal('Kazna::CoolDown') > 1 then
            nw.SetGlobal('Kazna::CoolDown', nw.GetGlobal('Kazna::CoolDown') - 1)
        else
            for k, v in pairs(player.GetAll()) do
                if !table.HasValue(rp.cfg.AllowedTeams, v:Team()) then return end
                v:Notify(NOTIFY_SUCCESS, 'Казна города вновь доступна.')
            end
            nw.SetGlobal('Kazna::CoolDown', 0)
            timer.Remove("kazna::cd")
        end
    end)
end

function rp.func.TryToRob(pl, ent)
    if nw.GetGlobal('Kazna::BoolOgr') != nil then
        pl:Notify(NOTIFY_ERROR, 'Казна уже грабится!')
        return
    end

    if nw.GetGlobal('Kazna::CoolDown') > 1 then
        pl:Notify(NOTIFY_ERROR, 'У казны кулдаун, приходите через #!', string.ToMinutesSeconds(nw.GetGlobal('Kazna::CoolDown')))
        return
    end

    if !table.HasValue(ents.FindInBox(rp.cfg.MayorRoom[1], rp.cfg.MayorRoom[2]), pl) then
        pl:Notify(NOTIFY_ERROR, 'нахуй пошел сын бля')
        return
    end

    if !table.HasValue(rp.cfg.AllowedTeams, pl:Team()) then
        pl:Notify(NOTIFY_ERROR, 'У вас неверная работа для ограбления!')
        return
    end

    if !pl:InParty() then
        pl:Notify(NOTIFY_ERROR, 'Вы должны быть в пати для ограбления!')
        return
    end

    if player.GetCount(rp.parties.GetPlayers(pl)) < 3 then
        pl:Notify(NOTIFY_ERROR, 'В вашей пати меньше трёх человек.')
        return
    end

    if ent:GetKaznaMoney() <= 0 then
        pl:Notify(NOTIFY_ERROR, 'В казне нет денег!')
        return
    end

    nw.SetGlobal("Kazna::EstTime", rp.cfg.RobTime)
    nw.SetGlobal("Kazna::BoolOgr", true)
    timer.Create('KaznaOgr', 1, rp.cfg.RobTime, function()
        if !table.HasValue(ents.FindInBox(rp.cfg.MayorRoom[1], rp.cfg.MayorRoom[2]), pl) then
            destroy(pl, 'Вы должны находится в мэрии во время ограбления!')
            restorekazna()
            return
        end

        if !pl:Alive() then
            destroy(pl, 'Вы были убиты во время ограбления казны!')
            return
        end

        if nw.GetGlobal("Kazna::EstTime") > 1 then
            nw.SetGlobal("Kazna::EstTime", nw.GetGlobal("Kazna::EstTime") - 1)
        else
            for k, v in pairs(player.GetAll()) do
                v:Notify(NOTIFY_ERROR, 'Казна города была ограблена.')
            end
            restorekazna()
            pl:AddMoney(ent:GetKaznaMoney())
            nw.SetGlobal('Kazna::Money', 0)
            nw.SetGlobal("Kazna::EstTime", 0)
            timer.Remove("KaznaOgr")
        end
    end)
end

net.Receive('kazna::try', function(len, pl)
    local ent = net.ReadEntity()

    rp.func.TryToRob(pl, ent)
end)

local function Init()
    nw.SetGlobal('Kazna::CoolDown', 0)
    nw.SetGlobal("Kazna::EstTime", 0)
    nw.SetGlobal("Kazna::BoolOgr", nil)
    nw.SetGlobal("Kazna::Money", rp.cfg.KaznaStartMoney)
end

hook.Add('PostGamemodeLoaded', 'kazna::post', Init)