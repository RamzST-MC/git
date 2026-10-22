util.AddNetworkString 'ba.ToggleChat'
util.AddNetworkString 'ba.DeToggleChat'
util.AddNetworkString 'sayRaw'

net.Receive('ba.ToggleChat', function(len, pl)
	pl:SetNetVar('IsTyping', not pl:GetNetVar('IsTyping'))
end)

net.Receive('ba.DeToggleChat', function(len, pl)
	pl:SetNetVar('IsTyping', false)
end)

net.Receive('sayRaw', function(len, pl)
	if (pl.nextSay and pl.nextSay > CurTime()) then
		return
	end

	pl.nextSay = CurTime() + 1

	local bTeam = net.ReadBool()
	local msg = string.Trim(net.ReadString() or "")

	if msg == "" then return end

	hook.Run("PlayerSay", pl, msg, bTeam)
end)

function PLAYER:ChatPrint(...)
	ba.notify(self, ...)
end

local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1379508787379175576/SmvCWYLLDmBrTo_7BjP0Ra8CkM77r6E__ERQDvvoXIJyjbm2CkpoYHBUJCGSQR6_Jj3Z"
local MIN_MESSAGE_LENGTH = 1
local MAX_MESSAGE_LENGTH = 40
local AVATAR_API = "https://steamcommunity.com/profiles/%s?xml=1"

rp.AddCommand("ds", function(ply, text)
    if not IsValid(ply) then return end
    
    local msgLength = string.len(text)
    
    if msgLength <= MIN_MESSAGE_LENGTH then
        rp.Notify(ply, NOTIFY_ERROR, "Сообщение слишком короткое")
        return
    end

    if msgLength > MAX_MESSAGE_LENGTH then
        text = string.sub(text, 1, MAX_MESSAGE_LENGTH) .. "..."
        rp.Notify(ply, NOTIFY_ERROR, "Сообщение было обрезано для Discord")
    end

    local payload = {
        username = ply:Nick() .. " @ Bangclaw",
        content = text
    }

    local steamID64 = ply:SteamID64()
    if steamID64 then
        local cachedAvatar = ply:GetPData("discord_avatar", "")
        if cachedAvatar ~= "" then
            payload.avatar_url = cachedAvatar
            sendToDiscord(payload)
            chat.Send('Discord', ply, text, ply)
        else
            http.Fetch(string.format(AVATAR_API, steamID64),
                function(body)
                    local avatarUrl = body:match('<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>')
                    if avatarUrl then
                        ply:SetPData("discord_avatar", avatarUrl)
                        payload.avatar_url = avatarUrl
                    end
                    sendToDiscord(payload)
                end,
                function(error)
                    sendToDiscord(payload)
                end
            )
            return
        end
    else
        sendToDiscord(payload)
    end
end)
:AddParam(cmd.STRING)

function sendToDiscord(payload)
    http.Post(DISCORD_WEBHOOK, payload, 
        function(_, _, _, code)
            print("[Discord] Сообщение отправлено. Код: " .. code)
        end,
        function(error)
            print("[Discord] Ошибка отправки: " .. error)
        end
    )
end
