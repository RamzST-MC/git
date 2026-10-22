Phone = {}
Phone.Accepted = false

function Phone.StartCall(ply)
    net.Start('rp::PhoneSys.phone')

    net.WriteTable{
        ply = ply,
        act = 'call'
    }

    net.SendToServer()
end

function Phone.Call(ply)
    if IsValid(Phone.ActiveFrame) then return end
    Phone.ActiveFrame = ui.Create('ui_frame')
    Phone.ActiveFrame:SetSize(241, 127)
    Phone.ActiveFrame:SetPos(10, ScrH() / 2 - Phone.ActiveFrame:GetWide() / 2)
    local f = Phone.ActiveFrame
    f:SetTitle('Звонок')
    local f = Phone.ActiveFrame

    function f:Close()
        local m = DermaMenu()

        m:AddOption('Бросить трубку').DoClick = function()
            Phone.Deny()
            self:Remove()
        end

        m:Open()
    end

    local accept = ui.Create('DPanel', f)
    accept:SetWide(110)
    accept:SetPos(100, 50)
    accept:SetText('')
    local pt = nil

    function accept:Paint(w, h)
        if Phone.Accepted == true then
            if not pt then
                pt = CurTime()
            end

            local time = CurTime() - pt
            local ft = string.FormattedTime(math.floor(time))
            draw.DrawText(string.format('%s:%s:%s', ft.h, ft.m, ft.s), 'ui.22', w / 2, h / 2 - 9, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        else
            draw.DrawText(string.rep('.', CurTime() % 4), 'ui.22', w / 2, h / 2 - 9, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    slb = ui.Create("ui_button", Phone.ActiveFrame)
    slb:SetSize(154, 20)
    slb:SetPos(78, 103)
    slb:SetText("Бросить")
    slb:SetTextColor(Color(255, 255, 255))

    slb.DoClick = function(self)
        Phone.Deny()
    end

    local avatar = ui.Create("AvatarImage", f)
    avatar:SetPos(5, 59)
    avatar:SetPlayer(ply, 128)
    avatar:SetSize(64, 64)
    local lbl = ui.Create("DLabel", f)
    lbl:SetPos(78, 56)
    lbl:SetText("")
    lbl:SetSize(154, 40)

    lbl.Paint = function(self, w, h)
        local name = ply:Nick()

        if string.len(name) > 13 then
            name = string.sub(name, 1, 13) .. "..."
        end

        draw.DrawText(name, 'ui.22', w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

function Phone.InCall(ply)
    if IsValid(Phone.ActiveFrame) then return end
    Phone.ActiveFrame = ui.Create('ui_frame')
    Phone.ActiveFrame:SetSize(241, 127)
    Phone.ActiveFrame:SetPos(10, ScrH() / 2 - Phone.ActiveFrame:GetWide() / 2)
    local f = Phone.ActiveFrame
    f:SetTitle('Звонок')

    function f:Close()
        local m = DermaMenu()

        m:AddOption('Заглушить звонок').DoClick = function()
            self:SetAlpha(100)
            Phone.Mute()
        end

        m:AddSpacer()

        m:AddOption('Бросить трубку').DoClick = function()
            Phone.Deny()
            self:Remove()
        end

        m:Open()
    end

    local decline = ui.Create('ui_button', f)
    decline:SetSize(154, 20)
    decline:SetPos(78, 103)
    decline:SetText('Бросить')

    function decline:DoClick()
        Phone.Deny()
    end

    local accept = ui.Create('ui_button', f)
    accept:SetSize(154, 20)
    accept:SetPos(78, 79)
    accept:SetText('Принять')
    accept:SetImage("icon16/phone_add.png")

    function accept:DoClick()
        net.Start'rp::PhoneSys.phone'
        net.WriteTable{
            act = 'accept'
        }
        net.SendToServer()
        f:Remove()
        Phone.Call(ply)
    end

    local avatar = ui.Create("AvatarImage", f)
    avatar:SetPos(5, 59)
    avatar:SetPlayer(ply, 128)
    avatar:SetSize(64, 64)
    local lbl = ui.Create("DLabel", f)
    lbl:SetPos(78, 56)
    lbl:SetText("")
    lbl:SetSize(154, 40)

    lbl.Paint = function(self, w, h)
        local name = ply:Nick()

        if string.len(name) > 13 then
            name = string.sub(name, 1, 13) .. "..."
        end

        draw.DrawText(name, 'ui.22', w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

function Phone.Deny()
    net.Start('rp::PhoneSys.phone')
    net.WriteTable{
        act = 'deny'
    }
    net.SendToServer()
end

function Phone.MuteForever()
    net.Start('rp::PhoneSys.phone')
    net.WriteTable{
        act = 'muteforever'
    }
    net.SendToServer()
end

function Phone.Mute()
    net.Start('rp::PhoneSys.phone')
    net.WriteTable{
        act = 'mute'
    }
    net.SendToServer()
end

net.Receive('rp::PhoneSys.phone_client', function()
    local t = net.ReadTable()

    if t.act == 'in' then
        Phone.InCall(t.ply)
    end

    if t.act == 'out' then
        Phone.Call(t.ply)
    end

    if t.act == 'accept' then
        Phone.Accepted = true
    end

    if t.act == 'deny' then
        Phone.Accepted = false

        if IsValid(Phone.ActiveFrame) then
            Phone.ActiveFrame:Remove()
        end
    end
end)
