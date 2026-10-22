term.Add('ChatTagCleared', 'Your chat tag has been cleared.')
term.Add('ChatTagUpdated', 'Your chat tag has been updated.')
term.Add('CannotSetChatTag', 'You need # hours more play time to use this chat tag!')
term.Add('CannotSetChatTagVIP', 'You must be VIP to set your chat tag!')

nw.Register 'ChatTag'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

function PLAYER:GetChatTag()
	local tag = hook.Call('PlayerOverrideChatTag', nil, self) or self:GetNetVar('ChatTag') or hook.Call('PlayerGetChatTag', nil, self)

	if tag and ba.chatEmotes[tag] and (SERVER or not cvar.GetValue('disable_emotes')) then
		return tag .. '  '
	end

	return ''
end