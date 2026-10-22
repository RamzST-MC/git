local function writemsg(pl, v)
	net.WritePlayer(pl)
	net.WriteString(v)
end

function encodeURI(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
			function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str
end
	
function decodeURI(s)
	if(s) then
		s = string.gsub(s, '%%(%x%x)', 
		function (hex) return string.char(tonumber(hex,16)) end )
	end
	return s
end

local function tts(txt, pl)
	pl.NextPlayTTS = pl.NextPlayTTS or 0
	if pl.NextPlayTTS and CurTime() > pl.NextPlayTTS then
		sound.PlayURL('https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=' .. encodeURI(txt) ..'&tl=ru','2d',function(station)
			if IsValid(station) then
				station:SetVolume(.5)
				station:Play()
				pl.NextPlayTTS = CurTime() + station:GetLength()
			end
		end)
	end
end

local function applyMsgtts(c, p, pl, msg)
	c = c or ''
	p = p or ''
	if IsValid(pl) then
		chat.EnableEmotes(pl:IsVIP())
		if pl:GetNWBool("GovorilkaHave") and system.HasFocus() then
			tts(msg, pl)
			return c, p, pl:GetChatTag(),  pl:GetJobColor(), pl:Name(), rp.col.White, ': ', msg
		else
			return c, p, pl:GetJobColor(), pl:Name(), rp.col.White, ': ', msg
		end
	else
		return c, p, rp.col.Gray, 'Unknown: ', rp.col.White, msg
	end
end


local function applyMsg(c, p, pl, msg)
	if #msg > 256 or msg:find("\n") then return end

	c = c or ''
	p = p or ''
	if IsValid(pl) then
		chat.EnableEmotes(pl:IsVIP())
		return c, p, pl:GetChatTag(), pl:GetJobColor(), pl:Name(), rp.col.White, ': ', msg
	else
		return c, p, rp.col.Gray, 'Unknown: ', rp.col.White, msg
	end
end

local function readmsgtts(c, p)
	c = c or ''
	p = p or ''
	local pl = net.ReadPlayer()
	local msg = net.ReadString()
	return applyMsgtts(c, p, pl, msg)
end

local function readmsg(c, p)
	c = c or ''
	p = p or ''
	local pl = net.ReadPlayer()
	local msg = net.ReadString()
	return applyMsg(c, p, pl, msg)
end

local function readBlockableMessage(c, p)
	c = c or ''
	p = p or ''

	local pl = net.ReadPlayer()
	if (not IsValid(pl)) then return end

	local msg = net.ReadString()
	return applyMsg(c, p, pl, msg)
end

local col = rp.col

chat.Register 'Local'
	:Write(writemsg)
	:Read(readmsgtts)
	:SetLocal(250)

chat.Register 'Whisper'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, '[Шепот] ')
	end)
	:SetLocal(90)

chat.Register 'Phone'
	:Write(writemsg)
	:Read(function()
		return readmsgtts(col.Red, '[Телефон] ')
	end)
	:Filter(function(pl)
		return table.Filter(player.GetAll(), function(v)
			return IsValid(v:GetNWEntity("TalkWith")) and IsValid(pl:GetNWEntity("TalkWith")) and (v:GetNWEntity("TalkWith") == pl) and (pl:GetNWEntity("TalkWith") == v)
		end)
	end)

chat.Register 'Yell'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, '[Крик] ')
	end)
	:SetLocal(600)

chat.Register 'Me'
	:Write(writemsg)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return pl:GetJobColor(), pl:Name() .. ' ' .. net.ReadString()
		end
	end)
	:SetLocal(250)

chat.Register 'Ad'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, '[Реклама] ')
	end)

chat.Register 'Dn'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Grey, '[ДаркНЕТ] ')
	end)

chat.Register 'Rb'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, '[Радиовещание] ')
	end)

chat.Register 'Radio'
	:Write(function(channel, pl, message)
		net.WriteUInt(channel, 8)
		writemsg(pl, message)
	end)
	:Read(function()
		return readmsg(col.Grey, '[Канал ' .. net.ReadUInt(8) .. '] ')
	end)
	:Filter(function(channel, pl, message)
		return table.Filter(player.GetAll(), function(v)
			return v.RadioChannel and (v.RadioChannel == pl.RadioChannel)
		end)
	end)

chat.Register 'Noo'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Yellow, '[911] ')
	end)

chat.Register 'Broadcast'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, '[Мэр Города] ')
	end)

chat.Register 'Org'
	:Write(function(pl, ...)
		net.WritePlayer(pl)
		writemsg(pl, ...)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			local color = pl:GetOrgColor() or ui.col.White
			local org = pl:GetOrg() or 'Unknown'
			chat.SetTab('[ORG]', '/o')
			return readBlockableMessage(color, '[' .. org .. '] ')
		end
	end)
	:Filter(function(pl, message)
		return table.Filter(player.GetAll(), function(v)
			if (v == pl) then return true end
			if (v:GetOrg() == pl:GetOrg()) then return true end

			return false
		end)
	end)

