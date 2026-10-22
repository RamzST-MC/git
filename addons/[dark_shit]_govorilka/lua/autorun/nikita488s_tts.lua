-- ==========================================================
-- ||                   Dumped by EOHack's                 ||
-- ==========================================================

if SERVER then
    util.AddNetworkString( "PlayTTS" )

    local filter = {
        'пидор',
        'негр',
        'хохол',
        'хохлы',
        'хохлина',
        'нигер',
        'чурка',
        'чурки'
    }

    hook.Add( "PostPlayerSay", "OnPlayerSayTTS", function( sender, text )
        if (hook.Call('CanPlayerUseTTS', nil, sender, text)) then
            local blocked = false
            -- for _, word in ipairs(filter) do
            --     if (text:lower():find(word)) then
            --         blocked = true
            --         break
            --     end
            -- end

            if (not blocked) then
                net.Start( "PlayTTS" )
                    net.WriteEntity( sender )
                    net.WriteString( sender:GetInfo( "cl_tts_speaker" ) )
                    net.WriteString( text )
                net.SendPAS( sender:GetPos() )
            else
                DarkRP.notify(sender, 1, 5, 'Не ругайтесь!')
            end
        end
    end )
elseif CLIENT then
    CreateClientConVar( "cl_tts_enable", "1" )
    CreateClientConVar( "cl_tts_speaker", "zahar", true, true )

    GovorilkaVoices = {
        ['kostya'] = 'М - Константин',
        ['zahar'] = 'М - Захар',
        ['ermil'] = 'М - Эрмил',
        ['nick'] = 'М - Ник',
        ['zhenya'] = 'М - Евгений',

        ['jane'] = 'Ж - Джейн',
        ['oksana'] = 'Ж - Оксана',
        ['tanya'] = 'Ж - Татьяна',
    }

    local function formatURL(speaker, emotion, text)
        local format = 'mp3' -- 10 times cheaper than .wav lol
        local hertz = 44100
        return string.format( "https://tts.voicetech.yandex.net/tts?speaker=%s&sampleRateHertz=%d&format=%s&emotion=%s&&text=%s", speaker, hertz, format, emotion, text )
    end

    local CharToHex = function( char ) return string.format( "%%%02X", string.byte(char) ) end

    //Modified from https://github.com/wiremod/wire/blob/0c86173f8caf272de2c6d732ed53f37a4fe24013/lua/entities/gmod_wire_expression2/core/http.lua#L109
    local function UrlEncode( str )
        return str:gsub( "[^%w _~%.%-]", CharToHex ):gsub( " ", "+" )
    end

    local delay = {}
    local channels = {}

    net.Receive( "PlayTTS", function()
        if !GetConVar( "cl_tts_enable" ):GetBool() then return end

        local sender = net.ReadEntity()
        local tts_speaker = net.ReadString()
        local pureText = net.ReadString()

        if (not GovorilkaVoices[tts_speaker]) then
            tts_speaker = 'kostya'
        end

        if ((delay[sender] or 0) > CurTime()) then
            return
        end

        delay[sender] = CurTime() + .33

        local text = UrlEncode( pureText )
        local url = formatURL( tts_speaker, 'neutral', text )
        local sound_type = '3d noplay'

        sound.PlayURL( url, sound_type, function( sound_channel )
            if IsValid( sound_channel ) and IsValid( sender ) then
                table.insert(channels, {
                    sender = sender,
                    channel = sound_channel
                })
            end
        end )
    end )

    hook.Add('Think', 'tts.UpdateSpeechPos', function()
        for index, data in ipairs(channels) do
            local sender = data.sender
            local channel = data.channel
            if (IsValid(sender) and sender:Alive()) then
                channel:SetPos(sender:GetPos())
                if (channel:GetState() ~= GMOD_CHANNEL_PLAYING) then
                    if (not data.initialized) then
                        channel:Play()
                        data.initialized = true
                    else
                        channel:Stop()
                        table.remove(channels, index)
                    end
                end
            else
                channel:Stop()
                table.remove(channels, index)
            end
        end
    end)
end