-- "addons\\ba\\lua\\modules\\chatbox\\tags\\tags_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function chat.RequestChatTag(id)
    net.Start 'ba.Chat.SetTag'
        net.WriteString(id)
    net.SendToServer()
end

function chat.RequestClearChatTag()
    net.Start 'ba.Chat.ClearTag'
    net.SendToServer()
end