chat.Register 'Party'
	:Write(function(pl, ...)
		net.WritePlayer(pl)
		writemsg(pl, ...)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			local color = ui.col.White
			local party = pl:GetParty() or 'Unknown'
			chat.SetTab('[Party]', '/p')
			return readBlockableMessage(color, '[' .. party .. '] ')
		end
	end)
	:Filter(function(pl, message)
		return table.Filter(player.GetAll(), function(v)
			if (v == pl) then return true end
			if (v:GetParty() == pl:GetParty()) then return true end

			return false
		end)
	end)

local function testGroupChats(t1, t2)
	return rp.groupChats[t1] and rp.groupChats[t1][t2]
end
chat.Register 'Group'
	:Write(writemsg)
	:Read(function()
		local pref = '[Группа ]'

		local pl = net.ReadPlayer()
		local msg = net.ReadString()

		if (pl:GetNetVar('Employer') == LocalPlayer() or (LocalPlayer():GetNetVar('Employer') == pl)) then
			pref = '[Рабочий] '
		elseif (testGroupChats(LocalPlayer():GetJob(), pl:GetJob())) then
			pref = '[Группа] '
		elseif (testGroupChats(LocalPlayer():Team(), pl:Team())) then
			pref = '[Группа] '
		else
			if (pl == LocalPlayer()) then
				rp.Notify(NOTIFY_ERROR, 'Вы не состоите в групповом чате.')
				chat.AddText(col.Orange, '[Внимание] ', col.White, 'Вы не состоите в групповом чате.')
			end
			return
		end
		return applyMsg(col.Green, pref, pl, msg)
	end)
	:Filter(function(pl)
		return table.Filter(player.GetAll(), function(v)
			if (v == pl) then return true end
			if (v:GetNetVar('Employer') == pl or pl:GetNetVar('Employer') == v) then return true end
			if (testGroupChats(pl:GetJob(), v:GetJob())) then return true end
			if (testGroupChats(pl:GetJob(), v:Team())) then return true end

			return false
		end)
	end)
	
chat.Register 'OOC'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.OOC, '[OOC] ')
	end)

chat.Register 'Discord'
	:Write(writemsg)
	:Read(function()
		return readmsg(Color(114,137,218), '[Discord] ')
	end)

chat.Register 'LOOC'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.LOOC, '[Локальный чат] ')
	end)
	:SetLocal(250)

chat.Register 'Roll'
	:Write(function(pl, num)
		net.WritePlayer(pl)
		net.WriteUInt(num, 8)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, '[', col.Pink, 'Кубик', col.Red, '] ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'кинул и выпало ', col.Pink, tostring(net.ReadUInt(8)), col.White, ' из 100.'
		end
	end)
	:SetLocal(250)

chat.Register 'Dice'
	:Write(function(pl, num1, num2)
		net.WritePlayer(pl)
		net.WriteUInt(num1, 8)
		net.WriteUInt(num2, 8)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, '[', col.Pink, 'Кости', col.Red, '] ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'кинул и выпало ', col.Pink, tostring(net.ReadUInt(8)), col.White, ' и ', col.Pink, tostring(net.ReadUInt(8)), '.'
		end
	end)
	:SetLocal(250)

chat.Register 'Cards'
	:Write(function(pl, card)
		net.WritePlayer(pl)
		net.WriteString(card)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, '[', col.Pink, 'Карты', col.Red, '] ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'вытянул ', col.Pink, net.ReadString(), col.White, '.'
		end
	end)
	:SetLocal(250)

chat.Register 'Coin'
	:Write(function(pl, card)
		net.WritePlayer(pl)
		net.WriteString(card)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, '[', col.Pink, 'Монетка', col.Red, '] ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'подбросил и выпало ', col.Pink, net.ReadString(), col.White, '.'
		end
	end)
	:SetLocal(250)

	chat.Register 'Try'
	:Write(function(pl, try)
		net.WritePlayer(pl)
		net.WriteString(try)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			local luck = table.Random({"Удачно", "Неудачно"})
			return pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, net.ReadString(), col.Red, ' [', luck == "Удачно" and rp.col.OOC or col.Pink, luck, col.Red, ']'
		end
	end)
	:SetLocal(250)
	
chat.Register 'Do'
	:Write(function(pl, msg)
		net.WritePlayer(pl)
		net.WriteString(msg)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return Color(200, 115, 200), net.ReadString(), '. (', pl:Name(), ')'
		end
	end)
	:SetLocal(250)