-- "addons\\ba\\lua\\modules\\chatbox\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
require 'texture'

cvar.Register 'ChatboxSize'

concommand.Add('chatbox_resetsize', function()
	cvar.SetValue('ChatboxSize', nil)
	if IsValid(CHATBOX) then
		CHATBOX:SetSize(chat.GetChatBoxSize(true))
		CHATBOX:SetPos(chat.GetChatBoxPos())
	end
	print('[Chatbox] Размер чата сброшен на стандартный.')
end)

cvar.Register 'pm_notify'
	:SetDefault(false)
	:AddMetadata('Category', 'Чат')
	:AddMetadata('Title', 'Private Message Sounds')
	:AddMetadata('Menu', 'Играть PM звуки')

cvar.Register 'disable_emotes'
	:SetDefault(false)
	:AddMetadata('Category', 'Чат')
	:AddMetadata('Title', 'Chat Emotes')
	:AddMetadata('Menu', 'Выключить эмоции')

chat.OldAddText = chat.OldAddText or chat.AddText
function chat.AddText(...)
	if IsValid(LocalPlayer()) then
		CHATBOX = CHATBOX or ba.CreateChatBox()

		CHATBOX:AddMessage({...})
	end

	return chat.OldAddText(...)
end

function chat.EnableEmotes(enable)
	if IsValid(CHATBOX) then
		CHATBOX.DoEmotes = enable
	end
end

function chat.SetResponseCommand(cmd)
	if IsValid(CHATBOX) then
		CHATBOX.ChatResponseCommand = cmd
	end
end

function chat.SetTab(tab, responseCommand)
	if IsValid(CHATBOX) then
		CHATBOX.PendingChatTab = tab
		CHATBOX.ChatResponseCommand = responseCommand
	end
end

function chat.AddTabbedText(tab, ...)
	if IsValid(LocalPlayer()) then
		CHATBOX = CHATBOX or ba.CreateChatBox()
		CHATBOX:AddTabbedMessage(tab, {...})
	end

	return chat.OldAddText(...)
end

function chat.GetChatBoxSize(setup)
	if setup or not IsValid(CHATBOX) then
		local saved = cvar.GetValue('ChatboxSize')

		if not saved then
			return ScrW() * .33, ScrH() * .3
		else
			return math.Clamp(saved[1], 265, ScrW() - 20), math.Clamp(saved[2], 155, ScrH() - 20)
		end
	end

	return CHATBOX:GetSize()
end

function chat.GetChatBoxPos(w, h)
	local _, _h = chat.GetChatBoxSize()
	h = h or _h

	return chat.GetChatBoxLeftBound(), chat.GetChatBoxBottomBound() - h
end

function chat.GetChatBoxLeftBound()
	return 20
end

-- на сколько пикселей нижний край чата поднят от низа экрана (было 280)
local CHAT_BOTTOM_OFFSET = 450

function chat.GetChatBoxBottomBound()
	return ScrH() - CHAT_BOTTOM_OFFSET
end

function chat.IsOpen()
	return IsValid(CHATBOX) and CHATBOX._Open
end

function chat.Say(msg, isGroup)
	net.Start('sayRaw')
		net.WriteBool(isGroup)
		net.WriteString(msg)
	net.SendToServer()
end

function PLAYER:ChatPrint(...)
	chat.AddText(...)
end

hook.Add('HUDShouldDraw', 'HideDefaultChat', function(name)
	if name == 'CHudChat' then return false end
end)

hook.Add('PlayerBindPress', 'OpenChatbox', function(p, q, r)
    if not r then return end
    CHATBOX = CHATBOX or ba.CreateChatBox()
	
    if string.find(q, 'messagemode2') then
        CHATBOX:Open(true)
        return true
    elseif string.find(q, 'messagemode') then
        CHATBOX:Open(false)
        return true
    end
end)

local function ToggleChat(bool)
	net.Start('ba.ToggleChat')
		net.WriteBool(bool)
	net.SendToServer()
end

hook.Add('StartChat', 'ba.chat.StartChat', function() ToggleChat(true) end)
hook.Add('FinishChat', 'ba.chat.FinishChat', function() ToggleChat(false) end)

hook.Add('ChatText', function(_, _, _, type)
	if type == 'joinleave' then return true end
end)