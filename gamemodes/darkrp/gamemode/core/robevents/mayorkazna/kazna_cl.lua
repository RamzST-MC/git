net.Receive('kazna::ask', function(len, pl)
    local ent = net.ReadEntity()

    ui.BoolRequest('Ограбить казну', 'Вы действительно хотите Ограбить казну?', function(g)
        if g then
            net.Start('kazna::try')
            net.WriteEntity(ent)
            net.SendToServer()
        end
    end)
end)