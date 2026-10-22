-- PMs
if CLIENT then
	cvar.Register 'enable_non_pm_chat_tabs'
		:SetDefault(false, true)
		:AddMetadata('Catagory', 'Чат')
		:AddMetadata('Menu', 'Создать вкладку чатов для не PM чатов')

	hook.Add('ShouldCreateChatTab', 'rp.chat.ShouldCreateChatTab2', function(name)
		if (!cvar.GetValue('enable_non_pm_chat_tabs')) and (string.find(name, '[PM]') == nil or string.find(name, '[Party]') == nil) then
			return false
		end
	end)
end

nw.Register'IsTyping'
    :Write(net.WriteBool)
    :Read(net.ReadBool)
    :SetPlayer()
    :SetNoSync()

local c = false

chat.Register'PM'
	:Write(function(a, d, e)
		net.WritePlayer(a)
		net.WritePlayer(d)
		net.WriteString(e)
	end)
	:Read(function()
		local pl, targ = net.ReadPlayer(), net.ReadPlayer()

		if (not IsValid(pl)) or (not IsValid(targ)) or (pl:IsMuted()) then return end

		local isTarget = (targ == LocalPlayer())
		local user = (isTarget and pl or targ)

		if cvar.GetValue('PMNotify') and isTarget then
			surface.PlaySound('friends/message.wav')
			system.FlashWindow()
		end

		chat.SetTab('[PM] ' .. user:Name(), "/pm " .. user:SteamID()) // have to do this twice
		chat.SetTab('[PM] ' .. user:Name(), "/pm " .. user:SteamID())
		CHATBOX.DoEmotes = pl:IsVIP()

		local tag = user:GetChatTag()
		tag = tag == '' and tag or (tag .. ' ')

		return ui.col.Yellow, '[PM] ', user:GetJobColor(), user:GetChatTag(), user:Name(), ': ', ui.col.White, net.ReadString()
	end)
	:Filter(function(a, d, e) 
		return {d, a} 
	end)

function PLAYER:IsTyping()
	return self:GetNetVar('IsTyping') == true
end

rp.AddCommand('pm', function(a, d, i)
	if a:IsChatMuted() then return end
	chat.Send('PM', a, d, i)
	d.LastPM = a
end)
:AddParam(cmd.PLAYER_ENTITY)
:AddParam(cmd.STRING)
-- :SetChatCommand()
-- :SetIgnoreImmunity(true)

rp.AddCommand('re', function(a, i)
	if a:IsChatMuted() then return end
	local d = a.LastPM
	if IsValid(d) then
		chat.Send('PM', a, d, i)
		d.LastPM = a
	else
		return NOTIFY_ERROR, term.Get('NoPMResponder')
	end
end)
:AddParam(cmd.STRING)
-- :SetChatCommand()
-- :SetIgnoreImmunity(true)

ba.cmd.Create('clearchat', function(pl)
    net.Start 'bad.Chat.Clear'
    net.Broadcast()
end)
:SetFlag('*')
:SetHelp('Clears the chatbox/console for everyone. Use with extreme caution!')

if SERVER then
    util.AddNetworkString 'bad.Chat.Clear'
else
    net('bad.Chat.Clear', function()
        CHATBOX:Remove()
        CHATBOX = ba.CreateChatBox()
    end)
end