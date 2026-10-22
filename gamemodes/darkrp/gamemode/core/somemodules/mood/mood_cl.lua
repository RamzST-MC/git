local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetMood()
    return self:GetPData( "urf_mood_"..util.CRC(game.GetIPAddress()), PLAYER_MOOD_NORMAL );
end

function PLAYER:SetMood( mood, nosave )
    net.Start( "net.rp.mood" );
        net.WriteUInt( isbool(mood) and 0 or mood, 4 );
        if not nosave then
            self:SetPData( "urf_mood_" .. util.CRC(game.GetIPAddress()), mood );
        end
    net.SendToServer();
end

hook.Add( "OnEntityCreated", "hook.rp.MoodInitialize", function( ent )
    if ent == LocalPlayer() then
        LocalPlayer():SetMood( LocalPlayer():GetMood() );
    end

    hook.Remove( "OnEntityCreated", "hook.rp.MoodInitialize" );
end );

function rp.SetMood(ply, mood)
	ply:SetMood(mood)
end
local mlist

net.Receive('posingkek', function()
    if IsValid(moodmenu) then moodmenu:Remove() end
    moodmenu = vgui.Create("ui_frame")
    moodmenu:SetSize(300, 400)
    moodmenu:Center()
    moodmenu:MakePopup()
    moodmenu:SetTitle("Выберите стойку")

    --local moodmenuscroll = vgui.Create("DScrollPanel", moodmenu)
    --moodmenuscroll:Dock(FILL)

    for k, v in pairs(rp.Mood.HoldTypes) do
        local mlist = vgui.Create("ui_button", moodmenu)
        mlist:Dock(TOP)
        mlist:SetTall(25)
        mlist:SetText(v[2])

        mlist.DoClick = function()
            LocalPlayer():SetMood(k)
            print(k)
        end
    end
end)