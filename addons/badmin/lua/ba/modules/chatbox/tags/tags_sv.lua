util.AddNetworkString("ba.chat.SetTag")
util.AddNetworkString("ba.chat.ClearTag")

net.Receive("ba.chat.SetTag", function(_,ply)
	if ply:IsVIP() or ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsRoot() then
		ply:SetNetVar("ChatTag",net.ReadString())
		ba.notify(ply, term.Get('ChatTagUpdated'))
	else
		ba.notify(ply, 'Вы должны быть VIP и выше чтобы использовать Эмодзи!')
	end
end)
net.Receive("ba.chat.ClearTag", function(_,ply)
	if ply:IsVIP() or ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsRoot() then
		ply:SetNetVar("ChatTag",'')
		ba.notify(ply, term.Get('ChatTagCleared'))
	else
		ba.notify(ply, 'Вы должны быть VIP и выше чтобы использовать Эмодзи!')
	end
end)